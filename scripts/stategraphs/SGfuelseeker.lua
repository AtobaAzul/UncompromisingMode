require("stategraphs/commonstates")

local events=
{
	EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and not inst.sg:HasStateTag("disappearing") then 
            inst.sg:GoToState("hit")  -- can't attack during hit reaction
        end 
    end),
    EventHandler("grab", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade")  and data and data.target  then 
        inst.sg:GoToState("grab", data.target) 
        end 
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("disappearing") and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("grabbing") and not inst.sg:HasStateTag("evade")  then
            
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("moving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),    
}

local function FinishExtendedSound(inst, soundid)
    inst.SoundEmitter:KillSound("sound_"..tostring(soundid))
    inst.sg.mem.soundcache[soundid] = nil
    if inst.sg.statemem.readytoremove and next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    end
end

local function PlayExtendedSound(inst, soundname)
    if inst.sg.mem.soundcache == nil then
        inst.sg.mem.soundcache = {}
        inst.sg.mem.soundid = 0
    else
        inst.sg.mem.soundid = inst.sg.mem.soundid + 1
    end
    inst.sg.mem.soundcache[inst.sg.mem.soundid] = true
    inst.SoundEmitter:PlaySound(inst.sounds[soundname], "sound_"..tostring(inst.sg.mem.soundid))
    inst:DoTaskInTime(5, FinishExtendedSound, inst.sg.mem.soundid)
end

local function OnAnimOverRemoveAfterSounds(inst)
    if inst.sg.mem.soundcache == nil or next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    else
        inst:Hide()
        inst.sg.statemem.readytoremove = true
    end
end

local function LightStealTarget(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 7)

	for i, v in ipairs(ents) do
		if v.components.burnable ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			--print("firefound")
			return true
		elseif v._light ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			--print("lightfound")
			return true
		elseif v._lastpulsesync ~= nil and v.components.timer and v.components.timer:GetTimeLeft("extinguish") then
			--print("starfound")
			return true
		end
	end
	
	return false
end

local function ConsumeLight(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 8)
	
	for i, v in ipairs(ents) do
		if v.components.burnable ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			v.components.fueled:DoDelta(-7)
			print("fire")
			
			SpawnPrefab("fuelseeker_circle").Transform:SetPosition(v.Transform:GetWorldPosition())
			
			if inst.fire ~= nil then
				inst.fire:LevelUp()
			end
		elseif v._light ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			v.components.fueled:DoDelta(-7)
			print("light")
			
			SpawnPrefab("fuelseeker_circle").Transform:SetPosition(v.Transform:GetWorldPosition())
			
			if inst.fire ~= nil then
				inst.fire:LevelUp()
			end
		elseif v._lastpulsesync ~= nil and v.components.timer then
			if v.components.timer:GetTimeLeft("extinguish") ~= nil then
				v.components.timer:SetTimeLeft("extinguish", v.components.timer:GetTimeLeft("extinguish") - 25)
				print("star")
				
				SpawnPrefab("fuelseeker_circle").Transform:SetPosition(v.Transform:GetWorldPosition())
				
				if inst.fire ~= nil then
					inst.fire:LevelUp()
				end
			end
		end
	end
end

local states=
{
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
			if inst.fire ~= nil then
				inst.fire:Hide()
			end
			inst:AddTag("INLIMBO")
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("disappear")
            inst.Physics:Stop()
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            
            RemovePhysicsColliders(inst)
            inst:AddTag("NOCLICK")
            inst.persists = false
        end,

        events=
        {
			EventHandler("animover", OnAnimOverRemoveAfterSounds),
        },
		
        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end
    }, 

    State{
        name = "appear",
        tags = {"idle", "canrotate", "disappearing"},
		
        onenter = function(inst)
			if inst.fire ~= nil then
				inst.fire:Show()
			end
			inst:RemoveTag("INLIMBO")
			inst.AnimState:PlayAnimation("appear")
            PlayExtendedSound(inst, "appear")
        end,
		
        events=
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle") 
			end),
        },
    },

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, start_anim)
            PlayExtendedSound(inst, "idle")
            
			inst.AnimState:PlayAnimation("idle", true)
        end,
        
		onupdate = function(inst)
			if LightStealTarget(inst) then
				inst.sg:GoToState("stealing_pre")
			end
		end,
        
        events=
        {
            EventHandler("animover", function(inst)
				--if LightStealTarget(inst) then
				--	inst.sg:GoToState("stealing_pre")
				--else
					inst.sg:GoToState("idle")
				--end
			end),
        },
    },

    State{
        name = "stealing_pre",
        tags = {"idle", "canrotate", "stealing", "busy"},
        
        onenter = function(inst, start_anim)
            inst.components.locomotor:StopMoving()
			
            PlayExtendedSound(inst, "idle")
            
			inst.AnimState:PlayAnimation("idle_stealing_pre")
            --inst.sg:SetTimeout(5)
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
				if LightStealTarget(inst) then
					inst.sg:GoToState("stealing")
				else
					inst.sg:GoToState("idle")
				end
			end),
        },
    },

    State{
        name = "stealing",
        tags = {"idle", "canrotate", "stealing", "busy"},
        
        onenter = function(inst, start_anim)
            inst.components.locomotor:StopMoving()
			if inst.consumetask == nil then
				inst.consumetask = inst:DoPeriodicTask(0.5, ConsumeLight)
			end
			
            PlayExtendedSound(inst, "attack_grunt")
            
			inst.AnimState:PlayAnimation("idle_stealing", true)
            --inst.sg:SetTimeout(5)
        end,
        
        onexit = function(inst)
			if inst.consumetask ~= nil then
				inst.consumetask:Cancel()
				inst.consumetask = nil
			end
		end,
		
        events=
        {
            EventHandler("animover", function(inst)
				if inst.fire ~= nil and inst.fire.level >= 3 then
					inst.sg:GoToState("burst")
				elseif LightStealTarget(inst) then
					inst.sg:GoToState("stealing")
				else
					inst.sg:GoToState("stealing_pst")
				end
			end),
        },
    },
	
    State{
        name = "burst",
        tags = {"idle", "canrotate", "attack", "stealing", "busy"},
        
        onenter = function(inst, start_anim)
            inst.components.locomotor:StopMoving()
		
            PlayExtendedSound(inst, "attack")
            
			inst.AnimState:PlayAnimation("burst")
            --inst.sg:SetTimeout(5)
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
				
				local x, y, z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 6, {"player"}, {"playerghost"})
				local explosive = SpawnPrefab("shadow_puff_solid")
				explosive.Transform:SetPosition(x, y, z)
				explosive.Transform:SetScale(4, 4, 4)
				
				for i, v in ipairs(ents) do
					v.components.combat:GetAttacked(inst, 50, nil)
				end
				
				
				if inst.fire ~= nil then
					inst.fire:Reset()
				end
				
				inst.sg:GoToState("idle")
			end),
        },
    },
	
    State{
        name = "stealing_pst",
        tags = {"idle", "canrotate", "stealing", "busy"},
        
        onenter = function(inst, start_anim)
            inst.components.locomotor:StopMoving()
		
            PlayExtendedSound(inst, "idle")
            
			inst.AnimState:PlayAnimation("idle_stealing_pst")
            --inst.sg:SetTimeout(5)
        end,
        
		onupdate = function(inst)
			if LightStealTarget(inst) then
				inst.sg:GoToState("stealing_pre")
			end
		end,
			
        events=
        {
            EventHandler("animover", function(inst)
				--if LightStealTarget(inst) then
				--	inst.sg:GoToState("stealing_pre")
			--	else
					inst.sg:GoToState("idle")
				--end
			end),
        },
    },
	
    State{
        name = "hit",
        tags = { "busy", "hit", "disappearing" },

        onenter = function(inst)
			if inst.fire ~= nil then
				inst.fire:Hide()
			end
		
			inst:AddTag("INLIMBO")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("disappear")
			PlayExtendedSound(inst, "death")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                local max_tries = 4
                for k = 1, max_tries do
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local offset = 10
                    x = x + math.random(2 * offset) - offset
                    z = z + math.random(2 * offset) - offset
                    if TheWorld.Map:IsPassableAtPoint(x, y, z) then
                        inst.Physics:Teleport(x, y, z)
                        break
                    end
                end

                inst.sg:GoToState("appear")
            end),
        },
    },
        

    State{
        name = "disappear",
        tags = {"busy", "disappearing"},
        
        onenter = function(inst)
			if inst.fire ~= nil then
				inst.fire:Hide()
			end
			inst:AddTag("INLIMBO")
            inst.AnimState:PlayAnimation("disappear")
			PlayExtendedSound(inst, "death")
			
			--[[if inst.shadowtask ~= nil then
				inst.shadowtask:Cancel()
				inst.shadowtask = nil
			end]]
			
			--inst.shadowtask = inst:DoPeriodicTask(0.1, shrinkshadow)
        end,
        
		timeline =
        {
            TimeEvent(55*FRAMES, function(inst)
				
				--inst.shadowtask = inst:DoPeriodicTask(0.1, shrinkshadow)
            end),
        },
		
        events=
        {
            EventHandler("animover", function(inst)
				if TheWorld.state.isday then
					OnAnimOverRemoveAfterSounds(inst)
					--inst:Remove()
				else
					inst.sg:GoToState("idle")
				end
			end),
        },

        onexit = function(inst)
			--[[if inst.shadowtask ~= nil then
				inst.shadowtask:Cancel()
				inst.shadowtask = nil
			end]]
        end,
    },

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("walk_loop", true)
        end,
        
		onupdate = function(inst)
			if LightStealTarget(inst) then
				inst.sg:GoToState("stealing_pre")
			end
		end,

        events =
        {
            EventHandler("animover", function(inst)
				--if LightStealTarget(inst) then
				--	inst.sg:GoToState("stealing_pre")
				--else
					inst.sg:GoToState("idle")
				--end
            end),
        },
    },
}

return StateGraph("fuelseeker", states, events, "appear")--, actionhandlers)


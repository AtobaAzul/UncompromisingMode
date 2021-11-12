require("stategraphs/commonstates")
--[[
local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "eat"),
    ActionHandler(ACTIONS.INVESTIGATE, "investigate"),
}]]

local events=
{
	--[[EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("no_stun") and not inst.sg:HasStateTag("attack") then 
            inst.sg:GoToState("hit")  -- can't attack during hit reaction
        end 
    end),]]
    EventHandler("grab", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade")  and data and data.target  then 
        inst.sg:GoToState("grab", data.target) 
        end 
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    
    
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("grabbing") and not inst.sg:HasStateTag("evade")  then
            
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("premoving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),    
}

local function Grabby(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 3, {"player"}, {"playerghost"})
	
	for i, v in ipairs(ents) do
	
		v.components.health:DoDelta(-40, false, inst.prefab, false, nil, inst, false)
		
		if v.components.health:IsDead() then
			v.Physics:Teleport(inst.Transform:GetWorldPosition())
		else 
			if not v:HasTag("wereplayer") then
				v.sg:GoToState("hit_weaver", inst)
			else
				v.sg:GoToState("hit", inst)
			end
		end
		
	end
	
	if #ents > 0 then
		return true
	end
	
	return false
end

local function growshadow(inst)
	if inst.shadowsize == nil then
		inst.shadowsize = 0
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	elseif inst.shadowsize ~= nil and inst.shadowsize < 5 then
		inst.shadowsize = inst.shadowsize + 0.25
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	else
		inst.shadowsize = 5
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	end
end

local function shrinkshadow(inst)
	if inst.shadowsize == nil then
		inst.shadowsize = 0
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	elseif inst.shadowsize ~= nil and inst.shadowsize > 1 then
		inst.shadowsize = inst.shadowsize - 0.25
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	else
		inst.shadowsize = 1
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	end
end

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

local states=
{
    State{
        name = "death",
        tags = { "busy", "grabbing" },

        onenter = function(inst)
			inst:AddTag("INLIMBO")
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("dead")
            inst.Physics:Stop()
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            
            RemovePhysicsColliders(inst)
            inst:AddTag("NOCLICK")
            inst.persists = false
			inst.DynamicShadow:Enable(false)
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
        tags = {"idle", "canrotate", "grabbing"},
		
        onenter = function(inst)
			inst:AddTag("INLIMBO")
			inst.AnimState:PlayAnimation("appear")
            inst.sg:SetTimeout(5)
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
			inst:Hide()
			inst:AddTag("INLIMBO")
            PlayExtendedSound(inst, "idle")
            
			inst.AnimState:PlayAnimation("idle_above", true)
            --inst.sg:SetTimeout(5)
        end,
		
		events =
        {
            EventHandler("animover", function(inst)
				if TheWorld.state.isday or TheWorld.state.iscaveday then
					OnAnimOverRemoveAfterSounds(inst)
					--inst:Remove()
				else
					inst.sg:GoToState("idle")
				end
			end),
        },
    },

    State{
        name = "grab",
        tags = {"busy", "canrotate", "grabbing"},
        
        onenter = function(inst, start_anim)
            inst.components.locomotor:StopMoving()
			inst:Show()
			inst:RemoveTag("INLIMBO")
			inst.AnimState:PlayAnimation("grab")
			PlayExtendedSound(inst, "taunt")
			--[[
			if inst.shadowtask ~= nil then
				inst.shadowtask:Cancel()
				inst.shadowtask = nil
			end
			
			inst.shadowtask = inst:DoPeriodicTask(0.1, growshadow)]]
        end,
		
		timeline =
        {
            TimeEvent(771*FRAMES, function(inst)
				--[[if inst.shadowtask ~= nil then
					inst.shadowtask:Cancel()
					inst.shadowtask = nil
				end]]
            end),
        },
		
		events =
        {
            EventHandler("animover", function(inst)
				if Grabby(inst) then
					inst.sg:GoToState("retreat") 
				else
					inst.sg:GoToState("idle_miss_yoinkey")
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
        name = "idle_grab",
        tags = {"idle", "canrotate", "grabbing"},
        
        onenter = function(inst, start_anim)
			inst:RemoveTag("INLIMBO")
			inst.AnimState:PlayAnimation("idle_grab", true)
            inst.sg:SetTimeout(0.4)
        end,
		
        ontimeout = function(inst)
            inst.sg:GoToState("retreat")
        end,
    },

    State{
        name = "idle_miss_yoinkey",
        tags = {"idle", "canrotate", "grabbing"},
        
        onenter = function(inst, start_anim)
			inst:RemoveTag("INLIMBO")
			inst.AnimState:PlayAnimation("idle_miss_yoinkey")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle_miss")
            end),
        },
    },

    State{
        name = "idle_miss",
        tags = {"idle", "canrotate", "grabbing"},
        
        onenter = function(inst, start_anim)
			inst:RemoveTag("INLIMBO")
			inst.AnimState:PlayAnimation("idle_miss", true)
            inst.sg:SetTimeout(2)
        end,
		
        ontimeout = function(inst)
            inst.sg:GoToState("retreat")
        end,
    },
        

    State{
        name = "retreat",
        tags = {"busy", "grabbing"},
        
        onenter = function(inst)
			inst:AddTag("INLIMBO")
            inst.AnimState:PlayAnimation("retreat")
			PlayExtendedSound(inst, "attack_grunt")
			
			inst.DynamicShadow:SetSize(0, 0)
			
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
				if TheWorld.state.isday or TheWorld.state.iscaveday then
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
        name = "premoving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
			inst:AddTag("INLIMBO")
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("idle_above")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("moving")
            end),
        },
    },

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
			inst:AddTag("INLIMBO")
            inst.components.locomotor:WalkForward()
            if not inst.AnimState:IsCurrentAnimation("idle_above") then
                inst.AnimState:PushAnimation("idle_above", true)
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("moving")
            end),
        },
    },
    
}

return StateGraph("mindweaver", states, events, "appear")--, actionhandlers)


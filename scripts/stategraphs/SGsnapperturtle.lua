require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local function IsSpeenDone(inst,data)
if data ~= nil and data.name == "speendone" and inst.sg:HasStateTag("speen") then
inst.sg:GoToState("speen_pst")
end
end

local function GetHome(inst)
    return inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
end

local function Splash(inst)
local x,y,z = inst.Transform:GetWorldPosition()
if not TheWorld.Map:IsAboveGroundAtPoint(x,y,z) then
	local splash = SpawnPrefab("splash")
	splash.Transform:SetPosition(x,y,z)
	splash.Transform:SetScale(2,1.5,2)
end
end

local events =
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),
	
    EventHandler("death", function(inst) inst.sg:GoToState("death", inst.sg.statemem.dead) end),
    EventHandler("doattack", function(inst, data) 
	if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
		if not (inst.components.timer == nil or inst.components.timer:TimerExists("dospin")) then
        inst.sg:GoToState("speen_pre", data.target)
		else
		inst.sg:GoToState("speen_pre",data.target)--"attack", data.target) 
		end
	end
	end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnHop(),
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnFreeze(),
    EventHandler("knockback", function(inst, data)
        if not inst.components.health:IsDead() then
                inst.sg:GoToState("knockback", data)
           
        end
    end),

}



local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, playanim)
            inst.SoundEmitter:PlaySound(inst.sounds.pant)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
            inst.sg:SetTimeout(2*math.random()+.5)
        end,
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
			if inst.components.timer == nil then
			inst:AddComponent("timer")
			inst.components.timer:StartTimer("dospin", TUNING.DEERCLOPS_ATTACK_PERIOD*2) --Placeholder time constant
			inst:ListenForEvent("timerdone", IsSpeenDone)
			end
        end,

        timeline =
        {

            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) if math.random() < .333 then inst.components.combat:SetTarget(nil) inst.sg:GoToState("taunt") else inst.sg:GoToState("idle", "atk_pst") end end),
        },
    },
    State{
        name = "speen_pre",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("spin_pre")
			if inst.components.timer == nil then
				inst:AddComponent("timer")
			end
			inst.components.timer:StartTimer("speendone", TUNING.DEERCLOPS_ATTACK_PERIOD)
			inst.components.locomotor.walkspeed = TUNING.HOUND_SPEED
			local x,y,z = inst.Transform:GetWorldPosition()
			MakeGhostPhysics(inst, .5, .5)
			inst.Transform:SetPosition(x,y,z)
        end,

        timeline =
        {

            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("speen_loop") end),
        },
    },

    State{
        name = "speen_loop",
        tags = { "attack", "busy" ,"speen"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.AnimState:PlayAnimation("spin_loop",true)
			inst.velx = 0
			inst.velz = 0
				if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
					inst.Transform:SetRotation(0)
				else
					inst.sg:GoToState("speen_pst")
				end
        end,

        timeline =
        {

            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
		onupdate = function(inst)
			--if inst.sg.statemem.move then
				if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
					inst:ForceFacePoint(inst.components.combat.target.Transform:GetWorldPosition())
					local theta = (inst.Transform:GetRotation()+90)*DEGREES
					inst.Transform:SetRotation(0)
					local oldvelx, oldvelz
					if inst.velx ~= nil then
						oldvelx = inst.velx
					else
						oldvelx = 0
					end
					if inst.velz ~= nil then
						oldvelz = inst.velz
					else
						oldvelz = 0
					end
					local dv = 0.75					
					local newvelx = oldvelx + dv * math.sin(theta)
					local newvelz = oldvelz + dv * math.cos(theta)
					inst.velx = newvelx
					inst.velz = newvelz
					
					inst.Physics:SetMotorVel(newvelx,0,newvelz)
					
					if inst.countersplash == nil then
						inst.countersplash = 1
					else
						inst.countersplash = inst.countersplash - 0.1
					end
					if inst.countersplash < 0 then
						Splash(inst)
						inst.countersplash = 1
					end
				else
					inst.sg:GoToState("speen_pst")
				end
		end,
    },
State{
        name = "speen_pst",
        tags = {"busy" },

        onenter = function(inst)
            inst.Physics:Stop()
			local x,y,z = inst.Transform:GetWorldPosition()
			MakeCharacterPhysics(inst, 10, .5)
			inst.Transform:SetPosition(x,y,z)
            inst.AnimState:PlayAnimation("spin_pst")
			inst.components.timer:StartTimer("dospin", TUNING.DEERCLOPS_ATTACK_PERIOD*2)
			inst.components.locomotor.walkspeed = TUNING.HOUND_SPEED/6
        end,

        timeline =
        {

            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    State{
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("eat_pre")
            inst.AnimState:PushAnimation("eat_loop", false)
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bite) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) if inst:PerformBufferedAction() then inst.components.combat:SetTarget(nil) inst.sg:GoToState("idle") else inst.sg:GoToState("idle", "atk_pst") end end),
        },
    },

    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
			if inst.components.timer == nil then
			inst:AddComponent("timer")
			inst.components.timer:StartTimer("dospin", TUNING.DEERCLOPS_ATTACK_PERIOD*2) --Placeholder time constant
			inst:ListenForEvent("timerdone", IsSpeenDone)
			end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst, norepeat)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("taunt")
                inst.sg.statemem.norepeat = norepeat
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bark) end),
            TimeEvent(24 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bark) end),
        },

        events =
        {
            EventHandler("animover", function(inst)
			inst.sg:GoToState("idle")
            end),
        },
    },
	
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst, reanimating)
            if reanimating then
                inst.AnimState:Pause()
            else
                inst.AnimState:PlayAnimation("death")
				--if inst.components.amphibiouscreature ~= nil and inst.components.amphibiouscreature.in_water then
		        --    inst.AnimState:PushAnimation("death_idle", true)
				--end			
            end
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.death)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,


		

        onexit = function(inst)
            if not inst:IsInLimbo() then
                inst.AnimState:Resume()
            end
        end,
    },

    State{
        name = "forcesleep",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("sleep_loop", true)
        end,
    },

    State{
        name = "knockback",
        tags = { "busy", "nopredict", "nomorph", "nodangle" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            inst.AnimState:PlayAnimation("smacked")

            if data ~= nil then
                if data.radius ~= nil and data.knocker ~= nil and data.knocker:IsValid() then
                    local x, y, z = data.knocker.Transform:GetWorldPosition()
                    local distsq = inst:GetDistanceSqToPoint(x, y, z)
                    local rangesq = data.radius * data.radius
                    local rot = inst.Transform:GetRotation()
                    local rot1 = distsq > 0 and inst:GetAngleToPoint(x, y, z) or data.knocker.Transform:GetRotation() + 180
                    local drot = math.abs(rot - rot1)
                    while drot > 180 do
                        drot = math.abs(drot - 360)
                    end
                    local k = distsq < rangesq and .3 * distsq / rangesq - 1 or -.7
                    inst.sg.statemem.speed = (data.strengthmult or 1) * 12 * k
                    inst.sg.statemem.dspeed = 0
                    if drot > 90 then
                        inst.sg.statemem.reverse = true
                        inst.Transform:SetRotation(rot1 + 180)
                        inst.Physics:SetMotorVel(-inst.sg.statemem.speed, 0, 0)
                    else
                        inst.Transform:SetRotation(rot1)
                        inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                    end
                end
            end
        end,

        onupdate = function(inst)
            if inst.sg.statemem.speed ~= nil then
                inst.sg.statemem.speed = inst.sg.statemem.speed + inst.sg.statemem.dspeed
                if inst.sg.statemem.speed < 0 then
                    inst.sg.statemem.dspeed = inst.sg.statemem.dspeed + .075
                    inst.Physics:SetMotorVel(inst.sg.statemem.reverse and -inst.sg.statemem.speed or inst.sg.statemem.speed, 0, 0)
                else
                    inst.sg.statemem.speed = nil
                    inst.sg.statemem.dspeed = nil
                    inst.Physics:Stop()
                end
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.speed ~= nil then
                inst.Physics:Stop()
            end
        end,
    },
}
CommonStates.AddAmphibiousCreatureHopStates(states, 
{ -- config
	swimming_clear_collision_frame = 9 * FRAMES,
},
{ -- anims
},
{ -- timeline
	hop_pre =
	{
		TimeEvent(0, function(inst) 
			if inst:HasTag("swimming") then 
				SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
			end
		end),
	},
	hop_pst = {
		TimeEvent(4 * FRAMES, function(inst) 
			if inst:HasTag("swimming") then 
				inst.components.locomotor:Stop()
				SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
			end
		end),
		TimeEvent(6 * FRAMES, function(inst) 
			if not inst:HasTag("swimming") then 
                inst.components.locomotor:StopMoving()
			end
		end),
	}
})

CommonStates.AddSleepStates(states,
{
    sleeptimeline =
    {
        TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end),
    },
})

CommonStates.AddFrozenStates(states)

CommonStates.AddWalkStates(states, nil, nil, nil, true)

return StateGraph("hound", states, events, "taunt", actionhandlers)

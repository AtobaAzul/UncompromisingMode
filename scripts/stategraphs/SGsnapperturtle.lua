require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events =
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death", inst.sg.statemem.dead) end),
    EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then inst.sg:GoToState("attack", data.target) end end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnHop(),
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnFreeze(),
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
            EventHandler("animqueueover", function(inst) if inst:PerformBufferedAction() then inst.components.combat:SetTarget(nil) inst.sg:GoToState("taunt") else inst.sg:GoToState("idle", "atk_pst") end end),
        },
    },

    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
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
                inst.AnimState:PlayAnimation("atk")
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
                if not inst.sg.statemem.norepeat and math.random() < .333 then
                    inst.sg:GoToState("taunt", inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("player"))
                else
                    inst.sg:GoToState("idle")
                end
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

CommonStates.AddRunStates(states,
{
    runtimeline =
    {
        TimeEvent(0, function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.growl)
            if inst:HasTag("swimming") then
                inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small",nil,.25)
            else
                PlayFootstep(inst) 
            end
        end),
        TimeEvent(4 * FRAMES, function(inst)
            if inst:HasTag("swimming") then
                inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small",nil,.25)
            else 
                PlayFootstep(inst)
            end
        end),
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("hound", states, events, "taunt", actionhandlers)

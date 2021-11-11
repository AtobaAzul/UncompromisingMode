require("stategraphs/commonstates")

local actionhandlers = 
{
}


local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
	EventHandler("doattack", function(inst, data) 
		if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then 
			if data.target:IsValid() then
				inst.sg:GoToState("playattack", data.target) 
			elseif data.target:IsValid() and inst:IsNear(data.target, 3) then
				inst.sg:GoToState("attack", data.target)
			end
		end 
	end),
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then
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
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(), 
}

local states=
{
	State {
		name = "idle",
		tags = { "idle", "canrotate" },
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			inst.AnimState:PushAnimation("idle_loop", true)
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.toottime == nil then
					inst.toottime = true
				end
				
				if inst.toottime then
					inst.sg:GoToState("toot")
				else
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State {
		name = "toot",
		tags = { "attack", "busy" },
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			inst.AnimState:PushAnimation("play")
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

	State{
		name = "playattack",
		tags = { "attack", "busy" },

		onenter = function(inst)
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("playatk")
		end,

		timeline =
		{
			TimeEvent(7 * FRAMES, function(inst)
				inst.components.combat:DoAttack()
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "attack",
		tags = { "attack", "busy" },

		onenter = function(inst)
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
		end,

		timeline =
		{
			TimeEvent(7 * FRAMES, function(inst)
				inst.components.combat:DoAttack()
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
			inst:AddTag("INLIMBO")
            inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("walk", true)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("moving")
            end),
        },
    },
}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
})

--[[
CommonStates.AddCombatStates(states,
{
    hittimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.hit) end),
    },
    deathtimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.death) end),
    },
})
]]
CommonStates.AddIdle(states)
CommonStates.AddFrozenStates(states)

    
return StateGraph("pied_rat", states, events, "idle", actionhandlers)
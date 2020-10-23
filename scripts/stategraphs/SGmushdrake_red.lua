require("stategraphs/commonstates")

local actionhandlers =
{
}

local events=
{
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	EventHandler("doattack", function(inst)
		if inst.components.health and not inst.components.health:IsDead()
			and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			inst.sg:GoToState("spin_pre")
		end
	end),
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnDeath(),
	EventHandler("locomote", function(inst)
		local is_moving = inst.sg:HasStateTag("moving")
		local is_idling = inst.sg:HasStateTag("idle")
		local is_spinning = inst.sg:HasStateTag("spinning")
		local should_move = inst.components.locomotor:WantsToMoveForward()

		if (is_moving and not should_move) or (is_spinning and not should_move) then
			if is_spinning then
				--Stop Moving
				inst.sg.statemem.move = false
			else
				inst.sg:GoToState("walk_stop")
			end
		elseif (is_idling or is_moving or is_spinning) and should_move then
			if is_spinning then
				--Start Moving
				inst.sg.statemem.move = true
			elseif not is_moving then
				inst.sg:GoToState("walk_start")
			end
		end
	end)
}

local function ShouldStopSpin(inst)
	local pos = inst:GetPosition()

	local nearby_player = FindClosestPlayerInRange(pos.x, pos.y, pos.z, 7.5, true)
	local time_out = inst.numSpins >= 10

	return not nearby_player or time_out
end

local states=
{

	State{

		name = "idle",
		tags = {"idle", "canrotate"},
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop")
		end,

		events=
		{
			EventHandler("animover", function(inst)
				if inst.components.combat.target then
					if math.random() < 0.25 then
						print("idle")
						inst.sg:GoToState("taunt")
						return
					end
				end
				inst.sg:GoToState("idle")
			end),
		},
},
	State{
		name = "taunt",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			print("taunt")
			inst.AnimState:PlayAnimation("taunt")
		end,

		timeline=
		{
			TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/flap") end),
			TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/taunt") end),
			TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/flap") end),
			TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/flap") end),
			TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/flap") end),
			TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/flap") end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "spin_pre",
		tags = {"busy"},

		onenter = function(inst)
			print("1")
			--inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk_pre")
			inst.components.burnable:Extinguish()
			inst.numSpins = 0
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("spin_loop") end),
		},

		timeline =
		{
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/attack") end),
		},
	},

	State{
		name = "spin_loop",
		tags = {"busy", "spinning"},

		onenter = function(inst)
			inst.DynamicShadow:SetSize(2.5,1.25)
			inst.components.sizetweener:StartTween(1.55, 2)

			inst.AnimState:PlayAnimation("atk_loop")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin", "spinLoop")

			local fx = SpawnPrefab("mossling_spin_fx")
			fx.entity:SetParent(inst.entity)
			fx.Transform:SetPosition(0,0.1,0)
			inst.components.burnable:Extinguish()
			inst.components.locomotor.walkspeed = TUNING.MOOSE_WALK_SPEED*2
		end,

		onupdate = function(inst)
			if inst.sg.statemem.move then
				inst.components.locomotor:WalkForward()
			else
				inst.components.locomotor:StopMoving()
			end
		end,

		onexit = function(inst)
			inst.SoundEmitter:KillSound("spinLoop")
			inst.components.locomotor:StopMoving()
			inst.components.locomotor.walkspeed = TUNING.MOOSE_WALK_SPEED/3
		end,

		timeline=
		{
			TimeEvent(0*FRAMES, function(inst) inst.components.combat:DoAttack() end),
			TimeEvent(35*FRAMES, function(inst) inst.components.combat:DoAttack() end),
			TimeEvent(70*FRAMES, function(inst) inst.components.combat:DoAttack() end),
		},

		events=
		{
			EventHandler("animover",
			function(inst)
				inst.numSpins = inst.numSpins + 1
				if ShouldStopSpin(inst) then
					inst.sg:GoToState("spin_pst")
				else
					inst.sg:GoToState("spin_loop")
				end
			end),
		},
	},

	State{
		name = "spin_pst",
		tags = {"busy"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("atk_pst")
		end,

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddFrozenStates(states)
CommonStates.AddWalkStates(states,
{
	walktimeline =
	{
		TimeEvent(FRAMES, function(inst) PlayFootstep(inst) end),
		TimeEvent(5*FRAMES, function(inst) PlayFootstep(inst) end),
		TimeEvent(10*FRAMES, function(inst) PlayFootstep(inst) end),
	}
})
CommonStates.AddCombatStates(states,
{
	attacktimeline =
	{
		TimeEvent(20*FRAMES, function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target, nil, nil, "electric")
		end),
		TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/attack") end),
		TimeEvent(22*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
	},

	deathtimeline =
	{
		TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/death") end)
	},
})
CommonStates.AddSleepStates(states,
{
	starttimeline =
	{
		TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/yawn") end)
	},
	sleeptimeline =
	{
		TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/sleep") end)
	},
	waketimeline =
	{
		TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/hatch") end)
	}
})

return StateGraph("mushdrake_red", states, events, "idle", actionhandlers)


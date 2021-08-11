require("stategraphs/commonstates")

local actionhandlers =
{
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.PICKUP, "steal"),
	ActionHandler(ACTIONS.HAMMER, "steal"),
	ActionHandler(ACTIONS.GOHOME, "hiding"),
}

local events =
{
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnAttack(),
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnLocomote(true, true),
	EventHandler("trapped", function(inst) inst.sg:GoToState("trapped") end),
	CommonHandlers.OnHop(),
}

local function play_carrat_scream(inst)
	inst.SoundEmitter:PlaySound(inst.sounds.scream)
end

local function Shake(inst)
	if inst.trashhome ~= nil and inst.sg:HasStateTag("hiding") then
		local trash = inst.trashhome 
		trash.Shake(trash)
	end
end

local states =
{
	State {
		name = "idle",
		tags = { "idle", "canrotate" },
		onenter = function(inst, playanim)
			inst.Physics:Stop()

			if playanim then
				inst.AnimState:PlayAnimation(playanim)
				inst.AnimState:PushAnimation("idle1", true)
			elseif not inst.AnimState:IsCurrentAnimation("idle1") then
				inst.AnimState:PlayAnimation("idle1", true)
			end
			inst.sg:SetTimeout(1 + math.random()*1)
		end,

		ontimeout= function(inst)
			if math.random() > 0.55 then
				inst.sg:GoToState("idle2")
			else
				inst.sg:GoToState("idle")
			end
		end,
	},

	State {
		name = "hiding",
		tags = { "hiding", "canrotate" },
		onenter = function(inst,data)
			inst:Hide()
			inst.Physics:SetActive(true)
			if inst.shaketask == nil then
				inst.shaketask = inst:DoPeriodicTask(3,Shake)
			end
		end,

		onexit = function(inst)
			inst.Physics:SetActive(true)
			inst:Show()
			inst.shaketask = nil
			inst.trashhome = nil
		end,
	},
	
	State {
		name = "idle2",
		tags = { "idle", "canrotate" },
		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle2", false)
		end,

		timeline =
		{
			TimeEvent(10*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.idle)
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
			inst.SoundEmitter:PlaySound(inst.sounds.eat)
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
	State {
		name = "eat",

		onenter = function(inst)
			inst:PerformBufferedAction()
			inst.Physics:SetActive(false)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pre", false)
			inst.AnimState:PushAnimation("eat_loop", false)
			inst.AnimState:PushAnimation("eat_pst", false)
		end,

		events =
		{
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("submerge")
				end
			end),
		},

		timeline =
		{
			TimeEvent(3*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.eat)
			end)
		},

		onexit = function(inst)
			inst.Physics:SetActive(true)
		end,
	},
}
CommonStates.AddSleepStates(states,
{
	sleeptimeline =
	{
		TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end),
	},
})
CommonStates.AddFrozenStates(states)
CommonStates.AddHitState(states)
CommonStates.AddDeathState(states,
{
	TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.death) end),
})
CommonStates.AddWalkStates(states)
CommonStates.AddRunStates(states,
{
	runtimeline =
	{
		TimeEvent(0, PlayFootstep),
	},
	endtimeline =
	{
		TimeEvent(0, PlayFootstep),
	},
})


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

return StateGraph("uncompromising_junkrat", states, events, "idle", actionhandlers)

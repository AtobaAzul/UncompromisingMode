require("stategraphs/commonstates")

local actionhandlers =
{
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.PICKUP, "steal"),
	ActionHandler(ACTIONS.RAT_STEAL_EQUIPPABLE, "chest_steal"),
	ActionHandler(ACTIONS.RAT_STEAL_GEM, "chest_steal"),
    ActionHandler(ACTIONS.CHECKTRAP, "destroy"),
    ActionHandler(ACTIONS.DIG, "plant_attack"),
    ActionHandler(ACTIONS.STORE, "deposit"),
}

local events =
{
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnAttack(),
    EventHandler("attacked", function(inst) 
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then 
			inst.sg:GoToState("hit") 
		end 
	end),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnLocomote(true, true),
	EventHandler("trapped", function(inst) inst.sg:GoToState("trapped") end),
	CommonHandlers.OnHop(),
}

local function play_carrat_scream(inst)
	inst.SoundEmitter:PlaySound(inst.sounds.scream)
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
			local scoutratvalue = inst.prefab == "uncompromising_scoutrat" and 120 or 0
		
			if (inst.components.inventory:NumItems() ~= 0 or inst.prefab == "uncompromising_packrat" or inst.components.health:GetPercent() < 1) and inst.components.herdmember and inst.components.herdmember:GetHerd() and inst.components.herdmember:GetHerd():HasTag("ratburrow") and ((inst.sg.mem.emerge_time or 0) + (TUNING.CARRAT.EMERGED_TIME_LIMIT + scoutratvalue) / 2.5) < GetTime() then
				inst.sg:GoToState("submerge")
			elseif math.random() > 0.55 then
				inst.sg:GoToState("idle2")
			else
				inst.sg:GoToState("idle")
			end
		end,
	},

    State{
        name = "hit",
        tags = { "busy", "hit" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound(inst.sounds.hit)
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
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

	State{
		name = "destroy",
		tags = { "attack", "busy" },

		onenter = function(inst)
			inst.SoundEmitter:PlaySound(inst.sounds.eat)
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pre")
		end,

		timeline =
		{
			TimeEvent(3 * FRAMES, function(inst)
				local buffaction = inst:GetBufferedAction()
				local target = buffaction ~= nil and buffaction.target or nil
				
				if target ~= nil and target:HasTag("trap") then
					if target.components.finiteuses ~= nil then
						target.components.finiteuses:Use(1)
						SpawnPrefab("yellow_leaves_chop").Transform:SetPosition(target.Transform:GetWorldPosition())
						inst.SoundEmitter:PlaySound("dontstarve/common/trap_rustle")
					else
						SpawnPrefab("yellow_leaves_chop").Transform:SetPosition(target.Transform:GetWorldPosition())
						target.components.trap:Harvest()
						inst.SoundEmitter:PlaySound("dontstarve/common/trap_rustle")
						target:Remove()
					end
				end
			
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst:ClearBufferedAction()
				inst.sg:GoToState("idle")
			end),
		},
	},
	
    State{
        name = "plant_attack",
        tags = {"busy"},

		onenter = function(inst)
			inst.Physics:SetActive(false)
            inst.sg.statemem.action = inst:GetBufferedAction()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pre")
			inst.AnimState:PushAnimation("eat_pst", false)
			
			if inst.plantdig ~= nil then
				inst.plantdig = inst.plantdig + 1
			else
				inst.plantdig = 1
			end
			
			inst:DoTaskInTime(0.5, function(inst)
				if inst.sg.statemem.action ~= nil and inst.sg.statemem.action.target ~= nil and inst.sg.statemem.action.target.Transform ~= nil and inst.sg.statemem.action.target.Transform:GetWorldPosition() ~= nil then
					inst.SoundEmitter:PlaySound(inst.sounds.eat)
					local dirt = SpawnPrefab("shovel_dirt")
					dirt.Transform:SetScale(0.8, 0.8, 0.8)
					dirt.Transform:SetPosition(inst.sg.statemem.action.target.Transform:GetWorldPosition())
						
					if inst.plantdig ~= nil and inst.plantdig > 4 then
						inst:PerformBufferedAction()
					end
				end
			end)
		end,
		
		onexit = function(inst)
			inst.Physics:SetActive(true)
		end,
		
		events=
		{
			EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.sg.statemem.action ~= nil and inst.sg.statemem.action.target ~= nil and not GetClosestInstWithTag("scarytoprey", inst, 3) then
					if inst.plantdig ~= nil and inst.plantdig > 4 then
						inst.plantdig = 1
						inst.sg:GoToState("idle")
					else
						inst.sg:GoToState("plant_attack")
					end
				else
					inst.plantdig = 1
					inst.sg:GoToState("idle")
                end
			end),
		}, 		
	}, 
	
	State {
		name = "submerge",
		tags = { "busy", "noattack" },

		onenter = function(inst)
			if not inst:IsOnValidGround() then
				inst.sg:GoToState("idle")
				return
			end

			if inst.components.locomotor ~= nil then
				inst.components.locomotor:StopMoving()
			end
			inst.Physics:Stop()
			inst.Physics:SetActive(false)
			inst.Transform:SetNoFaced()
			if inst._item ~= nil then
				inst._item:Remove()
			end
			inst.AnimState:PlayAnimation("submerge")
			if inst.components.inventory:NumItems() ~= 0 then
				local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
				if herd ~= nil and herd.components.inventory ~= nil then
					for k,v in pairs(inst.components.inventory.itemslots) do
						herd.components.inventory:GiveItem(inst.components.inventory:RemoveItemBySlot(k))
					end
				else
					inst.components.inventory:DropEverything()
				end
			end
		end,

		timeline =
		{
			TimeEvent(5*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.submerge)
			end),
			TimeEvent(30*FRAMES, function(inst)
				inst.DynamicShadow:Enable(false)
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("submerged")
			end),
		},

		onexit = function(inst)
			inst.Physics:SetActive(true)
			inst.Transform:SetSixFaced()
		end,
	},

	State {
		name = "submerged",
		tags = { "busy", "noattack" },

		onenter = function(inst, playanim)
			inst.Physics:SetActive(false)
			inst.Transform:SetNoFaced()
			inst:Remove()
		end,

		onexit = function(inst)
			inst.Physics:SetActive(true)
			inst.Transform:SetSixFaced()
		end,
	},
	
	State{
		name = "deposit",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pre", false)
			
			if inst.components.inventory:NumItems() ~= 0 then
				
				local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
				if herd ~= nil and not herd.components.inventory:IsFull() then
					if inst._item ~= nil then
						inst._item:Remove()
					end
					
					for k,v in pairs(inst.components.inventory.itemslots) do
						herd.components.inventory:GiveItem(inst.components.inventory:RemoveItemBySlot(k))
					end
				end
			end
		end,
		
		timeline=
		{
			
			TimeEvent(3*FRAMES, function(inst)
				inst:ClearBufferedAction() 
			end),
			TimeEvent(3*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.eat)
			end)
		},
		
		
		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		}, 		
	}, 

	State {
		name = "emerge_fast",
		tags = { "busy", "noattack" },

		onenter = function(inst)
			inst.Physics:SetActive(false)
			inst.AnimState:PlayAnimation("emerge_fast")

			inst.sg.mem.emerge_time = GetTime()
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},

		timeline =
		{
			TimeEvent(0, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.emerge)
			end),
			TimeEvent(5*FRAMES, function(inst)
				inst.DynamicShadow:Enable(true)
			end),
		},

		onexit = function(inst)
			inst.Physics:SetActive(true)
		end,
	},
	
	State{
		name = "eat",
		tags = {"busy"},

		onenter = function(inst)
			inst:PerformBufferedAction() 
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pre", false)
			inst.AnimState:PushAnimation("eat_loop", false)
			inst.AnimState:PushAnimation("eat_pst", false)
		end,
		
		timeline=
		{
			TimeEvent(3*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.eat)
			end)
		},
		
		
		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		}, 		
	}, 

	State{
		name = "steal",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pre", false)
			inst.AnimState:PushAnimation("eat_pst", false)
		end,
		
		timeline=
		{
			
			TimeEvent(3*FRAMES, function(inst)
				if not inst:HasTag("packrat") then
					inst.components.inventory:DropEverything()
				end

				inst:PerformBufferedAction() 
			end),
			TimeEvent(3*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.eat)
			end)
		},
		
		
		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		}, 		
	}, 

	State{
		name = "chest_steal",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pre", false)
			inst.AnimState:PushAnimation("eat_pst", false)
		end,
		
		timeline=
		{
			
			TimeEvent(3*FRAMES, function(inst)
				inst:PerformBufferedAction() 
			end),
			TimeEvent(3*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.eat)
			end)
		},
		
		
		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		}, 		
	}, 

	State {
		name = "stunned",
		tags = { "busy", "stunned" },

		onenter = function(inst, dont_play_sound)
			inst.Physics:Stop()
			if not dont_play_sound then
				inst.SoundEmitter:PlaySound(inst.sounds.stunned)
			end
			inst.AnimState:PlayAnimation("stunned_loop", true)
			inst.sg:SetTimeout(GetRandomWithVariance(6, 2))
			if inst.components.inventoryitem then
				inst.components.inventoryitem.canbepickedup = false
			end
		end,

		onexit = function(inst)
			if inst.components.inventoryitem then
				inst.components.inventoryitem.canbepickedup = false
			end
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle", "stunned_pst")
		end,
	},

	State {
		name = "trapped",
		tags = { "busy", "trapped" },
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("stunned_loop", true)
			inst.sg:SetTimeout(1)
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("idle")
		end,
	},

	State {
		name = "dug_up",
		tags = { "busy", "stunned" },

		onenter = function(inst)
			inst.SoundEmitter:PlaySound(inst.sounds.stunned)
			inst.AnimState:PlayAnimation("stunned_pre")
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("stunned", true)
				end
			end),
		},

		timeline =
		{
			TimeEvent(5*FRAMES, function(inst)
				inst.DynamicShadow:Enable(true)
			end),
		},
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
	starttimeline =
	{
		TimeEvent(0, function(inst)
			if (inst.components.inventoryitem == nil or inst.components.inventoryitem.owner == nil) then
				inst.SoundEmitter:PlaySound(inst.sounds.stunned)
			end
		end),
	},
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

return StateGraph("uncompromising_rat", states, events, "emerge_fast", actionhandlers)

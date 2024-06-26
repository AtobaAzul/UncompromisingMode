local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("SGcritter_puppy", function(inst)

local actionhandlers =
{
	ActionHandler(ACTIONS.PICKUP,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "woby_pickup"
			end
        end),
	ActionHandler(ACTIONS.PICK,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "woby_pickup"
			end
        end),
	ActionHandler(ACTIONS.HARVEST,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "woby_pickup"
			end
        end),
	ActionHandler(ACTIONS.WOBY_BARK,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "bark_at"
			end
        end)
}

local events =
{
	EventHandler("attacked", function(inst)
        if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("hit") -- can still attack
        end
    end)
}

local states = {

	State{
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end

            inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/bark")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

	State{
		name = "woby_pickup",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()

            inst.AnimState:PlayAnimation("emote_nuzzle")
		end,

		timeline =
		{
			TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/emote_scratch") end),
			TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/pant") end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/emote_scratch") end),
			TimeEvent(36*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/pant") end),

			TimeEvent(9*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/pant")
				inst:PerformBufferedAction()

				local x, y, z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 15, nil, { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung", "mineactive" })

				inst.sg:RemoveStateTag("busy")

				if inst.wobytarget ~= nil then
					inst.oldwobytarget = inst.wobytarget
					inst.wobytarget = nil
				end

				for i, v in ipairs(ents) do
					if inst.wobytarget ~= nil or inst.components.hunger:GetPercent() == 0 then
						break
					end

					if v ~= nil and not v:HasTag("INLIMBO") and inst.oldwobytarget ~= nil and v ~= inst.oldwobytarget and v.prefab == inst.oldwobytarget.prefab and v:IsValid() then
						if v.components.pickable == nil and v.components.harvestable == nil or v.components.pickable ~= nil and v.components.pickable.canbepicked and v.components.pickable.caninteractwith or v.components.harvestable ~= nil and v.components.harvestable:CanBeHarvested() and v.components.combat == nil then
							if v.components.inventoryitem then
								for k = 1, inst.components.container.numslots do
									if inst.components.container:GetItemInSlot(k) ~= nil and inst.components.container:GetItemInSlot(k).prefab == v.prefab and inst.components.container:GetItemInSlot(k).components.stackable ~= nil and not inst.components.container:GetItemInSlot(k).components.stackable:IsFull() then
										inst.wobytarget = v
										break
									elseif not inst.components.container:IsFull() then
										inst.wobytarget = v
										break
									end
								end
							else
								inst.wobytarget = v
								break
							end
						end
					end
				end

                if inst.brain ~= nil then
                    inst.brain:ForceUpdate()
                end
			end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
		}
	},

	State{
        name = "woby_does_a_flip",
		tags = {"busy"},

        onenter = function(inst)
			inst.AnimState:PlayAnimation("woby_does_a_flip")
            inst.components.locomotor:StopMoving()
        end,

		timeline =
		{
			TimeEvent(9*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/bark")
				inst:ClearBufferedAction()
				--inst.wobytarget = nil
				--inst.oldwobytarget = nil
			end),
		},

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

	State{
        name = "bark_at",
		tags = {"busy"},

        onenter = function(inst)
			inst.AnimState:PlayAnimation("emote_combat_pre")
			inst.components.locomotor:StopMoving()
        end,

		timeline =
		{
			TimeEvent(9*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/bark")
				inst:PerformBufferedAction()
				--inst.wobytarget = nil
				--inst.oldwobytarget = nil
			end),
		},

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("bark_at_pst") end ),
        },
    },

	State{
        name = "bark_clearaction",
        tags = { "busy" },
        onenter = function(inst)
			inst.AnimState:PlayAnimation("emote_combat_pre")
            inst.components.locomotor:StopMoving()
        end,

        timeline =
		{
			TimeEvent(9*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/bark")
				inst:ClearBufferedAction()
				--inst.wobytarget = nil
				--inst.oldwobytarget = nil
			end),
		},

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("bark_at_pst") end ),
        },
    },

	State{
        name = "bark_at_pst",
		tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("emote_combat_pst")
        end,

        events =
		{
			EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end)
		},
    },
}

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end


for k, v in pairs(actionhandlers) do
    assert(v:is_a(ActionHandler), "Non-action added in mod state table!")
    inst.actionhandlers[v.action] = v
end

end)

env.AddStategraphPostInit("wobybig", function(inst)

local actionhandlers =
{
	ActionHandler(ACTIONS.PICKUP,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "woby_pickup"
			end
        end),
	ActionHandler(ACTIONS.PICK,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				if action.target ~= nil and action.target:HasTag("snowpile_basic") then
					return "woby_dig"
				else
					return "woby_pickup"
				end
			end
        end),
	ActionHandler(ACTIONS.HARVEST,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "woby_pickup"
			end
        end),
	ActionHandler(ACTIONS.DIG,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "woby_dig"
			end
        end),
	ActionHandler(ACTIONS.WOBY_BARK,
        function(inst, action)
			if inst.sg.currentstate.name ~= "transform" then
				return "bark_at"
			end
        end)
}

local events =
{
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),

	EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("hit") -- can still attack
        end
    end)
}

local states = {

	State{
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end

            inst.AnimState:PlayAnimation("hit_woby")
			inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/wimper")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("cower") end ),
        },
    },

	State{
		name = "woby_pickup",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()

            inst.AnimState:PlayAnimation("command")
		end,

		timeline =
		{
			TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/emote_scratch") end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/emote_scratch") end),
			TimeEvent(9*FRAMES, function(inst)
				inst:PerformBufferedAction()

				local x, y, z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, 17, nil, { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung", "mineactive" })

				inst.sg:RemoveStateTag("busy")

				if inst.wobytarget ~= nil then
					if inst.wobytarget:HasTag("snowpile") then
						inst.components.hunger:DoDelta(-3)
						inst.SoundEmitter:PlaySound("wixie/characters/wixie/woby_hunger")
					end

					inst.oldwobytarget = inst.wobytarget
					inst.wobytarget = nil
				end

				for i, v in ipairs(ents) do
					if inst.wobytarget ~= nil or inst.components.hunger:GetPercent() == 0 then
						break
					end

					if v ~= nil and not v:HasTag("INLIMBO") and inst.oldwobytarget ~= nil and v ~= inst.oldwobytarget and v.prefab == inst.oldwobytarget.prefab and v:IsValid() then
						if v.components.pickable == nil and v.components.harvestable == nil or v.components.pickable ~= nil and v.components.pickable.canbepicked and v.components.pickable.caninteractwith or v.components.harvestable ~= nil and v.components.harvestable:CanBeHarvested() and v.components.combat == nil then
							if v.components.inventoryitem then
								for k = 1, inst.components.container.numslots do
									if inst.components.container:GetItemInSlot(k) ~= nil and inst.components.container:GetItemInSlot(k).prefab == v.prefab and inst.components.container:GetItemInSlot(k).components.stackable ~= nil and not inst.components.container:GetItemInSlot(k).components.stackable:IsFull() then
										inst.wobytarget = v
										break
									elseif not inst.components.container:IsFull() then
										inst.wobytarget = v
										break
									end
								end
							else
								inst.wobytarget = v
								break
							end
						end
					end
				end

                if inst.brain ~= nil then
                    inst.brain:ForceUpdate()
                end
			end),
		},

		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
		}
	},

	State{
		name = "woby_dig",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()

            inst.AnimState:PlayAnimation("command")
		end,

		timeline =
		{
			TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/emote_scratch") end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/emote_scratch") end),
			TimeEvent(9*FRAMES, function(inst)

				inst:PerformBufferedAction()
				inst.sg:RemoveStateTag("busy")

				if inst.wobytarget ~= nil then
					local stump_or_pile = inst.wobytarget:HasTag("stump") and "stump" or inst.wobytarget:HasTag("snowpile_basic") and "snowpile_basic" or nil
				
					if stump_or_pile ~= nil then
						inst.components.hunger:DoDelta(stump_or_pile == "snowpile_basic" and -5 or -1)
						inst.SoundEmitter:PlaySound("wixie/characters/wixie/woby_hunger")
						inst.oldwobytarget = inst.wobytarget
						inst.wobytarget = nil

						local x, y, z = inst.Transform:GetWorldPosition()
						local ents = TheSim:FindEntities(x, y, z, 17, nil, { "INLIMBO", "NOCLICK" }, { stump_or_pile })
						for i, v in ipairs(ents) do
							if inst.wobytarget ~= nil or inst.components.hunger:GetPercent() == 0 then
								break
							end

							if v ~= nil and v:IsValid() and not v:HasTag("INLIMBO") and inst.oldwobytarget ~= nil and inst.oldwobytarget:HasTag(stump_or_pile) and v ~= inst.oldwobytarget then
								inst.wobytarget = v
								break
							end
						end
					else
						inst.components.hunger:DoDelta(-1)
						inst.SoundEmitter:PlaySound("wixie/characters/wixie/woby_hunger")
						inst.oldwobytarget = nil
						inst.wobytarget = nil

					end

				end

                if inst.brain ~= nil then
                    inst.brain:ForceUpdate()
                end
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		}
	},

	State{
        name = "bark_at",
        tags = { "busy", "canrotate" },
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("bark1_woby", false)
        end,

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/bark")
				inst:PerformBufferedAction()
			end),
        },

        events=
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
        },
    },

	State{
        name = "bark_clearaction",
        tags = { "busy" },
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
			inst.AnimState:PlayAnimation("bark1_woby", false)
        end,

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/bark")
				inst:ClearBufferedAction()
				--inst.wobytarget = nil
				--inst.oldwobytarget = nil
			end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end


for k, v in pairs(actionhandlers) do
    assert(v:is_a(ActionHandler), "Non-action added in mod state table!")
    inst.actionhandlers[v.action] = v
end

end)
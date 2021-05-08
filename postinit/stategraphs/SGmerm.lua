local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("merm", function(inst)

local events =
{	

	EventHandler("attacked", function(inst)
		
		if inst.components.health ~= nil and not inst.components.health:IsDead() then
			if inst.counter ~= nil and inst.counter >= 3 then
				inst.counter = 0
				inst.sg:GoToState("karate_pre")
				return
			else
				if inst.counter ~= nil then
					inst.counter = inst.counter + 1
					if inst.countertask ~= nil then
						inst.countertask:Cancel()
						inst.countertask = nil
					end
					inst.countertask = inst:DoTaskInTime(10, function(inst) inst.counter = 0 end)
				else
					inst.counter = 0
				end
			end
		end
	
		if inst.components.health ~= nil and not inst.components.health:IsDead()
		and (not inst.sg:HasStateTag("busy") or
		inst.sg:HasStateTag("caninterrupt") or
		inst.sg:HasStateTag("frozen")) then
			inst.sg:GoToState("hit")
		end
	
	end),
}

local states = {
	State{
        name = "karate_pre",
        tags = { "attack", "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/merm/attack")
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.sg:SetTimeout(0.5)
            inst.AnimState:PlayAnimation("idle_angry")
        end,

        ontimeout= function(inst)
            inst.sg:GoToState("karate")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("karate")
            end),
        },
    },
    State{
        name = "karate",
        tags = { "attack", "busy" },

        onenter = function(inst)
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk_combo")
        end,

        timeline =
        {
            TimeEvent(12 * FRAMES, function(inst)
                inst.components.combat:DoAttack()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            end),
            TimeEvent(18 * FRAMES, function(inst)
                inst.components.combat:DoAttack()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            end),
            TimeEvent(31 * FRAMES, function(inst)
                inst.components.combat:DoAttack()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
            end),
            TimeEvent(43 * FRAMES, function(inst)
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
    
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)
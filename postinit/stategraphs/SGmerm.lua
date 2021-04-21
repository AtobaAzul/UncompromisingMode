local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("merm", function(inst)

local events =
{	
    EventHandler("doattack", function(inst, data) 
            inst.sg:GoToState("attack", data.target)
    end),   
}

local states = {
    State{
        name = "attack",
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
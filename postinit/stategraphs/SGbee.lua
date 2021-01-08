require("stategraphs/commonstates")
local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("bee", function(inst)
local events =
{
    EventHandler("doattack", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("attack")
        end
    end),
}
local states =
{

    State{
        name = "attack",
        tags = { "attack" },

        onenter = function(inst, cb)
            inst.components.locomotor:WalkForward()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(inst.sounds.attack)
            end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.components.combat:DoAttack()
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

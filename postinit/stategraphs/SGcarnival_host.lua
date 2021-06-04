local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddStategraphPostInit("carnival_host", function(inst)
local events =
{	
    EventHandler("death", function(inst)
        inst.sg:GoToState("death")
    end)
}

local states =
{
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("summerevent/characters/corvus/speak_1_shot")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            if inst.components.lootdropper ~= nil then
                inst.components.lootdropper:DropLoot(inst:GetPosition())
            end
        end,
    }
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
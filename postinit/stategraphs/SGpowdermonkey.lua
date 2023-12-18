local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("powdermonkey", function(inst)
    local states = {
        State {

            name = "action",
            tags = { "busy", "action", "caninterrupt" },
            onenter = function(inst, playanim)
                if inst:GetBufferedAction().target and inst:GetBufferedAction().target.components.boatcannon then
                    local cannon = inst:GetBufferedAction().target
                    cannon.components.timer:StartTimer("monkey_biz", 4)
                    if not cannon.components.boatcannon:IsAmmoLoaded() then
                        cannon.components.boatcannon:LoadAmmo((math.random() > 0.66 and "cannonball_sludge" or "cannonball_rock"))
                    end
                end
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("action_pre")
                inst.AnimState:PushAnimation("action", false)
                -- inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            end,

            onexit = function(inst)
            end,

            timeline =
            {
                TimeEvent(6 * FRAMES, function(inst)
                    if inst:GetBufferedAction() and inst:GetBufferedAction().target and inst:GetBufferedAction().target.components.boatcannon then
                        if inst.cannon then inst.cannon.operator = nil end
                        inst.cannon = nil
                    end

                    inst.ClearTinkerTarget(inst)
                    inst:PerformBufferedAction()
                end),
            },

            events =
            {
                EventHandler("animqueueover", function(inst)
                    inst.sg:GoToState("idle")
                end),
            }
        }
    }


    for k, v in pairs(states) do
        assert(v:is_a(State), "Non-state added in mod state table!")
        inst.states[v.name] = v
    end
end)

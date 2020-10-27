local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddStategraphState("stalker_minion",
    State{
        name = "emerge_noburst",
        tags = { "busy", "noattack" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("spawn")
            inst.DynamicShadow:Enable(false)
            inst.sg:SetTimeout(inst.emergeimmunetime)
        end,

        ontimeout = function(inst)
            inst.sg.statemem.emerging = true
            inst.sg:GoToState("emerge2")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.emerging then
                inst.DynamicShadow:Enable(true)
            end
        end,
    }
)
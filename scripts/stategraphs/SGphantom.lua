require("stategraphs/commonstates")

local function startaura(inst)
    inst.Light:SetColour(255/255, 32/255, 32/255)
    inst.SoundEmitter:PlaySound(inst:HasTag("girl") and "dontstarve/ghost/ghost_girl_attack_LP" or "dontstarve/ghost/ghost_attack_LP", "angry")
    inst.AnimState:SetMultColour(207/255, 92/255, 92/255, 1)
end

local function stopaura(inst)
    inst.Light:SetColour(180/255, 195/255, 225/255)
    inst.SoundEmitter:KillSound("angry")
    inst.AnimState:SetMultColour(1, 1, 1, 1)
end

local events =
{
    --CommonHandlers.OnLocomote(true, true),
    EventHandler("startaura", startaura),
    EventHandler("stopaura", stopaura),
    EventHandler("attacked", function(inst)
        if not (inst.sg:HasStateTag("jumping") or inst.components.health:IsDead()) and not CommonHandlers.HitRecoveryDelay(inst) then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("knockback", function(inst, data)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("knockback", data)
        end
    end),
    EventHandler("death", function(inst)
        inst.sg:GoToState("dissipate")
    end),
    EventHandler("locomote", function(inst)
		if not inst.sg:HasStateTag("busy") then
			inst.sg:GoToState("lurk")
		end
        --[[if not inst.sg:HasStateTag("busy") and inst.circling == false then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("premoving")
                elseif not is_moving then
                    inst.sg:GoToState("idle")
                end
            end
        end]]
    end), 
}

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate", "canslide" },

        onenter = function(inst)
            if inst.sg.mem.queuelevelchange then
                inst.sg:GoToState("idle")
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end,
    },

    State{
        name = "appear",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle")
            inst.SoundEmitter:PlaySound(inst:HasTag("girl") and "dontstarve/ghost/ghost_girl_howl" or "dontstarve/ghost/ghost_howl")
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
            inst.components.aura:Enable(true)
        end,
    },

    State{
        name = "hit",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound(inst:HasTag("girl") and "dontstarve/ghost/ghost_girl_howl" or "dontstarve/ghost/ghost_howl")
            inst.AnimState:PlayAnimation("idle")
            inst.Physics:Stop()
			CommonHandlers.UpdateHitRecoveryDelay(inst)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },


    State{
        name = "dissipate",
        tags = { "busy", "noattack", "nointerrupt" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle")--inst.AnimState:PlayAnimation("dissipate")
            inst.SoundEmitter:PlaySound(inst:HasTag("girl") and "dontstarve/ghost/ghost_girl_howl" or "dontstarve/ghost/ghost_howl")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.components.lootdropper ~= nil then
                        inst.components.lootdropper:DropLoot()
                    end
                    inst:PushEvent("detachchild")
                    inst:Remove()
                end
            end)
        },
    },
    State{
        name = "dive",
        tags = { "busy", "noattack", "nointerrupt" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("dive")--inst.AnimState:PlayAnimation("dissipate")
			inst.AnimState:PushAnimation("surface",false)
        end,
		
        events =
        {
		    EventHandler("animover", function(inst)
				inst.ReflectionMode(inst)
            end),
            EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("idle")
            end),
        },
    },
    State{
        name = "surface",
        tags = { "busy", "noattack", "nointerrupt" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("dive")--inst.AnimState:PlayAnimation("dissipate")
			inst.AnimState:PushAnimation("surface",false)
        end,
		
		events =
        {
		    EventHandler("animover", function(inst)
				inst.RealMode(inst)
            end),
            EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("idle")
            end)
        },
    },
    State{
        name = "premoving",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("run_pre")
        end,

        timeline=
        {
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },
    },

    State{
        name = "run",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PushAnimation("run")
        end,

        timeline=
        {
         },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },
    },
    State{
        name = "lurk",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PushAnimation("idle")
        end,

        timeline=
        {
         },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    State{
        name = "run_pst",
        tags = {"moving", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("run_pst")
        end,

        timeline=
        {
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}

return StateGraph("phantom", states, events, "idle")

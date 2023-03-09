local env = env
GLOBAL.setfenv(1, GLOBAL)

local function play_shadow_animation(inst, anim, loop)
    --addshadow(inst)
    inst.AnimState:PlayAnimation(anim,loop)
    if inst.shadow then
        inst.shadow.AnimState:PlayAnimation(anim,loop)
    end
end

env.AddStategraphPostInit("crabkingclaw", function(inst)
    local states = {
        State {
            name = "clamp_attack",
            tags = { "busy", "canrotate", "clampped" },

            onenter = function(inst, boat)
                inst.sg.statemem.boat = boat
                inst.Transform:SetEightFaced()

                play_shadow_animation(inst, "clamping")
            end,

            timeline =
            {
                TimeEvent(11 * FRAMES, function(inst)
                    local boat = inst.sg.statemem.boat
                    if boat and boat:IsValid() then
                        local bumper = FindEntity(inst, 2, nil, { "boatbumper" })
                        if bumper then
                            bumper.components.health:DoDelta( -TUNING.CRABKING_CLAW_BOATDAMAGE / 4)
                        else
                            inst.SoundEmitter:PlaySoundWithParams("turnoftides/common/together/boat/damage",
                                { intensity = .3 })
                            boat.components.health:DoDelta( -TUNING.CRABKING_CLAW_BOATDAMAGE / 4)
                        end
                        ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.3, 0.03, 0.25, boat, boat:GetPhysicsRadius(4))
                    end
                end),
                TimeEvent(22 * FRAMES, function(inst)
                    local boat = inst.sg.statemem.boat
                    if boat and boat:IsValid() then
                        local bumper = FindEntity(inst, 2, nil, { "boatbumper" })
                        print("bumper:", bumper)
                        if bumper then
                            print("yes bumper")
                            bumper.components.health:DoDelta( -TUNING.CRABKING_CLAW_BOATDAMAGE / 4)
                        else
                            print("no number")
                            inst.SoundEmitter:PlaySoundWithParams("turnoftides/common/together/boat/damage",
                                { intensity = .3 })
                            boat.components.health:DoDelta( -TUNING.CRABKING_CLAW_BOATDAMAGE / 4)
                        end
                        ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.3, 0.03, 0.25, boat, boat:GetPhysicsRadius(4))
                    end
                end),
            },

            onexit = function(inst)
                inst.Transform:SetSixFaced()
            end,

            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg:GoToState("clamp")
                end),
            },
        },

    }

    for k, v in pairs(states) do
        assert(v:is_a(State), "Non-state added in mod state table!")
        inst.states[v.name] = v
    end
end)

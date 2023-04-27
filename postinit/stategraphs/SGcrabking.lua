local env = env
GLOBAL.setfenv(1, GLOBAL)

require("stategraphs/commonstates")

env.AddPrefabPostInit("moon_altar_crown", function(inst)
    inst:AddTag("moon_altar_crown")
end)

env.AddPrefabPostInit("moon_altar_cosmic", function(inst)--bruh why the 2 names for the same thing
    inst:AddTag("moon_altar_crown")
end)

env.AddStategraphPostInit("crabking", function(sg)
    table.insert(sg.states["death"].timeline, TimeEvent(26 * FRAMES, function(inst)--TIL! yipee
        if inst.countgems(inst).pearl == 0 and TheSim:FindFirstEntityWithTag("moon_altar_crown") == nil then
            local crown = SpawnPrefab("moon_altar_crown")
            local pos = Vector3(inst.Transform:GetWorldPosition())
            crown.components.heavyobstaclephysics:AddFallingStates()
            crown.Transform:SetPosition(pos.x, 4, pos.z)
            crown:PushEvent("startfalling")
            crown.Physics:SetVel(0, 20, 0)
            crown.AnimState:PlayAnimation("spin_loop", true)
            crown.falltask = crown:DoPeriodicTask(1 / 30, function()
                local cpos = Vector3(crown.Transform:GetWorldPosition())
                if cpos.y <= 0.2 then
                    crown.Transform:SetPosition(cpos.x, 0, cpos.z)
                    crown:PushEvent("stopfalling")
                    crown.AnimState:PlayAnimation("anim")
                    if crown.falltask then
                        crown.falltask:Cancel()
                        crown.falltask = nil
                    end
                end
            end)
        end
    end))
end)

local env = env
GLOBAL.setfenv(1, GLOBAL)

require("stategraphs/commonstates")

env.AddPrefabPostInit("moon_altar_crown", function(inst) inst:AddTag("moon_altar_crown") end)

env.AddPrefabPostInit("moon_altar_cosmic", function(inst) -- bruh why the 2 names for the same thing
    inst:AddTag("moon_altar_crown")
end)

local function spawnwaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActivate, random_angle) SpawnAttackWaves(inst:GetPosition(), (not random_angle and inst.Transform:GetRotation()) or nil, initialOffset or (inst.Physics and inst.Physics:GetRadius()) or nil, numWaves, totalAngle, waveSpeed, wavePrefab, idleTime, instantActivate) end

local function throwchunk(inst, prefab)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local chunk = inst.spawnchunk(inst, prefab, pos)
    chunk.Physics:SetMotorVel(math.random(12, 25), math.random(0, 10), 0)
end

local function spawnwave(inst, time)
    spawnwaves(inst, 12, 360, 3, nil, 0, 0, nil, true) -- 2 1
end

env.AddStategraphPostInit("crabking", function(sg)
    sg.states["death"].timeline = {
        TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/death2") end),
        TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/hit", nil, .5) end),
        TimeEvent(5 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/hit") end),
        TimeEvent(26 * FRAMES, function(inst)
            if not TheSim:FindFirstEntityWithTag("moon_altar_crown") then
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
            if inst.countgems(inst).pearl > 0 then
                inst.removegem(inst, "hermit_pearl")
                inst.addgem(inst, "hermit_cracked_pearl")
            end
            inst.dropgems(inst)
        end),
        TimeEvent(28 * FRAMES, function(inst)
            throwchunk(inst, "crabking_chip_high")
            throwchunk(inst, "crabking_chip_high")
            throwchunk(inst, "crabking_chip_med")
            throwchunk(inst, "crabking_chip_med")
            throwchunk(inst, "crabking_chip_low")
            throwchunk(inst, "crabking_chip_low")
            throwchunk(inst, "crabking_chip_high")
            throwchunk(inst, "crabking_chip_high")
            throwchunk(inst, "crabking_chip_med")
            throwchunk(inst, "crabking_chip_med")
            throwchunk(inst, "crabking_chip_low")
            throwchunk(inst, "crabking_chip_low")
        end),
        TimeEvent(75 * FRAMES, function(inst) spawnwave(inst) end)

    }

end)

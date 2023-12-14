local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnSeasonTick(inst)
    if inst.components.childspawner ~= nil then
        if TheWorld.state.isautumn then
            inst.components.childspawner:SetRareChild("oceanfish_small_6", 0.2)
            inst.components.childspawner.childname = "oceanfish_medium_2"
        elseif TheWorld.state.iswinter then
            inst.components.childspawner:SetRareChild("oceanfish_medium_8", 0.2)
            inst.components.childspawner.childname = "oceanfish_medium_4"
        elseif TheWorld.state.isspring then
            inst.components.childspawner:SetRareChild("oceanfish_small_7", 0.2)
            inst.components.childspawner.childname = "oceanfish_medium_5"
        elseif TheWorld.state.issummer then
            inst.components.childspawner:SetRareChild("oceanfish_small_8", 0.2)
            inst.components.childspawner.childname = "oceanfish_medium_3"
        end
    end
end

local function OnMegaFlare(inst, data)
    local nearest_shoal
        nearest_shoal = TheSim:FindEntities(data.sourcept.x, data.sourcept.y, data.sourcept.z, 35, {"oceanshoalspawner"})
    print("nearest_shoal", nearest_shoal)
    print("check", nearest_shoal ~= nil and #nearest_shoal > 0)
    print(nearest_shoal[1])
    if nearest_shoal ~= nil and #nearest_shoal > 0 then
        nearest_shoal = nearest_shoal[1]
        nearest_shoal:DoTaskInTime(5, function(inst)
            local x_offset = math.random(-10, 10)
            local z_offset = math.random(-10, 10)

            local shoal_position = inst:GetPosition()

            local the_malbatross =
                TheSim:FindFirstEntityWithTag("malbatross") or
                SpawnPrefab("malbatross")


            if the_malbatross ~= nil then
                the_malbatross.Physics:Teleport(data.sourcept.x + x_offset, data.sourcept.y, data.sourcept.z + z_offset)
                the_malbatross.components.knownlocations:RememberLocation("home", shoal_position)
                the_malbatross.components.entitytracker:TrackEntity("feedingshoal", inst)

                the_malbatross.sg:GoToState("arrive")
            end
        end)
    end
end

env.AddPrefabPostInit("oceanfish_shoalspawner", function(inst)
    inst:DoTaskInTime(0, OnSeasonTick)
    inst:WatchWorldState("cycles", OnSeasonTick)

    inst:ListenForEvent("megaflare_detonated", function(src, data) OnMegaFlare(inst, data) end, TheWorld)
end)

local autumn_fishes = { "oceanfish_small_6", "oceanfish_medium_2" }
local winter_fishes = { "oceanfish_medium_4", "oceanfish_medium_8" }
local spring_fishes = { "oceanfish_small_7", "oceanfish_medium_5" }
local summer_fishes = { "oceanfish_small_8", "oceanfish_medium_3" }

for k, v in ipairs(autumn_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
            if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.isautumn then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1, 5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end

for k, v in ipairs(winter_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
            if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.iswinter then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1, 5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end

for k, v in ipairs(spring_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
            if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.isspring then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1, 5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end

for k, v in ipairs(summer_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
            if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.issummer then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1, 5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end

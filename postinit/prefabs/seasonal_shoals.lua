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

env.AddPrefabPostInit("oceanfish_shoalspawner", function(inst)
    inst:DoTaskInTime(0, OnSeasonTick)
    inst:WatchWorldState("cycles", OnSeasonTick)
end)

local autumn_fishes = {"oceanfish_small_6", "oceanfish_medium_2"}
local winter_fishes = {"oceanfish_medium_4", "oceanfish_medium_8"}
local spring_fishes = {"oceanfish_small_7", "oceanfish_medium_5"}
local summer_fishes = {"oceanfish_small_8", "oceanfish_medium_3"}

for k,v in ipairs(autumn_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
            if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.isautumn then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1,5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end

for k,v in ipairs(winter_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
            if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.iswinter then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1,5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end

for k,v in ipairs(spring_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
           if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.isspring then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1,5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end

for k,v in ipairs(summer_fishes) do
    env.AddPrefabPostInit(v, function(inst)
        inst:WatchWorldState("cycles", function(inst)
           if (inst.components.homeseeker ~= nil and inst.components.homeseeker.home.prefab == "oceanfish_shoalspawner") and not TheWorld.state.issummer then
                if inst.sg ~= nil then
                    if not inst.sg:HasStateTag("busy") then
                        inst:DoTaskInTime(math.random(1,5), inst.sg:GoToState("leave"))
                    end
                else
                    inst:Remove()
                end
            end
        end)
    end)
end
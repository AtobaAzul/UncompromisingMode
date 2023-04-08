local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then
        return
    end

    local count_skull, count_winky, items_skull, items_winky = 0, 0
    inst:DoTaskInTime(0, function()

        --count all skullchests and winky burrows
        for k, v in pairs(Ents) do
            if v.prefab == "skullchest" then
                count_skull = count_skull + 1
            elseif v.prefab == "uncompromising_winkyburrow_master" then
                count_winky = count_winky + 1
            end
        end

        --resolve any excess skullchests
        if count_skull > 1 then
            for k, v in pairs(Ents) do
                if count_skull == 1 then
                    break
                end
                if v.prefab == "skullchest" then
                    items_skull = v.components.container:RemoveAllItems()
                    if items_skull ~= nil then
                        local skullchest = TheSim:FindFirstEntityWithTag("skullchest")
                        local x, y, z = 0, 0, 0
                        if skullchest ~= nil then
                            x, y, z = skullchest.Transform:GetWorldPosition()
                        end
                        for _, item in pairs(items_skull) do
                            item.Transform:SetPosition(x, y, z)
                        end
                    end
                    v:DoTaskInTime(1, v.Remove)
                    count_skull = count_skull - 1
                end
            end
        end

        if count_winky > 1 then
            for k, v in pairs(Ents) do
                if count_winky == 1 then
                    break
                end
                if v.prefab == "skullchest" then
                    items_winky = v.components.container:RemoveAllItems()
                    if count_winky ~= nil then
                        local winky_burrow = TheSim:FindFirstEntityWithTag("winky_burrow")
                        local x, y, z = 0, 0, 0
                        if winky_burrow ~= nil then
                            x, y, z = winky_burrow.Transform:GetWorldPosition()
                        end
                        for _, item in pairs(items_winky) do
                            item.Transform:SetPosition(x, y, z)
                        end
                    end
                    v:DoTaskInTime(1, v.Remove)
                    count_winky = count_winky - 1
                end
            end
        end

        if count_skull == 0 then
            SpawnPrefab("skullchest") --Add a skullchest entity if there's none
            for k, v in pairs(Ents) do
                if v.prefab == "skullchest_child" then
                    v:OnLoadPostPass(v) --reattach for any pre-existing ones
                end
            end
        end
        if count_winky == 0 then
            SpawnPrefab("uncompromising_winkyburrow_master") --Add a uncompromising_winkyburrow_master entity if there's none
            for k, v in pairs(Ents) do
                if v.prefab == "uncompromising_winkyburrow" or v.prefab == "uncompromising_winkyhomeburrow" then
                    v:OnLoadPostPass(v) --reattach for any pre-existing ones
                end
            end
        end
    end)

    if inst:HasTag("forest") then
        --inst:AddComponent("acidmushrooms")
    end
end)

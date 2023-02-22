local env = env
GLOBAL.setfenv(1, GLOBAL)

--fish meat buff code by Electroely#0066
--1. remove existing drops (cook, perish, murder)
--2. add fns in place of those drops to give the meat according to a variable inst.meatvalue
--fish get +1 meat if above 75% weight, -1 if below 25%. can't go below 1
--gold value is determined by meatvalue. rare fish (baitfish & lionfish) give x3 gold for their value
local fishdata = {
    --{meatprefab, meatvalue, extraitems, israre }
    oceanfish_medium_1 = {"fishmeat", 1}, --mudfish
    oceanfish_medium_2 = {"fishmeat", 2}, --deep bass
    oceanfish_medium_3 = {"fishmeat", 3, nil, true}, --dandy lionfish
    oceanfish_medium_4 = {"fishmeat", 4}, --black catfish
    oceanfish_medium_5 = {"corn", 2, {"corn_seeds"}}, --corn cod
    oceanfish_medium_6 = {"fishmeat", 2, nil, true}, --dappled koi
    oceanfish_medium_7 = {"fishmeat", 2, nil, true}, --golden koi
    oceanfish_medium_8 = {"fishmeat", 3, {"ice", "ice"}}, --ice bream
    oceanfish_medium_9 = {"fishmeat", 2, {"honey", "honey"}}, --sweetish fish

    oceanfish_small_1 = {"fishmeat_small", 1}, --runty guppy
    oceanfish_small_2 = {"fishmeat_small", 1}, --needlenosed squirt
    oceanfish_small_3 = {"fishmeat_small", 2, nil, true}, --bitty baitfish
    oceanfish_small_4 = {"fishmeat_small", 1}, --smolt fry
    oceanfish_small_5 = {"corn_cooked", 1, {"corn_seeds"}}, --popperfish
    oceanfish_small_6 = {"plantmeat", 1}, --fallounder
    oceanfish_small_7 = {"plantmeat", 1}, --bloomfin tuna
    oceanfish_small_8 = {"fishmeat_small_cooked", 1, nil, true}, --scorching sunfish
    oceanfish_small_9 = {"fishmeat_small", 2, nil, true} --spittlefish
}

local function OnWeightChanged(inst)
    local data = fishdata[inst.prefab] or fishdata[string.sub(inst.prefab, 0, -5)]
    local basevalue = data[2]
    local pct = inst.components.weighable:GetWeightPercent()
    if pct >= 0.75 then
        inst.meatvalue = basevalue + 1
    elseif pct < 0.25 then
        inst.meatvalue = basevalue - 1
    else
        inst.meatvalue = basevalue
    end
    inst.meatvalue = math.max(1, inst.meatvalue)
    local loot = {}
    for i = 1, inst.meatvalue do
        table.insert(loot, data[1])
    end
    if data[3] then
        for k, v in pairs(data[3]) do
            table.insert(loot, v)
        end
    end
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot(loot)
    end
    if inst.edit_fish_def then
        inst.fish_def.loot = loot
    end
    if inst.components.tradable ~= nil then
        inst.components.tradable.goldvalue = inst.meatvalue * (data[4] and 3 or 1)
    end
end
for prefab, data in pairs(fishdata) do
    env.AddPrefabPostInit(
        prefab,
        function(inst)
            if not TheWorld.ismastersim then
                return
            end
            inst.edit_fish_def = true
            inst.fish_def = deepcopy(inst.fish_def)
            inst:ListenForEvent("weightchanged", OnWeightChanged)
            inst:DoTaskInTime(0, OnWeightChanged)
        end
    )
    env.AddPrefabPostInit(
        prefab .. "_inv",
        function(inst)
            if not TheWorld.ismastersim then
                return
            end
            inst.meatvalue = 1
            --weight fn (also overrides murder loot)
            inst:ListenForEvent("weightchanged", OnWeightChanged)
            inst:DoTaskInTime(0, OnWeightChanged)
            --cook override
            if inst.components.cookable then
                local meatname = data[1]
                if string.sub(meatname, -7) ~= "_cooked" then
                    meatname = meatname .. "_cooked"
                end
                inst.components.cookable.product = meatname
                inst.components.cookable.oncooked = function(inst, cooker, chef)
                    local cook_pos = (cooker and cooker:GetPosition()) or nil
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local loot = {}
                    for i = 1, inst.meatvalue - 1 do
                        table.insert(loot, SpawnPrefab(meatname))
                    end
                    if data[3] then
                        for k, v in pairs(data[3]) do
                            table.insert(loot, SpawnPrefab(v))
                        end
                    end
                    for k, v in pairs(loot) do
                        if chef.components.inventory then
                            chef.components.inventory:GiveItem(v, nil, cook_pos)
                        else
                            v.components.inventoryitem:DoDropPhysics(x, y, z, true, 0.3)
                        end
                    end
                    return true
                end
            end
            --perish override
            if inst.components.perishable then
                inst.components.perishable.onperishreplacement = nil
                inst.components.perishable:SetOnPerishFn(
                    function(inst)
                        local x, y, z = inst.Transform:GetWorldPosition()
                        local owner = inst.components.inventoryitem.owner
                        local holder = owner ~= nil and (owner.components.inventory or owner.components.container)
                        local loot = {}
                        for i = 1, inst.meatvalue do
                            table.insert(loot, SpawnPrefab(data[1]))
                        end
                        if data[3] then
                            for k, v in pairs(data[3]) do
                                table.insert(loot, SpawnPrefab(v))
                            end
                        end
                        local slot = holder and holder:GetItemSlot(inst)
                        inst:Remove()
                        for k, v in pairs(loot) do
                            if holder then
                                holder:GiveItem(v, slot)
                            else
                                v.components.inventoryitem:DoDropPhysics(x, y, z, true, 0.3)
                            end
                        end
                    end
                )
            end
        end
    )
end

env.AddComponentPostInit(
    "weighable",
    function(self)
        local SetWeight_old = self.SetWeight
        self.SetWeight = function(self, weight, ...)
            local rtn = {SetWeight_old(self, weight, ...)}
            self.inst:PushEvent("weightchanged", weight)
            return unpack(rtn)
        end
    end
)

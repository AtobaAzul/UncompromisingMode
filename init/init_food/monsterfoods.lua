--local variables
local SpawnPrefab = GLOBAL.SpawnPrefab
local TUNING = GLOBAL.TUNING

--------------------------------------------------

--AddIngredientValues({"monstersmallmeat"}, {meat = 0.5, monster = 1}, true, true)
AddIngredientValues({"monsteregg"}, {egg = 1, monster = 1}, true)

--------------------------------------------------

-- Spiders --
local spiders = {"spider"}

for k, v in pairs(spiders) do
    AddPrefabPostInit(v, function(v)
        --reconstruct the loot table
        v:RemoveComponent("lootdropper")
        v:AddComponent("lootdropper")
        v.components.lootdropper:AddRandomLoot("monstersmallmeat", 1)
        v.components.lootdropper:AddRandomLoot("silk", .5)
        v.components.lootdropper:AddRandomLoot("spidergland", .5)
        v.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
        v.components.lootdropper.numrandomloot = 1
    end)
end

--------------------------------------------------
--Haunting Morsels and Small Jerkies will transform them into Monster Morsels and Small Monster Jerkies

local function AddMonsterMeatChange(inst, prefab)
    GLOBAL.AddHauntableCustomReaction(inst, function(inst, haunter)
        if math.random() <= TUNING.HAUNT_CHANCE_OCCASIONAL then
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("small_puff").Transform:SetPosition(x, y, z)
            local new = SpawnPrefab(prefab)
            if new ~= nil then
                new.Transform:SetPosition(x, y, z)
                if new.components.stackable ~= nil and inst.components.stackable ~= nil and inst.components.stackable:IsStack() then
                    new.components.stackable:SetStackSize(inst.components.stackable:StackSize())
                end
                if new.components.inventoryitem ~= nil and inst.components.inventoryitem ~= nil then
                    new.components.inventoryitem:InheritMoisture(inst.components.inventoryitem:GetMoisture(), inst.components.inventoryitem:IsWet())
                end
                if new.components.perishable ~= nil and inst.components.perishable ~= nil then
                    new.components.perishable:SetPercent(inst.components.perishable:GetPercent())
                end
                new:PushEvent("spawnedfromhaunt", { haunter = haunter, oldPrefab = inst })
                inst:PushEvent("despawnedfromhaunt", { haunter = haunter, newPrefab = new })
                inst.persists = false
                inst.entity:Hide()
                inst:DoTaskInTime(0, inst.Remove)
            end
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            return true
        end
        return false
    end, false, true, false)
end

AddPrefabPostInit("smallmeat", function(inst)
    AddMonsterMeatChange(inst, "monstersmallmeat")
end)

AddPrefabPostInit("smallmeat_dried", function(inst)
    AddMonsterMeatChange(inst, "monstersmallmeat_dried")
end)
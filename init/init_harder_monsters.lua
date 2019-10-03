--Bats come in higher numbers
AddPrefabPostInit("cave_entrance", function (inst)
    --inst.components.childspawner:SetRegenPeriod(60)
    inst.components.childspawner:SetSpawnPeriod(.1/GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
    inst.components.childspawner:SetMaxChildren(6*GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
    --inst.components.childspawner.childname = "bat"
end)

AddPrefabPostInit("batcave", function (inst)
    --inst.components.childspawner:SetRegenPeriod(TUNING.BATCAVE_REGEN_PERIOD)
    inst.components.childspawner:SetSpawnPeriod(TUNING.BATCAVE_SPAWN_PERIOD/GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
    inst.components.childspawner:SetMaxChildren(TUNING.BATCAVE_MAX_CHILDREN*GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
    --inst.components.childspawner.childname = "bat"
end)

--Pigs defend their turf if their home is destroyed
local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
        inst.components.spawner.child.combat:SetTarget(worker) --<< Get the pig to attack the perpetrator of the crime against pig-kind
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

AddPrefabPostInit("pighouse", onhammered)
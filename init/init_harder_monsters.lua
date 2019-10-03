--Bats come in higher numbers
AddPrefabPostInit("cave_entrance", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.childspawner ~= nil then
        --inst.components.childspawner:SetRegenPeriod(60)
        inst.components.childspawner:SetSpawnPeriod(.1/GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        inst.components.childspawner:SetMaxChildren(6*GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        --inst.components.childspawner.childname = "bat"
    end
end)

AddPrefabPostInit("batcave", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.childspawner ~= nil then
        --inst.components.childspawner:SetRegenPeriod(TUNING.BATCAVE_REGEN_PERIOD)
        inst.components.childspawner:SetSpawnPeriod(TUNING.BATCAVE_SPAWN_PERIOD/GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        inst.components.childspawner:SetMaxChildren(TUNING.BATCAVE_MAX_CHILDREN*GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        --inst.components.childspawner.childname = "bat"
    end
end)


--Pigs defend their turf if their home is destroyed
local pigtaunts = 
{
    "GET OFF LAWN",
    "LEAVE HOUSE ALONE",
    "PIG HOUSE ATTACK",
    "DO NOT HIT",
    "NO KILL HOUSE",
    "STOP RIGHT THERE"
}

local function onworked(inst, worker)
    if inst.components.spawner ~= nil and inst.components.spawner.child then
        inst.components.spawner.child.components.combat:SetTarget(worker) --<< Get the pig to attack the perpetrator of the crime against pig-kind
    end
end

AddPrefabPostInit("pighouse", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.workable ~= nil then
        inst.components.workable:SetOnWorkCallback(onworked)
    end
end)
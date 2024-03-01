local DecidTable = {
}
local WixieTable = {
}
local DesertTable = {
}
local MarshTable = {
}
local HoodedTable = {
}
local DarkForestTable = {
}
local RockyTable = {
}
local SavannaTable = {
}

local MosaicTable = {
}

local GeneralTable = {
    TestSetpiece = 1
}

local OceanTable = {

}

local function AddToTheWorld(inst, umss) table.insert(TheWorld.dl_setpieces, umss) end

local function FinalizeSpawn(inst, dl, x, y, z)
    local spawner = SpawnPrefab("dl_spawner")
    spawner.layout = dl
    spawner.Transform:SetPosition(x, y, z)
    spawner.AnimState:SetMultColour(0, 0, 0, 0) -- makes it invisible too.
    spawner:AddTag("NOCLICK")
    spawner:AddTag("NOBLOCK")
    spawner:DoPeriodicTask(FRAMES * 2, function(spawner) spawner:Remove() end) -- just in case it fails.
    AddToTheWorld(inst, dl)
    inst:Remove()
end

local function SpawnBiomeDL(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
    local dl
    local Table
    local DoSpawn = true
    if TheWorld.Map:IsOceanAtPoint(x, y, z) then
        for i = -16, 16 do
            for k = -16, 16 do
                if not TheWorld.Map:IsOceanAtPoint(x + i, y, z + k) then
                    DoSpawn = false
                end
            end
        end
        if DoSpawn then
            Table = inst.OceanTable
            dl = weighted_random_choice(Table)
        end
    end

    if tile == WORLD_TILES.MARSH and weighted_random_choice(inst.MarshTable) then
        Table = inst.MarshTable
        dl = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.HOODEDFOREST and weighted_random_choice(inst.HoodedTable) then
        Table = inst.HoodedTable
        dl = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.DESERT_DIRT and weighted_random_choice(inst.DesertTable) then
        Table = inst.DesertTable
        dl = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.DECIDUOUS and weighted_random_choice(inst.DecidTable) then
        Table = inst.DecidTable
        dl = weighted_random_choice(Table)
    end
    --[[if tile == WORLD_TILES.GRASS and weighted_random_choice(inst.WixieTable) then
		Table = inst.WixieTable
		umss = weighted_random_choice(Table)
	end]]
    if tile == WORLD_TILES.FOREST and weighted_random_choice(inst.DarkForestTable) then
        Table = inst.DarkForestTable
        dl = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.SAVANNA and weighted_random_choice(inst.SavannaTable) then
        Table = inst.SavannaTable
        dl = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.ROCKY and weighted_random_choice(inst.RockyTable) then
        Table = inst.RockyTable
        dl = weighted_random_choice(Table)
    end

    if inst.components.areaaware:CurrentlyInTag("oasis") then -- Also triggers for secondary meteor biome
        Table = inst.MosaicTable
        dl = weighted_random_choice(Table)
    end

    if not dl then
        Table = inst.GeneralTable
        dl = weighted_random_choice(Table)
    end

    if not TheWorld.dl_setpieces then
        TheWorld.dl_setpieces = {}
    end

    for i, v in ipairs(TheWorld.dl_setpieces) do
        if v == dl then
            for i, v in ipairs(Table) do
                if v == dl then
                    table.remove(Table, i)
                end
            end
            if inst.count > 2 then
                inst:Remove()
            else
                inst.fail = true
                inst.count = inst.count + 1
            end
        end
    end
    --[[if not inst.fail then
		FinalizeSpawn(inst,umss,x,y,z)
	else
		inst.fail = nil
		SpawnBiomeUMSS(inst)
	end]]
    FinalizeSpawn(inst, dl, x, y, z)
end

local function makefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.DecidTable = DecidTable
    inst.WixieTable = WixieTable
    inst.DesertTable = DesertTable
    inst.MarshTable = MarshTable
    inst.HoodedTable = HoodedTable
    inst.DarkForestTable = DarkForestTable
    inst.RockyTable = RockyTable
    inst.SavannaTable = SavannaTable
    inst.MosaicTable = MosaicTable
    inst.GeneralTable = GeneralTable
    inst.OceanTable = OceanTable
    inst:AddComponent("areaaware")
    inst.count = 0
    inst:DoTaskInTime(0, SpawnBiomeDL)
    return inst
end

return Prefab("dl_biometable", makefn)

local DecidTable = {LazyBase = 1}
local WixieTable = {wixie_puzzle = 2}
local DesertTable = {sussyTable = 1}
local MarshTable = {fooltrap1Table = 1}
local HoodedTable = {

    ancientwalrusTable = 1
    -- Guardian_Of_Nothing = 0.5, -- Lacking the skins used to make it, looks kinda bad as a result. Might remake it?

}
local DarkForestTable = {walterifgood = 1}
local RockyTable = {singlefather = 1}
local SavannaTable = {sos = 0.5, moxTable = 0.5, deadBodies = 2, grassTrap = 0.1}

local MosaicTable = { -- need more mosaic setpieces

    impactfulDiscovery = 1,
    dudu_DUN_DUN = 0.01

}

local GeneralTable = {badfarmerTable = 0.5, baseFrag_smellyKitchen = 0.5, baseFrag_rattyStorage = 0.5, moonOil = 0.75, moonFrag = 0.25, megabaseruins_intersection = 0.25, megabaseruins_centerpiece = 0.25, megabaseruins_road = 0.25}

local OceanTable = {sunkenboat = 0.5, failedFisherman = 0.5}

local function AddToTheWorld(inst, umss) table.insert(TheWorld.umsetpieces, umss) end

local function FinalizeSpawn(inst, umss, x, y, z)
    local spawner = SpawnPrefab("umss_general")
    spawner.DefineTable(spawner, umss)
    spawner.Transform:SetPosition(x, y, z)
    spawner.AnimState:SetMultColour(0, 0, 0, 0) -- makes it invisible too.
    spawner:AddTag("NOCLICK")
    spawner:AddTag("NOBLOCK")
    spawner:DoPeriodicTask(3, function(spawner) spawner:Remove() end) -- just in case it fails.
    AddToTheWorld(inst, umss)
    inst:Remove()
end

local function SpawnBiomeUMSS(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
    local umss
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
            umss = weighted_random_choice(Table)
        end
    end

    if tile == WORLD_TILES.MARSH and weighted_random_choice(inst.MarshTable) then
        Table = inst.MarshTable
        umss = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.HOODEDFOREST and weighted_random_choice(inst.HoodedTable) then
        Table = inst.HoodedTable
        umss = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.DESERT_DIRT and weighted_random_choice(inst.DesertTable) then
        Table = inst.DesertTable
        umss = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.DECIDUOUS and weighted_random_choice(inst.DecidTable) then
        Table = inst.DecidTable
        umss = weighted_random_choice(Table)
    end
    --[[if tile == WORLD_TILES.GRASS and weighted_random_choice(inst.WixieTable) then
		Table = inst.WixieTable
		umss = weighted_random_choice(Table)
	end]]
    if tile == WORLD_TILES.FOREST and weighted_random_choice(inst.DarkForestTable) then
        Table = inst.DarkForestTable
        umss = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.SAVANNA and weighted_random_choice(inst.SavannaTable) then
        Table = inst.SavannaTable
        umss = weighted_random_choice(Table)
    end
    if tile == WORLD_TILES.ROCKY and weighted_random_choice(inst.RockyTable) then
        Table = inst.RockyTable
        umss = weighted_random_choice(Table)
    end

    if inst.components.areaaware:CurrentlyInTag("oasis") then -- Also triggers for secondary meteor biome
        Table = inst.MosaicTable
        umss = weighted_random_choice(Table)
    end

    if not umss then
        Table = inst.GeneralTable
        umss = weighted_random_choice(Table)
    end
    if not TheWorld.umsetpieces then
        TheWorld.umsetpieces = {}
    end

    for i, v in ipairs(TheWorld.umsetpieces) do
        if v == umss then
            for i, v in ipairs(Table) do
                if v == umss then
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
    FinalizeSpawn(inst, umss, x, y, z)
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
    inst:DoTaskInTime(0, SpawnBiomeUMSS)
    return inst
end

return Prefab("ums_biometable", makefn)

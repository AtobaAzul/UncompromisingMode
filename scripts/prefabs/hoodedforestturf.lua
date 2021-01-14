local function ondeploy(inst, pt, deployer)
    if deployer and deployer.SoundEmitter then
        deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
    end

    local map = TheWorld.Map
    local original_tile_type = map:GetTileAtPoint(pt:Get())
    local x, y = map:GetTileCoordsAtPoint(pt:Get())
    if x and y then
        map:SetTile(x,y, inst.data.tile)
        map:RebuildLayer( original_tile_type, x, y )
        map:RebuildLayer( inst.data.tile, x, y )
    end

    local minimap = TheWorld.minimap.MiniMap
    minimap:RebuildLayer(original_tile_type, x, y)
    minimap:RebuildLayer(inst.data.tile, x, y)

    inst.components.stackable:Get():Remove()
end

local assets =
{
    Asset("ANIM", "anim/hfturf.zip"),
}

local prefabs =
{
    "gridplacer",
}

local function make_turf(data)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("groundtile")

        inst.AnimState:SetBank("hfturf")
        inst.AnimState:SetBuild("hfturf")
        inst.AnimState:PlayAnimation(data.anim)

        inst:AddTag("molebait")

        inst.entity:SetPristine()
        
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/turf_" .. data.name .. ".xml"
        inst.data = data

        inst:AddComponent("bait")
        
        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL
        MakeMediumBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploy
        if data.tile == "webbing" then
            inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        else
            inst.components.deployable:SetDeployMode(DEPLOYMODE.TURF)
        end
        inst.components.deployable:SetUseGridPlacer(true)

        ---------------------
        return inst
    end

    return Prefab("turf_"..data.name, fn, assets, prefabs)
end

local turfs =
{
    {name="hoodedmoss",			anim="hoodedmoss",			tile=GROUND.HOODEDFOREST},
    {name="ancienthoodedturf",	anim="ancienthoodedturf",   tile=GROUND.ANCIENTHOODEDFOREST},
	--[[{name="tidalmarsh",		anim="tidalmarsh",		tile=GROUND.TIDALMARSH},
	{name="magmafield",		anim="magmafield",		tile=GROUND.MAGMAFIELD},
	{name="ash",			anim="ash",				tile=GROUND.ASH},
	{name="volcano",		anim="volcano",			tile=GROUND.VOLCANO},
	{name="snakeskinfloor",	anim="snakeskinfloor",	tile=GROUND.SNAKESKINFLOOR},
	{name="beach",			anim="beach",			tile=GROUND.BEACH},]]
}

for k,v in pairs(turfs) do
    table.insert(assets, Asset("ATLAS", "images/inventoryimages/turf_" .. v.name .. ".xml"))
    table.insert(assets, Asset("IMAGE", "images/inventoryimages/turf_" .. v.name .. ".tex"))
end

local prefabs= {}
for k,v in pairs(turfs) do
    table.insert(prefabs, make_turf(v))
end

return unpack(prefabs)
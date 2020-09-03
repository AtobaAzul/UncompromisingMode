require "prefabs/veggies"
require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/seeds.zip"),
	Asset("ANIM", "anim/oceanfishing_lure_mis.zip"),
}

local prefabs =
{
    "seeds_cooked",
    "spoiled_food",
    "plant_normal_ground",
}

for k,v in pairs(VEGGIES) do
    table.insert(prefabs, k)
end

local function pickproduct(inst)
    return "snapdragon"
end

local function OnDeploy(inst, pt)--, deployer, rot)
    local plant = SpawnPrefab("whisperpod_normal_ground")
    plant.components.crop:StartGrowing(inst.components.plantable.product(inst), inst.components.plantable.growtime)
    plant.Transform:SetPosition(pt.x, 0, pt.z)
    plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
    inst:Remove()
end

local function common(anim, cookable, oceanfishing_lure)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("seeds")
    inst.AnimState:SetBuild("seeds")
    inst.AnimState:PlayAnimation(anim)
    inst.AnimState:SetRayTestOnBB(true)

    if cookable then
        inst:AddTag("deployedplant")

        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")
    end

	if oceanfishing_lure then
		inst:AddTag("oceanfishing_lure")
	end

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.SEEDS

    if cookable then
        inst:AddComponent("cookable")
        inst.components.cookable.product = "seeds_cooked"
    end

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

local function raw()
    local inst = common("idle", true, true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

    inst:AddComponent("bait")
    inst:AddComponent("plantable")
    inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
    inst.components.plantable.product = pickproduct

    inst:AddComponent("deployable")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    --inst.components.deployable.restrictedtag = "plantkin"
    inst.components.deployable.ondeploy = OnDeploy

	inst:AddComponent("oceanfishingtackle")
	inst.components.oceanfishingtackle:SetupLure({build = "oceanfishing_lure_mis", symbol = "hook_seeds", single_use = true, lure_data = TUNING.OCEANFISHING_LURE.SEED})

    return inst
end

local function cooked()
    local inst = common("cooked")

    inst.components.floater:SetScale(0.8)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY / 2
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)

    return inst
end

return Prefab("whisperpod", raw, assets, prefabs),
    Prefab("whisperpod_cooked", cooked, assets),
    MakePlacer("whisperpod_placer", "plant_normal_ground", "plant_normal_ground", "placer")

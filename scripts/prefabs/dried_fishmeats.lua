local assets =
{
  --  Asset("ANIM", "anim/extra_monsterfoods.zip"),
  --  Asset("ANIM", "anim/extra_monsterfoods_dried.zip"),
   -- Asset("ATLAS", "images/inventoryimages/monstersmallmeat.xml"),
   -- Asset("ATLAS", "images/inventoryimages/cookedmonstersmallmeat.xml"),
   -- Asset("ATLAS", "images/inventoryimages/monstersmallmeat_dried.xml"),
}

local monster_prefabs =
{
    --"cookedmonstersmallmeat",
    --"monstersmallmeat_dried",
    --"spoiled_food",
}

local function OnSpawnedFromHaunt(inst, data)
    Launch(inst, data.haunter, TUNING.LAUNCH_SPEED_SMALL)
end

local function common_meat(anim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fishmeats")
    inst.AnimState:SetBuild("fishmeats")
    inst.AnimState:PlayAnimation(anim)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    
    inst:AddComponent("stackable")

    inst:AddComponent("tradable")

    inst:AddComponent("perishable")
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end

local function fishmeat_dried_fn()
	local inst = common_meat("fishmeat_dried")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = 25
    inst.components.edible.hungervalue = TUNING.CALORIES_MED
    inst.components.edible.sanityvalue = 20

    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)

	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM -- 10 days

    inst.components.inventoryitem.atlasname = "images/inventoryimages/fishmeat_dried.xml"
    
    return inst
end

local function smallfishmeat_dried_fn()
	local inst = common_meat("smallfishmeat_dried")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = 10
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = 12

    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)

	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM -- 10 days

    inst.components.inventoryitem.atlasname = "images/inventoryimages/smallfishmeat_dried.xml"
    
    return inst
end

return Prefab("fishmeat_dried", fishmeat_dried_fn, assets, monster_prefabs),
        Prefab("smallfishmeat_dried", smallfishmeat_dried_fn, assets)
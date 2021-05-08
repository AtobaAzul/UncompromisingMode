local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("purplesteamedhams")
    inst.AnimState:SetBuild("purplesteamedhams")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/purplesteamedhams.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 40
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = 15
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((3*TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst:AddTag("preparedfood")
	inst:SetPrefabNameOverride("steamedhams")
    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("greensteamedhams")
    inst.AnimState:SetBuild("greensteamedhams")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/greensteamedhams.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 40
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = 15
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((3*TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst:AddTag("preparedfood")
	inst:SetPrefabNameOverride("steamedhams")
    return inst
end

local function fnfoliagegreen()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("greenfoliage")
    inst.AnimState:SetBuild("greenfoliage")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/greenfoliage.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
	inst:SetPrefabNameOverride("foliage")
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("purplesteamedhams", fn1),
Prefab("greensteamedhams", fn2),
Prefab("greenfoliage", fnfoliagegreen)

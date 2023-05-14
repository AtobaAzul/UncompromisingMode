local function oneatenfn(inst, eater)
	if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("buff_largehungerslow", "buff_largehungerslow")
	end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("snotroast")
    inst.AnimState:SetBuild("snotroast")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.RAREMEAT
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/snotroast.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 3
    inst.components.edible.hungervalue = 150
    inst.components.edible.sanityvalue = 5
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((5*TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst.components.edible:SetOnEatenFn(oneatenfn)
	inst:AddTag("preparedfood")
    return inst
end

return Prefab("snotroast", fn)

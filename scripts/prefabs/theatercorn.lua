local function oneatenfn(inst, eater)
	if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                --eater.components.debuffable:AddDebuff("buff_electricretaliation", "buff_electricretaliation")
	end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("theatercorn")
    inst.AnimState:SetBuild("theatercorn")
    inst.AnimState:PlayAnimation("ground")

    MakeInventoryFloatable(inst)

	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/theatercorn.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 3
    inst.components.edible.hungervalue = 62.5
    inst.components.edible.sanityvalue = 5
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((10*TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst.components.edible:SetOnEatenFn(oneatenfn)
	inst:AddTag("preparedfood")
    return inst
end

return Prefab("theatercorn", fn)

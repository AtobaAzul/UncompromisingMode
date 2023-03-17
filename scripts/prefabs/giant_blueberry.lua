local assets =
{
    Asset("ANIM", "anim/blueberry.zip"),
	Asset("ATLAS", "images/inventoryimages/giant_blueberry.xml"),
	Asset("IMAGE", "images/inventoryimages/giant_blueberry.tex"),
}

local function oneatenfn(inst, eater)
	if  eater.components.moisture ~= nil and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.moisture:DoDelta(5)
	end
end
--hey uh, push jic?


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueberry")
    inst.AnimState:SetBuild("blueberry")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    --inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDIUMITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/giant_blueberry.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 1
    inst.components.edible.hungervalue = 12.5
    inst.components.edible.sanityvalue = 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible:SetOnEatenFn(oneatenfn)
    inst:AddComponent("perishable")
	inst:AddComponent("tradable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST) -- 6 days
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
    return inst
end

return Prefab("giant_blueberry", fn, assets)

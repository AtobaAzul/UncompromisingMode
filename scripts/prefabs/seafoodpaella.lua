local assets =
{
    Asset("ANIM", "anim/seafoodpaella.zip"),
    Asset("ATLAS", "images/inventoryimages/zaspberryparfait.xml"),
}
local function oneatenfn(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(1440)			
	end	
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("seafoodpaella")
    inst.AnimState:SetBuild("seafoodpaella")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
	--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/seafoodpaella.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 12
    inst.components.edible.hungervalue = 75
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

return Prefab("seafoodpaella", fn, assets)

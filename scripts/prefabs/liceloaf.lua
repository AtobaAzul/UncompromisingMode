local assets =
{
    Asset("ANIM", "anim/liceloaf.zip"),
    Asset("ATLAS", "images/inventoryimages/liceloaf.xml"),
}
local function oneatenfn(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(720)			
	end	
end

local function rename(inst)
    inst.components.named:PickNewName()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("liceloaf")
    inst.AnimState:SetBuild("liceloaf")
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
	
	inst:AddComponent("named")
	inst.components.named.possiblenames = {STRINGS.NAMES["LICELOAF1"], STRINGS.NAMES["LICELOAF2"]}
	inst.components.named:PickNewName()
	inst:DoPeriodicTask(5, rename)
		
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/liceloaf.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 62.5
    inst.components.edible.sanityvalue = 0
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

return Prefab("liceloaf", fn, assets)

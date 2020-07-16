local assets =
{
    Asset("ANIM", "anim/californiaking.zip"),
    Asset("ATLAS", "images/inventoryimages/californiaking.xml"),
}
local function oneatenfn(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(1920) --Should be four days			
	end
		if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("buff_californiaking", "buff_californiaking")
	end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("californiaking")
    inst.AnimState:SetBuild("californiaking")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(1.5,1.5,1.5)
    MakeInventoryFloatable(inst)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(237/255, 76/255, 37/255)
	--inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/californiaking.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 3
    inst.components.edible.hungervalue = 62.5
    inst.components.edible.sanityvalue = -15
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

return Prefab("californiaking", fn, assets)

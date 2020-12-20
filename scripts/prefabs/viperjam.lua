local assets =
{
    Asset("ANIM", "anim/zaspberryparfait.zip"),
	Asset("ATLAS", "images/inventoryimages/zaspberryparfait.xml"),
	--Asset("IMAGE", "images/inventoryimages/zaspberryparfait.tex"),
}

local function oneatenfn(inst, eater)
	if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                --eater.components.debuffable:AddDebuff("buff_electricretaliation", "buff_electricretaliation") Nothing, for now.
	end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("viperjam")
    inst.AnimState:SetBuild("viperjam")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(206/255, 37/255, 37/255)
	local scale = 1.2
	inst.Transform:SetScale(scale, scale, scale)
    inst.Light:Enable(true)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/viperjam.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 40
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = 15
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

return Prefab("viperjam", fn, assets)

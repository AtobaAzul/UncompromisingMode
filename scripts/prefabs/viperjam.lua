local assets =
{
    Asset("ANIM", "anim/zaspberryparfait.zip"),
	Asset("ATLAS", "images/inventoryimages/zaspberryparfait.xml"),
	--Asset("IMAGE", "images/inventoryimages/zaspberryparfait.tex"),
}
local easing = require("easing")
local function spawnfriends(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab("viperprojectile")
    projectile.Transform:SetPosition(x, y, z)
    local pt = inst:GetPosition()
	pt.x = pt.x + math.random(-3,3)
	pt.z = pt.z + math.random(-3,3)
	local speed = easing.linear(3, 7, 3, 10)
	projectile:AddTag("canthit")
	projectile:AddTag("friendly")
	--projectile.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS/2
    projectile.components.complexprojectile:SetHorizontalSpeed(speed+math.random(4,9))
	if TheWorld.Map:IsAboveGroundAtPoint(pt.x, 0, pt.z) or TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z) ~= nil then
		inst.count = 0
		projectile.components.complexprojectile:Launch(pt, inst, inst)
	else
		if inst.count < 10 then
			inst.count = inst.count + 1
			inst:DoTaskInTime(0,spawnfriends(inst))
		end
	projectile:Remove()
	end
end
local function oneatenfn(inst, eater)
	inst.count = 0
	if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
				for k = 1,6 do
				inst:DoTaskInTime(0,spawnfriends(inst))
				end
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

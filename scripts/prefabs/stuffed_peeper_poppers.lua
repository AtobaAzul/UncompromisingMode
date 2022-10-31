local assets =
{
    Asset("ANIM", "anim/stuffed_peeper_poppers.zip"),
	Asset("ATLAS", "images/inventoryimages/stuffed_peeper_poppers.xml"),
	Asset("IMAGE", "images/inventoryimages/stuffed_peeper_poppers.tex"),
}

local easing = require("easing")
local function spawnfriends(inst,eater)
    local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab("eyeofterror_mini_projectile_ally")
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
		projectile.player = eater
		projectile.components.complexprojectile:Launch(pt, inst, inst)
	else
		if inst.count < 10 then
			inst.count = inst.count + 1
			inst:DoTaskInTime(0,spawnfriends(inst,eater))
		end
	projectile:Remove()
	end
end

local function oneatenfn(inst, eater)
	inst.count = 0
	if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and not (eater.components.health ~= nil and eater.components.health:IsDead()) and not eater:HasTag("playerghost") then
		for k = 1,2 do
			inst:DoTaskInTime(0,spawnfriends(inst,eater))
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

    inst.AnimState:SetBank("stuffed_peeper_poppers")
    inst.AnimState:SetBuild("stuffed_peeper_poppers")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/stuffed_peeper_poppers.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = -3
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = -15
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(4*TUNING.PERISH_TWO_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst.components.edible:SetOnEatenFn(oneatenfn)
	inst:AddTag("preparedfood")
    return inst
end

return Prefab("stuffed_peeper_poppers", fn, assets)

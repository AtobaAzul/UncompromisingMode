local assets =
{
    Asset("ANIM", "anim/honey_log.zip"),
}

local function oneatenfn(inst, eater)
	if eater:HasTag("plantkin") then
		if eater.components.hunger ~= nil then
			eater.components.hunger:DoDelta(10)
		end
		
		if eater.components.hayfever and eater.components.hayfever.enabled then
			eater.components.hayfever:SetNextSneezeTime(400)			
		end	
	elseif eater:AddTag("werehuman") then
		if eater.components.hunger ~= nil then
			eater.components.hunger:DoDelta(10)
		end
		
		if eater.components.sanity ~= nil then
			eater.components.sanity:DoDelta(5)
		end
		
		if eater.components.hayfever and eater.components.hayfever.enabled then
			eater.components.hayfever:SetNextSneezeTime(300)			
		end	
	else
		if eater.components.hayfever and eater.components.hayfever.enabled then
			eater.components.hayfever:SetNextSneezeTime(300)			
		end	
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("honey_log")
    inst.AnimState:SetBuild("honey_log")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
	inst.components.edible.hungervalue = 5
	inst.components.edible.healthvalue = -10
    inst.components.edible.foodtype = FOODTYPE.GOODIES
	
	inst.components.edible:SetOnEatenFn(oneatenfn)
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/honey_log.xml"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("honey_log", fn, assets)

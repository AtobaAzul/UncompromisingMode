local assets =
{
    Asset("ANIM", "anim/um_halloween_ornaments.zip"),
}


local function fncommon(name, symboloverride)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst, 0.1)

	inst.AnimState:SetBank("um_halloween_ornaments")
	inst.AnimState:SetBuild("um_halloween_ornaments")
	inst.AnimState:PlayAnimation(symboloverride)

	inst:AddTag("halloween_ornament")
	inst:AddTag("molebait")
	inst:AddTag("cattoy")

	MakeInventoryFloatable(inst, "small", 0.1, 0.95)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst.halloween_ornamentbuildoverride = "um_halloween_ornaments"
	inst.halloween_ornamentsymboloverride = symboloverride

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	---------------------
	MakeHauntableLaunch(inst)

	return inst
end

local function fnposs()
    local inst = fncommon("um_ornament_opossum", "decor_1")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function fnrat()
    local inst = fncommon("um_ornament_rat", "decor_2")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("um_ornament_opossum", fnposs, assets, prefabs),
	Prefab("um_ornament_rat", fnrat, assets, prefabs)
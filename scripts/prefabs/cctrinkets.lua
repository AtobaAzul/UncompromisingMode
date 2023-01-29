local function makecctrinkets(name)
local assets =
{
    Asset("ANIM", "anim/cctrinkets.zip"),
	Asset("ATLAS", "images/inventoryimages/cctrinket_"..name..".xml"),
	Asset("IMAGE", "images/inventoryimages/cctrinket_"..name..".tex"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cctrinkets")
    inst.AnimState:SetBuild("cctrinkets")
    inst.AnimState:PlayAnimation(name)
    MakeInventoryFloatable(inst)
	if name == "jazzy" then
	inst.Transform:SetScale(.66,.66,.66)	
	end

	inst:AddTag("specialtrinket_"..name)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst:AddTag("molebait")
    inst:AddTag("cattoy")
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 5
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cctrinket_"..name..".xml"
    return inst
end

return Prefab("cctrinket_"..name, fn, assets)
end
return makecctrinkets("don"),
makecctrinkets("jazzy"),
makecctrinkets("freddo")


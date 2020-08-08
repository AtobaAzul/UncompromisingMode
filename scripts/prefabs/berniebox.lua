local assets =
{
    Asset("ANIM", "anim/berniebox.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("berniebox")
    inst.AnimState:SetBuild("berniebox")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
	
	inst:AddTag("irreplaceable")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/berniebox.xml"

    return inst
end

return Prefab("berniebox", fn, assets)

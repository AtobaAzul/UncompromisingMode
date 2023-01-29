local assets =
{
    Asset("ANIM", "anim/trinket_wathom1.zip"),
}


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("trinket_wathom1")
    inst.AnimState:SetBuild("trinket_wathom1")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/trinket_wathom1.xml"
	
	MakeHauntableLaunch(inst)

    return inst
end

return Prefab("trinket_wathom1", fn, assets)

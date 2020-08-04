local assets =
{
    Asset("ANIM", "anim/lifepen.zip"),
    Asset("ANIM", "anim/bloomershot.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lifepen")
    inst.AnimState:SetBuild("bloomershot")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bloomershot.xml"

    inst:AddComponent("healer")
	inst.components.healer:SetHealthAmount(-10)
	inst.components.healer:Bloomer(true)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("bloomershot", fn, assets)
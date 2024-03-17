local assets =
{
    Asset("ANIM", "anim/brine_balm.zip"),
}

local function OnUse(inst, target)
    if target.components.debuffable ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
        target.components.health:DeltaPenalty(-.125)
        target.configheal = 70
        target.components.debuffable:AddDebuff("confighealbuff", "confighealbuff")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("brine_balm")
    inst.AnimState:SetBuild("brine_balm")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/brine_balm.xml"

    inst:AddComponent("healer")
    inst.components.healer:SetHealthAmount(-TUNING.HEALING_MED)
    inst.components.healer.onhealfn = OnUse
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("brine_balm", fn, assets)

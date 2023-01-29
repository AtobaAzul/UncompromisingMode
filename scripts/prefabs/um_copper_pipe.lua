--https://www.youtube.com/watch?v=FODS-7wDEN0

local assets =
{
    Asset("ANIM", "anim/log.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("log")
    inst.AnimState:SetBuild("log")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.05, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.COPPER
    inst.components.repairer.healthrepairvalue = TUNING.REPAIR_TREEGROWTH_HEALTH --¯\_(ツ)_/¯
    inst.components.repairer.boatrepairsound = "dontstarve/common/chesspile_repair"

    MakeHauntableLaunch(inst)

    ---------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab("um_copper_pipe", fn, assets)

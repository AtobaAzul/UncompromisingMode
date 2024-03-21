--classified prefab for storing in items in the inventory component.
--No need to re-invent the inventory just for the manager component.

local function fn()
    local inst = CreateEntity()

    if TheWorld.ismastersim then
        inst.entity:AddTransform() --So we can save
    end

    inst.entity:AddNetwork()
    inst.entity:AddServerNonSleepable()
    inst.entity:SetCanSleep(false)
    inst.entity:Hide()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("irreplaceable")
    inst:AddTag("garbagepatch_inventory")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("garbagepatch_inventory")

    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 100

    return inst
end

return Prefab("garbagepatch_inventory", fn)
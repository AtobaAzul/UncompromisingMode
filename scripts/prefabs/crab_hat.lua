local assets =
{
    Asset("ANIM", "anim/hat_snowgoggles.zip"),
    Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
    Asset("IMAGE", "images/inventoryimages/gasmask.tex"),
}

local function onequip_crab(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_gore_horn_swap_off", "swap_hat")

    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
    owner.AnimState:Hide("HEAD")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
        owner:AddTag("expert_repairer")
    end
end

local function onunequip_crab(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
        owner:RemoveTag("expert_repairer")
    end
end

local function fn_crab()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_gore_horn")
    inst.AnimState:SetBuild("hat_gore_horn")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.63)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/gore_horn_hat.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip_crab)
    inst.components.equippable:SetOnUnequip(onunequip_crab)

    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    return inst
end

local function onequip_ice(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_gore_horn_swap_off", "swap_hat")

    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
    owner.AnimState:Hide("HEAD")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
        owner:AddTag("wetness_affinity")
    end

    owner.crab_hat_task = owner:DoPeriodicTask(1, function()
        if owner.components.moisture ~= nil then
            inst.components.armor.absorb_percent = Lerp(0.6, 0.95, owner.components.moisture:GetMoisturePercent())
        else
            inst.components.armor.absorb_percent = owner:HasTag("wet") and 0.95 or 0.6
        end
    end, 0)
end

local function onunequip_ice(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
        owner:RemoveTag("wetness_affinity")
    end

    if owner.crab_hat_task ~= nil then
        owner.crab_hat_task:Cancel()
        owner.crab_hat_task = nil
    end
end

local function fn_ice()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_gore_horn")
    inst.AnimState:SetBuild("hat_gore_horn")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.63)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/gore_horn_hat.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip_ice)
    inst.components.equippable:SetOnUnequip(onunequip_ice)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMOR_RUINSHAT, TUNING.ARMORGRASS_ABSORPTION)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("crab_hat", fn_crab, assets), Prefab("crab_hat_ice", fn_ice, assets)

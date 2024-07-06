local assets =
{
    Asset("ANIM", "anim/hat_crab.zip"),
    Asset("ANIM", "anim/swap_hat_crab.zip"),
    Asset("ATLAS", "images/inventoryimages/hat_crab.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_crab.tex"),
}

local function onequip_crab(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "swap_hat_crab", "swap_hat")

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

    inst.AnimState:SetBank("hat_crab")
    inst.AnimState:SetBuild("hat_crab")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")
    inst:AddTag("donotautopick")
    
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.63)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_crab.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip_crab)
    inst.components.equippable:SetOnUnequip(onunequip_crab)

    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    return inst
end

local function OnArmorDamaged(inst, damage_amount)
    inst.absorbed_moisture = inst.absorbed_moisture - damage_amount * 0.5
end

local function onequip_ice(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "swap_hat_crab", "swap_hat") --TODO

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

    owner.hat_crab_task = owner:DoPeriodicTask(0.125, function()
        if owner.components.moisture ~= nil then
            local delta = 1
            if owner.components.moisture.moisture - delta > 0 and inst.absorbed_moisture < (TUNING.ARMOR_RUINSHAT * 0.333) then
                owner.components.moisture:DoDelta(-delta, true)
                inst.absorbed_moisture = math.min(inst.absorbed_moisture + delta, (TUNING.ARMOR_RUINSHAT * 0.333))
            end
			
            inst.components.armor.absorb_percent = Lerp(0.4, 0.90,
                inst.absorbed_moisture / (TUNING.ARMOR_RUINSHAT * 0.333))
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

    if owner.hat_crab_task ~= nil then
        owner.hat_crab_task:Cancel()
        owner.hat_crab_task = nil
    end
end

local function OnSave(inst, data)
    if data ~= nil then
        data.absorbed_moisture = inst.absorbed_moisture
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.absorbed_moisture ~= nil then
        inst.absorbed_moisture = data.absorbed_moisture
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
    inst:AddTag("overchargeable")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)
    inst.components.floater:SetScale(0.63)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad


    inst:ListenForEvent("armordamaged", OnArmorDamaged)

    inst.absorbed_moisture = 0

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

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

return Prefab("hat_crab", fn_crab, assets), Prefab("hat_crab_ice", fn_ice, assets)

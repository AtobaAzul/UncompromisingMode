local assets =
{
    Asset("ANIM", "anim/driftwood_rod_ground.zip"),
    Asset("ANIM", "anim/swap_driftwood_fishingrod.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
}

local function onequip (inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_driftwood_fishingrod", "swap_driftwood_fishingrod")
    owner.AnimState:OverrideSymbol("fishingline", "swap_fishingrod", "fishingline")
    owner.AnimState:OverrideSymbol("FX_fishing", "swap_fishingrod", "FX_fishing")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("fishingline")
    owner.AnimState:ClearOverrideSymbol("FX_fishing")
end

local function onfished(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("driftwood_rod_ground")
    inst.AnimState:SetBuild("driftwood_rod_ground")
    inst.AnimState:PlayAnimation("idle")

    --fishingrod (from fishingrod component) added to pristine state for optimization
    inst:AddTag("fishingrod")

	inst:AddTag("allow_action_on_impassable")

	inst:AddTag("weapon")

    local floater_swap_data = {sym_build = "swap_driftwood_fishingrod"}
    MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8}, true, -12, floater_swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fishingrod")
    inst.components.fishingrod:SetWaitTimes(2, 20)
    inst.components.fishingrod:SetStrainTimes(0, 5)
    -----
    
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.FISHINGROD_DAMAGE)
	inst.components.weapon.attackwear = 4
	-----
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.FISHINGROD_USES * 1.5)
	inst.components.finiteuses:SetUses(TUNING.FISHINGROD_USES * 1.5)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst:ListenForEvent("fishingcollect", onfished)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/driftwoodfishingrod.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("driftwoodfishingrod", fn, assets)

local assets =
{
    Asset("ANIM", "anim/beak_basher_ground.zip"),
    Asset("ANIM", "anim/swap_beak_basher.zip"),
	Asset("IMAGE", "images/inventoryimages/beakbasher.tex"),
	Asset("ATLAS", "images/inventoryimages/beakbasher.xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_beak_basher", "swap_beak_basher")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("beak_basher_ground")
    inst.AnimState:SetBuild("beak_basher_ground")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hammer")

    MakeInventoryFloatable(inst, "med", nil, 0.9)

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51) --Tentacle spike damage, from a massive many tentacled creature.

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/beakbasher.xml"
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER,2) --Significantly improve on the basic hammer efficiency due to how baseline hammer ingredients are.
    -------
    inst:AddComponent("finiteuses") --If we need to nerf the effectiveness as a weapon (We shouldn't need to due to how difficult it is to get), nerf this aspect rather than damage -AXE
    inst.components.finiteuses:SetMaxUses(425) -- About 4.25 tentacle spikes
    inst.components.finiteuses:SetUses(425) -- About 6 (12 including the 2x multiplier if it's always used to 100% efficiency) hammers in 1 slot.

    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	MakeHauntableLaunch(inst)
    return inst
end

return Prefab("beakbasher", fn, assets)

local assets =
{
    Asset("ANIM", "anim/cursed_antler.zip"),
    Asset("ANIM", "anim/swap_cursed_antler.zip"),
}
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	inst.components.weapon:SetDamage(40)
end
local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_cursed_antler", "swap_cursed_antler")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	if not owner:HasTag("vetcurse") then
	inst.components.weapon:SetDamage(0)
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cursed_antler")
    inst.AnimState:SetBuild("cursed_antler")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	--[[
	inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil]]
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(40)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cursed_antler.xml"


    inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    inst._light = nil

    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    inst._onownerequip = function(owner, data)
	if not owner:HasTag("vetcursed") then
	owner.components.inventory:DropItem(inst)
    end
    end

    return inst
end

return Prefab("cursed_antler", fn, assets)

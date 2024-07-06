local assets =
{
    Asset("ANIM", "anim/widowsgrasp.zip"),
    Asset("ANIM", "anim/swap_widowsgrasp.zip"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset("INV_IMAGE", "lantern_lit"),
}


local function onequip(inst, owner)  
    owner.AnimState:OverrideSymbol("swap_object", "swap_widowsgrasp", "swap_widowsgrasp")	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner:AddTag("widowsgrasp")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner:RemoveTag("widowsgrasp")
end


-------------------------------------------------------------------------- Less usage on small cocoons, more on larger cocoons
local function onattack(inst,attaker,target)
	if target:HasTag("webbedcreature") then
		target.components.health:Kill()
	end
	if inst.components.finiteuses.current > 0 and inst.components.finiteuses.current ~= nil then
		if target:HasTag("smallcocoon") then
			inst.components.finiteuses:Use(1)
		elseif target:HasTag("mediumcocoon") then
			inst.components.finiteuses:Use(2)
		elseif target:HasTag("largecocoon") then
			inst.components.finiteuses:Use(3)
		end
	else
		inst.components.finiteuses.onfinished(inst)
	end
end
--------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("widowsgrasp")
    inst.AnimState:SetBuild("widowsgrasp")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddTag("donotautopick")

    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
	inst:AddComponent("weapon")
    inst:AddTag("weapon")
	inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetDamage(17)
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/widowsgrasp.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(9)
    inst.components.finiteuses:SetUses(9)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetIgnoreCombatDurabilityLoss(true)
	
    inst:AddComponent("equippable")

    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("widowsgrasp", fn, assets)

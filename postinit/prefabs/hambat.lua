local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------------------------------------------------------------------------

local function UpdateDamage(inst)
    if inst.components.perishable and inst.components.weapon then
        local dmg = TUNING.HAMBAT_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER/2*TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_DAMAGE)
        inst.components.weapon:SetDamage(dmg)
    end
end

local function onequip(inst, owner)
    UpdateDamage(inst)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ham_bat", inst.GUID, "swap_ham_bat")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ham_bat", "swap_ham_bat")
    end
    
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    UpdateDamage(inst)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

env.AddPrefabPostInit("hambat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	
	if inst.components.perishable ~= nil then
		inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
	end
	
	if inst.components.weapon ~= nil then
		inst.components.weapon:SetOnAttack(UpdateDamage)
	end
	
	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequip)
		inst.components.equippable:SetOnUnequip(onunequip)
	end
end)
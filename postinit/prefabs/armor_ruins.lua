local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_ruins")
    else
		owner.AnimState:OverrideSymbol("swap_body", "armor_ruins", "swap_body")
    end

    inst:ListenForEvent("blocked", OnBlocked, owner)
	
	if owner.prefab == "wortox" then
		owner.components.sanity.neg_aura_mult = TUNING.WORTOX_SANITY_AURA_MULT - 0.25
		owner:AddTag("armorruinssanityaura")
	elseif owner.prefab == "wolfgang" then
        owner.components.sanity.neg_aura_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER - 0.25
		owner:AddTag("armorruinssanityaura")
	elseif owner.prefab == "wendy" then
		owner.components.sanity.neg_aura_mult = TUNING.WENDY_SANITY_MULT - 0.25
		owner:AddTag("armorruinssanityaura")
	else
		owner.components.sanity.neg_aura_mult = 1 - 0.25
		owner:AddTag("armorruinssanityaura")
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
	
	if owner.prefab == "wortox" then
		owner.components.sanity.neg_aura_mult = TUNING.WORTOX_SANITY_AURA_MULT
		owner:RemoveTag("armorruinssanityaura")
	elseif owner.prefab == "wolfgang" then
        owner.components.sanity.neg_aura_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
		owner:RemoveTag("armorruinssanityaura")
	elseif owner.prefab == "wendy" then
		owner.components.sanity.neg_aura_mult = TUNING.WENDY_SANITY_MULT
		owner:RemoveTag("armorruinssanityaura")
	else
		owner.components.sanity.neg_aura_mult = 1
		owner:RemoveTag("armorruinssanityaura")
	end
end

env.AddPrefabPostInit("armorruins", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:AddTag("knockback_protection")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
end)
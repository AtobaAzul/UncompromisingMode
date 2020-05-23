local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_sweatervest", "swap_body")
    inst.components.fueled:StartConsuming()
	
	if owner ~= nil and owner.components.sanity ~= nil and owner.prefab == "wortox" then
		owner.components.sanity.neg_aura_mult = TUNING.WORTOX_SANITY_AURA_MULT - 0.4
		owner:AddTag("sweatervestsanityaura")
	elseif owner ~= nil and owner.components.sanity ~= nil and owner.prefab == "wolfgang" then
        owner.components.sanity.neg_aura_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER - 0.4
		owner:AddTag("sweatervestsanityaura")
	elseif owner ~= nil and owner.components.sanity ~= nil and owner.prefab == "wendy" then
		owner.components.sanity.neg_aura_mult = TUNING.WENDY_SANITY_MULT - 0.4
		owner:AddTag("sweatervestsanityaura")
	elseif owner ~= nil and owner.components.sanity ~= nil then
		owner.components.sanity.neg_aura_mult = 1 - 0.4
		owner:AddTag("sweatervestsanityaura")
	end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
	
	if owner ~= nil and owner.components.sanity ~= nil and owner.prefab == "wortox" then
		owner.components.sanity.neg_aura_mult = TUNING.WORTOX_SANITY_AURA_MULT
		owner:RemoveTag("sweatervestsanityaura")
	elseif owner ~= nil and owner.components.sanity ~= nil and owner.prefab == "wolfgang" then
        owner.components.sanity.neg_aura_mult = TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
		owner:RemoveTag("sweatervestsanityaura")
	elseif owner ~= nil and owner.components.sanity ~= nil and owner.prefab == "wendy" then
		owner.components.sanity.neg_aura_mult = TUNING.WENDY_SANITY_MULT
		owner:RemoveTag("sweatervestsanityaura")
	elseif owner ~= nil and owner.components.sanity ~= nil then 
		owner.components.sanity.neg_aura_mult = 1
		owner:RemoveTag("sweatervestsanityaura")
	end
end

env.AddPrefabPostInit("sweatervest", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
end)
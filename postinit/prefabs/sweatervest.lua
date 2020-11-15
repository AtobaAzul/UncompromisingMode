local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_sweatervest", "swap_body")
    inst.components.fueled:StartConsuming()
	
	if owner.components.sanity ~= nil then
        owner.components.sanity.neg_aura_modifiers:SetModifier(inst, TUNING.BATTLESONG_NEG_SANITY_AURA_MOD - 0.1)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
	
	if owner.components.sanity ~= nil then
        owner.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
    end
end

env.AddPrefabPostInit("sweatervest", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
end)
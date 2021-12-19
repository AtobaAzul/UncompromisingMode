local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("sweatervest", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local _OldOnEquip = inst.components.equippable.onequipfn

	inst.components.equippable.onequipfn = function(inst, owner)
		if owner.components.sanity ~= nil then
			owner.components.sanity.neg_aura_modifiers:SetModifier(inst, 0.3)
		end
		
		if _OldOnEquip ~= nil then
		   _OldOnEquip(inst, owner)
		end
	end
	
	local _OldOnUnequip = inst.components.equippable.onunequipfn
	
	inst.components.equippable.onunequipfn = function(inst, owner)
		if owner.components.sanity ~= nil then
			owner.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
		end
		
		if _OldOnUnequip ~= nil then
		   _OldOnUnequip(inst, owner)
		end
	end
	
end)
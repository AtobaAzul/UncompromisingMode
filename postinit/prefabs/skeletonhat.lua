local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("skeletonhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local _OldOnEquip = inst.components.equippable.onequipfn

	inst.components.equippable.onequipfn = function(inst, owner)
		owner:AddTag("shadowdominant")
		
		if _OldOnEquip ~= nil then
		   _OldOnEquip(inst, owner)
		end
	end
	
	local _OldOnUnequip = inst.components.equippable.onunequipfn
	
	inst.components.equippable.onunequipfn = function(inst, owner)
		owner:RemoveTag("shadowdominant")
		
		if _OldOnUnequip ~= nil then
		   _OldOnUnequip(inst, owner)
		end
	end
	
end)
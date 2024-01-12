local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

if TUNING.DSTU.BERNIE_BUFF then
	env.AddPrefabPostInit("bernie_inactive", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		local _OnEquip = inst.components.equippable.onequipfn
		local _OnUnequip = inst.components.equippable.onunequipfn

		inst.components.equippable.onunequipfn = function(inst, owner)
			owner:RemoveTag("notarget_shadow")
			_OnUnequip(inst, owner)
		end

		inst.components.equippable.onequipfn = function(inst, owner)
			owner:AddTag("notarget_shadow")
			_OnEquip(inst, owner)
		end
	end)
end

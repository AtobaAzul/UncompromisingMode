local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------------------------------------------------------------------------

local function UpdateDamage(inst)
	if inst.components.perishable and inst.components.weapon then
		local dmg = TUNING.HAMBAT_DAMAGE * inst.components.perishable:GetPercent()
		dmg = Remap(dmg, 0, TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER / 2 * TUNING.HAMBAT_DAMAGE,
			TUNING.HAMBAT_DAMAGE)
		inst.components.weapon:SetDamage(dmg)
	end
end

env.AddPrefabPostInit("hambat", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.perishable ~= nil then
		inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
	end

	if inst.components.weapon ~= nil then
		local _OldOnAttack = inst.components.weapon.onattack

		inst.components.weapon.onattack = function(inst)
			if _OldOnAttack ~= nil then
				_OldOnAttack(inst)
			end

			UpdateDamage(inst)
		end
	end

	if inst.components.equippable ~= nil then
		local _OldOnEquip = inst.components.equippable.onequipfn

		inst.components.equippable.onequipfn = function(inst, owner)
			if _OldOnEquip ~= nil then
				_OldOnEquip(inst, owner)
			end

			UpdateDamage(inst)
		end

		local _OldOnUnequip = inst.components.equippable.onunequipfn

		inst.components.equippable.onunequipfn = function(inst, owner)
			if _OldOnUnequip ~= nil then
				_OldOnUnequip(inst, owner)
			end

			UpdateDamage(inst)
		end
	end
end)

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("glasscutter", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if inst.components.weapon ~= nil then
		local _OnAttack = inst.components.weapon.onattack

		inst.components.weapon:SetOnAttack(function(inst, attacker, target, ...)
			if target ~= nil and target:HasTag("shadow_aligned") and not target.components.health:IsDead() and target.components.combat ~= nil then
				target.components.combat:GetAttacked(attacker, 17, nil)
			end

			inst.components.weapon.attackwear = target ~= nil and target:IsValid()
				and target:HasTag("shadow_aligned")
				and TUNING.GLASSCUTTER.SHADOW_WEAR
				or 1

			if _OnAttack ~= nil then
				_OnAttack(inst, attacker, target, ...)
			end
		end)
	end
end)

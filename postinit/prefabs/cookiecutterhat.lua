local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnCooldown(inst)
	inst._cdtask = nil
end

local function OnBlocked(owner, data, inst)
	if inst._cdtask == nil and data ~= nil and not data.redirected then
		--V2C: tiny CD to limit chain reactions
		inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)

		SpawnPrefab("cookiespikes"):SetFXOwner(owner)

		if owner.SoundEmitter ~= nil then
			owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
		end
	end

	if data.attacker ~= nil and data.attacker.components.combat ~= nil and
		not (data.attacker.components.health ~= nil and data.attacker.components.health:IsDead()) and
		(data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
		not data.redirected and
		not data.attacker:HasTag("thorny") and data.attacker.components.combat:CanBeAttacked() and not data.attacker:HasTag("companion") and not data.attacker:HasTag("abigail") then
		local damage = data.attacker.components.combat.defaultdamage *
		(data.attacker.components.combat.playerdamagepercent or 1) * 0.75
		data.attacker.components.combat:GetAttacked(inst, damage)
	end
end

env.AddPrefabPostInit("cookiecutterhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.equippable ~= nil then
		inst._onblocked = function(owner, data) OnBlocked(owner, data, inst) end

		local _OldOnEquip = inst.components.equippable.onequipfn

		inst.components.equippable.onequipfn = function(inst, owner)
			inst:ListenForEvent("blocked", inst._onblocked, owner)
			inst:ListenForEvent("attacked", inst._onblocked, owner)

			if _OldOnEquip ~= nil then
				_OldOnEquip(inst, owner)
			end
		end

		local _OldOnUnequip = inst.components.equippable.onunequipfn

		inst.components.equippable.onunequipfn = function(inst, owner)
			inst:RemoveEventCallback("blocked", inst._onblocked, owner)
			inst:RemoveEventCallback("attacked", inst._onblocked, owner)

			if _OldOnUnequip ~= nil then
				_OldOnUnequip(inst, owner)
			end
		end
	end
end)

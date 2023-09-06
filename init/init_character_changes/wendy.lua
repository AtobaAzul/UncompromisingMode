-- Wendy now only gets the 10% bonus from Abigail, not 40%

--if TUNING.DSTU.WENDY_NERF then
	--local function CustomCombatDamage(inst, target)
		--return (target == inst.components.ghostlybond.ghost and target:HasTag("abigail")) and 0
			--or nil
	--end

	--AddPrefabPostInit("wendy", function (inst)
		--if inst.components.combat ~= nil then
			--inst.components.combat.customdamagemultfn = CustomCombatDamage
		--end
	--end)
--end
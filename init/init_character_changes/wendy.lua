-- Abigal's Flower Mark Debuff brings Wendy's damage up to be HIGHER than every other basic strength character, now thats gone.

local function CustomCombatDamage(inst, target)
	return 1
end

AddPrefabPostInit("wendy", function (inst)
	if inst.components.combat ~= nil then
		inst.components.combat.customdamagemultfn = nil
	end
end)
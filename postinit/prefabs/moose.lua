local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("moose", function(inst)

	if not TheWorld.ismastersim then
		return
	end

	inst.components.combat:SetRange(TUNING.MOOSE_ATTACK_RANGE * 1.1)

end)
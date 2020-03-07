local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("mutatedhound", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.combat ~= nil then
		inst.components.combat:SetAttackPeriod(TUNING.HOUND_ATTACK_PERIOD)
	end
	
	if inst.components.locomotor ~= nil then
		inst.components.locomotor.runspeed = TUNING.MOONHOUND_SPEED * 1.2
	end
end)
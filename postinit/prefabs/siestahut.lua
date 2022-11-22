local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("siestahut", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if TUNING.DSTU.GOTOBED ~= false then
		inst.components.sleepingbag.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK / 2
	end
end)
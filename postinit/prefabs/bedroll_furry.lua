local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("bedroll_furry", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if TUNING.DSTU.GOTOBED ~= false then
		inst.components.sleepingbag.health_tick = TUNING.SLEEP_HEALTH_PER_TICK * 2
	end
end)

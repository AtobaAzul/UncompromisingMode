local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("walrus", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
    if inst.components.health ~= nil then
        inst.components.health:SetMaxHealth(TUNING.WALRUS_HEALTH*TUNING.DSTU.MONSTER_MCTUSK_HEALTH_INCREASE)
    end
end)
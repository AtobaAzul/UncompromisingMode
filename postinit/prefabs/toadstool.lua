local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("toadstool", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DSTU.TOADSTOOL_HEALTH)
	end
	
end)

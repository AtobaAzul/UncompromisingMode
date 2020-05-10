local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("armorruins", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:AddTag("knockback_protection")
	
end)
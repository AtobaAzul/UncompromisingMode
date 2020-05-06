local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("stafflight", function(inst)

	inst:AddTag("snowstorm_protection_high")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("staffcoldlight", function(inst)

	inst:AddTag("snowstorm_protection_high")
	
	if not TheWorld.ismastersim then
		return
	end

end)
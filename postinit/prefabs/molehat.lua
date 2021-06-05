local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("molehat", function(inst)

	inst:AddTag("goggles")

	if not TheWorld.ismastersim then
		return
	end
	
end)

env.AddPrefabPostInit("spiderhat", function(inst)

	inst:AddTag("goggles")

	if not TheWorld.ismastersim then
		return
	end
	
end)

env.AddPrefabPostInit("widowshead", function(inst)

	inst:AddTag("goggles")

	if not TheWorld.ismastersim then
		return
	end
	
end)
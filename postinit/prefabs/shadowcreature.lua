local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("terrorbeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
	end
	
end)

env.AddPrefabPostInit("nightmarebeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
	end
	
end)
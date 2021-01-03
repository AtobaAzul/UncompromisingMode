local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("pigman", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("pigattacker")

end)

env.AddPrefabPostInit("pigguard", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("pigattacker")

end)

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("malbatross", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("hostile")
	
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("rock_ice", function(inst)
	inst:AddTag("salt_workable")

	if not TheWorld.ismastersim then
		return
	end
	
end)
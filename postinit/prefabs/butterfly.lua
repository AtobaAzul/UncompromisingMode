local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("butterfly", function(inst)
	inst:AddTag("noauradamage")
	
	if not TheWorld.ismastersim then
		return
	end
	
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("penguin_ice", function(inst)

    inst:AddTag("penguin_ice_puddle")
	
	if not TheWorld.ismastersim then
		return
	end
	
end)
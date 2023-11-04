local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddPrefabPostInit("dug_sapling", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("tradable") -- For Moondial mutation.
end)

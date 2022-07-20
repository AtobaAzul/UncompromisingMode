local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("stinger", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst:AddComponent("selfstacker")
end)
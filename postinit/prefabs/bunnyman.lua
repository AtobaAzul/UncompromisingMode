local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("bunnyman", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:AddTag("bunnyattacker")
end)

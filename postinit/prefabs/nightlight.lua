local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("nightlight", function(inst)
	if not TheWorld.ismastersim then
		return
	end
inst:AddTag("funkylight")
end)
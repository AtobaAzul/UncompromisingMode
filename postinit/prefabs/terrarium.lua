local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("terrarium", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("terrarium")
end)
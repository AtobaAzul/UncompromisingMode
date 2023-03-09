local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("oasislake", function(inst)
	inst:AddTag("custom_oasis_tag")
end)

env.AddPrefabPostInit("beequeenhive", function(inst)
	inst:AddTag("custom_beequeenhive_tag")
end)
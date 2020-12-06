local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddPrefabPostInit("mushroom_light", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst.components.preserver:SetPerishRateMultiplier(0)

--return inst
end)
env.AddPrefabPostInit("mushroom_light2", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst.components.preserver:SetPerishRateMultiplier(0)

--return inst
end)
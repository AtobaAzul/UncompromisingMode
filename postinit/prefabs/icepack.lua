local env = env
GLOBAL.setfenv(1, GLOBAL)
env.AddPrefabPostInit("icepack", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if inst.components.burnable ~=nil then
	inst:RemoveComponent("burnable")
	end
--return inst
end)
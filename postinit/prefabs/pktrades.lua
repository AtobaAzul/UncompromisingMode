local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("coontail", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1
end)

env.AddPrefabPostInit("hambat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if inst.components.tradable == nil then
		inst:AddComponent("tradable")
	end
	inst.components.tradable.goldvalue = 1
end)
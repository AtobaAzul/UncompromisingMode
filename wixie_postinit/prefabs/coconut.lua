local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("coconut", function(inst)
	
	inst:AddTag("slingshotammo")
	inst:AddTag("reloaditem_ammo")
	
	if not TheWorld.ismastersim then
		return
	end

	inst:AddComponent("reloaditem")
	
end)
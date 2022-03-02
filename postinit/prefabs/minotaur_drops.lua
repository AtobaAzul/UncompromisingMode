local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("minotaur", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:AddComponent("vetcurselootdropper")
	inst.components.vetcurselootdropper.loot = "gore_horn_hat"
	inst.components.lootdropper:AddChanceLoot("skullchest_child_blueprint",1.00)
end)

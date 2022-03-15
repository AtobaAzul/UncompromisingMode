AddPrefabPostInit("minotaur", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end

	if TUNING.DSTU.VETCURSE ~= "off" then
		inst:AddComponent("vetcurselootdropper")
		inst.components.vetcurselootdropper.loot = "gore_horn_hat"
	end
	inst.components.lootdropper:AddChanceLoot("skullchest_child_blueprint",1.00)
end)

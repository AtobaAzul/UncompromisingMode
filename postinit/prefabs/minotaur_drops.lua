AddPrefabPostInit("minotaur", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end

	inst.components.lootdropper:AddChanceLoot("skullchest_child_blueprint",1.00)
end)

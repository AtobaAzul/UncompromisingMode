local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("cookiecutter", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
    if inst.components.lootdropper ~= nil then	
		SetSharedLootTable("cookiecutter",
		{
			{"monstersmallmeat",	1.00},
			{"cookiecuttershell",	0.50},
			{"cookiecuttershell",	0.25},
		})	
	end
	
end)

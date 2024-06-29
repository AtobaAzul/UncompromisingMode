local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("otter", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
    if inst.components.lootdropper ~= nil then	
		SetSharedLootTable("otter",
			{
				{ "meat",            1.00 },
				{ "messagebottle",   0.05 },
			})	
	end
	
end)

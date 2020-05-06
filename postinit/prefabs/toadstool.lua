local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable('toadystool',
{
    {"froglegs",      1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          0.50},
    {"meat",          0.25},

    {"shroom_skin",   1.00},

    {"red_cap",       1.00},
    {"red_cap",       0.33},
    {"red_cap",       0.33},

    {"blue_cap",      1.00},
    {"blue_cap",      0.33},
    {"blue_cap",      0.33},

    {"green_cap",     1.00},
    {"green_cap",     0.33},
    {"green_cap",     0.33},
	{"air_conditioner_blueprint", 1.00},
})

SetSharedLootTable('toadystool_dark',
{
    {"froglegs",      1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          1.00},
    {"meat",          0.50},
    {"meat",          0.25},

    {"shroom_skin",   1.00},
    {"shroom_skin",   1.00},

    {"red_cap",       1.00},
    {"red_cap",       0.33},
    {"red_cap",       0.33},

    {"blue_cap",      1.00},
    {"blue_cap",      0.33},
    {"blue_cap",      0.33},

    {"green_cap",     1.00},
    {"green_cap",     0.33},
    {"green_cap",     0.33},

    {"mushroom_light2_blueprint", 1.00},
    {"sleepbomb_blueprint", 1.00},
	{"air_conditioner_blueprint", 1.00},
})

env.AddPrefabPostInit("toadstool", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DSTU.TOADSTOOL_HEALTH)
	end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable("toadystool")
	end
	
end)

env.AddPrefabPostInit("toadstool_dark", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable("toadystool_dark")
	end
	
end)
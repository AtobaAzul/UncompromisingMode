local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'catty',
{
    {'meat',             1.00},
    {'coontail',		 0.80},
})

env.AddPrefabPostInit("catcoon", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    if inst.components.health ~= nil then
        inst.components.health:SetMaxHealth(TUNING.DSTU.MONSTER_CATCOON_HEALTH_CHANGE)
    end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable('catty')
	end
end)
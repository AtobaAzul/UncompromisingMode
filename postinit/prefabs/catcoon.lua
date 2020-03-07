local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'catcoon',
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
	
	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('catcoon') 
end)
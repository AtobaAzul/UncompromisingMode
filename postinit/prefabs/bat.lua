local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'batty',
{
    {'batwing',    0.15},
    {'guano',      0.15},
    {'monstersmallmeat',0.10},
})

env.AddPrefabPostInit("bat", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetChanceLootTable('batty')
	end
end)

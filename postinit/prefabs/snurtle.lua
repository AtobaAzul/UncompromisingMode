local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

SetSharedLootTable('slurtly',
{
    {'slurtleslime',  1.0},
    {'slurtleslime',  1.0},
    {'slurtlehat',    0.5},
})


local snails =
{
    "slurtle",
    "snurtle"
}
for k, v in ipairs(snails) do
    env.AddPrefabPostInit(v, function(inst)
		if inst.components.health then
			inst.components.health:SetMaxHealth(TUNING.SLURTLE_HEALTH*0.5)
		end
		
        if inst.components.combat then
			inst.components.combat:SetAttackPeriod(TUNING.SLURTLE_ATTACK_PERIOD*0.4)
		end
		
        if v == "slurtle" and inst.components.lootdropper then
            inst.components.lootdropper:SetChanceLootTable('slurtly')
        end
    end)
end
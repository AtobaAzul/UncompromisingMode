local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'catty',
{
    {'meat',             1.00},
    {'coontail',		 0.80},
    {'monstermeat',		 0.66},
})

local function OnAttackOther(inst, data)
    if data.target:HasTag("raidrat") and not data.target.components.health:IsDead() then
		data.target.components.health:Kill()
	end
end

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
	
    inst:ListenForEvent("onattackother", OnAttackOther)
	
end)
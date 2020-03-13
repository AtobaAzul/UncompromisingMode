local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable("shadow_creature_new",
{
    { "nightmarefuel",  0.5 },
})

local function OnDeath(inst, data)
    if data ~= nil and data.afflicter ~= nil and data.afflicter:HasTag("crazy") then
        --max one nightmarefuel if killed by a crazy NPC (e.g. Bernie)
        --inst.components.lootdropper:SetLoot({ "nightmarefuel" })
        --inst.components.lootdropper:SetChanceLootTable(nil)
    end
end

local function onkilledbyother(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
        attacker.components.sanity:DoDelta(TUNING.SANITY_SMALL)
    end
end

env.AddPrefabPostInit("crawlinghorror", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetChanceLootTable('shadow_creature_new')
	end
	
    inst.components.combat.onkilledbyother = onkilledbyother
	inst:ListenForEvent("death", OnDeath)

end)

env.AddPrefabPostInit("terrorbeak", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetChanceLootTable('shadow_creature_new')
	end

    inst.components.combat.onkilledbyother = onkilledbyother
	inst:ListenForEvent("death", OnDeath)
	
end)
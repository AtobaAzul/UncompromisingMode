local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable('corvis_dumbfeatherlmaogottem',
{
    {'feather_crow', 1.0},
    {'feather_crow', 1.0},
    {'feather_crow', 1.0},
    {'corvushat', 1},
})

local function OnAttacked(inst)
	if not inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("land")
	end
end

env.AddPrefabPostInit("carnival_host", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.WALRUS_HEALTH / 2)
	
    inst:AddComponent("combat")
    inst:ListenForEvent("attacked", OnAttacked)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('corvis_dumbfeatherlmaogottem')
end)
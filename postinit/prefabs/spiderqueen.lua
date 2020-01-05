local env = env
GLOBAL.setfenv(1, GLOBAL)
----------------------------------------------------------------
local function OnDead(inst)
    AwardRadialAchievement("spiderqueen_killed", inst:GetPosition(), TUNING.ACHIEVEMENT_RADIUS_FOR_GIANT_KILL)
	local corpse = SpawnPrefab("spiderqueencorpse")
	corpse.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:DoTaskInTime(0.3, function(inst)
	inst:Remove()
	end)
end
env.AddPrefabPostInit("spiderqueen", function(inst)
	inst.entity:AddGroundCreepEntity()
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst.GroundCreepEntity:SetRadius(2)
	inst:ListenForEvent("death", OnDead)
end)
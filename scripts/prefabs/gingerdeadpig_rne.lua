local assets =
{
    Asset("ANIM", "anim/gingerbread_pigman.zip"),
}

local prefabs =
{
    "gingerbreadhouse",
    "wintersfeastfuel",
    "crumbs"
}

local brain = require("brains/gingerdeadpig_rnebrain")

local function OnSpawnedBy(inst, player)
	inst.components.entitytracker:TrackEntity("stalker", player)
	inst:ForceFacePoint(player.Transform:GetWorldPosition())
end

local function OnPlayerNear(inst)
    inst.sg:GoToState("death")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    local COLLISION_MASK = COLLISION.GROUND
                         + COLLISION.LAND_OCEAN_LIMITS
                         + COLLISION.OBSTACLES
                         + COLLISION.SMALLOBSTACLES

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.WORLD)
    inst.Physics:SetCollisionMask(COLLISION_MASK)
    inst.Physics:SetCapsule(0.5, 1)
	
    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("gingerbread_pigman")
    inst.AnimState:SetBuild("gingerbread_pigman")

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("entitytracker")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 0.35

    inst:SetStateGraph("SGgingerdeadpig_rne")
    inst:SetBrain(brain)
    inst:DoTaskInTime(0, function() inst.sg:GoToState("walk_start") end)
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
    inst.components.playerprox:SetDist(6, 10)
    inst.components.playerprox:SetPlayerAliveMode(true)

	inst:WatchWorldState("isday", function() 
		inst.sg:GoToState("death")
	end)
	inst:WatchWorldState("iscaveday", function() 
		inst.sg:GoToState("death")
	end)
	
	inst.OnSpawnedBy = OnSpawnedBy
		
    inst.persists = false
	
	return inst
end

return Prefab("gingerdeadpig_rne", fn, assets, prefabs)

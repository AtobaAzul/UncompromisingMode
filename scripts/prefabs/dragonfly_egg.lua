local assets=
{
	Asset("ANIM", "anim/meteor.zip"),
}

local prefabs = 
{
	"rocks",
	"groundpound_fx",
	"groundpoundring_fx",
}

local loot = 
{
	"flint",
	"rocks",
}

local function cracksound(inst, loudness) --is this worth a stategraph?
	inst:DoTaskInTime(11*FRAMES, function(inst)
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_crack")
	end)
	inst:DoTaskInTime(24*FRAMES, function(inst)
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_bounce")
	end)
end

local function cracksmall(inst)
	inst.AnimState:PlayAnimation("crack_small")
	inst.AnimState:PushAnimation("crack_small_idle", true)
	cracksound(inst, 0.2)
end

local function crackmed(inst)
	inst.AnimState:PlayAnimation("crack_med")
	inst.AnimState:PushAnimation("crack_med_idle", true)
	cracksound(inst, 0.5)
end

local function crackbig(inst)
	inst.AnimState:PlayAnimation("crack_big")
	inst.AnimState:PushAnimation("crack_big_idle", true)
	cracksound(inst, 0.7)
end

local function hatch(inst)
	inst.AnimState:PlayAnimation("egg_hatch")
	
	-- inst:ListenForEvent("animover", function(inst) 
	inst:DoTaskInTime(42*FRAMES, function(inst)
		local dragoon = SpawnPrefab("lavae2")
		dragoon.Transform:SetPosition(inst:GetPosition():Get())
		--dragoon.components.combat:SuggestTarget(GetPlayer())
		dragoon.sg:GoToState("taunt")
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/egg_burst")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		inst.components.lootdropper:DropLoot()
		inst:Remove()
	end)
end

local function groundfn(Sim)
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBuild("dragonfly_egg")
	inst.AnimState:SetBank("dragonfly_egg")
	inst.AnimState:PlayAnimation("egg_idle", false)

	MakeObstaclePhysics(inst, 1.)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(loot)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE*2)
	inst.components.workable:SetOnFinishCallback(
		function(inst, worker)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
			inst.components.lootdropper:DropLoot()
			inst:Remove()
		end)

	inst:DoTaskInTime(0.25 * 10, cracksmall)
	inst:DoTaskInTime(0.5 * 10, crackmed)
	inst:DoTaskInTime(0.75 * 10, crackbig)
	inst:DoTaskInTime(10, hatch)

	return inst
end

local function OnHitInk(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ring = SpawnPrefab("dragonfly_egg")
	ring.Transform:SetPosition(x, 0, z)
	
	inst.components.groundpounder:GroundPound()
	
    inst:Remove()
end

local function oncollide(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y <= inst:GetPhysicsRadius() + 0.001 then
		OnHitInk(inst, other)
	end
end


local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("dragonfly_egg")
    inst.AnimState:SetBuild("dragonfly_egg")
    inst.AnimState:PlayAnimation("egg_loop", true)

	inst.Transform:SetScale(1.1, 1.1, 1.1)
	
    inst.Physics:SetCollisionCallback(oncollide)
end

local function projectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(10)
	inst.Physics:SetFriction(.1)
	inst.Physics:SetDamping(0)
	inst.Physics:SetRestitution(.5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:SetSphere(0.25)

	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, 1 )

    inst.AnimState:SetBank("dragonfly_egg")
    inst.AnimState:SetBuild("dragonfly_egg")
    inst.AnimState:PlayAnimation("egg_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 5, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitInk)
    inst.components.complexprojectile.usehigharc = true

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(20)

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.numRings = 2
    inst.components.groundpounder.burner = true
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpoundringfx = "firering_fx"
    inst.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "dragonfly", "lavae" }
	--[[
	inst:AddComponent("groundpounder")
	inst.components.groundpounder.numRings = 4
	inst.components.groundpounder.ringDelay = 0.1
	inst.components.groundpounder.initialRadius = 1
	inst.components.groundpounder.radiusStepDistance = 2
	inst.components.groundpounder.pointDensity = .25
	inst.components.groundpounder.damageRings = 2
	inst.components.groundpounder.destructionRings = 3
	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.burner = true
    --inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpoundringfx = "firering_fx"
	inst.components.groundpounder.ring_fx_scale = 0.75
    inst.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "dragonfly", "lavae" }
]]
    inst.persists = false

    inst:AddComponent("locomotor")

    return inst
end

return Prefab( "dragonfly_egg", groundfn, assets, prefabs),
	   --Prefab( "dragonfly_egg_falling", fallingfn, assets, prefabs),
	   Prefab( "dragonfly_egg_projectile", projectilefn, assets, prefabs)

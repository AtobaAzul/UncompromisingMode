local assets =
{
    Asset("ANIM", "anim/snowball.zip"),
}

local prefabs =
{
    "splash_snow_fx",
}

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/taunt")
end

local function onnear(inst, target)
    --hive pop open? Maybe rustle to indicate danger?
    --more and more come out the closer you get to the nest?
	if not inst.finished then
		if target.components.health ~= nil and not target.components.health:IsDead() then
			target.components.health:DoDelta(inst.healthvalue or 0)
		end
		
		local fx = SpawnPrefab("wortox_soul_heal_fx")
        fx.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, -50, 0)
        fx:Setup(target)
		
		inst:ListenForEvent("animover", inst.Remove)
		inst.AnimState:PlayAnimation("idle_pst")
		inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
		
		inst.finished = true
	end
end

local function KillSoul(inst)
	inst.finished = true
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("disappear")
    inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("wortox_soul_ball")
    inst.AnimState:SetBuild("ancient_soul_ball")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.finished = false

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(2, 3) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
	
    --inst:AddComponent("inspectable")
	
    inst.OnEntityWake = OnEntityWake
	
	inst:DoTaskInTime(8, KillSoul)
	
    inst.persists = false
	
    return inst
end

local function TestProjectileLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y <= inst:GetPhysicsRadius() + 0.05 then
		local orb = SpawnPrefab("amulet_health_orb")
		orb.Transform:SetPosition(inst.Transform:GetWorldPosition())
		orb.healthvalue = inst.healthvalue
		orb.AnimState:PlayAnimation("idle_pre")
		orb.AnimState:PushAnimation("idle_loop", true)
		inst:Remove()
	end
end

local function OnHitSnow(inst)
	local orb = SpawnPrefab("amulet_health_orb")
    orb.Transform:SetPosition(inst.Transform:GetWorldPosition())
	orb.healthvalue = inst.healthvalue
	orb.AnimState:PlayAnimation("idle_pre")
	orb.AnimState:PushAnimation("idle_loop", true)
    inst:Remove()
end

local function projectile_fn()
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
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:SetSphere(0.25)
	
    inst.AnimState:SetBank("snowball")
    inst.AnimState:SetBuild("snowball")
    inst.AnimState:PlayAnimation("spin_loop", true)
	
	inst.AnimState:SetMultColour(0, 0, 0, 1)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(OnHitSnow)

    inst:AddComponent("locomotor")
	
	inst:DoPeriodicTask(0, TestProjectileLand)

    inst.persists = false

    return inst
end

return Prefab("amulet_health_orb", fn),
		Prefab("amulet_health_orb_projectile", projectile_fn)

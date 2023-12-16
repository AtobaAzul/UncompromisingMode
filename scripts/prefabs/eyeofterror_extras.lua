local assets =
{
    Asset("ANIM", "anim/snowball.zip"),
}

local prefabs =
{
    "splash_snow_fx",
}

local function OnHitFire(inst, attacker, target)
	local firesplash = SpawnPrefab("cursed_firesplash")
    firesplash.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	local x, y, z = inst.Transform:GetWorldPosition() 
	local ents = TheSim:FindEntities(x, y, z, 4, { "_combat" }, { "shadow", "eyeofterror", "INLIMBO" })
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v ~= inst and v:IsValid() and not v:IsInLimbo() then
				if v:IsValid() and not v:IsInLimbo() then
					if v.components.health ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
						local dmg = -5
						
						--if v.components.health.fire_damage_scale > 0 then
							--dmg = dmg * v.components.health.fire_damage_scale
						--end
						
						--if v.components.health.fire_damage_scale == 0 or v.components.health.externalfiredamagemultipliers:Get() <= 0 or v:HasTag("ghost") or
						--v.prefab == "hound_magma" or v.prefab == "firehound" or v.prefab == "wobysmall" or v.prefab == "wobybig" or v.prefab == "stalker_minion1" or v.prefab == "stalker_minion2" then
							--dmg = 0
						--end
						
						v.components.health:DoDelta(dmg, false, "twinofterror2")
					end
					
				end
			end
		end
	end
	
	if math.random() > 0.5 then
		SpawnPrefab("cursed_fire").Transform:SetPosition(x, y, z)
	end
	
    inst:Remove()
end

local function onthrown(inst)
	local fx = SpawnPrefab("cursed_firespawn")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.33)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(0/255, 255/255, 0/255)
	
    inst:AddTag("projectile")
	inst:AddTag("weapon")
	
	MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
	
    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("fire")
    inst.AnimState:SetBuild("fire")
    inst.AnimState:PlayAnimation("level2", true)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
	inst.AnimState:SetMultColour(0, 1, 0, 0.5)
	inst.Transform:SetScale(1.2, 1.2, 1.2)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
	
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 0, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitFire)
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(20, 10)

    return inst
end

local firelevels =
{
    {anim="level1", sound="dontstarve/common/campfire", radius=2, intensity=.75, falloff=.33, colour = {0/255,255/255,0/255}, soundintensity=.1},
    {anim="level2", sound="dontstarve/common/campfire", radius=3, intensity=.8, falloff=.33, colour = {0/255,255/255,0/255}, soundintensity=.3},
    {anim="level3", sound="dontstarve/common/campfire", radius=4, intensity=.8, falloff=.33, colour = {0/255,255/255,0/255}, soundintensity=.6},
    {anim="level4", sound="dontstarve/common/campfire", radius=5, intensity=.9, falloff=.25, colour = {0/255,255/255,0/255}, soundintensity=1},
    {anim="level4", sound="dontstarve/common/forestfire", radius=6, intensity=.9, falloff=.2, colour = {0/255,255/255,0/255}, soundintensity=1},
    {anim="level5", sound="dontstarve/common/forestfire", radius=7, intensity=.9, falloff=.2, colour = {0/255,255/255,0/255}, soundintensity=1},
}

local function Burning(inst)
	local x, y, z = inst.Transform:GetWorldPosition() 
	local ents = TheSim:FindEntities(x, y, z, 4 * inst.Transform:GetScale(), nil, { "shadow", "eyeofterror", "INLIMBO" })
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v ~= inst and v:IsValid() and not v:IsInLimbo() then
				if v:IsValid() and not v:IsInLimbo() then
					if v.components.health ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
						local dmg = -5
						
						--if v.components.health.fire_damage_scale > 0 then
							--dmg = dmg * v.components.health.fire_damage_scale
						--end
						
						--if v.components.health.fire_damage_scale == 0 or v.components.health.externalfiredamagemultipliers:Get() <= 0 or v:HasTag("ghost") or
						--v.prefab == "hound_magma" or v.prefab == "firehound" or v.prefab == "wobysmall" or v.prefab == "wobybig" or v.prefab == "stalker_minion1" or v.prefab == "stalker_minion2" then
							--dmg = 0
						--end
						
						v.components.health:DoDelta(dmg, false, "twinofterror2")
					end
				end
			end
		end
	end
end

local function StartBurning(inst)
	inst:DoPeriodicTask(0.5, Burning)
end

local function KillIt(inst)
	inst.SoundEmitter:KillSound("cursedfire")
	inst:Remove()
end
local function startshrinking(inst, time, startsize, endsize)
	inst.components.sizetweener:StartTween(0.05, 5, KillIt)
end

local function cursedfirefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.25)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(0/255, 255/255, 0/255)

    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("fire")
    inst.AnimState:SetBuild("fire")
    inst.AnimState:PlayAnimation("level4", true)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
	inst.AnimState:SetMultColour(0, 1, 0, 0.5)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("sizetweener")
	inst.startshrinking = startshrinking
	inst:startshrinking()
	
	inst.SoundEmitter:PlaySound("dontstarve/common/forestfire", "cursedfire")
	
	inst:DoTaskInTime(0.5, StartBurning)

    return inst
end

local function cursedfiresplashfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.25)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(0/255, 255/255, 0/255)

    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("dragonfly_ground_fx")
    inst.AnimState:SetBuild("dragonfly_ground_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
	inst.AnimState:SetMultColour(0, 1, 0, 0.5)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst.persists = false

    return inst
end

local function cursedfirespawnfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --inst.entity:AddLight()
    inst.entity:AddNetwork()
	--[[
    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.25)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(0/255, 255/255, 0/255)]]

    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("halloween_embers")
    inst.AnimState:SetBuild("halloween_embers")
    inst.AnimState:PlayAnimation("puff_"..math.random(3))
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
	inst.AnimState:SetMultColour(0, 1, 0, 0.5)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst.persists = false

    return inst
end

local function chargepulsefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(.25)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(255/255, 255/255, 255/255)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("moon_altar_geyser")
    inst.AnimState:SetBuild("moon_geyser")
    inst.AnimState:PlayAnimation("moonpulse")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.Transform:SetScale(0.8, 0.8, 0.8)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst.persists = false

    return inst
end

local COLLAPSIBLE_TAGS = { "_combat", "NPC_workable" }
local NON_COLLAPSIBLE_TAGS = { "eyeofterror", "shadow", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function OnHitInk(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
    --local ents = TheSim:FindEntities(x, 0, z, 4, nil, NON_COLLAPSIBLE_TAGS, COLLAPSIBLE_TAGS)
    --for i, v in ipairs(ents) do
	
	if target ~= nil then
        if target:IsValid() then
            if target.components and target.components.combat ~= nil
                and target.components.health ~= nil
                and not target:HasTag("eyeofterror")
                and not target.components.health:IsDead() then
                if target.components.combat:CanBeAttacked() then
                    target.components.combat:GetAttacked(inst, 30)
					
					local eye_position = target:GetPosition()

					local minion_egg = SpawnPrefab("eyeofterror_mini_projectile")
					minion_egg.Transform:SetPosition(eye_position.x, eye_position.y--[[ + 1.5]], eye_position.z)

					local angle = 360 * math.random()
					minion_egg.Transform:SetRotation(angle)

					angle = -angle * DEGREES
					local radius = minion_egg:GetPhysicsRadius(0) + 5.0
					local angle_vector = Vector3(radius * math.cos(angle), 0, radius * math.sin(angle))

					minion_egg.components.complexprojectile:Launch(eye_position + angle_vector, target)

					if inst.shooter ~= nil then
						inst.shooter.components.commander:AddSoldier(minion_egg)
					end
                end
            end
        end
    end
	
    inst:Remove()
end

local function oncollide(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if other ~= nil and other:IsValid() and other:HasTag("_combat") and not other:HasTag("shadow") and not other:HasTag("eyeofterror") or y <= inst:GetPhysicsRadius() + 0.001 then
		OnHitInk(inst, other)
	end
end

local function onthrown_eye(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("treegrowthsolution_use_fx").Transform:SetPosition(x, 0, z)

    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("eyeofterror_mini")
    inst.AnimState:SetBuild("eyeofterror_mini_mob_build")
    inst.AnimState:PlayAnimation("spin_loop", true)
	
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst:SetPhysicsRadiusOverride(3)
	--inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetCapsule(1.5, 1.5)
	
    inst.Physics:SetCollisionCallback(oncollide)

	inst:DoTaskInTime(3, inst.Remove)
end

local function fneye_proj()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("eyeofterror_mini")
    inst.AnimState:SetBuild("eyeofterror_mini_mob_build")
    inst.AnimState:PlayAnimation("spin_loop", true)
	
    inst:AddTag("NOCLICK")
    inst:AddTag("blunt")
    inst:AddTag("weapon")
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("linearprojectile")
    inst.components.linearprojectile:SetHorizontalSpeed(15)
    inst.components.linearprojectile:SetGravity(-0.1)
    inst.components.linearprojectile:SetLaunchOffset(Vector3(2, 1, 0))
    inst.components.linearprojectile:SetOnLaunch(onthrown_eye)
    inst.components.linearprojectile:SetOnHit(OnHitInk)
    inst.components.linearprojectile.usehigharc = false

    inst.persists = false

    inst:AddComponent("locomotor")

    return inst
end

return Prefab("eyeofterror_fireball", fn, assets, prefabs),
		Prefab("cursed_fire", cursedfirefn, assets, prefabs),
		Prefab("cursed_firesplash", cursedfiresplashfn, assets, prefabs),
		Prefab("cursed_firespawn", cursedfirespawnfn, assets, prefabs),
		Prefab("eyeofterror_chargepulse", chargepulsefn, assets, prefabs),
		Prefab("eyeofterror_minieye_projectile", fneye_proj, assets, prefabs)
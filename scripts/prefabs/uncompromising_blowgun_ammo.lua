-- temp aggro system for the slingshots
local function no_aggro(attacker, target)
	local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker:IsValid()
			and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
			and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function ImpactFx(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx ~= nil and target.components.combat then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        if attacker ~= nil and attacker:IsValid() then
            impactfx:FacePoint(attacker.Transform:GetWorldPosition())
        end
    end
    inst:Remove()
end

local function OnAttack(inst, attacker, target)
	if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() then
		if inst.ammo_def ~= nil and inst.ammo_def.onhit ~= nil then
			inst.ammo_def.onhit(inst, attacker, target)
		end
		ImpactFx(inst, attacker, target)
	end
end



local function OnHit(inst, attacker, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
		target.components.combat.temp_disable_aggro = false
	end
    inst:Remove()
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function SpawnShadowTentacle(target, pt, starting_angle)
    local offset = FindWalkableOffset(pt, starting_angle, 2, 3, false, true, NoHoles)
    if offset ~= nil then
        local tentacle = SpawnPrefab("shadowtentacle")
        if tentacle ~= nil then
            tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
            tentacle.components.combat:SetTarget(target)

			tentacle.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shadowTentacleAttack_1")
			tentacle.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shadowTentacleAttack_2")
        end
    end
end

local function OnHit_Thulecite(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    if math.random() < 0.5 then
        local pt
        if target ~= nil and target:IsValid() then
            pt = target:GetPosition()
        else
            pt = inst:GetPosition()
            target = nil
        end

		local theta = math.random() * 2 * PI
		SpawnShadowTentacle(target, pt, theta)
    end

    inst:Remove() 
end

local function onloadammo_ice(inst, data)
	if data ~= nil and data.slingshot then
		data.slingshot:AddTag("extinguisher")
	end
end

local function onunloadammo_ice(inst, data)
	if data ~= nil and data.slingshot then
		data.slingshot:RemoveTag("extinguisher")
	end
end

local function OnHit_Ice(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.burnable ~= nil then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end

    if target.components.freezable ~= nil then
        target.components.freezable:AddColdness(TUNING.SLINGSHOT_AMMO_FREEZE_COLDNESS)
        target.components.freezable:SpawnShatterFX()
    else
        local fx = SpawnPrefab("shatter")
        fx.Transform:SetPosition(target.Transform:GetWorldPosition())
        fx.components.shatterfx:SetLevel(2)
    end

    if not no_aggro(attacker, target) and target.components.combat ~= nil then
        target.components.combat:SuggestTarget(attacker)
    end

    inst:Remove()
end

local function OnHit_Speed(inst, attacker, target)
    ImpactFx(inst, attacker, target)

	local debuffkey = inst.prefab

	if target ~= nil and target:IsValid() and target.components.locomotor ~= nil then
		if target._slingshot_speedmulttask ~= nil then
			target._slingshot_speedmulttask:Cancel()
		end
		target._slingshot_speedmulttask = target:DoTaskInTime(TUNING.SLINGSHOT_AMMO_MOVESPEED_DURATION, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._slingshot_speedmulttask = nil end)

		target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, TUNING.SLINGSHOT_AMMO_MOVESPEED_MULT)
	end

    inst:Remove()
end

local function OnHit_Distraction(inst, attacker, target)
	ImpactFx(inst, attacker, target)
 
	if target ~= nil and target:IsValid() and target.components.combat ~= nil then
		local targets_target = target.components.combat.target
		if targets_target == nil or targets_target == attacker then
			target:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })

			if not target:HasTag("epic") then
				target.components.combat:DropTarget()
			end
		end
	end

    inst:Remove()
end

local function fireattack(inst, attacker, target)
    if not target:IsValid() then
        --target killed or removed in combat damage phase
        return
    end

    target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
    target:PushEvent("attacked", {attacker = attacker, damage = 0})
    if target.components.burnable then
        target.components.burnable:Ignite(nil, attacker)
    end
    if target.components.freezable then
        target.components.freezable:Unfreeze()
    end
    if target.components.health then
        target.components.health:DoFireDamage(0, attacker)
    end
    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
    end
end

local function sleepattack(inst, attacker, target)
    if not target:IsValid() then
        --target killed or removed in combat damage phase
        return
    end

    target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_sleep")

    if target.components.sleeper ~= nil then
        target.components.sleeper:AddSleepiness(1, 15, inst)
    elseif target.components.grogginess ~= nil then
        target.components.grogginess:AddGrogginess(1, 15)
    end

    if target.components.combat ~= nil and not target:HasTag("player") then
        target.components.combat:SuggestTarget(attacker)
    end
    target:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })
end

local function yellowattack(inst, attacker, target)
    --target could be killed or removed in combat damage phase
    if target:IsValid() then
        SpawnPrefab("electrichitsparks"):AlignToTarget(target, inst)
    end
end

local function OnMiss(inst, owner, target)
    inst:Remove()
end

local function projectile_fn(ammo_def)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    MakeProjectilePhysics(inst)

    inst.AnimState:SetBank("blow_dart")
    inst.AnimState:SetBuild("blow_dart")
    inst.AnimState:PlayAnimation(ammo_def.anim, true)

	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

	if ammo_def.tags then
		for _, tag in pairs(ammo_def.tags) do
			inst:AddTag(tag)
		end
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

	inst.ammo_def = ammo_def

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(ammo_def.damage)
	inst.components.weapon:SetOnAttack(OnAttack)
	if ammo_def.electric then
	inst.components.weapon:SetElectric()	
	end
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile.range = 30
	inst.components.projectile.has_damage_set = true
	inst.components.projectile:SetLaunchOffset(Vector3(0, 1, 0))
	inst.components.projectile:SetHitDist(1.4)
    return inst
end

local function inv_fn(ammo_def)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("um_darts")
    inst.AnimState:SetBuild("um_darts")
    inst.AnimState:PlayAnimation(ammo_def.anim)
	inst:AddTag("um_dart")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/"..ammo_def.name..".xml"

    MakeHauntableLaunch(inst)


	if ammo_def.onloadammo ~= nil and ammo_def.onunloadammo ~= nil then
		inst:ListenForEvent("ammoloaded", ammo_def.onloadammo)
		inst:ListenForEvent("ammounloaded", ammo_def.onunloadammo)
		inst:ListenForEvent("onremove", ammo_def.onunloadammo)
	end

    return inst
end

local ammo =
{
	{
		name = "blowgunammo_tooth",
		damage = 100,
		anim = "dart_pipe",
	},
	{
		name = "blowgunammo_fire",
		damage = 0,
		onhit = fireattack,
		anim = "dart_red",
	},
	{
		name = "blowgunammo_sleep",
		damage = 0,
		onhit = sleepattack,
		anim = "dart_purple",
	},
	{
		name = "blowgunammo_electric",
		damage = TUNING.YELLOW_DART_DAMAGE,
		onhit = yellowattack,
		anim = "dart_yellow",
		electric = true
	},
}

local ammo_prefabs = {}
for _, v in ipairs(ammo) do
	--v.impactfx = "slingshotammo_hitfx_" .. (v.symbol or "rocks")

	---
	if not v.no_inv_item then
		table.insert(ammo_prefabs, Prefab(v.name, function() return inv_fn(v) end))
	end


	table.insert(ammo_prefabs, Prefab(v.name.."_proj", function() return projectile_fn(v) end))
end


return unpack(ammo_prefabs)
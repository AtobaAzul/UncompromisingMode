local prefabs =
{
    "nightmarefuel",
    "shadowtentacle",
    "uncompromising_shadow_projectile1_fx",
    "uncompromising_shadow_projectile2_fx",
}

local assets =
{
    Asset("ANIM", "anim/creepingfear.zip"), -----------------------------------------
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature1/die",
    idle = "dontstarve/sanity/creature2/idle",
    taunt = "dontstarve/sanity/creature1/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}

local brain = require("brains/shadowcreaturebrain") -----------------------------------------

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function SpawnTentacles(inst, target)
    local pt = target:GetPosition()
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3, false, true, NoHoles)
    if offset ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
        inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
        local tentacle = SpawnPrefab("shadowtentacle")
        local fx2 = SpawnPrefab("uncompromising_shadow_projectile2_fx")
        if tentacle ~= nil then
            fx2.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
            --fx2.Transform:SetScale(1, 1, 1)
            tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
			if not target:HasTag("shadowdominant") then
				tentacle.components.combat:SetTarget(target)
			end
            tentacle.components.combat:SetDefaultDamage(TUNING.DSTU.CREEPINGFEAR_DAMAGE * 0.50)
            tentacle.Transform:SetScale(1.2, 1.2, 1.2)
        end
    end
end

local function SpikeWaves(inst, target)
    local target_index = {}
    local found_targets = {}
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    local px, py, pz = target.Transform:GetWorldPosition()
    local rad = math.rad(inst:GetAngleToPoint(px, py, pz))
    local velx = math.cos(rad) * 2
    local velz = -math.sin(rad) * 2
    inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
    inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
    for i = 1,20 do
        inst:DoTaskInTime(FRAMES * i --[[* 1.5]], function()
            local dx, dy, dz = ix + (i * velx), 0, iz + (i * velz)
            local fx1 = SpawnPrefab("uncompromising_shadow_projectile1_fx_fast")
            fx1.Transform:SetPosition(dx, dy, dz)
            inst:DoTaskInTime(.6, function()
                inst.SoundEmitter:PlaySound("dontstarve/sanity/creature2/attack")
                local ents = TheSim:FindEntities(dx, dy, dz, 1.5, nil, { "FX", "NOCLICK", "INLIMBO", "shadowdominant" })
                for k,v in ipairs(ents) do
                    if not target_index[v] and v ~= inst and inst.components.combat:IsValidTarget(v) and v.components.combat and ((v.components.sanity and v.components.sanity:IsInsane()) or v == target) and not v:HasTag("shadowdominant") then
                        target_index[v] = true
                        v.components.combat:GetAttacked(inst, TUNING.DSTU.CREEPINGFEAR_DAMAGE)
                    end
                end
            end)
        end)
    end
end

local function CancelSpikewaves(inst)
    if inst.spiketask ~= nil then
        inst.spiketask:Cancel()
        inst.spiketask = nil
    end
end

local function CreepinFearTimer(inst)
    local target = inst.components.combat.target
    if inst.sp_atk_cd <= 0 and inst.components.combat:HasTarget() and not inst.sg:HasStateTag("busy") then
        if target:IsValid() and not target:HasTag("shadowdominant") then
            inst.sg:GoToState("taunt")
            local init_pos = inst:GetPosition()
            local target_pos = target:GetPosition()
            if math.random() < 0.5 and distsq(target_pos, init_pos) < 900 then
                CancelSpikewaves(inst)
                SpikeWaves(inst, target)
                inst.spiketask = inst:DoPeriodicTask(1, function() SpikeWaves(inst, target) end)
                inst:DoTaskInTime(2.1, function() CancelSpikewaves(inst) inst.spiketask = nil end)
            else
                SpawnTentacles(inst, target)
                inst:DoTaskInTime(1, function() SpawnTentacles(inst, target) end)
                inst:DoTaskInTime(2, function() SpawnTentacles(inst, target) end)
            end
            inst.sp_atk_cd = 20
		else
            inst.sp_atk_cd = 20
        end
    end
    if target ~= nil then
        inst.persists = true
    else
        inst.persists = false
    end
    inst.sp_atk_cd = inst.sp_atk_cd - 1
end

local function retargetfn(inst)
    local maxrangesq = TUNING.SHADOWCREATURE_TARGET_DIST * TUNING.SHADOWCREATURE_TARGET_DIST
    local rangesq, rangesq1, rangesq2 = maxrangesq, math.huge, math.huge
    local target1, target2 = nil, nil
    for i, v in ipairs(AllPlayers) do
        if v.components.sanity:IsInsane() and not v:HasTag("playerghost") and not v:HasTag("notarget_shadow") then
            local distsq = v:GetDistanceSqToInst(inst)
            if distsq < rangesq then
                if inst.components.shadowsubmissive:TargetHasDominance(v) then
                    if distsq < rangesq1 and inst.components.combat:CanTarget(v) then
                        target1 = v
                        rangesq1 = distsq
                        rangesq = math.max(rangesq1, rangesq2)
                    end
                elseif distsq < rangesq2 and inst.components.combat:CanTarget(v) then
                    target2 = v
                    rangesq2 = distsq
                    rangesq = math.max(rangesq1, rangesq2)
                end
            end
        end
    end

    if target1 ~= nil and rangesq1 <= math.max(rangesq2, maxrangesq * .25) then
        --Targets with shadow dominance have higher priority within half targeting range
        --Force target switch if current target does not have shadow dominance
        return target1, not inst.components.shadowsubmissive:TargetHasDominance(inst.components.combat.target)
    end
    return target2
end

local function NotifyBrainOfTarget(inst, target)
    if inst.brain ~= nil and inst.brain.SetTarget ~= nil then
        inst.brain:SetTarget(target)
    end
end

local function onkilledbyother(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
	
		inst.sanityreward = (attacker.components.sanity.max * 0.25) + 10
	
        attacker.components.sanity:DoDelta(inst.sanityreward)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 15, { "player" }, { "playerghost" } )
		
		for i, v in ipairs(ents) do
			if v ~= attacker and v.components.sanity ~= nil and v.components.sanity:IsInsane() then
				inst.halfreward = ((v.components.sanity.max * 0.25) + 10) / 2
				inst.quarterreward = ((v.components.sanity.max * 0.25) + 10) / 4
				
				v.components.sanity:DoDelta(inst.halfreward)
				
				if v.components.sanity:IsInsane() then
					v.components.sanity:DoDelta(inst.halfreward)
				else
					v.components.sanity:DoDelta(inst.quarterreward)
				end
			end
		end
    end
end

local function CalcSanityAura(inst, observer)
    return inst.components.combat:HasTarget()
        and observer.components.sanity:IsCrazy()
        and -TUNING.SANITYAURA_LARGE
        or 0
end

local function ShareTargetFn(dude)
    return dude:HasTag("shadowcreature") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 1)
    inst.hitcount = inst.hitcount - 1
end

local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

local function OnDeath(inst, data)
    if data ~= nil and data.afflicter ~= nil and data.afflicter:HasTag("crazy") then
        --max one nightmarefuel if killed by a crazy NPC (e.g. Bernie)
        inst.components.lootdropper:SetLoot({ "nightmarefuel" })
        inst.components.lootdropper:SetChanceLootTable(nil)
    end
end

local function OnSave(inst, data)
    --data.maxhealth = inst.components.health.maxhealth or nil
    --data.damage = inst.components.combat.defaultdamage or nil
    data.sp_atk_cd = inst.sp_atk_cd or nil
    data.hitcount = inst.hitcount or nil
end

local function OnPreLoad(inst, data)
    if data ~= nil then
        --if data.maxhealth then
        --    inst.components.health:SetMaxHealth(data.maxhealth)
        --end
        --if data.damage then
        --    inst.components.combat:SetDefaultDamage(data.damage)
        --end
        if data.sp_atk_cd then
            inst.sp_atk_cd = data.sp_atk_cd
        end
        if data.hitcount then
            inst.hitcount = data.hitcount
        end
    end
end

local function ConsumeShadow(inst, other, damage)
	print("eaty")
	if other:HasTag("shadowcreature") then
		print("shadow")
		local x, y, z = other.Transform:GetWorldPosition()
		local shadowdespawnfx = SpawnPrefab("shadow_despawn")
		shadowdespawnfx.Transform:SetPosition(x, y, z)
		
		other:Remove()
		inst.components.health:DoDelta(inst.components.health.maxhealth * 0.2)
		
		inst.size = inst.size + 0.1
		if inst.size < 1.8 then
			inst.Transform:SetScale(inst.size, inst.size, inst.size)
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, 1.5)
    RemovePhysicsColliders(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --inst.Physics:CollidesWith(COLLISION.WORLD)

    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst:AddTag("shadowcreature")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")
	inst:AddTag("creepingfear")
    --inst:AddTag("epic")
    inst:AddTag("notraptrigger")

    inst.AnimState:SetBank("creepingfear")
    inst.AnimState:SetBuild("creepingfear")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD)
	inst.AnimState:SetSortOrder(5)
    inst:AddComponent("transparentonsanity")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.size = 1.2
    inst.hitcount = 3
    inst.sp_atk_cd = 15

    inst:AddComponent("uncompromising_shadowfollower")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.DSTU.CREEPINGFEAR_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.DSTU.CREEPINGFEAR_RUN_SPEED
    --inst.components.locomotor.pathcaps = { allowocean = true }
	inst.components.locomotor:SetTriggersCreep(false)
    inst.sounds = sounds
    inst:SetStateGraph("SGcreepingfear")

    inst:SetBrain(brain)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health.nofadeout = true

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.DSTU.CREEPINGFEAR_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.DSTU.CREEPINGFEAR_RANGE_1, TUNING.DSTU.CREEPINGFEAR_RANGE_2)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat:SetRetargetFunction(3, retargetfn)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODGROUP.SHADOWCREATURE }, { FOODGROUP.SHADOWCREATURE })
	inst.components.eater:SetOnEatFn(ConsumeShadow)

    --if TheWorld.state.cycles then
    --    inst.components.health:SetMaxHealth(1200 + (math.min(TheWorld.state.cycles, 100) *  38))
    --    inst.components.combat:SetDefaultDamage(50 + (math.min(TheWorld.state.cycles, 100) *  0.4))
    --else
        inst.components.health:SetMaxHealth(TUNING.DSTU.CREEPINGFEAR_HEALTH)
        inst.components.combat:SetDefaultDamage(TUNING.DSTU.CREEPINGFEAR_DAMAGE)
    --end

    inst:AddComponent("shadowsubmissive")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "nightmarefuel","nightmarefuel" ,"nightmarefuel"  })

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
    inst:ListenForEvent("death", OnDeath)

    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad

    inst:DoPeriodicTask(1, function() CreepinFearTimer(inst) end)

    inst.persists = true

    return inst
end


return Prefab("creepingfear", fn, assets)
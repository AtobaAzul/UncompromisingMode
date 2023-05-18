require "brains/old_shadowwaxwellbrain"
require "stategraphs/SGold_shadowwaxwell"

local assets = 
{
    Asset("ANIM", "anim/waxwell_shadow_mod.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
	Asset("ANIM", "anim/swap_pickaxe.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_nightmaresword.zip"),
}

local prefabs = 
{

}

local function retargetfn(inst)
    --retarget nearby players if current target is fleeing or not a player
	local target = inst.components.combat.target

    local x, y, z = inst.Transform:GetWorldPosition()
	local players = TheSim:FindEntities(x, y, z, 40, { "player" })
    local rangesq = math.huge
    for i, v in ipairs(players) do
        local distsq = v:GetDistanceSqToPoint(x, y, z)
		
		local clones = TheSim:FindEntities(x, y, z, 40, { "shadow_wixie" })
		for n, b in ipairs(clones) do
			if #clones == 1 or b ~= inst and (b.components.combat.target == nil or b.components.combat.target ~= v) then
				if distsq < rangesq and inst.components.combat:CanTarget(v) and (target == nil) then
					rangesq = distsq
					target = v
				end
			end
		end
    end
    return target, true
end

local function KeepTargetFn(inst, target)
    local x, y, z = inst.Transform:GetWorldPosition()
		
	local clones = TheSim:FindEntities(x, y, z, 40, { "shadow_wixie" })
	for n, b in ipairs(clones) do
		if b ~= inst and b.components.combat.target ~= nil and b.components.combat.target == target then
			return false
		end
	end
	
    return true
end

local function OnAttacked(inst, data)
	if data ~= nil then
		inst.components.combat:SetTarget(data.attacker)
	end
end

local function OnDamaged(inst, data)
	local amount = data.amount or 0

	inst.decoy_attack_count = inst.decoy_attack_count + amount
	
	if inst.decoy_attack_count <= -1500 then
		inst.decoy_attack = true
	end

	inst.marble_bag_attack_count = inst.marble_bag_attack_count + amount

	if inst.marble_bag_attack_count <= -250 then
		if inst.components.health:GetPercent() <= 0.75 then
			inst.marble_bag_attack_count = 0
			inst.marble_bag_attack = true
		end
	end

	inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/appear")
			
	local x, y, z = inst.Transform:GetWorldPosition()
	local clones = TheSim:FindEntities(x, y, z, 40, { "shadow_wixie_clone" })
			
	for i, v in pairs(clones) do
		if v ~= nil and v:IsValid() then
			SpawnPrefab("shadow_despawn").Transform:SetPosition(v.Transform:GetWorldPosition())

			if v.physbox ~= nil then
				v.physbox:Remove()
			end

			v:Remove()
		end
	end
	
	inst.force_invincible_value = inst.force_invincible_value + amount
	
	if inst.force_invincible_value <= -500 then
		inst.sg:GoToState("disappear")
	elseif inst.sg.currentstate.name == "trickster" then
		inst.sg:GoToState("claustrophobia")
	end
end

local function PushMusic(inst, level)
    if ThePlayer == nil or inst:HasTag("flight") or IsEntityDead(inst) then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("playwixiemusic", { name = "wixie", level = level })
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 50) then
        inst._playingmusic = false
    end
end

local function OnMusicDirty(inst)
    --Dedicated server does not need to trigger music
    if not TheNet:IsDedicated() then
        if inst._musictask ~= nil then
            inst._musictask:Cancel()
        end
        local level = inst._pausemusic:value() and 2 or (inst._unchained:value() and 3 or 1)
        inst._musictask = inst:DoPeriodicTask(1, PushMusic, nil, level)
        PushMusic(inst, level)
    end
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced(inst)

    MakeCharacterPhysics(inst, 10, .25)
    RemovePhysicsColliders(inst)
    inst.Physics:SetCollisionGroup(COLLISION.SANITY)
	inst.Physics:CollidesWith(COLLISION.SANITY)

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wixie") -- "waxwell_shadow_mod" Deprecated.
	inst.AnimState:HideSymbol("face")
    inst.AnimState:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
	
	
    inst.AnimState:AddOverrideBuild("waxwell_minion_spawn")
    inst.AnimState:AddOverrideBuild("waxwell_minion_appear")
    inst.AnimState:AddOverrideBuild("lavaarena_shadow_lunge")
    inst.AnimState:SetMultColour(0, 0, 0, .6)
	inst.AnimState:UsePointFiltering(true)

	inst.AnimState:PlayAnimation("idle")

    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")

    inst:AddTag("epic")
    inst:AddTag("hostile")
    inst:AddTag("notraptrigger")
    inst:AddTag("shadowchesspiece")
	inst:AddTag("shadowcreature")
	inst:AddTag("shadow_wixie")
	inst:AddTag("prime_shadow_wixie")

    inst._unchained = net_bool(inst.GUID, "klaus._unchained", "musicdirty")
    inst._pausemusic = net_bool(inst.GUID, "klaus_pausemusic", "musicdirty")
    inst._playingmusic = false
    inst._musictask = nil
    OnMusicDirty(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("musicdirty", OnMusicDirty)
		
        return inst
    end
	
	inst.decoy_attack = false
	inst.decoy_attack_count = 0
	inst.force_invincible_value = 0
	inst.marble_bag_attack_count = 0
	inst.stunned_count = 0
	inst.marble_bag_attack = false
	inst.helper = false

	inst.AnimState:OverrideSymbol("swap_object", "swap_slingshot", "swap_slingshot")
	inst.AnimState:Show("ARM_carry") 
	inst.AnimState:Hide("ARM_normal")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 8
	inst.components.locomotor.runspeed = 20
	inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor:SetSlowMultiplier(.6)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(5000)
    --inst.components.health:SetMaxDamageTakenPerHit(1)
    inst.components.health.destroytime = 3
    inst.components.health.fire_damage_scale = TUNING.WILLOW_FIRE_DAMAGE
	
    inst:AddComponent("colourtweener")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(5, 1)
    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetRetargetFunction(1, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"nightmarefuel", "nightmarefuel", "nightmarefuel", "the_real_charles_t_horse"})

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.penalty = TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY
	
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("healthdelta", OnDamaged)
    inst:ListenForEvent("death", function()
		if inst.physbox ~= nil then
			inst.physbox:Remove()
		end 
	end)
    inst:ListenForEvent("removed", function()
		if inst.physbox ~= nil then
			inst.physbox:Remove()
		end 
	end)

	local brain = require"brains/shadow_wixie"
	inst:SetBrain(brain)

	inst:SetStateGraph("SGshadow_wixie")

	inst:DoTaskInTime(0, function()
		if not inst:HasTag("puzzlespawn") then
			if inst.physbox ~= nil then
				inst.physbox:Remove()
			end
			
			inst:Remove()
		end
	end)
	
	inst:WatchWorldState("cycles", function() 
		if not inst.components.health:IsDead() then
		
			local wixie_clock = TheSim:FindFirstEntityWithTag("wixie_clock")
			wixie_clock.canbeused = true
			wixie_clock.MakeUsable(wixie_clock)
			
			local x, y, z = inst.Transform:GetWorldPosition()
			
			SpawnPrefab("statue_transition").Transform:SetPosition(x, y, z)
			SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
			
			if inst.physbox ~= nil then
				inst.physbox:Remove()
			end
			
			inst:Remove()
		end
	end)
	
	inst.persists = false

	return inst
end

local function helperfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced(inst)

    MakeCharacterPhysics(inst, 10, .25)
    RemovePhysicsColliders(inst)
    inst.Physics:SetCollisionGroup(COLLISION.SANITY)
	inst.Physics:CollidesWith(COLLISION.SANITY)

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wixie") -- "waxwell_shadow_mod" Deprecated.
	inst.AnimState:HideSymbol("face")
    inst.AnimState:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
	
	
    inst.AnimState:AddOverrideBuild("waxwell_minion_spawn")
    inst.AnimState:AddOverrideBuild("waxwell_minion_appear")
    inst.AnimState:AddOverrideBuild("lavaarena_shadow_lunge")
    inst.AnimState:SetMultColour(0, 0, 0, .6)
	inst.AnimState:UsePointFiltering(true)

	inst.AnimState:PlayAnimation("idle")

    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")

    inst:AddTag("hostile")
    inst:AddTag("notraptrigger")
    inst:AddTag("shadowchesspiece")
	inst:AddTag("shadowcreature")
    inst:AddTag("shadow_wixie")
    inst:AddTag("shadow_wixie_helper")
    inst:AddTag("shadow_wixie_clone")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.stunned_count = 0
	inst.helper = true

	inst.AnimState:OverrideSymbol("swap_object", "swap_slingshot", "swap_slingshot")
	inst.AnimState:Show("ARM_carry") 
	inst.AnimState:Hide("ARM_normal")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 8
	inst.components.locomotor.runspeed = 20
	inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor:SetSlowMultiplier(.6)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1)
    inst.components.health:SetMaxDamageTakenPerHit(1)
    inst.components.health.destroytime = 1
    inst.components.health.fire_damage_scale = TUNING.WILLOW_FIRE_DAMAGE
	
    inst:AddComponent("colourtweener")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(5, 1)
    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetRetargetFunction(2, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.penalty = TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY

	local brain = require"brains/shadow_wixie"
	inst:SetBrain(brain)

	inst:SetStateGraph("SGshadow_wixie")
    inst:ListenForEvent("death", function()
		if inst.physbox ~= nil then
			inst.physbox:Remove()
		end 
	end)
    inst:ListenForEvent("removed", function()
		if inst.physbox ~= nil then
			inst.physbox:Remove()
		end 
	end)

	inst:DoTaskInTime(0, function()
		if not inst:HasTag("puzzlespawn") then
			if inst.physbox ~= nil then
				inst.physbox:Remove()
			end
			
			inst:Remove()
		end
	end)
	
	inst:WatchWorldState("cycles", function() 
		if not inst.components.health:IsDead() then
			
			local x, y, z = inst.Transform:GetWorldPosition()
			
			SpawnPrefab("statue_transition").Transform:SetPosition(x, y, z)
			SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
			
			if inst.physbox ~= nil then
				inst.physbox:Remove()
			end
			
			inst:Remove()
		end
	end)
	
	inst.persists = false

	return inst
end

local function OnHitLazy(inst, attacker, target)
	
	local pt = inst:GetPosition()
	if inst.caster ~= nil and inst.thisistheone then
		if TheWorld.Map:IsPassableAtPoint(pt.x, 0, pt.z) then
			inst.caster.Physics:Teleport(pt:Get())
		end
		
		inst.caster.sg:GoToState("trickster")
			
		local x, y, z = inst.Transform:GetWorldPosition()
		local clones = TheSim:FindEntities(x, y, z, 40, { "shadow_wixie_helper" })
				
		for i, v in pairs(clones) do
			if v ~= nil and v ~= inst and v:IsValid() then
				SpawnPrefab("shadow_despawn").Transform:SetPosition(v.Transform:GetWorldPosition())

				if v.physbox ~= nil then
					v.physbox:Remove()
				end

				v:Remove()
			end
		end
	else
		local xc, yc, zc = inst.Transform:GetWorldPosition()
			
		local sandclone = SpawnPrefab("wixie_shadow_clone")
			
		SpawnPrefab("shadow_puff_large_back").Transform:SetPosition(xc, yc - .1, zc)
		sandclone.Transform:SetPosition(xc, yc - .05, zc)
		SpawnPrefab("shadow_puff_large_front").Transform:SetPosition(xc, yc, zc)
		
		local targetingents = TheSim:FindEntities(xc, yc, zc, 15, { "_combat" }, { "noclaustrophobia", "INLIMBO" })
		
		for i, v in pairs(targetingents) do
			if v:IsValid() and v.components ~= nil and v.components.combat ~= nil and v.components.combat.target ~= nil and v.components.combat.target == inst.caster then
				--v.components.combat:SuggestTarget(inst)
				v.components.combat.target = sandclone
			end
		end
	end
		
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
	
    inst:Remove()
end

local function ballfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.entity:AddPhysics()
	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(0)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GROUND)
	inst.Physics:SetCapsule(0.1, 0.1)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo")
	inst.AnimState:PlayAnimation("spin_loop", true)
	inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", "slow")
    inst.AnimState:SetMultColour(0, 0, 0, .6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.thisistheone = false
	inst.caster = nil

    inst:AddComponent("locomotor")
	
    inst:AddComponent("complexprojectile")
	inst.components.complexprojectile.usehigharc = true
    inst.components.complexprojectile:SetHorizontalSpeed(30)
	inst.components.complexprojectile:SetGravity(-45)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 1.5, 0))
    inst.components.complexprojectile:SetOnHit(OnHitLazy)
	
    return inst
end

local function GenerateSpiralSpikes(inst)
    local spawnpoints = {}
    local source = inst
    local x, y, z = source.Transform:GetWorldPosition()
    local spacing = 12--2.7
    local radius = 15
    local deltaradius = .2
    local angle = 2 * PI * math.random()
    local deltaanglemult = (inst.reversespikes and -2 or 2) * PI * spacing
    inst.reversespikes = not inst.reversespikes
    local delay = 0
    local deltadelay = 2 * FRAMES
    local num = 8
    local map = TheWorld.Map
    for i = 1, num do
        local oldradius = radius
        radius = radius --+ deltaradius
        local circ = PI * (oldradius + radius)
        local deltaangle = deltaanglemult / circ
        angle = angle + deltaangle
        local x1 = x + radius * math.cos(angle)
        local z1 = z + radius * math.sin(angle)
        if map:IsPassableAtPoint(x1, 0, z1) then
            table.insert(spawnpoints, {
                t = delay,
                level = i / num,
                pts = { Vector3(x1, 0, z1) },
            })
            delay = delay + deltadelay
        end
    end
    return spawnpoints, source
end

local function DoSpawnSpikes(inst, pts, level)
    if not inst.components.health:IsDead() then
        for i, v in ipairs(pts) do
            local spike = SpawnPrefab("slingshot_target")
			spike.Transform:SetPosition(v:Get())
			spike.persists = false
			
			local x2, y2, z2 = inst.Transform:GetWorldPosition()
			local projectile = SpawnPrefab("wixie_shadow_shot")
			projectile.Transform:SetPosition(x2, y2, z2)
			projectile.components.projectile:Throw(inst, spike, inst)
			
			spike:DoTaskInTime(0, spike.Remove)
        end
    end
end

local function SpawnSpikes(inst)
    local spikes, source = GenerateSpiralSpikes(inst)
	
    if #spikes > 0 then
        for i, v in ipairs(spikes) do
            inst:DoTaskInTime(0, DoSpawnSpikes, v.pts, v.level)
        end
    end
		
	inst:DoTaskInTime(.1, function()
		SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:Remove()
	end)
end

local function shadowclone_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("wixie_shadowclone")
    inst.AnimState:SetBuild("wixie_shadowclone")
    inst.AnimState:PlayAnimation("pose"..math.random(5), true)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("notraptrigger")
    inst:AddTag("shadowchesspiece")
    inst:AddTag("shadow_wixie_clone")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("combat")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(10)
    inst.components.health.destroytime = 1
	
	inst:DoTaskInTime(15, function(inst) 

	local x, y, z = inst.Transform:GetWorldPosition()
		local fxcircle = SpawnPrefab("dreadeye_sanityburstring")
		fxcircle:AddTag("ignore_transparency")
		fxcircle.Transform:SetScale(1.4, 1.4, 1.4)
		fxcircle.entity:SetParent(inst.entity)
		
		for i, v in ipairs(TheSim:FindEntities(x, y, z, 4, { "_combat", "player"}, {"playerghost"})) do
			if v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil then
				if not (v.components.health:IsDead() or v:HasTag("playerghost")) then
					v.components.combat:GetAttacked(inst, 50, inst)
				end
			end
		end
		
		SpawnSpikes(inst)
	end)
	
    inst:ListenForEvent("attacked", function(inst)
		inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_sanity_armour_dull")
		
		SpawnPrefab("wixie_shadow_ring").Transform:SetPosition(inst.Transform:GetWorldPosition())
		SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if not inst.components.health:IsDead() then
			inst.components.health:Kill()
		end
	end)
	
	inst:WatchWorldState("cycles", function() 
		if not inst.components.health:IsDead() then
			inst.components.health:Kill()
		end
	end)
	
    inst:ListenForEvent("death", function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
			
		SpawnPrefab("statue_transition").Transform:SetPosition(x, y, z)
		SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
	end)
	
	inst.persists = false

    return inst
end

local function near_burst(inst, target)
	if target ~= nil and target.components.sanity ~= nil then
		if target.components.sanity ~= nil and target.components.sanity:IsSane() then
			target.components.sanity:DoDelta(-10)
		end
	end
	
	inst:Remove()
end

local function SanityBurst(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local radius = 6
		
	local burstring = SpawnPrefab("dreadeye_sanityburstring")
	burstring:AddTag("ignore_transparency")
	burstring.Transform:SetPosition(x, 0, z)
	burstring.Transform:SetScale(1.8, 1.8, 1.8)
		
	local players = FindPlayersInRange(x, y, z, radius, { "player" }, { "playerghost" })

	local closeplayers = {}
	for i, v in ipairs(players) do
		if v:IsValid() then
			near_burst(inst, v)
		end
	end
end
	
local function ringfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("dreadeye_circle")
    inst.AnimState:SetBuild("dreadeye_circle")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetMultColour(0, 0, 0, .6)

	inst.Transform:SetScale(2, 2, 2)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    if not TheNet:IsDedicated() then
		inst:AddComponent("transparentonsanity_dreadeye")
		inst.components.transparentonsanity_dreadeye:ForceUpdate()
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/shield")
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst:DoTaskInTime(0, SanityBurst)

    inst.persists = false

    return inst
end

local function CollisionCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local attacker = inst.components.projectile.owner or nil
	
	for i, v in ipairs(TheSim:FindEntities(x, y, z, .9, { "_combat", "player"}, {"playerghost"})) do
		if v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil then
			if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost")) then
				v.components.combat:GetAttacked(attacker, 50, inst)
				inst:Remove()
				return
			end
		end
	end
end

local function shadowshot_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetCapsule(0.85, 0.85)

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("slingshotammo")
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.AnimState:SetMultColour(0, 0, 0, .6)

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")
	inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(50)
	inst.components.weapon:SetOnAttack(nil)
	
    inst.Physics:SetCollisionCallback(nil)
	
	inst:DoPeriodicTask(FRAMES, CollisionCheck, 0)

    inst:AddComponent("locomotor")
	
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnPreHitFn(nil)
    inst.components.projectile:SetOnHitFn(nil)
    inst.components.projectile:SetOnMissFn(nil)
	inst.components.projectile:SetLaunchOffset(Vector3(1, 0.5, 0))
	
	inst:DoTaskInTime(2, inst.Remove)
	
    return inst
end

local function shieldfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()
		
	inst.AnimState:SetBank("forcefield")
	inst.AnimState:SetBuild("forcefield")
	inst.AnimState:PlayAnimation("open")
	inst.AnimState:PushAnimation("idle_loop", true)
		
	inst.AnimState:SetMultColour(0, 0, 0, 1)

	inst:AddTag("fx")
		
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false

	return inst
end

return Prefab("shadow_wixie", fn, assets, prefabs),
		Prefab("shadow_wixie_helper", helperfn, assets, prefabs),
		Prefab("shadow_wixie_cloneball", ballfn, assets, prefabs),
		Prefab("wixie_shadow_clone", shadowclone_fn, assets, prefabs),
		Prefab("wixie_shadow_ring", ringfn, assets, prefabs),
		Prefab("wixie_shadow_shield", shieldfn, assets, prefabs),
		Prefab("wixie_shadow_shot", shadowshot_fn, assets, prefabs)
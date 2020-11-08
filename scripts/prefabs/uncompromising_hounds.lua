local assets =
{
    Asset("ANIM", "anim/hound_basic.zip"),
    Asset("ANIM", "anim/hound_basic_water.zip"),
    Asset("ANIM", "anim/hound.zip"),
    Asset("ANIM", "anim/hound_ocean.zip"),
    Asset("ANIM", "anim/hound_red.zip"),
    Asset("ANIM", "anim/hound_red_ocean.zip"),
    Asset("ANIM", "anim/hound_ice.zip"),
    Asset("ANIM", "anim/hound_ice_ocean.zip"),
    Asset("ANIM", "anim/hound_mutated.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}

local assets_clay =
{
    Asset("ANIM", "anim/clayhound.zip"),
}

local prefabs =
{
    "houndstooth",
    "monstermeat",
    "redgem",
    "bluegem",
    "splash_green",
	"houndcorpse",
}

local prefabs_clay =
{
    "houndstooth",
    "redpouch",
    "eyeflame",
}

local gargoyles = 
{
    "gargoyle_houndatk",
    "gargoyle_hounddeath",
}
local prefabs_moon = {}
for i, v in ipairs(gargoyles) do
    table.insert(prefabs_moon, v)
end
for i, v in ipairs(prefabs) do
    table.insert(prefabs_moon, v)
end

local brain = require("brains/houndbrain")
local moonbrain = require("brains/moonbeastbrain")

local sounds =
{
    pant = "dontstarve/creatures/hound/pant",
    attack = "dontstarve/creatures/hound/attack",
    bite = "dontstarve/creatures/hound/bite",
    bark = "dontstarve/creatures/hound/bark",
    death = "dontstarve/creatures/hound/death",
    sleep = "dontstarve/creatures/hound/sleep",
    growl = "dontstarve/creatures/hound/growl",
    howl = "dontstarve/creatures/together/clayhound/howl",
    hurt = "dontstarve/creatures/hound/hurt",
}

SetSharedLootTable('hound_lightning',
{
    {'monstermeat', 1.0},
    {'houndstooth', 1.0},
    {'yellowgem',      0.05},
})

SetSharedLootTable('hound_magma',
{
    {'monstermeat', 1.0},
    {'houndstooth', 1.0},
    --{'deer_fire_circle',   1.0},
    {'redgem',      0.3},
})

SetSharedLootTable('hound_glacial',
{
    {'monstermeat', 1.0},
    {'houndstooth', 1.0},
    --{'deer_ice_circle', 1.0},
    {'bluegem',     0.3},
})

SetSharedLootTable('hound_spore',
{
    {'monstermeat', 1.0},
    {'houndstooth', 1.0},
    {'sporecloud_toad', 1.0},
    {'greengem',      0.05},
})

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
local FREEZABLE_TAGS = { "freezable" }

local SINKHOLD_BLOCKER_TAGS = { "hound_lightning" }
local function Zap(posx, posz)
    --local projectile = SpawnPrefab("hound_lightning")
    --projectile.Transform:SetPosition(posx, 0, posz)
	
	local x = GetRandomWithVariance(posx, TUNING.ANTLION_SINKHOLE.RADIUS)
    local z = GetRandomWithVariance(posz, TUNING.ANTLION_SINKHOLE.RADIUS)

    local function IsValidSinkholePosition(offset)
        local x1, z1 = x + offset.x, z + offset.z
        if #TheSim:FindEntities(x1, 0, z1, TUNING.ANTLION_SINKHOLE.RADIUS * 1.9, SINKHOLD_BLOCKER_TAGS) > 0 then
            return false
        end
        return true
    end

    local offset = Vector3(0, 0, 0)
    offset =
        IsValidSinkholePosition(offset) and offset or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 1.8 + math.random(), 9, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 2.9 + math.random(), 17, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, TUNING.ANTLION_SINKHOLE.RADIUS * 3.9 + math.random(), 17, IsValidSinkholePosition) or
        nil

    if offset ~= nil then
        local sinkhole = SpawnPrefab("hound_lightning")
        sinkhole.Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
	
end

local function LaunchProjectile(inst, targetpos)
    local x, y, z = targetpos.Transform:GetWorldPosition()
	inst:DoTaskInTime(0, function(inst) Zap(x, z) end)
	inst:DoTaskInTime(0.4, function(inst) Zap(x, z) end)    
	inst:DoTaskInTime(0.8, function(inst) Zap(x, z) end)
end

local function Charging(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local x1 = x + math.random(-0.5, 0.5)
	local z1 = z + math.random(-0.5, 0.5)
	
	if math.random() >= 0.8 then
		SpawnPrefab("electricchargedfx").Transform:SetPosition(x1, 0, z1)
	end
	
    SpawnPrefab("sparks").Transform:SetPosition(x1, 0 + 0.25 * math.random(), z1)
end

local function CancelCharge(inst)
	if inst.task ~= nil then
		inst.task:Cancel()
		inst.task = nil
	end
end

local function Charge(inst)
    inst.task = inst:DoPeriodicTask(0.15, function(inst) Charging(inst) end)
end


local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or (inst.components.follower and inst.components.follower.leader and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local function ShouldSleep(inst)
    return inst:HasTag("pet_hound")
        and not TheWorld.state.isday
        and not (inst.components.combat and inst.components.combat.target)
        and not (inst.components.burnable and inst.components.burnable:IsBurning())
        and (not inst.components.homeseeker or inst:IsNear(inst.components.homeseeker.home, SLEEP_NEAR_HOME_DISTANCE))
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local RETARGET_CANT_TAGS = { "wall", "houndmound", "hound", "houndfriend" }
local function retargetfn(inst)
    if inst.sg:HasStateTag("statue") then
        return
    end
    local leader = inst.components.follower.leader
    if leader ~= nil and leader.sg ~= nil and leader.sg:HasStateTag("statue") then
        return
    end
    local playerleader = leader ~= nil and leader:HasTag("player")
    local ispet = inst:HasTag("pet_hound")
    return (leader == nil or
            (ispet and not playerleader) or
            inst:IsNear(leader, TUNING.HOUND_FOLLOWER_AGGRO_DIST))
        and FindEntity(
                inst,
                (ispet or leader ~= nil) and TUNING.HOUND_FOLLOWER_TARGET_DIST or TUNING.HOUND_TARGET_DIST,
                function(guy)
                    return guy ~= leader and inst.components.combat:CanTarget(guy)
                end,
                nil,
                RETARGET_CANT_TAGS
            )
        or nil
end

local function KeepTarget(inst, target)
    if inst.sg:HasStateTag("statue") then
        return false
    end
    local leader = inst.components.follower.leader
    local playerleader = leader ~= nil and leader:HasTag("player")
    local ispet = inst:HasTag("pet_hound")
    return (leader == nil or
            (ispet and not playerleader) or
            inst:IsNear(leader, TUNING.HOUND_FOLLOWER_RETURN_DIST))
        and inst.components.combat:CanTarget(target)
        and (not (ispet or leader ~= nil) or
            inst:IsNear(target, TUNING.HOUND_FOLLOWER_TARGET_KEEP))
end

local function IsNearMoonBase(inst, dist)
    local moonbase = inst.components.entitytracker:GetEntity("moonbase")
    return moonbase == nil or inst:IsNear(moonbase, dist)
end

local MOON_RETARGET_CANT_TAGS = { "wall", "houndmound", "hound", "houndfriend", "moonbeast" }
local function moon_retargetfn(inst)
    return IsNearMoonBase(inst, TUNING.MOONHOUND_AGGRO_DIST)
        and FindEntity(
                inst,
                TUNING.HOUND_FOLLOWER_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                nil,
                MOON_RETARGET_CANT_TAGS
            )
        or nil
end

local function moon_keeptargetfn(inst, target)
    return IsNearMoonBase(inst, TUNING.MOONHOUND_RETURN_DIST)
        and inst.components.combat:CanTarget(target)
        and inst:IsNear(target, TUNING.HOUND_FOLLOWER_TARGET_KEEP)
end

local function OnAttacked(inst, data)
	if inst.sg:HasStateTag("charging") and data ~= nil and data.attacker ~= nil then
		if data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead() and
			(data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) then
		
			data.attacker.components.health:DoDelta(-5, nil, inst.prefab, nil, inst)
			if data.attacker:HasTag("player") and not (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated()) then
				data.attacker.sg:GoToState("electrocute")
			end
        end
    end
	
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("hound") or dude:HasTag("houndfriend"))
                and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end

local function OnAttackOther(inst, data)
		if data ~= nil and data.target ~= nil then
            if data.target.components.health ~= nil and not data.target.components.health:IsDead() and
                (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
                not (data.target.components.inventory ~= nil and data.target.components.inventory:IsInsulated()) then

                data.target.components.health:DoDelta(-5, nil, inst.prefab, nil, inst)
                if data.target:HasTag("player") then
					local shockvictim = data.target.sg:GoToState("electrocute")
					inst:DoTaskInTime(2, shockvictim)
                end
            end
        end
		
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("hound") or dude:HasTag("houndfriend"))
                and data.target ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end

local function GetReturnPos(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = 2
    local angle = math.random() * 2 * PI
    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function DoReturn(inst)
    --print("DoReturn", inst)
    if inst.components.homeseeker ~= nil and inst.components.homeseeker:HasHome() then
        if inst:HasTag("pet_hound") then
            if inst.components.homeseeker.home:IsAsleep() and not inst:IsNear(inst.components.homeseeker.home, HOME_TELEPORT_DIST) then
                inst.Physics:Teleport(GetReturnPos(inst.components.homeseeker.home))
            end
        elseif inst.components.homeseeker.home.components.childspawner ~= nil then
            inst.components.homeseeker.home.components.childspawner:GoHome(inst)
        end
    end
end

local function OnEntitySleep(inst)
    --print("OnEntitySleep", inst)
    if not TheWorld.state.isday then
        DoReturn(inst)
    end
end

local function OnStopDay(inst)
    --print("OnStopDay", inst)
    if inst:IsAsleep() then
        DoReturn(inst)
    end
end

local function OnSpawnedFromHaunt(inst)
    if inst.components.hauntable ~= nil then
        inst.components.hauntable:Panic()
    end
end

local function OnSave(inst, data)
    data.ispet = inst:HasTag("pet_hound") or nil
    --print("OnSave", inst, data.ispet)
end

local function OnLoad(inst, data)
    --print("OnLoad", inst, data.ispet)
    if data ~= nil and data.ispet then
        inst:AddTag("pet_hound")
        if inst.sg ~= nil then
            inst.sg:GoToState("idle")
        end
    end
end

local function GetStatus(inst)
    return (inst.sg:HasStateTag("statue") and "STATUE")
        or nil
end

local function OnEyeFlamesDirty(inst)
    if TheWorld.ismastersim then
        if not inst._eyeflames:value() then
            inst.AnimState:SetLightOverride(0)
            inst.SoundEmitter:KillSound("eyeflames")
        else
            inst.AnimState:SetLightOverride(.07)
            if not inst.SoundEmitter:PlayingSound("eyeflames") then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "eyeflames")
                inst.SoundEmitter:SetParameter("eyeflames", "intensity", 1)
            end
        end
        if TheNet:IsDedicated() then
            return
        end
    end

    if inst._eyeflames:value() then
        if inst.eyefxl == nil then
            inst.eyefxl = SpawnPrefab("eyeflame")
            inst.eyefxl.entity:SetParent(inst.entity) --prevent 1st frame sleep on clients
            inst.eyefxl.entity:AddFollower()
            inst.eyefxl.Follower:FollowSymbol(inst.GUID, "hound_eye_left", 0, 0, 0)
        end
        if inst.eyefxr == nil then
            inst.eyefxr = SpawnPrefab("eyeflame")
            inst.eyefxr.entity:SetParent(inst.entity) --prevent 1st frame sleep on clients
            inst.eyefxr.entity:AddFollower()
            inst.eyefxr.Follower:FollowSymbol(inst.GUID, "hound_eye_right", 0, 0, 0)
        end
    else
        if inst.eyefxl ~= nil then
            inst.eyefxl:Remove()
            inst.eyefxl = nil
        end
        if inst.eyefxr ~= nil then
            inst.eyefxr:Remove()
            inst.eyefxr = nil
        end
    end
end

local function OnStartFollowing(inst, data)
    if inst.leadertask ~= nil then
        inst.leadertask:Cancel()
        inst.leadertask = nil
    end
    if data == nil or data.leader == nil then
        inst.components.follower.maxfollowtime = nil
    elseif data.leader:HasTag("player") then
        inst.components.follower.maxfollowtime = TUNING.HOUNDWHISTLE_EFFECTIVE_TIME * 1.5
    else
        inst.components.follower.maxfollowtime = nil
        if inst.components.entitytracker:GetEntity("leader") == nil then
            inst.components.entitytracker:TrackEntity("leader", data.leader)
        end
    end
end

local function RestoreLeader(inst)
    inst.leadertask = nil
    local leader = inst.components.entitytracker:GetEntity("leader")
    if leader ~= nil and not leader.components.health:IsDead() then
        inst.components.follower:SetLeader(leader)
        leader:PushEvent("restoredfollower", { follower = inst })
    end
end

local function OnStopFollowing(inst)
    inst.leader_offset = nil
    if not inst.components.health:IsDead() then
        local leader = inst.components.entitytracker:GetEntity("leader")
        if leader ~= nil and not leader.components.health:IsDead() then
            inst.leadertask = inst:DoTaskInTime(.2, RestoreLeader)
        end
    end
end

local function CanMutateFromCorpse(inst)
	if (inst.components.amphibiouscreature == nil or not inst.components.amphibiouscreature.in_water)
		and math.random() <= TUNING.MUTATEDHOUND_SPAWN_CHANCE 
		and TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition()) then

		local node = TheWorld.Map:FindNodeAtPoint(inst.Transform:GetWorldPosition())
		return node ~= nil and node.tags ~= nil and table.contains(node.tags, "lunacyarea")
	end
	return false
end

local function fncommon(bank, build, morphlist, custombrain, tag, data)
	data = data or {}

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetFourFaced()

    inst:AddTag("scarytoprey")
    inst:AddTag("scarytooceanprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("hound")
    inst:AddTag("canbestartled")

    if tag ~= nil then
        inst:AddTag(tag)

        if tag == "clay" then
            inst._eyeflames = net_bool(inst.GUID, "clayhound._eyeflames", "eyeflamesdirty")
            inst:ListenForEvent("eyeflamesdirty", OnEyeFlamesDirty)
        end
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst._CanMutateFromCorpse = data.canmutatefn

    inst.sounds = sounds

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = tag == "clay" and TUNING.CLAYHOUND_SPEED or TUNING.HOUND_SPEED
	
    if data.amphibious then
		inst:AddComponent("embarker")
		inst.components.embarker.embark_speed = inst.components.locomotor.runspeed
        inst.components.embarker.antic = true

	    inst.components.locomotor:SetAllowPlatformHopping(true)

		inst:AddComponent("amphibiouscreature")
		inst.components.amphibiouscreature:SetBanks(bank, bank.."_water")
        inst.components.amphibiouscreature:SetEnterWaterFn(
            function(inst)
                inst.landspeed = inst.components.locomotor.runspeed
                inst.components.locomotor.runspeed = TUNING.HOUND_SWIM_SPEED
                inst.hop_distance = inst.components.locomotor.hop_distance
                inst.components.locomotor.hop_distance = 4
            end)            
        inst.components.amphibiouscreature:SetExitWaterFn(
            function(inst)
                if inst.landspeed then
                    inst.components.locomotor.runspeed = inst.landspeed 
                end
                if inst.hop_distance then
                    inst.components.locomotor.hop_distance = inst.hop_distance
                end
            end)

		inst.components.locomotor.pathcaps = { allowocean = true }
	end

    

    inst:SetBrain(custombrain or brain)

    inst:AddComponent("follower")
    inst:AddComponent("entitytracker")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.HOUND_HEALTH)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.HOUND_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetHurtSound(inst.sounds.hurt)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('hound')

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    if tag == "clay" then
        inst.sg:GoToState("statue")

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    else
        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
        inst.components.eater:SetCanEatHorrible()
        inst.components.eater.strongstomach = true -- can eat monster meat!

        inst:AddComponent("sleeper")
        inst.components.sleeper:SetResistance(3)
        inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
        inst.components.sleeper:SetSleepTest(ShouldSleep)
        inst.components.sleeper:SetWakeTest(ShouldWakeUp)
        inst:ListenForEvent("newcombattarget", OnNewTarget)

        if morphlist ~= nil then
            MakeHauntableChangePrefab(inst, morphlist)
            inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)
        else
            MakeHauntablePanic(inst)
        end
    end

    inst:WatchWorldState("stopday", OnStopDay)
    inst.OnEntitySleep = OnEntitySleep

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("startfollowing", OnStartFollowing)
    inst:ListenForEvent("stopfollowing", OnStopFollowing)

    return inst
end

local function ontimerdone(inst, data)
    if data.name == "lightningshot_cooldown" then
		inst.lightningshot = true
    end
end

local function fnlightning()
    local inst = fncommon("hound", "hound_lightning", { "firehound", "icehound" }, nil, nil, {amphibious = true})

    if not TheWorld.ismastersim then
        return inst
    end

    MakeMediumFreezableCharacter(inst, "hound_body")
	
	inst:SetStateGraph("SGlightninghound")
		
    inst.components.lootdropper:SetChanceLootTable('hound_lightning')
	
    inst.components.combat:SetRange(10, 3)
	
    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)

	inst.task = nil
	
    inst.LaunchProjectile = LaunchProjectile
    inst.CancelCharge = CancelCharge
    inst.Charge = Charge
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)
	
	inst.lightningshot = true

    return inst
end

local function DoGlacialExplosion(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

    local spell = SpawnPrefab("deer_ice_circle")
    spell.Transform:SetPosition(x, 0, z)
    spell:DoTaskInTime(6, spell.KillFX)
end

local function fnglacial()
    local inst = fncommon("hound", "hound_mutated", nil, nil, nil, {amphibious = true})

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetMultColour(0, 0, 1, 1)
	
    inst:SetStateGraph("SGhound")

    MakeMediumBurnableCharacter(inst, "hound_body")
	
    inst.components.lootdropper:SetChanceLootTable('hound_glacial')
	
    inst:ListenForEvent("death", DoGlacialExplosion)

    return inst
end

local function DoMagmaExplosion(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

    local spell = SpawnPrefab("deer_fire_circle")
    spell.Transform:SetPosition(x, 0, z)
    spell:DoTaskInTime(4, spell.KillFX)
end

local easing = require("easing")

local function ShootProjectile(inst, target)
   local target = inst.components.combat.target
	if target ~= nil then
    local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab("fireball_throwable")
    projectile.Transform:SetPosition(x, y, z)
    local a, b, c = target.Transform:GetWorldPosition()
	local targetpos = target:GetPosition()
	targetpos.x = targetpos.x + math.random(-3,3)
	targetpos.z = targetpos.z + math.random(-3,3)
    local dx = a - x
    local dz = c - z
    local rangesq = dx * dx + dz * dz
    local maxrange = 15
    local bigNum = 10
    local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange * 2)
	projectile:AddTag("canthit")
	--projectile.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS/2
    projectile.components.complexprojectile:SetHorizontalSpeed(speed+math.random(4,9))
    projectile.components.complexprojectile:SetGravity(-25)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

local function fnmagma()
    local inst = fncommon("hound", "hound_mutated", nil, nil, nil, {amphibious = true})

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetMultColour(1, 0, 0, 1)
	
    inst:SetStateGraph("SGmagmahound")

    MakeMediumFreezableCharacter(inst, "hound_body")
	
    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)

	inst.task = nil
	
    inst.components.combat:SetRange(10, 3)
	
    inst.components.freezable:SetResistance(4)
	
    inst.components.lootdropper:SetChanceLootTable('hound_magma')
	
    inst.LaunchProjectile = ShootProjectile
    inst.CancelCharge = CancelCharge
    inst.Charge = Charge
	
    inst:ListenForEvent("death", DoMagmaExplosion)
	
	inst.foogley = 0
	
	inst.lightningshot = true

    return inst
end

local function fnspore()
    local inst = fncommon("hound", "hound_mutated", nil, nil, nil, {amphibious = true})

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetMultColour(0, 1, 0, 1)
	
    inst:SetStateGraph("SGhound")
	
    inst.components.lootdropper:SetChanceLootTable('hound_spore')

    return inst
end

return Prefab("lightninghound", fnlightning, assets, prefabs),
	Prefab("glacialhound", fnglacial, assets, prefabs),
	Prefab("magmahound", fnmagma, assets, prefabs),
	Prefab("sporehound", fnspore, assets, prefabs)

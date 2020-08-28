require("prefabs/mushtree_spores")

local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/toadstool_basic.zip"),
    Asset("ANIM", "anim/toadstool_actions.zip"),
    Asset("ANIM", "anim/toadstool_build.zip"),
    Asset("ANIM", "anim/toadstool_upg_build.zip"),
}




SetSharedLootTable('rambranch',
{
    {"livinglog",      1.00},
    {"livinglog",      1.00},
    {"steelwool",      1.00},
    {"steelwool",      1.00},
    {"plantmeat",      1.00},
    {"plantmeat",      1.00},
    {"plantmeat",      1.00},
    {"plantmeat",      1.00},
    {"nightmarefuel",  1.00},
    {"nightmarefuel",  1.00},
    {"nightmarefuel",  1.00},
    {"nightmarefuel",  1.00},
    --{"evileye",   6.00},
})

--------------------------------------------------------------------------

local brain = require("brains/rambranchbrain") 

--------------------------------------------------------------------------
--------------------------------------------------------------------------
local SPOREBOMBTARGET_MUST_TAGS = { "debuffable", "player" }
local SPOREBOMBTARGET_CANT_TAGS = { "ghost", "playerghost", "shadow", "shadowminion", "noauradamage", "INLIMBO" }

local function FindSporeBombTargets(inst, preferredtargets)
    local targets = {}

    if preferredtargets ~= nil then
        for i, v in ipairs(preferredtargets) do
            if v:IsValid() and v.entity:IsVisible() and
                v.components.debuffable ~= nil and
                v.components.debuffable:IsEnabled() and
                not v.components.debuffable:HasDebuff("sporebomb") and
                not (v.components.health ~= nil and
                    v.components.health:IsDead()) and
                not v:HasTag("playerghost") and
                v:IsNear(inst, TUNING.TOADSTOOL_SPOREBOMB_HIT_RANGE) then
                table.insert(targets, v)
                if #targets >= inst.sporebomb_targets then
                    return targets
                end
            end
        end
    end

    local newtargets = {}
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.TOADSTOOL_SPOREBOMB_ATTACK_RANGE, SPOREBOMBTARGET_MUST_TAGS, SPOREBOMBTARGET_CANT_TAGS)
    for i, v in ipairs(ents) do
        if v.entity:IsVisible() and
            v.components.debuffable ~= nil and
            not v.components.debuffable:HasDebuff("sporebomb") and
            not (v.components.health ~= nil and
                v.components.health:IsDead()) then
            table.insert(newtargets, v)
        end
    end

    for i = #targets + 1, inst.sporebomb_targets do
        if #newtargets <= 0 then
            return targets
        end
        table.insert(targets, table.remove(newtargets, math.random(#newtargets)))
    end

    return targets
end

local function DoSporeBomb(inst, targets)
    for i, v in ipairs(FindSporeBombTargets(inst, targets)) do
        v.components.debuffable:AddDebuff("sporebomb", "sporebomb")
    end
end

--------------------------------------------------------------------------

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local BOMBTARGET_MUST_TAGS = { "_combat", "_health" }
local BOMBTARGET_CANT_TAGS = { "player", "INLIMBO" }
local function FindMushroomBombTargets(inst)
    --ring with a random gap
    local maxbombs = inst.mushroombomb_variance > 0 and inst.mushroombomb_count + math.random(inst.mushroombomb_variance) or inst.mushroombomb_count
    local delta = (1 + math.random()) * PI / maxbombs
    local offset = 2 * PI * math.random()
    local angles = {}
    for i = 1, maxbombs do
        table.insert(angles, i * delta + offset)
    end

    --shorten range when mobbed by NPC
    local pt = inst:GetPosition()
    local maxrange = TUNING.TOADSTOOL_MUSHROOMBOMB_MAX_RANGE
    for i = 1, 2 do
        local closerange = (TUNING.TOADSTOOL_MUSHROOMBOMB_MIN_RANGE + maxrange) * .5
        local targets = TheSim:FindEntities(pt.x, 0, pt.z, closerange, BOMBTARGET_MUST_TAGS, BOMBTARGET_CANT_TAGS)
        if #targets < inst.components.grouptargeter.num_targets then
            break
        end
        maxrange = closerange
    end

    local range = GetRandomMinMax(TUNING.TOADSTOOL_MUSHROOMBOMB_MIN_RANGE, maxrange)
    local targets = {}
    while #angles > 0 do
        local theta = table.remove(angles, math.random(#angles))
        local offset = FindWalkableOffset(pt, theta, range, 12, true, true, NoHoles)
        if offset ~= nil then
            offset.x = offset.x + pt.x
            offset.y = 0
            offset.z = offset.z + pt.z
            table.insert(targets, offset)
        end
    end

    return targets
end

local function SpawnMushroomBombProjectile(inst, targets)
    local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab(inst.mushroombomb_prefab)
    projectile.Transform:SetPosition(x, y, z)
    projectile.components.entitytracker:TrackEntity("toadstool", inst)

    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
    local targetpos = table.remove(targets, 1)
    local dx = targetpos.x - x
    local dz = targetpos.z - z
    local rangesq = dx * dx + dz * dz
    local maxrange = 15
    local bigNum = 15 -- 13 + (math.random()*4)
    local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	if inst.components.combat.target ~= nil then
	projectile.target = inst.components.combat.target
	end

    if #targets > 0 then
        inst:DoTaskInTime(FRAMES, SpawnMushroomBombProjectile, targets)
    end
end

local function DoMushroomBomb(inst)
    local targets = FindMushroomBombTargets(inst)
    if #targets > 0 then
        inst:DoTaskInTime(FRAMES, SpawnMushroomBombProjectile, targets)
    end
end

--------------------------------------------------------------------------

local function FindMushroomSproutAngles(inst)
    --evenly spaced ring
    local maxspawns = 3
    local delta = 2 * PI / maxspawns
    local offset = 2 * PI * math.random()
    local angles = {}
    for i = 1, maxspawns do
        table.insert(angles, i * delta + offset)
    end
    return angles
end

local function SproutLaunch(inst, launcher, basespeed)
    local x0, y0, z0 = launcher.Transform:GetWorldPosition()
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local dx, dz = x1 - x0, z1 - z0
    local dsq = dx * dx + dz * dz
    local angle
    if dsq > 0 then
        local dist = math.sqrt(dsq)
        angle = math.atan2(dz / dist, dx / dist) + (math.random() * 20 - 10) * DEGREES
    else
        angle = 2 * PI * math.random()
    end
    local speed = basespeed + math.random()
    inst.Physics:Teleport(x1, .1, z1)
    inst.Physics:SetVel(math.cos(angle) * speed, speed * 4 + math.random() * 2, math.sin(angle) * speed)
end

local MUSHROOMSPROUT_BLOCKER_TAGS = { "_inventoryitem", "playerskeleton", "quickpick", "DIG_workable", "NOBLOCK", "FX", "INLIMBO", "DECOR" }
local MUSHROOMSPROUT_BREAK_ONEOF_TAGS = { "playerskeleton", "DIG_workable" }
local MUSHROOMSPROUT_TOSS_MUST_TAGS = { "_inventoryitem" }
local MUSHROOMSPROUT_TOSS_CANT_TAGS = { "locomotor", "INLIMBO" }
local MUSHROOMSPROUT_TOSSFLOWERS_MUST_TAGS = { "quickpick", "pickable" }
local MUSHROOMSPROUT_TOSSFLOWERS_CANT_TAGS = { "intense" }
--These Functions are Still Pmuch perfect for the Ram Branch
local function DoMushroomSprout(inst, angles)
    if angles == nil or #angles <= 0 then
        return
    end

    local map = TheWorld.Map
    local pt = inst:GetPosition()
    local theta = table.remove(angles, math.random(#angles))
    local radius = GetRandomMinMax(TUNING.TOADSTOOL_MUSHROOMSPROUT_MIN_RANGE, TUNING.TOADSTOOL_MUSHROOMSPROUT_MAX_RANGE)
    local offset = FindWalkableOffset(pt, theta, radius, 12, true, false, NoHoles)
    pt.y = 0

    --number of attempts to find an unblocked spawn point
    local min_spacing = DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT]
    local min_spacing_sq = min_spacing * min_spacing
    for i = 1, 12 do
        if i > 1 then
            offset = FindWalkableOffset(pt, 2 * PI * math.random(), 2.5, 8, true, false, NoHoles)
        end
        if offset ~= nil then
            pt.x = pt.x + offset.x
            pt.z = pt.z + offset.z
            if #TheSim:FindEntities(pt.x, 0, pt.z, min_spacing, nil, MUSHROOMSPROUT_BLOCKER_TAGS) <= 0 then
                --destroy skeletons and diggables
                for i, v in ipairs(TheSim:FindEntities(pt.x, 0, pt.z, 1.2, nil, nil, MUSHROOMSPROUT_BREAK_ONEOF_TAGS)) do
                    v.components.workable:Destroy(inst)
                end

                local totoss = TheSim:FindEntities(pt.x, 0, pt.z, 1, MUSHROOMSPROUT_TOSS_MUST_TAGS, MUSHROOMSPROUT_TOSS_CANT_TAGS)

                --toss flowers out of the way
                for i, v in ipairs(TheSim:FindEntities(pt.x, 0, pt.z, 1, MUSHROOMSPROUT_TOSSFLOWERS_MUST_TAGS, MUSHROOMSPROUT_TOSSFLOWERS_CANT_TAGS)) do
                    local num = v.components.pickable.numtoharvest or 1
                    local product = v.components.pickable.product
                    local x1, y1, z1 = v.Transform:GetWorldPosition()
                    v.components.pickable:Pick(inst) -- only calling this to trigger callbacks on the object
                    if product ~= nil and num > 0 then
                        for i = 1, num do
                            local loot = SpawnPrefab(product)
                            loot.Transform:SetPosition(x1, 0, z1)
                            table.insert(totoss, loot)
                        end
                    end
                end

                local ent = SpawnPrefab(inst.mushroomsprout_prefab)
                ent.Transform:SetPosition(pt:Get())
                ent:PushEvent("linkrambranch", inst)

                --toss stuff out of the way
                for i, v in ipairs(totoss) do
                    if v:IsValid() then
                        if v.components.mine ~= nil then
                            v.components.mine:Deactivate()
                        end
                        if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
                            SproutLaunch(v, ent, 1.5)
                        end
                    end
                end
                break
            end
        end
    end
end

--------------------------------------------------------------------------

local function CalculateLevel(links)
    return (links < 1 and 0)
        or (links < 2 and 1)
        or (links < 3 and 2)
        or 3
end

local function UpdateLevel(inst)
    local level = CalculateLevel(inst._numlinks)

    if not (inst.sg:HasStateTag("frozen") or inst.sg:HasStateTag("thawing")) then
        inst.level = level
        inst.components.health:SetAbsorptionAmount(TUNING.TOADSTOOL_ABSORPTION_LVL[level])

    end

    inst:PushEvent("rambranchlevel", level) --Link in mushroomsprout or in other words, nightmare horns
end

local function OnUnlinkHorn(inst, link)
    if inst._links[link] ~= nil then
        inst:RemoveEventCallback("onremove", inst._links[link], link)
        inst._links[link] = nil
        inst._numlinks = inst._numlinks - 1
        UpdateLevel(inst)
    end
end

local function OnLinkHorn(inst, link)
    if inst._links[link] == nil then
        inst._numlinks = inst._numlinks + 1
        inst._links[link] = function(link) OnUnlinkMushroomSprout(inst, link) end
        inst:ListenForEvent("onremove", inst._links[link], link)
        UpdateLevel(inst)
    end
end

--------------------------------------------------------------------------

local function UpdatePlayerTargets(inst)
    local toadd = {}
    local toremove = {}
    local pos = inst.components.knownlocations:GetLocation("spawnpoint")

    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        toremove[k] = true
    end
    for i, v in ipairs(FindPlayersInRange(pos.x, pos.y, pos.z, TUNING.TOADSTOOL_DEAGGRO_DIST, true)) do
        if toremove[v] then
            toremove[v] = nil
        else
            table.insert(toadd, v)
        end
    end

    for k, v in pairs(toremove) do
        inst.components.grouptargeter:RemoveTarget(k)
    end
    for i, v in ipairs(toadd) do
        inst.components.grouptargeter:AddTarget(v)
    end
end

local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "INLIMBO", "prey", "companion"--[[, "smallcreature" <- the beeees... - _-" ]] }
local function RetargetFn(inst)
    UpdatePlayerTargets(inst)

    local player = inst.components.combat.target
    if player ~= nil and player:HasTag("player") then
        local newplayer = inst.components.grouptargeter:TryGetNewTarget()
        if newplayer ~= nil and newplayer:IsNear(inst, TUNING.TOADSTOOL_ATTACK_RANGE) then
            return newplayer, true
        elseif player:IsNear(inst, TUNING.TOADSTOOL_ATTACK_RANGE) then
            return
        elseif newplayer ~= nil then
            player = newplayer
        end
    else
        player = nil
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local nearplayers = FindPlayersInRange(x, y, z, TUNING.TOADSTOOL_ATTACK_RANGE, true)
    if #nearplayers > 0 then
        return nearplayers[math.random(#nearplayers)], true
    end

    --Also needs to deal with other creatures in the world
    local spawnpoint = inst.components.knownlocations:GetLocation("spawnpoint")
    local deaggro_dist_sq = TUNING.TOADSTOOL_DEAGGRO_DIST * TUNING.TOADSTOOL_DEAGGRO_DIST
    local creature = FindEntity(
        inst,
        TUNING.TOADSTOOL_AGGRO_DIST,
        function(guy)
            return inst.components.combat:CanTarget(guy)
                and guy:GetDistanceSqToPoint(spawnpoint) < deaggro_dist_sq
        end,
        RETARGET_MUST_TAGS, --see entityreplica.lua
        RETARGET_CANT_TAGS
    )

    if player ~= nil and
        (   creature == nil or
            player:GetDistanceSqToPoint(x, y, z) <= creature:GetDistanceSqToPoint(x, y, z)
        ) then
        return player, true
    end

    if creature ~= nil then
        return creature, true
    end
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
        and target:GetDistanceSqToPoint(inst.components.knownlocations:GetLocation("spawnpoint")) < TUNING.TOADSTOOL_DEAGGRO_DIST * TUNING.TOADSTOOL_DEAGGRO_DIST
end

local function OnNewTarget(inst, data)
    if data.target ~= nil then
        inst:RemoveEventCallback("newcombattarget", OnNewTarget)
        inst.engaged = true

        --Ability first use timers 
        inst.components.timer:StartTimer("sporebomb_cd", TUNING.TOADSTOOL_ABILITY_INTRO_CD)
        --inst.components.timer:StartTimer("mushroombomb_cd", inst.mushroombomb_cd)
        inst.components.timer:StartTimer("mushroomsprout_cd", inst.mushroomsprout_cd/4)
        inst.components.timer:StartTimer("pound_cd", TUNING.TOADSTOOL_ABILITY_INTRO_CD, true)
    end
end

local function OnNewState(inst)
    if inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("frozen") or inst.sg:HasStateTag("thawing") then
        inst.components.timer:PauseTimer("mushroomsprout_cd")
    else
        inst.components.timer:ResumeTimer("mushroomsprout_cd")
    end
end

local function ClearRecentAttacker(inst, attacker)
    if inst._recentattackers[attacker] ~= nil then
        inst._recentattackers[attacker]:Cancel()
        inst._recentattackers[attacker] = nil
    end
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil and data.attacker:HasTag("player") then
        if inst._recentattackers[data.attacker] ~= nil then
            inst._recentattackers[data.attacker]:Cancel()
        end
        inst._recentattackers[data.attacker] = inst:DoTaskInTime(120, ClearRecentAttacker, data.attacker)
    end
end



--------------------------------------------------------------------------

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

--------------------------------------------------------------------------

local function OnEntitySleep(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
    end
    --inst._sleeptask = not inst.components.health:IsDead() and inst:DoTaskInTime(10, inst.Remove) or nil
end

local function OnEntityWake(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
        inst._sleeptask = nil
    end
end

--------------------------------------------------------------------------

local PHASE2_HEALTH = .7
local PHASE3_HEALTH = .4

local function SetPhaseLevel(inst, phase)
    inst.phase = phase
    inst.pound_rnd = phase > 3 
    phase = math.min(3, phase)
    inst.sporebomb_targets = TUNING.TOADSTOOL_SPOREBOMB_TARGETS_PHASE[phase]
    inst.sporebomb_cd = TUNING.TOADSTOOL_SPOREBOMB_CD_PHASE[phase]
    inst.mushroombomb_count = TUNING.TOADSTOOL_MUSHROOMBOMB_COUNT_PHASE[phase]
    if phase > 2 then
        inst.components.timer:ResumeTimer("pound_cd")
    else
        inst.components.timer:StopTimer("pound_cd")
        inst.components.timer:StartTimer("pound_cd", TUNING.TOADSTOOL_ABILITY_INTRO_CD, true)
    end
end


local function EnterPhase2Trigger(inst)
    if inst.phase < 2 then
        SetPhaseLevel(inst, 2)
        inst:PushEvent("roar")
    end
end

local function EnterPhase3Trigger(inst)
    if inst.phase < 3 then
        SetPhaseLevel(inst, 3)
        inst:PushEvent("roar")
    end
end


local function OnSave(inst, data)
    data.phase = inst.phase
    data.engaged = inst.engaged or nil
    data.poundspeed = inst.pound_speed > 0 and math.floor(inst.pound_speed) or nil
end

local function OnLoad(inst, data)
    if data ~= nil and data.phase ~= nil then
        SetPhaseLevel(inst, data.phase)
    else
        local healthpct = inst.components.health:GetPercent()
        SetPhaseLevel(
            inst,
            (healthpct > PHASE2_HEALTH and 1) or
            (healthpct > PHASE3_HEALTH and 2) or
            ((not inst.dark or healthpct > PHASE4_HEALTH) and 3) or
            4
        )
    end

    if data ~= nil then
        if data.poundspeed ~= nil then
            inst.pound_speed = math.max(0, data.poundspeed)
        end
        if data.engaged then
            inst:RemoveEventCallback("newcombattarget", OnNewTarget)
            inst.engaged = true
        end
    end
end

--------------------------------------------------------------------------

local function ClearRecentlyCharged(inst, other)
    inst.recentlycharged[other] = nil
end

local function OnDestroyOther(inst, other)
    if other:IsValid() and
        other.components.workable ~= nil and
        other.components.workable:CanBeWorked() and
        other.components.workable.action ~= ACTIONS.NET and
        not inst.recentlycharged[other] then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        if other.components.lootdropper ~= nil and (other:HasTag("tree") or other:HasTag("boulder")) then
            other.components.lootdropper:SetLoot({})
        end
        other.components.workable:Destroy(inst)
        if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
            inst.recentlycharged[other] = true
            inst:DoTaskInTime(3, ClearRecentlyCharged, other)
        end
    end
end

local function OnCollide(inst, other)
    if other ~= nil and
        other:IsValid() and
        other.components.workable ~= nil and
        other.components.workable:CanBeWorked() and
        other.components.workable.action ~= ACTIONS.NET and
        not inst.recentlycharged[other] then
        inst:DoTaskInTime(2 * FRAMES, OnDestroyOther, other)
    end
end

--------------------------------------------------------------------------

local function getstatus(inst)
    return inst.level >= 3  and "RAGE" or nil
end

local function PushMusic(inst)
    if ThePlayer == nil then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 30 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("triggeredevent", { name = "toadstool" })
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 40) then
        inst._playingmusic = false
    end
end

--------------------------------------------------------------------------
local function CalcSanityAura(inst)
    return -TUNING.SANITYAURA_LARGE/12
end
local function common_fn(build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()

    inst.DynamicShadow:SetSize(6, 3.5)


    MakeGiantCharacterPhysics(inst, 1000, 2.5)

    inst.AnimState:SetBank("toadstool")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle", true)
    --inst.AnimState:SetLightOverride(.3)

    inst:AddTag("epic")
    inst:AddTag("noepicmusic")
    inst:AddTag("monster")
    inst:AddTag("rambranch")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
	inst:AddTag("beaverchewable")

    inst.entity:SetPristine()

    --Dedicated server does not need to trigger music
    if not TheNet:IsDedicated() then
        inst._playingmusic = false
        inst:DoPeriodicTask(1, PushMusic, 0)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst.recentlycharged = {}
    inst.Physics:SetCollisionCallback(OnCollide)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("lootdropper")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper.diminishingreturns = true

    inst:AddComponent("locomotor")
    inst.components.locomotor.pathcaps = { ignorewalls = true }
    inst.components.locomotor.walkspeed = TUNING.TOADSTOOL_SPEED_LVL[0]

    inst:AddComponent("health")
    inst.components.health.nofadeout = true

    inst:AddComponent("healthtrigger")
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.TOADSTOOL_ATTACK_PERIOD_LVL[0])
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(4*TUNING.TOADSTOOL_ATTACK_RANGE)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat.hiteffectsymbol = "toad_torso"

    inst:AddComponent("explosiveresist")

    inst:AddComponent("sanityaura")

    inst:AddComponent("epicscare")
    inst.components.epicscare:SetRange(TUNING.TOADSTOOL_EPICSCARE_RANGE)

    inst:AddComponent("timer")

    inst:AddComponent("grouptargeter")

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.platformPushingRings = 0

    inst:AddComponent("knownlocations")

    MakeLargeBurnableCharacter(inst, "swap_fire")
    MakeHugeFreezableCharacter(inst, "toad_torso")
    inst.components.freezable.diminishingreturns = true

    inst:SetStateGraph("SGrambranch")
    inst:SetBrain(brain)

    inst.FindSporeBombTargets = FindSporeBombTargets
    inst.DoSporeBomb = DoSporeBomb
    inst.DoMushroomBomb = DoMushroomBomb
    inst.FindMushroomSproutAngles = FindMushroomSproutAngles
    inst.DoMushroomSprout = DoMushroomSprout

    inst.sporebomb_targets = TUNING.TOADSTOOL_SPOREBOMB_TARGETS_PHASE[1]
    inst.sporebomb_cd = TUNING.TOADSTOOL_SPOREBOMB_CD_PHASE[1]

    inst.mushroombomb_count = TUNING.TOADSTOOL_MUSHROOMBOMB_COUNT_PHASE[1]
    inst.mushroombomb_variance = TUNING.TOADSTOOL_MUSHROOMBOMB_VAR_LVL[0]
    inst.mushroombomb_maxchain = TUNING.TOADSTOOL_MUSHROOMBOMB_CHAIN_LVL[0]
    inst.mushroombomb_cd = TUNING.TOADSTOOL_MUSHROOMBOMB_CD

    inst.mushroomsprout_cd = TUNING.TOADSTOOL_MUSHROOMSPROUT_CD

    inst.pound_cd = TUNING.TOADSTOOL_POUND_CD
    inst.pound_speed = 0
    inst.pound_rnd = false

    inst.hit_recovery = TUNING.TOADSTOOL_HIT_RECOVERY_LVL[0]

    inst.phase = 1
    inst.level = 0
    inst._numlinks = 0
    inst._links = {}
    inst:ListenForEvent("linkhorn", OnLinkHorn)
    inst:ListenForEvent("unlinkhorn", OnUnlinkHorn)

    inst._recentattackers = {}
    inst.engaged = false

    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("newstate", OnNewState)
    inst:ListenForEvent("attacked", OnAttacked)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad


    inst.UpdateLevel = UpdateLevel

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
end

local function normal_fn()
    local inst = common_fn("toadstool_build")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.health:SetMaxHealth(6000)
    inst.components.health:SetAbsorptionAmount(TUNING.TOADSTOOL_ABSORPTION_LVL[0])

    inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, EnterPhase3Trigger)

    inst.components.combat:SetDefaultDamage(TUNING.TOADSTOOL_DAMAGE_LVL[0])

    inst.components.lootdropper:SetChanceLootTable("rambranch")

    inst.mushroombomb_prefab = "sheepletbomb"
    inst.mushroomsprout_prefab = "nightmarehorn"

    return inst
end

return Prefab("rambranch", normal_fn, assets, prefabs)

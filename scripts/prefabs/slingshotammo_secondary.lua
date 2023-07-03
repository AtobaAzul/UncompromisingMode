-- wonder if this will work
if not TUNING.DSTU.WIXIE then
    return
end

local assets = {Asset("ANIM", "anim/slingshotammo.zip")}

local easing = require("easing")

-- temp aggro system for the slingshots
local function no_aggro(attacker, target)
    local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
    return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker:IsValid() and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4 and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function ImpactFx(inst, attacker, target)
    if target ~= nil and target:IsValid() then
        local impactfx = SpawnPrefab(inst.ammo_def.impactfx)
        impactfx.Transform:SetPosition(target.Transform:GetWorldPosition())
    end
end

local function OnAttack(inst, attacker, target)
    if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() then
        if target:HasDebuff("wixiecurse_debuff") then
            inst.powerlevel = inst.powerlevel + 1
            target:PushEvent("wixiebite")
        end

        if inst.ammo_def ~= nil and inst.ammo_def.onhit ~= nil then
            inst.ammo_def.onhit(inst, attacker, target)
        end

        if inst.ammo_def ~= nil and inst.ammo_def.damage ~= nil then
            inst.finaldamage = (inst.ammo_def.damage * (1 + (inst.powerlevel / 2))) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1)

            if no_aggro(attacker, target) and target.components.combat ~= nil then
                target.components.combat:SetShouldAvoidAggro(attacker)
            end

            if target:HasTag("shadowcreature") or target.sg == nil or target.wixieammo_hitstuncd == nil and not (target.sg:HasStateTag("busy") or target.sg:HasStateTag("caninterrupt")) or target.sg:HasStateTag("frozen") then
                target.wixieammo_hitstuncd = target:DoTaskInTime(8, function()
                    if target.wixieammo_hitstuncd ~= nil then
                        target.wixieammo_hitstuncd:Cancel()
                    end

                    target.wixieammo_hitstuncd = nil
                end)

                target.components.combat:GetAttacked(inst, inst.finaldamage, inst)
            else
                target.components.combat:GetAttacked(inst, 0, inst)

                target.components.health:DoDelta(-inst.finaldamage, false, attacker, false, attacker, false)
            end
        end

        ImpactFx(inst, attacker, target)

        if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
            target.components.sleeper:WakeUp()
        end

        if target.components.combat ~= nil then
			target.components.combat:SetTarget(attacker)
            target.components.combat:RemoveShouldAvoidAggro(attacker)
        end

        if attacker.components.combat ~= nil then
            attacker.components.combat:SetTarget(target)
        end
    end
end

local function OnPreHit(inst, attacker, target) target.components.combat.temp_disable_aggro = no_aggro(attacker, target) end

local function OnHit(inst, attacker, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
        target.components.combat.temp_disable_aggro = false
    end
end

local function NoHoles(pt) return not TheWorld.Map:IsPointNearHole(pt) end

local function SpawnShadowTentacle(target, pt, starting_angle)
    local offset = FindWalkableOffset(pt, starting_angle, 1.25, 3, false, true, NoHoles)
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

    if target ~= nil and target:IsValid() then
        target:AddDebuff("wixiecurse_debuff", "wixiecurse_debuff", {powerlevel = inst.powerlevel})
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

local FREEZE_CANT_TAGS = {"noclaustrophobia", "player", "shadow", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "INLIMBO"}

local function GenerateSpiralSpikes(inst, powerlevel)
    local spawnpoints = {}
    local source = inst
    local x, y, z = source.Transform:GetWorldPosition()
    local spacing = 12 / powerlevel -- 2.5
    local radius = powerlevel -- 5
    local deltaradius = .2
    local angle = 2 * PI * math.random()
    local deltaanglemult = (inst.reversespikes and -2 or 2) * PI * spacing
    inst.reversespikes = not inst.reversespikes
    local delay = 0
    local deltadelay = 2 * FRAMES
    local num = powerlevel * 3 -- 15
    local map = TheWorld.Map
    for i = 1, num do
        local oldradius = radius
        radius = radius -- + deltaradius
        local circ = PI * (oldradius + radius)
        local deltaangle = deltaanglemult / circ
        angle = angle + deltaangle
        local x1 = x + radius * math.cos(angle)
        local z1 = z + radius * math.sin(angle)
        if map:IsPassableAtPoint(x1, 0, z1) then
            table.insert(spawnpoints, {t = delay, level = i / num, pts = {Vector3(x1, 0, z1)}})
            delay = delay + deltadelay
        end
    end
    return spawnpoints, source
end

local function DoSpawnSpikes(inst, pts, level)
    for i, v in ipairs(pts) do

        local spike = SpawnPrefab("icespike_fx_" .. math.random(4))
        spike.Transform:SetPosition(v:Get())
        spike.persists = false
    end
end

local function SpawnSpikes(inst, powerlevel)
    local spikes, source = GenerateSpiralSpikes(inst, powerlevel)
    if #spikes > 0 then
        for i, v in ipairs(spikes) do
            inst:DoTaskInTime(0, DoSpawnSpikes, v.pts, v.level)
        end
    end
end

local function DoFreeze(inst, target)
    local pos = Vector3(target.Transform:GetWorldPosition())

    local power = 1 + (inst.powerlevel * 2)
    local forloopvalue = power * 2

    SpawnSpikes(target, power)

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, power, nil, FREEZE_CANT_TAGS)
    for i, v in pairs(ents) do
        if v ~= target and v.components.freezable ~= nil then
            v.components.freezable:AddColdness((TUNING.SLINGSHOT_AMMO_FREEZE_COLDNESS / 2) + inst.powerlevel / 2)
            v.components.freezable:SpawnShatterFX()
        end
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
        target.components.freezable:AddColdness((TUNING.SLINGSHOT_AMMO_FREEZE_COLDNESS / 2) + inst.powerlevel)
        target.components.freezable:SpawnShatterFX()
        DoFreeze(inst, target)
    else
        local fx = SpawnPrefab("shatter")
        fx.Transform:SetPosition(target.Transform:GetWorldPosition())
        fx.components.shatterfx:SetLevel(2)
        DoFreeze(inst, target)
    end

    if not no_aggro(attacker, target) and target.components.combat ~= nil then
        target.components.combat:SetTarget(attacker)
    end

    inst:Remove()
end

local function AoE_Speed(inst)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local fx = SpawnPrefab("shadow_puff")
    fx.Transform:SetPosition(pos.x, pos.y, pos.z)
    fx.Transform:SetScale(1.1, 1.1, 1.1)
    local debuffkey = inst.prefab

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 4, nil, FREEZE_CANT_TAGS)
    for i, v in pairs(ents) do
        if v ~= nil and v ~= inst and v:IsValid() and v.components.locomotor ~= nil then
            if v._slingshot_speedmulttask ~= nil then
                v._slingshot_speedmulttask:Cancel()
            end
            v._slingshot_speedmulttask = v:DoTaskInTime(TUNING.SLINGSHOT_AMMO_MOVESPEED_DURATION / 3, function(i)
                i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                i._slingshot_speedmulttask = nil
            end)

            v.components.locomotor:SetExternalSpeedMultiplier(v, debuffkey, TUNING.SLINGSHOT_AMMO_MOVESPEED_MULT)

            local vx, vy, vz = v.Transform:GetWorldPosition()

            local fx1 = SpawnPrefab("shadow_despawn")
            fx1.Transform:SetPosition(vx, vy, vz)
        end
    end
end

local function OnHit_Speed(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    local debuffkey = inst.prefab

    if target ~= nil and target:IsValid() and target.components.locomotor ~= nil then
        if target._slingshot_speedmulttask ~= nil then
            target._slingshot_speedmulttask:Cancel()
        end
        target._slingshot_speedmulttask = target:DoTaskInTime(TUNING.SLINGSHOT_AMMO_MOVESPEED_DURATION, function(i)
            i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
            i._slingshot_speedmulttask = nil
        end)

        target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, TUNING.SLINGSHOT_AMMO_MOVESPEED_MULT)

        AoE_Speed(target)
    end

    inst:Remove()
end

local function OnHit_Vortex(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    if target ~= nil and target:IsValid() then
        local vortex = SpawnPrefab("slingshot_vortex")
        vortex.Transform:SetPosition(target.Transform:GetWorldPosition())
        vortex.powerlevel = inst.powerlevel
    end

    inst:Remove()
end

local function OnHit_Distraction(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
        local targets_target = target.components.combat.target
        if targets_target == nil or targets_target == attacker then
            attacker._doesnotdrawaggro = true
            target:PushEvent("attacked", {attacker = attacker, damage = 0, weapon = inst})
            attacker._doesnotdrawaggro = nil

            if not target:HasTag("epic") and target.components.combat ~= nil then
                target.components.combat:DropTarget()
            end

            if target.components.hauntable ~= nil and target.components.hauntable.panicable then
                target.components.hauntable:Panic(4 * inst.powerlevel)
            end

            -- local stinkcloud = SpawnPrefab("wixie_stinkcloud")
            -- stinkcloud.Transform:SetPosition(target.Transform:GetWorldPosition())
            -- stinkcloud.components.timer:StartTimer("disperse", 10 * inst.powerlevel)
        end
    end

    inst:Remove()
end

local AURA_EXCLUDE_TAGS = {"noclaustrophobia", "rabbit", "playerghost", "abigail", "companion", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible"}

if not TheNet:GetPVPEnabled() then
    table.insert(AURA_EXCLUDE_TAGS, "player")
end

local function OnHit_Marble(inst, attacker, target)
    -- ImpactFx(inst, attacker, target)

    if target ~= nil and target:IsValid() and target.components and target.components.locomotor and not target:HasTag("stageusher") and not target:HasTag("toadstool") then

        local x, y, z = inst.Transform:GetWorldPosition()
        local tx, ty, tz = target.Transform:GetWorldPosition()

        local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))

        for i = 1, 50 do
            target:DoTaskInTime((i - 1) / 50, function(target)
                if target ~= nil and inst ~= nil then
                    -- local x, y, z = inst.Transform:GetWorldPosition()
                    -- local tx, ty, tz = target.Transform:GetWorldPosition()
                    local tx2, ty2, tz2 = target.Transform:GetWorldPosition()

                    -- local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
                    local velx = math.cos(rad) -- * 4.5
                    local velz = -math.sin(rad) -- * 4.5

                    local giantreduction = target:HasTag("epic") and 8 or target:HasTag("smallcreature") and 2 or 3

                    local dx, dy, dz = tx2 + (((inst.powerlevel) / (i + 1)) * velx) / giantreduction, ty2, tz2 + (((inst.powerlevel) / (i + 1)) * velz) / giantreduction

                    local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
                    local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
                    local ocean = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
                    local on_water = nil

                    if TUNING.DSTU.ISLAND_ADVENTURES then
                        on_water = IsOnWater(dx, dy, dz)
                    end

                    if not (target.sg ~= nil and (target.sg:HasStateTag("swimming") or target.sg:HasStateTag("invisible"))) then
                        if target ~= nil and target.components.locomotor ~= nil and dx ~= nil and (ground or boat or ocean and target.components.locomotor:CanPathfindOnWater() or target.components.tiletracker ~= nil and not target:HasTag("whale")) then
                            if not target:HasTag("aquatic") and not on_water or target:HasTag("aquatic") and on_water then
                                --[[if ocean and target.components.amphibiouscreature and not target.components.amphibiouscreature.in_water then
									target.components.amphibiouscreature:OnEnterOcean()
								end]]

                                target.Transform:SetPosition(dx, dy, dz)
                            end
                        end
                    end
                end
            end)
        end
    end

    inst:Remove()
end

local function OnHit_Melty(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()

    for i = 1, 3 do
        local marble = SpawnPrefab("slipperymarblesproj")
        marble.Transform:SetPosition(x, 2, z)
        marble.type = math.random(4)
        local targetpos = inst:GetPosition()

        targetpos.x = targetpos.x + math.random(-4, 4)
        targetpos.z = targetpos.z + math.random(-4, 4)

        local dx = targetpos.x - x
        local dz = targetpos.z - z
        local rangesq = dx * dx + dz * dz

        local maxrange = TUNING.FIRE_DETECTOR_RANGE
        local speed = easing.linear(rangesq, maxrange, 5, maxrange * maxrange)
        marble.components.complexprojectile:SetHorizontalSpeed(15)
        marble.components.complexprojectile:SetGravity(-35)
        marble.components.complexprojectile:SetLaunchOffset(Vector3(0, .25, 0))
        marble.components.complexprojectile.usehigharc = true
        marble.components.complexprojectile:Launch(targetpos, inst, inst)
    end

    inst:Remove()
end

local function OnHit_Gold(inst, attacker, target)
    if target ~= nil and target:IsValid() and target.components and target.components.locomotor then
        local x, y, z = target.Transform:GetWorldPosition()
        local goldshatter = SpawnPrefab("slingshotammo_goldshatter")
        goldshatter.Transform:SetPosition(target.Transform:GetWorldPosition())
        goldshatter.AnimState:PlayAnimation("level" .. inst.powerlevel)

        local ents = TheSim:FindEntities(x, y, z, 1.5 + inst.powerlevel, {"_combat"}, AURA_EXCLUDE_TAGS)
        local damage = (inst.ammo_def.damage * (1 + (inst.powerlevel / 2))) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1)

        for i, v in ipairs(ents) do
            if v ~= target and v:IsValid() and not v:IsInLimbo() and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
                if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
                    if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
                        if no_aggro(attacker, v) then
                            v.components.combat:SetShouldAvoidAggro(attacker)
                        end

                        v.components.combat:GetAttacked(inst, damage, inst)

                        if v.components.sleeper ~= nil and v.components.sleeper:IsAsleep() then
                            v.components.sleeper:WakeUp()
                        end

                        if v.components.combat ~= nil then
							v.components.combat:SetTarget(attacker)
                            v.components.combat:RemoveShouldAvoidAggro(attacker)
                        end
                    end
                end
            end
        end
    end
end

local function CollisionCheck(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local attacker = inst.components.projectile.owner or nil

    for i, v in ipairs(TheSim:FindEntities(x, y, z, 3, {"_combat"}, AURA_EXCLUDE_TAGS)) do
        if v:GetPhysicsRadius(0) > 1.5 and v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
            if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
                if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
                    OnAttack(inst, attacker, v)
                    inst:Remove()
                    return
                end
            end
        end
    end

    for i, v in ipairs(TheSim:FindEntities(x, y, z, 2, {"_combat"}, AURA_EXCLUDE_TAGS)) do
        if v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
            if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
                if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
                    OnAttack(inst, attacker, v)
                    inst:Remove()
                    return
                end
            end
        end
    end
end

local function projectile_fn(ammo_def)
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
    if ammo_def.symbol ~= nil then
        inst.AnimState:OverrideSymbol("rock", "slingshotammo", ammo_def.symbol)
    end

    -- projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")
    inst:AddTag("scarytoprey")

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

    if inst.powerlevel == nil then
        inst.powerlevel = 1
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(ammo_def.damage)
    inst.components.weapon:SetOnAttack(nil --[[OnAttack]] )

    inst.Physics:SetCollisionCallback(nil)

    inst:DoPeriodicTask(FRAMES, CollisionCheck)

    inst:AddComponent("locomotor")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnPreHitFn(nil)
    inst.components.projectile:SetOnHitFn(nil)
    inst.components.projectile:SetOnMissFn(nil)
    inst.components.projectile:SetLaunchOffset(Vector3(1, 0.5, 0))

    inst:DoTaskInTime(2 - (inst.powerlevel * inst.powerlevel), inst.Remove)

    return inst
end

local ammo = {
    {name = "slingshotammo_rock", damage = TUNING.SLINGSHOT_AMMO_DAMAGE_ROCKS, hit_sound = "dontstarve/characters/walter/slingshot/rock"},
    {name = "slingshotammo_gold", symbol = "gold", onhit = OnHit_Gold, damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD, hit_sound = "dontstarve/characters/walter/slingshot/gold"},
    {name = "slingshotammo_marble", symbol = "marble", onhit = OnHit_Marble, damage = TUNING.SLINGSHOT_AMMO_DAMAGE_MARBLE, hit_sound = "dontstarve/characters/walter/slingshot/marble"},
    {
        name = "slingshotammo_thulecite", -- chance to spawn a Shadow Tentacle
        symbol = "thulecite",
        onhit = OnHit_Thulecite,
        damage = TUNING.SLINGSHOT_AMMO_DAMAGE_THULECITE,
        hit_sound = "dontstarve/characters/walter/slingshot/gold"
    },
    {name = "slingshotammo_freeze", symbol = "freeze", onhit = OnHit_Ice, tags = {"extinguisher"}, onloadammo = onloadammo_ice, onunloadammo = onunloadammo_ice, damage = nil, hit_sound = "dontstarve/characters/walter/slingshot/frozen"},
    {name = "slingshotammo_slow", symbol = "slow", onhit = OnHit_Vortex, damage = TUNING.SLINGSHOT_AMMO_DAMAGE_SLOW, hit_sound = "dontstarve/characters/walter/slingshot/slow"},
    {
        name = "slingshotammo_poop", -- distraction (drop target, note: hostile creatures will probably retarget you very shortly after)
        symbol = "poop",
        onhit = OnHit_Distraction,
        damage = nil,
        hit_sound = "dontstarve/characters/walter/slingshot/poop",
        fuelvalue = TUNING.MED_FUEL / 10 -- 1/10th the value of using poop
    },
    {name = "trinket_1", no_inv_item = true, symbol = "trinket_1", onhit = OnHit_Melty, damage = TUNING.SLINGSHOT_AMMO_DAMAGE_TRINKET_1, hit_sound = "dontstarve/characters/walter/slingshot/trinket"}
}

local ammo_prefabs = {}
for _, v in ipairs(ammo) do
    v.impactfx = "slingshotammo_hitfx_" .. (v.symbol or "rock")

    local prefabs = {"shatter"}
    table.insert(prefabs, v.impactfx)
    table.insert(ammo_prefabs, Prefab(v.name .. "_proj_secondary", function() return projectile_fn(v) end, assets, prefabs))
end

return unpack(ammo_prefabs)

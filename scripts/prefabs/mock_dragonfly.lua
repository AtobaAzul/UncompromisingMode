local brain = require "brains/mock_dragonflybrain"

local assets =
{
    Asset("ANIM", "anim/dragonfly_build.zip"),
    Asset("ANIM", "anim/dragonfly_fire_build.zip"),
    Asset("ANIM", "anim/dragonfly_basic.zip"),
    Asset("ANIM", "anim/dragonfly_actions.zip"),
    Asset("ANIM", "anim/dragonfly_yule_build.zip"),
    Asset("ANIM", "anim/dragonfly_fire_yule_build.zip"),
    Asset("SOUND", "sound/dragonfly.fsb"),
}

local prefabs =
{
    "meat",
    "dragon_scales",
}

local easing = require("easing")

TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME = 240
TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED = 40
TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED = 20

local BASE_TAGS = { "structure" }
local SEE_STRUCTURE_DIST = 20

local TARGET_DIST = 3

local function LeaveWorld(inst)
    TheWorld:PushEvent("storehasslermockdragonfly", inst)
    inst:Remove()
end

local function NearPlayerBase(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, BASE_TAGS)
    if #ents >= 5 then
        inst.SeenBase = true
        return true
    end
end

local function CalcSanityAura(inst)
    return inst.components.combat.target ~= nil and -TUNING.SANITYAURA_HUGE or -TUNING.SANITYAURA_LARGE
end

--[[
local function NearPlayerBase(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, BASE_TAGS)
    if #ents >= 2 then
        inst.SeenBase = true
        return true
    end
end


local function FindBaseToAttack(inst, target)
    local structure = GetClosestInstWithTag("structure", target, 40)
    if structure ~= nil then
        inst.components.knownlocations:RememberLocation("targetbase", structure:GetPosition())
        inst.AnimState:ClearOverrideSymbol("deerclops_head")
    end
end


local function RetargetFn(inst)
  if inst:GetTimeAlive() < 5 then return end
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then return end
    if inst.spit_interval and inst.last_target_spit_time and (GetTime() - inst.last_target_spit_time) > (inst.spit_interval * 1.5)
    and inst.last_spit_time and (GetTime() - inst.last_spit_time) > (inst.spit_interval * 1.5) then
    local range = inst:GetPhysicsRadius(0) + 8
    return FindEntity(
            inst,
            TARGET_DIST,
            function(guy)
                return inst.components.combat:CanTarget(guy)
                    and (   guy.components.combat:TargetIs(inst) or
                            guy:IsNear(inst, range)
                        )
            end,
            { "_combat" },
            { "prey", "smallcreature", "INLIMBO" }
        )
		end
end
--]]

local function SetFlameOn(inst, flameon, newtarget, freeze)
    if flameon and not inst.flame_on then
        inst.flame_on = true
        if newtarget then
            inst.sg:GoToState("taunt_pre")
        end
        if math.random(100) == 50 then
            inst.rainbowtime = inst:DoPeriodicTask(0.25, function(inst)

                inst.hue = inst.hue - 0.01
                if inst.hue == 0 then
                    inst.hue = 1
                end
                inst.AnimState:SetHue(inst.hue)
            end)
        end
    elseif not flameon and inst.flame_on then
        if freeze then
            inst.flame_on = false
            inst.Light:Enable(false)
            inst.components.propagator:StopSpreading()
            inst.AnimState:SetBuild("dragonfly_build")
            inst.fire_build = false
        elseif inst.components.combat and not inst.components.combat.target then
            inst.sg:GoToState("flameoff")
        end
        if inst.rainbowtime ~= nil then
            inst.rainbowtime:Cancel()
            inst.rainbowtime = nil
        end
        inst.AnimState:SetHue(1)
    end
end

local function RetargetFn(inst)
    if inst:GetTimeAlive() < 5 then return end
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then return end
    if inst.spit_interval and inst.last_target_spit_time and
        (GetTime() - inst.last_target_spit_time) > (inst.spit_interval * 1.5)
        and inst.last_spit_time and (GetTime() - inst.last_spit_time) > (inst.spit_interval * 1.5) then
        return FindEntity(inst, 7 * TARGET_DIST, function(guy)
            return inst.components.combat:CanTarget(guy)
                and not guy:HasTag("prey")
                and not guy:HasTag("smallcreature")
                and not guy:HasTag("antlion")
        end)
    else
        return FindEntity(inst, TARGET_DIST, function(guy)
            return inst.components.combat:CanTarget(guy)
                and not guy:HasTag("prey")
                and not guy:HasTag("smallcreature")
                and not guy:HasTag("antlion")
        end)
    end
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnEntitySleep(inst)
    --[[if ((not inst:NearPlayerBase() and inst.SeenBase and not inst.components.combat:TargetIs(ThePlayer))
	--if ((not inst:NearPlayerBase() and inst.SeenBase and not inst.components.combat:TargetIs(GetPlayer()))
        or inst.components.sleeper:IsAsleep()
        or inst.KilledPlayer)
        and not NearPlayerBase(inst) then
        --Dragonfly has seen your base and been lured off! Despawn.
        --Or the dragonfly has killed you, you've been punished enough.
        --Only applies if not currently at a base
        LeaveWorld(inst)--]]
    local PlayerPosition = inst:GetNearestPlayer()

    if inst.shouldGoAway then
        LeaveWorld(inst)
    else
        --[[ elseif (not inst:NearPlayerBase() and not inst.SeenBase) and ThePlayer ~= nil
        or (inst.components.combat:TargetIs(ThePlayer) and not inst.KilledPlayer) then
        --Get back in there Dragonfly! You still have work to do.--]]

        if PlayerPosition ~= nil and not inst:NearPlayerBase() and not inst.SeenBase then
            local init_pos = inst:GetPosition()
            local player_pos = PlayerPosition:GetPosition()
            if player_pos then
                local angle = PlayerPosition:GetAngleToPoint(init_pos)
                local offset = FindWalkableOffset(player_pos, angle * DEGREES, 30, 10)
                if offset ~= nil then

                    local pos = player_pos + offset

                    if pos and distsq(player_pos, init_pos) > 1600 then
                        --There's a crash if you teleport without the delay
                        if not inst.components.combat:TargetIs(PlayerPosition) then
                            inst.components.combat:SetTarget(nil)
                        end
                        inst:DoTaskInTime(.1, function()
                            inst.Transform:SetPosition(pos:Get())
                        end)

                        SetFlameOn(inst, false)
                    end

                else
                    local offset = FindSwimmableOffset(player_pos, angle * DEGREES, 30, 10)
                    local pos = player_pos + offset

                    if pos and distsq(player_pos, init_pos) > 1600 then
                        --There's a crash if you teleport without the delay
                        if not inst.components.combat:TargetIs(PlayerPosition) then
                            inst.components.combat:SetTarget(nil)
                        end
                        inst:DoTaskInTime(.1, function()
                            inst.Transform:SetPosition(pos:Get())
                        end)

                        SetFlameOn(inst, false)
                    end
                end
            end
        end
    end
end

local function AfterWorking(inst, data)
    if data.target then
        local recipe = AllRecipes[data.target.prefab]
        if recipe then
            inst.structuresDestroyed = inst.structuresDestroyed + 1
            if inst:IsSated() then
                inst.components.knownlocations:ForgetLocation("targetbase")
                --inst.AnimState:OverrideSymbol("deerclops_head", IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and "deerclops_yule" or "deerclops_build", "deerclops_head_neutral")
            end
        end
    end
end

local function OnSave(inst, data)
    data.SeenBase = inst.SeenBase
    data.vomits = inst.num_targets_vomited
    data.KilledPlayer = inst.KilledPlayer
    data.shouldGoAway = inst.shouldGoAway
end

local function OnLoad(inst, data)
    if data then
        inst.SeenBase = data.SeenBase
        inst.num_targets_vomited = data.vomits
        inst.KilledPlayer = data.KilledPlayer or false
        inst.shouldGoAway = data.shouldGoAway or false

        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying")
    end
end

local function OnSeasonChange(inst, data)
    inst.shouldGoAway = (TheWorld.state.isspring or TheWorld.state.isautumn or TheWorld.state.iswinter)
    if inst:IsAsleep() then
        OnEntitySleep(inst)
    end
end

local function OnAttacked(inst, data)
    inst:ClearBufferedAction()
    inst.components.combat:SetTarget(data.attacker)
end

local function OnFreeze(inst)
    inst.SoundEmitter:KillSound("flying")
    inst:ClearBufferedAction()
    SetFlameOn(inst, false, nil, true)
end

local function OnUnfreeze(inst)
    inst.recently_frozen = true
    inst.components.locomotor.walkspeed = 2
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying")
    inst.components.combat:SetTarget(nil)

    inst:DoTaskInTime(5, function(inst)
        inst.recently_frozen = false
        inst.components.locomotor.walkspeed = 4
        inst.spit_interval = math.random(20, 30)
    end)
end

local function ShouldSleep(inst)
    if (
        (inst.num_targets_vomited >= TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED) or
            (inst.num_ashes_eaten >= TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED))
        and inst.arrivedatsleepdestination then
        inst.num_targets_vomited = 0
        inst.num_ashes_eaten = 0
        inst.sleep_time = GetTime()
        inst.arrivedatsleepdestination = false
        inst.components.locomotor.atdestfn = nil
        return true
    end
    return false
end

local function ShouldWake(inst)
    local wake = inst.sleep_time and (GetTime() - inst.sleep_time) > TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME
    if wake == nil then wake = true end
    wake = wake
        or (inst.components.combat and inst.components.combat.target)
        or (inst.components.freezable and inst.components.freezable:IsFrozen())
    if wake then inst.hassleepdestination = false end
    return wake
end

local function OnCollide(inst, other)
    if other and other:HasTag("burnt") then
        -- local v1 = Vector3(inst.Physics:GetVelocity())
        -- if v1:LengthSq() < 1 then return end

        inst:DoTaskInTime(2 * FRAMES, function()
            if other and other.components.workable and other.components.workable.workleft > 0 then
                SpawnPrefab("collapse_small").Transform:SetPosition(other:GetPosition():Get())
                other.components.lootdropper:SetLoot({})
                other.components.workable:Destroy(inst)
            end
        end)
    end
end

local function OnSleep(inst)
    inst.SoundEmitter:KillSound("flying")
    inst.SoundEmitter:KillSound("vomitrumble")
    inst.SoundEmitter:KillSound("sleep")
    inst.SoundEmitter:KillSound("fireflying")
end

local function OnRemove(inst)
    TheWorld:PushEvent("mockflyremoved", inst)
    inst.SoundEmitter:KillSound("flying")
    inst.SoundEmitter:KillSound("vomitrumble")
    inst.SoundEmitter:KillSound("sleep")
    inst.SoundEmitter:KillSound("fireflying")
end

local function OnKill(inst, data)
    if inst.components.combat and data and data.victim == inst.components.combat.target then
        inst.components.combat.target = nil
        inst.last_kill_time = GetTime()
    end

    local PlayerPosition = inst:GetNearestPlayer()

    if data and PlayerPosition ~= nil then
        if data.victim == PlayerPosition then
            --if data and data.victim == GetPlayer() then
            --inst.KilledPlayer = true
            SetFlameOn(inst, false)
        end
    end --]]
end

local loot = { "meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat", "dragon_scales" }

local function OnDead(inst)
    TheWorld:PushEvent("mockflykilled", inst)
end

local function CheckTarget(inst)
    if not inst.components.combat:HasTarget() and not inst.components.health:IsDead() then
        SetFlameOn(inst, false)
    end

    inst:DoTaskInTime(10, CheckTarget)
end

local function OnRemove(inst)
    TheWorld:PushEvent("mockflyremoved", inst)
end

local function RockThrowTimer(inst, data)
    if data.name == "RockThrow" then
        inst.rockthrow = true

        --EquipWeapon(inst)
    end
end

local function LaunchProjectile(inst)
    local target = inst.components.combat.target
    if target ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local projectile = SpawnPrefab("fireball_throwable")
        projectile.Transform:SetPosition(x, y, z)
        local a, b, c = target.Transform:GetWorldPosition()
        local targetpos = target:GetPosition()
        targetpos.x = targetpos.x + math.random(-1, 1)
        targetpos.z = targetpos.z + math.random(-1, 1)
        local dx = a - x
        local dz = c - z
        local rangesq = dx * dx + dz * dz
        local maxrange = 20
        local bigNum = 15
        local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange * 2)
        projectile:AddTag("canthit")

        projectile.components.complexprojectile:SetLaunchOffset(Vector3(5, 4, 0))
        --projectile.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS/2
        projectile.components.complexprojectile:SetHorizontalSpeed(speed + math.random(4, 9))
        projectile.components.complexprojectile:SetGravity(-55)
        projectile.components.complexprojectile:Launch(targetpos, inst, inst)
        projectile.dragonflyspit = true
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(6, 3.5)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(6, 3.5)

    inst.Transform:SetSixFaced()
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying")

    inst.Transform:SetScale(1.3, 1.3, 1.3)

    --MakePoisonableCharacter(inst)
    --MakeCharacterPhysics(inst, 500, 1.4)

    MakeFlyingGiantCharacterPhysics(inst, 500, 1.4)

    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)

    inst.Physics:SetCollisionCallback(OnCollide)

    inst.OnEntitySleep = OnSleep
    inst.OnRemoveEntity = OnRemove

    inst.AnimState:SetBank("dragonfly")
    inst.AnimState:SetBuild("dragonfly_build")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetMultColour(0.6, 0.6, 0.3, 1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("mock_dragonfly")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("insect")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(4000 * TUNING.DSTU.WILTFLY_HEALTH)
    inst.components.health.destroytime = 5
    inst.components.health.fire_damage_scale = 0

    local function isnottree(ent)
        if ent ~= nil and not ent:HasTag("mock_dragonfly") and not ent:HasTag("dragonfly") and not ent:HasTag("lavae") then -- fix to friendly AOE: refer for later AOE mobs -Axe
            return true
        end
    end

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.numRings = 2
    inst.components.groundpounder.burner = true
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpounddamagemult = .5
    inst.components.groundpounder.groundpoundringfx = "firering_fx"
    inst.components.groundpounder.noTags = { "FX", "NOCLICK", "DECOR", "INLIMBO", "dragonfly", "lavae" }

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.DSTU.MOCK_DRAGONFLY_DAMAGE)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(4)
    --inst.components.combat:SetAreaDamage(6, 0.8)
    inst.components.combat:SetAreaDamage(6, 0.8, isnottree)
    inst.components.combat.hiteffectsymbol = "dragonfly_body"
    inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/dragonfly/hurt")

    inst:AddComponent("explosiveresist")

    inst.flame_on = false
    inst.KilledPlayer = false
    inst:ListenForEvent("killed", OnKill)
    inst:ListenForEvent("losttarget", function(inst)
        SetFlameOn(inst, false)
    end)
    inst:ListenForEvent("giveuptarget", function(inst)
        SetFlameOn(inst, false)
    end)
    inst:ListenForEvent("newcombattarget", function(inst, data)
        if data.target ~= nil then
            SetFlameOn(inst, true, true)
        end
    end)
    inst.SetFlameOn = SetFlameOn

    MakeLargePropagator(inst)
    inst.components.propagator.decayrate = 0

    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(235 / 255, 121 / 255, 12 / 255)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.playsleepsound = false
    inst.shouldGoAway = false

    inst:AddComponent("timer")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("knownlocations")
    inst:AddComponent("inventory")

    inst:ListenForEvent("seasontick", function() OnSeasonChange(inst) end, TheWorld)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entitysleep", OnEntitySleep)

    MakeHugeFreezableCharacter(inst, "dragonfly_body")
    inst.components.freezable.wearofftime = 1.5
    inst:ListenForEvent("freeze", OnFreeze)
    inst:ListenForEvent("unfreeze", OnUnfreeze)

    if TUNING.DSTU.VETCURSE ~= "off" then
        inst:AddComponent("vetcurselootdropper")
        inst.components.vetcurselootdropper.loot = "slobberlobber"
    end
    inst:DoTaskInTime(10, CheckTarget)

    inst.SeenBase = false
    inst.NearPlayerBase = NearPlayerBase
    inst.last_spit_time = nil
    inst.last_target_spit_time = nil
    inst.spit_interval = math.random(20, 30)
    inst.num_targets_vomited = 0
    inst.num_ashes_eaten = 0

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 6

    inst:SetStateGraph("SGmock_dragonfly")
    --local brain = require("brains/dragonflybrain")
    inst:SetBrain(brain)

    inst:ListenForEvent("onremove", OnRemove)
    inst:ListenForEvent("death", OnDead)

    inst:ListenForEvent("timerdone", RockThrowTimer)

    inst.rockthrow = true

    inst.LaunchProjectile = LaunchProjectile

    inst.hue = 0
    --if math.random() > 0.99 then

    --end

    return inst
end

return Prefab("mock_dragonfly", fn, assets, prefabs)

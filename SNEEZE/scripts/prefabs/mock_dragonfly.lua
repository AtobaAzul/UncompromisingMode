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
	
    Asset("ANIM", "anim/deerclops_basic.zip"),
    Asset("ANIM", "anim/deerclops_actions.zip"),
    Asset("ANIM", "anim/deerclops_build.zip"),
    Asset("ANIM", "anim/deerclops_yule.zip"),
    Asset("SOUND", "sound/deerclops.fsb"),
}

local prefabs =
{
    "meat",
    "deerclops_eyeball",
    "chesspiece_deerclops_sketch",
    "icespike_fx_1",
    "icespike_fx_2",
    "icespike_fx_3",
    "icespike_fx_4",
    "deerclops_laser",
    "deerclops_laserempty",
    "winter_ornament_light1",
}

local TARGET_DIST = 16
local STRUCTURES_PER_HARASS = 5

local function LeaveWorld(inst)
    inst:Remove()
end

local function IsSated(inst)
    return inst.structuresDestroyed >= STRUCTURES_PER_HARASS
end

local function WantsToLeave(inst)
    return not inst.components.combat:HasTarget()
        and inst:IsSated()
        and inst:GetTimeAlive() >= 120
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
--]]

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

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end
--[[
local function OnEntitySleep(inst)
    if ((not inst:NearPlayerBase() and inst.SeenBase and not inst.components.combat:TargetIs(GetPlayer()))
        or inst.components.sleeper:IsAsleep() 
        or inst.KilledPlayer)
        and not NearPlayerBase(inst) then
        --Dragonfly has seen your base and been lured off! Despawn.
        --Or the dragonfly has killed you, you've been punished enough.
        --Only applies if not currently at a base
        LeaveWorld(inst)
    elseif (not inst:NearPlayerBase() and not inst.SeenBase) 
        or (inst.components.combat:TargetIs(GetPlayer()) and not inst.KilledPlayer) then
        --Get back in there Dragonfly! You still have work to do.
        print("Porting Dragonfly to Player!")
        local init_pos = inst:GetPosition()
        local player_pos = GetPlayer():GetPosition()
        local angle = GetPlayer():GetAngleToPoint(init_pos)
        local offset = FindWalkableOffset(player_pos, angle*DEGREES, 30, 10)
        local pos = player_pos + offset
        
        if pos and distsq(player_pos, init_pos) > 1600 then
            --There's a crash if you teleport without the delay
            if not inst.components.combat:TargetIs(GetPlayer()) then
                inst.components.combat:SetTarget(nil)
            end
            inst:DoTaskInTime(.1, function() 
                inst.Transform:SetPosition(pos:Get())
            end)
        end
    elseif inst.shouldGoAway then
        LeaveWorld(inst)
    end
end
--]]

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

--]]
local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

local function OnEntitySleep(inst)
    if inst:WantsToLeave() then
        inst.structuresDestroyed = 0 -- reset this for the stored version
        TheWorld:PushEvent("storehassler", inst)
        inst:Remove()
    end
end

local function OnStopWinter(inst)
    if inst:IsAsleep() then
        TheWorld:PushEvent("storehassler", inst)
        inst:Remove()
    end
end

local function OnSave(inst, data)
    data.structuresDestroyed = inst.structuresDestroyed
end

local function OnLoad(inst, data)
    if data then
        inst.structuresDestroyed = data.structuresDestroyed or inst.structuresDestroyed
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    if data.attacker:HasTag("player") and inst.structuresDestroyed < STRUCTURES_PER_HARASS and inst.components.knownlocations:GetLocation("targetbase") == nil then
        FindBaseToAttack(inst, data.attacker)
    end
end

local function OnHitOther(inst, data)
    local other = data.target
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if other.components.freezable ~= nil then
                other.components.freezable:AddColdness(2)
            end
            if other.components.temperature ~= nil then
                local mintemp = math.max(other.components.temperature.mintemp, 0)
                local curtemp = other.components.temperature:GetCurrent()
                if mintemp < curtemp then
                    other.components.temperature:DoDelta(math.max(-5, mintemp - curtemp))
                end
            end
        end
        if other.components.freezable ~= nil then
            other.components.freezable:SpawnShatterFX()
        end
    end
end

local function OnRemove(inst)
    TheWorld:PushEvent("hasslerremoved", inst)
end

local function OnDead(inst)
    AwardRadialAchievement("deerclops_killed", inst:GetPosition(), TUNING.ACHIEVEMENT_RADIUS_FOR_GIANT_KILL)
    TheWorld:PushEvent("hasslerkilled", inst)
end

local function oncollapse(inst, other)
    if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        other.components.workable:Destroy(inst)
    end
end

local function oncollide(inst, other)
    if other ~= nil and
        (other:HasTag("tree") or other:HasTag("boulder")) and --HasTag implies IsValid
        Vector3(inst.Physics:GetVelocity()):LengthSq() >= 1 then
        inst:DoTaskInTime(2 * FRAMES, oncollapse, other)
    end
end

local function OnNewTarget(inst, data)
    FindBaseToAttack(inst, data.target or inst)
    if inst.components.knownlocations:GetLocation("targetbase") and data.target:HasTag("player") then
        inst.structuresDestroyed = inst.structuresDestroyed - 1
        inst.components.knownlocations:ForgetLocation("home")
    end
end
--[[
local function OnNewState(inst, data)
    if not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("waking")) then
        inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(1, 0, 0)
    end
end
--]]

local function OnHealthTrigger(inst)
    inst:PushEvent("transform", { transformstate = "normal" })
    inst.components.rampingspawner:Start() 
end

local loot = {"meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat", "dragon_scales", "dragonflyfurnace_blueprint"}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeGiantCharacterPhysics(inst, 1000, .5)
	inst.Transform:SetSixFaced()

    local s  = 1.65
    inst.Transform:SetScale(s, s, s)
    inst.DynamicShadow:SetSize(6, 3.5)
    inst.Transform:SetFourFaced()

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("mock_dragonfly")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")

    inst.AnimState:SetBank("dragonfly")
	inst.AnimState:SetBuild("dragonfly_build")
	inst.AnimState:PlayAnimation("idle", true)
--[[
    if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
        inst.AnimState:SetBuild("deerclops_yule")

        inst.entity:AddLight()
        inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(1, 0, 0)
    else
        inst.AnimState:SetBuild("deerclops_build")
    end
	

    inst.AnimState:PlayAnimation("idle_loop", true)
--]]
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(oncollide)

    inst.structuresDestroyed = 0

    ------------------------------------------

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 3  

    ------------------------------------------
    inst:SetStateGraph("SGmock_dragonfly")

    ------------------------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
--[[
    MakeLargeBurnableCharacter(inst, "deerclops_body")
    MakeHugeFreezableCharacter(inst, "deerclops_body")
--]]
    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.DEERCLOPS_HEALTH)

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.DEERCLOPS_DAMAGE)
    inst.components.combat.playerdamagepercent = TUNING.DEERCLOPS_DAMAGE_PLAYER_PERCENT
    inst.components.combat:SetRange(TUNING.DEERCLOPS_ATTACK_RANGE)
    inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE, TUNING.DEERCLOPS_AOE_SCALE)
    inst.components.combat.hiteffectsymbol = "deerclops_body"
    inst.components.combat:SetAttackPeriod(TUNING.DEERCLOPS_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:AddComponent("groundpounder")
	
	inst.components.groundpounder.numRings = 2
    inst.components.groundpounder.burner = true
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpounddamagemult = 0.5
    inst.components.groundpounder.groundpoundringfx = "firering_fx"

    ------------------------------------------
    inst:AddComponent("explosiveresist")

    ------------------------------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
    ------------------------------------------
    inst:AddComponent("knownlocations")
    inst:SetBrain(brain)

    inst:ListenForEvent("working", AfterWorking)
    inst:ListenForEvent("entitysleep", OnEntitySleep)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onhitother", OnHitOther)
    inst:ListenForEvent("death", OnDead)
    inst:ListenForEvent("onremove", OnRemove)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

    inst:WatchWorldState("stopwinter", OnStopWinter)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.IsSated = IsSated
    inst.WantsToLeave = WantsToLeave
--[[
    if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
        inst:AddComponent("timer")

        inst:ListenForEvent("newstate", OnNewState)
    end
--]]
    return inst
end

return Prefab("mock_dragonfly", fn, assets, prefabs)

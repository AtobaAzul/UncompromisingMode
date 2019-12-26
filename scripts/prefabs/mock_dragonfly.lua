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

TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME = 240
TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED = 40
TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED = 20

local BASE_TAGS = {"structure"}
local SEE_STRUCTURE_DIST = 20

local TARGET_DIST = 3

local function LeaveWorld(inst)
    inst:Remove()
end

local function NearPlayerBase(inst)
    local pt = inst:GetPosition()
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, BASE_TAGS)
    if #ents >= 2 then
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
local function RetargetFn(inst)
    if inst:GetTimeAlive() < 5 then return end
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then return end
    if inst.spit_interval and inst.last_target_spit_time and (GetTime() - inst.last_target_spit_time) > (inst.spit_interval * 1.5) 
    and inst.last_spit_time and (GetTime() - inst.last_spit_time) > (inst.spit_interval * 1.5) then
        return FindEntity(inst, 7*TARGET_DIST, function(guy) 
            return inst.components.combat:CanTarget(guy)
               and not guy:HasTag("prey")
               and not guy:HasTag("smallcreature")
        end)
    else
        return FindEntity(inst, TARGET_DIST, function(guy) 
            return inst.components.combat:CanTarget(guy)
               and not guy:HasTag("prey")
               and not guy:HasTag("smallcreature")
        end)
    end
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnEntitySleep(inst)
    if ((not inst:NearPlayerBase() and inst.SeenBase and not inst.components.combat:TargetIs(ThePlayer))
	--if ((not inst:NearPlayerBase() and inst.SeenBase and not inst.components.combat:TargetIs(GetPlayer()))
        or inst.components.sleeper:IsAsleep() 
        or inst.KilledPlayer)
        and not NearPlayerBase(inst) then
        --Dragonfly has seen your base and been lured off! Despawn.
        --Or the dragonfly has killed you, you've been punished enough.
        --Only applies if not currently at a base
        LeaveWorld(inst)
		
    elseif (not inst:NearPlayerBase() and not inst.SeenBase) and ThePlayer ~= nil 
        or (inst.components.combat:TargetIs(ThePlayer) and not inst.KilledPlayer) then
        --Get back in there Dragonfly! You still have work to do.
        print("Porting Dragonfly to Player!")
        local init_pos = inst:GetPosition()
        local player_pos = ThePlayer:GetPosition()
        local angle = ThePlayer:GetAngleToPoint(init_pos)
        local offset = FindWalkableOffset(player_pos, angle*DEGREES, 30, 10)
        local pos = player_pos + offset
        
        if pos and distsq(player_pos, init_pos) > 1600 then
            --There's a crash if you teleport without the delay
            if not inst.components.combat:TargetIs(ThePlayer) then
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
    end
end

local function OnSeasonChange(inst, data)
    inst.shouldGoAway = (GetSeasonManager():GetSeason() ~= SEASONS.SUMMER or GetSeasonManager().incaves)
    if inst:IsAsleep() then
        OnEntitySleep(inst)
    end
end
--[[
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

local function OnNewState(inst, data)
    if not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("waking")) then
        inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(1, 0, 0)
    end
end
--]]


local function SetFlameOn(inst, flameon, newtarget, freeze)
    if flameon and not inst.flame_on then
        inst.flame_on = true
        if newtarget then
            inst.sg:GoToState("taunt_pre")
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
        inst.spit_interval = math.random(20,30)
    end)
end

local function ShouldSleep(inst)
    if ((inst.num_targets_vomited >= TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED) or (inst.num_ashes_eaten >= TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED))
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
    if other:HasTag("burnt") then
        -- local v1 = Vector3(inst.Physics:GetVelocity())
        -- if v1:LengthSq() < 1 then return end

        inst:DoTaskInTime(2*FRAMES, function()
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

    if data and data.victim == ThePlayer then
	--if data and data.victim == GetPlayer() then
        --inst.KilledPlayer = true
    end
end

--[[

local function OnHealthTrigger(inst)
    inst:PushEvent("transform", { transformstate = "normal" })
    inst.components.rampingspawner:Start() 
end
--]]

local loot = {"meat", "meat", "meat", "meat", "meat", "meat", "meat", "meat", "dragon_scales", "dragonflyfurnace_blueprint"}

local function OnDead(inst)
    TheWorld:PushEvent("hasslerkilled", inst)
end


local function fn(Sim)
    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
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

    inst.Transform:SetScale(1.3,1.3,1.3)
    
    --MakePoisonableCharacter(inst)
	MakeCharacterPhysics(inst, 500, 1.4)
    inst.Physics:SetCollisionCallback(OnCollide)

    inst.OnEntitySleep = OnSleep 
    inst.OnRemoveEntity = OnRemove

    anim:SetBank("dragonfly")
    anim:SetBuild("dragonfly_build")
    anim:PlayAnimation("idle", true)
	
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

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.DEERCLOPS_HEALTH)
    inst.components.health.destroytime = 5
    inst.components.health.fire_damage_scale = 0

    inst:AddComponent("groundpounder")
    inst.components.groundpounder.numRings = 2
    inst.components.groundpounder.burner = true
    inst.components.groundpounder.groundpoundfx = "firesplash_fx"
    inst.components.groundpounder.groundpounddamagemult = .5
    inst.components.groundpounder.groundpoundringfx = "firering_fx"
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.DRAGONFLY_DAMAGE)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(4)
    inst.components.combat:SetAreaDamage(6, 0.8)
    inst.components.combat.hiteffectsymbol = "dragonfly_body"
    inst.components.combat:SetAttackPeriod(TUNING.DRAGONFLY_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/dragonfly/hurt")
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
    inst.Light:SetColour(235/255,121/255,12/255)
 
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.playsleepsound = false
    inst.shouldGoAway = false

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("dragonfly")
    
    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("knownlocations")
    inst:AddComponent("inventory")

    inst:ListenForEvent("seasonChange", function() OnSeasonChange(inst) end, GetWorld() )
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entitysleep", OnEntitySleep)

    MakeHugeFreezableCharacter(inst, "dragonfly_body")
    inst.components.freezable.wearofftime = 1.5
    inst:ListenForEvent("freeze", OnFreeze)
    inst:ListenForEvent("unfreeze", OnUnfreeze)

    inst.SeenBase = false
    inst.NearPlayerBase = NearPlayerBase
    inst.last_spit_time = nil
    inst.last_target_spit_time = nil
    inst.spit_interval = math.random(20,30)
    inst.num_targets_vomited = 0
    inst.num_ashes_eaten = 0

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4

    inst:SetStateGraph("SGmock_dragonfly")
    --local brain = require("brains/dragonflybrain")
    inst:SetBrain(brain)
    
    
    inst:ListenForEvent("death", OnDead)

    return inst
end


--[[
local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	shadow:SetSize(6, 3.5)
	
	inst.Transform:SetFourFaced()
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying")

    

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

    MakeLargeBurnableCharacter(inst, "deerclops_body")
    MakeHugeFreezableCharacter(inst, "deerclops_body")

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

    if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
        inst:AddComponent("timer")

        inst:ListenForEvent("newstate", OnNewState)
    end

    return inst
end

--]]

return Prefab("mock_dragonfly", fn, assets, prefabs)

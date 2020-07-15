require "brains/vampirebatbrain"
require "stategraphs/SGvampirebat"

local assets=
{
    Asset("ANIM", "anim/bat_basic.zip"),
    Asset("ANIM", "anim/bat_vamp_build.zip"),
    Asset("ANIM", "anim/bat_vamp_shadow.zip"),
    Asset("SOUND", "sound/bat.fsb"),
    Asset("INV_IMAGE", "bat"),
}

local prefabs =
{
    "guano",
    "batwing",
    "pigskin",
	"monstersmallmeat",
}

SetSharedLootTable( 'vampirebat',
{
    {'monstersmallmeat',0.25},
    {'pigskin',0.05},
    {'batwing',1},
})

local SLEEP_DIST_FROMHOME = 1
local SLEEP_DIST_FROMTHREAT = 20
local MAX_CHASEAWAY_DIST = 80
local MAX_TARGET_SHARES = 100
local SHARE_TARGET_DIST = 100

local function MakeTeam(inst, attacker)
    local leader = SpawnPrefab("teamleader")
    leader:AddTag("bat")
    leader.components.teamleader.threat = attacker
    leader.components.teamleader.team_type = inst.components.teamattacker.team_type
    leader.components.teamleader:NewTeammate(inst)
    leader.components.teamleader:BroadcastDistress(inst)
end

local function OnWingDown(inst)
    inst.SoundEmitter:PlaySound("UCSounds/vampirebat/flap")
end

local function OnWingDownShadow(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/vampire_bat/distant_flap")
end
local function OnSleepGoHome(inst)
    inst._hometask = nil
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home ~= nil and home:IsValid() and home.components.childspawner ~= nil then
        home.components.childspawner:GoHome(inst)
    end
end

local function OnIsDay(inst, isday)
    if isday then
        if inst._hometask == nil then
            inst._hometask = inst:DoTaskInTime(10 + math.random(), OnSleepGoHome)
        end
    elseif inst._hometask ~= nil then
        inst._hometask:Cancel()
        inst._hometask = nil
    end
end

local function StopWatchingDay(inst)
    inst:StopWatchingWorldState("isday", OnIsDay)
    if inst._hometask ~= nil then
        inst._hometask:Cancel()
        inst._hometask = nil
    end
end

local function StartWatchingDay(inst)
    inst:WatchWorldState("isday", OnIsDay)
    OnIsDay(inst, TheWorld.state.isday)
end

local function OnEntitySleep(inst)
    inst:ListenForEvent("enterlimbo", StopWatchingDay)
    inst:ListenForEvent("exitlimbo", StartWatchingDay)
    if not inst:IsInLimbo() then
        StartWatchingDay(inst)
    end
end

local function OnEntityWake(inst)
    inst:RemoveEventCallback("enterlimbo", StopWatchingDay)
    inst:RemoveEventCallback("exitlimbo", StartWatchingDay)
    if not inst:IsInLimbo() then
        StopWatchingDay(inst)
    end
end

-- TEAM ATTACKER STUFF


local function KeepTarget(inst, target)
    if (inst.components.teamattacker.teamleader and not inst.components.teamattacker.teamleader:CanAttack()) or
        inst.components.teamattacker.orders == "ATTACK" then
        return true
    else
        return false
    end 
end

local function retargetfn(inst)
    local ta = inst.components.teamattacker

    local newtarget = FindEntity(inst, TUNING.BISHOP_TARGET_DIST, function(guy)
            return (guy:HasTag("character") or guy:HasTag("monster") )
                   and not guy:HasTag("bat")
                   and inst.components.combat:CanTarget(guy)
    end)

    if newtarget and not ta.inteam and not ta:SearchForTeam() then
        MakeTeam(inst, newtarget)
    end

    if ta.inteam and not ta.teamleader:CanAttack() then
        return newtarget
    end
end

local function OnAttacked(inst, data)
    if not inst.components.teamattacker.inteam and not inst.components.teamattacker:SearchForTeam() then
        MakeTeam(inst, data.attacker)
    elseif inst.components.teamattacker.teamleader then    
        inst.components.teamattacker.teamleader:BroadcastDistress()   --Ask for  help!
    end

    if inst.components.teamattacker.inteam and not inst.components.teamattacker.teamleader:CanAttack() then
        local attacker = data and data.attacker
        inst.components.combat:SetTarget(attacker)
        inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("bat") end, MAX_TARGET_SHARES)
    end
end


--[[
local function KeepTarget(inst, target)
    local shouldkeep = inst.components.combat:CanTarget(target) and (not inst:HasTag("pet_hound") or inst:IsNear(target, TUNING.HOUND_FOLLOWER_TARGET_KEEP))
   -- local onboat = target.components.driver and target.components.driver:GetIsDriving()
    return shouldkeep
end

local function retargetfn(inst)
    local dist = TUNING.HOUND_TARGET_DIST
    if inst:HasTag("pet_hound") then
        dist = TUNING.HOUND_FOLLOWER_TARGET_DIST
    end
    local notags = {"FX", "NOCLICK","INLIMBO", "wall", "vampirebat"}
    return FindEntity(inst, dist, function(guy) 
        local shouldtarget = inst.components.combat:CanTarget(guy)
        return shouldtarget
    end, nil, notags)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("hound") or dude:HasTag("houndfriend") and not dude.components.health:IsDead() end, 5)
end
]]
local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("bat") and not dude.components.health:IsDead() end, 5)
end

local function OnWaterChange(inst, onwater)
    if onwater then
        inst.onwater = true
    else
        inst.onwater = false        
    end
end

local function onsave(inst, data)    
    if inst:HasTag("batfrenzy") then
        data.batfrenzy = true
    end
    if inst.sg:HasStateTag("sleeping") then
        data.forcesleep = true
    end
end

local function onload(inst, data)
  if data then
    if data.batfrenzy then
        inst:AddTag("batfrenzy")
    end
    if data.forcesleep then
        inst.sg:GoToState("forcesleep")
        inst.components.sleeper.hibernate = true
        inst.components.sleeper:GoToSleep()
    end    
  end
end
local function OnPreLoad(inst, data)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y > 0 then
		inst.Transform:SetPosition(x, 0, z)
	end
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, .75 )
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()

	--shadow:SetSize(1, 0.75)
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(0.9, 0.9, 0.9)
	MakeFlyingCharacterPhysics(inst, 1, .5)
	--MakePoisonableCharacter(inst)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
    --MakeAmphibiousCharacterPhysics(inst, 1, .5)
   -- inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    --inst.Physics:CollidesWith(COLLISION.FLYERS) 
    --inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst:AddTag("bat")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("flying")

    inst.AnimState:SetBank("bat")
    inst.AnimState:SetBuild("bat_vamp_build")
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 10

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    inst.components.eater.strongstomach = true -- can eat monster meat!
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(130)
     
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(25)
    inst.components.combat:SetAttackPeriod(1.8)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
	    inst.components.sleeper.sleeptestfn = NocturnalSleepTest
    inst.components.sleeper.waketestfn = NocturnalWakeTest
    
    inst:SetStateGraph("SGvampirebat")
 
    local brain = require "brains/vampirebatbrain"
    inst:SetBrain(brain)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('vampirebat')

    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
    
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)
    
    inst:ListenForEvent("wingdown", OnWingDown)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)
    --inst:ListenForEvent("death", OnKilled)

    --inst:AddComponent("tiletracker")
    --inst.components.tiletracker:SetOnWaterChangeFn(OnWaterChange)    

    inst:AddComponent("teamattacker")
    inst.components.teamattacker.team_type = "vampirebat"
    inst.MakeTeam = MakeTeam
	MakeHauntablePanic(inst)
    MakeMediumBurnableCharacter(inst, "bat_body")
    MakeMediumFreezableCharacter(inst, "bat_body")
	
	inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
    inst.OnPreLoad = OnPreLoad
	
    inst.OnSave = onsave 
    inst.OnLoad = onload 

    inst.cavebat = false
    
    return inst
end

local function dodive(inst)
    if not TheCamera.interior and inst:IsOnValidGround() then
        local bat = SpawnPrefab("vampirebat")
        local spawn_pt = Vector3(inst.Transform:GetWorldPosition())
        if bat and spawn_pt then
            local x,y,z  = spawn_pt:Get()
            bat.Transform:SetPosition(x,y+30,z)
            bat:FacePoint(GetPlayer().Transform:GetWorldPosition())           
            bat.sg:GoToState("glide")               
            bat:AddTag("batfrenzy")

            bat:DoTaskInTime(2,function()  bat:PushEvent("attacked", {attacker = GetPlayer(), damage = 0, weapon = nil}) end)
        end
        inst:Remove()
    else
        inst.task = inst:DoTaskInTime(5+(math.random()*2),function() dodive(inst) end)
    end
end


local function onsaveshadow(inst, data)    
    if inst.task then
        data.task = inst:TimeRemainingInTask(inst.task)
    end
end

local function onloadshadow(inst, data)
  if data then
    if data.task then
        inst.task = inst:DoTaskInTime(data.task,function() dodive(inst) end)
    end  
  end
end

local function circlingbatfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()

    MakeAmphibiousGhostPhysics(inst, 1, .5)

    anim:SetBank("bat_vamp_shadow")
    anim:SetBuild("bat_vamp_shadow")
    anim:PlayAnimation("shadow_flap_loop", true)
    anim:SetOrientation( ANIM_ORIENTATION.OnGround )
    anim:SetLayer( LAYER_BACKGROUND )
    anim:SetSortOrder( 3 )

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.walkspeed = 10

    inst:AddComponent("circler")
    inst.components.circler.track = 8
    
    inst.dodive = dodive

    inst.AnimState:SetMultColour(1,1,1,0)
    inst:AddComponent("colourtweener")
    if not GetClock():IsNight() then
        inst.components.colourtweener:StartTween({1,1,1,1}, 3)
    end

    inst.persists = false

    inst:ListenForEvent("wingdown", OnWingDownShadow)
    -- flap sound
    inst:DoPeriodicTask(10/30, function() inst:PushEvent("wingdown") end)
    -- screech sound
    inst:DoPeriodicTask(1, function() if math.random()<0.1 then inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/vampire_bat/distant_taunt") end end)

    inst:ListenForEvent("daytime", function()
        if not GetSeasonManager() or not GetSeasonManager():IsWinter() then
            inst.components.colourtweener:StartTween({1,1,1,1}, 3)
        end
    end, GetWorld())

    inst:ListenForEvent("nighttime", function() 
            inst.components.colourtweener:StartTween({1,1,1,0}, 3)
    end, GetWorld())

    inst.task = inst:DoTaskInTime(20+(math.random()*2),function() dodive(inst) end)

    inst.OnSave = onsaveshadow
    inst.OnLoad = onloadshadow

    return inst
end

return Prefab("vampirebat", fn, assets, prefabs) --,
       --Prefab("badlands/objects/circlingbat", circlingbatfn, assets, prefabs)


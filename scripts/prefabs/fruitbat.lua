require "brains/fruitbatbrain"
require "stategraphs/SGfruitbat"

local assets=
{
    Asset("ANIM", "anim/bat_basic.zip"),
    Asset("ANIM", "anim/fruitbat.zip"),
    Asset("SOUND", "sound/bat.fsb"),
    Asset("INV_IMAGE", "bat"),
}

local prefabs =
{
    "seeds",
}

SetSharedLootTable( 'fruitbat',
{
    {'seeds',1},
})

local SLEEP_DIST_FROMHOME = 1
local SLEEP_DIST_FROMTHREAT = 20
local MAX_CHASEAWAY_DIST = 80
local MAX_TARGET_SHARES = 100
local SHARE_TARGET_DIST = 100
--Thanks for these functions scrimbles
local RETARGET_MUST_TAGS = { "_combat", "player" }
local RETARGET_CANT_TAGS = { "bat", "wall", "plantkin", "INLIMBO", "notarget" }

local function retargetfn(inst)
    return TheWorld.state.issummer and FindEntity(
                inst,
                TUNING.BEEFALO_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                RETARGET_MUST_TAGS, --See entityreplica.lua (re: "_combat" tag)
                RETARGET_CANT_TAGS
            )
        or nil
end

local function KeepTarget(inst, target)
    return true 
end

local function OnEat(inst, data)
	if data ~= nil and data:HasTag("pollenmites") then
		inst.SoundEmitter:PlaySound("UCSounds/pollenmite/die")
	end
		inst.bugcount = inst.bugcount + 1
end
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

local function OnIsNight(inst, isnight)
    if isnight then
        if inst._hometask == nil then
            inst._hometask = inst:DoTaskInTime(10 + math.random(), OnSleepGoHome)
        end
    elseif inst._hometask ~= nil then
        inst._hometask:Cancel()
        inst._hometask = nil
    end
end

local function StopWatchingNight(inst)
    inst:StopWatchingWorldState("isnight", OnIsNight)
    if inst._hometask ~= nil then
        inst._hometask:Cancel()
        inst._hometask = nil
    end
end

local function StartWatchingNight(inst)
    inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)
end

local function OnEntitySleep(inst)
    inst:ListenForEvent("enterlimbo", StopWatchingNight)
    inst:ListenForEvent("exitlimbo", StartWatchingNight)
    if not inst:IsInLimbo() then
        StartWatchingNight(inst)
    end
end

local function OnEntityWake(inst)
    inst:RemoveEventCallback("enterlimbo", StopWatchingNight)
    inst:RemoveEventCallback("exitlimbo", StartWatchingNight)
    if not inst:IsInLimbo() then
        StopWatchingNight(inst)
    end
end

-- TEAM ATTACKER STUFF



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
	data.bugcount = inst.bugcount
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
	if data.bugcount then
	inst.bugcount = data.bugcount
	else
	inst.bugcount = 0
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
	inst:AddTag("fruitbat")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("flying")

    inst.AnimState:SetBank("bat")
    inst.AnimState:SetBuild("fruitbat")
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 10

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.INSECT, FOODTYPE.VEGGIE }, { FOODTYPE.INSECT, FOODTYPE.VEGGIE })
    inst.components.eater:SetOnEatFn(OnEat)   
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
     

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(25)
    inst.components.combat:SetAttackPeriod(1.8)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    
    inst:SetStateGraph("SGfruitbat")
 
    local brain = require "brains/fruitbatbrain"
    inst:SetBrain(brain)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('fruitbat')

    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
    
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)
    
    inst:ListenForEvent("wingdown", OnWingDown)
    inst:ListenForEvent("attacked", OnAttacked)
    --inst:ListenForEvent("death", OnKilled)

    --inst:AddComponent("tiletracker")
    --inst.components.tiletracker:SetOnWaterChangeFn(OnWaterChange)    

    inst:AddComponent("teamattacker")
    inst.components.teamattacker.team_type = "fruitbat"
    inst.MakeTeam = MakeTeam
	MakeHauntablePanic(inst)
    MakeMediumBurnableCharacter(inst, "bat_body")
    MakeMediumFreezableCharacter(inst, "bat_body")
	
	inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
    inst.OnPreLoad = OnPreLoad
	inst.bugcount = 0
    inst.OnSave = onsave 
    inst.OnLoad = onload 

    inst.cavebat = false
    
    return inst
end

return Prefab("fruitbat", fn, assets, prefabs)


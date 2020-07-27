local assets =
{
    Asset("ANIM", "anim/snapperturtle.zip"),
    Asset("ANIM", "anim/snapperturtle_water.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}



local brain = require("brains/snapperturtlebrain")

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

SetSharedLootTable('snapperturtle',
{
    {'fishmeat', 1.000},
})



local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
local FREEZABLE_TAGS = { "freezable" }

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or (inst.components.follower and inst.components.follower.leader and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local function ShouldSleep(inst)
    return TheWorld.state.isnight and not inst.components.amphibiouscreature.in_water
        and not (inst.components.combat and inst.components.combat.target)
        and not (inst.components.burnable and inst.components.burnable:IsBurning())
        and (not inst.components.homeseeker or inst:IsNear(inst.components.homeseeker.home, SLEEP_NEAR_HOME_DISTANCE))
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end


local function KeepTarget(inst, target)
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


local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
				and dude:HasTag("snappingturtle")
                and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end

local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and dude:HasTag("snappingturtle")
                and data.target ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end





local function OnSpawnedFromHaunt(inst)
    if inst.components.hauntable ~= nil then
        inst.components.hauntable:Panic()
    end
end

local function FindInvaderFn(guy, inst)
    return (guy:HasTag("character") and not (guy:HasTag("merm")))
end


local function RetargetFn(inst)

    local defend_dist = TUNING.MERM_DEFEND_DIST
	local defenseTarget = false
    local home = inst.components.homeseeker and inst.components.homeseeker.home

    if home and inst:GetDistanceSqToInst(home) < defend_dist * defend_dist then
    defenseTarget = home
    end
	if not defenseTarget == false then
	return FindEntity(defenseTarget, SpringCombatMod(TUNING.MERM_TARGET_DIST), FindInvaderFn)
	end
end





local function fncommon(n, build, morphlist, custombrain, tag, data)
	data = data or {}

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetTwoFaced()

    inst:AddTag("scarytoprey")
    inst:AddTag("scarytooceanprey")
	inst:AddTag("snappingturtle")
    if tag ~= nil then
        inst:AddTag(tag)

    end

    inst.AnimState:SetBank("snapperturtle")
    inst.AnimState:SetBuild("snapperturtle")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(1.5,1.5,1.5)

    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = sounds

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.HOUND_SPEED/3
	inst.components.locomotor.walkspeed = TUNING.HOUND_SPEED/6

    inst:SetStateGraph("SGsnapperturtle")

		inst:AddComponent("embarker")
		inst.components.embarker.embark_speed = inst.components.locomotor.runspeed
        inst.components.embarker.antic = true

	    inst.components.locomotor:SetAllowPlatformHopping(true)

		inst:AddComponent("amphibiouscreature")
		inst.components.amphibiouscreature:SetBanks("snapperturtle", "snapperturtle_water")
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

    

    inst:SetBrain(brain)

    inst:AddComponent("follower")
    inst:AddComponent("entitytracker")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(400)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(40)
    inst.components.combat:SetAttackPeriod(TUNING.HOUND_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetHurtSound(inst.sounds.hurt)
	inst.components.combat:SetRetargetFunction(1, RetargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("snapperturtle")

    inst:AddComponent("inspectable")
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

	inst:AddComponent("knownlocations")
	
    MakeHauntablePanic(inst)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)

    return inst
end

local function fndefault()
    local inst = fncommon(nil, nil, nil, nil, nil, {amphibious = true, nil})

    if not TheWorld.ismastersim then
        return inst
    end

    MakeMediumFreezableCharacter(inst, "shelldown")
    MakeMediumBurnableCharacter(inst, "shelldown")

    return inst
end

return Prefab("snapperturtle", fndefault, assets, prefabs)

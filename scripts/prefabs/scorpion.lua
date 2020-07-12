require "stategraphs/SGscorpion"

local brain = require "brains/spiderbrain"
local assets =
{
	Asset("ANIM", "anim/scorpion_basic.zip"),
	Asset("ANIM", "anim/scorpion_build.zip"),
	Asset("SOUND", "sound/spider.fsb"),
}
    
    
local prefabs =
{
	--"chitin",
    "scorpioncarapace",
    --"venomgland",
    "stinger",
	"sand_puff",
}

SetSharedLootTable( 'scorpion',
{
    {'scorpioncarapace',  1.00},
    --{'chitin',  0.3},
    --{'venomgland',  0.3},
    {'stinger',  0.3},
})


local SHARE_TARGET_DIST = 30

local function NormalRetarget(inst)
    local targetDist = 6
    if inst.components.knownlocations:GetLocation("investigate") then
        targetDist = 8
    end
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy) then
                return guy:HasTag("character") or guy:HasTag("pig")
            end
    end)
end

local function FindWarriorTargets(guy)
	return (guy:HasTag("character") or guy:HasTag("pig"))
               and inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy)
end

local function keeptargetfn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
          and not (inst.components.follower and inst.components.follower.leader == target)
end

local function ShouldSleep(inst)
    return false
--[[    
    return GetClock():IsDay()
           and not (inst.components.combat and inst.components.combat.target)
           and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           and not (inst.components.burnable and inst.components.burnable:IsBurning() )
           and not (inst.components.follower and inst.components.follower.leader)
           ]]
end

local function ShouldWake(inst)
    return true
    --[[
    return GetClock():IsNight()
           or (inst.components.combat and inst.components.combat.target)
           or (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           or (inst.components.burnable and inst.components.burnable:IsBurning() )
           or (inst.components.follower and inst.components.follower.leader)
           or (inst:HasTag("spider_warrior") and FindEntity(inst, TUNING.SPIDER_WARRIOR_WAKE_RADIUS, function(...) return FindWarriorTargets(inst, ...) end ))
           ]]
end

--[[
local function DoReturn(inst)
	if inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home.components.childspawner then
		inst.components.homeseeker.home.components.childspawner:GoHome(inst)
	end
end

local function StartDay(inst)
	if inst:IsAsleep() then
		DoReturn(inst)	
	end
end


local function OnEntitySleep(inst)
	if GetClock():IsDay() then
		DoReturn(inst)
	end
end
]]
--[[
local function SummonFriends(inst, attacker)
	local den = GetClosestInstWithTag("spiderden",inst, TUNING.SPIDER_SUMMON_WARRIORS_RADIUS)
	if den and den.components.combat and den.components.combat.onhitfn then
		den.components.combat.onhitfn(den, attacker)
	end
end
]]

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("scorpion") and not dude.components.health:IsDead() end, 5)
end

local function StartNight(inst)
    inst.components.sleeper:WakeUp()
end

local function OnHitOther(inst, data)
    local other = data.target
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
			if inst:HasTag("sleepattack") then
				local grogginess = inst.sg.statemem.target.components.grogginess
				if grogginess ~= nil then 
					grogginess:AddGrogginess(TUNING.GESTALT.ATTACK_DAMAGE_GROGGINESS, TUNING.GESTALT.ATTACK_DAMAGE_KO_TIME)
						if grogginess.knockoutduration == 0 then
							inst.sg.statemem.target:PushEvent("attacked", {attacker = inst, damage = 0})
						else
						-- TODO: turn on special hud overlay while asleep in enlightened dream land
						end
				else
					inst.sg.statemem.target:PushEvent("attacked", {attacker = inst, damage = 0})
				end	
			end
			
        end
    end
end
local function WhenDusk(inst)
inst:AddTag("notactuallydead")
if inst.components.health ~= nil then
inst.components.health:Kill()
end
end
local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, .5 )
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()

	--shadow:SetSize(1, 0.75)
	inst.Transform:SetFourFaced()

	MakeCharacterPhysics(inst, 10, .5)
	--MakePoisonableCharacter(inst)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.AnimState:SetBank("scorpion")
    inst.AnimState:SetBuild("scorpion_build")
    inst.AnimState:PlayAnimation("idle",true)
    
    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 5

    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('scorpion')
    
    ---------------------            
    MakeMediumBurnableCharacter(inst, "scorpion_body")
    MakeMediumFreezableCharacter(inst, "scorpion_body")    
    inst.components.burnable.flammability = 0.33
    ---------------------       
    
	
	inst:AddTag("monster")
    inst:AddTag("animal")    
    inst:AddTag("insect")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")    
    inst:AddTag("scorpion")
    inst:AddTag("canbetrapped")  

    inst:AddComponent("follower")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "scorpion_body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)    
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetHurtSound("dontstarve/creatures/spider/hit_response")
    inst.components.combat:SetRange(3, 3)
    ------------------
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    ------------------
    
    inst:AddComponent("knownlocations")
    ------------------
    
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    
    ------------------
    
    inst:AddComponent("inspectable")
    
    ------------------
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
    
    inst:SetStateGraph("SGscorpion")
    inst:SetBrain(brain)  
    inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onhitother", OnHitOther)
	inst:WatchWorldState("isdusk", WhenDusk)

    return inst
end

return Prefab( "scorpion", fn, assets, prefabs)
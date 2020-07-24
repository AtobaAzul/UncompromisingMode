local assets =
{
	Asset("ANIM", "anim/lureplague_rat.zip"),
	Asset("ANIM", "anim/carrat_basic.zip"),
}

local prefabs =
{
	
}

local carratsounds =
{
	idle = "turnoftides/creatures/together/carrat/idle",
	hit = "turnoftides/creatures/together/carrat/hit",
	sleep = "turnoftides/creatures/together/carrat/sleep",
	death = "turnoftides/creatures/together/carrat/death",
	emerge = "turnoftides/creatures/together/carrat/emerge",
	submerge = "turnoftides/creatures/together/carrat/submerge",
	eat = "turnoftides/creatures/together/carrat/eat",
	stunned = "turnoftides/creatures/together/carrat/stunned",
}

--Credits to ADM for basecode from uncompromising_rat 
--Credits to Rose and Leonardo Coxington for base art of rat.

local brain = require "brains/lureplague_ratbrain"


local function OnAttackOther(inst, data)
	if data.target ~= nil and data.target:HasTag("player") and not data.target:HasTag("hasplaguemask") then
		data.target.components.health:DeltaPenalty(0.05)
	end
end


local TARGET_MUST_TAGS = { "_combat", "character" }
local TARGET_CANT_TAGS = { "plantkin", "INLIMBO" }   --Won't target Wormwood, for now.
local function FindTarget(inst, radius)
    return FindEntity(
        inst,
        SpringCombatMod(radius),
        function(guy)
            return (not guy:HasTag("monster") or guy:HasTag("player"))
                and inst.components.combat:CanTarget(guy)
        end,
        TARGET_MUST_TAGS,
        TARGET_CANT_TAGS
    )
end


local function NormalRetarget(inst)
    return FindTarget(inst, inst.components.knownlocations:GetLocation("investigate") ~= nil and TUNING.SPIDER_INVESTIGATETARGET_DIST or TUNING.SPIDER_TARGET_DIST)
end

local function keeptargetfn(inst, target)
   return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("lureplague")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
    end, 10)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 1, 0.5)
	
	inst.DynamicShadow:SetSize(1, .75)
	inst.DynamicShadow:Enable(false)
	inst.Transform:SetSixFaced()
	
	inst.AnimState:SetBank("carrat")
	inst.AnimState:SetBuild("lureplague_rat")
	inst.AnimState:PlayAnimation("planted")
	
	inst:AddTag("animal")
	inst:AddTag("hostile")
	inst:AddTag("smallcreature")
	--inst:AddTag("canbetrapped")
	inst:AddTag("cattoy")
	inst:AddTag("catfood")
	inst:AddTag("lureplague")
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	
	inst.sounds = carratsounds
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.DSTU.RAIDRAT_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.DSTU.RAIDRAT_RUNSPEED
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst:SetStateGraph("SGlureplague_rat")
	
	inst:SetBrain(brain)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.HORRIBLE }, { FOODTYPE.HORRIBLE })
	inst.components.eater.strongstomach = true
	inst.components.eater:SetCanEatRaw()
	
	inst:AddComponent("workmultiplier")
	inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, -0.8, inst)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.DSTU.RAIDRAT_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.DSTU.RAIDRAT_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.DSTU.RAIDRAT_ATTACK_RANGE)
	inst.components.combat.hiteffectsymbol = "carrat_body"
	inst.components.combat:SetRetargetFunction(1, NormalRetarget)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.DSTU.RAIDRAT_HEALTH)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("monstersmallmeat", 0.66)
	inst.components.lootdropper:AddRandomLoot("spoiled_food", 0.34)
	inst.components.lootdropper.numrandomloot = 1
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(1)
	

	
	inst:AddComponent("knownlocations")
	

	

	
	inst:AddComponent("inspectable")
	
	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("attacked", OnAttacked)
	
	MakeHauntablePanic(inst)
	

	MakeSmallBurnableCharacter(inst, "carrat_body")
	MakeSmallFreezableCharacter(inst, "carrat_body")
	

	return inst
end





return Prefab("lureplague_rat", fn, assets, prefabs)
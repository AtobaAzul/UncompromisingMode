require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/useshield"

local BrainCommon = require "brains/braincommon"

local RUN_AWAY_DIST = 10
local SEE_FOOD_DIST = 10
local SEE_TARGET_DIST = 6

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 3
local MAX_FOLLOW_DIST = 8

local TRADE_DIST = 20

local MAX_CHASE_DIST = 7 * .8
local MAX_CHASE_TIME = 4
local MAX_WANDER_DIST = 32

local START_RUN_DIST = 8
local STOP_RUN_DIST = 12

local DAMAGE_UNTIL_SHIELD = 50
local SHIELD_TIME = 3
local AVOID_PROJECTILE_ATTACKS = false
local HIDE_WHEN_SCARED = true

local SpiderBrain_TrapDoor = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetTraderFn(inst)
    return inst.components.trader ~= nil
        and FindEntity(inst, TRADE_DIST, function(target) return inst.components.trader:IsTryingToTradeWithMe(target) end, { "player" })
        or nil
end

local function KeepTraderFn(inst, target)
    return inst.components.trader ~= nil
        and inst.components.trader:IsTryingToTradeWithMe(target)
end

local function EatFoodAction(inst)
    local target = FindEntity(inst,
        SEE_FOOD_DIST,
        function(item)
            return inst.components.eater:CanEat(item)
                and item:IsOnValidGround()
                and item:GetTimeAlive() > TUNING.SPIDER_EAT_DELAY
        end,
        nil,
        { "outofreach" }
    )
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
end

local function GoHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and home.components.childspawner ~= nil
		and not home:HasTag("trapdooreviction")
        and (home.components.health == nil or not home.components.health:IsDead())
        and BufferedAction(inst, home, ACTIONS.GOHOME)
        or nil
end

local function InvestigateAction(inst)
    local investigatePos = inst.components.knownlocations ~= nil and inst.components.knownlocations:GetLocation("investigate") or nil
    return investigatePos ~= nil and BufferedAction(inst, nil, ACTIONS.INVESTIGATE, nil, investigatePos, nil, 1) or nil
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function CanAttackNow(inst)
    return (inst.components.combat.target == nil or not inst.components.combat:InCooldown()) and not inst.sg:HasStateTag("busy")
end
local function Attacking(inst)
	return inst.sg:HasStateTag("attack")
end

local function Taunting(inst)
	return inst.sg:HasStateTag("taunting")
end
local RUN_AWAY_PARAMS =
{
    tags = { "_combat", "_health","player"},
    notags = { "spiderwhisperer" },
}


local function CheckForWebber(itsame)
	if itsame.components.combat ~= nil then
		local target = itsame.components.combat.target
		
		if target ~= nil and target:HasTag("spiderwhisperer") then
			return true
		end
	end
	
	return false
end

function SpiderBrain_TrapDoor:OnStart()
    local root =
        PriorityNode(
        {
            BrainCommon.PanicWhenScared(self.inst, .3),
            WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            IfNode(function() return self.inst:HasTag("spider_hider") end, "IsHider",
                UseShield(self.inst, DAMAGE_UNTIL_SHIELD, SHIELD_TIME, AVOID_PROJECTILE_ATTACKS, HIDE_WHEN_SCARED)),
            AttackWall(self.inst),
			WhileNode(function() return CanAttackNow(self.inst) end, "AttackMomentarily", ChaseAndAttack(self.inst, MAX_CHASE_TIME)),
			WhileNode(function() return CheckForWebber(self.inst) and not Attacking(self.inst) and not Taunting(self.inst) end, "AmIBusyAttacking", RunAway(self.inst, "scarytoprey", 4, 8)),
			WhileNode(function() return not Attacking(self.inst) and not Taunting(self.inst) end, "AmIBusyAttacking", RunAway(self.inst, RUN_AWAY_PARAMS, 4, 8)),
			
			ChaseAndAttack(self.inst, MAX_CHASE_TIME),
            DoAction(self.inst, function() return EatFoodAction(self.inst) end ),
            Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            IfNode(function() return self.inst.components.follower.leader ~= nil end, "HasLeader",
                FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),
            DoAction(self.inst, function() return InvestigateAction(self.inst) end ),
            WhileNode(function() return TheWorld.state.iscaveday end, "IsDay",
                    DoAction(self.inst, function() return GoHomeAction(self.inst) end ) ),
            FaceEntity(self.inst, GetTraderFn, KeepTraderFn),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
        }, 1)
    self.bt = BT(self.inst, root)
end

function SpiderBrain_TrapDoor:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))

end

return SpiderBrain_TrapDoor

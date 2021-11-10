require "behaviours/wander"
require "behaviours/follow"
require "behaviours/chaseandattack"
--require "behaviours/choptree"

local BrainCommon = require("brains/braincommon")


local function IsDefensive(self)
    return self.inst.components.health.currenthealth < 2000
end

local function ShouldSummonChannelers(self)
    return IsDefensive(self)
        and self.inst.components.commander:GetNumSoldiers() <= 0
        and not self.inst.components.timer:TimerExists("channelers_cd")
end
local function ShouldUseAbility(self)
    self.abilityname = self.inst.components.combat:HasTarget() and ((ShouldSummonChannelers(self) and "shadowchannelers")) or nil
    return self.abilityname ~= nil
end
local function ShouldAttack(self)
    if self.inst.components.shadowsubmissive:ShouldSubmitToTarget(self.inst.components.combat.target) then
        self._harasstarget = self.inst.components.combat.target
        return false
    end
    self._harasstarget = nil
    return true
end


local function ShouldChaseAndHarass(self)
    return self.inst.components.locomotor.walkspeed < 5
        or (self._harasstarget ~= nil and self._harasstarget:IsValid() and not self.inst:IsNear(self._harasstarget, HARASS_MED))
end

local function GetHarassWanderDir(self)
    return (self._harasstarget:GetAngleToPoint(self.inst.Transform:GetWorldPosition()) - 60 + math.random() * 120) * DEGREES
end

local TrepidationBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)
local function GetHome(inst)
    return inst.components.homeseeker and inst.components.homeseeker.home
end


local function WithinDomain(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local nearestspawner = FindEntity(inst, 50, nil,{"trepidationspawner"})
	local home = GetHome(inst)
	if nearestspawner ~= nil and home ~= nil then
		local dist1 = inst:GetDistanceSqToInst(nearestspawner)
		local dist2 = inst:GetDistanceSqToInst(home)
		if dist1-4 > dist2 then
			return false
		else
			return true
		end
	else
	return true
	end
end

local function GetTargetfn(inst)
if inst.harassplayer ~= nil then
	return inst.harassplayer
end
end
local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 10
local MAX_FOLLOW_DIST = 7

function TrepidationBrain:OnStart()
    local root = PriorityNode(
    {	
		WhileNode(function() return ShouldUseAbility(self) end, "Ability",
				ActionNode(function()
                    self.inst:PushEvent(self.abilityname, self.abilitydata)
                    self.abilityname = nil
                    self.abilitydata = nil
                end)),
        WhileNode(function() return ShouldAttack(self) end, "Attack", ChaseAndAttack(self.inst, 40)),
		

		Follow(self.inst, GetTargetfn(self.inst), MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),--),

        WhileNode(function() return self.inst.harassplayer == nil end, "Home",
			Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, 20)),
    }, .25)

    self.bt = BT(self.inst, root)
end
function TrepidationBrain:OnInitializationComplete()
    local pos = self.inst:GetPosition()
    pos.y = 0
    self.inst.components.knownlocations:RememberLocation("spawnpoint", pos, true)
end

return TrepidationBrain

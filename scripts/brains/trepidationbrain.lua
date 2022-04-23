require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/follow"

local MIN_FOLLOW = 5
local MED_FOLLOW = 15
local MAX_FOLLOW = 30

local HARASS_MIN = 0
local HARASS_MED = 4
local HARASS_MAX = 5


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
local TARGET_FOLLOW_DIST = 7
local MAX_FOLLOW_DIST = 10
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

function TrepidationBrain:OnStart()
    local root = PriorityNode(
    {	
		WhileNode(function() return ShouldUseAbility(self) end, "Ability",
				ActionNode(function()
                    self.inst:PushEvent(self.abilityname, self.abilitydata)
                    self.abilityname = nil
                    self.abilitydata = nil
                end)),
        WhileNode(function() return ShouldAttack(self) end, "Attack", ChaseAndAttack(self.inst)),
		
		--WhileNode(function() return WithinDomain(self.inst) end, "Follow",
		Follow(self.inst, function() return self.inst.harassplayer end, 1, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),--),
		
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

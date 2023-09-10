require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/follow"
require "behaviours/doaction"
require "behaviours/minperiod"
require "behaviours/panic"
require "behaviours/runaway"

local HoodedWidowBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

-----------------------------------------------------------------
local FORCE_MELEE_DIST = 4
local MAX_WANDER_DIST = 7


local function GoHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and home.components.childspawner ~= nil
        and (home.components.health == nil or not home.components.health:IsDead())
        and BufferedAction(inst, home, ACTIONS.GOHOME)
        or nil
end

local function WebSlingerAction(inst)
	if not inst.sg:HasStateTag("busy") then
		return inst.sg:GoToState("launchprojectile")
	end
end

local function JumpHomeAction(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and home.components.childspawner ~= nil
        and (home.components.health == nil or not home.components.health:IsDead())
        and inst.sg:GoToState("jumphome") --Instead we should be just jumping back into the canopy
        or nil
end

local function CanMeleeNow(inst)
    local target = inst.components.combat.target
    if target == nil or inst.components.combat:InCooldown() then
        return false
    end
    if target.components.pinnable ~= nil then
        return not target.components.pinnable:IsValidPinTarget()
    end
    return inst:IsNear(target, FORCE_MELEE_DIST)
end

local function TargetLeavingArena(inst)
	if inst.components.combat~= nil and inst.components.combat.target ~= nil then
		local target = inst.components.combat.target
		local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
		
		if (target ~= nil and home ~= nil) then
			local dx, dy, dz = target.Transform:GetWorldPosition()
			local spx, spy, spz = home.Transform:GetWorldPosition()
			
			return target ~= nil and home ~= nil and distsq(spx, spz, dx, dz) >= (TUNING.DRAGONFLY_RESET_DIST*10)
		else
			return false
		end
	else
		return false
	end
end


local function ShouldLeave(inst)
	if inst.investigated and inst.components.combat.target == nil then
		return true
	end
end

local function ReadyToLeapOrStick(inst)
	return inst.components.timer and (not inst.components.timer:TimerExists("mortar") or not inst.components.timer:TimerExists("pounce"))
end

local function DistancedFromTarget(inst)
	if inst.components.combat and inst.components.combat.target then
		return inst:GetDistanceSqToInst(inst.components.combat.target) > 5^2
	end
end

local function DoSpecial(inst)
	if not inst.sg:HasStateTag("busy") then
		if not inst.components.timer:TimerExists("pounce") then --If both are done from counter, first pounce THEN lob
			return inst.sg:GoToState("preleapattack")
		elseif not inst.components.timer:TimerExists("mortar") then
			return inst.sg:GoToState("lobprojectile")
		end
	end
end

function HoodedWidowBrain:OnStart()
    local root = PriorityNode(
    {	
		
		WhileNode(function() return self.inst.bullier end,"BeingBullied", DoAction(self.inst, JumpHomeAction)), -- Under any circumstances where an epic is nearby, leave the fight.
		
		WhileNode(function() return TargetLeavingArena(self.inst) end, "PullThemBack", DoAction(self.inst, WebSlingerAction)), -- Target is leaving arena... pull them back.
		
		
		WhileNode(function() return ReadyToLeapOrStick(self.inst) and DistancedFromTarget(self.inst) end, "DoSpecial", DoAction(self.inst, DoSpecial)), --Ready to pounce or Web, get some distance first
		WhileNode(function() return ReadyToLeapOrStick(self.inst) end, "GetDistanceToSpecial", RunAway(self.inst, function() return self.inst.components.combat.target end, 5, 6)), --Ready to pounce or Web, get some distance first
		WhileNode(function() return not (ReadyToLeapOrStick(self.inst) and (self.inst.components.combat.target and self.inst.components.combat:InCooldown())) end, "ChaseAndAttack", ChaseAndAttack(self.inst,30)), --Chase and attack for 30 seconds, if the player stops after that then quit and go home
		
		WhileNode(function() return ShouldLeave(self.inst) end,"NoTarget", DoAction(self.inst, GoHomeAction)), --No target and done investigating? we should probably go home then.
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, 2)
    
    self.bt = BT(self.inst, root)
    
end

return HoodedWidowBrain
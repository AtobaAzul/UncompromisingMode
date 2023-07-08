require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/chaseandattack"
require "behaviours/doaction"
require "behaviours/panic"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 7

local SEE_PLAYER_DIST_NIGHTMARE = 2

local SEE_PLAYER_STOP_DIST = 12

local SEE_BAIT_DIST = 20
local MAX_WANDER_DIST = 30




local Uncompromising_PawnBrain = Class(Brain, function(self, inst)
	self.trytohide = false

    Brain._ctor(self, inst)
end)

local function GetFaceTargetFn(inst)
    local shouldface = FindClosestPlayerToInst(inst, SEE_PLAYER_STOP_DIST, true)

    return shouldface
end

local function KeepFaceTargetFn(inst, target)
    local keepface = inst:IsNear(target, SEE_PLAYER_STOP_DIST)

    return keepface
end

local function IsDangerClose(inst)
	if inst.keeptryingtohide ~= nil and inst.keeptryingtohide then
		return true
	end

	if inst:HasTag("landmine") then
		return FindEntity(
		inst, 
		SEE_PLAYER_DIST_NIGHTMARE, 
		function(guy)
			return guy ~= nil and (guy.sg == nil or guy.sg ~= nil and not guy.sg:HasStateTag("hiding"))
		end, 
		{"player"}, {"playerghost"})
	else
		return FindEntity(
		inst, 
		SEE_PLAYER_DIST, 
		function(guy)
			return guy ~= nil and (guy.sg == nil or guy.sg ~= nil and not guy.sg:HasStateTag("hiding"))
		end, 
		{"player"}, {"playerghost"})
	end
end

local function TryHide(inst)
	inst.keeptryingtohide = true

    if not inst.sg:HasStateTag("busy") then
        return BufferedAction(inst, inst, ACTIONS.UNCOMPROMISING_PAWN_HIDE)
    end
end

function Uncompromising_PawnBrain:OnStart()

    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        --RunAway(self.inst, "scarytopr1ey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
        
		IfNode(function() return IsDangerClose(self.inst) and not self.inst.components.freezable:IsFrozen() end, "DangerClose", DoAction(self.inst, TryHide, "Hide")),

        ChaseAndAttack(self.inst, 10),
		
		--FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
    }, .25)
    self.bt = BT(self.inst, root)
end

return Uncompromising_PawnBrain

require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/minperiod"

local BrainCommon = require("brains/braincommon")

local SEE_PLAYER_DIST = 5
local WANDER_DIST_DAY = 20
local WANDER_DIST_NIGHT = 5
local MAX_CHASE_TIME = 6

local START_CHASE_DIST = 14
local START_FACE_DIST = 8
local KEEP_FACE_DIST = 14

local MIN_FOLLOW_DIST = 5
local TARGET_FOLLOW_DIST = 7
local MAX_FOLLOW_DIST = 10
local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 7

local function GetFaceTargetFn(inst)
	local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
	local herd = inst.components.knownlocations:GetLocation("herd")
	
	if target ~= nil and not target:HasTag("notarget") then
		inst.getting_angry = true
	else
		inst.getting_angry = false
	end
		
	return herd ~= nil and inst:GetDistanceSqToPoint(herd:Get()) < 300 and target ~= nil and not target:HasTag("notarget") and target or nil
end

local function GetChaseTargetFn(inst)
	local target = FindClosestPlayerToInst(inst, START_CHASE_DIST, true)
	local herd = inst.components.knownlocations:GetLocation("herd")
	
	if target ~= nil and not target:HasTag("notarget") then
		inst.getting_angry = true
	else
		inst.getting_angry = false
	end
		
	return herd ~= nil and inst:GetDistanceSqToPoint(herd:Get()) < 300 and target ~= nil and not target:HasTag("notarget") and target or nil
end

local function KeepFaceTargetFn(inst, target)
    return not target:HasTag("notarget")
        and inst:IsNear(target, KEEP_FACE_DIST)
end

local function ShouldRunAwayEpic(guy)
    return guy:HasTag("epic") and not guy:HasTag("notarget")
end

local function ShouldRunAwayCombat(guy)
    return guy:HasTag("combat") and not guy:HasTag("notarget")
end

local function GetWanderDistFn(inst)
    return TheWorld.state.isday and WANDER_DIST_DAY or WANDER_DIST_NIGHT
end

local Alpha_LightningGoatBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function Alpha_LightningGoatBrain:OnStart()
    local root =
    PriorityNode(
    {
		BrainCommon.PanicTrigger(self.inst),
		
		--Enhanced Combat brain, run away from epics, back off to perform electrical attack or charge
		RunAway(self.inst, ShouldRunAwayEpic, 4*RUN_AWAY_DIST, 4*STOP_RUN_AWAY_DIST),
        IfNode(function() return self.inst.components.combat.target ~= nil end, "hastarget", 
			AttackWall(self.inst)
		),		
        ChaseAndAttack(self.inst, MAX_CHASE_TIME),
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Follow(self.inst, function() return GetChaseTargetFn(self.inst) end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        --FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        BrainCommon.AnchorToSaltlick(self.inst),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, GetWanderDistFn)
    },.25)

    self.bt = BT(self.inst, root)
end

function Alpha_LightningGoatBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition())
end

return Alpha_LightningGoatBrain

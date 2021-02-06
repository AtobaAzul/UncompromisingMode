require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/chaseandattack"
require "behaviours/doaction"
require "behaviours/panic"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 7

local SEE_PLAYER_STOP_DIST = 12

local SEE_BAIT_DIST = 20
local MAX_WANDER_DIST = 40


local Uncompromising_PawnBrain = Class(Brain, function(self, inst)
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
	if inst:HasTag("landmine") then
		return FindEntity(inst, 2, nil, {"player"}) ~= nil
	else
		return FindEntity(inst, 7, nil, {"player"}) ~= nil
	end
end

local function TryHide(inst)
    if not inst.sg:HasStateTag("busy") then
        return BufferedAction(inst, inst, ACTIONS.UNCOMPROMISING_PAWN_HIDE)
    end
end

function Uncompromising_PawnBrain:OnStart()

    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        --RunAway(self.inst, "scarytopr1ey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
        ParallelNode
        {
            --RunAway(self.inst, "player", SEE_PLAYER_DIST, STOP_RUN_DIST),
            SequenceNode
            {
                IfNode(function() return IsDangerClose(self.inst) end, "DangerClose", DoAction(self.inst, TryHide, "Hide")),
            },
        },
		
        ChaseAndAttack(self.inst, 10),
		
		--FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
    }, .25)
    self.bt = BT(self.inst, root)
end

return Uncompromising_PawnBrain

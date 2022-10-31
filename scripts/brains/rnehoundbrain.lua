require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/minperiod"
require "behaviours/leash"
require "behaviours/faceentity"
require "behaviours/doaction"
require "behaviours/standstill"
require "behaviours/runaway"


local RneHoundBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
    --self.reanimatetime = nil
end)

local SEE_DIST = 30

local MIN_FOLLOW_LEADER = 2
local MAX_FOLLOW_LEADER = 6
local TARGET_FOLLOW_LEADER = (MAX_FOLLOW_LEADER + MIN_FOLLOW_LEADER) / 2

local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 40

local HOUSE_MAX_DIST = 40
local HOUSE_RETURN_DIST = 50

local SIT_BOY_DIST = 10
local MAX_JUMP_ATTACK_RANGE = 9

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

local function GetHome(inst)
    return inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
end

local function GetHomePos(inst)
    local home = GetHome(inst)
    return home ~= nil and home:GetPosition() or nil
end

local function GetNoLeaderLeashPos(inst)
    return GetLeader(inst) == nil and GetHomePos(inst) or nil
end

local function GetWanderPoint(inst)
    local target = GetLeader(inst) or inst:GetNearestPlayer(true)
    return target ~= nil and target:GetPosition() or nil
end

local function ShouldStandStill(inst)
    return inst:HasTag("pet_hound") and not TheWorld.state.isday and not GetLeader(inst) and not inst.components.combat:HasTarget() and inst:IsNear(GetHome(inst), SIT_BOY_DIST)
end

local function TryReanimate(self)
    local leader = GetLeader(self.inst)
    if leader ~= nil then
        if leader.sg ~= nil and leader.sg:HasStateTag("statue") then
            self.reanimatetime = nil
        elseif self.reanimatetime == nil then
            self.reanimatetime = GetTime() + math.random() * .5
        elseif self.reanimatetime then
            self.inst:PushEvent("reanimate", { target = leader.components.combat.target })
        elseif self.reanimatetime < GetTime() then
            self.reanimatetime = true
        end
    else
        local player, dsq = self.inst:GetNearestPlayer(true)
        if player == nil or dsq >= 25 then
            self.reanimatetime = nil
        elseif self.reanimatetime == nil then
            self.reanimatetime = GetTime() + 3
        elseif self.reanimatetime then
            self.inst:PushEvent("reanimate", { target = player })
        elseif self.reanimatetime < GetTime() then
            self.reanimatetime = true
        end
    end
end

local function ShouldBecomeStatue(inst)
    local leader = GetLeader(inst)
    return leader ~= nil and leader.sg ~= nil and leader.sg:HasStateTag("statue") and inst:IsNear(leader, 10)
end

local function GetClayLeaderLeashPos(inst)
    local leader = GetLeader(inst)
    if leader == nil or inst.leader_offset == nil then
        return
    end
    local x, y, z = leader.Transform:GetWorldPosition()
    return Vector3(x + inst.leader_offset.x, 0, z + inst.leader_offset.z)
end

local function FaceFormation(inst)
    if inst.sg:HasStateTag("canrotate") then
        local leader = GetLeader(inst)
        if leader ~= nil then
            inst.Transform:SetRotation(leader.Transform:GetRotation())
        end
    end
end
local function Attacking(inst)
	return inst.sg:HasStateTag("attack")
end

local function Taunting(inst)
	return inst.sg:HasStateTag("taunting")
end
function RneHoundBrain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "NotJumpingBehaviour",
                PriorityNode({
					WhileNode(function() return Attacking(self.inst) and not Taunting(self.inst) end, "AmIBusyAttacking", RunAway(self.inst, "scarytoprey", 4, 8)),
					ChaseAndAttack(self.inst, 100),
                    Leash(self.inst, GetNoLeaderLeashPos, HOUSE_MAX_DIST, HOUSE_RETURN_DIST),
                    StandStill(self.inst, ShouldStandStill),

                    WhileNode(function() return GetHome(self.inst) end, "HasHome", Wander(self.inst, GetHomePos, 8)),
                    Wander(self.inst, GetWanderPoint, 20),
                }, .25)
            ),
        }, .25 )

    self.bt = BT(self.inst, root)
end

return RneHoundBrain

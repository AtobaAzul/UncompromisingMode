require "behaviours/standstill"
require "behaviours/wander"

local MAX_WANDER_DIST = 40
local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 0
local TARGET_FOLLOW_DIST = 0

local MindWeaverBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function ShouldWalkToLeader(self)
    return not self.inst.sg:HasStateTag("grabbing")
end

function MindWeaverBrain:OnStart()
    local root = PriorityNode(
	{
	WhileNode(function() return ShouldWalkToLeader(self) end, "Walk Follow",
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, false)),
	WhileNode(function() return not self.inst.sg:HasStateTag("grabbing") end, "Wander",
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("spawnpoint") end, MAX_WANDER_DIST)),
    }, .05--[[.25]])

    self.bt = BT(self.inst, root)
end

function MindWeaverBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition())
end

return MindWeaverBrain
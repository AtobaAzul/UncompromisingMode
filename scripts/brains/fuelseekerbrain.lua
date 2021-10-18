require "behaviours/wander"
require "behaviours/findlight"

local BrainCommon = require "brains/braincommon"

local SEE_LIGHT_DIST = 80
local START_RUN_DIST = 5
local STOP_RUN_DIST = 8

local function SafeLightDist(inst, target)
    return (target:HasTag("player") or target:HasTag("playerlight")
            or (target.inventoryitem and target.inventoryitem:GetGrandOwner() and target.inventoryitem:GetGrandOwner():HasTag("player")))
        and 3
        or target.Light:GetCalculatedRadius() / 5
end

local FuelSeekerBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function FuelSeekerBrain:OnStart()

    local root = PriorityNode(
		{
			WhileNode(function() return not self.inst:IsInLight() end, "Flee",
				RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST)),
			WhileNode(function() return not self.inst:IsInLight() end, "Flee",
				FindLight(self.inst, SEE_LIGHT_DIST, SafeLightDist)),
        }, 0.25)

    self.bt = BT(self.inst, root)
end

return FuelSeekerBrain
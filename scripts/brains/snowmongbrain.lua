require "behaviours/wander"
require "behaviours/panic"
require "behaviours/chaseandattack"

local MAX_WANDER_DIST = 120
local MAX_CHASE_TIME = 120
local SEE_FOOD_DIST = 50
local SEE_VICTIM_DIST = 25

local SnowMongBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function SnowMongBrain:OnStart()
	local root = PriorityNode(
	{
		WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
	}, 0.25)
	self.bt = BT(self.inst, root)
end

return SnowMongBrain
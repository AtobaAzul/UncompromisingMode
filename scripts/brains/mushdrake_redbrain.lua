require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/panic"
require "behaviours/minperiod"

local TIME_BETWEEN_EATING = 3.5

local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 500
local SEE_FOOD_DIST = 15
local SEE_STRUCTURE_DIST = 30

local BASE_TAGS = {"structure"}
local STEAL_TAGS = {"structure"}
local NO_TAGS = {"FX", "NOCLICK", "DECOR","INLIMBO"}

local Mushdrake_redBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function Mushdrake_redBrain:OnStart()

	local root =
	PriorityNode(
	{
		WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		Wander(self.inst,nil,10),

	},.25)

	self.bt = BT(self.inst, root)

end

function Mushdrake_redBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("spawnpoint", Point(self.inst.Transform:GetWorldPosition()))
end

return Mushdrake_redBrain

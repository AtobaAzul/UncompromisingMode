require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/follow"

local MAX_CHASE_TIME = 15
local MAX_CHASE_DIST = 30
local MAX_WANDER_DIST = 10


local NervousTickBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function NervousTickBrain:OnStart()

    local root = PriorityNode(
    {
		Leash(self.inst, self.inst.components.knownlocations:GetLocation("home"), 20, 3),
        ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, .25)

    self.bt = BT(self.inst, root)
end

return NervousTickBrain

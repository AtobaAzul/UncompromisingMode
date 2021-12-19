require "behaviours/attackwall"
require "behaviours/chaseandattack"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"

local Oculet_PetsBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9

local function GetLeader(inst)
    return inst.components.follower.leader
end

function Oculet_PetsBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return not self.inst.sg:HasStateTag("charge") end, "Not Attacking",
            PriorityNode({
                ChaseAndAttack(self.inst),
				Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
				StandStill(self.inst),
            }, 0.5)
        ),
    }, 0.5)

    self.bt = BT(self.inst, root)
end

return Oculet_PetsBrain

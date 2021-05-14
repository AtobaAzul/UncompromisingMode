require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/attackwall"

local ArmorLavaeBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

--Spawned with a purpose.
--If no combat target, go to nearest lava pool and despawn

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9

local function GetLeader(inst)
    return inst.components.follower.leader
end

local function ispanichaunted(inst)
    return inst.components.hauntable and inst.components.hauntable.panic
end

function ArmorLavaeBrain:OnStart()
    local root =
        PriorityNode(
        {
            
			WhileNode(function() ispanichaunted(self.inst) end, "PanicHaunted", Panic(self.inst)), --Ghosts can still help in the fight by helping with lavae :)
			ChaseAndAttack(self.inst),
			Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
            StandStill(self.inst),
        }, 1)
    
    self.bt = BT(self.inst, root)
end

return ArmorLavaeBrain
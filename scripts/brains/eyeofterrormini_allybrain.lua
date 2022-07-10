require "behaviours/attackwall"
require "behaviours/chaseandattack"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"

local EyeOfTerrorMini_AllyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local FOOD_DISTANCE = 20
local function EatFoodAction(inst)
    if inst.sg:HasStateTag("busy") then
        return nil
    end

    local food = FindEntity(inst, FOOD_DISTANCE, function(item)
        return inst.components.eater:CanEat(item)
            and item:IsOnPassablePoint(true)
    end)

    return (food ~= nil and BufferedAction(inst, food, ACTIONS.EAT))
        or nil
end

local MIN_FOLLOW_LEADER = 2
local MAX_FOLLOW_LEADER = 6
local TARGET_FOLLOW_LEADER = (MAX_FOLLOW_LEADER + MIN_FOLLOW_LEADER) / 2

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

function EyeOfTerrorMini_AllyBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return not self.inst.sg:HasStateTag("charge") end, "Not Attacking",
            PriorityNode({
                WhileNode(function()
                        return self.inst.components.hauntable
                            and self.inst.components.hauntable.panic
                    end, "PanicHaunted", Panic(self.inst)
                ),
                WhileNode(function()
                        return self.inst.components.health.takingfiredamage
                    end, "OnFire", Panic(self.inst)
                ),
                ChaseAndAttack(self.inst),
                DoAction(self.inst, EatFoodAction, "Find And Eat Food"),
				Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
            }, 0.5)
        ),
    }, 0.5)

    self.bt = BT(self.inst, root)
end

return EyeOfTerrorMini_AllyBrain

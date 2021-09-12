require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/minperiod"
require "behaviours/leash"
require "behaviours/faceentity"
require "behaviours/doaction"
require "behaviours/standstill"

local StumplingBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
    --self.reanimatetime = nil
end)

local SEE_DIST = 30

local MIN_FOLLOW_FOOD = 2
local MAX_FOLLOW_FOOD = 6
local TARGET_FOLLOW_FOOD = (MAX_FOLLOW_FOOD + MIN_FOLLOW_FOOD) / 2

local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 30

local WANDER_DIST = 15

local SEE_FOOD_DIST = 15 --10

local MAX_FISER_DIST = TUNING.OCEAN_FISHING.MAX_HOOK_DIST

local STRUGGLE_WANDER_TIMES = {minwalktime=0.3, randwalktime=0.2, minwaittime=0.0, randwaittime=0.0}
local STRUGGLE_WANDER_DATA = {wander_dist = 6, should_run = true}

local TIREDOUT_WANDER_TIMES = {minwalktime=0.5, randwalktime=0.5, minwaittime=0.0, randwaittime=0.0}
local TIREDOUT_WANDER_DATA = {wander_dist = 6, should_run = false}

local FISHING_COMBAT_DIST = 8

local function EatFoodAction(inst)
    local target = FindEntity(inst, SEE_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnPassablePoint(true) end)
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
end

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



local FIND_WALL_TAGS = {"wall"}
local function findwall(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local walls = TheSim:FindEntities(x,y,z, 1, FIND_WALL_TAGS)
    return #walls > 0
end

local function getdirectionFn(inst)
    local r = math.random() * 2 - 1
    return (inst.Transform:GetRotation() + r*r*r * 60) * DEGREES
end
function StumplingBrain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "NotJumpingBehaviour",
                PriorityNode({
                    WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
                    WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),

                    IfNode(function() return findwall(self.inst) end, "nearwall", AttackWall(self.inst)),


                    WhileNode( function() return self.inst.components.combat.target end, "combat actions",
                        PriorityNode({
                            ChaseAndAttack(self.inst),
                        })
                    ),
                 

                    WhileNode(function() return GetHome(self.inst) end, "HasHome", Wander(self.inst, GetHomePos, 8)),

                    Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd_offset") or self.inst.components.knownlocations:GetLocation("herd") end, WANDER_DIST, {minwalktime=1,randwalktime=0.5,minwaittime=2,randwaittime=2}, getdirectionFn),
                }, .25)
            ),
        }, .25 )

    self.bt = BT(self.inst, root)
end

return StumplingBrain

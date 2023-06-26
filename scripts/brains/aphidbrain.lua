require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/useshield"

--local BrainCommon = require "brains/braincommon"

local RETURN_HOME_DELAY_MIN = 15
local RETURN_HOME_DELAY_MAX = 25

local MAX_WANDER_DIST = 50
local MAX_CHASE_DIST = 20
local MAX_CHASE_TIME = 8

local RUN_AWAY_DIST = 3
local STOP_RUN_AWAY_DIST = 5


local DAMAGE_UNTIL_SHIELD = 100
local SHIELD_TIME = 3
local AVOID_PROJECTILE_ATTACKS = false
local HIDE_WHEN_SCARED = true

local SEE_FOOD_DIST = 10

local function GetHome(inst)
    return inst.components.homeseeker and inst.components.homeseeker.home
end

local function GetHomePos(inst)
    local home = GetHome(inst)
    return home and home:GetPosition()
end

local function GetWanderPoint(inst)
    local target = GetHome(inst)

    if target then
        return target:GetPosition()
    end
end

local function GoHomeAction(inst)
    if inst.components.homeseeker and
        inst.components.homeseeker.home and
        inst.components.homeseeker.home:IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end


local function EatFoodAction(inst)
    local EAT_CANT_TAGS = { "outofreach" }
    local EAT_ONEOF_TAGS = {
        "edible_GENERIC",
        "edible_VEGGIE",
        --"edible_INSECT",
        "edible_SEEDS",
        "edible_ROUGHAGE",
        "edible_WOOD",
        "edible_MEAT",
        "pickable",
        "harvestable",
    }

    if inst.sg:HasStateTag("busy") or inst:GetTimeAlive() < 5 or
        (inst.components.eater:TimeSinceLastEating() ~= nil and inst.components.eater:TimeSinceLastEating() < 5) then
        return
    elseif inst.components.inventory ~= nil then
        if inst.components.eater ~= nil then
            local target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) or
                    (inst.components.eater:CanEat(item) and item:IsOnValidGround()) end)
            if target ~= nil then
                return BufferedAction(inst, target, ACTIONS.EAT)
            end
        end
        if inst.components.inventory:IsFull() then
            return
        end
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z,
        TUNING.WORM_FOOD_DIST,
        nil,
        EAT_CANT_TAGS,
        EAT_ONEOF_TAGS)

    --Look for food on the ground, pick it up
    for i, item in ipairs(ents) do
        if item:GetTimeAlive() > 8 and
            item.components.inventoryitem ~= nil and
            item.components.inventoryitem.canbepickedup and
            not item.components.inventoryitem:IsHeld() and
            item:IsOnValidGround() and
            inst.components.eater:CanEat(item) and TheWorld.Map:IsPassableAtPoint(x, y, z) then
            return BufferedAction(inst, item, ACTIONS.PICKUP)
        end
    end

    for i, item in ipairs(ents) do
        if item.prefab ~= inst.prefab and
            item.components.pickable ~= nil and
            item.components.pickable.caninteractwith and
            item.components.pickable:CanBePicked() and TheWorld.Map:IsPassableAtPoint(x, y, z) then
            return BufferedAction(inst, item, ACTIONS.PICK)
        end
    end

    for i, item in ipairs(ents) do
        if item.components.crop ~= nil and
            item.components.crop:IsReadyForHarvest() and TheWorld.Map:IsPassableAtPoint(x, y, z) then
            return BufferedAction(inst, item, ACTIONS.HARVEST)
        end
    end


    --[[
    local target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnValidGround() end) --May have to give checks so it doesn't try to get food on water.
    if target then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end]]
end
local function GetLeader(inst)
    return inst.components.follower.leader
end


local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 3
local MAX_FOLLOW_DIST = 7
local AphidBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)




function AphidBrain:OnStart()
    local root = PriorityNode(
        {
            WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "AttackAndWander",
                PriorityNode(
                    {
                        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),						
                        WhileNode(function() return self.inst.components.combat.target == nil or
                                not self.inst.components.combat:InCooldown() end, "AttackMomentarily", ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
                        WhileNode(function() return self.inst.components.combat.target and
                                self.inst.components.combat:InCooldown() end, "Dodge", RunAway(self.inst, function() return
                            self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),
                        DoAction(self.inst, function() return EatFoodAction(self.inst) end),

                        WhileNode(function() return TheWorld.state.isnight end, "IsNight",
                            DoAction(self.inst, GoHomeAction, "go home", true)),

                        WhileNode(function() return GetHome(self.inst) end, "HasHome", Wander(self.inst, GetHomePos, 8)),
                        --    Wander(self.inst, GetWanderPoint, 20),
                        Wander(self.inst, GetWanderPoint, MAX_WANDER_DIST, { minwalktime = .5, randwalktime = math.random() < 0.5 and .5 or 1, minwaittime = math.random() < 0.5 and 0 or 1, randwaittime = .2, }),
                    }, .25)
            )
        }, .25)

    self.bt = BT(self.inst, root)
end

function AphidBrain:OnInitializationComplete()
    if not self.inst.components.knownlocations:GetLocation("home") then
        self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()), true)
    end
end

return AphidBrain

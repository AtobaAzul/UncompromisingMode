require "behaviours/standstill"
require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/leash"

local ViperlingBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)
local MIN_FOLLOW_LEADER = 2
local MAX_FOLLOW_LEADER = 6
local TARGET_FOLLOW_LEADER = (MAX_FOLLOW_LEADER + MIN_FOLLOW_LEADER) / 2
local function LayInWait(inst)
    if inst.sg:HasStateTag("idle") then
        --Only transition into this state from the idle state.
        inst:PushEvent("dolure")
    end
end

local function GoHomeAction(inst)
    if inst.components.combat:HasTarget() or GetTime() - inst.lastluretime < TUNING.WORM_LURE_COOLDOWN then
        return
    end

    local homePos = inst.components.knownlocations:GetLocation("home")
    if homePos ~= nil then
        local ba = BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, 5)
        ba:AddSuccessAction(function() inst:PushEvent("dolure") end)
        return ba
    end
end

local EAT_CANT_TAGS = { "outofreach" }
local EAT_ONEOF_TAGS = {
            "edible_GENERIC",
            "edible_VEGGIE",
            "edible_INSECT",
            "edible_SEEDS",
            "edible_MEAT",
            "pickable",
            "harvestable",
        }
local function EatFoodAction(inst)
    if inst.sg:HasStateTag("busy") or
        (inst.components.eater:TimeSinceLastEating() ~= nil and inst.components.eater:TimeSinceLastEating() < TUNING.WORM_EATING_COOLDOWN) then
        return
    elseif inst.components.inventory ~= nil then
        if inst.components.eater ~= nil then
            local target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
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
            inst.components.eater:CanEat(item) then
            return BufferedAction(inst, item, ACTIONS.PICKUP)
        end
    end

    for i, item in ipairs(ents) do
        if item.prefab ~= inst.prefab and
            item.components.pickable ~= nil and
            item.components.pickable.caninteractwith and
            item.components.pickable:CanBePicked() then
            return BufferedAction(inst, item, ACTIONS.PICK)
        end
    end

    for i, item in ipairs(ents) do
        if item.components.crop ~= nil and
            item.components.crop:IsReadyForHarvest() then
            return BufferedAction(inst, item, ACTIONS.HARVEST)
        end
    end
end

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

function ViperlingBrain:OnStart()
    local root = PriorityNode(
    {

		Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
        ChaseAndAttack(self.inst, TUNING.WORM_CHASE_TIME, TUNING.WORM_CHASE_DIST),
        Wander(self.inst, function() return self.inst:GetPosition() end, TUNING.WORM_WANDER_DIST),
        StandStill(self.inst),

    }, .25)
    self.bt = BT(self.inst, root)
end

return ViperlingBrain

local env = env
GLOBAL.setfenv(1, GLOBAL)

require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/panic"
require "behaviours/minperiod"
require "behaviours/chaseandram"
-----------------------------------------------------------------
local SEE_FOOD_DIST = 15 * 10
local SEE_STRUCTURE_DIST = 30 * 10

local BASE_TAGS = { "structure" }
local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt" }

--local OFFSCREEN_RANGE = 64

local PICKABLE_FOODS =
{
    berries = true,
    cave_banana = true,
    carrot = true,
    red_cap = true,
    blue_cap = true,
    green_cap = true,
}

local function EatFoodAction(inst) --Look for food to eat
    -- If we don't check that the target is not a beehive, we will keep doing targeting stuff while there's precious honey on the ground
    if inst.sg:HasStateTag("busy")
            and not inst.sg:HasStateTag("wantstoeat")
            and (inst.components.combat ~= nil and
            inst.components.combat.target ~= nil and
            not inst.components.combat.target:HasTag("beehive")) then
        return
    end

    if inst.components.inventory ~= nil and inst.components.eater ~= nil then
        local target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
        if target ~= nil then
            return BufferedAction(inst, target, ACTIONS.EAT)
        end
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SEE_FOOD_DIST, nil, NO_TAGS, inst.components.eater:GetEdibleTags())
    local target = nil
    for i, v in ipairs(ents) do
        if v:IsValid() and v:IsOnValidGround() and inst.components.eater:CanEat(v) then
            if v:HasTag("honeyed") then
                return BufferedAction(inst, v, ACTIONS.PICKUP)
            elseif target == nil then
                target = v
            end
        end
    end

    --no honey found, but was there something else edible?
    return target ~= nil and BufferedAction(inst, target, ACTIONS.PICKUP) or nil
end

local function StealFoodAction(inst) --Look for things to take food from (EatFoodAction handles picking up/ eating)
    -- Food On Ground > Pots = Farms = Drying Racks > Beebox > Mushroom Farm > Look In Fridge > Chests > Backpacks (on ground) > Plants

    if inst.sg:HasStateTag("busy")
        or (inst.components.inventory ~= nil and
            inst.components.inventory:IsFull()) then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SEE_STRUCTURE_DIST, nil, NO_TAGS)
    local targets = {}

    --Gather all targets in one pass
    for i, item in ipairs(ents) do
        if item:IsValid() and item:IsOnValidGround() then
            if item.components.stewer ~= nil then
                if targets.stewer == nil and item.components.stewer:IsDone() then
                    targets.stewer = item
                end
            elseif item.components.dryer ~= nil then
                if targets.harvestable == nil and item.components.dryer:IsDone() then
                    targets.harvestable = item
                end
            elseif item.components.crop ~= nil then
                if targets.harvestable == nil and item.components.crop:IsReadyForHarvest() then
                    targets.harvestable = item
                end
            elseif item:HasTag("beebox") then
                if targets.beebox == nil and item.components.harvestable ~= nil and item.components.harvestable:CanBeHarvested() then
                    targets.beebox = item
                end
            elseif item:HasTag("mushroom_farm") then
                if targets.mushroom_farm == nil and item.components.harvestable ~= nil and item.components.harvestable:CanBeHarvested() then
                    targets.mushroom_farm = item
                end
            elseif item.components.container ~= nil then
                if not item.components.container:IsEmpty() then
                    if item:HasTag("fridge") and item.components.workable ~= nil then
                        if targets.honeyed_fridge == nil then
                            if item.components.container:FindItem(function(food) return inst.components.eater:CanEat(food) and food:HasTag("honeyed") end) ~= nil then
                                targets.honeyed_fridge = item
                                targets.fridge = nil
                            elseif targets.fridge == nil and item.components.container:FindItem(function(food) return inst.components.eater:CanEat(food) end) ~= nil then
                                targets.fridge = item
                            end
                        end
                    elseif item:HasTag("chest") and item.components.workable ~= nil then
                        if targets.honeyed_chest == nil then
                            if item.components.container:FindItem(function(food) return inst.components.eater:CanEat(food) and food:HasTag("honeyed") end) ~= nil then
                                targets.honeyed_chest = item
                                targets.chest = nil
                            elseif targets.chest == nil and item.components.container:FindItem(function(food) return inst.components.eater:CanEat(food) end) ~= nil then
                                targets.chest = item
                            end
                        end
                    elseif item:HasTag("backpack") then
                        if targets.honeyed_backpack == nil then
                            targets.honeyed_backpack = item.components.container:FindItem(function(food) return inst.components.eater:CanEat(food) and food:HasTag("honeyed") end)
                            if targets.honeyed_backpack ~= nil then
                                targets.backpack = nil
                            elseif targets.backpack == nil then
                                targets.backpack = item.components.container:FindItem(function(food) return inst.components.eater:CanEat(food) end)
                            end
                        end
                    end
                end
            elseif item.components.pickable ~= nil then
                if targets.pickable == nil and
                    item.components.pickable.caninteractwith and
                    item.components.pickable:CanBePicked() and
                    PICKABLE_FOODS[item.components.pickable.product] then
                    targets.pickable = item
                end
            end
        end
    end

    --Pick action by priority on all gathered targets
    if targets.stewer ~= nil then
        return BufferedAction(inst, targets.stewer, ACTIONS.HARVEST)
    elseif targets.beebox ~= nil then
        return BufferedAction(inst, targets.beebox, ACTIONS.HARVEST)
    elseif targets.honeyed_fridge ~= nil then
        return BufferedAction(inst, targets.honeyed_fridge, ACTIONS.HAMMER)
    elseif targets.honeyed_chest ~= nil then
        return BufferedAction(inst, targets.honeyed_chest, ACTIONS.HAMMER)
    elseif targets.honeyed_backpack ~= nil then
        return BufferedAction(inst, targets.honeyed_backpack, ACTIONS.STEAL)
    elseif targets.harvestable ~= nil then
        return BufferedAction(inst, targets.harvestable, ACTIONS.HARVEST)
    elseif targets.mushroom_farm ~= nil then
        return BufferedAction(inst, targets.mushroom_farm, ACTIONS.HARVEST)
    elseif targets.fridge ~= nil then
        return BufferedAction(inst, targets.fridge, ACTIONS.HAMMER)
    elseif targets.chest ~= nil then
        return BufferedAction(inst, targets.chest, ACTIONS.HAMMER)
    elseif targets.backpack ~= nil then
        return BufferedAction(inst, targets.backpack, ACTIONS.STEAL)
    elseif targets.pickable ~= nil then
        return BufferedAction(inst, targets.pickable, ACTIONS.PICK)
    end
end

local BEEHIVE_TAGS = { "beehive" }

local function AttackHiveAction(inst)
    local hive = FindEntity(inst, SEE_STRUCTURE_DIST, function(guy) 
            return inst.components.combat:CanTarget(guy) and guy:IsOnValidGround()
        end,
        BEEHIVE_TAGS)
    return hive ~= nil and BufferedAction(inst, hive, ACTIONS.ATTACK) or nil
end

local function ExtendedFoodFinding(self)

    local findfood = DoAction(self.inst, StealFoodAction)
    local attackhive = DoAction(self.inst, AttackHiveAction, "AttackHive", nil, 7)
	
    table.insert(self.bt.root.children, 8, findfood)
    table.insert(self.bt.root.children, 9, attackhive)
end

env.AddBrainPostInit("beargerbrain", ExtendedFoodFinding)
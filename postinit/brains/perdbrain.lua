local env = env
GLOBAL.setfenv(1, GLOBAL)

require "behaviours/wander"
require "behaviours/leash"
require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"


local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 20
local SEE_BUSH_DIST = 40
local SEE_SHRINE_DIST = 30
local MIN_SHRINE_WANDER_DIST = 4
local MAX_SHRINE_WANDER_DIST = 6
local MAX_WANDER_DIST = 80
local SHRINE_LOITER_TIME = 4
local SHRINE_LOITER_TIME_VAR = 3
local MAX_CHASE_DIST = 7
local MAX_CHASE_TIME = 5

local EATFOOD_MUST_TAGS = { "edible_"..FOODTYPE.VEGGIE }
local EATFOOD_CANT_TAGS = { "INLIMBO" }
local SCARY_TAGS = { "scarytoprey" }
local function EatFoodAction(inst, checksafety)
    local target =
        inst.components.inventory ~= nil and
        inst.components.eater ~= nil and
        inst.components.inventory:FindItem(
            function(item)
                return inst.components.eater:CanEat(item)
            end)
        or nil

    if target == nil then
        target = FindEntity(inst, SEE_FOOD_DIST, nil, EATFOOD_MUST_TAGS, EATFOOD_CANT_TAGS)
        --check for scary things near the food, or if it's in the water
        if target == nil or not target:IsOnValidGround() or
                ( checksafety and GetClosestInstWithTag(SCARY_TAGS, target, SEE_PLAYER_DIST) ~= nil ) then
            return nil
        end
    end

    local act = BufferedAction(inst, target, ACTIONS.EAT)
    act.validfn = function()
        return target.components.inventoryitem == nil
            or target.components.inventoryitem.owner == nil
            or target.components.inventoryitem.owner == inst
    end
    return act
end

local function EatFoodWhenSafe(inst)
    return EatFoodAction(inst, true)
end

local function HungryPerd(self)
	local RunAtFood = DoAction(self.inst, EatFoodWhenSafe, "Eat Food", true)

    table.insert(self.bt.root.children, 4, RunAtFood)
end


env.AddBrainPostInit("perdbrain", HungryPerd)
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

local function EatFoodAnytime(inst)
    return EatFoodAction(inst, false)
end

local function EatFoodWhenSafe(inst)
    return EatFoodAction(inst, true)
end

local function HasBerry(item)
    return item.components.pickable ~= nil and (item.components.pickable.product == "berries" or item.components.pickable.product == "berries_juicy")
end

local PICKBERRIES_MUST_TAGS = { "pickable" }
local function PickBerriesActionHungry(inst)
    local target = FindEntity(inst, SEE_FOOD_DIST, HasBerry, PICKBERRIES_MUST_TAGS)
    --check for scary things near the bush
    return target ~= nil
        and BufferedAction(inst, target, ACTIONS.PICK)
        or nil
end

local BUSH_TAGS = { "bush" }
local function FindNearestBush(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SEE_BUSH_DIST, BUSH_TAGS)
    local emptybush = nil
    for i, v in ipairs(ents) do
        if v ~= inst and v.entity:IsVisible() and v.components.pickable ~= nil then
            -- NOTE: if a bush that can be in the ocean gets made, we should test for that here (unless perds learn to swim!)
            if v.components.pickable:CanBePicked() then
                return v
            elseif emptybush == nil then
                emptybush = v
            end
        end
    end
    return emptybush
        or (inst.components.homeseeker ~= nil and inst.components.homeseeker.home)
        or nil
end

local function HomePos(inst)
    local bush = FindNearestBush(inst)
    return bush ~= nil and bush:GetPosition() or nil
end

local function GoHomeAction(inst)
    local bush = FindNearestBush(inst)
    return bush ~= nil and BufferedAction(inst, bush, ACTIONS.GOHOME, nil, bush:GetPosition()) or nil
end

local function HungryPerd(self)
	--[[local MeHungy = WhileNode(function() return self.inst.mehungy < 5 end, "Still Hungry",
				PriorityNode({
					DoAction(self.inst, EatFoodAnytime, "Eat Food"),
					DoAction(self.inst, PickBerriesActionHungry, "Pick Berries", true),
					ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME)),
					Wander(self.inst, HomePos, MAX_WANDER_DIST),
					StandStill(self.inst),
                }, .25))]]
	local DontTouchMe = WhileNode(function() return self.inst.mehungy <= 5 and self.inst.attacked end, "don't touch me",
							RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST))
				
	local MeHungy = WhileNode(function() return self.inst.mehungy <= 5 end, "Still Hungry",
					PriorityNode({
						DoAction(self.inst, EatFoodAnytime, "Eat Food", true),
						DoAction(self.inst, PickBerriesActionHungry, "Pick Berries", true),
						WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
							RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST)),
						WhileNode(function() return TheWorld.state.isnight end, "IsNight",
							DoAction(self.inst, GoHomeAction, "Go Home", true)),
						ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME)),
						RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST),
						Wander(self.inst, HomePos, MAX_WANDER_DIST),
					}, .25))
					
	local RunAtFood = DoAction(self.inst, EatFoodWhenSafe, "Eat Food", true)
					
    table.insert(self.bt.root.children, 2, DontTouchMe)
    table.insert(self.bt.root.children, 3, MeHungy)
    table.insert(self.bt.root.children, 6, RunAtFood)
end


env.AddBrainPostInit("perdbrain", HungryPerd)
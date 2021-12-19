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
require "behaviours/beargeroffscreen"
-----------------------------------------------------------------

local OFFSCREEN_RANGE = 64

local function OutsidePlayerRange(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    return TheWorld.state.isautumn-- and (not IsAnyPlayerInRange(x, y, z, OFFSCREEN_RANGE)) -- only run offscreen behaviour in autumn
end

local function FindNewFood(inst)
	inst.TeleportToFood(inst)
    --[[local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SEE_FOOD_DIST, nil, NO_TAGS, inst.components.eater:GetEdibleTags())
    local target = nil
    for i, v in ipairs(ents) do
        if v:IsValid() and v:IsOnValidGround() and inst.components.eater:CanEat(v) then
            if target == nil then
                target = v
            end
        end
    end
    --no honey found, but was there something else edible?
    return target ~= nil and target or nil]]
end

local function ExtendedFoodFinding(self)
	local OutsidePlayerRange = WhileNode(function() return OutsidePlayerRange(self.inst) end, "OffScreen",
                PriorityNode(
                {   --[[We want the dragonfly to follow the player]]
                    Follow(self.inst, function() return self.inst:GetNearestPlayer(true) end, 0, 15, 20, false)
					--Follow(self.inst, function() return  GetPlayer() end, 0, 15, 20)
                }))

    table.insert(self.bt.root.children, 8, OutsidePlayerRange)
end

env.AddBrainPostInit("beargerbrain", ExtendedFoodFinding)
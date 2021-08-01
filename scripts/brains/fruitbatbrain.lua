require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"
require "behaviours/chaseandattack"

local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 40
local SEE_FOOD_DIST = 20
local MAX_WANDER_DIST = 30
local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

local FruitBatBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    return inst.components.homeseeker ~= nil
        and inst.components.homeseeker.home ~= nil
        and inst.components.homeseeker.home:IsValid()
        and inst.components.homeseeker.home.components.childspawner ~= nil
        and not inst.components.teamattacker.inteam
        and BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
        or nil
end

local function EscapeAction(inst)
    if TheWorld.state.isnight then
        return GoHomeAction(inst)
    end
    -- wander up through a sinkhole at night
    local x, y, z = inst.Transform:GetWorldPosition()
    local exit = TheSim:FindEntities(x, 0, z, TUNING.BAT_ESCAPE_RADIUS, { "batdestination" })[1]
    return exit ~= nil
        and (exit.components.childspawner ~= nil or
            exit.components.hideout ~= nil)
        and BufferedAction(inst, exit, ACTIONS.GOHOME)
        or nil
end

local function EatFoodAction(inst)
	if inst.sg:HasStateTag("busy") or inst:GetTimeAlive() < 5 or
        (inst.components.eater:TimeSinceLastEating() ~= nil and inst.components.eater:TimeSinceLastEating() < 5) then
        return
    elseif inst.components.inventory ~= nil and inst.components.eater ~= nil then
        local target = inst.components.inventory:FindItem(function(item)
            return inst.components.eater:CanEat(item)
        end)
        if target ~= nil then
            return BufferedAction(inst, target, ACTIONS.EAT)
        end
    end

    local target = FindEntity(
        inst,
        SEE_FOOD_DIST,
        function(item)
            return item:GetTimeAlive() >= 8
                and item:IsOnPassablePoint(true)
                and inst.components.eater:CanEat(item)
        end,
        nil,
        NO_TAGS,
        inst.components.eater:GetEdibleTags()
    )
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
end

function FruitBatBrain:OnStart()
    local root = PriorityNode({
        WhileNode(function() return self.inst.components.health.takingfiredamage or self.inst.components.hauntable.panic end, "Panic", Panic(self.inst)),
        ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
        WhileNode(function() return TheWorld.state.isnight end, "IsNight",
            DoAction(self.inst, GoHomeAction)),
          
                DoAction(self.inst, EatFoodAction),
                MinPeriod(self.inst, TUNING.BAT_ESCAPE_TIME, false,
                    DoAction(self.inst, EscapeAction)),
                Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, .25)

    self.bt = BT(self.inst, root)
end

function FruitBatBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return FruitBatBrain
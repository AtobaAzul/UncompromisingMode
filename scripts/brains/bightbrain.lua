require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/useshield"

local BrainCommon = require "brains/braincommon"


local MAX_CHASE_TIME = 99
local MAX_WANDER_DIST = 32


local BightBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


local function InvestigateAction(inst)
    local investigatePos = inst.components.knownlocations ~= nil and inst.components.knownlocations:GetLocation("investigate") or nil
    return investigatePos ~= nil and BufferedAction(inst, nil, ACTIONS.INVESTIGATE, nil, investigatePos, nil, 1) or nil
end

local function Conditions(guy)
return guy:HasTag("funkylight") 
end
local FINDFOOD_CANT_TAGS = { "outofreach" } --Temp
local function TargetIsNotCloseToSpecialLight(inst)
if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
local target = inst.components.combat.target
return not FindEntity(target,
        5,
        function(item)
        return item:HasTag("funkylight")
        end,
        nil,
        FINDFOOD_CANT_TAGS
    )
end
end
function BightBrain:OnStart()
    local root =
        PriorityNode(
        {
			RunAway(self.inst, Conditions, 4, 8),
			WhileNode(function() return TargetIsNotCloseToSpecialLight(self.inst) end, "",
                ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME))),
            DoAction(self.inst, function() return InvestigateAction(self.inst) end ),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
        }, 1)
    self.bt = BT(self.inst, root)
end

function BightBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))

end

return BightBrain

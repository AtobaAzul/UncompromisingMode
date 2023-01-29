require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
--require "behaviours/choptree"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"

local BrainCommon = require "brains/braincommon"

local TRADE_DIST = 20
local function ShouldRunAway(inst, target)
    return not inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GetTraderFn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, TRADE_DIST, true)
    for i, v in ipairs(players) do
        if inst.components.trader:IsTryingToTradeWithMe(v) then
            return v
        end
    end
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end


local TricktreatpigBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function TricktreatpigBrain:OnStart()

    local root =
        PriorityNode(
        {
		
            ChattyNode(self.inst, "PIG_TALK_ATTEMPT_TRADE",
                FaceEntity(self.inst, GetTraderFn, KeepTraderFn)),
        }, .5)

    self.bt = BT(self.inst, root)
end

return TricktreatpigBrain

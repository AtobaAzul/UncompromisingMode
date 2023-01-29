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
local MIN_FOLLOW_LEADER = 2
local MAX_FOLLOW_LEADER = 6
local TARGET_FOLLOW_LEADER = (MAX_FOLLOW_LEADER + MIN_FOLLOW_LEADER) / 2

local Moonmaw_lavaeBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function InvestigateAction(inst)
    local investigatePos = inst.components.knownlocations ~= nil and inst.components.knownlocations:GetLocation("investigate") or nil
    return investigatePos ~= nil and BufferedAction(inst, nil, ACTIONS.INVESTIGATE, nil, investigatePos, nil, 1) or nil
end

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

function Moonmaw_lavaeBrain:OnStart()
    local root =
        PriorityNode(
        {
            DoAction(self.inst, function() return InvestigateAction(self.inst) end ),
			ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME)),
			Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
			WhileNode( function() return self.inst.WINDSTAFF_CASTER ~= nil end, "HasParent",
			Wander(self.inst, function() return self.inst.WINDSTAFF_CASTER:GetPosition() end, MAX_WANDER_DIST)),
        }, 1)
    self.bt = BT(self.inst, root)
end


return Moonmaw_lavaeBrain

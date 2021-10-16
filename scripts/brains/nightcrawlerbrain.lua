require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/chaseandattack"
require "behaviours/avoidlight"

local AVOID_PLAYER_DIST = 3
local AVOID_PLAYER_DIST_SQ = AVOID_PLAYER_DIST * AVOID_PLAYER_DIST
local AVOID_PLAYER_STOP = 8

local AVOID_PLAYER_DIST_COMBAT = 12
local AVOID_PLAYER_DIST_SQ_COMBAT  = AVOID_PLAYER_DIST_COMBAT  * AVOID_PLAYER_DIST_COMBAT 
local AVOID_PLAYER_STOP_COMBAT  = 15

local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 40

local SEE_DIST = 25
local TOOCLOSE = 3

local SEE_BAIT_DIST = 15
local MAX_WANDER_DIST = 5
local NightCrawlerBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function NightCrawlerBrain:OnStart()
    local root = PriorityNode(
			{
				--AvoidLight(self.inst),
                WhileNode( function() return self.inst:IsInLight() and not self.inst.sg:HasStateTag("attack") end, "Dodge",
					RunAway(self.inst, function() return self.inst.components.combat.target end, AVOID_PLAYER_DIST_COMBAT, AVOID_PLAYER_STOP_COMBAT)),
				ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
			}, .25)

    self.bt = BT(self.inst, root)
end

return NightCrawlerBrain

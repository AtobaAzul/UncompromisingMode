require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/chaseandattack"
require "behaviours/avoidlight"
require "behaviours/findclosest"

local AVOID_PLAYER_DIST = 3
local AVOID_PLAYER_DIST_SQ = AVOID_PLAYER_DIST * AVOID_PLAYER_DIST
local AVOID_PLAYER_STOP = 8

local AVOID_PLAYER_DIST_COMBAT = 12
local AVOID_PLAYER_DIST_SQ_COMBAT  = AVOID_PLAYER_DIST_COMBAT  * AVOID_PLAYER_DIST_COMBAT 
local AVOID_PLAYER_STOP_COMBAT  = 15

local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 40

local SEE_LIGHT_DIST = 50

local SEE_DIST = 25
local TOOCLOSE = 3

local SEE_BAIT_DIST = 15
local MAX_WANDER_DIST = 5
local NightCrawlerBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function SafeLightDist(inst, target)
    if target:HasTag("player") or target:HasTag("playerlight") then
        return 4
    end
    local owner = target.components.inventoryitem ~= nil and target.components.inventoryitem:GetGrandOwner() or nil
    return (owner ~= nil and owner:HasTag("player") and 4)
        or (target.Light ~= nil and target.Light:GetCalculatedRadius())
        or 4
end

function NightCrawlerBrain:OnStart()
    local root = PriorityNode(
			{
                WhileNode( function() return (self.inst:IsInLight() or self.inst.components.combat.target and self.inst.components.combat:InCooldown()) and not self.inst.sg:HasStateTag("attack") and not self.inst.sg:HasStateTag("busy") end, "Dodge",
					RunAway(self.inst, "lightsource", AVOID_PLAYER_DIST_COMBAT, AVOID_PLAYER_STOP_COMBAT),
					RunAway(self.inst, "player", AVOID_PLAYER_DIST_COMBAT, AVOID_PLAYER_STOP_COMBAT)),
				ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
				WhileNode( function() return self.inst:IsInLight() and not self.inst.sg:HasStateTag("attack") end, "Light",
					FindClosest(self.inst, SEE_LIGHT_DIST, SafeLightDist, { "fire" }, nil, { "campfire", "lighter" })),
			}, .25)

    self.bt = BT(self.inst, root)
end

return NightCrawlerBrain

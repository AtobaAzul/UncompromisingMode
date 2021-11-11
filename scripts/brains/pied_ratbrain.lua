--Brian
require "behaviours/wander"

local BrainCommon = require "brains/braincommon"

local SEE_PLAYER_DIST = 8
local SEE_FOOD_DIST = 20

local AVOID_PLAYER_DIST = 3
local AVOID_PLAYER_DIST_SQ = AVOID_PLAYER_DIST * AVOID_PLAYER_DIST
local AVOID_PLAYER_STOP = 8

local AVOID_PLAYER_DIST_COMBAT = 6
local AVOID_PLAYER_DIST_SQ_COMBAT  = AVOID_PLAYER_DIST_COMBAT  * AVOID_PLAYER_DIST_COMBAT 
local AVOID_PLAYER_STOP_COMBAT  = 10

local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30

local SEE_DIST = 25
local TOOCLOSE = 3

local SEE_BAIT_DIST = 15
local MAX_WANDER_DIST = 5

local Pied_RatBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function Pied_RatBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            
			WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
				ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
			--WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
			--	RunAway(self.inst, function() return self.inst.components.combat.target end, AVOID_PLAYER_DIST_COMBAT, AVOID_PLAYER_STOP_COMBAT)),
			--RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
			
			--Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, MAX_WANDER_DIST),
        
			--[[Wander(self.inst, function()
				if self.inst.components.knownlocations ~= nil then
					return 
					self.inst.components.knownlocations:GetLocation("home")
				end
			end, MAX_WANDER_DIST)]]
		
		}, 1)
    self.bt = BT(self.inst, root)
end

function Pied_RatBrain:OnInitializationComplete()
		if self.inst.components.knownlocations ~= nil then
			self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
		end
end

return Pied_RatBrain
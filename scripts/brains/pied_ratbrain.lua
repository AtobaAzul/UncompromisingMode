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
local MAX_WANDER_DIST = 10

local Pied_RatBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function CanSpawnChild(inst)
    return inst:GetTimeAlive() > 5
        --and inst:NumHoundsToSpawn() > 0
end

function Pied_RatBrain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            MinPeriod(self.inst, TUNING.WARG_SUMMONPERIOD, true,
            IfNode(function() return CanSpawnChild(self.inst) end, "needs follower",
                ActionNode(function()
					if self.inst.components.health and not self.inst.components.health:IsDead() then
						self.inst.sg:GoToState("toot")
						return SUCCESS
					end
                end, "Summon Rat"))),
			
			
			
			WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
				ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
			--RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
			
			--Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, MAX_WANDER_DIST),
        
			Wander(self.inst, function() 
					if self.inst.components.knownlocations ~= nil then
						return self.inst.components.knownlocations:GetLocation("herd") 
					end
				end, MAX_WANDER_DIST),
				
			Wander(self.inst, function()
				if self.inst.components.knownlocations ~= nil then
					return self.inst.components.knownlocations:GetLocation("home")
				end
			end, MAX_WANDER_DIST)
		
		}, 1)
    self.bt = BT(self.inst, root)
end

function Pied_RatBrain:OnInitializationComplete()
		if self.inst.components.knownlocations ~= nil then
			self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
		end
end

return Pied_RatBrain
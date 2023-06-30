require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/avoidlight"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/useshield"

--local BrainCommon = require "brains/braincommon"

local RUN_AWAY_DIST = 3
local STOP_RUN_AWAY_DIST = 5


local AphidBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function AphidBrain:OnStart()
    local root = PriorityNode(
    {

		WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge", RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) ),


		Leash(self.inst, self.inst.treetarget, 1, 1, false),               

	}, .25)
		


    self.bt = BT(self.inst, root)
end

function AphidBrain:OnInitializationComplete()

end

return AphidBrain

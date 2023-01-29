--Brian
require "behaviours/wander"

local BrainCommon = require "brains/braincommon"

local MAX_WANDER_DIST = 32
local UmbralHound_Brain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function UmbralHound_Brain:OnStart()
    local root =
        PriorityNode(
        {
            WhileNode(function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
            Wander(self.inst, function()
			if self.inst.components.knownlocations ~= nil then
				return 
				self.inst.components.knownlocations:GetLocation("home")
			end
			end, MAX_WANDER_DIST)
        }, 1)
    self.bt = BT(self.inst, root)
end

function UmbralHound_Brain:OnInitializationComplete()
if self.inst.components.knownlocations ~= nil then
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
end
end

return UmbralHound_Brain
require "behaviours/leash"
require "behaviours/standstill"
require "behaviours/wander"

local STALKER_RADIUS = .75
local MINION_RADIUS = .3
local LEASH_DIST = STALKER_RADIUS + MINION_RADIUS

local GingerDeadPig_RneBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetTarget(inst)
    return inst.components.entitytracker:GetEntity("stalker")
end

local function GetTargetPos(inst)
    local target = GetTarget(inst)
    return target ~= nil and target:GetPosition() or nil
end

function GingerDeadPig_RneBrain:OnStart()
    local root = PriorityNode({
        Leash(self.inst, GetTargetPos, LEASH_DIST, LEASH_DIST)
    }, 1)

    self.bt = BT(self.inst, root)
end

return GingerDeadPig_RneBrain

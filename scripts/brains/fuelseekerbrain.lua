require "behaviours/wander"
require "behaviours/findlight"

local BrainCommon = require "brains/braincommon"

local SEE_LIGHT_DIST = 80
local START_RUN_DIST = 5
local STOP_RUN_DIST = 8

local function SafeLightDist(inst, target)
    return target.components.burnable ~= nil and target.components.fueled ~= nil and target.components.fueled.consuming and 3
		or target._light ~= nil and target.components.fueled ~= nil and target.components.fueled.consuming and 3
		--[[
			(target:HasTag("player") or target:HasTag("playerlight")
            or (target.inventoryitem and target.inventoryitem:GetGrandOwner() and target.inventoryitem:GetGrandOwner():HasTag("player")))
        and 3
        or 3]]
end

local FuelSeekerBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function LightStealTarget(inst)
	local target = 
	FindEntity(
				inst,
                6,
                function(guy)
                    return guy.components.burnable ~= nil and 
					guy.components.fueled ~= nil and 
					guy.components.fueled.consuming
                end--[[,
                { "player" },
                { "playerghost" }]]
            )
        or FindEntity(
				inst,
                6,
                function(guy)
                    return guy._light ~= nil and 
					guy.components.fueled ~= nil and 
					guy.components.fueled.consuming
                end--[[,
                { "player" },
                { "playerghost" }]]
            )
		or FindEntity(
				inst,
                6,
                function(guy)
                    return guy._light ~= nil and 
					guy.components.fueled ~= nil and 
					guy.components.fueled.consuming
                end,
                { "INLIMBO" }--[[,
                { "playerghost" }]]
            )
		or FindEntity(
				inst,
                6,
                function(guy)
                    return guy._light ~= nil and 
					guy.components.fueled ~= nil and 
					guy.components.fueled.consuming
                end,
                { "INLIMBO" }--[[,
                { "playerghost" }]]
            )
		or nil
	
	return target and true or false
end

function FuelSeekerBrain:OnStart()

    local root = PriorityNode(
		{
			WhileNode(function() return not self.inst:IsInLight() end, "Flee",
				RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST)),
			WhileNode(function() return not LightStealTarget(self.inst) end, "NoLight",
				RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST)),
			FindLight(self.inst, SEE_LIGHT_DIST, SafeLightDist),
        }, 0.25)

    self.bt = BT(self.inst, root)
end

return FuelSeekerBrain
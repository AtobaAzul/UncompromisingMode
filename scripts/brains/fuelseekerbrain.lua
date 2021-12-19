require "behaviours/wander"
require "behaviours/leash"
require "behaviours/runaway"

local BrainCommon = require "brains/braincommon"

local SEE_LIGHT_DIST = 80
local START_RUN_DIST = 2
local STOP_RUN_DIST = 5
local START_RUN_DIST_DARK = 5
local STOP_RUN_DIST_DARK = 8
local MIN_SHRINE_WANDER_DIST = 2
local MAX_SHRINE_WANDER_DIST = 6

local FuelSeekerBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetNearestLightPos(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 80)

	for i, v in ipairs(ents) do
		if v.components.burnable ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			print("firefound")
			return Vector3(v.Transform:GetWorldPosition())
		elseif v._light ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			print("lightfound")
			return Vector3(v.Transform:GetWorldPosition())
		end
	end
	
    return nil
end

local function GetNearestLightPos_Stop(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 6)

	for i, v in ipairs(ents) do
		if v.components.burnable ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			print("firefound")
			return Vector3(v.Transform:GetWorldPosition())
		elseif v._light ~= nil and v.components.fueled ~= nil and v.components.fueled.consuming then
			print("lightfound")
			return Vector3(v.Transform:GetWorldPosition())
		end
	end
	
    return nil
end

local function FollowPlayer(inst)
    local target = inst:GetNearestPlayer(true)
    return target ~= nil and target:GetPosition() or nil
end

function FuelSeekerBrain:OnStart()

    local root = PriorityNode(
		{
			RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST),
			WhileNode(function() return not self.inst:IsInLight() or GetNearestLightPos(self.inst) == nil end, "Flee",
				RunAway(self.inst, "player", START_RUN_DIST_DARK, STOP_RUN_DIST_DARK)
			),
			WhileNode(function() return GetNearestLightPos_Stop(self.inst) ~= nil end, "StandNearLight",
				StandStill(self.inst)
			),
			WhileNode(function() return GetNearestLightPos(self.inst) ~= nil end, "FindLight",
				Leash(self.inst, GetNearestLightPos, MAX_SHRINE_WANDER_DIST, MIN_SHRINE_WANDER_DIST)
			),
			Follow(self.inst, function() return self.inst:GetNearestPlayer(true) end, MIN_SHRINE_WANDER_DIST, 15, MAX_SHRINE_WANDER_DIST)
        }, 0.25)

    self.bt = BT(self.inst, root)
end

return FuelSeekerBrain
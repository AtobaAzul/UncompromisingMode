require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local SEE_BUSH_DIST = 40 --Used for finding junk to hide in

local AVOID_PLAYER_DIST = 12
local AVOID_PLAYER_DIST_SQ = AVOID_PLAYER_DIST * AVOID_PLAYER_DIST
local AVOID_PLAYER_STOP = 15

local MIN_FOLLOW_DIST = 13
local TARGET_FOLLOW_DIST = 15
local MAX_FOLLOW_DIST = 17

local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30

local SEE_DIST = 25
local TOOCLOSE = 3

local SEE_BAIT_DIST = 15
local MAX_WANDER_DIST = 5

local Uncompromising_JunkRatBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local BUSH_TAGS = { "ratjunk" }
local function FindNearestTrash(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SEE_BUSH_DIST, BUSH_TAGS)
    local trash = nil
    for i, v in ipairs(ents) do
        if v ~= inst and v.entity:IsVisible() then
			trash = v
        end
    end
	if trash ~= nil then
		inst.trashhome = trash
		return trash
	else
		return nil
	end
end

local function HomePos(inst)
    local trash = FindNearestTrash(inst)
    return trash ~= nil and trash:GetPosition() or nil
end

local function GoHomeAction(inst)
    local trash = FindNearestTrash(inst)
    return trash ~= nil and BufferedAction(inst, trash, ACTIONS.GOHOME, nil, trash:GetPosition()) or nil
end

local function edible(inst, item)
	return inst.components.eater:CanEat(item) and item.components.bait and not item:HasTag("planted") and
			not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) and
			item:IsOnPassablePoint() and
			item:GetCurrentPlatform() == inst:GetCurrentPlatform()
end

local function eat_food_action(inst)
	if inst == nil or not inst:IsValid() then
		return nil
	end

	local px, py, pz = inst.Transform:GetWorldPosition()

	local ents_nearby = TheSim:FindEntities(px, py, pz, SEE_BAIT_DIST + AVOID_PLAYER_DIST)

	local foods = {}
	local scaries = {}
	for _, ent in ipairs(ents_nearby) do
		if ent ~= inst and ent.entity:IsVisible() then
			if ent:HasTag("scarytoprey") then
				table.insert(scaries, ent)
			elseif edible(inst, ent) then
				table.insert(foods, ent)
			end
		end
	end

	if #foods == 0 then
		return nil
	end

	local target = nil
	if #scaries == 0 then
		target = foods[1]
	else
		for fi = 1, #foods do
			local food = foods[fi]
			local scary_thing_nearby = false

			for si = 1, #scaries do
				local scary_thing = scaries[si]
				if scary_thing ~= nil and scary_thing.Transform ~= nil then
					local sq_distance = food:GetDistanceSqToPoint(scary_thing.Transform:GetWorldPosition())
					if sq_distance < AVOID_PLAYER_DIST_SQ then
						scary_thing_nearby = true
						break
					end
				end
			end

			if not scary_thing_nearby then
				target = food
				break
			end
		end
	end

	if target then
		local act = BufferedAction(inst, target, ACTIONS.EAT)
		act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
		return act
	end
end

function Uncompromising_JunkRatBrain:OnStart()
	local root = PriorityNode(
	{	
		WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "NotJumpingBehaviour",
                PriorityNode({
		WhileNode( function()
			return self.inst.components.hauntable and self.inst.components.hauntable.panic
		end, "PanicHaunted", Panic(self.inst)),
		WhileNode( function()
			return self.inst.components.health.takingfiredamage or self.inst.components.burnable:IsBurning()
		end, "OnFire", Panic(self.inst)),
		
		
		
		
		
		WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
			ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
        WhileNode(function() return self.inst.shouldhide end, "IsNight",
            DoAction(self.inst, GoHomeAction, "Go Home", true)),
		WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
			RunAway(self.inst, function() return self.inst.components.combat.target end, AVOID_PLAYER_DIST, AVOID_PLAYER_STOP)),
		RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),

        --Following
        --[[WhileNode(function() return self.inst.harassplayer end, "Annoy Leader",
            DoAction(self.inst, AnnoyLeader)),]]
        Follow(self.inst, function() return self.inst.harassplayer end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		
		DoAction(self.inst, eat_food_action),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, MAX_WANDER_DIST),
		}, 0.25))
	}, .25)
	self.bt = BT(self.inst, root)
end

return Uncompromising_JunkRatBrain

require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

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

local Uncompromising_RatBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function CanSteal(item)
	return item.components.inventoryitem ~= nil
		and item.components.inventoryitem.canbepickedup
		and item:IsOnValidGround()
		and not item:IsNearPlayer(TOOCLOSE)
		and not item:HasTag("raidrat")
end

local function StealAction(inst)
	local targetpriority = FindEntity(inst, SEE_DIST,
	CanSteal,
	{ "_inventoryitem", "_equippable" },
	{ "raidrat", "spider", "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container" })
	
	local targetpriority_secondary = FindEntity(inst, SEE_DIST,
	CanSteal,
	{ "_inventoryitem", "preparedfood" },
	{ "raidrat", "spider", "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container" })
	
	local target = FindEntity(inst, SEE_DIST,
	CanSteal,
	{ "_inventoryitem" },
	{ "raidrat", "spider", "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container" })
			
	if inst:HasTag("packrat") and not inst.components.inventory:IsFull() then
		if targetpriority ~= nil then
			return targetpriority ~= nil
				and BufferedAction(inst, targetpriority, ACTIONS.PICKUP)
				or nil
		elseif targetpriority_secondary ~= nil then
			return targetpriority_secondary ~= nil
				and BufferedAction(inst, targetpriority_secondary, ACTIONS.PICKUP)
				or nil
		else
			return target ~= nil
				and BufferedAction(inst, target, ACTIONS.PICKUP)
				or nil
		end
	else
		if targetpriority ~= nil and inst._item ~= nil and not inst._item:HasTag("_equippable") then
			return targetpriority ~= nil
				and BufferedAction(inst, targetpriority, ACTIONS.PICKUP)
				or nil
		elseif targetpriority_secondary ~= nil and inst._item ~= nil and not inst._item:HasTag("_equippable") and not inst._item:HasTag("preparedfood") then
			return targetpriority_secondary ~= nil
				and BufferedAction(inst, targetpriority_secondary, ACTIONS.PICKUP)
				or nil
		elseif not inst.components.inventory:IsFull() then
			return target ~= nil
				and BufferedAction(inst, target, ACTIONS.PICKUP)
				or nil
		end
	end
end

local function CanHammer(item)
	return item.components.container ~= nil
		and item.components.workable ~= nil
		and not item.components.container:IsEmpty()
		and not item:IsNearPlayer(TOOCLOSE)
		and item:IsOnValidGround()
end

local function EmptyChest(inst)
	if not inst.components.inventory:IsFull() then
		local target = FindEntity(inst, SEE_DIST, CanHammer, { "structure", "_container", "HAMMER_workable" })
		return target ~= nil
			and BufferedAction(inst, target, ACTIONS.HAMMER)
			or nil
	end
end

local function edible(inst, item)
	return inst.components.eater:CanEat(item) --[[and item.components.bait]] and not item:HasTag("planted") and
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

function Uncompromising_RatBrain:OnStart()
	local stealnode = PriorityNode(
	{
		WhileNode(function() return not self.inst.sg:HasStateTag("jumping") and self.inst.prefab ~= "uncompromising_caverat" end, "NotJumpingBehaviour",
                PriorityNode({
		DoAction(self.inst, eat_food_action),
		DoAction(self.inst, function() return StealAction(self.inst) end, "steal", true ),
		DoAction(self.inst, function() return EmptyChest(self.inst) end, "emptychest", true )
		}, .25))
	}, 0.25)
	local root = PriorityNode(
	{	
		WhileNode(function() return not self.inst.sg:HasStateTag("jumping") end, "NotJumpingBehaviour",
                PriorityNode({
		WhileNode( function()
			return self.inst.components.hauntable and self.inst.components.hauntable.panic
		end, "PanicHaunted", Panic(self.inst)),
		MinPeriod(self.inst, 2, true,
            stealnode),
		WhileNode( function()
			return self.inst.components.health.takingfiredamage or self.inst.components.burnable:IsBurning()
		end, "OnFire", Panic(self.inst)),
		WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
			ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
		WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
			RunAway(self.inst, function() return self.inst.components.combat.target end, AVOID_PLAYER_DIST_COMBAT, AVOID_PLAYER_STOP_COMBAT)),
		RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),

		DoAction(self.inst, eat_food_action),
		
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, MAX_WANDER_DIST),
		}, 0.25))
	}, .25)
	self.bt = BT(self.inst, root)
end

return Uncompromising_RatBrain

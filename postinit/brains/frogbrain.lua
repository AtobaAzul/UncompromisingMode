local env = env
GLOBAL.setfenv(1, GLOBAL)
require "behaviours/runaway"
-----------------------------------------------------------------
local SEE_DIST = 12

local AVOID_PLAYER_DIST = 7
local AVOID_PLAYER_STOP = 12

local AVOID_DIST = 10
local AVOID_STOP = 12

local FINDFOOD_CANT_TAGS = { "outofreach" }
local function EatFoodAction(inst)
	if inst.sg.currentstate.name == "fall" then
		return nil
	end
    --[[local target = FindEntity(inst, SEE_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnPassablePoint(true) end)
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
	]]
	 local target = FindEntity(inst,
        SEE_DIST,
        function(item)
            return item.prefab ~= "mandrake"
                and item.components.edible ~= nil
                and item:IsOnPassablePoint()
				and item:IsOnValidGround()
				and not (item:HasTag("bee") or item:HasTag("mosquito"))
                and (inst.components.eater ~= nil and inst.components.eater:CanEat(item))
        end,
        nil,
        FINDFOOD_CANT_TAGS
    )
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.PICKUP) or nil
    end
end

local function FrogFindFood(self)

    local avoidthenoid = RunAway(self.inst, "epic", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP , function(inst) 
	local target = inst.components.combat ~= nil and inst.components.combat.target ~= nil and inst.components.combat.target or nil
	
	if target ~= nil and target:HasTag("epic") and TUNING.DSTU.COWARDFROGS then
		inst.components.combat:DropTarget()
	end
	
	return true 
	end)
	if TUNING.DSTU.COWARDFROGS then
        table.insert(self.bt.root.children, 2, avoidthenoid)
    end
    local findfood = DoAction(self.inst, EatFoodAction, "eat food", true)
	if TUNING.DSTU.HUNGRYFROGS then
        table.insert(self.bt.root.children, 4, findfood)
    end
end

env.AddBrainPostInit("frogbrain", FrogFindFood)

local function ToadFindFood(self)

    local avoidthenoid = RunAway(self.inst, "epic", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP , function(inst) 
	local target = inst.components.combat ~= nil and inst.components.combat.target ~= nil and inst.components.combat.target or nil
	
	if target ~= nil and target:HasTag("epic") then
		inst.components.combat:DropTarget()
	end
	
	return true 
	end)
    if TUNING.DSTU.COWARDFROGS then
        table.insert(self.bt.root.children, 2, avoidthenoid)
    end
    local findfood = DoAction(self.inst, EatFoodAction, "eat food", true)
    if TUNING.DSTU.HUNGRYFROGS then
        table.insert(self.bt.root.children, 4, findfood)
    end
end

env.AddBrainPostInit("uncompromising_toadbrain", ToadFindFood)
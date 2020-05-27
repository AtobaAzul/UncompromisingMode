local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local SEE_DIST = 20

local function EatFoodAction(inst)
	if inst.sg.currentstate.name == "fall" then
		return nil
	end
    local target = FindEntity(inst, SEE_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnPassablePoint(true) end)
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
end

local function FrogFindFood(self)


    local findfood = DoAction(self.inst, EatFoodAction, "eat food", true)
	
    table.insert(self.bt.root.children, 3, findfood)
end

env.AddBrainPostInit("frogbrain", FrogFindFood)

local function ToadFindFood(self)

    local findfood = DoAction(self.inst, EatFoodAction, "eat food", true)
	
    table.insert(self.bt.root.children, 3, findfood)
end

env.AddBrainPostInit("toadbrain", ToadFindFood)
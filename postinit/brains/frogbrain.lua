local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local SEE_DIST = 20

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
        return BufferedAction(inst, target, ACTIONS.EAT) or nil
    end
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

env.AddBrainPostInit("uncompromising_toadbrain", ToadFindFood)
local env = env
GLOBAL.setfenv(1, GLOBAL)

local SEE_FOOD_DIST = 15
local NO_TAGS = {"FX", "NOCLICK", "DECOR","INLIMBO"}
local FINDFOOD_CANT_TAGS = { "outofreach" }

local function TargetNotClaimed(inst, target)
	local herd = inst.components.herdmember.herd
	if herd and herd.components.herd.members then
		for k,v in pairs(herd.components.herd.members) do
			if k then
				local ba = k:GetBufferedAction()
				if ba and ba.target == target then
					return false
				end
			end
		end
	end
	return true
end

local function EatFoodAction_UM(inst)	--Look for food to eat

	local target = nil
	local action = nil

	if inst.sg:HasStateTag("busy")
		and not inst.sg:HasStateTag("wantstoeat") then
		return
	end

	if inst.components.inventory and inst.components.eater then
		target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
		if target then return BufferedAction(inst,target,ACTIONS.EAT) end
	end

	local pt = inst:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_FOOD_DIST, nil, NO_TAGS, inst.components.eater:GetEdibleTags())

	if not target then
		for k,v in pairs(ents) do
			if v and v:IsOnValidGround() and
			inst.components.eater:CanEat(v) and
			v:GetTimeAlive() > 5 and
			v.components.inventoryitem and not
			v.components.inventoryitem:IsHeld() and
			TargetNotClaimed(inst, v) then
				target = v
				break
			end
		end
	end

	if target then
		local action = BufferedAction(inst,target,ACTIONS.PICKUP)
		return action
	end
end

local function GosFindFood(self)
	local findfood = DoAction(self.inst, EatFoodAction_UM, "eat food", true)
	
	table.insert(self.bt.root.children, 1, findfood)
end

env.AddBrainPostInit("mosslingbrain", GosFindFood)
local env = env
GLOBAL.setfenv(1, GLOBAL)

local function UpdateHungerDrain(inst)
	local hunger = inst.components.hunger:GetPercent()

	if hunger >= 0.75 then
		if inst.hungerpercent < 5.95 then
			inst.hungerpercent = inst.hungerpercent + 0.05
			inst.hungerrate = inst.standardrate * inst.hungerpercent
		else
			inst.hungerpercent = 6
			inst.hungerrate = inst.standardrate * inst.hungerpercent
		end
	elseif hunger <= 0.25 then
		if inst.hungerpercent > 0.80 then
			inst.hungerpercent = inst.hungerpercent - 0.05
			inst.hungerrate = inst.standardrate * inst.hungerpercent
		else
			inst.hungerpercent = 0.75
			inst.hungerrate = inst.standardrate * inst.hungerpercent
		end
	else
		if inst.hungerpercent > 1.30 then
			inst.hungerpercent = inst.hungerpercent - 0.05
			inst.hungerrate = inst.standardrate * inst.hungerpercent
		elseif inst.hungerpercent <= 1.20 then
			inst.hungerpercent = inst.hungerpercent + 0.05
			inst.hungerrate = inst.standardrate * inst.hungerpercent
		else
			inst.hungerpercent = 1.25
			inst.hungerrate = inst.standardrate * inst.hungerpercent
		end
	end
	
	print("Wolfgang Hunger Drain = "..inst.hungerpercent)
	
	inst.components.hunger:SetRate(inst.hungerrate)
end

local function UpdateMightiness(inst)
	local hunger = inst.components.hunger:GetPercent()
	
	inst.components.mightiness:SetPercent(hunger)

	if hunger >= 0.75 then
		inst:AddTag("fat_gang")
	else
		inst:RemoveTag("fat_gang")
	end
end

env.AddPrefabPostInit("wolfgang", function(inst)
    
	if inst ~= nil and inst.components.mightiness ~= nil then
		inst.standardrate = TUNING.WILSON_HUNGER_RATE * 1.25
		inst.hungerrate = inst.standardrate
		inst.hungerpercent = 1.25

		inst.components.mightiness.rate = 0
		inst:ListenForEvent("hungerdelta", UpdateMightiness)
        inst.components.hunger.current = TUNING.WOLFGANG_START_HUNGER
		inst:DoPeriodicTask(0.5, UpdateHungerDrain)
	end
	
end)
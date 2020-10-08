local env = env
GLOBAL.setfenv(1, GLOBAL)
---	This Code Applies Groginess To The Player Based On How Much Higher 
---	The Hunger Value Of Eaten Food Is Compared To The Players Max Hunger. Min 1, Max 6

env.AddPlayerPostInit(function(inst)
	inst:ListenForEvent("oneat", function(inst, data)
		if data.food ~= nil and data.food.components.edible ~= nil and data.food.components.edible.hungervalue ~= nil then
			local overstuffed = inst.components.hunger.current + data.food.components.edible.hungervalue
			local maxhunger = inst.components.hunger.max
			local clampvalue = overstuffed - maxhunger
				
			if inst.components.grogginess ~= nil then
				if overstuffed > maxhunger then
					if inst.components.grogginess:HasGrogginess() then
						inst.components.talker:Say(GetString(inst, "ANNOUNCE_OVER_EAT", "OVERSTUFFED"))
						inst.components.grogginess:MaximizeGrogginess()
						print("STOP THIS FORCE FEEDING ITS TOO MUCH")
					else
						inst.components.talker:Say(GetString(inst, "ANNOUNCE_OVER_EAT", "STUFFED"))
						local delta = math.clamp(clampvalue / 10, 0.1, 2.9)
						inst.components.grogginess:AddGrogginess(delta)
						print("OVERSTUFFED AMOUNT:")
						print(clampvalue)
						print("GROGINESS DELTA:")
						print(delta)
					end
				end
			end
		end
	end)
end)
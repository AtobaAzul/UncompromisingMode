GLOBAL.STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACIDRAIN = {"Ack!", "It burns!", "The rain is poison!", }
--TODO: Add character specific quotes

local function doacidrain(inst, dt)
    if inst.components.moisture ~= nil and inst.components.moisture:GetMoisture() > 0 and GLOBAL.TheWorld.state.isautumn and GLOBAL.TheWorld.state.cycles > GLOBAL.TUNING.DSTU.ACID_RAIN_START_AFTER_DAY then

        local t = GLOBAL.GetTime()
		local mushroomcheck = TheSim:FindFirstEntityWithTag("acidrain_mushroom")
        -- Raining, no moisture-giving equipment on head, and moisture is increasing. Pro-rate damage based on waterproofness.
        if inst.components.inventory:GetEquippedMoistureRate(GLOBAL.EQUIPSLOTS.HEAD) <= 0 and inst.components.moisture:GetRate() > 0 and mushroomcheck ~= nil then
            local waterproofmult =
                (   inst.components.sheltered ~= nil and
                    inst.components.sheltered.sheltered and
                    inst.components.sheltered.waterproofness or 0
                ) +
                (   inst.components.inventory ~= nil and
                    inst.components.inventory:GetWaterproofness() or 0
                )
            if waterproofmult < 1 and t > inst.acid_time + inst.acid_time_offset + waterproofmult * 7 and mushroomcheck ~= nil then
                inst.components.health:DoDelta(-GLOBAL.TUNING.DSTU.ACID_RAIN_DAMAGE_TICK, false, "rain")
                --assuming you have 0 wetness resistance and it rains nonstop, you will lose on average 30% max health per day
                inst.components.health:DeltaPenalty(GLOBAL.TUNING.DSTU.ACID_RAIN_DAMAGE_TICK / 800)
				if math.random() <= 0.3 then 
					inst.components.talker:Say(GLOBAL.GetString(inst, "ANNOUNCE_ACIDRAIN"))
				end
                inst.acid_time_offset = 3 + math.random() * 2
                inst.acid_time = t
		--[[elseif waterproofmult < 1 and t > inst.acid_time + inst.acid_time_offset + waterproofmult * 7 and c_countprefabs("mushroomsprout_overworld") >= 2 and c_countprefabs("mushroomsprout_overworld") < 4 then
                inst.components.health:DoDelta(-1, false, "rain")
		inst.components.talker:Say(GLOBAL.GetString(inst, "ANNOUNCE_ACIDRAIN"))
                inst.acid_time_offset = 3 + math.random() * 2
                inst.acid_time = t
				elseif waterproofmult < 1 and t > inst.acid_time + inst.acid_time_offset + waterproofmult * 7 and c_countprefabs("mushroomsprout_overworld") >= 4 and c_countprefabs("mushroomsprout_overworld") < 6  then
                inst.components.health:DoDelta(-1.5, false, "rain")
		inst.components.talker:Say(GLOBAL.GetString(inst, "ANNOUNCE_ACIDRAIN"))
                inst.acid_time_offset = 3 + math.random() * 2
                inst.acid_time = t
				elseif waterproofmult < 1 and t > inst.acid_time + inst.acid_time_offset + waterproofmult * 7 and c_countprefabs("mushroomsprout_overworld") >= 6 and c_countprefabs("mushroomsprout_overworld") < 8  then
                inst.components.health:DoDelta(-2, false, "rain")
		inst.components.talker:Say(GLOBAL.GetString(inst, "ANNOUNCE_ACIDRAIN"))
                inst.acid_time_offset = 3 + math.random() * 2
                inst.acid_time = t
				elseif waterproofmult < 1 and t > inst.acid_time + inst.acid_time_offset + waterproofmult * 7 and c_countprefabs("mushroomsprout_overworld") >= 8 then
                inst.components.health:DoDelta(-2.5, false, "rain")
		inst.components.talker:Say(GLOBAL.GetString(inst, "ANNOUNCE_ACIDRAIN"))
                inst.acid_time_offset = 3 + math.random() * 2
                inst.acid_time = t

				]]
            end
        elseif t > inst.acid_time + inst.acid_time_offset and mushroomcheck ~= nil then -- We have moisture-giving equipment on our head or it is not raining and we are just passively wet (but drying off). Do full damage.
            inst.components.health:DoDelta(
                inst.components.moisture:GetRate() >= 0 and
                -.2 or
                -.1,
                false, "water")
            inst.acid_time_offset = 3 + math.random() * 2
            inst.acid_time = t
        end
    end
end

local function onisraining(inst, israining)
    if israining then
        if inst.acid_task == nil then
            inst.acid_task = inst:DoPeriodicTask(5, doacidrain, nil, .1)
        end
    elseif inst.acid_task ~= nil then
        inst.acid_task:Cancel()
        inst.acid_task = nil
    end
end

AddPlayerPostInit(function(inst)
	inst.acid_task = nil
   	inst.acid_time = 0
   	inst.acid_time_offset = 3

	if not GLOBAL.TheWorld.ismastersim then
            return inst
        end

	if not inst.watchingrain then
        inst.watchingrain = true
        inst:WatchWorldState("israining", onisraining)
        onisraining(inst, GLOBAL.TheWorld.state.israining)
    end

	inst:AddComponent("firerain")
end)
-----------------------------------------------------------------
-- Wolfgang scaredy cat bonus is increased significantly
-----------------------------------------------------------------
local function speedcheck(inst)
	if inst.strength == "mighty" then
		if inst.components.locomotor ~= nil then
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED / 1.2
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED / 1.2
		end
	else
		if inst.components.locomotor ~= nil then
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
		end
	end
end

AddPrefabPostInit("wolfgang", function(inst)
    if inst ~= nil and inst.components.sanity ~= nil then    
        inst.components.sanity.night_drain_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
        inst.components.sanity.neg_aura_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
    end
	
	inst:ListenForEvent("hungerdelta", speedcheck)
end)

--TODO add a "scared" animation from time to time, as a flavour
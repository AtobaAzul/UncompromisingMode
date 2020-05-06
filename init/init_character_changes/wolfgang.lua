-----------------------------------------------------------------
-- Wolfgang scaredy cat bonus is increased significantly
-----------------------------------------------------------------
local function speedcheck(inst)
	if inst.strength == "mighty" then
		inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED / 1.25
		inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED / 1.25
		print(inst.components.locomotor.walkspeed)
		print(inst.components.locomotor.runspeed)
	else
		inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED
		inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
		print(inst.components.locomotor.walkspeed)
		print(inst.components.locomotor.runspeed)
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
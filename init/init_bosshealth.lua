AddPrefabPostInit("minotaur", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.MINOTAUR_HEALTH * TUNING.DSTU.MINOTAUR_HEALTH)
	end
end)

AddPrefabPostInit("stalker_forest", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.STALKER_HEALTH * TUNING.DSTU.STALKER_HEALTH)
	end
end)

AddPrefabPostInit("stalker", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.STALKER_HEALTH * TUNING.DSTU.STALKER_HEALTH)
	end
	
end)

AddPrefabPostInit("stalker_atrium", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.STALKER_ATRIUM_HEALTH * TUNING.DSTU.STALKER_ATRIUM_HEALTH)
	end
	
	TUNING.STALKER_ATRIUM_PHASE2_HEALTH = 10000 * TUNING.DSTU.STALKER_HEALTH
	
end)

AddPrefabPostInit("bearger", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.BEARGER_HEALTH * TUNING.DSTU.BEARGER_HEALTH)
	end
end)

AddPrefabPostInit("mutatedbearger", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.BEARGER_HEALTH * TUNING.DSTU.BEARGER_HEALTH)
	end
end)

AddPrefabPostInit("beequeen", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.BEEQUEEN_HEALTH * TUNING.DSTU.BEEQUEEN_HEALTH)
	end
end)

AddPrefabPostInit("alterguardian_phase1", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(GLOBAL.TUNING.ALTERGUARDIAN_PHASE1_HEALTH * TUNING.DSTU.ALTERGUARDIAN_PHASE1_HEALTH)
	end
end)

AddPrefabPostInit("alterguardian_phase2", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(GLOBAL.TUNING.ALTERGUARDIAN_PHASE2_STARTHEALTH * TUNING.DSTU.ALTERGUARDIAN_PHASE2_HEALTH)
	end
end)

AddPrefabPostInit("alterguardian_phase3", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(GLOBAL.TUNING.ALTERGUARDIAN_PHASE3_STARTHEALTH * TUNING.DSTU.ALTERGUARDIAN_PHASE3_HEALTH)
	end
end)

AddPrefabPostInit("mutateddeerclops", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.MUTATED_DEERCLOPS_HEALTH * TUNING.DSTU.MUTATED_DEERCLOPS_HEALTH)
	end
end)

AddPrefabPostInit("dragonfly", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DRAGONFLY_HEALTH * TUNING.DSTU.DRAGONFLY_HEALTH)
	end
end)

AddPrefabPostInit("eyeofterror", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.EYEOFTERROR_HEALTH * TUNING.DSTU.EYEOFTERROR_HEALTH)
	end
end)

AddPrefabPostInit("sharkboi", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.SHARKBOI_HEALTH * TUNING.DSTU.SHARKBOI_HEALTH)
	end
end)

AddPrefabPostInit("lordfruitfly", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.LORDFRUITFLY_HEALTH * TUNING.DSTU.LORDFRUITFLY_HEALTH)
	end
end)

AddPrefabPostInit("malbatross", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.MALBATROSS_HEALTH * TUNING.DSTU.MALBATROSS_HEALTH)
	end
end)

AddPrefabPostInit("moose", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.MOOSE_HEALTH * TUNING.DSTU.MOOSE_HEALTH)
	end
end)

AddPrefabPostInit("daywalker", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DAYWALKER_HEALTH * TUNING.DSTU.DAYWALKER_HEALTH)
	end
end)

AddPrefabPostInit("warg", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.WARG_HEALTH * TUNING.DSTU.WARG_HEALTH)
	end
end)

AddPrefabPostInit("mutatedwarg", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.MUTATED_WARG_HEALTH * TUNING.DSTU.MUTATED_WARG_HEALTH)
	end
end)

AddPrefabPostInit("spiderqueen", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.SPIDERQUEEN_HEALTH * TUNING.DSTU.SPIDERQUEEN_HEALTH)
	end
end)

AddPrefabPostInit("toadstool", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.TOADSTOOL_HEALTH * TUNING.DSTU.TOADSTOOL_HEALTH)
	end
end)

AddPrefabPostInit("toadstool_dark", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.TOADSTOOL_DARK_HEALTH * TUNING.DSTU.TOADSTOOL_DARK_HEALTH)
	end
end)

AddPrefabPostInit("twinofterror1", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.TWIN1_HEALTH * TUNING.DSTU.TWIN1_HEALTH)
	end
end)

AddPrefabPostInit("twinofterror2", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.TWIN2_HEALTH * TUNING.DSTU.TWIN2_HEALTH)
	end
end)
local function DefaultIgniteFn(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:StartWildfire()
    end
end

AddPrefabPostInit("willow", function(inst)
	if inst.components.burnable ~= nil then
		
		inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
		
		inst:AddComponent("propagator")
		inst.components.propagator.acceptsheat = true
		inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
		inst.components.propagator.flashpoint = 5 + math.random()*5
		inst.components.propagator.decayrate = 0.5
		inst.components.propagator.propagaterange = 5
		inst.components.propagator.heatoutput = 5--8

		inst.components.propagator.damagerange = 2
		inst.components.propagator.damages = true
	end
end)
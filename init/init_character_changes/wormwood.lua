--More and longer fire damage
GLOBAL.TUNING.WORMWOOD_BURN_TIME = GLOBAL.TUNING.DSTU.WORMWOOD_BURN_TIME 
GLOBAL.TUNING.WORMWOOD_FIRE_DAMAGE = GLOBAL.TUNING.DSTU.WORMWOOD_FIRE_DAMAGE

local function DefaultIgniteFn(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:StartWildfire()
    end
end

AddPrefabPostInit("wormwood", function(inst)
	if inst.components.burnable ~= nil then
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
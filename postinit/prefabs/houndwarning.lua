local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("houndwarning_lvl1", function(inst, distance)
	inst:DoTaskInTime(0, function() 
		if TUNING.DSTU.VARGWAVES and TheWorld.components.hounded and math.random() >= .3 then
			if TheWorld.components.hounded.varggraceperiod ~= nil and TheWorld.state.cycles > (TheWorld.components.hounded.varggraceperiod + TUNING.DSTU.VARGWAVES_DELAY_PERIOD) then
				inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
			end
		end
	end)
end)

env.AddPrefabPostInit("houndwarning_lvl2", function(inst, distance)
	inst:DoTaskInTime(0, function()
		if TUNING.DSTU.VARGWAVES and TheWorld.components.hounded and math.random() >= .3 then
			if TheWorld.components.hounded.varggraceperiod ~= nil and TheWorld.state.cycles > (TheWorld.components.hounded.varggraceperiod + TUNING.DSTU.VARGWAVES_DELAY_PERIOD) then
				inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
			end
		end
	end)
end)

env.AddPrefabPostInit("houndwarning_lvl3", function(inst, distance)
	inst:DoTaskInTime(0, function() 
		if TUNING.DSTU.VARGWAVES and TheWorld.components.hounded and math.random() >= .3 then
			if TheWorld.components.hounded.varggraceperiod ~= nil and TheWorld.state.cycles > (TheWorld.components.hounded.varggraceperiod + TUNING.DSTU.VARGWAVES_DELAY_PERIOD) then
				inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
			end
		end
	end)
end)

env.AddPrefabPostInit("houndwarning_lvl4", function(inst, distance)
	inst:DoTaskInTime(0, function() 
		if TUNING.DSTU.VARGWAVES and TheWorld.components.hounded and math.random() >= .3 then
			if TheWorld.components.hounded.varggraceperiod ~= nil and TheWorld.state.cycles > (TheWorld.components.hounded.varggraceperiod + TUNING.DSTU.VARGWAVES_DELAY_PERIOD) then
				inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
			end
		end
	end)
end)
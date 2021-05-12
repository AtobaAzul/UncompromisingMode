local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("houndwarning_lvl1", function(inst, distance)
	inst:DoTaskInTime(0, function() 
		if TheWorld.components.hounded and TheWorld.state.cycles >= 100 and math.random() >= .3 then
			inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
		end
	end)
end)

env.AddPrefabPostInit("houndwarning_lvl2", function(inst, distance)
	inst:DoTaskInTime(0, function()
		if TheWorld.components.hounded and TheWorld.state.cycles >= 100 and math.random() >= .3 then
			inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
		end
	end)
end)

env.AddPrefabPostInit("houndwarning_lvl3", function(inst, distance)
	inst:DoTaskInTime(0, function() 
		if TheWorld.components.hounded and TheWorld.state.cycles >= 100 and math.random() >= .3 then
			inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
		end
	end)
end)

env.AddPrefabPostInit("houndwarning_lvl4", function(inst, distance)
	inst:DoTaskInTime(0, function() 
		if TheWorld.components.hounded and TheWorld.state.cycles >= 100 and math.random() >= .3 then
			inst.SoundEmitter:PlaySound("UCSounds/wargdistant/distant")
		end
	end)
end)
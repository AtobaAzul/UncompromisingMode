local env = env
GLOBAL.setfenv(1, GLOBAL)

--Oh the hoops I had to go through.
env.AddPrefabPostInit("inventoryitem_classified", function(inst)
	--local _SerializePercentUsed = inst.SerializePercentUsed

	inst.SerializePercentUsed = function(inst, percent) --didn't want to have to replace this but unfortunetly tags don't work here, oh well.
		inst.percentused:set((percent == nil and 255) or (percent <= 0 and 0) or
		math.clamp(math.floor(percent * 100 + .5), 1, 200))
	end
end)

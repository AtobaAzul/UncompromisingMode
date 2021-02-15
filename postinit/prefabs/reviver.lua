local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("reviver", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst.components.tradable.goldvalue = 2*TUNING.GOLD_VALUES.MEAT

--return inst
end)
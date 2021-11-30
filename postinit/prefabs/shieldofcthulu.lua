local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("shieldofterror", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst.components.armor:InitCondition(2*TUNING.SHIELDOFTERROR_ARMOR, TUNING.SHIELDOFTERROR_ABSORPTION)

--return inst
end)
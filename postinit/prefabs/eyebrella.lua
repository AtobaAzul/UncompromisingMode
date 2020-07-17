local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("eyebrellahat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.insulator ~= nil then
        inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	end
	
end)
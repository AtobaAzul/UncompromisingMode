local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("warly", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.eater ~= nil then
		inst.components.eater:SetAbsorptionModifiers(1.2, 1.15, 1.2)
	end
	
end)


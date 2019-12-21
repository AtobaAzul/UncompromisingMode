local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("bearger", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.groundpounder then
		inst.components.groundpounder.sinkhole = true
	end
end)
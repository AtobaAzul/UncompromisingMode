local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("compostingbin", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.compostingbin ~= nil then
		inst.components.compostingbin.max_materials = 24
	end
end)

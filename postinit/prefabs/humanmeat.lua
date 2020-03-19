local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("humanmeat", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
    if inst.components.edible ~= nil then
		inst.components.edible.foodtype = FOODTYPE.HORRIBLE
	end
end)
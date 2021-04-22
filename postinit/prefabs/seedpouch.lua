local env = env
GLOBAL.setfenv(1, GLOBAL)



env.AddPrefabPostInit("seedpouch", function(inst)
	if not TheWorld.ismastersim then
		return
	end
    inst:AddTag("fridge")
    inst:AddTag("nocool")	
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("sewing_tape", function(inst)
	if not TheWorld.ismastersim then
		return
	end
    inst:AddTag("toolbox_item")	
end)
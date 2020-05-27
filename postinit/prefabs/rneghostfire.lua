local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddPrefabPostInit("minerhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget1")
inst:AddTag("lighttarget")
--return inst
end)
env.AddPrefabPostInit("lantern", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget1")
inst:AddTag("lighttarget")
--return inst
end)
env.AddPrefabPostInit("stafflight", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget2")
inst:AddTag("lighttarget")
--return inst
end)
env.AddPrefabPostInit("staffcoldlight", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget2")
inst:AddTag("lighttarget")
--return inst
end)
env.AddPrefabPostInit("campfire", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
--return inst
end)
env.AddPrefabPostInit("firepit", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
--return inst
end)
env.AddPrefabPostInit("coldfire", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
--return inst
end)
env.AddPrefabPostInit("coldfirepit", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
--return inst
end)
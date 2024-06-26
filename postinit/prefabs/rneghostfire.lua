local env = env
GLOBAL.setfenv(1, GLOBAL)


--[[env.AddPrefabPostInit("minerhat", function(inst)
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
end)]]--
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
env.AddPrefabPostInit("pumpkin_lantern", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
inst:AddTag("plight")
--return inst
end)
env.AddPrefabPostInit("mushroom_light", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
inst:AddTag("mlight1")
--return inst
end)
env.AddPrefabPostInit("mushroom_light2", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
inst:AddTag("mlight2")
--return inst
end)
env.AddPrefabPostInit("dragonflyfurnace", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:AddTag("lighttarget")
inst:AddTag("dlight")
--return inst
end)
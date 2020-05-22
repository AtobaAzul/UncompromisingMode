local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("mist", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
inst:WatchWorldState("isday", function(inst) 
if inst:HasTag("rne") then 
inst:Remove()
end 
end)

--return inst
end)
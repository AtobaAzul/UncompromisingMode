local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("spiderqueen", function(inst)
	inst.entity:AddGroundCreepEntity()
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst.GroundCreepEntity:SetRadius(2)
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("crabking", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("crabclaw", 1)
	end
end)
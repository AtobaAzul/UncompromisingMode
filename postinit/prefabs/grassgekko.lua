
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("grassgekko", function(inst)

	if not TheWorld.ismastersim then
		return
	end

	inst.components.lootdropper:AddChanceLoot("dug_grass",1.00)
end)

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("monkey", function(inst)

	if not TheWorld.ismastersim then
		return
	end

	if not TheWorld:HasTag("cave") then
		inst.persists = false
	end
end)

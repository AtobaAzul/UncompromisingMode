local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("pumpkin_lantern", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY

end)

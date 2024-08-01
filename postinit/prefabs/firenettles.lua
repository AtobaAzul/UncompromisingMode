local env = env
GLOBAL.setfenv(1, GLOBAL)


-- Fire Nettle Fronds item.
env.AddPrefabPostInit("firenettles", function(inst)	
	if not TheWorld.ismastersim then
		return
	end
	
--	inst:RemoveComponent("propagator")
	inst:RemoveComponent("burnable")
	
	inst:AddComponent("burnable")
	inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 0))
	inst.components.burnable:SetFXLevel(1)
	inst.components.burnable:SetBurnTime(3)
	inst.components.burnable:SetOnBurntFn(nil)
	
    inst.components.edible.healthvalue = -15 -- Increased health loss on-eat due to increased item availability.
end)





-- https://i.postimg.cc/bNfXKh0d/FRONDS.jpg

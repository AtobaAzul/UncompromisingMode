	AddPrefabPostInit("coontail", function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 9
        inst.components.edible.hungervalue = 9
        inst.components.edible.sanityvalue = 7      
        inst.components.edible.foodtype = GLOBAL.FOODTYPE.HORRIBLE

	end)

	AddPrefabPostInit("honeycomb", function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 10
        inst.components.edible.hungervalue = 10
        inst.components.edible.sanityvalue = 0      
        inst.components.edible.foodtype = GLOBAL.FOODTYPE.HORRIBLE

	end)
	
	AddPrefabPostInit("shroom_skin", function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 10
        inst.components.edible.hungervalue = 10
        inst.components.edible.sanityvalue = 0      
        inst.components.edible.foodtype = GLOBAL.FOODTYPE.HORRIBLE

	end)	

	AddPrefabPostInit("tentaclespots", function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 10
        inst.components.edible.hungervalue = 10
        inst.components.edible.sanityvalue = 0      
        inst.components.edible.foodtype = GLOBAL.FOODTYPE.HORRIBLE

	end)
	
	AddPrefabPostInit("waterplant_bomb", function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = -2.5
        inst.components.edible.hungervalue = 5
        inst.components.edible.sanityvalue = 0      
        inst.components.edible.foodtype = GLOBAL.FOODTYPE.HORRIBLE

	end)

	AddPrefabPostInit("glommerwings", function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 10
        inst.components.edible.hungervalue = 10
        inst.components.edible.sanityvalue = 0      
        inst.components.edible.foodtype = GLOBAL.FOODTYPE.HORRIBLE

	end)

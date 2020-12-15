local assets =
{
    Asset("ANIM", "anim/glommer_fuel.zip"),
	Asset("SCRIPT", "scripts/prefabs/fertilizer_nutrient_defs.lua"),
}

local prefabs =
{
    "gridplacer_farmablesoil",
}

local function GetFertilizerKey(inst)
    return inst.prefab
end

local function fertilizerresearchfn(inst)
    return inst:GetFertilizerKey()
end

local function MakeVomit(name, color, x, y, z)
		
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("glommer_fuel")
		inst.AnimState:SetBuild("glommer_fuel")
		inst.AnimState:PlayAnimation("idle")
		
		inst.AnimState:SetMultColour(x, y, z, 1)

		MakeInventoryFloatable(inst)
		MakeDeployableFertilizerPristine(inst)

		--inst:AddTag("fertilizerresearchable")

		--inst.GetFertilizerKey = GetFertilizerKey

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst:AddComponent("stackable")

		--inst:AddComponent("fertilizerresearchable")
		--inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.MED_FUEL
		
		inst:AddComponent("perishable")
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "ash"
		inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY)

		MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
		MakeSmallPropagator(inst)

		inst:AddComponent("fertilizer")
		inst.components.fertilizer.fertilizervalue = TUNING.GLOMMERFUEL_FERTILIZE
		inst.components.fertilizer.soil_cycles = TUNING.GLOMMERFUEL_SOILCYCLES
		inst.components.fertilizer:SetNutrients({x, y, z})

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = x
		inst.components.edible.hungervalue = y
		inst.components.edible.sanityvalue = z


		MakeDeployableFertilizer(inst)
		MakeHauntableLaunch(inst)
		
		return inst
	end

    return Prefab(name, fn, assets, prefabs)
end

return MakeVomit("purple_vomit", "purple", 2, 2, 0),
		MakeVomit("orange_vomit", "orange", 0, 2, 2),
		MakeVomit("yellow_vomit", "yellow", 2, 0, 2),
		MakeVomit("red_vomit", "red", 0, 6, 0),
		MakeVomit("green_vomit", "green", 0, 0, 6),
		MakeVomit("pink_vomit", "pink", 6, 0, 0),
		MakeVomit("pale_vomit", "pale", 1, 1, 1)
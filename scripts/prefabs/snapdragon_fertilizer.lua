local assets =
{
    Asset("ANIM", "anim/glommer_fuel.zip"),
}

local prefabs =
{
    "gridplacer_farmablesoil",
}



local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local function GetFertilizerKey(inst)
	return inst.prefab
end

local function fertilizerresearchfn(inst)
	return inst:GetFertilizerKey()
end

local function MakeVomit(name, color)

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("snapdragon_fertilizer")
		inst.AnimState:SetBuild("snapdragon_fertilizer")
		inst.AnimState:PlayAnimation("idle_"..color)

		MakeInventoryFloatable(inst)
		MakeDeployableFertilizerPristine(inst)

		inst:AddTag("fertilizerresearchable")
		inst.GetFertilizerKey = GetFertilizerKey

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..color.."_vomit.xml"
		
		inst:AddComponent("stackable")

		inst:AddComponent("fertilizerresearchable")
		inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

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
		inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS[name].nutrients)
		--inst.components.fertilizer:SetNutrients({x, y, z})

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = -(FERTILIZER_DEFS[name].nutrients[1] / 4)
		inst.components.edible.hungervalue = -(FERTILIZER_DEFS[name].nutrients[2] / 4)
		inst.components.edible.sanityvalue = -(FERTILIZER_DEFS[name].nutrients[3] / 4)


		MakeDeployableFertilizer(inst)
		MakeHauntableLaunch(inst)

		return inst
	end

    return Prefab(name, fn, assets, prefabs)
end

return MakeVomit("purple_vomit", "purple"),
		MakeVomit("orange_vomit", "orange"),
		MakeVomit("yellow_vomit", "yellow"),
		MakeVomit("red_vomit", "red"),
		MakeVomit("green_vomit", "green"),
		MakeVomit("pink_vomit", "pink"),
		MakeVomit("pale_vomit", "pale")
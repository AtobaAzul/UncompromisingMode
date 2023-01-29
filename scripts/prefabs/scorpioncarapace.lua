require "tuning"



    local assets =
    {
        --Asset("ANIM", "anim/scorpioncarapace.zip"),
		Asset("ATLAS", "images/inventoryimages/scorpioncarapace.xml"),
    }

    local assets_cooked =
    {
        --Asset("ANIM", "anim/scorpioncarapacecooked.zip"),
		Asset("ATLAS", "images/inventoryimages/scorpioncarapacecooked.xml"),
    }
    
    local prefabs =
    {
        "spoiled_food",
    }

local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("scorpioncarapace")
        inst.AnimState:SetBuild("scorpioncarapace")
        inst.AnimState:PlayAnimation("idle")
		MakeInventoryFloatable(inst, "med", 0.05, 0.68)
        --cookable (from cookable component) added to pristine state for optimization
		inst:AddTag("cookable")
		inst:AddTag("monstermeat")
		inst:AddTag("meat")
		inst.Transform:SetScale(0.75, 0.75, 0.75)
        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end
		

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = -20
        inst.components.edible.hungervalue = 18.8
        inst.components.edible.sanityvalue = -20
        inst.components.edible.foodtype = FOODTYPE.MEAT
		inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
        inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime((3*TUNING.PERISH_TWO_DAY))
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
		
		
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/scorpioncarapace.xml"
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    ---------------------        

    inst:AddComponent("bait")

    ------------------------------------------------
    inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 0
    ------------------------------------------------  

    inst:AddComponent("cookable")
    inst.components.cookable.product = "scorpioncarapacecooked"
	
	--[[inst:AddComponent("dryable")     Removed till animations can work.
    inst.components.dryable:SetBuildFile("scorpioncarapace_dried")  --More like drying to be honest. It produces regular monster jerky.
    inst.components.dryable:SetDriedBuildFile("idle_dried_monster")
    inst.components.dryable:SetProduct("monstermeat_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

    MakeHauntableLaunchAndPerish(inst)
	]]
    return inst
end

    local function fn_cooked()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("scorpioncarapace")
        inst.AnimState:SetBuild("scorpioncarapace")
        inst.AnimState:PlayAnimation("cooked")
		inst.Transform:SetScale(0.75, 0.75, 0.75)		
		inst:AddTag("monstermeat")
		inst:AddTag("meat")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		

        inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime((4*TUNING.PERISH_TWO_DAY))
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = -10
        inst.components.edible.hungervalue = 18.8
        inst.components.edible.sanityvalue = -10
        inst.components.edible.foodtype = FOODTYPE.MEAT
		inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
		
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/scorpioncarapacecooked.xml"
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        ---------------------        

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")

		inst.components.tradable.goldvalue = 0
        MakeHauntableLaunchAndPerish(inst)

        return inst
    end
return  Prefab("scorpioncarapace", fn, assets, prefabs),
		Prefab("scorpioncarapacecooked", fn_cooked, assets_cooked)

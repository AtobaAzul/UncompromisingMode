require "tuning"



    local assets =
    {
        Asset("ANIM", "anim/rice.zip"),
		Asset("ATLAS", "images/inventoryimages/rice.xml"),
    }

    local assets_cooked =
    {
        Asset("ANIM", "anim/berries.zip"),
		--Asset("ATLAS", "images/inventoryimages/berries_cooked.xml"),
    }
    
    local prefabs =
    {
        "rice_cooked",
        "spoiled_food",
    }
    

local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("rice")
        inst.AnimState:SetBuild("rice")
        inst.AnimState:PlayAnimation("idle")
		MakeInventoryFloatable(inst, "med", 0.05, 0.68)
        --cookable (from cookable component) added to pristine state for optimization
		inst:AddTag("cookable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 0
        inst.components.edible.hungervalue = 9.8
        inst.components.edible.sanityvalue = 0      
        inst.components.edible.foodtype = FOODTYPE.VEGGIE

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rice.xml"
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    ---------------------        

    inst:AddComponent("bait")

    ------------------------------------------------
    inst:AddComponent("tradable")

    ------------------------------------------------  

    inst:AddComponent("cookable")
    inst.components.cookable.product = "rice_cooked"

        

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

    local function fn_cooked()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("berries")
        inst.AnimState:SetBuild("berries")
        inst.AnimState:PlayAnimation("cooked")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 1
        inst.components.edible.hungervalue = 12.5
        inst.components.edible.sanityvalue = 0
        inst.components.edible.foodtype = FOODTYPE.VEGGIE

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = nil--"images/inventoryimages/berries_cooked.xml"
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
        ---------------------        

        inst:AddComponent("bait")

        ------------------------------------------------
        inst:AddComponent("tradable")


        MakeHauntableLaunchAndPerish(inst)

        return inst
    end
return  Prefab("rice", fn, assets, prefabs),
		Prefab("rice_cooked", fn_cooked, assets_cooked)

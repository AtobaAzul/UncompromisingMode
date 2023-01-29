local assets =
{
    Asset("ANIM", "anim/extra_monsterfoods.zip"),
    Asset("ANIM", "anim/extra_monsterfoods_dried.zip"),
    Asset("ATLAS", "images/inventoryimages/monstersmallmeat.xml"),
    Asset("ATLAS", "images/inventoryimages/cookedmonstersmallmeat.xml"),
    Asset("ATLAS", "images/inventoryimages/monstersmallmeat_dried.xml"),
}

local monster_prefabs =
{
    "cookedmonstersmallmeat",
    "monstersmallmeat_dried",
    "spoiled_food",
}

local function OnSpawnedFromHaunt(inst, data)
    Launch(inst, data.haunter, TUNING.LAUNCH_SPEED_SMALL)
end

local function common_meat(anim, tags, dryable, cookable)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("extra_monsterfoods")
    inst.AnimState:SetBuild("extra_monsterfoods")
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("meat")
    if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

    if dryable ~= nil then
        --dryable (from dryable component) added to pristine state for optimization
        inst:AddTag("dryable")
        inst:AddTag("lureplant_bait")
    end

    if cookable ~= nil then
        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")
    end

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    
    inst:AddComponent("stackable")

    inst:AddComponent("tradable")

    inst:AddComponent("perishable")
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    if dryable ~= nil and dryable.product ~= nil then
        inst:AddComponent("dryable")
        inst.components.dryable:SetProduct(dryable.product)
        inst.components.dryable:SetDryTime(dryable.time)
    end

    if cookable ~= nil then
        inst:AddComponent("cookable")
        inst.components.cookable.product = cookable.product
    end

    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end

local function monstersmallmeat_fn()
    local inst = common_meat("idle", { "monstermeat" }, { product = "monstersmallmeat_dried", time = TUNING.DRY_VERYFAST }, { product = "cookedmonstersmallmeat" })
        
    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
    inst.components.edible.healthvalue = -15 -- -15 health
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY -- 9.375 hunger
    inst.components.edible.sanityvalue = -10 -- -15 sanity
    
    inst.components.inventoryitem.atlasname = "images/inventoryimages/monstersmallmeat.xml"
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST) -- 2 days
    
    if inst.components.dryable then
        inst.components.dryable:SetBuildFile("extra_monsterfoods_dried")
        inst.components.dryable:SetDriedBuildFile("extra_monsterfoods_dried")
    end
    
    inst.components.tradable.goldvalue = 0

    inst.components.floater:SetVerticalOffset(0.05)

    inst:AddComponent("selfstacker")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM 

    return inst
end

local function cookedmonstersmallmeat_fn()
    local inst = common_meat("cooked", { "monstermeat" })

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
    inst.components.edible.healthvalue = -5 -- -10 health
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY -- 9.375 hunger
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL -- -10 sanity
    
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW) -- 3 days

    inst.components.tradable.goldvalue = 0
    
    inst.components.floater:SetVerticalOffset(0.05)

    inst.components.inventoryitem.atlasname = "images/inventoryimages/cookedmonstersmallmeat.xml"
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM 

    return inst
end

local function monstersmallmeat_dried_fn()
	local inst = common_meat("dried", { "monstermeat" }, { isdried = true })

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
    inst.components.edible.healthvalue = -5 -- -5 health
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY -- 9.375 hunger
    inst.components.edible.sanityvalue = -TUNING.SANITY_TINY -- -5 sanity

    inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)

	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM 

    inst.components.inventoryitem.atlasname = "images/inventoryimages/monstersmallmeat_dried.xml"
    
    return inst
end

local function commonfn(anim, cookable)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("extra_monsterfoods")
    inst.AnimState:SetBuild("extra_monsterfoods")
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("catfood")
    inst:AddTag("monstermeat")

    if cookable then
        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")
    end

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER

    if cookable then
        inst:AddComponent("cookable")
        inst.components.cookable.product = "um_monsteregg_cooked"
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "rottenegg"

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("tradable")

    return inst
end

local function defaultfn()
    local inst = commonfn("egg", true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.inventoryitem.atlasname = "images/inventoryimages/um_monsteregg.xml"

    inst.components.edible.healthvalue = -15 -- -15 health
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY -- 9.375 hunger
    inst.components.edible.sanityvalue = -10 -- -15 sanity
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)

	inst.components.tradable.rocktribute = 1

    inst.components.floater:SetScale({0.55, 0.5, 0.55})
    inst.components.floater:SetVerticalOffset(0.05)
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM 

    return inst
end

local function cookedfn()
    local inst = commonfn("egg_cooked")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.inventoryitem.atlasname = "images/inventoryimages/um_monsteregg_cooked.xml"

    inst.components.edible.healthvalue = -5 -- -5 health
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY -- 9.375 hunger
    inst.components.edible.sanityvalue = -TUNING.SANITY_TINY -- -5 sanity
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst.components.floater:SetSize("med")
    inst.components.floater:SetScale(0.65)
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM 

    return inst
end

return Prefab("monstersmallmeat", monstersmallmeat_fn, assets, monster_prefabs),
        Prefab("cookedmonstersmallmeat", cookedmonstersmallmeat_fn, assets),
        Prefab("monstersmallmeat_dried", monstersmallmeat_dried_fn, assets),
        Prefab("um_monsteregg", defaultfn, assets),
        Prefab("um_monsteregg_cooked", cookedfn, assets)
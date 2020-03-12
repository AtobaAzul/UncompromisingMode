local assets =
{
    Asset("ANIM", "anim/meat.zip"),
}

local function OnSpawnedFromHaunt(inst, data)
    Launch(inst, data.haunter, TUNING.LAUNCH_SPEED_SMALL)
end

local function common(bank, build, anim, tags, dryable, cookable)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("meat")
    if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
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
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    if cookable ~= nil then
        inst:AddComponent("cookable")
        inst.components.cookable.product = cookable.product
    end

    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end

local function fn()
    local inst = common("monstermeat", "monstermorsel", "idle", { "smallmonstermeat", "monstermeat" }, nil, { product = "cookedmonstermorsel" })

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.ismeat = true    
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = -TUNING.HEALING_MEDSMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL
    inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY)

    inst.components.tradable.goldvalue = 0
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/monstermorsel.xml"

    inst.components.floater:SetVerticalOffset(0.05)

    inst:AddComponent("selfstacker")

    return inst
end
--[[
local function dried()
    local inst = common("meat_rack_food", "meat_rack_food", "idle_dried_monster", { "smallmonstermeat" }, { isdried = true })
    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = -TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL
    inst.components.edible.sanityvalue = -TUNING.SANITY_TINY

    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)

    return inst
end
--]]
local function cooked()
    local inst = common("monstermeat", "monstermorsel", "cooked", { "smallmonstermeat", "monstermeat" })

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = -TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY
    inst.components.edible.sanityvalue = -TUNING.SANITY_TINY

    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)

    inst.components.tradable.goldvalue = 0
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cookedmonstermorsel.xml"
	
    inst.components.floater:SetVerticalOffset(0.05)

    return inst
end


--[[
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("meat_small")
    inst.AnimState:SetBuild("meat_small")
    inst.AnimState:PlayAnimation("raw")
	
    inst:AddTag("meat")
    inst:AddTag("monstermeat")

    inst:AddTag("dryable")
    inst:AddTag("lureplant_bait")

    inst:AddTag("cookable")

	MakeInventoryFloatable(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("edible")
    inst.components.edible.ismeat = true    
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = -TUNING.HEALING_MED
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = -TUNING.SANITY_MED
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
	inst:AddComponent("bait")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")

    inst:AddComponent("tradable")

    inst.components.tradable.goldvalue = 0
	
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("dryable")
    inst.components.dryable:SetProduct(dryable.product)
    inst.components.dryable:SetDryTime(dryable.time)
	inst.components.dryable:SetBuildFile(dryable.build)
    inst.components.dryable:SetDriedBuildFile(dryable.dried_build)
	
	inst:AddComponent("cookable")
    inst.components.cookable.product = cookable.product

    inst.components.floater:SetVerticalOffset(0.05)

    inst:AddComponent("selfstacker")
	
	MakeHauntableLaunchAndPerish(inst)

    return inst
end
--]]

return Prefab("monstermorsel", fn, assets),
		Prefab("cookedmonstermorsel", cooked, assets)--,
		--Prefab("smallmonstermeat_dried", dried, assets)
local assets =
{
    Asset("ANIM", "anim/ocupus_items.zip"),
}


local prefabs =
{
    "ocupus_tentacle",
    "ocupus_tentacle_eye",
    "ocupus_tentacle_cooked",
    "ocupus_beak",
}


local function common(bank, build, anim, tags, cookable)
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
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST*1.5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_fish"

    if cookable ~= nil then
        inst:AddComponent("cookable")
        inst.components.cookable.product = cookable.product
    end

    return inst
end

local function ocupus_tentacle()
    local inst = common("ocupus_items", "ocupus_items", "idle_tentacle", { "catfood", "rawmeat" }, { product = "ocupus_tentacle_cooked" })
    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = -20
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = -15
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST*1.5)

    inst.components.tradable.goldvalue = 1

	inst.components.inventoryitem.atlasname = "images/inventoryimages/ocupus_tentacle.xml"


    return inst
end

local function ocupus_tentacle_eye()
    local inst = common("ocupus_items", "ocupus_items", "idle_eye", { "catfood", "rawmeat" }, { product = "ocupus_tentacle_cooked" })
    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = 20
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = -33
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST*1.5)

    inst.components.tradable.goldvalue = 1

	inst.components.inventoryitem.atlasname = "images/inventoryimages/ocupus_tentacle_eye.xml"

    return inst
end

local function ocupus_tentacle_cooked()
    local inst = common("ocupus_items", "ocupus_items", "idle_cooked", { "catfood", "rawmeat" }, { product = "ocupus_tentacle_cooked" })

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = -3
    inst.components.edible.hungervalue = 37.5
    inst.components.edible.sanityvalue = -10
    inst.components.perishable:SetPerishTime(3*TUNING.PERISH_FAST)

    inst.components.tradable.goldvalue = 1

    inst.components.inventoryitem.atlasname = "images/inventoryimages/ocupus_tentacle_cooked.xml"
    return inst
end

local function ocupus_beak()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ocupus_items")
    inst.AnimState:SetBuild("ocupus_items")
    inst.AnimState:PlayAnimation("idle_beak")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ocupus_beak.xml"

    inst:AddComponent("stackable")

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT

    return inst
end

return Prefab("ocupus_tentacle", ocupus_tentacle, assets), Prefab("ocupus_tentacle_eye", ocupus_tentacle_eye, assets),
    Prefab("ocupus_tentacle_cooked", ocupus_tentacle_cooked, assets), Prefab("ocupus_beak", ocupus_beak, assets)

    
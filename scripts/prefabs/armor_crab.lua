local assets =
{
    Asset("ANIM", "anim/armor_reed_um.zip"),
}

local function OnBlocked(owner)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_reed_um", "swap_body")

    inst:ListenForEvent("blocked", OnBlocked, owner)

    if inst.prefab == "armor_crab_maxhp" then
        owner:DoTaskInTime(0, function()
            if owner.components.health ~= nil then
                local current_health_percent = owner.components.health:GetPercent()

                owner.components.health.maxhealth = owner.components.health.maxhealth + 150

                owner.components.health:SetPercent(current_health_percent)

                -- We want to force a badge pulse, but also maintain the health percent as much as we can.
                local badgedelta = 0.01
                owner.components.health:DoDelta(badgedelta, false, nil, true)
            end
        end)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    if inst.prefab == "armor_crab_maxhp" then
        owner:DoTaskInTime(0, function()
            local current_health_percent = owner.components.health:GetPercent()

            owner.components.health.maxhealth = owner.components.health.maxhealth - 150

            owner.components.health:SetPercent(current_health_percent)

            -- We want to force a badge pulse, but also maintain the health percent as much as we can.
            local badgedelta = -0.01
            owner.components.health:DoDelta(badgedelta, false, nil, true)
        end)
    end

end

local function common_fn(type)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_reed_um")
    inst.AnimState:SetBuild("armor_reed_um")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("grass")

    inst.foleysound = "dontstarve/movement/foley/shellarmour"

    local swap_data = { bank = "armor_grass", anim = "anim" }
    MakeInventoryFloatable(inst, "small", 0.2, 0.80, nil, nil, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_reed_um.xml"

    inst:AddComponent("armor")
    local absorption = type == "armor_crab_regen" and 0.2 or 0
    inst.components.armor:InitCondition(TUNING.DSTU.ARMORREED_UM * 2, TUNING.ARMORGRASS_ABSORPTION + absorption)

    if type == "armor_crab_regen" then
        inst:DoPeriodicTask(1, function()
            inst.components.armor:SetPercent(inst.components.armor:GetPercent()+0.005)
        end)
    end

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALLMED)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function fn_regen()
    return common_fn("armor_crab_regen")
end

local function fn_maxhp()
    return common_fn("armor_crab_maxhp")
end


return Prefab("armor_crab_regen", fn_regen, assets), Prefab("armor_crab_maxhp", fn_maxhp, assets)

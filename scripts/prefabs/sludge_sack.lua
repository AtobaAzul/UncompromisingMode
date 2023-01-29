local assets =
{
    Asset("ANIM", "anim/piggyback.zip"),
    Asset("ANIM", "anim/swap_sludge_sack.zip"),
    Asset("ANIM", "anim/ui_piggyback_2x6.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_sludge_sack", "swap_body")
    inst.components.container:Open(owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.container:Close(owner)
end
local function ItemGained(inst, data)
    if data ~= nil and data.item ~= nil then
        data.item:AddTag("nosteal")
        if data.item.components.inventoryitemmoisture ~= nil then
            data.item.wet_task = data.item:DoPeriodicTask(10, function(inst)
                inst.components.inventoryitemmoisture:SetMoisture(TUNING.MOISTURE_WET_THRESHOLD+40)
            end)
        end
    end
end

local function ItemLost(inst, data)
    if data ~= nil and data.prev_item ~= nil then
        data.prev_item:RemoveTag("nosteal")
        if data.prev_item.wet_task ~= nil then
            data.prev_item.wet_task:Cancel()
        end
        if data.prev_item.components.inventoryitemmoisture ~= nil then
            data.prev_item.components.inventoryitemmoisture:SetMoisture(TUNING.MOISTURE_WET_THRESHOLD+40)
        end
        data.prev_item.wet_task = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_sludge_sack")
    inst.AnimState:SetBuild("swap_sludge_sack")
    inst.AnimState:PlayAnimation("anim")

    inst.MiniMapEntity:SetIcon("piggyback.png")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst:AddTag("backpack")
    inst:AddTag("outofreach")--I sure do hope this doesn't cause any issues!
    inst:AddTag("wet")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    --inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst, "small", 0.1, 0.85)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sludge_sack.xml"
    inst.components.inventoryitem.cangoincontainer = false
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    --inst.components.equippable.dapperness = TUNING.MOISTURE_SANITY_PENALTY_MAX
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    --inst:AddComponent("waterproofer")
    --inst.components.waterproofer:SetEffectiveness(0)

    if inst.components.inventoryitemmoisture ~= nil then
        inst.components.inventoryitemmoisture:SetMoisture(TUNING.MOISTURE_WET_THRESHOLD+10)
    end

    inst:DoPeriodicTask(10, function(inst)
        if inst.components.inventoryitemmoisture ~= nil then
            inst.components.inventoryitemmoisture:SetMoisture(TUNING.MOISTURE_WET_THRESHOLD+10)
        end
    end)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("sludge_sack")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst:ListenForEvent("itemlose", ItemLost)
    inst:ListenForEvent("itemget", ItemGained)

    return inst
end

return Prefab("sludge_sack", fn, assets)
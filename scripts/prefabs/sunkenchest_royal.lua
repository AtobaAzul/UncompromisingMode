require "prefabutil"

local SUNKEN_PHYSICS_RADIUS = .45

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local function MakeChest(name, bank, build, indestructible, master_postinit, prefabs, assets, common_postinit,
                         force_non_burnable)
    local default_assets =
    {
        Asset("ANIM", "anim/" .. build .. ".zip"),
        Asset("ANIM", "anim/ui_chest_3x2.zip"),
    }
    assets = assets ~= nil and JoinArrays(assets, default_assets) or default_assets

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon(name .. ".png")

        inst:AddTag("structure")
        inst:AddTag("chest")

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("closed")

        MakeSnowCoveredPristine(inst)

        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
    
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        if not indestructible then
            inst:AddComponent("lootdropper")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(2)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)

            if not force_non_burnable then
                MakeSmallBurnable(inst, nil, nil, true)
                MakeMediumPropagator(inst)
            end
        end

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)

        -- Save / load is extended by some prefab variants
        inst.OnSave = onsave
        inst.OnLoad = onload

        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

--------------------------------------------------------------------------
--[[ sunken ]]
--------------------------------------------------------------------------

local function sunken_onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        if inst.components.container ~= nil then
            inst.components.container:Close()
        end
    end
end

local function sunken_OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function sunken_OnEquip(inst, owner)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
    owner.AnimState:OverrideSymbol("swap_body", "swap_sunken_treasurechest", "swap_body")
end

local function sunken_OnSubmerge(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
    inst:AddTag("saltbox")
end

local function sunken_OnLanded(inst)
    inst:RemoveTag("saltbox")
end

local function sunken_GetStatus(inst)
    return (inst.components.container ~= nil and not inst.components.container.canbeopened) and "LOCKED" or nil
end

local function sunken_common_postinit(inst)
    inst:AddTag("heavy")

    MakeHeavyObstaclePhysics(inst, 0)
    inst:SetPhysicsRadiusOverride(0)
end

local function sunken_master_postinit(inst)
    inst.components.workable:SetOnWorkCallback(sunken_onhit)

    inst.components.inspectable.getstatus = sunken_GetStatus

    inst:AddComponent("heavyobstaclephysics")
    inst.components.heavyobstaclephysics:SetRadius(0)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(sunken_OnEquip)
    inst.components.equippable:SetOnUnequip(sunken_OnUnequip)
    inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

    inst.components.container.canbeopened = true
    --need new anims/assets for it.

    inst:AddComponent("submersible")
    inst:AddComponent("symbolswapdata")
    inst.components.symbolswapdata:SetData("swap_sunken_treasurechest", "swap_body")

    inst:ListenForEvent("on_submerge", sunken_OnSubmerge)
    inst:ListenForEvent("on_landed", sunken_OnLanded)
end

return MakeChest("sunkenchest_royal_random", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true),
    MakeChest("sunkenchest_royal_red", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true),
    MakeChest("sunkenchest_royal_blue", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true),
    MakeChest("sunkenchest_royal_purple", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true),
    MakeChest("sunkenchest_royal_green", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true),
    MakeChest("sunkenchest_royal_orange", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true),
    MakeChest("sunkenchest_royal_yellow", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true),
    MakeChest("sunkenchest_royal_rainbow", "sunken_treasurechest", "sunken_royalchest", false, sunken_master_postinit,
        { "collapse_small", "underwater_salvageable", "splash_green" },
        { Asset("ANIM", "anim/swap_sunken_treasurechest.zip"), Asset("ANIM", "anim/sunken_royalchest.zip") },
        sunken_common_postinit, true)

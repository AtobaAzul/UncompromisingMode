require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/boat_cannon.zip"),
}

local prefabs =
{
    "cannonball_rock",
    "collapse_small",
    "cannon_aoe_range_fx",
    "cannon_reticule_fx",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")

    inst:Remove()
end

local function onbuilt(inst, data)
    local pt = data.pos

    if pt == nil then
        return
    end

    local fx = SpawnPrefab("moon_beacon_fx")
    fx.Transform:SetPosition(pt:Get())
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.25)

    inst.AnimState:SetBank("boat_cannon")
    inst.AnimState:SetBuild("boat_cannon")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:HideSymbol("cannon_flap_down")

    inst.entity:SetPristine()

    inst:AddTag("moon_beacon")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("onbuilt", onbuilt)

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    --inst.components.workable:SetWorkAction(ACTIONS.HAMMER) nuh uh
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("timer")

    MakeHauntableWork(inst)

    return inst
end

local function OnAnimOver(inst)
    inst.AnimState:PushAnimation("meteorground_pre")
    inst.AnimState:PushAnimation("meteorground_loop", true)

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.Transform:SetScale(1, 1, 1)
    inst.AnimState:SetMultColour(1, 1, 1, 0.5)
    inst.AnimState:SetSortOrder(2)

    inst:RemoveEventCallback("animover", OnAnimOver)
end

local function fn_fx()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("alterguardian_meteor")
    inst.AnimState:SetBuild("alterguardian_meteor")
    inst:DoTaskInTime(3, function()
        inst.AnimState:PlayAnimation("meteor_pre")
        inst.AnimState:HideSymbol("charged_moonglass_rock")
    end)
    --inst.AnimState:HideSymbol("fx_crown_break")

    inst.AnimState:SetLightOverride(1)
    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", OnAnimOver)

    inst:DoTaskInTime(FRAMES * 120, function(inst)
        local scorch = SpawnPrefab("alterguardian_laserscorch")
        local x, y, z = inst.Transform:GetWorldPosition()
        scorch.Transform:SetPosition(x, 0, z)
        scorch.Transform:SetScale(1.5, 1.5, 1.5)
        scorch.AnimState:SetMultColour(1, 1, 1, 0.5)

        local ent = FindEntity(inst, 1, nil, { "moon_beacon" })
        ent.components.workable:Destroy(inst)

        inst.count = 0
        inst:DoPeriodicTask(3, function()
            inst.count = inst.count + 1

            if inst.count > 3 then
                inst:Remove()
            end

            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 8, nil,
                { "FX", --[["INLIMBO",]] "CLASSIFIED", "DECOR", "NOCLICK", "NOBLOCK" })
                        --Excluded INLIMBO so items in inventories work.
            for k, v in ipairs(ents) do
                if v.components ~= nil and v.components.finiteuses ~= nil and v.components.finiteuses:GetPercent() < 1 then
                    v.components.finiteuses:SetPercent(1)
                end
                if v.components ~= nil and v.components.fueled ~= nil and v.components.fueled:GetPercent() < 1 then
                    v.components.fueled:SetPercent(1)
                end
                if v.components ~= nil and v.components.armor ~= nil and v.components.armor:GetPercent() < 1 then
                    v.components.armor:SetPercent(1)
                end
            end
        end)
    end)

    return inst
end

return Prefab("moon_beacon", fn, assets, prefabs), Prefab("moon_beacon_fx", fn_fx),
    MakeDeployableKitItem("moon_beacon_kit", "moon_beacon", "boat_cannon", "boat_cannon", "kit", assets, nil,
        { "moon_beacon" }, { fuelvalue = TUNING.LARGE_FUEL }, { deployspacing = DEPLOYSPACING.LESS }),
    MakePlacer("moon_beacon_placer", "boat_cannon", "boat_cannon", "idle", false, false, false, nil, 0, "eight")

--Steering wheel but steers the boat if there's a rudder!

local assets = {Asset("ANIM", "anim/boat_wheel.zip")}

local item_assets = {
    Asset("ANIM", "anim/seafarer_wheel.zip"),
    Asset("INV_IMAGE", "steeringwheel_item")
}

local prefabs = {
    "collapse_small", "steeringwheel_copper_item" -- deprecated but kept for existing worlds and mods
}

local function on_start_steering(inst, sailor)
    inst.AnimState:HideSymbol("boat_wheel_round")
    inst.AnimState:HideSymbol("boat_wheel_stick")

    sailor.AnimState:AddOverrideBuild("player_boat")

    local boat = inst:GetCurrentPlatform()

    if boat ~= nil then
        local x, y, z = boat.Transform:GetWorldPosition()
        local rudder = TheSim:FindEntities(x, y, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS, {"boatrotator"}, {"burnt", "INLIMBO", "_inventoryitem"})
        for k, v in ipairs(rudder) do
            if k > 0 then
                if boat.components.boatphysics ~= nil then
                    boat.components.boatphysics:SetCanSteeringRotate(true)
                    v:RemoveComponent("boatrotator") -- so you can't interact
                end
            end
        end
    end
end

local function on_stop_steering(inst, sailor)
    inst.AnimState:ShowSymbol("boat_wheel_round")
    inst.AnimState:ShowSymbol("boat_wheel_stick")

    if sailor ~= nil then
        sailor.AnimState:ClearOverrideSymbol("boat_wheel_round")
        sailor.AnimState:ClearOverrideSymbol("boat_wheel_stick")
    end

    local boat = inst:GetCurrentPlatform()

    if boat ~= nil then
        local x, y, z = boat.Transform:GetWorldPosition()
        local rudder = TheSim:FindEntities(x, y, z, TUNING.MAX_WALKABLE_PLATFORM_RADIUS, {"boatrotator"}, {"burnt", "INLIMBO", "_inventoryitem"})
        boat.components.boatphysics:SetCanSteeringRotate(false)
        if rudder ~= nil then
            for k, v in ipairs(rudder) do
                v:AddComponent("boatrotator")
            end
        end
    end
end

local function on_hammered(inst, hammerer)
    inst.components.lootdropper:DropLoot()

    local collapse_fx = SpawnPrefab("collapse_small")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    collapse_fx:SetMaterial("metal")

    if inst.components.steeringwheel ~= nil and
        inst.components.steeringwheel.sailor ~= nil then
        inst.components.steeringwheel:StopSteering()
    end

    inst:Remove()
end

local function onignite(inst)
    DefaultBurnFn(inst)

    if inst.components.steeringwheel.sailor ~= nil then
        local sailor = inst.components.steeringwheel.sailor
        inst.components.steeringwheel:StopSteering()

        sailor.components.steeringwheeluser:SetSteeringWheel(nil)
        sailor:PushEvent("stop_steering_boat")
    end
end

local function onburnt(inst)
    DefaultBurntStructureFn(inst)

    inst:RemoveComponent("steeringwheel")
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound(
        "turnoftides/common/together/boat/steering_wheel/place")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt == true then
        inst.components.burnable.onburnt(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("boat_wheel")
    inst.AnimState:SetBuild("boat_wheel")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetMultColour(1, 1, 0.5, 1)
    inst:AddTag("structure")

    inst:SetPhysicsRadiusOverride(0.25)

    inst.entity:SetPristine()

    inst:AddTag("steeringwheel_copper")

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("steeringwheel")
    inst.components.steeringwheel:SetOnStartSteeringFn(on_start_steering)
    inst.components.steeringwheel:SetOnStopSteeringFn(on_stop_steering)

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(on_hammered)

    MakeSmallBurnable(inst, nil, nil, true)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnBurntFn(onburnt)

    MakeSmallPropagator(inst)

    MakeHauntableWork(inst)

    inst:ListenForEvent("onbuilt", onbuilt)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("steeringwheel_copper", fn, assets, prefabs),
       MakeDeployableKitItem("steeringwheel_copper_item", "steeringwheel_copper", "seafarer_wheel", "seafarer_wheel", "idle", item_assets, {size = "med", scale = 0.77}, {"boat_accessory"}, {fuelvalue = TUNING.LARGE_FUEL}),
       MakePlacer("steeringwheel_copper_item_placer", "boat_wheel", "boat_wheel", "idle")

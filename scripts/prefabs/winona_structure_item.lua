require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/portable_blender.zip"),
    Asset("ANIM", "anim/winona_spotlight.zip"),
    Asset("ANIM", "anim/winona_spotlight_placement.zip"),
    Asset("ANIM", "anim/winona_catapult.zip"),
    Asset("ANIM", "anim/winona_catapult_placement.zip"),
    Asset("ANIM", "anim/winona_battery_low.zip"),
    Asset("ANIM", "anim/winona_battery_high.zip"),
    Asset("ANIM", "anim/winona_battery_placement.zip"),
    Asset("ANIM", "anim/gems.zip"),


}

local prefabs =
{
    "collapse_small",
    "ash",
    "portableblender_item",
}

local prefabs_item =
{
    "portableblender",
}

local function ondeploy_catapult(inst, pt, deployer)
    local catapult = SpawnPrefab("winona_catapult")
    if catapult ~= nil then
        catapult.Physics:SetCollides(false)
        catapult.Physics:Teleport(pt.x, 0, pt.z)
        catapult.Physics:SetCollides(true)
        catapult.sg:GoToState("place")
        catapult.components.health:SetPercent(inst.components.finiteuses:GetPercent())
        inst:Remove()
    end
end

local function ondeploy_spotlight(inst, pt, deployer)
    local spotlight = SpawnPrefab("winona_spotlight")
    if spotlight ~= nil then
        spotlight.Physics:SetCollides(false)
        spotlight.Physics:Teleport(pt.x, 0, pt.z)
        spotlight.Physics:SetCollides(true)
        spotlight:PushEvent("onbuilt")
        inst:Remove()
    end
end

local function ondeploy_low(inst, pt, deployer)
    local gen = SpawnPrefab("winona_battery_low")
    if gen ~= nil then
        gen.Physics:SetCollides(false)
        gen.Physics:Teleport(pt.x, 0, pt.z)
        gen.Physics:SetCollides(true)
        gen:PushEvent("onbuilt")
        gen.components.fueled:SetPercent(inst.components.finiteuses:GetPercent())
        inst:Remove()
    end
end


local function ondeploy_high(inst, pt, deployer)
    local gen = inst.generator ~= nil and SpawnSaveRecord(inst.generator) or SpawnPrefab("winona_battery_high")

    gen.Physics:SetCollides(false)
    gen.Physics:Teleport(pt.x, 0, pt.z)
    gen.Physics:SetCollides(true)
    gen:PushEvent("onbuilt")

    gen:DoTaskInTime(61 * FRAMES, function()--1 frame delay so the anim is finished visually.
        for k,v in ipairs(gen._gems) do
            gen.components.trader.onaccept(gen, deployer, v)
        end

        gen:RemoveTag("NOCLICK")--manually do it since the animation gets a buit interrupted.
        gen.components.trader:Enable()
        gen.components.fueled:SetPercent(inst.components.finiteuses:GetPercent())
    end)

    inst:Remove()
end

local function fn(ondeploy, finiteuses)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("portable_blender")
    inst.AnimState:SetBuild("portable_blender")
    inst.AnimState:PlayAnimation("idle_ground")

    inst:AddTag("portableitem")

    MakeInventoryFloatable(inst, nil, 0.05, 0.7)

    inst:AddTag("toolbox_item")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("deployable")
    inst.components.deployable.restrictedtag = "handyperson"
    inst.components.deployable.ondeploy = ondeploy

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    if finiteuses == nil then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(100)
        inst.components.finiteuses:SetUses(100)
    end

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

local function fn_catapult()
    return fn(ondeploy_catapult)
end

local function fn_spotlight()
    return fn(ondeploy_spotlight, false)
end

local function fn_low()
    return fn(ondeploy_low)
end

local function fn_high()
    local inst = fn(ondeploy_high)

    inst.OnSave = function(inst, data)
        if inst.generator ~= nil then
            data.generator = inst.generator
        end
    end

    inst.OnLoad = function(inst, data)
        if data ~= nil and data.generator ~= nil then
            inst.generator = data.generator
        end
    end

    return inst
end

local PLACER_SCALE = 1.5

local function CreatePlacerBatteryRing()
    local inst = CreateEntity()

    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("placer")

    inst.AnimState:SetBank("winona_battery_placement")
    inst.AnimState:SetBuild("winona_battery_placement")
    inst.AnimState:PlayAnimation("idle_small")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetScale(PLACER_SCALE, PLACER_SCALE)

    return inst
end

local function CreatePlacerCatapult()
    local inst = CreateEntity()

    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("placer")

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("winona_catapult")
    inst.AnimState:SetBuild("winona_catapult")
    inst.AnimState:PlayAnimation("idle_placer")
    inst.AnimState:SetLightOverride(1)

    return inst
end

local function CreatePlacerSpotlight()
    local inst = CreateEntity()

    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOCLICK")
    inst:AddTag("placer")

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("winona_spotlight")
    inst.AnimState:SetBuild("winona_spotlight")
    inst.AnimState:PlayAnimation("idle_placer")
    inst.AnimState:SetLightOverride(1)

    return inst
end

local function placer_catapult(inst)
    --Show the catapult placer on top of the catapult range ground placer
    --Also add the small battery range indicator

    local placer2 = CreatePlacerBatteryRing()
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)

    placer2 = CreatePlacerCatapult()
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)

    inst.AnimState:Hide("inner")
    inst.AnimState:SetScale(PLACER_SCALE, PLACER_SCALE)
end

local function placer_spotlight(inst)
    --Show the spotlight placer on top of the spotlight range ground placer
    --Also add the small battery range indicator

    local placer2 = CreatePlacerBatteryRing()
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)

    placer2 = CreatePlacerSpotlight()
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)

    inst.AnimState:SetScale(PLACER_SCALE, PLACER_SCALE)
end

local function placer_low(inst)
    --Show the battery placer on top of the battery range ground placer

    local placer2 = CreateEntity()

    --[[Non-networked entity]]
    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    placer2.AnimState:SetBank("winona_battery_low")
    placer2.AnimState:SetBuild("winona_battery_low")
    placer2.AnimState:PlayAnimation("idle_placer")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)

    inst.AnimState:SetScale(PLACER_SCALE, PLACER_SCALE)
end

local function placer_high(inst)
    --Show the battery placer on top of the battery range ground placer

    local placer2 = CreateEntity()

    --[[Non-networked entity]]
    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    placer2.AnimState:SetBank("winona_battery_high")
    placer2.AnimState:SetBuild("winona_battery_high")
    placer2.AnimState:PlayAnimation("idle_placer")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)

    inst.AnimState:SetScale(PLACER_SCALE, PLACER_SCALE)
end

return Prefab("winona_catapult_item", fn_catapult, assets, prefabs_item),
    MakePlacer("winona_catapult_item_placer", "winona_catapult_placement", "winona_catapult_placement", "idle", true, nil, nil, nil, nil, nil, placer_catapult),
    Prefab("winona_spotlight_item", fn_spotlight, assets, prefabs_item),
    MakePlacer("winona_spotlight_item_placer", "winona_spotlight_placement", "winona_spotlight_placement", "idle", true, nil, nil, nil, nil, nil, placer_spotlight),
    Prefab("winona_battery_low_item", fn_low, assets, prefabs_item),
    MakePlacer("winona_battery_low_item_placer", "winona_battery_placement", "winona_battery_placement", "idle", true, nil, nil, nil, nil, nil, placer_low),
    Prefab("winona_battery_high_item", fn_high, assets, prefabs_item),
    MakePlacer("winona_battery_high_item_placer", "winona_battery_placement", "winona_battery_placement", "idle", true, nil, nil, nil, nil, nil, placer_high)


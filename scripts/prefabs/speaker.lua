local assets =
{
    Asset("ANIM", "anim/speaker_test.zip"),
    Asset("MINIMAP_IMAGE", "seastack"),
}

local prefabs =
{
    "rock_break_fx",
    "waterplant_baby",
    "waterplant_destroy",
}

local function PlaySound(inst)
    if TheWorld.state.isnight then
        inst.SoundEmitter:PlaySound("UCSounds/speaker/canyouseethem?", "thedeepwatches")
    else
        inst.SoundEmitter:KillSound("thedeepwatches")
    end
end

local types =
{
    "siren_throne",
    "ocean_speaker",
    "siren_bird_nest"
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("seastack.png")

    inst:SetPhysicsRadiusOverride(2.35)

    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("seastack")
    inst:AddTag("siren_speaker_spawner")

    inst.AnimState:SetBank("speaker_test")
    inst.AnimState:SetBuild("speaker_test")
    inst.AnimState:PlayAnimation("sneaky_leaky_preview")

    MakeInventoryFloatable(inst, "med", 0.1, { 1.1, 0.9, 1.1 })
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random() * 5 * FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst:SetPrefabNameOverride("ocean_speaker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("sirenpoint")

    inst:AddComponent("inspectable")

    inst:WatchWorldState("isnight", PlaySound)

    return inst
end

local function PickSiren(inst)
    if TheWorld.siren_count == 1 then
        return "siren_throne"
    elseif TheWorld.siren_count == 2 then
        return "siren_bird_nest"
    else
        return "ocean_speaker"
    end
end

--I am incredibly lazy.
local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("seastack.png")

    inst:SetPhysicsRadiusOverride(2.35)

    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("seastack")

    --inst.AnimState:SetBank("speaker_test")
    --inst.AnimState:SetBuild("speaker_test")
    --inst.AnimState:PlayAnimation("sneaky_leaky_preview")

    MakeInventoryFloatable(inst, "med", 0.1, { 1.1, 0.9, 1.1 })
    inst.components.floater.bob_percent = 0
    local land_time = (POPULATING and math.random() * 5 * FRAMES) or 0


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --hopefully impossibly hard to get things to spawn at the same time.
    inst:DoTaskInTime(math.random(), function(inst)
        if TheWorld.siren_count == nil then
            TheWorld.siren_count = 0
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        local siren = SpawnPrefab(PickSiren() .. "_teaser")
        siren.Transform:SetPosition(x, y, z)
        TheWorld.siren_count = TheWorld.siren_count + 1
        inst:Remove()
    end)
    return inst
end




return Prefab("ocean_speaker", fn, assets, prefabs), -- This is the real one, other ones are temp placeholders.
    Prefab("ocean_speaker_teaser", fn, assets, prefabs),
    Prefab("siren_teaser_picker", fn1, assets, prefabs)

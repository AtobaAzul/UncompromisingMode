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

    inst.AnimState:SetBank("speaker_test")
    inst.AnimState:SetBuild("speaker_test")
    inst.AnimState:PlayAnimation("sneaky_leaky_preview")

    MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.9, 1.1})
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    return inst
end


return Prefab("speaker", fn, assets, prefabs)


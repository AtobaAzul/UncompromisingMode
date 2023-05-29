local assets =
{
    Asset("ANIM", "anim/siren_bird_nest.zip"),
}

local function OnCollide(inst, data)

end

local function onsave(inst, data)

end

local function onload(inst, data)

end

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
    inst:AddTag("siren_bird_spawner")

    inst.AnimState:SetBank("siren_bird_nest")
    inst.AnimState:SetBuild("siren_bird_nest")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.1, {1.4, 0.9, 1.4})
    inst.components.floater.bob_percent = 0

    local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst.entity:SetPristine()

    inst:SetPrefabNameOverride("siren_bird_nest")

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddTag("sirenpoint")

    inst:AddComponent("inspectable")


    MakeHauntableWork(inst)

    inst:ListenForEvent("on_collide", OnCollide)

    --[[if not POPULATING then
        inst.stackid = math.random(NUM_STACK_TYPES)
        updateart(inst)
    end]]

    --------SaveLoad
    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("siren_bird_nest", fn, assets), Prefab("siren_bird_nest_teaser", fn, assets)--teaser will remove itself eventually.

local assets =
{
    Asset("ANIM", "anim/um_krissurepart.zip"),
}



local function OnSave(inst, data)
  
end

local function OnLoad(inst, data)

end

local function OnCollide(inst, other)
    if other ~= nil and
        other:IsValid() and
        inst:IsValid() and
        other.components.burnable ~= nil and
        other.components.fueled == nil then
        other.components.burnable:Ignite(true, inst)
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst, 1)

    inst.AnimState:SetBuild("um_krissurepart")
    inst.AnimState:SetBank("um_krissurepart")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.MiniMapEntity:SetIcon("lava_pond.png")

    inst:AddTag("lava")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    --cooker (from cooker component) added to pristine state for optimization
    inst:AddTag("cooker")


    inst.Light:Enable(true)
    inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(0.66)
    inst.Light:SetIntensity(0.11)
    inst.Light:SetColour(235 / 255, 121 / 255, 12 / 255)

    inst._playingmusic = false
    inst._musictask = nil

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(OnCollide)

    inst:AddComponent("inspectable")
    inst:AddComponent("heater")
    inst.components.heater.heat = 500

    inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = 5
    inst.components.propagator.damagerange = 5
    inst.components.propagator:StartSpreading()

    inst:AddComponent("cooker")


    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad



    return inst
end


return	Prefab("um_krissurepart", fn, assets)


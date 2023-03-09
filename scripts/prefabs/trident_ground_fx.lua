local assets = {
    Asset("ANIM", "anim/cavein_debris_fx.zip")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("cavein_debris_fx")
    inst.AnimState:SetBuild("cavein_debris_fx")
    inst.AnimState:PlayAnimation("anim")
    inst.AnimState:SetScale(0.5, -0.25, 0.5)
    inst.AnimState:SetAddColour(0, 0, 0, 6)
    inst.AnimState:SetDeltaTimeMultiplier(2)

    inst.entity:SetPristine()

    inst:AddTag("FX")


    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, function()
        inst.SoundEmitter:PlaySoundWithParams(
            "dontstarve/creatures/together/antlion/sfx/ground_break", { size = 1 })
    end)
    inst:ListenForEvent("animover", inst.Remove)


    return inst
end

return Prefab("trident_ground_fx", fn, assets)

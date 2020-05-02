local assets =
{
    Asset("ANIM", "anim/shroom_skin_fragment.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("deer_ice_burst")
    inst.AnimState:SetBuild("deer_ice_burst")
    inst.AnimState:PlayAnimation("loop")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_shoot", nil, .2)
	--inst.SoundEmitter:SetParameter("airconditionerpuff", "intensity", 0.1)
	inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("air_conditioner_smoke", fn, assets)

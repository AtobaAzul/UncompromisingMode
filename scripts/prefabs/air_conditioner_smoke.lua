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

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("small_puff")
    inst.AnimState:SetBuild("smoke_puff_small")
    inst.AnimState:PlayAnimation("puff")

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

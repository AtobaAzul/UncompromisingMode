local function beering_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()
	--inst.entity:AddAnimState()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("linearcircler")
    --[[inst.AnimState:SetBank("moonmaw_lavae")
    inst.AnimState:SetBuild("moonmaw_lavae")
	inst.AnimState:PlayAnimation("hover",true)]]
    inst.WINDSTAFF_CASTER = nil

	inst.persists = false
    return inst
end

return Prefab("beequeen_beering", beering_fn)

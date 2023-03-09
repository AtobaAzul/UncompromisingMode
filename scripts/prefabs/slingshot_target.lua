local function projectiletargetfn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("slingshot_target", projectiletargetfn)
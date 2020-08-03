local assets =
{
	Asset( "ANIM", "anim/hoodedcanopy.zip"),
}



local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    inst.AnimState:SetBuild("hoodedcanopy")
    inst.AnimState:SetBank("hoodedcanopy")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetScale(4, 4, 4)

    return inst
end

return Prefab("hoodedcanopy", fn, assets)
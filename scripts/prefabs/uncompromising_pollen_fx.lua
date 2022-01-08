local assets =
{
	Asset( "ANIM", "anim/um_pollen_fx.zip"),
}
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.persists = false

    inst.AnimState:SetBuild("um_pollen_fx")
    inst.AnimState:SetBank("um_pollen_fx")
    inst:DoTaskInTime(0,function (inst) inst.AnimState:PlayAnimation("fly") end)
	inst:DoTaskInTime(1.5,function (inst) inst:Remove() end)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("UM_Pollen")
	inst:ListenForEvent("animover", function(inst) inst:Remove() end)

    return inst
end
return Prefab("uncompromising_pollen_fx", fn, assets)
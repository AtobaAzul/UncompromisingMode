local assets =
{
	Asset( "ANIM", "anim/hoodedcanopy.zip"),
}

local function Thin(inst)
 local pt = inst:GetPosition()
 if #(TheSim:FindEntities(pt.x, pt.y, pt.z, 9, { "canopy" })) > 4 then
 inst:Remove()
 end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("tree")
	inst:AddTag("canopy")
    inst.AnimState:SetBuild("hoodedcanopy")
    inst.AnimState:SetBank("hoodedcanopy")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetMultColour(1, 1, 1, .3)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetScale(4, 4, 4)
	inst:DoTaskInTime(math.random(0,0.1),Thin)
    return inst
end

return Prefab("hoodedcanopy", fn, assets)
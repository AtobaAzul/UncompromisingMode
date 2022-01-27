local assets =
{
    Asset("ANIM", "anim/william.zip"),      
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
    anim:SetBuild("william")    
    anim:SetBank("william")

	inst.entity:SetPristine()
	

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")

	inst:DoTaskInTime(0,function(inst) anim:PlayAnimation("hanging", true) end)
	
    return inst
end

return Prefab("william", fn, assets)



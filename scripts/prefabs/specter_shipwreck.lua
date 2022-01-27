local assets =
{
    Asset("ANIM", "anim/shipwreck.zip"),      
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
	
    anim:SetBuild("shipwreck")    
    anim:SetBank("shipwreck")

	inst.entity:SetPristine()
	

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.type = math.random(1,4)
    inst:AddComponent("inspectable")

	inst:DoTaskInTime(0,function(inst) anim:PlayAnimation("idle_empty"..inst.type, true) end)
	
	inst.OnLoad = function(inst,data) if data and data.type then inst.type = data.type end end
	inst.OnSave = function(inst,data) data.type = inst.type end
    return inst
end

return Prefab("specter_shipwreck", fn, assets)



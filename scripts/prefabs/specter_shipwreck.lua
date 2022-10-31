local assets =
{
    Asset("ANIM", "anim/shipwreck.zip"),      
}

local function fn(Sim)
    local inst = CreateEntity()

	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBuild("shipwreck")    
    inst.AnimState:SetBank("shipwreck")

	inst.entity:SetPristine()
	

    if not TheWorld.ismastersim then
        return inst
    end
    inst:SetPhysicsRadiusOverride(2.35)

    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst:AddTag("ignorewalkableplatforms")

	inst.type = math.random(1,4)
    inst:AddComponent("inspectable")

	inst:DoTaskInTime(0,function(inst) inst.AnimState:PlayAnimation("idle_empty"..inst.type, true) end)
	
	inst.OnLoad = function(inst,data) if data and data.type then inst.type = data.type end end
	inst.OnSave = function(inst,data) data.type = inst.type end
    return inst
end

return Prefab("specter_shipwreck", fn, assets)



local SpawnDen(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("pollenmiteden").Transform:SetPosition(x, 0, z)
	
	inst:DoTaskInTime(0, function() inst:Remove() end)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
	inst:DoTaskInTime(0, SpawnDen)

    return inst
end


return Prefab("pollenmitedenprefabspawner", fn)
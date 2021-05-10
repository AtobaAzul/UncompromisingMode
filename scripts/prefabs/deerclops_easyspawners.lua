local function fn_enraged()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(0.1, function(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local deerclops = SpawnPrefab("deerclops")
		deerclops.Transform:SetPosition(x,y,z)
		deerclops.MakeEnrageable(deerclops)
		inst:Remove()
	end)
    return inst
end
local function fn_iceattuned()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(0.1, function(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local deerclops = SpawnPrefab("deerclops")
		deerclops.MakeIcey(deerclops)
		deerclops.Transform:SetPosition(x,y,z)
		inst:Remove()
	end)
    return inst
end
local function fn_strength()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:DoTaskInTime(0.1, function(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local deerclops = SpawnPrefab("deerclops")
		deerclops.MakeStrong(deerclops)
		deerclops.Transform:SetPosition(x,y,z)
		inst:Remove()
	end)
    return inst
end
return Prefab("deerclops_enragable", fn_enraged),
Prefab("deerclops_iceattuned", fn_iceattuned),
Prefab("deerclops_strength", fn_strength)
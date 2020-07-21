

local function SpawnTrapdoor(spawn_point)
    local plant = SpawnPrefab("trapdoor")
	plant.Transform:SetPosition(spawn_point.x, spawn_point.y, spawn_point.z)
			local grasschance = math.random()
			if grasschance > 0.25 then
			local grassycover = SpawnPrefab("trapdoorgrass")
			grassycover.Transform:SetPosition(spawn_point.x, spawn_point.y, spawn_point.z)
			--inst:AddChild(grassycover)
			end
    return plant
end


local function SpawnTrapdoorPre(inst)
		local pt = inst:GetPosition()
		local spawn_point = pt
		if spawn_point ~= nil then
			local plant = SpawnTrapdoor(spawn_point)
			inst:Remove()
		else
		inst:DoTaskInTime(1,SpawnTrapdoorPre)
		end
	
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	--inst:AddTag("CLASSIFIED")
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	--inst:AddTag("CLASSIFIED")
	
	inst:DoTaskInTime(0,SpawnTrapdoorPre)

    return inst
end

return Prefab("trapdoorspawner", fn)

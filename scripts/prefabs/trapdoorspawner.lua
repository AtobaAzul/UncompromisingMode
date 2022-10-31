local function SpawnTrapdoor(inst, spawn_point)
	local plant = SpawnPrefab("trapdoor")
	plant.Transform:SetPosition(spawn_point.x, spawn_point.y, spawn_point.z)
	if inst:HasTag("umss_grasstrap") then
		plant.components.childspawner:SetMaxChildren(1)
		plant.components.childspawner:StartRegen()
	end
	local grasschance = math.random()
	if grasschance > (inst:HasTag("umss_grasstrap") and 0.125 or 0.25) then
		local grassycover = SpawnPrefab("trapdoorgrass")
		grassycover.Transform:SetPosition(spawn_point.x, spawn_point.y, spawn_point.z)
	end
	inst:Remove()
end

local function SpawnTrapdoorPre(inst)
	local pt = inst:GetPosition()
	local spawn_point = pt
	if spawn_point ~= nil then
		local plant = SpawnTrapdoor(inst, spawn_point)
		inst:Remove()
	else
		inst:DoTaskInTime(1, SpawnTrapdoorPre)
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

	inst:DoTaskInTime(0, SpawnTrapdoorPre)

	return inst
end

return Prefab("trapdoorspawner", fn)

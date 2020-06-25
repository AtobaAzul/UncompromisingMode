local assets =
{
    --Asset("ANIM", "anim/grass.zip"),
    --Asset("ANIM", "anim/reeds.zip"),
    Asset("ANIM", "anim/riceplant.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "cutreeds",
}

local VALID_TILES = table.invert(
{
    GROUND.MARSH,
})
local function SpawnRice(spawn_point)
    local plant = SpawnPrefab("riceplant")
	plant.Physics:Teleport(spawn_point.x, spawn_point.y, spawn_point.z)
    return plant
end

local function GetSpawnPoint(pt)
    local function TestSpawnPoint(offset)
        local spawnpoint = pt + offset
		local spawnpoint_x, spawnpoint_y, spawnpoint_z = (pt + offset):Get()
        return not TheWorld.Map:IsAboveGroundAtPoint(spawnpoint:Get())
		and not VALID_TILES[TheWorld.Map:GetTileAtPoint(spawnpoint:Get())] ~= nil and
		not TheWorld.Map:IsPassableAtPoint(spawnpoint:Get())
		end

    local theta = math.random() * 2 * PI
    local radius = 12 + math.random(-1,1) * TUNING.FROG_RAIN_SPAWN_RADIUS/3
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function SpawnRicePre(inst)
		local pt = inst:GetPosition()
		local spawn_point = GetSpawnPoint(pt)
		if spawn_point ~= nil then
			local plant = SpawnRice(spawn_point)
			inst:Remove()
		end
		inst:DoTaskInTime(1,SpawnRicePre)
	
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
	
	inst:DoTaskInTime(1,SpawnRicePre)

    return inst
end

return Prefab("riceplantspawner", fn, assets, prefabs)

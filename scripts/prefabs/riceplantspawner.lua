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

local LAND_CHECK_RADIUS = 6
local function FindLandNextToWater(playerpos, waterpos)
    local radius = 12
    local ground = TheWorld

    local test = function(offset)
        local run_point = waterpos + offset

        -- TODO: Also test for suitability - trees or too many objects
        return TheWorld.Map:IsPassableAtPoint(run_point:Get())
    end

    -- FindValidPositionByFan(start_angle, radius, attempts, test_fn)
    -- returns offset, check_angle, deflected
    local loc, landAngle, deflected = FindValidPositionByFan(0, radius, 8, test)
    if loc then
        return waterpos + loc, landAngle, deflected
    end
end

local function IsNotNextToLand(pt)
    local playerPos = pt

    local radius = LAND_CHECK_RADIUS
    local landPos
    local tmpAng
    local map = TheWorld.Map

    local test = function(offset)
        local run_point = playerPos + offset
        -- Above ground, this should be water
        local loc, ang, def = FindLandNextToWater(playerPos, run_point)
        if loc ~= nil then
            landPos = loc
            tmpAng = ang
			
            return true
        end
        return false
    end

    local cang = (math.random() * 360) * DEGREES
    local loc, landAngle, deflected = FindValidPositionByFan(cang, radius, 7, test)
	
    if loc ~= nil then
        return landPos, tmpAng, deflected
    end
end

local function GetSpawnPoint(pt)
    local function TestSpawnPoint(offset)
        local spawnpoint = pt + offset
        local spawnpoint_x, spawnpoint_y, spawnpoint_z = (pt + offset):Get()
        return not TheWorld.Map:IsAboveGroundAtPoint(spawnpoint:Get())
            and not VALID_TILES[TheWorld.Map:GetTileAtPoint(spawnpoint:Get())] ~= nil and
            not TheWorld.Map:IsPassableAtPoint(spawnpoint:Get()) and IsNotNextToLand(spawnpoint)
    end

    local theta = math.random() * 2 * PI
    local radius = 24 + math.random(-1, 1) * 4
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function CheckPoint(pt)
    local moved = false
    if TheWorld.Map:IsAboveGroundAtPoint(pt.x + 4, pt.y, pt.z) then
        moved = true
        pt.x = pt.x - math.random(2, 4)
    end
    if TheWorld.Map:IsAboveGroundAtPoint(pt.x - 4, pt.y, pt.z) then
        moved = true
        pt.x = pt.x + math.random(2, 4)
    end
    if TheWorld.Map:IsAboveGroundAtPoint(pt.x, pt.y, pt.z + 4) then
        moved = true
        pt.z = pt.z - math.random(2, 4)
    end
    if TheWorld.Map:IsAboveGroundAtPoint(pt.x, pt.y, pt.z - 4) then
        moved = true
        pt.z = pt.z + math.random(2, 4)
    end
    if moved == false then
        return pt
    else
        return CheckPoint(pt)
    end
end

local function SpawnRicePre(inst)
    local pt = inst:GetPosition()
    local spawn_point = GetSpawnPoint(pt)
    if spawn_point ~= nil then
        local checkedpoint = CheckPoint(spawn_point)
        local plant = SpawnRice(checkedpoint)
        inst:Remove()
    else
        inst:DoTaskInTime(1, SpawnRicePre)
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

    inst:DoTaskInTime(1, SpawnRicePre)

    return inst
end

return Prefab("riceplantspawner", fn, assets, prefabs),
    Prefab("riceplantspawnerlarge", fn, assets, prefabs)

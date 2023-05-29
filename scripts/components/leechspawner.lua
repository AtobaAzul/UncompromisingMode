local FLOCK_SIZE = 9
local MIN_SPAWN_DIST = 40
local LAND_CHECK_RADIUS = 6
local WATER_CHECK_RADIUS = 2

local LOCAL_CHEATS_ENABLED = false

local MAX_DIST_FROM_PLAYER = 12
local MAX_DIST_FROM_WATER = 6
local MIN_DIST_FROM_STRUCTURES = 20

local SEARCH_RADIUS = 50
local SEARCH_RADIUS2 = SEARCH_RADIUS*SEARCH_RADIUS
local _flockSize = 1
--local DEFAULT_NUM_BOULDERS = 7

--------------------------------------------------------------------------
--[[ Penguin(leech)Spawner class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "Penguin(leech)Spawner should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private

local _spacing = 60
local _checktime = 5
local _lastSpawnTime = 0

local _spawnInterval = 30

local _active = true

local _activeplayers = {}

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------
local function FindLandNextToWater( playerpos, waterpos )
    local ignore_walls = true 
    local radius = WATER_CHECK_RADIUS
    local ground = TheWorld

    local test = function(offset)
        local run_point = waterpos + offset

        -- TODO: Also test for suitability - trees or too many objects
        return ground.Map:IsAboveGroundAtPoint(run_point:Get()) and
            ground.Pathfinder:IsClear(
                playerpos.x, playerpos.y, playerpos.z,
                run_point.x, run_point.y, run_point.z,
                { ignorewalls = ignore_walls, ignorecreep = true })
    end

    -- FindValidPositionByFan(start_angle, radius, attempts, test_fn)
    -- returns offset, check_angle, deflected
    local loc,landAngle,deflected = FindValidPositionByFan(0, radius, 8, test)
    if loc then
        return waterpos+loc,landAngle,deflected
    end
end


local function FindSpawnLocationForPlayer(player)
    local playerPos = Vector3(player.Transform:GetWorldPosition())

    local radius = LAND_CHECK_RADIUS
    local landPos
    local tmpAng
    local map = TheWorld.Map

    local test = function(offset)
        local run_point = playerPos + offset
        -- Above ground, this should be water
        if not map:IsAboveGroundAtPoint(run_point:Get()) then
            local loc, ang, def= FindLandNextToWater(playerPos, run_point)
            if loc ~= nil then
                landPos = loc
                tmpAng = ang
				
                return true
            end
        end
        return false
    end

    local cang = (math.random() * 360) * DEGREES
    local loc, landAngle, deflected = FindValidPositionByFan(cang, radius, 7, test)
	
    if loc ~= nil then
        return landPos, tmpAng, deflected
    end
end

local function SpawnLeech(inst,spawner,colonyNum,pos,angle)

    local leechprefab = "leechswarm"

    local leechswarm = SpawnPrefab(leechprefab)
    if leechswarm then
        leechswarm.Transform:SetPosition(pos.x,pos.y,pos.z)
        leechswarm.Transform:SetRotation(angle)
        leechswarm.sg:GoToState("locomote")
        --self:AddToColony(colonyNum,leechswarm)
    end
end

local function SpawnSwarm(colonyNum,loc,check_angle)
    local map = TheWorld.Map
    local flock = GetRandomWithVariance(_flockSize,1)
    local spawned = 0
    local i = 0
    local pang = check_angle/DEGREES
    while spawned < flock and i < flock + 7 do
        local spawnPos = loc + Vector3(GetRandomWithVariance(0,0.5),0.0,GetRandomWithVariance(0,0.5))
        i = i + 1
        if map:IsAboveGroundAtPoint(spawnPos:Get()) then
            spawned = spawned + 1
            self.inst:DoTaskInTime(GetRandomWithVariance(1,1), SpawnLeech, self, colonyNum, spawnPos,(check_angle/DEGREES))
        end
    end
end


local function TryToSpawnSwarmForPlayer(playerdata)
    if _active then
	    if not TheWorld.state.issummer then
            return
        end


		-- if too close to any player, then don't spawn
--        local playerPos = ThePlayer:GetPosition()
		-- if any player too close to any of the spawnlocs then bail
		-- if this player is too close to any of the lastSpawnLocs then don't try
        local player = playerdata.player
		local playerPos = player:GetPosition()
		for i,v in ipairs(_activeplayers) do
			if v.lastSpawnLoc and distsq(v.lastSpawnLoc,playerPos) < MIN_SPAWN_DIST*MIN_SPAWN_DIST then
				return
			end
		end

        if (_lastSpawnTime and (GetTime() - _lastSpawnTime) < _spawnInterval) then
            return
        end

        -- Go find a spot on land close to water
        -- returns offset, check_angle, deflected
        local loc,check_angle,deflected = FindSpawnLocationForPlayer(player)
        if loc then
            _lastSpawnTime = GetTime()
			playerdata.lastSpawnLoc = loc
			local colony = nil
            SpawnSwarm(colony,loc,check_angle)
        end
    end
end

local function TryToSpawnSwarm()
	-- Round robin the players
	if #_activeplayers > 0 then
		local playerdata = _activeplayers[1]
		TryToSpawnSwarmForPlayer(playerdata)
		table.remove(_activeplayers,1)
		table.insert(_activeplayers, playerdata)
	end
	self.inst:DoTaskInTime(_checktime / math.max(#_activeplayers,1), function() TryToSpawnSwarm() end)
end



--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------
local function OnPlayerJoined(src, player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, {player = player, lastSpawnLoc = nil})
end

local function OnPlayerLeft(src, player)
    for i, v in ipairs(_activeplayers) do
        if v.player == player then
            table.remove(_activeplayers, i)
            return
        end
    end
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
--Initialize variables
for i, v in ipairs(AllPlayers) do
	OnPlayerJoined(self, v)
end

inst:ListenForEvent("ms_playerjoined", function(src, player) OnPlayerJoined(src, player) end, TheWorld)
inst:ListenForEvent("ms_playerleft", function(src, player) OnPlayerLeft(src,player) end, TheWorld)

-- Reschedule based on number of players
self.inst:DoTaskInTime(_checktime / math.max(#_activeplayers,1), function() TryToSpawnSwarm() end)
--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------
end)

--------------------------------------------------------------------------
--[[ FrogRain class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "FrogRain should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _activeplayers = {}
local _scheduledtasks = {}
local _worldstate = TheWorld.state
local _map = TheWorld.Map
local _frogs = {}
local _frogcap = 10
local _spawntime = TUNING.FROG_RAIN_DELAY
local _updating = false
local _checktime = 40
local _chance = TUNING.FROG_RAIN_CHANCE
local _localfrogs = {
    min = TUNING.FROG_RAIN_LOCAL_MIN,
    max = TUNING.FROG_RAIN_LOCAL_MAX,
}

local VALID_TILES = table.invert(
{
    GROUND.DESERT_DIRT,
})
--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function GetSpawnPoint(pt)
    local function TestSpawnPoint(offset)
        local spawnpoint = pt + offset
		local spawnpoint_x, spawnpoint_y, spawnpoint_z = (pt + offset):Get()
        return _map:IsAboveGroundAtPoint(spawnpoint:Get())
		and VALID_TILES[_map:GetTileAtPoint(spawnpoint:Get())] ~= nil
		and
        #(TheSim:FindEntities(spawnpoint_x, 0, spawnpoint_z, 4, { "player" })) == 0
		end

    local theta = math.random() * 2 * PI
    local radius = math.random() * TUNING.FROG_RAIN_SPAWN_RADIUS/3
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function SpawnFrog(spawn_point)
    local frog = SpawnPrefab("scorpion")
    frog.persists = false
    if math.random() < .5 then
        frog.Transform:SetRotation(180)
    end
	frog.Physics:Teleport(spawn_point.x, spawn_point.y, spawn_point.z)
    frog.sg:GoToState("enterdig")
    return frog
end

local function SpawnFrogForPlayer(player, reschedule)
	if (not TheWorld.state.iswinter) and TheWorld.state.isday then
    local pt = player:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.FROG_RAIN_MAX_RADIUS, { "scorpion" })
	if GetTableSize(_frogs) < TUNING.FROG_RAIN_MAX and #ents < _frogcap then
		local spawn_point = GetSpawnPoint(pt)
		if spawn_point ~= nil then
            -- print("Spawning a frog for player ",player)
			local frog = SpawnFrog(spawn_point)
		end
	end
	end
    _scheduledtasks[player] = nil
    reschedule(player)
	
end

local function ScheduleSpawn(player, initialspawn)
    if _scheduledtasks[player] == nil and _spawntime ~= nil then
        local lowerbound = _spawntime.min
        local upperbound = _spawntime.max
        _scheduledtasks[player] = player:DoTaskInTime(20+math.random()*10, SpawnFrogForPlayer, ScheduleSpawn)
    end
end

local function CancelSpawn(player)
    if _scheduledtasks[player] ~= nil then
        _scheduledtasks[player]:Cancel()
        _scheduledtasks[player] = nil
    end
end

local function ToggleUpdate(force)
    --if (not _worldstate.iswinter) and TheWorld.state.isday then
        --if not _updating then
        --    _updating = true
            for i, v in ipairs(_activeplayers) do
                ScheduleSpawn(v, true)
            end
        --elseif force then
            for i, v in ipairs(_activeplayers) do
                CancelSpawn(v)
                ScheduleSpawn(v, true)
            end
        --end
end

local function AutoRemoveTarget(inst, target)
    if _frogs[target] ~= nil and target:IsAsleep() then
        target:Remove()
    end
end

--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

local function OnIsRaining(inst, israining)
    --if israining and (math.random() < _chance) then -- only add fromgs to some rains
    --    _frogcap = math.random(_localfrogs.min, _localfrogs.max)
    --else
    --    _frogcap = 0
    --end
    --ToggleUpdate()
end

local function OnPlayerJoined(src, player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)
    --if _updating then
        ScheduleSpawn(player, true)
    --end
end

local function OnPlayerLeft(src, player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            CancelSpawn(player)
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
    table.insert(_activeplayers, v)
end

--Register events
inst:WatchWorldState("israining", OnIsRaining)

inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

ToggleUpdate()


--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------

function self:SetSpawnTimes(times)
    _spawntime = times
    ToggleUpdate(true)
end

function self:SetMaxFrogs(max)
    _frogcap = max
end


--V2C: FIXME: nobody calls this ever... c'mon...
function self:StopTracking(inst)
    _frogs[inst] = nil
end

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

function self:OnSave()
    return
    {
        frogcap = _frogcap,
        spawntime = _spawntime,
        chance = _chance,
        localfrogs = _localfrogs,
    }
end

function self:OnLoad(data)
    _frogcap = data.frogcap or 0
    _spawntime = data.spawntime or TUNING.FROG_RAIN_DELAY
    _chance = data.chance or TUNING.FROG_RAIN_CHANCE
    _localfrogs = data.localfrogs or {min=TUNING.FROG_RAIN_LOCAL_MIN, max=TUNING.FROG_RAIN_LOCAL_MAX}

    ToggleUpdate(true)
end

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------

function self:GetDebugString()
    local frog_count = 0
    for k, v in pairs(_frogs) do
        frog_count = frog_count + 1
    end
    return string.format("Frograin: %d/%d, updating:%s min: %2.2f max:%2.2f", frog_count, _frogcap, tostring(_updating), _spawntime.min, _spawntime.max)
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)


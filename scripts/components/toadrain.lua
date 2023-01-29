--------------------------------------------------------------------------
--[[ FrogRain class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "ToadRain should not exist on client")

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
local _frogcap = 0
local _spawntime = TUNING.DSTU.TOAD_RAIN_DELAY
local _updating = false

local _chance = TUNING.FROG_RAIN_CHANCE
local _localfrogs = {
    min = TUNING.FROG_RAIN_LOCAL_MIN,
    max = TUNING.FROG_RAIN_LOCAL_MAX,
}

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function GetSpawnPoint(pt)
    local function TestSpawnPoint(offset)
        local spawnpoint = pt + offset
        return _map:IsAboveGroundAtPoint(spawnpoint:Get())
    end

    local theta = math.random() * 2 * PI
    local radius = math.random() * TUNING.FROG_RAIN_SPAWN_RADIUS
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function SpawnToad(spawn_point)
    local toad = SpawnPrefab("uncompromising_toad")
    toad.persists = false
    if math.random() < .5 then
        toad.Transform:SetRotation(180)
    end
    toad.sg:GoToState("fall")
    toad.Physics:Teleport(spawn_point.x, 35, spawn_point.z)
    return toad
end

local function SpawnFrogForPlayer(player, reschedule)

	local mushroomcheck = TheSim:FindFirstEntityWithTag("acidrain_mushroom")
	if _worldstate.isautumn and mushroomcheck ~= nil then
		local pt = player:GetPosition()
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.FROG_RAIN_MAX_RADIUS, { "frog" })
		if GetTableSize(_frogs) < TUNING.FROG_RAIN_MAX and #ents < _frogcap then
			local spawn_point = GetSpawnPoint(pt)
			if spawn_point ~= nil then
				-- print("Spawning a frog for player ",player)
				local toad = SpawnToad(spawn_point)
				self:StartTracking(toad)
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
        _scheduledtasks[player] = player:DoTaskInTime(GetRandomMinMax(lowerbound, upperbound), SpawnFrogForPlayer, ScheduleSpawn)
    end
end

local function CancelSpawn(player)
    if _scheduledtasks[player] ~= nil then
        _scheduledtasks[player]:Cancel()
        _scheduledtasks[player] = nil
    end
end

local function ToggleUpdate(force)

	local mushroomcheck = TheSim:FindFirstEntityWithTag("acidrain_mushroom")

	if _worldstate.isautumn and
		_worldstate.israining and
        mushroomcheck ~= nil and
		TheWorld.state.cycles > TUNING.DSTU.ACID_RAIN_START_AFTER_DAY then
		
		TUNING.PERISH_WET_MULT = 1.6
		
        if not _updating then
            _updating = true
            for i, v in ipairs(_activeplayers) do
                ScheduleSpawn(v, true)
            end
        elseif force then
            for i, v in ipairs(_activeplayers) do
                CancelSpawn(v)
                ScheduleSpawn(v, true)
            end
        end
	elseif _updating then
	
		TUNING.PERISH_WET_MULT = 1.3
	
        _updating = false
        for i, v in ipairs(_activeplayers) do
            CancelSpawn(v)
        end
    end
	
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
    if israining then
        _frogcap = math.random(_localfrogs.min, _localfrogs.max)
    end
    ToggleUpdate()
end

local function OnPlayerJoined(src, player)
    for i, v in ipairs(_activeplayers) do
        if v == player then
            return
        end
    end
    table.insert(_activeplayers, player)
    if _updating then
        ScheduleSpawn(player, true)
    end
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

local function OnSetChance(src, chance)
    _chance = chance
end

local function OnSetLocalMax(src, maxtable)
    _localfrogs = maxtable
end

local function OnTargetSleep(target)
    inst:DoTaskInTime(0, AutoRemoveTarget, target)
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
inst:WatchWorldState("precipitationrate", ToggleUpdate)

inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

inst:ListenForEvent("ms_setfrograinchance", OnSetChance, TheWorld)
inst:ListenForEvent("ms_setfrograinlocalfrogs", OnSetLocalMax, TheWorld)


ToggleUpdate(true)

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

function self.StartTrackingFn(target)
    _frogs[target] = target.persists
    target.persists = false
    inst:ListenForEvent("entitysleep", OnTargetSleep, target)
    inst:ListenForEvent("onremove", self.StopTrackingFn, target)
    inst:ListenForEvent("enterlimbo", self.StopTrackingFn, target)
    inst:ListenForEvent("exitlimbo", self.StartTrackingFn, target)
end

function self:StartTracking(target)
    self.StartTrackingFn(target)
end

function self.StopTrackingFn(target)
    local restore = _frogs[target]
    if restore ~= nil then
        target.persists = restore
        _frogs[target] = nil
        inst:RemoveEventCallback("entitysleep", OnTargetSleep, target)
    end
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
    _spawntime = data.spawntime or TUNING.DSTU.TOAD_RAIN_DELAY
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

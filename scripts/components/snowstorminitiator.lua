--------------------------------------------------------------------------
--[[ PollenmiteDenSpawner class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "PollenmiteDenSpawner should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _scheduledspawntasks = nil
local _worldstate = TheWorld.state
local _updating = false
local _storming = false
local _spawninterval = TUNING.TOTAL_DAY_TIME * 3
local _despawninterval = TUNING.TOTAL_DAY_TIME / 2
local _RandomTime = nil
local _RandomTimeData = nil

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function RandomizeSpawnTime()
	if _storming then
		--return 10 --+ math.random(-_spawnintervalvariance, _spawnintervalvariance)
		return _despawninterval --+ math.random(-_spawnintervalvariance, _spawnintervalvariance)
	else
		--return 1 --+ math.random(-_spawnintervalvariance, _spawnintervalvariance)
		return _spawninterval --+ math.random(-_spawnintervalvariance, _spawnintervalvariance)
	end
end

local function SpawnPollenmiteDenForPlayer(reschedule)

	if _storming or not TheWorld.state.iswinter then
		_storming = false
		TheWorld:RemoveTag("snowstormstart")
		TheWorld.net:RemoveTag("snowstormstartnet")
		print("remove")
	else
		_storming = true
		TheWorld:AddTag("snowstormstart")
		TheWorld.net:AddTag("snowstormstartnet")
		print("add")
	end
	
    _scheduledspawntasks = nil
    
    if _scheduledspawntasks == nil then
		_RandomTime = RandomizeSpawnTime()
        _scheduledspawntasks = TheWorld:DoTaskInTime(_RandomTime, SpawnPollenmiteDenForPlayer)
    end
end

local function ScheduleSpawnTask()
    if _scheduledspawntasks == nil then
		_RandomTime = RandomizeSpawnTime()
        _scheduledspawntasks = TheWorld:DoTaskInTime(_RandomTime, SpawnPollenmiteDenForPlayer)
    end
end

local function CancelSpawnTask()
    if _scheduledspawntasks ~= nil then
        _scheduledspawntasks:Cancel()
        _scheduledspawntasks = nil
    end
end

local function StartUpdating(force)
    if not TheWorld.state.iswinter then
        return
    end

	
    if _spawninterval > 0 then
        if not _updating then
            _updating = true
            ScheduleSpawnTask()
        elseif force then
            CancelSpawnTask()
            ScheduleSpawnTask()
        end
    end
end

local function StopUpdating()
    if _updating then
        _updating = false
        CancelSpawnTask()
    end
end
--[[
function self:OnUpdate(dt)
	if _RandomTime ~= nil then
		_RandomTimeData = _RandomTime - dt
		print(_RandomTimeData)
	end
end

function self:LongUpdate(dt)
	self:OnUpdate(dt)
end
]]
--------------------------------------------------------------------------
--[[ Private event handlers ]]
--------------------------------------------------------------------------

local OnSeasonTick = function(inst, data)
    if data.season == "winter" then
        StartUpdating()
		--self.inst:StartUpdatingComponent(self)
    else
        StopUpdating()
		--self.inst:StopUpdatingComponent(self)
    end
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

inst:ListenForEvent("seasontick", OnSeasonTick, TheWorld)

StartUpdating(true)

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------

function self:SpawnModeNever()
    _spawninterval = 0
    _spawnintervalvariance = 0
    StartUpdating(true)
end

function self:SpawnModeHeavy()
    _spawninterval = TUNING.TOTAL_DAY_TIME-- * 2
    _spawnintervalvariance = TUNING.TOTAL_DAY_TIME + math.random(TUNING.TOTAL_DAY_TIME)-- * 1
    StartUpdating(true)
end

function self:SpawnModeMed()
    _spawninterval = TUNING.TOTAL_DAY_TIME-- * 4
    _spawnintervalvariance = TUNING.TOTAL_DAY_TIME + math.random(TUNING.TOTAL_DAY_TIME)-- * 1
    StartUpdating(true)
end

function self:SpawnModeLight()
    _spawninterval = TUNING.TOTAL_DAY_TIME-- * 10
    _spawnintervalvariance = TUNING.TOTAL_DAY_TIME + math.random(TUNING.TOTAL_DAY_TIME)-- * 2
    StartUpdating(true)
end

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

function self:OnSave()
    local data =
    {
		--RandomTime = _RandomTimeData,
		storming = _storming,
        spawninterval = _spawninterval,
        despawninterval = _despawninterval,
    }

    return data
end

function self:OnLoad(data)
	_storming = data.storming or false
    _spawninterval = data.spawninterval or TUNING.TOTAL_DAY_TIME * 3
    _despawninterval = data._despawninterval or TUNING.TOTAL_DAY_TIME / 2
	
	self.inst:DoTaskInTime(1, function(self) 
		if _storming then
			TheWorld:AddTag("snowstormstart")
			TheWorld.net:AddTag("snowstormstartnet")
		end
	end)
	
	--[[
	if data.RandomTime ~= nil then
		_RandomTimeData = data.RandomTime
        _scheduledspawntasks = TheWorld:DoTaskInTime(_RandomTimeData, SpawnPollenmiteDenForPlayer)
	end	]]
		
	
    --_scheduledspawntasks = TheWorld:DoTaskInTime(RandomizeSpawnTime(), SpawnPollenmiteDenForPlayer)

    StartUpdating(true)
end

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------

function self:GetDebugString()
    return string.format("spawn interval:%2.2f, variance:%2.2f", _spawninterval, _spawnintervalvariance)
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
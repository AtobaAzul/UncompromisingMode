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
--local _spawninterval = 30
--local _despawninterval = 100
local _RandomTime = nil
local _RandomTimeData = nil

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function RandomizeSpawnTime()
	if _storming then
		--return _despawninterval
		return _despawninterval + math.random(0,120)
	else
		--return _spawninterval
		return _spawninterval + math.random(0,120)
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
		
		for i, v in ipairs(AllPlayers) do
			v.components.talker:Say(GetString(v, "ANNOUNCE_DEERCLOPS"))
		end
		
		TheWorld:PushEvent("ms_forceprecipitation", true)
		
		TheWorld:DoTaskInTime(60, function()
			if TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE then
				TheWorld:AddTag("snowstormstart")
				TheWorld.net:AddTag("snowstormstartnet")
			end
		end)
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
--[[ Save/Load ]]
--------------------------------------------------------------------------

function self:OnSave()
	
	if _RandomTime ~= nil then
		local time = GetTime()
		if _RandomTime > time then
			_RandomTimeData = _RandomTime - time
			print(_RandomTimeData)
			print("saved")
		end
	end
	
    local data =
    {
		randomtime = _RandomTimeData,
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
    --_spawninterval = data.spawninterval or 30
    --_despawninterval = data._despawninterval or 100
	
	self.inst:DoTaskInTime(1, function(self) 
		if _storming then
			if TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE then
				TheWorld:AddTag("snowstormstart")
				TheWorld.net:AddTag("snowstormstartnet")
			end
		end
	end)
	
	
	if data.randomtime ~= nil then
		_RandomTime = data.randomtime + GetTime()
        _scheduledspawntasks = TheWorld:DoTaskInTime(_RandomTime, SpawnPollenmiteDenForPlayer)
	end	
		
	self.inst:DoTaskInTime(1, function(self)
		if _RandomTime ~= nil then
		print(_RandomTime)
		print("loaded")
		end
	end)
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
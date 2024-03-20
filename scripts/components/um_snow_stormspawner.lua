--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ UM_Snowstorms class definition ]]
--------------------------------------------------------------------------

local _storming = false
local _spawninterval = TUNING.TOTAL_DAY_TIME * 3
local _despawninterval = TUNING.TOTAL_DAY_TIME / 2
local _worldsettingstimer = TheWorld.components.worldsettingstimer
local UM_SNOWSTORM_TIMERNAME = "um_snowstorm_timer"
local UM_STOPSNOWSTORM_TIMERNAME = "um_stopsnowstorm_timer"
local _stormtask = nil
local function StopSnowstorm()
    _storming = false

    if TheWorld.snowstorm_task ~= nil then
        TheWorld.snowstorm_task:Cancel()
        TheWorld.snowstorm_task = nil
    end

    TheWorld:RemoveTag("snowstormstart")

    if TheWorld.net ~= nil then
        TheWorld.net:RemoveTag("snowstormstartnet")
    end

    if _worldsettingstimer:GetTimeLeft(UM_SNOWSTORM_TIMERNAME) == nil then
        _worldsettingstimer:StartTimer(UM_SNOWSTORM_TIMERNAME, _spawninterval + math.random(0, 120))
    end

    _worldsettingstimer:ResumeTimer(UM_SNOWSTORM_TIMERNAME)
end

local function StartStorming()
    _storming = true

    TheWorld:PushEvent("ms_forceprecipitation", true)

    for i, v in ipairs(AllPlayers) do
        if v.components.talker ~= nil then
            v:DoTaskInTime(math.random() * 4, function(inst)
                inst.components.talker:Say(GetString(v, "ANNOUNCE_SNOWSTORM"))
            end)
        end
    end

    TheWorld.snowstorm_task = TheWorld:DoTaskInTime(60, function()
        TheWorld:AddTag("snowstormstart")
        if TheWorld.net ~= nil then
            TheWorld.net:AddTag("snowstormstartnet")
        end

        _worldsettingstimer:StartTimer(UM_STOPSNOWSTORM_TIMERNAME, _despawninterval + math.random(80, 120))
    end)
end

local function StartSnowstorms()
    if _worldsettingstimer:GetTimeLeft(UM_SNOWSTORM_TIMERNAME) == nil then
        if not _storming then
            _worldsettingstimer:StartTimer(UM_SNOWSTORM_TIMERNAME, _spawninterval + math.random(0, 120))
        end
    end

    _worldsettingstimer:ResumeTimer(UM_SNOWSTORM_TIMERNAME)
end

local function StopSnowstorms()
    _worldsettingstimer:StopTimer(UM_SNOWSTORM_TIMERNAME)
    _worldsettingstimer:StopTimer(UM_STOPSNOWSTORM_TIMERNAME)
end

local function OnSeasonChange(self)
    if TheWorld.state.season == "winter" then
        if TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE_WINTER then
            --if not _storming then
            StartSnowstorms()
            --end
        end
    else
        StopSnowstorm()
        StopSnowstorms()
    end
end

local SnowstormInitiator = Class(function(self, inst)
    assert(TheWorld.ismastersim, "SnowstormInitiator should not exist on client!")

    self.inst = inst

    self:WatchWorldState("season", OnSeasonChange)
    self:WatchWorldState("cycles", function(inst)
        if not TheWorld.state.season == "winter" then
            OnSeasonChange()
        end
    end)

    self.inst:StartUpdatingComponent(self)
end)


function SnowstormInitiator:OnPostInit()
    if not _worldsettingstimer:ActiveTimerExists(UM_SNOWSTORM_TIMERNAME) then
        _worldsettingstimer:AddTimer(UM_SNOWSTORM_TIMERNAME, _spawninterval + math.random(0, 120), true, StartStorming)
    end
    if not _worldsettingstimer:ActiveTimerExists(UM_STOPSNOWSTORM_TIMERNAME) then
        _worldsettingstimer:AddTimer(UM_STOPSNOWSTORM_TIMERNAME, _despawninterval + math.random(80, 120), true,
            StopSnowstorm)
    end

    OnSeasonChange()
end

function SnowstormInitiator:OnUpdate(dt)
    if not TheWorld.state.issnowing and TheWorld:HasTag("snowstormstart") then
        TheWorld:PushEvent("ms_forceprecipitation", true)
    end

    if not TheWorld.state.iswinter then
        StopSnowstorm()
        StopSnowstorms()
    end
end

function SnowstormInitiator:OnSave()
    local data = {
        storming = _storming
        -- old_temp = self.old_temp
    }

    return data
end

function SnowstormInitiator:ToggleSnowstorm(toggle)
    if toggle == nil or type(toggle) ~= "boolean" then
        if not _storming then
            StartStorming()
            return true
        else
            StopSnowstorm()
            return false
        end
    else
        if toggle then
            StartStorming()
            return true
        else
            StopSnowstorm()
            return false
        end
    end
end

function SnowstormInitiator:OnLoad(data)
    _storming = data.storming or false

    if _storming then
        StartStorming()
    end
end

function SnowstormInitiator:LongUpdate(dt) self:OnUpdate(dt) end

return SnowstormInitiator

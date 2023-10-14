-- TODO: Rework this into a heat wave that goes across the map!!
--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ UM_Heatwaves class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)
    assert(TheWorld.ismastersim, "UM_Heatwaves should not exist on client!")

    local _worldsettingstimer = TheWorld.components.worldsettingstimer
    local UM_HEATWAVE_TIMERNAME = "um_heatwave_timer"
    local UM_STOPHEATWAVE_TIMERNAME = "um_stopheatwave_timer"

    --------------------------------------------------------------------------
    --[[ Public Member Variables ]]
    --------------------------------------------------------------------------

    self.inst = inst
    -- self.old_temp = nil

    --------------------------------------------------------------------------
    --[[ Private Member Variables ]]
    --------------------------------------------------------------------------

    local _storming = false
    local _spawninterval = TUNING.TOTAL_DAY_TIME * 3
    local _despawninterval = TUNING.TOTAL_DAY_TIME / 2

    --------------------------------------------------------------------------
    --[[ Private member functions ]]
    --------------------------------------------------------------------------

    local function StopHeatwave()
        _storming = false

        TheWorld:RemoveTag("heatwavestart")

        if TheWorld.net ~= nil then
            TheWorld.net:RemoveTag("heatwavestartnet")
        end
        -- TheWorld.state.temperature = self.old_temp
        SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "ToggleCaveHeatWave"), nil, false)

        if _worldsettingstimer:GetTimeLeft(UM_HEATWAVE_TIMERNAME) == nil then
            _worldsettingstimer:StartTimer(UM_HEATWAVE_TIMERNAME, _spawninterval + math.random(0, 120))
        end

        _worldsettingstimer:ResumeTimer(UM_HEATWAVE_TIMERNAME)
    end

    local function StartHeatWaving()
        _storming = true

        -- for i, v in ipairs(AllPlayers) do
        --    --if v.components ~= nil and v.components.talker ~= nil and TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE_WINTER then
        --    v.components.talker:Say(GetString(v, "ANNOUNCE_SNOWSTORM"))
        --    --end
        -- end

        TheWorld:PushEvent("ms_forceprecipitation", false)

        TheWorld:DoTaskInTime(5, function()
            TheWorld:AddTag("heatwavestart")
            if TheWorld.net ~= nil then
                TheWorld.net:AddTag("heatwavestartnet")
            end
            SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "ToggleCaveHeatWave"), nil, true)
            -- self.old_temp = TheWorld.state.temperature
            -- TheWorld.state.temperature = TheWorld.state.temperature * 2
            _worldsettingstimer:StartTimer(UM_STOPHEATWAVE_TIMERNAME, _despawninterval + math.random(80, 120))
        end)
    end

    local function StartHeatWaves()
        if _worldsettingstimer:GetTimeLeft(UM_HEATWAVE_TIMERNAME) == nil then
			if not _storming then
				_worldsettingstimer:StartTimer(UM_HEATWAVE_TIMERNAME, _spawninterval + math.random(0, 120))
			end
        end

        _worldsettingstimer:ResumeTimer(UM_HEATWAVE_TIMERNAME)
    end

    local function StopHeatWaves()
        _worldsettingstimer:StopTimer(UM_HEATWAVE_TIMERNAME)
        _worldsettingstimer:StopTimer(UM_STOPHEATWAVE_TIMERNAME)
    end

    --------------------------------------------------------------------------
    --[[ Private event handlers ]]
    --------------------------------------------------------------------------

    local function OnSeasonChange(self)
        if TheWorld.state.season == "summer" then
            if TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE_SUMMER then
                --if not _storming then
                    StartHeatWaves()
                --end
            end
        else
            StopHeatwave()
            StopHeatWaves()
        end
    end

    function self:OnSave()
        local data = {
            storming = _storming
            -- old_temp = self.old_temp
        }

        return data
    end

    function self:ToggleHeatWave(toggle)
        if toggle == nil or type(toggle) ~= "boolean" then
            if not _storming then
                StartHeatWaving()
                return true
            else
                StopHeatwave()
                return false
            end
        else
            if toggle then
                StartHeatWaving()
                return true
            else
                StopHeatwave()
                return false
            end
        end
    end

    function self:OnLoad(data)
        _storming = data.storming or false
        -- self.old_temp = data.old_temp

        if _storming then
            StartHeatWaving()
        end
    end

    function self:OnPostInit()
        _worldsettingstimer:AddTimer(UM_HEATWAVE_TIMERNAME, _spawninterval + math.random(0, 120), true, StartHeatWaving)
        _worldsettingstimer:AddTimer(UM_STOPHEATWAVE_TIMERNAME, _despawninterval + math.random(80, 120), true,
            StopHeatwave)

        OnSeasonChange()
    end

    function self:OnUpdate(dt)
        if TheWorld.state.israining and TheWorld:HasTag("heatwavestart") then
            TheWorld:PushEvent("ms_forceprecipitation", false)
        end
    end

    function self:LongUpdate(dt) self:OnUpdate(dt) end

    self:WatchWorldState("season", OnSeasonChange)
    self:WatchWorldState("cycles", function(inst)
        if not TheWorld.state.season == "summer" then
            OnSeasonChange()
        end
    end)

    -- self.inst:ListenForEvent("forcetornado", PickAttackTarget)

    self.inst:StartUpdatingComponent(self)
end)

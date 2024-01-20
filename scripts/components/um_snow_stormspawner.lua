--------------------------------------------------------------------------
--[[ Dependencies ]] --------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ Gmoosespawner class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Gmoosespawner should not exist on client")

	local _worldsettingstimer = TheWorld.components.worldsettingstimer
	local UM_SNOW_STORM_TIMERNAME = "um_snowstorm_timer"
	local UM_STOP_SNOW_STORM_TIMERNAME = "um_stopsnowstorm_timer"

	--------------------------------------------------------------------------
	--[[ Private constants ]]
	--------------------------------------------------------------------------

	--------------------------------------------------------------------------
	--[[ Public Member Variables ]]
	--------------------------------------------------------------------------

	self.inst = inst

	--------------------------------------------------------------------------
	--[[ Private Member Variables ]]
	--------------------------------------------------------------------------

	local _storming = false
	local _spawninterval = TUNING.TOTAL_DAY_TIME * 3
	local _despawninterval = TUNING.TOTAL_DAY_TIME / 2

	--------------------------------------------------------------------------
	--[[ Private member functions ]]
	--------------------------------------------------------------------------

	local function StopStorming()
		print("StopStorming")
		_storming = false

		TheWorld:RemoveTag("snowstormstart")

		if TheWorld.net ~= nil then
			TheWorld.net:RemoveTag("snowstormstartnet")
		end

		if _worldsettingstimer:GetTimeLeft(UM_SNOW_STORM_TIMERNAME) == nil or not _worldsettingstimer:ActiveTimerExists(UM_SNOW_STORM_TIMERNAME) then
			_worldsettingstimer:StartTimer(UM_SNOW_STORM_TIMERNAME, _spawninterval + math.random(0, 120))
		end

		_worldsettingstimer:ResumeTimer(UM_SNOW_STORM_TIMERNAME)
	end

	local function StartStorming(self, immediately)
		if TheWorld.state.season == "winter" then
			print("StartStorming")
			_storming = true

			for i, v in ipairs(AllPlayers) do
				-- if v.components ~= nil and v.components.talker ~= nil and TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE_WINTER then
				v.components.talker:Say(GetString(v, "ANNOUNCE_SNOWSTORM"))
				-- end
			end

			TheWorld:PushEvent("ms_forceprecipitation", true)

			TheWorld:DoTaskInTime((immediately and 0) or 60, function()
				print("TASK IN TIME STORM START!")
				TheWorld:AddTag("snowstormstart")
				if TheWorld.net ~= nil then
					TheWorld.net:AddTag("snowstormstartnet")
				end

				--if _worldsettingstimer:GetTimeLeft(UM_STOP_SNOW_STORM_TIMERNAME) == nil or not _worldsettingstimer:ActiveTimerExists(UM_STOP_SNOW_STORM_TIMERNAME) then
					_worldsettingstimer:StartTimer(UM_STOP_SNOW_STORM_TIMERNAME, _despawninterval + math.random(80, 120))
				--end

				--_worldsettingstimer:ResumeTimer(UM_STOP_SNOW_STORM_TIMERNAME)
			end)
		end
	end

	local function StartStorms()
		print("StartStorms")
		if _worldsettingstimer:GetTimeLeft(UM_SNOW_STORM_TIMERNAME) == nil or not _worldsettingstimer:ActiveTimerExists(UM_SNOW_STORM_TIMERNAME) then
			if not _storming then
				_worldsettingstimer:StartTimer(UM_SNOW_STORM_TIMERNAME, _spawninterval + math.random(0, 120))
			end
		end

		_worldsettingstimer:ResumeTimer(UM_SNOW_STORM_TIMERNAME)
	end

	local function PauseStorms()
		_worldsettingstimer:PauseTimer(UM_SNOW_STORM_TIMERNAME, true)
		_worldsettingstimer:PauseTimer(UM_STOP_SNOW_STORM_TIMERNAME, true)
	end

	local function StopStorms()
		print("StopStorms")
		_worldsettingstimer:StopTimer(UM_SNOW_STORM_TIMERNAME)
		_worldsettingstimer:StopTimer(UM_STOP_SNOW_STORM_TIMERNAME)
		
		--PauseStorms()
	end

	--------------------------------------------------------------------------
	--[[ Private event handlers ]]
	--------------------------------------------------------------------------

	local function OnSeasonChange(self)
		if TheWorld.state.season == "winter" then
			if TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE_WINTER then
				--if not _storming then
					StartStorms()
				--end
			end
		else
			StopStorming()
			StopStorms()
		end
	end

	function self:OnSave()
		local data = {storming = _storming}

		return data
	end

	function self:OnLoad(data)
		_storming = data.storming

		if _storming then
			StartStorming(self, true)
		end
	end

	function self:OnPostInit()
		if not TestForIA() then
			_worldsettingstimer:AddTimer(UM_SNOW_STORM_TIMERNAME, _spawninterval + math.random(0, 120), true, StartStorming)
			_worldsettingstimer:AddTimer(UM_STOP_SNOW_STORM_TIMERNAME, _despawninterval + math.random(80, 120), true, StopStorming)

			OnSeasonChange()
		end
	end
	
	self:WatchWorldState("season", OnSeasonChange)
    self:WatchWorldState("cycles", function(inst)
        if not TheWorld.state.season == "winter" then
            OnSeasonChange()
        end
    end)
	-- self.inst:ListenForEvent("forcetornado", PickAttackTarget)
end)

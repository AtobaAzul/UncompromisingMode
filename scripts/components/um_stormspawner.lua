--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")

--------------------------------------------------------------------------
--[[ Gmoosespawner class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Gmoosespawner should not exist on client")

	local _locationtags = {
		"siren_bird_spawner",
		"siren_speaker_spawner",
		"siren_fish_spawner",
	}

	local _worldsettingstimer = TheWorld.components.worldsettingstimer
	local UM_STORM_TIMERNAME = "um_storm_timer"

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

	local _tornadotime = (TestForIA() and (TheWorld.state.winterlenght / 4) * 480) or (TheWorld.state.springlength / 4) * 480

	--------------------------------------------------------------------------
	--[[ Private member functions ]]
	--------------------------------------------------------------------------

	local function PickAttackTarget()
		if #_locationtags == 0 then
			_locationtags = {
				"siren_bird_spawner",
				"siren_speaker_spawner",
				"siren_fish_spawner",
			}
		else
			local location_id = math.random(#_locationtags)
			local spawn_location = TheSim:FindFirstEntityWithTag(_locationtags[location_id])

			table.remove(_locationtags, location_id)

			local x, y, z, x_dest, y_dest, z_dest

			if spawn_location ~= nil then
				x, y, z = spawn_location.Transform:GetWorldPosition()
				x_dest, y_dest, z_dest = spawn_location.Transform:GetWorldPosition()
			else
				x, y, z = math.random(-600, 600), 0, math.random(-600, 600)
				x_dest, y_dest, z_dest = x, y, z
			end

			local wise = 90
			local dest_can_move = true

			local mthnrd = math.random()

			local x_offset = 0
			local z_offset = 0

			--if x > 700 or x < -700 or mthnrd > 0.5 and not (z > 700 or z < -700) then
			if mthnrd > 0.5 then
				if x < 200 and x >= 0 then
					x_offset = -200
				elseif x > -200 and x <= 0 then
					x_offset = 200
				end

				if z < 200 and z >= 0 then
					z_offset = 200
				elseif z > -200 and z <= 0 then
					z_offset = -200
				end

				if x > 0 then
					x_dest = (-x + x_offset) * 1.5
				else
					x_dest = (math.abs(x) + x_offset) * 1.5
				end

				z_dest = (z + z_offset) * 1.5

				local destination = SpawnPrefab("um_tornado_destination")
				destination.Transform:SetPosition(x_dest, 0, z_dest)

				if x > 0 and z > 0 then
					destination.danumber = 90
				elseif x > 0 and z < 0 then
					destination.danumber = -90
					wise = -90
				elseif x < 0 and z > 0 then
					destination.danumber = -90
					wise = -90
				else
					destination.danumber = 90
				end

				destination.marker = "um_tornado_destination_marker"

				SpawnPrefab("um_tornado").Transform:SetPosition(x, y, z)
				--elseif z > 700 or z < -700 or mthnrd <= 0.5 and not (x > 700 or x < -700) then
			else
				if x < 200 and x >= 0 then
					x_offset = 200
				elseif x > -200 and x <= 0 then
					x_offset = -200
				end

				if z < 200 and z >= 0 then
					z_offset = -200
				elseif z > -200 and z <= 0 then
					z_offset = 200
				end

				x_dest = (x + x_offset) * 1.5

				if z > 0 then
					z_dest = (-z + z_offset) * 1.5
				else
					z_dest = (math.abs(z) + z_offset) * 1.5
				end

				local destination = SpawnPrefab("um_tornado_destination")
				destination.Transform:SetPosition(x_dest, 0, z_dest)

				if x > 0 and z > 0 then
					destination.danumber = -90
					wise = -90
				elseif x > 0 and z < 0 then
					destination.danumber = 90
				elseif x < 0 and z > 0 then
					destination.danumber = 90
				else
					destination.danumber = -90
					wise = -90
				end

				destination.marker = "um_tornado_destination_marker3"

				SpawnPrefab("um_tornado").Transform:SetPosition(x, y, z)
				--[[else
					if x > 0 then
						x_dest = -x * 1.5
					else
						x_dest = math.abs(x) * 1.5
					end
					
					if z > 0 then
						z_dest = -z * 1.5
					else
						z_dest = math.abs(z) * 1.5
					end
					
					local destination = SpawnPrefab("um_tornado_destination")
					destination.Transform:SetPosition(x_dest, 0, z_dest)
					destination.dest_can_move = false
					dest_can_move = false
					
					SpawnPrefab("um_tornado").Transform:SetPosition(x, y, z)]]
			end

			if not TestForIA() then
				SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "CaveTornado"), nil, x, z, wise, dest_can_move)
			end
		end

		_worldsettingstimer:StartTimer(UM_STORM_TIMERNAME, _tornadotime + math.random(180))
	end

	local function SpawnCaveTornado(inst, data)
		if data ~= nil and data.xdata ~= nil then
			local x = data.xdata
			local z = data.zdata
			local wise = data.wisedata
			local dest_can_move = data.dest_can_movedata

			local x_dest = x
			local z_dest = z

			if x > 0 then
				x_dest = -x * 2
			else
				x_dest = math.abs(x) * 2
			end

			if z > 0 then
				z_dest = -z * 2
			else
				z_dest = math.abs(z) * 2
			end

			local destination = SpawnPrefab("um_tornado_destination")
			destination.Transform:SetPosition(x_dest, 0, z_dest)
			destination.danumber = wise
			destination.dest_can_move = dest_can_move

			SpawnPrefab("um_cavetornado").Transform:SetPosition(x, 0, z)
		end
	end

	local function StartStorms()
		if _worldsettingstimer:GetTimeLeft(UM_STORM_TIMERNAME) == nil then
			_worldsettingstimer:StartTimer(UM_STORM_TIMERNAME, _tornadotime + math.random(180))
		end

		_worldsettingstimer:ResumeTimer(UM_STORM_TIMERNAME)
	end

	local function StopStorms()
		_worldsettingstimer:StopTimer(UM_STORM_TIMERNAME)
	end

	--------------------------------------------------------------------------
	--[[ Private event handlers ]]
	--------------------------------------------------------------------------

	local function OnSeasonChange(self)
		if TestForIA() and TheWorld.state.season == "winter" or TheWorld.state.season == "spring" and TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE_SPRING then
			StartStorms()
		else
			_locationtags = {
				"siren_bird_spawner",
				"siren_speaker_spawner",
				"siren_fish_spawner",
			}

			StopStorms()
		end
	end


	function self:OnSave()
		local data =
		{
			locationtags = _locationtags,
		}

		return data
	end

	function self:OnLoad(data)
		_locationtags = data.locationtags
	end

	function self:OnPostInit()
		if TheWorld.ismastershard then
			_worldsettingstimer:AddTimer(UM_STORM_TIMERNAME, _tornadotime + math.random(180), true, PickAttackTarget)

			OnSeasonChange()
		end
	end

	if TheWorld.ismastershard then
		self:WatchWorldState("season", OnSeasonChange)
		self.inst:ListenForEvent("forcetornado", PickAttackTarget)
	else
		self.inst:ListenForEvent("spawncavetornado", SpawnCaveTornado)
	end
end)

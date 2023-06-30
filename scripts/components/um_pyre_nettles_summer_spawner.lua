-- This file handles the spawning of Pyre Nettles around the player during Summer.
local _worldsettingstimer = TheWorld.components.worldsettingstimer
local PYRENETTLES_TIMER = "um_pyre_nettles_timer"
local _spawninterval = 1 --TUNING.TOTAL_DAY_TIME

return Class(function(self, inst)
	assert(TheWorld.ismastersim, "um_pyre_nettles_summer_spawner should not exist on client!")

	self.inst = inst
	inst.pyrenettle_attempts = 0

	-- Spawn conditions are here.
	local function SpawnPlants(inst)
		local tempchance = (TheWorld.state.temperature * 2) * (math.random() + math.random())
		if tempchance > 70 or TheWorld:HasTag("heatwavestart") then
			for k, v in pairs(AllPlayers) do
				local x, y, z = v.Transform:GetWorldPosition()
				local theta = math.random() * 2 * PI
				local x = x + 30 * math.cos(theta)
				local y = 0
				local z = z - 30 * math.sin(theta)

				local blockers = TheSim:FindEntities(x, y, z, 8, nil,
					{ "invisible", "playerghost" },
					{ "blocker", "player", "antlion_sinkhole_blocker", "structure" })
				local nettlescrowding = TheSim:FindEntities(x, y, z, 10, { "PyreNettle" })
				local findnettles = TheSim:FindEntities(x, y, z, 30, { "PyreNettle" })

				if #blockers > 0 or #nettlescrowding > 16 or #findnettles > 32 then
					--SpawnPlants()
					inst.pyrenettle_attempts = inst.pyrenettle_attempts + 1
					if inst.pyrenettle_attempts < 5 then
						SpawnPlants(inst)
					end
					return
				end

				for i = 1, math.random(10, 15) do
					local ix, iy, iz = x + math.random(-i, i), y, z + math.random(-i, i)
					if TheWorld.Map:IsPassableAtPoint(ix, iy, iz) then
						TheWorld:DoTaskInTime(math.random(), function()
							local nettle = SpawnPrefab("um_pyre_nettles")
							nettle.Transform:SetPosition(ix, iy, iz)
							nettle:PutBackOnGround(30)
						end)
					end
				end
				--	end
			end
		end

		if _worldsettingstimer:GetTimeLeft(PYRENETTLES_TIMER) == nil then
			_worldsettingstimer:StartTimer(PYRENETTLES_TIMER, _spawninterval + math.random(0, 120))
		end
	end


	local function OnSeasonChange()
		if TheWorld.state.season == "summer" and TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE_SUMMER then
			
			if _worldsettingstimer:GetTimeLeft(PYRENETTLES_TIMER) == nil then
				_worldsettingstimer:StartTimer(PYRENETTLES_TIMER, _spawninterval + math.random(-120, 120))
			end
		else
			_worldsettingstimer:StopTimer(PYRENETTLES_TIMER)
		end
	end

	function self:OnPostInit()
		_worldsettingstimer:AddTimer(PYRENETTLES_TIMER, _spawninterval + math.random(-120, 120), true, SpawnPlants)
		OnSeasonChange()
	end

	function self:ForceSpawnNettles()
		SpawnPlants()
	end

	self:WatchWorldState("season", OnSeasonChange)
end)

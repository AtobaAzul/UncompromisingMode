--please PLEASE tell me there's a better way to make this without copying every local
--KNOWN ISSUES - MARKERS BROKE
--do I care? NO.
--It solves a thing I was going to do aready - remove the max active limit.
local env = env
GLOBAL.setfenv(1, GLOBAL)

local BORDER_SCALE = .85 -- 0 < BORDER_SCALE < 1
local SPAWN_POINTS_PER_SIDE = 8
local SPAWN_OFFSET_ATTEMPTS = 8

local DOER_CHECK_RADIUS_SQ = 200 * 200   -- Minimum distance a treasure can spawn from the player using the message bottle
local ALLPLAYERS_CHECK_RADIUS_SQ = 50 * 50 -- Minimum distance from any player

local WATER_RADIUS_CHECK_BIAS = -4

local SHORE_CHECK_RADIUS = 2
local SHORE_CHECK_ATTEMPTS = 12

local MAX_ACTIVE_TREASURE_HUNTS = 4

local treasure_spawn_positions = nil

local function gettreasurespawnpointfromindex(ind)
	if treasure_spawn_positions[ind] == nil then
		local scaled_mapdim = TheWorld.Map:GetSize() * 2 * BORDER_SCALE
		local i = ind - (ind % 4)
		local c = ((i / 4) / SPAWN_POINTS_PER_SIDE) * 2 * scaled_mapdim - scaled_mapdim

		-- Spawn points are placed along a square inside the boundaries of the map. Once one point
		-- is calculated it's possible to figure out three more points relative to their respective
		-- sides of the square, which can be cached.
		treasure_spawn_positions[i] = Vector3(scaled_mapdim, 0, -c)
		treasure_spawn_positions[i + 1] = Vector3(-c, 0, scaled_mapdim)
		treasure_spawn_positions[i + 2] = Vector3(-scaled_mapdim, 0, -c)
		treasure_spawn_positions[i + 3] = Vector3(c, 0, -scaled_mapdim)
	end
	return treasure_spawn_positions[ind]
end

-- Returns a swimmable position at on offset from a spawn point given an index
local function getoffsetfromtreasurespawnpoint(point_ind, radius, attempts, doer)
	local pt = gettreasurespawnpointfromindex(point_ind)

	-- Checks for a point in the ocean around the given point
	local offset = FindSwimmableOffset(pt, math.random() * 2 * PI, radius, attempts)
	if offset == nil then
		return nil
	end

	local x, y, z = pt.x + offset.x, pt.y + offset.y, pt.z + offset.z

	if doer ~= nil and doer:GetDistanceSqToPoint(x, y, z) <= DOER_CHECK_RADIUS_SQ then
		return nil
	end

	-- If a point was found a check is also made to make sure it's not right next to land
	if FindSwimmableOffset(Vector3(x, y, z), 0, SHORE_CHECK_RADIUS, SHORE_CHECK_ATTEMPTS) == nil then
		return nil
	end

	for _, v in ipairs(AllPlayers) do
		if v:GetDistanceSqToPoint(x, y, z) <= ALLPLAYERS_CHECK_RADIUS_SQ then
			return nil
		end
	end

	return offset
end

local function gettreasurepos(doer)
	local offset = nil
	local offset_radius = math.max(TheWorld.Map:GetSize() * (1 - BORDER_SCALE) + WATER_RADIUS_CHECK_BIAS, 0)

	if treasure_spawn_positions == nil then
		treasure_spawn_positions = {}
	end

	local point_total = SPAWN_POINTS_PER_SIDE * 4
	local ind = math.random(1, point_total)
	local i = ind
	while offset == nil and i <= point_total do
		offset = getoffsetfromtreasurespawnpoint(i, offset_radius, SPAWN_OFFSET_ATTEMPTS, doer)
		i = i + 1
	end
	if offset == nil then
		i = 1
		while offset == nil and i < ind do
			offset = getoffsetfromtreasurespawnpoint(i, offset_radius, SPAWN_OFFSET_ATTEMPTS, doer)
			i = i + 1
		end
	end

	local base_point = treasure_spawn_positions[i - 1]

	if not offset or not base_point then
		return false, "NO_VALID_SPAWN_POINT_FOUND"
	end

	return Vector3(
		base_point.x + offset.x,
		0,
		base_point.z + offset.z
	)
end

--------------------------------------------------------------------------
--[[ Event handlers ]]
--------------------------------------------------------------------------

local function AddMinimapMarker(treasure, data)
	if data.underwater_object ~= nil then
		if data.underwater_object.components.treasuremarked ~= nil then
			data.underwater_object.components.treasuremarked:TurnOn()
		end
	end

	treasure:RemoveEventCallback("on_submerge", AddMinimapMarker)
end
local messagebottletreasures_um = require("messagebottletreasures_um")
local messagebottletreasures = require("messagebottletreasures")

env.AddComponentPostInit("messagebottlemanager", function(self)
	function self:UseMessageBottle(bottle, doer, is_not_from_hermit)
		--I should really, really use function hooking here, but I just woke up and want to get this done with.
		local hermitcrab = self:GetHermitCrab()

		if not is_not_from_hermit and hermitcrab ~= nil and not self:GetPlayerHasFoundHermit(doer) then
			return hermitcrab:GetPosition()     --, reason=nil
		else
			local pos, reason
			local num_active_hunts = GetTableSize(self.active_treasure_hunt_markers)

			if num_active_hunts < MAX_ACTIVE_TREASURE_HUNTS then
				pos, reason = gettreasurepos(doer)

				local rng = math.random()


				if pos and pos.x ~= nil then
					if rng > 0.5 then
						local treasure = messagebottletreasures.GenerateTreasure(pos)
						treasure.Transform:SetPosition(pos.x, pos.y, pos.z)
						treasure:ListenForEvent("on_submerge", AddMinimapMarker)
					else
						local treasure = messagebottletreasures_um.GenerateTreasure(pos, (math.random() > 0.25 and "sunkenchest" or "sunkenchest_royal_random"))
						treasure.Transform:SetPosition(pos.x, pos.y, pos.z)
						treasure:ListenForEvent("on_submerge", AddMinimapMarker)
					end
				end

				return pos, reason
			else
				local active_hunt = nil

				-- Iterate in random order
				local rand = math.random(MAX_ACTIVE_TREASURE_HUNTS)
				for i = 1, MAX_ACTIVE_TREASURE_HUNTS do
					local ind = ((i + rand) % MAX_ACTIVE_TREASURE_HUNTS) + 1

					local keys = {}
					for k, v in pairs(self.active_treasure_hunt_markers) do
						table.insert(keys, k)
					end
					active_hunt = keys[ind]

					if active_hunt ~= nil and active_hunt:IsValid() then
						return active_hunt:GetPosition()     --, reason=nil
					else
						self.active_treasure_hunt_markers[keys[ind]] = nil
					end
				end
			end
		end
		return nil, "STALE_ACTIVE_HUNT_REFERENCES"
	end
end)

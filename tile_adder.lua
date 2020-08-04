--[[
-- The following tables list what may be present in the tile and minimap
-- tile specifications passed to AddTile(). The values listed here are the
-- default ones used when none are specified.
--]]

-- Lists the structure for a tile specification by mapping the possible fields to their
-- default values.
local tile_spec_defaults = {
	noise_texture = "images/square.tex",
	runsound = "dontstarve/movement/run_dirt",
	walksound = "dontstarve/movement/walk_dirt",
	snowsound = "dontstarve/movement/run_ice",
	mudsound = "dontstarve/movement/run_mud",
	flashpoint_modifier = 0,
}

-- Like the above, but for the minimap tile specification.
local mini_tile_spec_defaults = {
	name = "map_edge",
	noise_texture = "levels/textures/mini_dirt_noise.tex",
}


------------------------------------------------------------------------


local _G = GLOBAL
local require = _G.require


require 'util'
require 'map/terrain'


local Asset = _G.Asset

local tiledefs = require 'worldtiledefs'
local GROUND = _G.GROUND
local GROUND_NAMES = _G.GROUND_NAMES
local GROUND_FLOORING = _G.GROUND_FLOORING
local resolvefilepath = _G.resolvefilepath
local softresolvefilepath = _G.softresolvefilepath

local assert = _G.assert
local error = _G.error
local type = _G.type
local rawget = _G.rawget


local GroundAtlas = rawget(_G, "GroundAtlas") or function( name )
	return ("levels/tiles/%s.xml"):format(name) 
end

local GroundImage = rawget(_G, "GroundImage") or function( name )
	return ("levels/tiles/%s.tex"):format(name) 
end

local noise_locations = {
	"%s.tex",
	"levels/textures/%s.tex",
}

local function GroundNoise( name )
	local trimmed_name = name:gsub("%.tex$", "")
	for _, pattern in ipairs(noise_locations) do
		local tentative = pattern:format(trimmed_name)
		if softresolvefilepath(tentative) then
				return tentative
		end
	end

	-- This is meant to trigger an error.
	local status, err = pcall(resolvefilepath, name)
	return error(err or "This shouldn't be thrown. But your texture path is invalid, btw.", 3)
end


local function AddAssetsTo(assets_table, specs)
	table.insert( assets_table, Asset( "IMAGE", GroundNoise( specs.noise_texture ) ) )
	table.insert( assets_table, Asset( "IMAGE", GroundImage( specs.name ) ) )
	table.insert( assets_table, Asset( "FILE", GroundAtlas( specs.name ) ) )
end

local function AddAssets(specs)
	AddAssetsTo(tiledefs.assets, specs)
end



local function validate_ground_numerical_id(numerical_id)
	if numerical_id >= GROUND.UNDERGROUND then
		return error(("Invalid numerical id %d: values greater than or equal to %d are assumed to represent walls."):format(numerical_id, GROUND.UNDERGROUND), 3)
	end
	for k, v in pairs(GROUND) do
		if v == numerical_id then
			return error(("The numerical id %d is already used by GROUND.%s!"):format(v, tostring(k)), 3)
		end
	end
end

--[[
-- name should match the texture/atlas specification in levels/tiles.
-- (it's not just an arbitrary name, it defines the texture used)
--]]
function AddTile(id, numerical_id, name, specs, minispecs, isflooring)
	assert( type(id) == "string" )
	assert( type(numerical_id) == "number" )
	assert( type(name) == "string" )
	assert( isflooring == nil or type(isflooring) == "boolean" )

	-- the same tile can be added multiple times if the mod is loaded via the frontend mod loader, see http://forums.kleientertainment.com/topic/66075-world-gen-data-and-mod-changes/
	if GROUND[id] ~= nil then
		modassert(GROUND[id] == numerical_id, ("GROUND.%s already exists: %s (%s), and differs from intended %s."):format(
			id, tostring(GROUND_NAMES[GROUND[id]]), tostring(GROUND[id]), tostring(numerical_id)
		))
		modassert(GROUND_NAMES[numerical_id] == name, ("GROUND_NAMES[%s] %s differs from intended %s."):format(tostring(numerical_id), tostring(GROUND_NAMES[numerical_id]), name))
		-- flooring checking can't be currently done, modworldgenmain.lua can get loaded by frontend mod loader multiple times
		-- if the user changes the setting between the loads, the value can differ and cause unwanted error
		--modassert(GROUND_FLOORING[numerical_id] == isflooring, ('GROUND_FLOORING[%s] (%s) differs from intended %s.'):format(
		--	tostring(numerical_id), tostring(GROUND_FLOORING[numerical_id]), tostring(isflooring)
		--))
		return
	end

	specs = specs or {}
	minispecs = minispecs or {}

	assert( type(specs) == "table" )
	assert( type(minispecs) == "table" )

	-- Ideally, this should never be passed, and we would wither generate it or load it
	-- from savedata if it had already been generated once for the current map/saveslot.
	validate_ground_numerical_id(numerical_id)

	GROUND[id] = numerical_id
	GROUND_NAMES[numerical_id] = name
	GROUND_FLOORING[numerical_id] = isflooring -- don't allow planting (saplings etc.) on this turf


	local real_specs = { name = name }
	for k, default in pairs(tile_spec_defaults) do
		if specs[k] == nil then
			real_specs[k] = default
		else
			-- resolvefilepath() gets called by the world entity.
			real_specs[k] = specs[k]
		end
	end
	real_specs.noise_texture = GroundNoise( real_specs.noise_texture )

	table.insert(tiledefs.ground, {
		GROUND[id], real_specs
	})

	AddAssets(real_specs)


	local real_minispecs = {}
	for k, default in pairs(mini_tile_spec_defaults) do
		if minispecs[k] == nil then
			real_minispecs[k] = default
		else
			real_minispecs[k] = minispecs[k]
		end
	end

	if not GLOBAL.ModManager.worldgen then
		AddPrefabPostInit("minimap", function(inst)
			local handle = _G.MapLayerManager:CreateRenderLayer(
				GROUND[id],
				resolvefilepath( GroundAtlas(real_minispecs.name) ),
				resolvefilepath( GroundImage(real_minispecs.name) ),
				resolvefilepath( GroundNoise(real_minispecs.noise_texture) )
			)
			inst.MiniMap:AddRenderLayer( handle )
		end)

		AddAssets(real_minispecs)
	end


	--return real_specs, real_minispecs
end

-- moves tile type with specified id before (or after) target tile type in the rendering layer order table
-- @param tiletypeid  id of the tile type that will be moved
-- @param targettiletypeid  id of the tile type in relation to which the moving tile type will be moved
-- @param moveafter  boolean  nil/false - move before target tile; true - move after target tile
function ChangeTileTypeRenderOrder(tiletypeid, targettiletypeid, moveafter)
	assert(tiletypeid ~= nil)
	assert(targettiletypeid ~= nil)

	local GROUND_LOOKUP = table.invert(GROUND)

	if tiletypeid == targettiletypeid then
		moderror(("[ChangeTileTypeRenderOrder(%s,%s,%s)] Trying to move ground %s (%s) in relation to itself."):format(
			tostring(tiletypeid), tostring(targettiletypeid), tostring(moveafter), tostring(tiletypeid), tostring(GROUND_LOOKUP[tiletypeid])
		))
		return nil
	end

	local grounds = tiledefs.ground

	local idx = nil
	for i, ground in ipairs(grounds) do
		if ground[1] ~= nil and ground[1] == tiletypeid then
			idx = i
			break
		end
	end
	if idx == nil then
		-- tile type not found
		moderror(("[ChangeTileTypeRenderOrder(%s,%s,%s)] Tile type %s (%s) not found."):format(
			tostring(tiletypeid), tostring(targettiletypeid), tostring(moveafter), tostring(tiletypeid), tostring(GROUND_LOOKUP[tiletypeid])
		))
		return nil
	end

	local targetidx = nil
	-- this is just a check for existence, the index might change during the moving
	for i, ground in ipairs(grounds) do
		if ground[1] ~= nil and ground[1] == targettiletypeid then
			targetidx = i
			break
		end
	end
	if targetidx == nil then
		-- tile type not found
		moderror(("[ChangeTileTypeRenderOrder(%s,%s,%s)] Tile type %s (%s) not found."):format(
			tostring(tiletypeid), tostring(targettiletypeid), tostring(moveafter), tostring(targettiletypeid), tostring(GROUND_LOOKUP[targettiletypeid])
		))
		return nil
	end

	--print(("[ChangeTileTypeRenderOrder(%s,%s,%s)] Moving tile type %s (%s) from index %s to index %s."):format(
	--	tostring(tiletypeid), tostring(targettiletypeid), tostring(moveafter), tostring(tiletypeid), tostring(GROUND_LOOKUP[tiletypeid]), tostring(idx), tostring(targetidx)
	--))
	local item = table.remove(grounds, idx)
	-- get the real target index
	targetidx = nil
	for i, ground in ipairs(grounds) do
		if ground[1] ~= nil and ground[1] == targettiletypeid then
			targetidx = i
			break
		end
	end
	assert(targetidx ~= nil, "Target index no longer found.")
	targetidx = moveafter and targetidx + 1 or targetidx
	table.insert(grounds, targetidx, item)
end

require "map/room_functions"

local Layouts = require ("map/layouts").Layouts
local StaticLayout = require ("map/static_layout")

Layouts["cave_exit_ratacombs"] = StaticLayout.Get("map/static_layouts/cave_exit_ratacombs")
Layouts["cave_entrance_ratacombs"] = StaticLayout.Get("map/static_layouts/cave_entrance_ratacombs")
Layouts["ratking"] = StaticLayout.Get("map/static_layouts/ratking")
Layouts["ratacombs_airpocket_1"] = StaticLayout.Get("map/static_layouts/ratacombs_airpocket_1")
Layouts["ratacombs_lock1"] = StaticLayout.Get("map/static_layouts/ratacombs_lock1")
----
--Ratacombs
----

	AddRoom("RattyStairs", {
						colour={r=0,g=.9,b=0,a=.50},
						value = WORLD_TILES.GROUND_NOISE,
						type = NODE_TYPE.Room,
						contents =  {
										countstaticlayouts = {
											["cave_exit_ratacombs"] = 1,
										},
										distributepercent = .3,
										distributeprefabs=
										{
											fireflies = 0.1,
											grass = .05,
											sapling=.5,
											twiggytree=0.2,
											rocks=.03,
											flint=.03,
											berrybush=.02,
											berrybush_juicy = 0.01,
											cavelight = 0.5,
											cavelight_small = 0.5,
											cavelight_tiny = 0.5,
											flower_cave = 0.1,
											flower_cave_double = 0.05,
											flower_cave_triple = 0.05,
										},								
									}

	})

	AddRoom("RattySinkhole", {
						colour={r=0,g=.9,b=0,a=.50},
						value = WORLD_TILES.GROUND_NOISE,
						tags = {"RoadPoison"},
						contents =  {
										countstaticlayouts = {
											["cave_entrance_ratacombs"] = 1,
										},
										distributepercent = .3,
										distributeprefabs=
										{
											fireflies = 0.1,
											evergreen_sparse=.7,
											grass = .05,
											sapling=.5,
											twiggytree=0.2,
											rocks=.03,
											flint=.03,
											berrybush=.02,
											berrybush_juicy = 0.01,
											
										},
									}

	})


	-- Rocky Plains
	AddRoom("RattyWilds", {
		colour={r=0.7,g=0.7,b=0.7,a=0.9},
		value = WORLD_TILES.CAVE_NOISE,
		type = NODE_TYPE.Room,
		contents =  {
			countstaticlayouts = {
				["ratacombs_airpocket_1"] = function() return math.random(0,1) end,
			},
			distributepercent = .10,
			distributeprefabs=
			{
				rock_flintless = 1.0,
				rock_flintless_med = 1.0,
				rock_flintless_low = 1.0,
				pillar_cave_flintless = 0.2,
				ratgas_spawner = 6,
				--uncompromising_ratherd = 1,
				goldnugget=.05,
				rocks=.1,
				flint=0.05,
				ratacombs_junkpile_spawner = 1.5,
				uncompromising_junkrat = 1,
				cavelight_small = 0.1,
				cavelight_tiny = 0.5,
				ratacombs_totem_short = 0.33,
				ratacombs_totem_medium = 0.33,
				ratacombs_totem_tall = 0.33,
				ratgashole = 6,
			},
		}
	})

	AddRoom("RattyLock1", {
		colour={r=0.7,g=0.7,b=0.7,a=0.9},
		value = WORLD_TILES.CAVE_NOISE,
		type = NODE_TYPE.Room,
		contents =  {
			countstaticlayouts = {
				["ratacombs_lock1"] = function() return math.random(0,1) end,
			},
			distributepercent = .10,
			distributeprefabs=
			{
				rock_flintless = 1.0,
				rock_flintless_med = 1.0,
				rock_flintless_low = 1.0,
				pillar_cave_flintless = 0.2,
				ratgas_spawner = 6,
				--uncompromising_ratherd = 1,
				goldnugget=.05,
				rocks=.1,
				flint=0.05,
				ratacombs_junkpile_spawner = 1.5,
				uncompromising_junkrat = 1,
				ratacombs_totem_short = 0.33,
				ratacombs_totem_medium = 0.33,
				ratacombs_totem_tall = 0.33,
				ratgashole = 3,
			},
		}
	})

	AddRoom("DeepRattyWilds", {
		colour={r=0.7,g=0.7,b=0.7,a=0.9},
		value = WORLD_TILES.CAVE_NOISE,
		type = NODE_TYPE.Room,
		contents =  {
			distributepercent = .10,
			distributeprefabs=
			{
				rock_flintless = 1.0,
				rock_flintless_med = 1.0,
				rock_flintless_low = 1.0,
				pillar_cave_flintless = 0.2,
				ratgas_spawner = 6,
				--uncompromising_ratherd = 1,
				goldnugget=.05,
				rocks=.1,
				flint=0.05,
				ratacombs_junkpile_spawner = 1.5,
				uncompromising_junkrat = 1,
				ratacombs_totem_short = 0.33,
				ratacombs_totem_medium = 0.33,
				ratacombs_totem_tall = 0.33,
				ratgashole = 3,
			},
		}
	})
	-- Rocky Plains
	AddRoom("RattyLink", {
		colour={r=0.7,g=0.7,b=0.7,a=0.9},
		value = WORLD_TILES.GROUND_NOISE,
						contents =  {
										--countprefabs = {
												--uncompromising_ratburrow = function() return math.random(8, 12) end,
											--},
										distributepercent = .5,
										distributeprefabs =
										{
											rock1 = .8,
											rock2 = .1,
											goldnugget = .1,
											flint = .1,
											fireflies = 0.2,
											--[[red_mushroom = .03,
											green_mushroom = .02,
											blue_mushroom = .002,]]
											trees = {weight = 6, prefabs = {"evergreen", "evergreen_sparse"}},
											cavelight = 0.05,
											cavelight_small = 0.05,
											cavelight_tiny = 0.05,
											ratacombs_junkpile_spawner = 3,
											cavelight_small = 0.5,
											cavelight_tiny = 0.5,
											ratacombs_totem_short = 0.33,
											ratacombs_totem_medium = 0.33,
											ratacombs_totem_tall = 0.33,
										},
									}
	})

	AddRoom("RatKingdomCaves", {
						colour={r=.5,g=0.6,b=.080,a=.10},
						value = WORLD_TILES.GROUND_NOISE,
						--tags = {"Chester_Eyebone"},
						contents =  {
										countstaticlayouts = {
											["ratking"] = 1,
										},
										countprefabs = {
											ratacombs_junkpile_trigger = 1,
										},
										distributepercent = .5,
										distributeprefabs =
										{
											--rock1 = .8,
											--rock2 = .1,
											--goldnugget = .1,
											flint = .1,
											fireflies = 0.2,
											red_mushroom = .03,
											green_mushroom = .02,
											blue_mushroom = .002,
											trees = {weight = 6, prefabs = {"evergreen", "evergreen_sparse"}},
											cavelight = 0.3,
											cavelight_small = 0.1,
											cavelight_tiny = 0.1,
										},
									}
	})

	local bgratty = {
		colour={r=0.7,g=0.7,b=0.7,a=0.9},
		value = WORLD_TILES.FOREST,
		type = NODE_TYPE.Room,
		contents =  {
			distributepercent = .10,
			distributeprefabs=
			{
				rock_flintless = 1.0,
				rock_flintless_med = 1.0,
				rock_flintless_low = 1.0,
				pillar_cave_flintless = 0.2,
				ratgas_spawner = 2.5,
				ratacombs_junkpile_spawner = 3,
				uncompromising_junkrat = 1,
				cavelight_small = 0.5,
				cavelight_tiny = 0.5,
				ratacombs_totem_short = 0.33,
				ratacombs_totem_medium = 0.33,
				ratacombs_totem_tall = 0.33,
			},
		}
	}

	AddRoom("BGRattyCave", bgratty)
	AddRoom("BGRattyCaveRoom", Roomify(bgratty))

	AddRoom("RattyWall", MakeSetpieceBlockerRoom("RatLockBlocker1"))
require ("map/rooms/forest/gianttreesrooms")
AddTask("GiantTrees", {
		locks={LOCKS.ADVANCED_COMBAT,LOCKS.MONSTERS_DEFEATED,LOCKS.TIER5},
		keys_given={KEYS.HF},
		--region_id = "hoodedforest",
		level_set_piece_blocker = true,
		room_choices={
			["GiantTrees"] = 1,
			["SnapDragons"] = 1,
			["SpideryGiantTrees"] = 1,
			["WalrusGiantTrees"] = 1,
			["MoonBaseGiantTrees"] = 1,

			["AphidLand"] = function() return math.random(0,1) end,
			--["RoadGiantTrees"] = 1,
			["ShroomInfestedGiantTrees"] = function() return math.random(0,1) end,
			["HoodedTown"] = function() return math.random(0,1) end,
			["HFHolidays"] = function() return math.random(0,1) end,
			["RoseGarden"] = function() return math.random(0,1) end,

			--["QuestionableDecisions"] = 1,
		},
		room_bg=WORLD_TILES.HOODEDFOREST,
		background_room="BGGiantTrees",
		colour={r=.1,g=.1,b=.1,a=1}
	})

	AddTask("GiantTrees_IA", {
		locks={LOCKS.ISLAND2},
		keys_given={KEYS.ISLAND3},
		--region_id = "hoodedforest",
		level_set_piece_blocker = true,
		room_choices={
			["GiantTrees"] = 1,
			["RoseGarden"] = 1,
			["AphidLand"] = 1,
			--["RoadGiantTrees"] = 1,
			--["WalrusGiantTrees"] = 1,
			--["MoonBaseGiantTrees"] = 1,
			["ShroomInfestedGiantTrees"] = 1,
			["SnapDragons"] = 1,
			["SpideryGiantTrees"] = 1,
			["HoodedTown"] = 1,
			["HFHolidays"] = 1,
			--["QuestionableDecisions"] = 1,
		},
		room_bg=WORLD_TILES.HOODEDFOREST,
		background_room="BGGiantTrees",
		colour={r=.1,g=.1,b=.1,a=1}
	})

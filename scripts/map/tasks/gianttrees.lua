require ("map/rooms/forest/gianttreesrooms")
AddTask("GiantTrees", {
		locks={LOCKS.ADVANCED_COMBAT,LOCKS.MONSTERS_DEFEATED,LOCKS.TIER3},
		keys_given={KEYS.WALRUS,KEYS.TIER4},
		--region_id = "ricearea",
		level_set_piece_blocker = true,
		room_choices={
			["GiantTrees"] = function() return math.random(1,2) end, 
			["RoseGarden"] = 1,
			["AphidLand"] = 1,
			--["RoadGiantTrees"] = 1,
			["WalrusGiantTrees"] = 1,
			["MoonBaseGiantTrees"] = 1,
			["ShroomInfestedGiantTrees"] = 1,
			["SnapDragons"] = 1,
			["SpideryGiantTrees"] = 1,
			["HoodedTown"] = 1,
			["HFHolidays"] = 1,
		},
		room_bg=GROUND.HOODEDFOREST,
		background_room="BGGiantTrees",
		colour={r=.1,g=.1,b=.1,a=1}
	})
	AddTask("CaveGiantTrees", {
		locks={LOCKS.HF},
		keys_given={},
		--region_id = "ricearea",
		level_set_piece_blocker = true,
		room_choices={
			["GiantTrees"] = function() return math.random(1,2) end, 
			["RoseGarden"] = 1,
			["AphidLand"] = 1,
			--["RoadGiantTrees"] = 1,
			["WalrusGiantTrees"] = 1,
			["MoonBaseGiantTrees"] = 1,
			["ShroomInfestedGiantTrees"] = 1,
			["SnapDragons"] = 1,
			["SpideryGiantTrees"] = 1,
			["HoodedTown"] = 1,
			["HFHolidays"] = 1,
		},
		room_bg=GROUND.HOODEDFOREST,
		background_room="BGGiantTrees",
		colour={r=.1,g=.1,b=.1,a=1}
	})
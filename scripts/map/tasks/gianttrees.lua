require ("map/rooms/forest/gianttreesrooms")
AddTask("GiantTrees", {
		locks={LOCKS.ADVANCED_COMBAT,LOCKS.MONSTERS_DEFEATED,LOCKS.TIER3},
		keys_given={KEYS.WALRUS,KEYS.TIER4},
		--region_id = "ricearea",
		level_set_piece_blocker = true,
		room_choices={
			["GiantTrees"] = function() return 2 + math.random(1,2) end, 
			["SpideryGiantTrees"] = 1,
			--["RoadGiantTrees"] = 1,
			["WalrusGiantTrees"] = 1,
			["MoonBaseGiantTrees"] = 1,
			["ShroomInfestedGiantTrees"] = 1,
			["SnapDragons"] = 1,
		},
		room_bg=GROUND.JUNGLE,
		background_room="BGGiantTrees",
		colour={r=.1,g=.1,b=.1,a=1}
	}) 
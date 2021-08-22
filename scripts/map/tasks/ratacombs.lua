require ("map/rooms/caves/ratacombsrooms")

AddTask("Ratty_Entrance", {
		locks={},
		keys_given={KEYS.TIER1},
		region_id = "ratacombs",
		level_set_piece_blocker = true,
		room_tags = {"RoadPoison", "nohunt", "nohasslers","not_mainland"},
		room_choices={
			["RattyStairs"] = 1, 			
		},
		room_bg=GROUND.FOREST,
		colour={r=.1,g=.1,b=.1,a=1},
})

AddTask("Ratty_Link", {
		locks={LOCKS.TIER2},
		keys_given={KEYS.TIER3},
		region_id = "ratacombs",
		level_set_piece_blocker = true,
		room_tags = {"RoadPoison", "nohunt", "nohasslers","not_mainland"},
		entrance_room= "RattyWall",
		room_choices={
			["RatKingdomCaves"] = 1,
		},
		background_room="RattyLink",
		room_bg=GROUND.FOREST,
		colour={r=.1,g=.1,b=.1,a=1},
})

AddTask("Ratty_Maze", {
		locks={LOCKS.TIER1},
		keys_given={KEYS.TIER2},
		region_id = "ratacombs",
		level_set_piece_blocker = true,
		room_tags = {"RoadPoison", "nohunt", "nohasslers","not_mainland","rattygas", "ratkey1"},
		room_choices={
			["RattyWilds"] = function() return 3 + math.random(4) end,
			["RattyLock1"] = 1,
		},
		room_bg=GROUND.FOREST,
		background_room="BGRattyCaveRoom",
		colour={r=.1,g=.1,b=.1,a=1},
})
AddTask("Ratty_Maze2", {
		locks={LOCKS.TIER3},
		keys_given={},
		region_id = "ratacombs",
		level_set_piece_blocker = true,
		room_tags = {"RoadPoison", "nohunt", "nohasslers","not_mainland","rattygas"},
		room_choices={
			["DeepRattyWilds"] = 5,
		},
		room_bg=GROUND.FOREST,
		background_room="BGRattyCaveRoom",
		colour={r=.1,g=.1,b=.1,a=1},
})
AddTask("Ratty_Maze3", {
		locks={LOCKS.TIER3},
		keys_given={},
		region_id = "ratacombs",
		level_set_piece_blocker = true,
		room_tags = {"RoadPoison", "nohunt", "nohasslers","not_mainland","rattygas"},
		room_choices={
			["DeepRattyWilds"] = 5,
		},
		room_bg=GROUND.FOREST,
		background_room="BGRattyCaveRoom",
		colour={r=.1,g=.1,b=.1,a=1},
})
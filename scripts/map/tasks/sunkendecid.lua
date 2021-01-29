require ("map/rooms/forest/sunkdecidrooms")

AddTask("SunkDecid", {
		locks={LOCKS.ENTRANCE_OUTER},
		keys_given={},
		level_set_piece_blocker = true,
		room_choices={
			["SunkDecidExit"] = 1,
			["SunkDecid"] = 1, 			
		},
		room_bg=GROUND.HOODEDFOREST,
		background_room="SunkDecid",
		colour={r=.1,g=.1,b=.1,a=1},
	})

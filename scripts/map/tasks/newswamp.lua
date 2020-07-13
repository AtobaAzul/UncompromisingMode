require ("map/rooms/forest/extraswamp")
AddTask("RiceSqueltch", {
		locks={LOCKS.RICE},
		keys_given={},
		room_choices={
			--["Marsh"] = function() return 5+math.random(SIZE_VARIATION) end, 
			--["Forest"] = function() return math.random(SIZE_VARIATION) end, 
			--["DeepForest"] = function() return 1+math.random(SIZE_VARIATION) end,
			["ricepatch"]=1,
		},
		room_bg=GROUND.MARSH,
		background_room="BGMarsh",
		colour={r=.05,g=.05,b=.05,a=1}
	}) 
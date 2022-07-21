	AddRoom("ricepatch", 
	{
		colour={r=.6,g=.2,b=.8,a=.50},
		value = WORLD_TILES.MARSH,
		tags = {"RoadPoison"}, --"ForceDisconnected",
						contents =  {
										distributepercent = 0.1,
										distributeprefabs =
										{
											marsh_bush = 0.25,
											marsh_tree = 0.75,
											reeds = .7,
										},
										countprefabs =
										{
											marshmist = function() return math.random(4,6) end,
										},
									}
	})
	AddRoom("densericepatch", 
	{
		colour={r=.6,g=.2,b=.8,a=.50},
		value = WORLD_TILES.MARSH,
		tags = {"RoadPoison"}, --"ForceDisconnected",
						contents =  {
										distributepercent = 0.1,
										distributeprefabs =
										{
											marsh_bush = 0.25,
											marsh_tree = 0.75,
											reeds = .7,
										},
										countprefabs =
										{
											marshmist = function() return math.random(4,6) end,
										},
									}
	})
	AddRoom("sparsericepatch", 
	{
		colour = {r=1,g=1,b=1,a=.50}, 
		value = WORLD_TILES.OCEAN_COASTAL_SHORE,
		tags = {"RoadPoison"}, --"ForceDisconnected"
		type = NODE_TYPE.SeparatedRoom,
		contents =  
		{
			countprefabs =	
			{
				--riceplantspawner = function () return 1 + math.random(1,2) end,
				--seastack = function () return 1 + math.random(1,2) end,
				
		}
	}})
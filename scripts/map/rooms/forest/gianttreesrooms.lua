AddRoom("GiantTrees", 
{
	colour={r=.6,g=.2,b=.8,a=.50},
	value = GROUND.JUNGLE,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		sapling = 0.2,
		evergreen_sparse = 0.5,
		cave_fern = 0.5,
		blueberryplant = 0.1,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			
		}
}})
AddRoom("RoadGiantTrees", 
{
	colour={r=.6,g=.2,b=.8,a=.50},
	value = GROUND.JUNGLE,
	tags = {"hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		sapling = 0.2,
		evergreen_sparse = 0.5,
		cave_fern = 0.5,
		blueberryplant = 0.04,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			
		}
}})
AddRoom("BGGiantTrees", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.JUNGLE,
	tags = {"RoadPoison","hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		sapling = 0.2,
		evergreen_sparse = 0.5,
		cave_fern = 0.5,
		blueberryplant = 0.07,
		},
			countprefabs =	
		{
			
			giant_tree = function () return 6 + math.random(0,1) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			
		}
}})
AddRoom("SpideryGiantTrees", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.JUNGLE,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
			distributepercent = 0.001,
			distributeprefabs =
			{
				giant_tree = 0.01,
			},
			countprefabs =	
			{
			giant_tree = function () return 3 + math.random(0,1) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			widowwebspawner = 1 
			},
}})
AddRoom("SnapDragons", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.MUD,
	tags = {"RoadPoison","hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
			distributepercent = .05,
			distributeprefabs =
			{
				snapdragon = 0.02,
				cave_fern= 0.02,
				giant_tree = 0.005,
			},
			countprefabs =	
			{
			--snapdragon = function () return 3 + math.random(0,1) end,
			giant_tree = function () return 3 + math.random(0,1) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			},
}})
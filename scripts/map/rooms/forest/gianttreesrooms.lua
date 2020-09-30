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
		hooded_fern = 0.5,
		blueberryplantbuncher = 0.05,
		mushtree_medium = 0.05,
		hoodedtrapdoor = 0.05,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			pitcherplant = function () return math.random(1,2) end,
			
		}
}})
AddRoom("ShroomInfestedGiantTrees", 
{
	colour={r=.6,g=.2,b=.8,a=.50},
	value = GROUND.JUNGLE,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		sapling = 0.2,
		--evergreen_sparse = 0.5,
		hooded_fern = 0.5,
		mushtree_small = 0.3,
		mushtree_tall = 0.2,
		mushtree_medium = 0.3,
		hoodedtrapdoor = 0.015,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			pitcherplant = function () return math.random(0,1) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			
		}
}})
AddRoom("WalrusGiantTrees", 
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
		hooded_fern = 0.5,
		blueberryplantbuncher = 0.02,
		mushtree_small = 0.05,
		hoodedtrapdoor = 0.2,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			pitcherplant = function () return math.random(0,1) end,
			walrus_camp = 1,
			
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
		hooded_fern = 0.5,
		blueberryplantbuncher = 0.035,
		mushtree_tall = 0.05,
		},
			countprefabs =	
		{
			
			giant_tree = function () return 6 + math.random(0,1) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			pitcherplant = function () return math.random(0,1) end,
			
		}
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
				snapdragon = 0.2,
				hooded_fern= 0.02,
				giant_tree = 0.005,
			},
			countprefabs =	
			{
			snapdragon = 1,
			giant_tree = function () return 3 + math.random(0,1) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			},
}})
AddRoom("MoonBaseGiantTrees", {
					colour={r=.8,g=0.5,b=.6,a=.50},
					value = GROUND.JUNGLE,
					tags = { "RoadPoison","hoodedcanopy" },
					contents =  {
									countprefabs = {
										giant_tree = function () return 3 + math.random(0,1) end,
										extracanopyspawner = function () return 6 + math.random(0,1) end,
    									},
									countstaticlayouts={["MoonbaseOne"]=1},
									
					                distributepercent = .8,
					                distributeprefabs=
					                {
									sapling = 0.2,
									evergreen_sparse = 0.5,
									hooded_fern = 0.5,
									blueberryplantbuncher = 0.001,
									pitcherplant = 0.05,
					                },
					            }
					})
AddRoom("SpideryGiantTrees", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.JUNGLE,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
			distributepercent = 0.3,
			distributeprefabs =
			{
				giant_tree = 0.01,
				houndbone = 0.25,
				extracanopyspawner = 1,
				hooded_fern = 0.5,
			},
			countprefabs =	
			{
			giant_tree = function () return 3 + math.random(0,1) end,
			extracanopyspawner = function () return 6 + math.random(0,1) end,
			widowwebspawner = 1 
			},
}})
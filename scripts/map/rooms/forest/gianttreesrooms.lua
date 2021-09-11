AddRoom("GiantTrees", 
{
	colour={r=.6,g=.2,b=.8,a=.50},
	value = GROUND.HOODEDFOREST,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		sapling = 0.2,
		evergreen_sparse = 0.5,
		hooded_fern = 0.5,
		ghost_walrus = 0.005,
		blueberryplantbuncher = 0.05,
		hooded_mushtree_medium = 0.05,
		hoodedtrapdoor = 0.05,
		giant_tree_infested = 0.01,
		lightrays_canopy = 0.25,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			extracanopyspawner = function () return 10 + math.random(0,1) end,
			pitcherplant = function () return math.random(1,2) end,
			
		}
}})
AddRoom("AphidLand", 
{
	colour={r=.6,g=.2,b=.8,a=.50},
	value = GROUND.HOODEDFOREST,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		um_bear_trap_old = 0.05,
		sapling = 0.2,
		evergreen_sparse = 0.5,
		hooded_fern = 0.5,
		ghost_walrus = 0.05,
		blueberryplantbuncher = 0.05,
		hooded_mushtree_tall = 0.05,
		hoodedtrapdoor = 0.05,
		lightrays_canopy = 0.2,
		},
		
			countprefabs =	
		{
			giant_tree_infested = function () return 6 + math.random(1,2) end,
			extracanopyspawner = function () return 10 + math.random(0,1) end,
			pitcherplant = function () return math.random(1,2) end,
			
		}
}})
AddRoom("ShroomInfestedGiantTrees", 
{
	colour={r=.6,g=.2,b=.8,a=.50},
	value = GROUND.HOODEDFOREST,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		um_bear_trap_old = 0.01,
		distributepercent = 0.3,
		distributeprefabs = {
		sapling = 0.2,
		--evergreen_sparse = 0.5,
		hooded_fern = 0.5,
		hooded_mushtree_small = 0.3,
		hooded_mushtree_tall = 0.2,
		hooded_mushtree_medium = 0.3,
		ghost_walrus = 0.015,
		hoodedtrapdoor = 0.015,
		giant_tree_infested = 0.005,
		lightrays_canopy = 0.25,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			pitcherplant = function () return math.random(0,1) end,
			extracanopyspawner = function () return 10 + math.random(0,1) end,
			
		}
}})
AddRoom("SpideryGiantTrees", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.HOODEDFOREST,
	tags = {"RoadPoison", "hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
			distributepercent = 0.3,
			distributeprefabs =
			{
				um_bear_trap_old = 0.05,
				giant_tree = 0.01,
				houndbone = 0.25,
				ghost_walrus = 0.01,
				extracanopyspawner = 1,
				hooded_fern = 0.5,
				--giant_tree_infested = 0.006,
				--webbedcreature = 0.2,
				lightrays_canopy = 0.25,
			},
			countprefabs =	
			{
			giant_tree = function () return 3 + math.random(0,1) end,
			extracanopyspawner = function () return 10 + math.random(0,1) end,
			widowwebspawner = 1 
			},
}})
AddRoom("WalrusGiantTrees", 
{
	colour={r=.6,g=.2,b=.8,a=.50},
	value = GROUND.HOODEDFOREST,
	tags = {"hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		um_bear_trap_old = 0.1,
		sapling = 0.2,
		evergreen_sparse = 0.5,
		hooded_fern = 0.5,
		ghost_walrus = 0.5,
		blueberryplantbuncher = 0.02,
		hooded_mushtree_small = 0.05,
		hoodedtrapdoor = 0.2,
		giant_tree_infested = 0.005,
		lightrays_canopy = 0.25,
		},
		
			countprefabs =	
		{
			giant_tree = function () return 6 + math.random(1,2) end,
			extracanopyspawner = function () return 10 + math.random(0,1) end,
			pitcherplant = function () return math.random(0,1) end,
			walrus_camp = 1,
			
		}
}})
AddRoom("BGGiantTrees", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.HOODEDFOREST,
	tags = {"RoadPoison","hoodedcanopy"}, --"ForceDisconnected"
	contents =  
	{	
		distributepercent = 0.3,
		distributeprefabs = {
		sapling = 0.2,
		evergreen_sparse = 0.5,
		hooded_fern = 0.5,
		ghost_walrus = 0.005,
		blueberryplantbuncher = 0.035,
		hooded_mushtree_tall = 0.05,
		giant_tree_infested = 0.005,
		lightrays_canopy = 0.25,
		},
			countprefabs =	
		{
			
			giant_tree = function () return 6 + math.random(0,1) end,
			extracanopyspawner = function () return 10 + math.random(0,1) end,
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
				hooded_fern= 0.02,
				giant_tree = 0.005,
				giant_tree_infested = 0.005,
			},
			countprefabs =	
			{
			snapdragon = function () return 1 + math.random(3,4) end,
			giant_tree = function () return 3 + math.random(0,1) end,
			extracanopyspawner = function () return 10 + math.random(0,1) end,
			},
}})
AddRoom("MoonBaseGiantTrees", {
					colour={r=.8,g=0.5,b=.6,a=.50},
					value = GROUND.HOODEDFOREST,
					tags = { "RoadPoison","hoodedcanopy"},
					contents =  {
									countprefabs = {
										giant_tree = function () return 3 + math.random(0,1) end,
    									},
									countstaticlayouts={["MoonbaseOne"]=1},
									
					                distributepercent = .8,
					                distributeprefabs=
					                {
									sapling = 0.2,
									evergreen_sparse = 0.5,
									hooded_fern = 0.5,
									blueberryplantbuncher = 0.001,
									pitcherplant = 0.0001,
					                },
					            }
					})
AddRoom("HoodedTown", {
					colour={r=.8,g=0.5,b=.6,a=.50},
					value = GROUND.HOODEDFOREST,
					tags = { "RoadPoison","hoodedcanopy" },
					contents =  {
									countprefabs = {
										giant_tree = function () return 3 + math.random(0,1) end,
										extracanopyspawner = function () return 10 + math.random(0,1) end,
    									},
									
					                distributepercent = .4,
					                distributeprefabs=
					                {
									sapling = 0.2,
									evergreen_sparse = 0.4,
									hooded_fern = 0.3,
									ghost_walrus = 0.02,
									blueberryplantbuncher = 0.001,
									pitcherplant = 0.0001,
									lightrays_canopy = 0.25,
					                },
					            }
					})
AddRoom("RoseGarden", {
					colour={r=.8,g=0.5,b=.6,a=.50},
					value = GROUND.HOODEDFOREST,
					tags = { "RoadPoison","hoodedcanopy" },
					contents =  {
									countprefabs = {
										giant_tree = function () return 3 + math.random(0,1) end,
										extracanopyspawner = function () return 10 + math.random(0,1) end,
    									},
									
					                distributepercent = .4,
					                distributeprefabs=
					                {
									sapling = 0.2,
									evergreen_sparse = 0.4,
									hooded_fern = 0.3,
									ghost_walrus = 0.005,
									blueberryplantbuncher = 0.001,
									lightrays_canopy = 0.25,
					                },
					            }
					})
AddRoom("HFHolidays", {
					colour={r=.8,g=0.5,b=.6,a=.50},
					value = GROUND.HOODEDFOREST,
					tags = { "RoadPoison","hoodedcanopy" },
					contents =  {
									countprefabs = {
										giant_tree = function () return 3 + math.random(0,1) end,
										extracanopyspawner = function () return 10 + math.random(0,1) end,
    									},
									
					                distributepercent = .4,
					                distributeprefabs=
					                {
									um_bear_trap_old = 0.05,
									ghost_walrus = 0.006,
									sapling = 0.2,
									evergreen_sparse = 0.4,
									hooded_fern = 0.3,
									blueberryplantbuncher = 0.001,
									lightrays_canopy = 0.25,
					                },
					            }
					})
AddRoom("ricepatch", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.OCEAN_COASTAL_SHORE,
	tags = {"RoadPoison"}, --"ForceDisconnected"
	type = NODE_TYPE.SeparatedRoom,
	contents =  
	{	
		
--[[		countprefabs =	
		{
			riceplantspawner = function () return 3 + math.random(2,3) end,
			--seastack = 1,
			
		}]]
			distributepercent = 0.4,
			distributeprefabs =
			{
				riceplantspawner = 1,
			},
}})
AddRoom("densericepatch", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.OCEAN_COASTAL_SHORE,
	tags = {"RoadPoison"}, --"ForceDisconnected"
	type = NODE_TYPE.SeparatedRoom,
	contents =  
	{
		countprefabs =	
		{
			riceplantspawner = function () return 5 + math.random(4,5) end,
			
	}
}})
AddRoom("sparsericepatch", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.OCEAN_COASTAL_SHORE,
	tags = {"RoadPoison"}, --"ForceDisconnected"
	type = NODE_TYPE.SeparatedRoom,
	contents =  
	{
		countprefabs =	
		{
			riceplantspawner = function () return 1 + math.random(1,2) end,
			--seastack = function () return 1 + math.random(1,2) end,
			
	}
}})
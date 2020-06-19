AddRoom("veteranshrine", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.ROCKY,
	contents =  
	{
		countprefabs =	
		{
			veteranshrine = 1,
			rock1 = function () return 3 + math.random(2,5) end,
			houndbone = function () return 1 + math.random(1,4) end,
			sapling= function () return 1 + math.random(0,1) end,
			
	}
}})
AddRoom("nearveteranshrine", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = GROUND.ROCKY,
	contents =  
	{
		countprefabs =	
		{
			rock1 = function () return 3 + math.random(1,2) end,
			houndbone = function () return math.random(0,1) end,
			sapling= function () return 1 + math.random(1,3) end,
			
	}
}})
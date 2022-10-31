require "map/room_functions"

local Layouts = require ("map/layouts").Layouts
local StaticLayout = require ("map/static_layout")

AddRoom("veteranshrine", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = WORLD_TILES.ROCKY,
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
	value = WORLD_TILES.ROCKY,
	contents =  
	{
		countprefabs =	
		{
			rock1 = function () return 3 + math.random(1,2) end,
			houndbone = function () return math.random(0,1) end,
			sapling= function () return 1 + math.random(1,3) end,
			
	}
}})
AddRoom("veteranshrine_ia", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = WORLD_TILES.MAGMAFIELD,
	contents =  
	{
		countprefabs =	
		{
			veteranshrine = 1,
			magmarock = function () return 3 + math.random(2,5) end,
			magmarock_full = function () return 1 + math.random(1,4) end,
			sapling= function () return 1 + math.random(0,1) end,
			
	}
}})

AddRoom("nearveteranshrine_ia", 
{
	colour = {r=1,g=1,b=1,a=.50}, 
	value = WORLD_TILES.MAGMAFIELD,
	contents =  
	{
		countprefabs =	
		{
			magmarock = function () return 3 + math.random(1,2) end,
			magmarock_full = function () return math.random(0,1) end,
			sapling= function () return 1 + math.random(1,3) end,
			
	}
}})


Layouts["wixie_puzzle"] = StaticLayout.Get("map/static_layouts/wixie_puzzle")
AddRoom("wixie_puzzlearea", 
{
					colour={r=0,g=.9,b=0,a=.50},
					value = WORLD_TILES.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone","Astral_1"},
					contents =  {
					                countprefabs =
					                {
					                    deerspawningground = 1,
					                },
									countstaticlayouts={
										["wixie_puzzle"] = 1,
									},
					                distributepercent = .4,
					                distributeprefabs=
					                {
					                    grass = .03,
					                    sapling=1,
					                    twiggytree=0.4,
					                    berrybush=.1,
					                    berrybush_juicy = 0.05,

					                    deciduoustree = 10,
					                    catcoonden = .05,

					                    red_mushroom = 0.15,
					                    blue_mushroom = 0.15,
					                    green_mushroom = 0.15,

                                        fireflies = 3,

					                },
					            }
})

AddRoom("wixie_puzzlearea_ia", 
{
					colour={r=0,g=.9,b=0,a=.50},
					value = WORLD_TILES.JUNGLE,
					tags = {"ExitPiece", "Packim_Fishbone", "Terrarium_Spawner_Shipwrecked"},
					contents =  {

									countstaticlayouts={
										["wixie_puzzle"] = 1,
									},
									distributepercent = .2,
									distributeprefabs = {
										fireflies = 0.2,
										jungletree = 1,
										rock1 = 0.03,
										flint = 0.03,
										grass = .03,
										flower = 0.75,
										bambootree = .5,
									},				
					            }
})

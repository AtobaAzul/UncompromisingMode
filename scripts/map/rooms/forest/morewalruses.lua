AddRoom("WalrusHut_Deciduous", {
					colour={r=.1,g=.8,b=.1,a=.50},
					value = GROUND.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone","Astral_2"},
					contents =  {
					                countprefabs= {
					                    pumpkin = function () return IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and (0 + math.random(3)) or 0 end,
					                    deerspawningground = 1,
										walrus_camp = 1,
					                },

					                distributepercent = .2,
					                distributeprefabs=
					                {
										deciduoustree=6,

										pighouse=.1,
										catcoonden=.1,

										rock1=0.05,
										rock2=0.05,

										sapling=1,
					                    twiggytree=0.4,
										grass=0.03,								

										flower=0.75,

					                    red_mushroom = 0.3,
					                    blue_mushroom = 0.3,
					                    green_mushroom = 0.3,
										berrybush=0.1,
										berrybush_juicy = 0.05,
										carrot_planted = 0.1,

										fireflies = 1,

										pond=.01,
					                },
					            }
					})
					
AddRoom("WalrusHut_Badlands", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.DIRT_NOISE,
					contents =  {	
					                countprefabs= {
										walrus_camp = 1,
					                },
									distributepercent = 0.07,
									distributeprefabs =
									{
										marsh_bush = 0.05,
										marsh_tree = 0.2,
										rock_flintless = 1,
										--rock_ice = .5,
										grass = 0.1,
										grassgekko = 0.4,
										houndbone = 0.2,
										cactus = 0.2,
										tumbleweedspawner = .05,
									},
					            }
					})
					
AddRoom("WalrusHut_Oasis", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.DIRT_NOISE,
					tags = {"RoadPoison", "sandstorm"},
					contents =  {
					                countprefabs= {
										walrus_camp = 1,
					                },
									distributepercent = 0.06,
									distributeprefabs =
									{
										marsh_bush = 0.15,
										houndbone = 0.2,
										oasis_cactus = 0.02,
										buzzardspawner = .05,
									},
					            }
					})

AddRoom("WalrusHut_Marsh", {
					colour={r=.45,g=.75,b=.45,a=.50},
					value = GROUND.MARSH,
					tags = {"ExitPiece", "Chester_Eyebone", "Astral_2"},
					contents =  {
									countstaticlayouts={["MushroomRingMedium"]=function()  
																				if math.random(0,1000) > 985 then 
																					return 1 
																				end
																				return 0 
																			   end},
					                countprefabs= {
										walrus_camp = 1,
					                },
					                distributepercent = .1,
					                distributeprefabs=
					                {
					                    evergreen = 1.0,
					                    tentacle = 3,
					                    pond_mos = 1,
					                    reeds =  4,--function () return 3 + math.random(4) end,
					                    --TODO: jcheng: fix mandrakes
					                    --mandrake=0.0001,
					                    spiderden=.01,
					                    blue_mushroom = 0.01,
					                    green_mushroom = 2.02,
					                },
					            }
					})
AddRoom("RatKingdom", {
					colour={r=.5,g=0.6,b=.080,a=.10},
					value = GROUND.GROUND_NOISE,
					--tags = {"Chester_Eyebone"},
					contents =  {
									countprefabs = {
    										ratking = 1,
											uncompromising_ratburrow = function() return math.random(8, 12) end,
    									},
					                distributepercent = .5,
					                distributeprefabs =
					                {
										rock1 = .8,
										rock2 = .1,
										goldnugget = .1,
										flint = .1,
                                        fireflies = 0.2,
					                    red_mushroom = .03,
					                    green_mushroom = .02,
					                    blue_mushroom = .002,
										trees = {weight = 6, prefabs = {"evergreen", "evergreen_sparse"}},
					                },
					            }
					})
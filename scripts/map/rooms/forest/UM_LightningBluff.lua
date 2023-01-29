
AddRoom("LightningBluff_Scorpion", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = WORLD_TILES.DIRT_NOISE,
					tags = {"RoadPoison", "sandstorm"},
					contents =  {
									distributepercent = 0.06,
									distributeprefabs =
									{
										marsh_bush = 0.15,
										rock_flintless = .5,
										houndbone = 0.2,
										oasis_cactus = 0.2,
										buzzardspawner = .05,
									},
									countprefabs = 
									{ 
										um_scorpionhole_organizer = 1,
										um_scorpionhole = math.random(0,1),
									},
					            },
})

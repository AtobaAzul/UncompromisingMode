local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WAXWELL = {"codexumbra", "nightmarefuel", "nightmarefuel", "nightmarefuel", "nightmarefuel", "nightmarefuel", "nightmarefuel"}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["codexumbra"] =
	{
		atlas = "images/inventoryimages/codexumbra.xml",
		image = "codexumbra.tex",
	}
	
TUNING.SHADOWWAXWELL_FUEL_COST = 2
TUNING.SHADOWWAXWELL_HEALTH_COST = -15

TUNING.SHADOWWAXWELL_SANITY_PENALTY =
        {
            SHADOWLUMBER = .2,
            SHADOWMINER = .2,
            SHADOWDIGGER = .2,
            SHADOWDUELIST = .35,
			OLD_SHADOWWAXWELL = .275,
        }
		
TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY = 55

env.AddPrefabPostInit("waxwell", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst:RemoveTag("shadowmagic")
	inst:AddTag("codexumbrareader")

end)


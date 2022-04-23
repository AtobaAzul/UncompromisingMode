
function setup_custom_loading_tips()

	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_FIREREWORK", "\"Burning monsters is more fun when they leave more than ash behind!\" -W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_TOPHAT", "\"I had left the top hat behind with my old act, but it's still good for a magic trick or two.\" -M")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_AMALGAMS", "\"Whoever designed these clockwork thingamawatzits should have installed a surge protector!\" -W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RNES", "\"Sometimes, I feel like something is watching us night...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_MOONMAW", "Like a moth to flame, she flew too close to the moon. But unlike Icarus, her story doesn't end there.")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_MUTATIONS", "The King of Winter has invited some extended family over for the season.")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RUINS", "The Shadows are stirring, and long buried clock works have resurfaced. Keep your wits about you.")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_CONFIGS", "Not a fan of some changes? Need a change of pace? Check out Uncompromising Modes configurable options!" )
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_WIKI", "Confused with anything? Visit the Uncompromising Mode Wiki! Just don't trust EVERYTHING you see online..." )
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RATS_FOODSCORE", "\"Our rations appear to be attracting unwanted attention. I should get rid of our stale food...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RATS_ITEMSCORE", "\"The vermin have noticed the mess around camp, I really should do a bit of Spring cleaning...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RATS_BURROWBONUS", "\"I've spotted a rat den where there wasn't one before, I think they are multiplying, and fast!\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_SNOWPILES", "\"Something is watching me from mounds of snow, I should dig them up before we find out what's inside...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_SPIDERS", "\"LEAPING SPIDERS MAKE GOOD TARGET PRACTICE\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_WINTERSMOLDERING", "\"It is so cold... I can't get a fire going.\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_UNHAPPYTOMATO", "\"My tomato harvest seems to have shortened this fall, I guess they're feeling under the weather.\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_AURACLOPS", "The ice walls certain Deerclops make can be mined, and some are more brittle than others.")

	local tipcategorystartweights =
	{
		CONTROLS = 0.2,
		SURVIVAL = 0.2,
		LORE = 0.2,
		LOADING_SCREEN = 0.2,
		OTHER = 0.2,
	}

	SetLoadingTipCategoryWeights(GLOBAL.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START, tipcategorystartweights)

	local tipcategoryendweights =
	{
		CONTROLS = 0,
		SURVIVAL = 0,
		LORE = 0,
		LOADING_SCREEN = 0,
		OTHER = 1,
	}
  --UM tips are guaranteed on the second tip during the loading screen.
	SetLoadingTipCategoryWeights(GLOBAL.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END, tipcategoryendweights)

	-- Loading tip icon
	SetLoadingTipCategoryIcon("OTHER", "images/UM_tip_icon.xml", "UM_tip_icon.tex")

	GLOBAL.TheLoadingTips = require("loadingtipsdata")()

	-- Recalculate loading tip & category weights.
	local TheLoadingTips = GLOBAL.TheLoadingTips
	TheLoadingTips.loadingtipweights = TheLoadingTips:CalculateLoadingTipWeights()
    TheLoadingTips.categoryweights = TheLoadingTips:CalculateCategoryWeights()

	GLOBAL.TheLoadingTips:Load()
end

-- We need to call this directly instead of in AddGamePostInit() because the loading screen appears before calling that function.
setup_custom_loading_tips()










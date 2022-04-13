
function setup_custom_loading_tips()

	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_FIREREWORK", "\"Burning creatures is way more fun when you get more than ash afterwards!\" -W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_TOPHAT", "\"I thought I left the top hat behind with my old act, but apparently it's still good for the odd magic trick or two.\" -M")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_AMALGAMS", "\"I cracked open some of those clockwork thingamawatzits, and I got to say. Whoever designed these things didn't put any sort of surge protector in.\" -W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RNES", "\"Sometimes, I feel like I'm being watch at night...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_MOONMAW", "Dragonfly once flew too close too the moon. But unlike Icarus, her story doesn't end there.")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_MUTATIONS", "Deerclops has invited some extended family over for the winter.")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RUINS", "Something's stirred in the ruins. Keep your wits about you.")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_CONFIGS", "Don't forget a lot of things in Uncompromising Mode are configurable!" )
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_WIKI", "Confused with anything? Visit the Uncompromising Mode Wiki! Just watch out for outdated warnings, not everything is up to date just yet." )
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RATS_FOODSCORE", "\"Our rations appear to attracting unwanted attention. I should get rid of our stale food...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RATS_ITEMSCORE", "\"It seems those rats I've spotted like the mess in our camp, I really should do a bit of Spring cleaning...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_RATS_BURROWBONUS", "\"I've spotted a den of rats, they are multipying in the wilderness, and fast!\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_SNOWPILES", "\"There is something watching me from the snowpiles, I should dig them up before we find out what's inside...\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_SPIDERS", "\"Ha! Weak spider can't jump past might of heavy smack!\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_WINTERSMOLDERING", "\"It is so cold... I can't get a fire going.\" - W")
	AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_UNHAPPYTOMATO", "\"My tomato harvest seems to have shortened this autumn, I guess they're feeling under the weather.\" - W")
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










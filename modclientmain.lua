PrefabFiles = {
	"winky_none",
	"wathom_none",
	"wixie_none"
}

Assets = {
	Asset("ANIM", "anim/winky.zip"),
	Asset("ANIM", "anim/ghost_winky_build.zip"),
--	Asset("ANIM", "anim/wathom.zip"),
--	Asset("ANIM", "anim/ghost_wathom_build.zip"),    -- Commented out because the standalone mod doesn't load these and works fine.

	Asset( "IMAGE", "bigportraits/winky.tex" ),
    Asset( "ATLAS", "bigportraits/winky.xml" ),
    Asset( "IMAGE", "bigportraits/wathom.tex" ),
    Asset( "ATLAS", "bigportraits/wathom.xml" ),

    Asset( "IMAGE", "bigportraits/winky_none_oval.tex" ),
    Asset( "ATLAS", "bigportraits/winky_none.xml" ),
    Asset( "IMAGE", "bigportraits/wathom_none.tex" ),
    Asset( "ATLAS", "bigportraits/wathom_none.xml" ),

    Asset( "IMAGE", "images/saveslot_portraits/winky.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/winky.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/wathom.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wathom.xml" ),

    Asset( "IMAGE", "images/names_gold_winky.tex" ),
    Asset( "ATLAS", "images/names_gold_winky.xml" ),
	Asset( "IMAGE", "images/names_gold_wathom.tex" ),
    Asset( "ATLAS", "images/names_gold_wathom.xml" ),


	Asset("ANIM", "anim/wixie.zip"),
	Asset("ANIM", "anim/ghost_wixie_build.zip"),

	Asset( "IMAGE", "bigportraits/wixie.tex" ),
    Asset( "ATLAS", "bigportraits/wixie.xml" ),

    Asset( "IMAGE", "bigportraits/wixie_none_oval.tex" ),
    Asset( "ATLAS", "bigportraits/wixie_none.xml" ),

    Asset( "IMAGE", "images/saveslot_portraits/wixie.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wixie.xml" ),

    Asset( "IMAGE", "images/names_gold_wixie.tex" ),
    Asset( "ATLAS", "images/names_gold_wixie.xml" ),

    Asset("IMAGE", "images/inventoryimages/meatrack_hat.tex" ),
    Asset("ATLAS", "images/inventoryimages/meatrack_hat.xml"),
}

local STRINGS = GLOBAL.STRINGS

-- Winky

STRINGS.NAMES.WINKY = "Winky"
STRINGS.SKIN_NAMES.winky_none = "Winky"
STRINGS.SKIN_DESCRIPTIONS.winky_none = "Despite the rumors, Winky bathes frequently."

STRINGS.CHARACTER_TITLES.winky = "The Vile Vermin"
STRINGS.CHARACTER_NAMES.winky = "Winky"
STRINGS.CHARACTER_DESCRIPTIONS.winky = "*Is a Rat\n*Can dig interconnected burrows\n*'Is weak, but fast'\n*Can eat horrible foods\n*Hates to lose hold of things"
STRINGS.CHARACTER_QUOTES.winky = "\"Squeak!\""
STRINGS.CHARACTER_ABOUTME.winky = "She's a rat."
STRINGS.CHARACTER_BIOS.winky = {
 { title = "Birthday", desc = "April 1" },
 { title = "Favorite Food", desc = "Powdercake" },
 { title = "Her Past...", desc = "Is yet to be revealed."},
}

STRINGS.CHARACTER_SURVIVABILITY.winky= "Stinky"

TUNING.WINKY_HEALTH = 175
TUNING.WINKY_HUNGER = 150
TUNING.WINKY_SANITY = 125

-- Wathom

STRINGS.NAMES.wathom = "Wathom"
STRINGS.SKIN_NAMES.wathom_none = "Wathom"
STRINGS.SKIN_DESCRIPTIONS.wathom_none = "An inadequate attempt to revive the ones who came before him."

STRINGS.CHARACTER_TITLES.wathom = "The Forgotten Parody"
STRINGS.CHARACTER_NAMES.wathom = "Wathom"
STRINGS.CHARACTER_DESCRIPTIONS.wathom = "*Apex Predator\n*Gets amped up with adrenaline\n*Causes animals to panic\n*The faster he goes, the harder he falls"
STRINGS.CHARACTER_QUOTES.wathom = "\"I HEAR YOU BREATHING.\""
STRINGS.CHARACTER_ABOUTME.wathom = "A hunter with an uncontrollable surplus of energy, Wathom lives on after crawling out of the Abyss he was imprisoned in."
STRINGS.CHARACTER_BIOS.wathom = {
 { title = "Birthday", desc = "January 20" },
 { title = "Favorite Food", desc = "Hardshell Tacos" },
 { title = "From the Abyss", desc = "The civilization that once occupied the ruins always piqued Maxwell's curiosity. Even he on the throne didn't know all the secrets buried within the Constant. Using dusted bones and nightmare fuel, the Shadow King breathed life into a mimic of the ancient race, with the purpose to understand those who came before them. \n \nWathom never knew anything other than dank caverns and pulsating ruins - and when he didn't provide the secrets that he was born to uncover, the only thing he knew from then on was the indefinite darkness of the Abyss, banished and forgotten. At least, until the fallen moon provided climbable cracks in the walls."},
}
STRINGS.CHARACTER_SURVIVABILITY.wathom = "Slim"

TUNING.WATHOM_HEALTH = 200
TUNING.WATHOM_HUNGER = 120
TUNING.WATHOM_SANITY = 120

STRINGS.NAMES.WIXIE = "Wixie"
STRINGS.SKIN_NAMES.wixie_none = "Wixie"
STRINGS.SKIN_DESCRIPTIONS.wixie_none = "A troubled youth that gets up to trouble."

STRINGS.CHARACTER_TITLES.wixie = "The Delinquent"
STRINGS.CHARACTER_NAMES.wixie = "Wixie"
STRINGS.CHARACTER_DESCRIPTIONS.wixie = "*Good with a slingshot\n*Has a mighty shove\n*Is Claustrophobic"
STRINGS.CHARACTER_QUOTES.wixie = "\"It wasn't me!\""
STRINGS.CHARACTER_ABOUTME.wixie = "Some say Wixies abrasive attitude is a cover for her insecurities. These people tend to be on the receiving end of her slingshot."
STRINGS.CHARACTER_BIOS.wixie = {
 { title = "Birthday", desc = "March 23" },
 { title = "Favorite Food", desc = "Boomberry Pancakes" },
 { title = "All Good Things...", desc = "Growing up can hurt, and few know it better than Wixie. As long as she could remember she would see shadows in the corner of her eye, and hear whispers in the dark when she felt surrounded. After tragedy struck her family, her fears, and her abrasive attitude grew, as she further pushed people away. This cycle continued, gaining the attention of a dark force from beyond. Now, she finds herself in the Constant, free from the confines of her old life, but more trapped than ever before."},
}

STRINGS.CHARACTER_SURVIVABILITY.wixie= "Grim"

TUNING.WIXIE_HEALTH = 130
TUNING.WIXIE_HUNGER = 150
TUNING.WIXIE_SANITY = 200

--Wixie + Walter

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WIXIE = {"slingshot", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock"}

STRINGS.CHARACTER_DESCRIPTIONS.walter = "*Not afraid of anything, except getting hurt\n󰀕Is a master of survival tactics\n󰀕Is an expert dog trainer\n*Allergic to bees\n*Has no interest in fashion"

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WALTER = {"walterhat", "meatrack_hat", "meat", "monstermeat"}

TUNING.STARTING_ITEM_IMAGE_OVERRIDE["meatrack_hat"] = {
    atlas = "images/inventoryimages/meatrack_hat.xml",
    image = "meatrack_hat.tex",
}

AddModCharacter("winky", "FEMALE")
AddModCharacter("wathom", "MALE")
AddModCharacter("wixie", "FEMALE")

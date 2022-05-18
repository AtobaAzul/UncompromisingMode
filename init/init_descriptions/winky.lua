local require = GLOBAL.require

GLOBAL.STRINGS.CHARACTERS.WINKY = require "speech_winky"

ANNOUNCE = GLOBAL.STRINGS.CHARACTERS.WINKY
DESCRIBE = GLOBAL.STRINGS.CHARACTERS.WINKY.DESCRIBE
ACTIONFAIL = GLOBAL.STRINGS.CHARACTERS.WINKY.ACTIONFAIL

--	[ 		Wilson Descriptions		]   --

    ANNOUNCE.ANNOUNCE_HARDCORE_RES = "Hearts aren't part of ghost anatomy!"
    ANNOUNCE.ANNOUNCE_WINONAGEN = "That's not really my thing."
    ANNOUNCE.ANNOUNCE_RATRAID = "I can hear my family."
    ANNOUNCE.ANNOUNCE_RATRAID_SPAWN = "Take everything!"
    ANNOUNCE.ANNOUNCE_RATRAID_OVER = "Hey, my stuff!"
    ANNOUNCE.ANNOUNCE_ACIDRAIN = {
        "The rain, it burns!",
        "Ack, acid rain!",
        "I need shelter!",
    }
    ANNOUNCE.ANNOUNCE_TOADSTOOLED = "There's fungus among us!"
	--FoodBuffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LESSERELECTRICATTACK = ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICRETALIATION = ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_FROZENFURY = "ssSsooo cCccold."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_VETCURSE = "I feel.. Vulnerable..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_LESSERELECTRICATTACK = ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICRETALIATION = ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_FROZENFURY = "Feeling better now"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_VETCURSE = "I'm glad that's over!"
	ANNOUNCE.ANNOUNCE_RNEFOG = "I feel like I'm being watched."
	--FoodBuffs
	
	--CaliforniaKing
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_CALIFORNIAKING = "Ahahah ha ha ahh."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_CALIFORNIAKING = "I can almost feel my nose again."
	DESCRIBE.CALIFORNIAKING = "Ooooo, this is nice."
	--CaliforniaKing
	
	--Content Creators
	DESCRIBE.CCTRINKET_DON = "I can only make out the words \"Don\" and \"Guide\"."
	DESCRIBE.CCTRINKET_JAZZY = "Looks pretty jazzy."
	DESCRIBE.CCTRINKET_FREDDO = "The name \"Freddo\" is etched onto it."		
	--Content Creators
    DESCRIBE.UNCOMPROMISING_RAT = "Hello."
    DESCRIBE.UNCOMPROMISING_RATHERD = "It must lead to their labo-rat-ory."
    DESCRIBE.UNCOMPROMISING_RATBURROW = "It must lead to their labo-rat-ory."
    DESCRIBE.RATPOISONBOTTLE = "It's labeled \"Do not drink. That means you, Webber.\""
    DESCRIBE.RATPOISON = "Yuck! Are you trying to kill me?"

    DESCRIBE.MONSTERSMALLMEAT = "Small, angry meat."
    DESCRIBE.COOKEDMONSTERSMALLMEAT = "...it's still purple meat."
    DESCRIBE.MONSTERSMALLMEAT_DRIED = "What a little jerk."

    DESCRIBE.MUSHROOMSPROUT_OVERWORLD = "There's the source of the pestilence!"
    DESCRIBE.TOADLING = "It sure likes those weird trees."
	DESCRIBE.UNCOMPROMISING_TOAD = "That toads looking pretty sick."
	
    DESCRIBE.GASMASK = "Now I can breathe anywhere."
	DESCRIBE.MOCK_DRAGONFLY = DESCRIBE.DRAGONFLY
	DESCRIBE.MOTHERGOOSE = DESCRIBE.MOOSE
	DESCRIBE.SPIDERQUEENCORPSE = "That's really gross."
	ANNOUNCE.ANNOUNCE_SNEEZE = "AHHH CHOOOO!"
	ANNOUNCE.ANNOUNCE_HAYFEVER = "My nose feels.. itchy."
	ANNOUNCE.ANNOUNCE_HAYFEVER_OFF = "I don't want to claw my eyes out anymore."
	ANNOUNCE.ANNOUNCE_FIREFALL = {
		"It sure is heating up around here.",
		"Geez, that guys getting loud!",
		"I've got a bad feeling about this.",
	}
	ANNOUNCE.ANNOUNCE_ROOTING = "I'm stuck!"
	ANNOUNCE.ANNOUNCE_SNOWSTORM = "The winds picking up..."
	ANNOUNCE.ANNOUNCE_OVER_EAT =
	{
		STUFFED = "I am so big and round!",
		OVERSTUFFED = "",
    }
    ANNOUNCE.CURSED_ITEM_EQUIP = "GAHH!"
    DESCRIBE.VETSITEM = "It whispers, wants me to talk to skeleton man."
	DESCRIBE.SCREECHER_TRINKET = "Little dolly thing."
	
	DESCRIBE.SAND = "Powder dust."
	DESCRIBE.SANDHILL = "Dust hill."
	DESCRIBE.SNOWPILE = "Snow hill."
	DESCRIBE.SNOWGOGGLES = "Snoggles."
	
	DESCRIBE.SNOWMONG = "Snow Seal."
	DESCRIBE.SHOCKWORM = "Quite the conductive worm!"
	DESCRIBE.ZASPBERRY = "I can feel the electricity flowing through it."
	DESCRIBE.ZASPBERRYPARFAIT = "It makes my fur erect."
	DESCRIBE.ICEBOOMERANG = "Almost stuck to my tongue."
	
	DESCRIBE.MINOTAUR_BOULDER = "Rock."
	DESCRIBE.MINOTAUR_BOULDER_BIG = "Rock again."
	DESCRIBE.BUSHCRAB = "Give me your berries!"
	DESCRIBE.LAVAE2 = DESCRIBE.LAVAE
	DESCRIBE.DISEASECUREBOMB = "Sack of rock oils."
	DESCRIBE.TOADLINGSPAWNER = "smells smelly."
	DESCRIBE.VETERANSHRINE = "Why are you speaking..."
	DESCRIBE.WICKER_TENTACLE = "Green and slimier."
	DESCRIBE.HONEY_LOG = "Crunchy and sweet, like beetles."
	
	DESCRIBE.RAT_TAIL = "What's the problem? We all die from time to time."
	DESCRIBE.PLAGUEMASK = "Why would I want to smell nice things."
	DESCRIBE.SALTPACK = "AAH, I think It got my EYE!"
	DESCRIBE.SPOREPACK = "We do a little bit of farding, we do a little Farding, yes."
	DESCRIBE.SNOWBALL_THROWABLE = "Haha, I wish I had thumbs sooner."
	DESCRIBE.SPIDER_TRAPDOOR = "Go back in your ugly hole."
	DESCRIBE.TRAPDOOR = "Nothing out of the ordinary here."
	DESCRIBE.HOODEDTRAPDOOR = DESCRIBE.TRAPDOOR 
	DESCRIBE.SHROOM_SKIN_FRAGMENT = "."
	DESCRIBE.AIR_CONDITIONER = "Smells terrible!"
	
	DESCRIBE.SCORPION = "Crush it."
	DESCRIBE.SCORPIONCARAPACE = "Tastes funny."
	DESCRIBE.SCORPIONCARAPACECOOKED = "It's not that bad, really."
	DESCRIBE.HARDSHELLTACOS = "Mmmm so Crunchy."
	
	DESCRIBE.SKELETONMEAT = "Flesh is flesh. Where do I draw the line?"
	DESCRIBE.CHIMP = DESCRIBE.MONKEY
	DESCRIBE.SWILSON = "Which one are you again?"
	DESCRIBE.VAMPIREBAT = "Bat two."
	DESCRIBE.CRITTERLAB_REAL = DESCRIBE.CRITTERLAB
	DESCRIBE.CRITTERLAB_REAL_BROKEN = "I should leave it like that."
	DESCRIBE.SLINGSHOTAMMO_FIRECRACKERS = DESCRIBE.FIRECRACKERS
	DESCRIBE.CHARLIEPHONOGRAPH_100 = DESCRIBE.MAXWELLPHONOGRAPH
	DESCRIBE.WALRUS_CAMP_SUMMER = DESCRIBE.WALRUS_CAMP
	
	--Swampyness
	DESCRIBE.RICEPLANT = "Crunchy little things."
	DESCRIBE.RICE = "Crunchy little things."
	DESCRIBE.RICE_COOKED = "OH, you're supposed to cook them."
	DESCRIBE.SEAFOODPAELLA = "Dish of Fish."
	
	DESCRIBE.STUMPLING = "Smash it with a hammer!"
	DESCRIBE.BIRCHLING = DESCRIBE.STUMPLING
	DESCRIBE.BUGZAPPER = "Stingy Thingy."
	DESCRIBE.MOON_TEAR = "I think the moon is upset at it's missing piece. Let's keep this safe."
	DESCRIBE.SHADOW_TELEPORTER = "Hey! Let go of that gem!"
	DESCRIBE.POLLENMITEDEN = "Science says it mite be dangerous."
    DESCRIBE.POLLENMITES = "I mite want to keep my distance."
    DESCRIBE.SHADOW_CROWN = "I feel un-safer already."
    DESCRIBE.RNEGHOST = DESCRIBE.GHOST
	DESCRIBE.LICELOAF = "I'll keep it for later."
	DESCRIBE.SUNGLASSES = "Eye Darkner."
	DESCRIBE.TRAPDOORGRASS = DESCRIBE.GRASS
	DESCRIBE.LUREPLAGUE_RAT = "They're rat..tal... Oh no."
	DESCRIBE.MARSH_GRASS = "Shushhshhh, be quiet..."
	DESCRIBE.CURSED_ANTLER = "Bash heads ahahaha."
	DESCRIBE.BERNIEBOX = "Box I can open with my teefth."
	DESCRIBE.HOODED_FERN = "It is green."
	DESCRIBE.HOODEDWIDOW = "Who invited you!"
	DESCRIBE.GIANT_TREE = "I should climb up it, and eat baby birds."
	DESCRIBE.WIDOWSGRASP =  "haha, my personal toothpick."
	DESCRIBE.WEBBEDCREATURE = "It wouldn't hurt to see what's inside, right?"
	ANNOUNCE.WEBBEDCREATURE = "Only a spider could rip through silk this tough!"
	DESCRIBE.SNAPDRAGON_BUDDY = "It looks hungry. Me too."
	DESCRIBE.SNAPDRAGON = "It looks nice enough."
	DESCRIBE.SNAPPLANT = "A little piece of home."
	DESCRIBE.WHISPERPOD = "Lets see what happens when you put it in the ground."
	DESCRIBE.WHISPERPOD_NORMAL_GROUND =
	{
		GENERIC = "Huh, do something.",
		GROWING = "The root is coming!",
	}
	DESCRIBE.FRUITBAT = "Agh, it's still terrifying!"
	DESCRIBE.PITCHERPLANT = "Must climb to it."
	DESCRIBE.APHID = "Get out of here, our home now."
	DESCRIBE.GIANT_TREE_INFESTED = "Don't blame us."
	DESCRIBE.GIANT_BLUEBERRY = "This'll be messy, for sure."
	DESCRIBE.STEAMEDHAMS = ""
	DESCRIBE.BLUEBERRYPANCAKES = ""
	DESCRIBE.SIMPSALAD = "Greens."
	DESCRIBE.BEEFALOWINGS = "I'm sure the beefalo didn't mind."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_KNOCKBACKIMMUNE = "Never gonna knock me down."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_KNOCKBACKIMMUNE = "My legs are getting flimsy again."
	ANNOUNCE.WIDOWSHEAD = "My eyes are fine with out this."
	DESCRIBE.HOODED_MUSHTREE_TALL = DESCRIBE.MUSHTREE_TALL
	DESCRIBE.HOODED_MUSHTREE_MEDIUM = DESCRIBE.MUSHTREE_MEDIUM
	DESCRIBE.HOODED_MUSHTREE_SMALL = DESCRIBE.MUSHTREE_SMALL
	DESCRIBE.WATERMELON_LANTERN = "Why would you do this."
	DESCRIBE.SNOWCONE = "Why would anyone eat snow."
	
	--Viperstuff Quotes
	DESCRIBE.VIPERWORM = "GET OUT OF MY HEAD, GET OUT!"
	DESCRIBE.VIPERFRUIT = "Juicy one, full of sweetness."
	DESCRIBE.VIPERJAM = "Thick slime."
	
	DESCRIBE.BLUEBERRYPLANT =         
		{
            READY = "I should dig my claws in it.",
			FROZE = "Hard.",
			REGROWING = "Maybe claws was a bad idea.",
		}
	DESCRIBE.BERNIE_INACTIVE =
        {
            BROKEN = "It finally fell apart.",
            GENERIC = "It's all scorched.",
            ASHLEY_BROKEN = "It finally fell apart.",
            ASHLEY = "It's all scorched.",
        }
	
	DESCRIBE.BERNIE_ACTIVE =
        {
            GENERIC = "That teddy bear is moving around. Interesting.",
            ASHLEY = "That stuffed cat is moving around. Interesting.",
        }
	DESCRIBE.BERNIE_BIG =
        {
            GENERIC = "Remind me not to get on Willow's bad side.",
            ASHLEY = "Remind me not to get on Willow's bad side.",
        }
	DESCRIBE.ANTIHISTAMINE = "It's useful for ailing a stuffy nose!"

	DESCRIBE.HEATROCK_LEVEL = 
	{
		TINY = "A lonely old rock, sitting out in the open.",
		SMALL = "It's a little bit insulated when sitting in my pocket.",
		MED = "I'm keeping it somewhat insulated now.",
		LARGE = "It's well protected against the elements now.",
		HUGE = "It's perfectly protected against the elements!",
	}

	DESCRIBE.DURABILITY_LEVEL = 
	{
		QUARTER = "It's practically falling apart!",
		HALF = "It has some nasty holes in it.",
		THREEQUARTER = "Could use some stiching up.",
		FULL = "It's in perfect condition.",
	}

	ACTIONFAIL.READ =
        {
            GENERIC = "It seems the magic is inert in this state.",
        }
	ACTIONFAIL.GIVE = {NOTNIGHT = "I should wait until the moon is out."}

RECIPE_DESC = GLOBAL.STRINGS.RECIPE_DESC

    RECIPE_DESC.RAT_BURROW = "Home."

	-- Xmas Update
	DESCRIBE.MAGMAHOUND = "Bumpy thing."
	DESCRIBE.LIGHTNINGHOUND = "Yellow like the sun."
	DESCRIBE.SPOREHOUND = "Go farding around elsewhere."
	DESCRIBE.GLACIALHOUND = "Does it have ice bones."
	DESCRIBE.RNESKELETON = "How are they walking."
	DESCRIBE.RAT_WHIP = "I wish my tail could whack like this."
	DESCRIBE.KLAUS_AMULET = "Like gem necklace, and less pretty."
	DESCRIBE.CRABCLAW = "Whacker." 
	DESCRIBE.HAT_RATMASK = "It is how Humans say, Flattering." 

	DESCRIBE.ORANGE_VOMIT = "Slime paste."
	DESCRIBE.GREEN_VOMIT = "Slime paste."
	DESCRIBE.RED_VOMIT = "Slime paste."
	DESCRIBE.PINK_VOMIT = "Slime paste."
	DESCRIBE.YELLOW_VOMIT = "Slime paste."
	DESCRIBE.PURPLE_VOMIT = "Slime paste."
	DESCRIBE.PALE_VOMIT = "Slime paste."

	DESCRIBE.WALRUS_CAMP_EMPTY = DESCRIBE.WALRUS_CAMP.EMPTY
	DESCRIBE.PIGKING_PIGGUARD = 
	{
	GUARD = DESCRIBE.PIGMAN.GUARD,
	WEREPIG = DESCRIBE.PIGMAN.WEREPIG,
	}
	DESCRIBE.PIGKING_PIGTORCH = DESCRIBE.PIGTORCH

	DESCRIBE.BIGHT = "What."
	DESCRIBE.KNOOK = "Ugly Uglier"
	DESCRIBE.ROSHIP = "Get away Ugly."
	
	DESCRIBE.UM_PAWN = "It is ANNOYING."
	DESCRIBE.UM_PAWN_NIGHTMARE = "At least this one can SHUT UP!"
	
	DESCRIBE.CAVE_ENTRANCE_SUNKDECID = DESCRIBE.CAVE_ENTRANCE
	DESCRIBE.CAVE_ENTRANCE_OPEN_SUNKDECID = DESCRIBE.CAVE_ENTRANCE_OPEN
	DESCRIBE.CAVE_EXIT_SUNKDECID= DESCRIBE.CAVE_EXIT
	
	-- Blowgun stuff
	DESCRIBE.UNCOMPROMISING_BLOWGUN = DESCRIBE.BLOWDART_PIPE
	DESCRIBE.BLOWGUNAMMO_TOOTH = DESCRIBE.BLOWDART_PIPE
	DESCRIBE.BLOWGUNAMMO_FIRE = DESCRIBE.BLOWDART_FIRE
	DESCRIBE.BLOWGUNAMMO_SLEEP = DESCRIBE.BLOWDART_SLEEP
	DESCRIBE.BLOWGUNAMMO_ELECTRIC = DESCRIBE.BLOWDART_YELLOW
	
	DESCRIBE.ANCIENT_AMULET_RED = "I thought it was an omulette."
	DESCRIBE.UM_BEAR_TRAP = "Maybe I should throw a rock at it."
	DESCRIBE.UM_BEAR_TRAP_OLD = "Rust is yummy."
	DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_TOOTH = "I should cover it in yucky too."
	DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_GOLD = "I should cover it in yucky too."
	DESCRIBE.CORNCAN = "Crack it open! I smell something inside."
	DESCRIBE.SKULLCHEST_CHILD = "It is very quiet..."
	
	DESCRIBE.SLOBBERLOBBER = "Yucky spatty thing."
	DESCRIBE.GORE_HORN_HAT = "Run away from me! WINKY."
	DESCRIBE.BEARGERCLAW = "New Nails, not mine."
	DESCRIBE.FEATHER_FROCK = "Dusty ugly."
	
	DESCRIBE.REDGEM_CRACKED = DESCRIBE.REDGEM.."\nDeformed thang. Useless."
	DESCRIBE.BLUEGEM_CRACKED = DESCRIBE.BLUEGEM.."\nDeformed thang. Useless."
	DESCRIBE.ORANGEGEM_CRACKED = DESCRIBE.ORANGEGEM.."\nDeformed thang. Useless."
	DESCRIBE.GREENGEM_CRACKED = DESCRIBE.GREENGEM.."\nDeformed thang. Useless."
	DESCRIBE.YELLOWGEM_CRACKED = DESCRIBE.YELLOWGEM.."\nDeformed thang. Useless."
	DESCRIBE.PURPLEGEM_CRACKED = DESCRIBE.PURPLEGEM.."\nDeformed thang. Useless."
	DESCRIBE.OPALPRECIOUSGEM_CRACKED = DESCRIBE.OPALPRECIOUSGEM.."\nDeformed thang. Useless."
	
	DESCRIBE.RED_MUSHED_ROOM = "Goop"
	DESCRIBE.GREEN_MUSHED_ROOM = "Goop"
	DESCRIBE.BLUE_MUSHED_ROOM = "Goop"
	
	DESCRIBE.HEAT_SCALES_ARMOR = "If only I could fit inside."

	--StantonStuff
	DESCRIBE.SKULLFLASK = "Bone head, I want to drank it up."
	DESCRIBE.SKULLFLASK_EMPTY = "What? No more?"
	DESCRIBE.STANTON_SHADOW_TONIC = "Slimey drink"
	DESCRIBE.STANTON_SHADOW_TONIC_FANCY = DESCRIBE.STANTON_SHADOW_TONIC
	DESCRIBE.STANTON = "You're alive. Welcome back?"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HYPERCOURAGE = "Mmm!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HYPERCOURAGE = "Oh"
	--StantonStuff
	
	DESCRIBE.ARMORLAVAE = DESCRIBE.LAVAE
	
	DESCRIBE.THEATERCORN = "Ooh it is funny to eat and laugh."
	DESCRIBE.DEERCLOPS_BARRIER = "I'm Trapped! No!"
	
	
	DESCRIBE.MOONMAW_DRAGONFLY = "AH! WHAT ARE YOU!"
	DESCRIBE.MOONMAW_LAVAE = "Spinning, spinning, spinning."
	DESCRIBE.SNAPPERTURTLE = "ummm, Helllo? I am not here"
	DESCRIBE.SNAPPERTURTLEBABY = "I'll pick it up and throw it!"
	DESCRIBE.SNAPPERTURTLENEST = "Not my nest."
	DESCRIBE.GLASS_SCALES = "I like how it lights up like that!"
	DESCRIBE.MOONGLASS_GEODE = "Full of Light."
	DESCRIBE.ARMOR_GLASSMAIL = "I am the glass killer!"
	DESCRIBE.ARMOR_GLASSMAIL_SHARDS = "Cut Cut Cut, And slice."
	DESCRIBE.MOONMAW_GLASSSHARDS_RING = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
	DESCRIBE.MOONMAW_GLASSSHARDS = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
	DESCRIBE.MOONMAW_LAVAE_RING = DESCRIBE.MOONMAW_LAVAE

	DESCRIBE.MUTATOR_TRAPDOOR = DESCRIBE.MUTATOR_WARRIOR
	
	DESCRIBE.WOODPECKER = "Why are you banging your head, stupid."
	DESCRIBE.SNOTROAST = "full of delicious snot."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LARGEHUNGERSLOW = "ah, so full."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_LARGEHUNGERSLOW = "I wish I had some food."
	DESCRIBE.BOOK_RAIN = "Book of water."
	DESCRIBE.FLORAL_BANDAGE = "I should just eat it."
	DESCRIBE.DORMANT_RAIN_HORN = "It's Salty."
	DESCRIBE.RAIN_HORN = "Is it full of cloud?"
	DESCRIBE.DRIFTWOODFISHINGROD = "Why do they like this one?"
	
	ANNOUNCE.ANNOUNCE_NORATBURROWS = "Smells, lonely."
	
	
    ANNOUNCE.ANNOUNCE_RATSNIFFER_ITEMS = {
        LEVEL_1 = "It's starting to feel like home!",
    }
    ANNOUNCE.ANNOUNCE_RATSNIFFER_FOOD = {
        LEVEL_1 = "It's starting to smell like home!",
    }
    ANNOUNCE.ANNOUNCE_RATSNIFFER_BURROWS = {
        LEVEL_1 = "Ahaha, more friends are coming!",
    }

	DESCRIBE.PIED_RAT = "Give me that, you're playing it wrong."
	DESCRIBE.PIED_PIPER_FLUTE = "I love to play songs!"
	DESCRIBE.UNCOMPROMISING_PACKRAT = "I taught them to wear that."
	DESCRIBE.WINONA_TOOLBOX = ""
	DESCRIBE.OCEAN_SPEAKER = "loud"
	
	ANNOUNCE.ANNOUNCE_PORTABLEBOAT_SINK = "No! Going to lose boat if we sink!"
	
	--DESCRIBE.UM_SIREN = "SHE APPEARS TO BE THE ULTRA-MARINE LIFEFORM AROUND HERE"

	ACTIONFAIL.CHARGE_FROM =
	{
		NOT_ENOUGH_CHARGE = "test",
		CHARGE_FULL = "test",
	}
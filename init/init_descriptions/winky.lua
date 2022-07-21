local require = GLOBAL.require

GLOBAL.STRINGS.CHARACTERS.WINKY = require "speech_winky"

ANNOUNCE = GLOBAL.STRINGS.CHARACTERS.WINKY
DESCRIBE = GLOBAL.STRINGS.CHARACTERS.WINKY.DESCRIBE
ACTIONFAIL = GLOBAL.STRINGS.CHARACTERS.WINKY.ACTIONFAIL

--	[ 		Winky Descriptions		]   --

    ANNOUNCE.ANNOUNCE_HARDCORE_RES = "Grah! This heart is mine, not yours."
    ANNOUNCE.ANNOUNCE_WINONAGEN = "Useless machine"
    ANNOUNCE.ANNOUNCE_RATRAID = "I can hear my family."
    ANNOUNCE.ANNOUNCE_RATRAID_SPAWN = "Take everything! AaHaha!"
    ANNOUNCE.ANNOUNCE_RATRAID_OVER = "Hey, my family! They took my hoard!"
    ANNOUNCE.ANNOUNCE_ACIDRAIN = {
        "My fur is melting!",
        "Aaah the rain smells of burning!",
        "Must hide from this yucky rain! Squeek!",
    }
    ANNOUNCE.ANNOUNCE_TOADSTOOLED = "Did someone cut the cheese?"
	--FoodBuffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LESSERELECTRICATTACK = ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICRETALIATION = ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_FROZENFURY = "ch-ch-ch-ch-c-old touch"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_VETCURSE = "NoOOOo The darkness can't have ME!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_LESSERELECTRICATTACK = ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICRETALIATION = ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_FROZENFURY = "f-feeling my fingers again."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_VETCURSE = "The evil presence is gone..."
	ANNOUNCE.ANNOUNCE_RNEFOG = "Who is out there!"
	--FoodBuffs
	
	--CaliforniaKing
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_CALIFORNIAKING = "Feeling Ahahah ha ha ahh. Buzzy."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_CALIFORNIAKING = "Ah, I am not feeling buzzy anymore."
	DESCRIBE.CALIFORNIAKING = "Ooooo, this is nice drink."
	--CaliforniaKing
	
	--Content Creators
	DESCRIBE.CCTRINKET_DON = "I can only make out the words \"Squeek\" and uhhh \"Squeek\"."
	DESCRIBE.CCTRINKET_JAZZY = "Looks pretty jazzy."
	DESCRIBE.CCTRINKET_FREDDO = "There are stupid letters etched into it."		
	--Content Creators
	
    DESCRIBE.UNCOMPROMISING_RAT = "Hello, friend."
    DESCRIBE.UNCOMPROMISING_RATHERD = "We're all connected."
    DESCRIBE.UNCOMPROMISING_RATBURROW = "We're all connected."
    DESCRIBE.UNCOMPROMISING_WINKYBURROW = "There are many tunnels that lead to home."
    DESCRIBE.UNCOMPROMISING_WINKYHOMEBURROW = "My beauttiful home!"
	
	WINKY =
        {
            GENERIC = "Do I know you?",
            ATTACKER = "You need to keep your ratty claws away from me!",
            MURDERER = "%s I see blood in your fur!",
            REVIVER = "We're family.",
            GHOST = "You seem familar, are you part of my pack?",
            FIRESTARTER = "I can smell the ash on you fur, %s.",
        }
		
    DESCRIBE.RATPOISONBOTTLE = "Yuck! Are you trying to kill me?"
    DESCRIBE.RATPOISON = "Yuck! Are you trying to kill me?"

    DESCRIBE.MONSTERSMALLMEAT = "A small piece of juicy meat."
    DESCRIBE.COOKEDMONSTERSMALLMEAT = "The flavour is nice."
    DESCRIBE.MONSTERSMALLMEAT_DRIED = "You must chew a lot to get the flavour out."

    DESCRIBE.MUSHROOMSPROUT_OVERWORLD = "That! That is where the melting rain is from!"
    DESCRIBE.TOADLING = "Stop getting in my way."
	DESCRIBE.UNCOMPROMISING_TOAD = "Smells sick bleugh."
	
    DESCRIBE.GASMASK = "It's stuffy, so I can't smell."
	DESCRIBE.MOCK_DRAGONFLY = DESCRIBE.DRAGONFLY
	DESCRIBE.MOTHERGOOSE = DESCRIBE.MOOSE
	DESCRIBE.SPIDERQUEENCORPSE = "She is sitting there. Waiting..."
	ANNOUNCE.ANNOUNCE_SNEEZE = "AHHH \"SQUEE-CHUU!!!!\""
	ANNOUNCE.ANNOUNCE_HAYFEVER = "My nose feels.. itchy."
	ANNOUNCE.ANNOUNCE_HAYFEVER_OFF = "Finally, I don't want to claw my nose off anymore."
	ANNOUNCE.ANNOUNCE_FIREFALL = {
		"Is my fur on fire? Or is it me?",
		"Does something smell like burning rat!",
		"I'm exhuasted from this heat.",
	}
	ANNOUNCE.ANNOUNCE_ROOTING = "I'm stuck!"
	ANNOUNCE.ANNOUNCE_SNOWSTORM = "The winds picking up..."
	ANNOUNCE.ANNOUNCE_OVER_EAT =
	{
		STUFFED = "my belly is so big! Squeek!",
		OVERSTUFFED = "I am so big and round!",
    }
    ANNOUNCE.CURSED_ITEM_EQUIP = "GAHH!"
	DESCRIBE.VETSITEM = "It whispers, It wants me to talk to that bone head!"
	DESCRIBE.SCREECHER_TRINKET = "Little dolly thing."
	
	DESCRIBE.SAND = "Powder dust."
	DESCRIBE.SANDHILL = "Dust hill."
	DESCRIBE.SNOWPILE = "Snow hill."
	DESCRIBE.SNOWGOGGLES = "Snoggles."
	
	DESCRIBE.SNOWMONG = "Snow Seal."
	DESCRIBE.SHOCKWORM = "I can smell your slime from up here."
	DESCRIBE.ZASPBERRY = "This one must be a little zappy then."
	DESCRIBE.ZASPBERRYPARFAIT = "It makes my fur erect."
	DESCRIBE.ICEBOOMERANG = "Almost stuck to my tongue."
	
	DESCRIBE.MINOTAUR_BOULDER = "Rock."
	DESCRIBE.MINOTAUR_BOULDER_BIG = "Rock, but bigger."
	DESCRIBE.BUSHCRAB = "Give me your berries!"
	DESCRIBE.LAVAE2 = DESCRIBE.LAVAE
	DESCRIBE.DISEASECUREBOMB = "Sack of rock oils."
	DESCRIBE.TOADLINGSPAWNER = "Smells smelly."
	DESCRIBE.VETERANSHRINE = "Why are you speaking..."
	DESCRIBE.WICKER_TENTACLE = "Green and slimier."
	DESCRIBE.HONEY_LOG = "Crunchy and sweet, like beetles."
	
	DESCRIBE.RAT_TAIL = "What's the problem? We all die from time to time."
	DESCRIBE.PLAGUEMASK = "Why would I want to smell nice things."
	DESCRIBE.SALTPACK = "AAH, I think It got my EYE!"
	DESCRIBE.SPOREPACK = "We do a little bit of farding, we do a little Farding, yes."
	DESCRIBE.SNOWBALL_THROWABLE = "Haha, I wish I had thumbs sooner."
	DESCRIBE.SPIDER_TRAPDOOR = "Go back in your ugly hole."
	DESCRIBE.TRAPDOOR = "Flatter, worse looking rock."
	DESCRIBE.HOODEDTRAPDOOR = DESCRIBE.TRAPDOOR 
	DESCRIBE.SHROOM_SKIN_FRAGMENT = "."
	DESCRIBE.AIR_CONDITIONER = "Eyuck, Smells terrible! I do not like this fragrance."
	
	DESCRIBE.SCORPION = "Crush it."
	DESCRIBE.SCORPIONCARAPACE = "Tastes funny."
	DESCRIBE.SCORPIONCARAPACECOOKED = "It's not that bad, really."
	DESCRIBE.HARDSHELLTACOS = "Mmmm so Crunchy."
	
	DESCRIBE.SKELETONMEAT = "Stringy meat"
	DESCRIBE.CHIMP = DESCRIBE.MONKEY
	DESCRIBE.SWILSON = "Which one are you again?"
	DESCRIBE.VAMPIREBAT = "Meaner."
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
	DESCRIBE.MOON_TEAR = "For tears they are not very salty tasting."
	DESCRIBE.SHADOW_TELEPORTER = "Maybe it won't notice me taking the gem."
	DESCRIBE.POLLENMITEDEN = "A snack shack, full of juicy bugs."
    DESCRIBE.POLLENMITES = "If only there was a good way to eat them."
    DESCRIBE.SHADOW_CROWN = "It matches my fur at least."
    DESCRIBE.RNEGHOST = DESCRIBE.GHOST
	DESCRIBE.LICELOAF = "I'll keep it for later."
	DESCRIBE.SUNGLASSES = "Eye Darkner."
	DESCRIBE.TRAPDOORGRASS = DESCRIBE.GRASS
	DESCRIBE.LUREPLAGUE_RAT = "Hey! what is going on with you?"
	DESCRIBE.MARSH_GRASS = "Shushhshhh, be quiet..."
	DESCRIBE.CURSED_ANTLER = "Bash heads ahahaha."
	DESCRIBE.BERNIEBOX = "Box I can open with my teeth."
	DESCRIBE.HOODED_FERN = "It is green."
	DESCRIBE.HOODEDWIDOW = "/Ah!/ Who invited you!"
	DESCRIBE.GIANT_TREE = "I should climb up it, and eat the baby birds."
	DESCRIBE.WIDOWSGRASP =  "Haha, my personal toothpick."
	DESCRIBE.WEBBEDCREATURE = ""
	ANNOUNCE.WEBBEDCREATURE = "I keep getting stuck when I try to rip it up!"
	DESCRIBE.SNAPDRAGON_BUDDY = "It looks hungry, I am hungry too."
	DESCRIBE.SNAPDRAGON = "Some wild root beast."
	DESCRIBE.SNAPPLANT = "The connection they have is very snappy."
	DESCRIBE.WHISPERPOD = "Huh? I do not hear any whispering coming from this lump."
	DESCRIBE.WHISPERPOD_NORMAL_GROUND =
	{
		GENERIC = "Huh, do something.",
		GROWING = "The root is coming!",
	}
	DESCRIBE.FRUITBAT = "I hope you do not explode like the ground ones."
	DESCRIBE.PITCHERPLANT = "Must climb to it I can smell the sweetness."
	DESCRIBE.APHID = "Get out of here, this is Rat-land now."
	DESCRIBE.GIANT_TREE_INFESTED = "Must be full of worms."
	DESCRIBE.GIANT_BLUEBERRY = ""
	DESCRIBE.STEAMEDHAMS = "These steamed hams are very similar to the ones they have at PorkShire."
	DESCRIBE.BLUEBERRYPANCAKES = "This home-made blue slime is very satisfying."
	DESCRIBE.SIMPSALAD = "Greens."
	DESCRIBE.BEEFALOWINGS = "I am not sure if I eat the horn aswell."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_KNOCKBACKIMMUNE = "Ha-ha! I am invincible!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_KNOCKBACKIMMUNE = "Ooooh.. my body is sore now.."
	ANNOUNCE.WIDOWSHEAD = "My eyes are fine without this."
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
			FROZE = "Hard and cold.",
			REGROWING = "Maybe using my claws was a bad idea.",
		}
	DESCRIBE.BERNIE_INACTIVE =
        {
            BROKEN = "He is dead.",
            GENERIC = "Smells like that burning girl.",
            ASHLEY_BROKEN = "She is dead.",
            ASHLEY = "Smells like that burning girl.",
        }
	
	DESCRIBE.BERNIE_ACTIVE =
        {
            GENERIC = "You are a jitter-bug.",
            ASHLEY = "You are a jitter-bug.",
        }
	DESCRIBE.BERNIE_BIG =
        {
            GENERIC = "He is a big brute now!",
            ASHLEY = "He is a big brute now!",
        }
	DESCRIBE.ANTIHISTAMINE = "My nose will no longer be itchy!"

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
		QUARTER = "Smelly rags now.",
		HALF = "It is getting very smelly.",
		THREEQUARTER = "It is starting to stink.",
		FULL = "This is nice.",
	}

	ACTIONFAIL.READ =
        {
            GENERIC = "Of course I know what I'm doing.",
        }
	ACTIONFAIL.GIVE = {NOTNIGHT = "Maybe if I hit it hard, it will work?"}

RECIPE_DESC = GLOBAL.STRINGS.RECIPE_DESC

    RECIPE_DESC.RAT_BURROW = "Leads back to"

	-- Xmas Update
	DESCRIBE.MAGMAHOUND = "Bumpy rocky thing."
	DESCRIBE.LIGHTNINGHOUND = "Yellow like corn I suppose."
	DESCRIBE.SPOREHOUND = "Go farding around elsewhere."
	DESCRIBE.GLACIALHOUND = "Does it have ice bones."
	DESCRIBE.RNESKELETON = "How are you walking?"
	DESCRIBE.RAT_WHIP = "I wish my tail could whack like this."
	DESCRIBE.KLAUS_AMULET = "Like the gem necklace, and less pretty."
	DESCRIBE.CRABCLAW = "Whacker club." 
	DESCRIBE.HAT_RATMASK = "It is how Humans say, flattering." 

	DESCRIBE.ORANGE_VOMIT = "Slime paste. Very bitter tasting."
	DESCRIBE.GREEN_VOMIT = "Slime paste. Very sour tasting."
	DESCRIBE.RED_VOMIT = "Slime paste. Very bitter tasting."
	DESCRIBE.PINK_VOMIT = "Slime paste. Very sour tasting."
	DESCRIBE.YELLOW_VOMIT = "Slime paste. Very bitter tasting."
	DESCRIBE.PURPLE_VOMIT = "Slime paste. Very sour tasting."
	DESCRIBE.PALE_VOMIT = "Slime paste. Very bland tasting."

	DESCRIBE.WALRUS_CAMP_EMPTY = DESCRIBE.WALRUS_CAMP.EMPTY
	DESCRIBE.PIGKING_PIGGUARD = 
	{
	GUARD = DESCRIBE.PIGMAN.GUARD,
	WEREPIG = DESCRIBE.PIGMAN.WEREPIG,
	}
	DESCRIBE.PIGKING_PIGTORCH = DESCRIBE.PIGTORCH

	DESCRIBE.BIGHT = "What is this ugly noisy thing?."
	DESCRIBE.KNOOK = "terrible noisy clunking, gaahhhh..."
	DESCRIBE.ROSHIP = "Get away you ugly clunking thing!."
	
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
	
	DESCRIBE.ANCIENT_AMULET_RED = ""
	DESCRIBE.UM_BEAR_TRAP = "Maybe I should throw a rock at it."
	DESCRIBE.UM_BEAR_TRAP_OLD = "Rust is yummy."
	DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_TOOTH = "I should cover it in rust too."
	DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_GOLD = "I should cover it in rust too."
	DESCRIBE.CORNCAN = "Crack it open! I smell something inside."
	DESCRIBE.SKULLCHEST_CHILD = "It is very quiet..."
	
	DESCRIBE.SLOBBERLOBBER = "Yucky spatty thing."
	DESCRIBE.GORE_HORN_HAT = "Run away from me! WINKY."
	DESCRIBE.BEARGERCLAW = "New Nails, not mine."
	DESCRIBE.FEATHER_FROCK = "Dusty ugly bird cape."
	
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
	DESCRIBE.SKULLFLASK = "Bone head for drinking."
	DESCRIBE.SKULLFLASK_EMPTY = "What? No more?"
	DESCRIBE.STANTON_SHADOW_TONIC = "Slimey drink"
	DESCRIBE.STANTON_SHADOW_TONIC_FANCY = DESCRIBE.STANTON_SHADOW_TONIC
	DESCRIBE.STANTON = "You're alive. Welcome back?"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HYPERCOURAGE = "Mmm!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HYPERCOURAGE = "Oh"
	--StantonStuff
	
	DESCRIBE.ARMORLAVAE = DESCRIBE.LAVAE
	
	DESCRIBE.THEATERCORN = "Ooh, it is funny to eat and laugh."
	DESCRIBE.DEERCLOPS_BARRIER = "I'm Trapped! No!"
	
	
	DESCRIBE.MOONMAW_DRAGONFLY = "AH! WHAT ARE YOU!"
	DESCRIBE.MOONMAW_LAVAE = "Spinning, spinning. Spinning..."
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
	DESCRIBE.SNOTROAST = "full of delicious slime."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LARGEHUNGERSLOW = "Ah, so full."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_LARGEHUNGERSLOW = "I wish I had some food."
	DESCRIBE.BOOK_RAIN_UM = "Cloudy with a chance of rain."
	DESCRIBE.FLORAL_BANDAGE = "I should just eat it."
	DESCRIBE.DORMANT_RAIN_HORN = "It's salty."
	DESCRIBE.RAIN_HORN = "Is it full of clouds?"
	DESCRIBE.DRIFTWOODFISHINGROD = "Why do they like this one more?"
	
	ANNOUNCE.ANNOUNCE_NORATBURROWS = "Smells, around lonely here."
	
	
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
	
	ANNOUNCE.ANNOUNCE_PORTABLEBOAT_SINK = "No! I do not want to get my fur wet!"

	ACTIONFAIL.CHARGE_FROM =
	{
		NOT_ENOUGH_CHARGE = "The Stupid Machine is broken!",
		CHARGE_FULL = "Work! Oh wait, it is full.",
	}
	ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_INSULATED = "What is yours is mine as well."
	ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED = "/SQUEAK!!!/"
	DESCRIBE.UM_DEVILED_EGGS = "Yummy eggs, they smell good!"
	

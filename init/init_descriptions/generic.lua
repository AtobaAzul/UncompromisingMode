	-- Wilson's speech file
-- The strings here are also used when other characters are missing a line
-- If you've added an object to the mod, this is where to add placeholder strings
-- Keep things organized

ANNOUNCE = GLOBAL.STRINGS.CHARACTERS.GENERIC
DESCRIBE = GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE
ACTIONFAIL = GLOBAL.STRINGS.CHARACTERS.GENERIC.ACTIONFAIL

--	[ 		Wilson Descriptions		]   --

    ANNOUNCE.ANNOUNCE_HARDCORE_RES = "Hearts aren't part of ghost anatomy!"
    ANNOUNCE.ANNOUNCE_WINONAGEN = "That's not really my thing."
    ANNOUNCE.ANNOUNCE_RATRAID = "Squeak squeak?"
    ANNOUNCE.ANNOUNCE_RATRAID_SPAWN = "It's a rat-at-tack!"
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
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_CALIFORNIAKING = "Huh, it wasn't that bad."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_CALIFORNIAKING = "Who am I again?"
	DESCRIBE.CALIFORNIAKING = "This dish is gruesome."
	--CaliforniaKing

	--Content Creators
	DESCRIBE.CCTRINKET_DON = "I can only make out the words \"Don\" and \"Guide\"."
	DESCRIBE.CCTRINKET_JAZZY = "Looks pretty jazzy."
	DESCRIBE.CCTRINKET_FREDDO = "The name \"Freddo\" is etched onto it."
	--Content Creators
    DESCRIBE.UNCOMPROMISING_RAT = "They're rataliating!"
    DESCRIBE.UNCOMPROMISING_RATHERD = "It must lead to their labo-rat-ory."
    DESCRIBE.UNCOMPROMISING_RATBURROW = "It must lead to their labo-rat-ory."
    DESCRIBE.UNCOMPROMISING_WINKYBURROW = "She keeps leaving these around, I hope no rats come out..."
    DESCRIBE.UNCOMPROMISING_WINKYHOMEBURROW = "I think that's supposed to be that rat things home. Maybe I should look inside?"

	DESCRIBE.WINKY =
        {
            GENERIC = "How would you feel about a few experiments, %s?",
            ATTACKER = "Careful who you bite, %s!",
            MURDERER = "She's a bad rat!",
            REVIVER = "%s would be a great lab assistant!",
            GHOST = "I hope that wasn't caused by one of my experiments.",
            FIRESTARTER = "Rats shouldn't wield fire!",
        }
	DESCRIBE.WATHOM =
        {
            GENERIC = "%s seems smarter than he looks.",
            ATTACKER = "%s looks pretty intimidating!",
            MURDERER = "This monster is going to kill us all!",
            REVIVER = "I'm glad %s is on my side!",
            GHOST = "That doesn't look like normal ghosts. Well, \"normal\".",
            FIRESTARTER = "Are you trying to breathe fire, %s?",
        }


    DESCRIBE.RATPOISONBOTTLE = "It's labeled \"Do not drink. That means you, Webber.\""
    DESCRIBE.RATPOISON = "It's all murdery."

    DESCRIBE.MONSTERSMALLMEAT = "Small, angry meat."
    DESCRIBE.COOKEDMONSTERSMALLMEAT = "...it's still purple meat."
    DESCRIBE.MONSTERSMALLMEAT_DRIED = "What a little jerk."

    DESCRIBE.UM_MONSTEREGG = "A small, abnormal egg."
    DESCRIBE.UM_MONSTEREGG_COOKED = "Runny side yuck."

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

	ANNOUNCE.SHADOWTALKER = {
        "THERES NO ESCAPE",
        "THEY ARE OUT THERE, WATCHING, ALWAYS",
        "IT'S ONLY A MATTER OF TIME",
        "WHAT YEAR IS IT OUT THERE?",
        "NOTHING BUT DARKNESS",
        "IT'S A NEVER ENDING CYCLE",
        "HOW MANY TIMES HAVE I DIED HERE?",
		"WHAT DID I DO TO DESERVE THIS?",
		"CAN I REALLY TRUST THEM?",
    }
	ANNOUNCE.VETERANCURSETAUNT = {
		"COME CLOSER IF ADVERSITY IS WHAT YOU DESIRE",
        "COME, LET THE CURSE WASH OVER YOU",
        "SURVIVAL TOO EASY FOR YOU? I CAN HELP WITH THAT...",
	}
	ANNOUNCE.VETERANCURSED = {
		"YOU'VE MADE YOUR CHOICE",
        "TOO DIFFICULT FOR YOU?",
        "CURSE TOO TOUGH? THERE IS ONLY ONE WAY OUT...", --should this still be here?
	}

	ANNOUNCE.STANTON_GREET = {"Care to drink with the dead?", "Let's play a little game, how's about a drink?", "Come and drink with me.","I pick the drinks, you knock 'em back." }
	ANNOUNCE.STANTON_GIVE = {"You seem willing, I'll drink with you.", "It'll be you then."}
	ANNOUNCE.STANTON_RESTOCK = {"Still awake? We can drink again.", "I can give you another."}
	ANNOUNCE.STANTON_RULES = {"I only drink with one at a time."}
	ANNOUNCE.STANTON_GLOAT = {"Ha! I knew you were soft.", "Ha! You lose!"}

	ANNOUNCE.STANTON_POET1 = { "When it's six to midnight and the boney hand of death is nigh."}
	ANNOUNCE.STANTON_POET2 = { "You better drink your drink and shut your mouth."}
	ANNOUNCE.STANTON_POET3 = { "If you draw against his hand, you can never win." }
	ANNOUNCE.STANTON_POET4 = { "Go ahead… drink with the living dead." }
	ANNOUNCE.STANTON_POET5 = { "Drink with the living dead." }

	ANNOUNCE.STANTON_IMPATIENT = {"I'm getting tired of waiting here.","I ain't got all night!"}
	ANNOUNCE.STANTON_SUPERIMPATIENT = {"I'm done waiting."}

	ANNOUNCE.SHADOW_CROWN_CHALLENGE = "DEFEAT THIS CREATURE AND CLAIM YOUR PRIZE"
	ANNOUNCE.ANNOUNCE_OVER_EAT =
	{
		STUFFED = "I'm full!",
		OVERSTUFFED = "Oooh... I shouldn't eat more!",
    }
    ANNOUNCE.CURSED_ITEM_EQUIP = "Ow, my hand!"
    DESCRIBE.VETSITEM = "I need to seek out a dark power to use this!"
	DESCRIBE.SCREECHER_TRINKET = "Great, just what I needed."

	DESCRIBE.UM_SAND = "A handy pile of pocket sand."
	DESCRIBE.UM_SANDHILL = "You better stay out of my shoes."
	DESCRIBE.SNOWPILE = "That'll be a problem if it builds up."
	DESCRIBE.SNOWGOGGLES = "Icy clearly now!"

	DESCRIBE.SNOWMONG = "Shiverbug!"
	DESCRIBE.SHOCKWORM = "Quite the conductive worm!"
	DESCRIBE.ZASPBERRY = "I can feel the electricity flowing through it."
	DESCRIBE.ZASPBERRYPARFAIT = "Shockingly delicious."
	DESCRIBE.ICEBOOMERANG = "It has a chilling bite to it."

	DESCRIBE.MINOTAUR_BOULDER = "Thats a nice boulder."
	DESCRIBE.MINOTAUR_BOULDER_BIG = "Science says it would hurt if you ran into it. Probably."
	DESCRIBE.BUSHCRAB = "AH! How long was he down there?!"
	DESCRIBE.LAVAE2 = DESCRIBE.LAVAE
	DESCRIBE.DISEASECUREBOMB = "Finally, a practical use for the moons transformative properties."
	DESCRIBE.TOADLINGSPAWNER = "Uh oh."
	DESCRIBE.SNOWBALL_THROWABLE = "Not the face!"
	DESCRIBE.VETERANSHRINE = "I know what I'm doing... right?"
	DESCRIBE.WICKER_TENTACLE = "Doubly sickening."
	DESCRIBE.HONEY_LOG = "I have a strange desire to eat it."

	DESCRIBE.RAT_TAIL = "It reeks of a pestilence."
	DESCRIBE.PLAGUEMASK = "The mushrooms stuffed in the beak smell nice."
	DESCRIBE.SALTPACK = "It breaks down the snow around me!"
	DESCRIBE.SPOREPACK = "It's huge, and smelly."
	DESCRIBE.SNOWBALL_THROWABLE = "Not the face!"
	DESCRIBE.SPIDER_TRAPDOOR = "Agh! An ambush!"
	DESCRIBE.TRAPDOOR = "Nothing out of the ordinary here."
	DESCRIBE.HOODEDTRAPDOOR = DESCRIBE.TRAPDOOR
	DESCRIBE.SHROOM_SKIN_FRAGMENT = "It's small, but the stench is still a punch in the face."
	DESCRIBE.AIR_CONDITIONER = "Smells great!"

	DESCRIBE.UM_SCORPION = "That better not be venomous."
	DESCRIBE.UM_SCORPIONHOLE = "Another inconspicious mark in the terrain."
	DESCRIBE.SCORPIONCARAPACE = "I'll pass."
	DESCRIBE.SCORPIONCARAPACECOOKED = "The shell is still pretty hard."
	DESCRIBE.HARDSHELLTACOS = "Must be Tuesday."

	DESCRIBE.SKELETONMEAT = "Flesh is flesh. Where do I draw the line?"
	DESCRIBE.CHIMP = DESCRIBE.MONKEY
	DESCRIBE.SWILSON = "What-?!"
	DESCRIBE.VAMPIREBAT = "This one is uglier!"
	DESCRIBE.CRITTERLAB_REAL = DESCRIBE.CRITTERLAB
	DESCRIBE.CRITTERLAB_REAL_BROKEN = "I could fix this up with some moon rocks."
	DESCRIBE.SLINGSHOTAMMO_FIRECRACKERS = DESCRIBE.FIRECRACKERS
	DESCRIBE.CHARLIEPHONOGRAPH_100 = DESCRIBE.MAXWELLPHONOGRAPH
	DESCRIBE.WALRUS_CAMP_SUMMER = DESCRIBE.WALRUS_CAMP

	--Swampyness
	DESCRIBE.RICEPLANT = "Rice is nice."
	DESCRIBE.RICE = "It's too tough to eat."
	DESCRIBE.RICE_COOKED = "Tastes soggy."
	DESCRIBE.SEAFOODPAELLA = "Clears the sinuses."

	DESCRIBE.STUMPLING = "He's small, but he's angry!"
	DESCRIBE.BIRCHLING = DESCRIBE.STUMPLING
	DESCRIBE.BUGZAPPER = "Now I'll show those pesky pests!"
	DESCRIBE.MOON_TEAR = "I think the moon is upset at it's missing piece. Let's keep this safe."
	DESCRIBE.SHADOW_TELEPORTER = "Hey! Let go of that gem!"
	DESCRIBE.POLLENMITEDEN = "Science says it mite be dangerous."
    DESCRIBE.POLLENMITES = "I mite want to keep my distance."
    DESCRIBE.SHADOW_CROWN = "I feel un-safer already."
    DESCRIBE.RNEGHOST = DESCRIBE.GHOST
	DESCRIBE.LICELOAF = "How bland."
	DESCRIBE.SUNGLASSES = "Stylish, and slightly over sized."
	DESCRIBE.TRAPDOORGRASS = DESCRIBE.GRASS
	DESCRIBE.LUREPLAGUE_RAT = "They're rat..tal... Oh no."
	DESCRIBE.MARSH_GRASS = "It's all bushy."
	DESCRIBE.CURSED_ANTLER = "Strong AND reliable!"
	DESCRIBE.BERNIEBOX = "What could be inside? If only I could open it..."
	DESCRIBE.HOODED_FERN = "That fern is pretty big."
	DESCRIBE.HOODEDWIDOW = "That thing could eat a giant!!"
	DESCRIBE.GIANT_TREE = "It totally blocks out the sun."
	DESCRIBE.WIDOWSGRASP =  "Let's open up those cocoons!"
	DESCRIBE.WEBBEDCREATURE = "It wouldn't hurt to see what's inside, right?"
	ANNOUNCE.WEBBEDCREATURE = "Only a spider could rip through silk this tough!"
	DESCRIBE.SNAPDRAGON_BUDDY = "It looks hungry. Me too."
	DESCRIBE.SNAPDRAGON = "It looks nice enough."
	DESCRIBE.SNAPPLANT = "A little piece of home."
	DESCRIBE.WHISPERPOD = "Lets see what happens when you put it in the ground."
	DESCRIBE.WHISPERPOD_NORMAL_GROUND =
	{
		GENERIC = "Need some seeds?",
		GROWING = "Guh! It's growing so slowly!",
	}
	DESCRIBE.FRUITBAT = "Agh, it's still terrifying!"
	DESCRIBE.PITCHERPLANT = "It's quite high up."
	DESCRIBE.APHID = "A horrible pest."
	DESCRIBE.GIANT_TREE_INFESTED = "It doesn't look too well."
	DESCRIBE.GIANT_BLUEBERRY = "This'll be messy, for sure."
	DESCRIBE.STEAMEDHAMS = "Science says it's a hamburger."
	DESCRIBE.BLUEBERRYPANCAKES = "Exploding with flavor."
	DESCRIBE.SIMPSALAD = "It's a rather light meal."
	DESCRIBE.BEEFALOWINGS = "I'm sure the beefalo didn't mind."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_KNOCKBACKIMMUNE = "Never gonna knock me down."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_KNOCKBACKIMMUNE = "My legs are getting flimsy again."
	DESCRIBE.WIDOWSHEAD = "It seems to augment my vision."
	DESCRIBE.HOODED_MUSHTREE_TALL = DESCRIBE.MUSHTREE_TALL
	DESCRIBE.HOODED_MUSHTREE_MEDIUM = DESCRIBE.MUSHTREE_MEDIUM
	DESCRIBE.HOODED_MUSHTREE_SMALL = DESCRIBE.MUSHTREE_SMALL
	DESCRIBE.WATERMELON_LANTERN = "Spooky?"
	DESCRIBE.SNOWCONE = "Must've used too much ice."

	--Viperstuff Quotes
	DESCRIBE.VIPERWORM = "It's messing with my head!"
	DESCRIBE.VIPERFRUIT = "I create snakes through the power of science!"
	DESCRIBE.VIPERJAM = "At least I have the jar now."

	DESCRIBE.BLUEBERRYPLANT =
		{
            READY = "It's pretty big, maybe I can dig it up.",
			FROZE = "It's frozen solid.",
			REGROWING = "That plant survived, it'll probably grow back?",
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

    RECIPE_DESC.RAT_BURROW = "A den of annoying little hairballs."

	-- Xmas Update
	DESCRIBE.MAGMAHOUND = "Hot dog!"
	DESCRIBE.LIGHTNINGHOUND = "Watch it, that one stings!"
	DESCRIBE.SPOREHOUND = "You sick dog."
	DESCRIBE.GLACIALHOUND = "This hound's on ice."
	DESCRIBE.RNESKELETON = "They are spooky AND scary!"
	DESCRIBE.RAT_WHIP = "I make all the rules."
	DESCRIBE.KLAUS_AMULET = "It's chains contain the King of Winter!"
	DESCRIBE.CRABCLAW = "Hey, these are gem holes!"
	DESCRIBE.HAT_RATMASK = "I'll sniff out those dens myself!"

	DESCRIBE.ORANGE_VOMIT = "Oh, how nice of you..."
	DESCRIBE.GREEN_VOMIT = "Oh, how nice of you..."
	DESCRIBE.RED_VOMIT = "Oh, how nice of you..."
	DESCRIBE.PINK_VOMIT = "Oh, how nice of you..."
	DESCRIBE.YELLOW_VOMIT = "Oh, how nice of you..."
	DESCRIBE.PURPLE_VOMIT = "Oh, how nice of you..."
	DESCRIBE.PALE_VOMIT = "Oh, how nice of you..."

	DESCRIBE.WALRUS_CAMP_EMPTY = DESCRIBE.WALRUS_CAMP.EMPTY
	DESCRIBE.PIGKING_PIGGUARD =
	{
	GUARD = DESCRIBE.PIGMAN.GUARD,
	WEREPIG = DESCRIBE.PIGMAN.WEREPIG,
	}
	DESCRIBE.PIGKING_PIGTORCH = DESCRIBE.PIGTORCH

	DESCRIBE.BIGHT = "It lives!"
	DESCRIBE.KNOOK = "I don't like that maw!"
	DESCRIBE.ROSHIP = "What a horror!"

	DESCRIBE.UM_PAWN = "It gets louder when I get closer."
	DESCRIBE.UM_PAWN_NIGHTMARE = "I should keep my distance."

	DESCRIBE.CAVE_ENTRANCE_SUNKDECID = DESCRIBE.CAVE_ENTRANCE
	DESCRIBE.CAVE_ENTRANCE_OPEN_SUNKDECID = DESCRIBE.CAVE_ENTRANCE_OPEN
	DESCRIBE.CAVE_EXIT_SUNKDECID= DESCRIBE.CAVE_EXIT

	-- Blowgun stuff
	DESCRIBE.UNCOMPROMISING_BLOWGUN = DESCRIBE.BLOWDART_PIPE
	DESCRIBE.BLOWGUNAMMO_TOOTH = DESCRIBE.BLOWDART_PIPE
	DESCRIBE.BLOWGUNAMMO_FIRE = DESCRIBE.BLOWDART_FIRE
	DESCRIBE.BLOWGUNAMMO_SLEEP = DESCRIBE.BLOWDART_SLEEP
	DESCRIBE.BLOWGUNAMMO_ELECTRIC = DESCRIBE.BLOWDART_YELLOW

	DESCRIBE.ANCIENT_AMULET_RED = "It's tugging at my heart strings!"
	DESCRIBE.UM_BEAR_TRAP = "I need to watch my step."
	DESCRIBE.UM_BEAR_TRAP_OLD = "Woah! I need to watch my step!"
	DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_TOOTH = "Don't get snappy with me!"
	DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_GOLD = "Don't get snappy with me!"
	DESCRIBE.CORNCAN = "Where did this can come from?"
	DESCRIBE.SKULLCHEST_CHILD = "If only I could fit inside."

	DESCRIBE.SLOBBERLOBBER = "A portable loogie launcher."
	DESCRIBE.GORE_HORN_HAT = "My mind was always the greatest weapon but... yeah, you get the idea."
	DESCRIBE.BEARGERCLAW = "Sticks and stones can break some bones."
	DESCRIBE.FEATHER_FROCK = "All the comfort of a bed, in wearable form!"

	DESCRIBE.REDGEM_CRACKED = DESCRIBE.REDGEM.."\n...It's nigh unusable in this form."
	DESCRIBE.BLUEGEM_CRACKED = DESCRIBE.BLUEGEM.."\n...It's nigh unusable in this form."
	DESCRIBE.ORANGEGEM_CRACKED = DESCRIBE.ORANGEGEM.."\n...It's nigh unusable in this form."
	DESCRIBE.GREENGEM_CRACKED = DESCRIBE.GREENGEM.."\n...It's nigh unusable in this form."
	DESCRIBE.YELLOWGEM_CRACKED = DESCRIBE.YELLOWGEM.."\n...It's nigh unusable in this form."
	DESCRIBE.PURPLEGEM_CRACKED = DESCRIBE.PURPLEGEM.."\n...It's nigh unusable in this form."
	DESCRIBE.OPALPRECIOUSGEM_CRACKED = DESCRIBE.OPALPRECIOUSGEM.."\n...It's nigh unusable in this form."

	DESCRIBE.RED_MUSHED_ROOM = "It's all mushed up now."
	DESCRIBE.GREEN_MUSHED_ROOM = "It's all mushed up now."
	DESCRIBE.BLUE_MUSHED_ROOM = "It's all mushed up now."

	DESCRIBE.HEAT_SCALES_ARMOR = "If only I could fit inside."

	--StantonStuff
	DESCRIBE.SKULLFLASK = "We got that guy's lucky flask."
	DESCRIBE.SKULLFLASK_EMPTY = "I'll get a refill later."
	DESCRIBE.STANTON_SHADOW_TONIC = "I shouldn't do this..."
	DESCRIBE.STANTON_SHADOW_TONIC_FANCY = DESCRIBE.STANTON_SHADOW_TONIC
	DESCRIBE.STANTON = "You want a drinking partner? Uh..."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HYPERCOURAGE = "What's so scary?"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HYPERCOURAGE = "I..."
	--StantonStuff

	DESCRIBE.ARMORLAVAE = DESCRIBE.LAVAE

	DESCRIBE.THEATERCORN = "I should find something interesting to watch."
	DESCRIBE.DEERCLOPS_BARRIER = "I need to mine my way out of here!"


	DESCRIBE.MOONMAW_DRAGONFLY = "Crys-terrifying!"
	DESCRIBE.MOONMAW_LAVAE = "They're protecting it's mom!"
	DESCRIBE.SNAPPERTURTLE = "These are the kind that don't bite your hand off, right?"
	DESCRIBE.SNAPPERTURTLEBABY = "I'd like one as a pet, but it would probably take my fingers."
	DESCRIBE.SNAPPERTURTLENEST = "Yup, that's a nest."
	DESCRIBE.GLASS_SCALES = "I like how it lights up like that!"
	DESCRIBE.MOONGLASS_GEODE = "It's not quite glass. Pretty hefty, too."
	DESCRIBE.ARMOR_GLASSMAIL = "Anything within arm's reach will get shredded!"
	DESCRIBE.ARMOR_GLASSMAIL_SHARDS = "Thankfully I'm the one in control!"
	DESCRIBE.MOONMAW_GLASSSHARDS_RING = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
	DESCRIBE.MOONMAW_GLASSSHARDS = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
	DESCRIBE.MOONMAW_LAVAE_RING = DESCRIBE.MOONMAW_LAVAE

	DESCRIBE.MUTATOR_TRAPDOOR = DESCRIBE.MUTATOR_WARRIOR

	DESCRIBE.WOODPECKER = "Science makes it not get headaches."
	DESCRIBE.SNOTROAST = "That isn't going anywhere near my mouth."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LARGEHUNGERSLOW = "I've lost my appetite."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_LARGEHUNGERSLOW = ""
	DESCRIBE.BOOK_RAIN_UM = "I already know about the water cycle, thanks."
	DESCRIBE.FLORAL_BANDAGE = "Heals open wounds and keeps them smelling good."
	DESCRIBE.DORMANT_RAIN_HORN = "Looking at it gives me flashes of a tropical setting."
	DESCRIBE.RAIN_HORN = "This'll be useful for when wildfires start up again."
	DESCRIBE.DRIFTWOODFISHINGROD = "It's attuned to the ocean."

	ANNOUNCE.ANNOUNCE_NORATBURROWS = "Sounds like theres no rat dens nearby."


    ANNOUNCE.ANNOUNCE_RATSNIFFER_ITEMS = {
        LEVEL_1 = "The camp is looking like rat's nest.",
    }
    ANNOUNCE.ANNOUNCE_RATSNIFFER_FOOD = {
        LEVEL_1 = "The state of our rations may attract unwanted attention to the camp.",
    }
    ANNOUNCE.ANNOUNCE_RATSNIFFER_BURROWS = {
        LEVEL_1 = "The rats seem to be multiplying out in the wilderness, where is their source?",
    }

	DESCRIBE.PIED_RAT = "He must be leading the vermin!"
	DESCRIBE.PIED_PIPER_FLUTE = "Maybe I could lead some of the rats myself?"
	DESCRIBE.UNCOMPROMISING_PACKRAT = "Hey! It's carrying off all of our valuables!"

	ANNOUNCE.ANNOUNCE_PORTABLEBOAT_SINK = "I can't retrieve this raft if I drown!"

	ACTIONFAIL.CHARGE_FROM =
	{
		NOT_ENOUGH_CHARGE = "I need to restore the power before I can do that.",
		CHARGE_FULL = "That won't work when it's already charged.",
	}
	ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_INSULATED = "What a shocking result!"
	ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED = "OW! What a shocking result!"

	----UNDER THE WEATHER----

	DESCRIBE.WINONA_TOOLBOX = "I had one like this for all of my scientific tools."
	ACTIONFAIL.WINONATOOLBOX = "Well, I never said these were my tools."
    DESCRIBE.POWERCELL = "It's like carrying around a little box of electricty."
	DESCRIBE.WINONA_UPGRADEKIT_ELECTRICAL = "Of course I know how this works! I could've made one myself."
	DESCRIBE.MINERHAT_ELECTRICAL = "Hands-free and scientifically powered!"
	DESCRIBE.OCEAN_SPEAKER = "Well this seems awfully out of place." --Lame guy. Lame quote.

	DESCRIBE.OCUPUS_BEAK = "Better that I ate you, than you eat me."
	DESCRIBE.OCUPUS_TENTACLE = ""
	DESCRIBE.OCUPUS_TENTACLE_EYE = "Everyone around here seems to be watching me."
	DESCRIBE.OCUPUS_TENTACLE_COOKED = "It doesn't look that bad..."

	DESCRIBE.ARMOR_REED_UM = "I'll still be light on my feet with it on."
	DESCRIBE.ARMOR_SHARKSUIT_UM = "It makes me feel like the alpha predator."
	DESCRIBE.ROCKJAWLEATHER = "It's cold and surprinsgly smooth."

	--DESCRIBE.UM_SIREN = "Science says we may be able to \"help\" each other."
	--WHAT THE FUCK VARIANT
	--DESCRIBE.UM_SIREN = "Science says she may not be from around here."

	DESCRIBE.EYEOFTERROR_MINI_ALLY = DESCRIBE.EYEOFTERROR_MINI
	DESCRIBE.STUFFED_PEEPER_POPPERS = "I'll have to keep an eye on these eyes."
	DESCRIBE.UM_DEVILED_EGGS = "They smell fowl."
	DESCRIBE.LUSH_ENTRANCE = "What a perfectly innocent looking ominous hole in the ground."
	DESCRIBE.CRITTER_FIGGY = "Hmm. I think I'll call you Figgy Newton Fluffybottom the Fourteenth."
	DESCRIBE.GIANT_TREE_BIRDNEST = "What an eggscellent find!"
	ACTIONFAIL.UPGRADE.NOT_HARVESTED = "Yuck, I gotta clean that first!"

    DESCRIBE.SLUDGE = "It reeks like eggs, but doesn't look nearly as appetizing."
	DESCRIBE.SLUDGE_OIL = "Something like this belongs in my old laboratory."
    DESCRIBE.SLUDGE_SACK = "I hope it doesn't stick to my back."
	DESCRIBE.CANNONBALL_SLUDGE_ITEM = "It's crude, but it blows things up all the same."
	DESCRIBE.BOAT_BUMPER_SLUDGE = "It'll bounce back whatever hits it."
	DESCRIBE.BOAT_BUMBER_SLUDGE_KIT = "A softer cushion for something hitting my boat."
    DESCRIBE.BOATPATCH_SLUDGE = "Another way to plug up any leaks."
    DESCRIBE.UM_COPPER_PIPE = "Metal tubes, from a tree?"
    DESCRIBE.BRINE_BALM  = "It keeps wounds fresh. No wait, that's not right."
    DESCRIBE.UNCOMPROMISING_FISHINGNET = DESCRIBE.FISHINGNET
	DESCRIBE.UM_AMBER = "There's something inside of it?"
	DESCRIBE.UM_BEEGUN = "Bees love being shot out of cannons, right?"
	DESCRIBE.BULLETBEE = DESCRIBE.KILLERBEE
	DESCRIBE.CHERRYBULLETBEE = DESCRIBE.KILLERBEE
	DESCRIBE.SUNKENCHEST_ROYAL = "It was a royal pain just to get this."
	DESCRIBE.STEERINGWHEEL_COPPER = "It's mechanical, and that means it's better."
	DESCRIBE.STEERINGWHEEL_COPPER_ITEM = "It's better because it's mechanical."
	DESCRIBE.BOAT_BUMPER_COPPER = "It will take a lot more hits before it breaks done."
	DESCRIBE.BOAT_BUMPER_COPPER_KIT = "Metal tubes stuck to one another."
	DESCRIBE.UM_DREAMCATCHER = "It's not easy having a good nights rest anymore, I hope this helps."
	DESCRIBE.UM_BRINEISHMOSS = "You're not the moss of me!"
	DESCRIBE.UM_COALESCED_NIGHTMARE = "That stuff better not start crawling around."
	DESCRIBE.SLUDGE_CORK = "It's too big for a boat. Maybe it can plug something else."
	DESCRIBE.SLUDGESTACK = "Is that where that awful smell is coming from?"
	DESCRIBE.SPECTER_SHIPWRECK = "It's been ship wrecked." --TM

	DESCRIBE.UNCOMPROMISING_HARPOON = "Stabbing things from a distance has never been easier."
	DESCRIBE.UNCOMPROMISING_HARPOON_HEAVY = "It's not as heavy as it looks."
	DESCRIBE.UNCOMPROMISING_HARPOONREEL = "It's the reel deal." -- I think he already has a quote that's exactly like this
	DESCRIBE.UM_MAGNERANG = "It'll come back and bring something with it."
	DESCRIBE.UM_MAGNERANGREEL = "Science is pretty attractive."
	DESCRIBE.SIREN_THRONE = "Something... or someone, seems to have been here recently."
	DESCRIBE.LAVASPIT_SLUDGE = "Ack, that's boiling!"
		
	DESCRIBE.UM_BEEGUARD_SHOOTER = DESCRIBE.BEEGUARD
	DESCRIBE.UM_BEEGUARD_SEEKER = DESCRIBE.BEEGUARD
	DESCRIBE.UM_BEEGUARD_BLOCKER = "They beecame a wall!"

	DESCRIBE.PORTABLEBOAT_ITEM = "Science will determine if it floats."
	DESCRIBE.MASTUPGRADE_WINDTURBINE_ITEM = "It produces light, theoretically."
	
	DESCRIBE.WIXIE_PIANO = "It's never too late to learn!"
	DESCRIBE.WIXIE_CLOCK = "We're both right twice a day. Usually."
	DESCRIBE.WIXIE_WARDROBE = "It contains dark secrets. Or clothing."
	DESCRIBE.CHARLES_T_HORSE = "This better not be a trick."

	DESCRIBE.UM_ORNAMENT_OPOSSUM = "Would it make a good decoration? Possumbly!"
	DESCRIBE.UM_ORNAMENT_RAT = "Rats aren't so scary!"
	
	DESCRIBE.TRINKET_WATHOM1 = "It looks a little brokeny, whatever it is."
	
	DESCRIBE.CODEX_MANTRA = DESCRIBE.WAXWELLJOURNAL
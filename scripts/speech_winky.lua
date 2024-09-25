return {
	ACTIONFAIL =
	{
        APPRAISE =
        {
            NOTNOW = "You're wasting my time.",
        },
        REPAIR =
        {
            WRONGPIECE = "It does not go in.",
        },
        BUILD =
        {
            MOUNTED = "I'm not falling off for that!",
            HASPET = "I have a creature, I don't need more!",
			TICOON = "They might KILL me together if I get another.",
        },
		SHAVE =
		{
			AWAKEBEEFALO = "Beasts like that know what I want.",
			GENERIC = "He is smooth.",
			NOBITS = "No more.",
            REFUSE = "only_used_by_woodie",
            SOMEONEELSESBEEFALO = "I don't think I should, I want to, but I can't.",
		},
		STORE =
		{
			GENERIC = "I should empty it.",
			NOTALLOWED = "No no no.",
			INUSE = "Don't keep ME waiting.",
            NOTMASTERCHEF = "He'll slap my fingers again...",
		},
        CONSTRUCT =
        {
            INUSE = "Get off so I can use it.",
            NOTALLOWED = "Wrong, I hate it.",
            EMPTY = "Missing... Something.",
            MISMATCH = "This is wrong, built by idiots!",
        },
		RUMMAGE =
		{
			GENERIC = "I can't do that.",
			INUSE = "Hey let me have a peek.",
            NOTMASTERCHEF = "He'll slap my fingers again...",
		},
		UNLOCK =
        {
        	WRONGKEY = "I think I have the right one... Somewhere.",
        },
		USEKLAUSSACKKEY =
        {
        	WRONGKEY = "Bad thing.",
        	KLAUS = "The Claws-Man is here!!",
			QUAGMIRE_WRONGKEY = "Bad thing.",
        },
		ACTIVATE =
		{
			LOCKED_GATE = "Broken.",
            HOSTBUSY = "Everyone wastes my time here.",
            CARNIVAL_HOST_HERE = "Where is Mr.Beaky.",
            NOCARNIVAL = "They're gone, I hope it stays like that.",
			EMPTY_CATCOONDEN = "Someone stole it before I could!",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDERS = "So bad at hiding, haha.",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDING_SPOTS = "I guess we can't play, Oh well. ha.",
			KITCOON_HIDEANDSEEK_ONE_GAME_PER_DAY = "I'm tired of looking for UGLY creatures.",
		},
        COOK =
        {
            GENERIC = "Nope.",
            INUSE = "I was going to do it first.",
            TOOFAR = "Come to ME!",
        },
        START_CARRAT_RACE =
        {
            NO_RACERS = "I am not a going to do it.",
        },

		DISMANTLE =
		{
			COOKING = "Hey, make me food.",
			INUSE = "I am waiting...",
			NOTEMPTY = "Full of slime.",
        },
        FISH_OCEAN =
		{
			TOODEEP = "Flimsy rod is too good for the ocean.",
		},
        OCEAN_FISHING_POND =
		{
			WRONGGEAR = "It can't fish in stinky ponds.",
		},
        --wickerbottom specific action
        READ =
        {
            GENERIC = "only_used_by_wickerbottom",
            NOBIRDS = "only_used_by_wickerbottom",
        },

        GIVE =
        {
            GENERIC = "Keeping it! haha!",
            DEAD = "Don't want this anyways?",
            SLEEPING = "Hey! I have this.. Thing..",
            BUSY = "Here....",
            ABIGAILHEART = "Dead-dead.",
            GHOSTHEART = "You want it! Dont you!",
            NOTGEM = "I can keep smashing it until it works!",
            WRONGGEM = "Bad.",
            NOTSTAFF = "I can keep smashing it until it works!",
            MUSHROOMFARM_NEEDSSHROOM = "It smells like mushrooms, Maybe I need those.",
            MUSHROOMFARM_NEEDSLOG = "Hmmm it is missing something...",
            MUSHROOMFARM_NOMOONALLOWED = "I don't want these growing here.",
            SLOTFULL = "No room. I should make some.",
            FOODFULL = "I want what is in there!",
            NOTDISH = "What? it's food to me.",
            DUPLICATE = "I knew that!",
            NOTSCULPTABLE = "I can sculpt anything with mud.",
            NOTATRIUMKEY = "Fit stupid thing!",
            CANTSHADOWREVIVE = "Work already!",
            WRONGSHADOWFORM = "WHO did this wrong.",
            NOMOON = "That dumb Round thing at night should be out.",
			PIGKINGGAME_MESSY = "I like things how they are.",
			PIGKINGGAME_DANGER = "Monsters are coming now!",
			PIGKINGGAME_TOOLATE = "Bored now.",
			CARNIVALGAME_INVALID_ITEM = "I need the loot here to play.",
			CARNIVALGAME_ALREADY_PLAYING = "Busy with meaningless thing.",
            SPIDERNOHAT = "Something is wrong with it.",
            TERRARIUM_REFUSE = "Hit it until it works!",
            TERRARIUM_COOLDOWN = "Broken thing, Smash it to get in.",
        },
        GIVETOPLAYER =
        {
            FULL = "I guess you don't want it.",
            DEAD = "Hah, it was always mine!",
            SLEEPING = "Nice pockets.",
            BUSY = "Hurry up, Stupid.",
        },
        GIVEALLTOPLAYER =
        {
            FULL = "Give me your things!",
            DEAD = "Oh well. It is mine now.",
            SLEEPING = "Don't wake up. This is mine.",
            BUSY = "Hey, you don't want this right?",
        },
        WRITE =
        {
            GENERIC = "Blegh. Whoever wrote this did terrible!",
            INUSE = "Don't write bad about me!",
        },
        DRAW =
        {
            NOIMAGE = "I need a thingy to uh.. look at.. Drawing is easy!",
        },
        CHANGEIN =
        {
            GENERIC = "Not in style.",
            BURNING = "Ha-Ha, they will stay ugly!",
            INUSE = "Occupied by an idiot.",
            NOTENOUGHHAIR = "They are too ugly.",
            NOOCCUPANT = "Not working.",
        },
        ATTUNE =
        {
            NOHEALTH = "No no, I don't feel right...",
        },
        MOUNT =
        {
            TARGETINCOMBAT = "It is too angry and I am too close!",
            INUSE = "Get off! It is my turn.",
        },
        SADDLE =
        {
            TARGETINCOMBAT = "It is moving too much, I can't put it on.",
        },
        TEACH =
        {
            --Recipes/Teacher
            KNOWN = "I already know that one.",
            CANTLEARN = "I can't learn that one.",

            --MapRecorder/MapExplorer
            WRONGWORLD = "It is blank.",

			--MapSpotRevealer/messagebottle
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "The pictures do not match with this place.",--Likely trying to read messagebottle treasure map in caves
        },
        WRAPBUNDLE =
        {
            EMPTY = "I must fill it with treats.",
        },
        PICKUP =
        {
			RESTRICTION = "I am not allowed to steal this.",
			INUSE = "Give it to me now!",
            NOTMINE_SPIDER = "only_used_by_webber",
            NOTMINE_YOTC =
            {
                "I don't know you.",
                "You are a fake family.",
            },
			NO_HEAVY_LIFTING = "only_used_by_wanda",
        },
        SLAUGHTER =
        {
            TOOFAR = "I am bored now anyways.",
        },
        REPLATE =
        {
            MISMATCH = "It needs another type of dish.",
            SAMEDISH = "I only need to use one dish.",
        },
        SAIL =
        {
        	REPAIR = "Not broken.",
        },
        ROW_FAIL =
        {
            BAD_TIMING0 = "Gah!",
            BAD_TIMING1 = "Work Paddle!",
            BAD_TIMING2 = "I don't want to be wet!",
        },
        LOWER_SAIL_FAIL =
        {
            "Oopsie!",
            "My claw slipped.",
            "Not my fault!",
        },
        BATHBOMB =
        {
            GLASSED = "This is why I did not want to be in there.",
            ALREADY_BOMBED = "It is already bubbling.",
        },
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "That is too many.",
		},
		COMPARE_WEIGHABLE =
		{
            FISH_TOO_SMALL = "It has no meat!",
            OVERSIZEDVEGGIES_TOO_SMALL = "It weighs a lot. A lot less.",
		},
        BEGIN_QUEST =
        {
            ONEGHOST = "only_used_by_wendy",
        },
		TELLSTORY =
		{
			GENERIC = "only_used_by_walter",
			NOT_NIGHT = "only_used_by_walter",
			NO_FIRE = "only_used_by_walter",
		},
        SING_FAIL =
        {
            SAMESONG = "only_used_by_wathgrithr",
        },
        PLANTREGISTRY_RESEARCH_FAIL =
        {
            GENERIC = "I do not care about that.",
            FERTILIZER = "I do not care about that.",
        },
        FILL_OCEAN =
        {
            UNSUITABLE_FOR_PLANTS = "This water will only make them more thirsty.",
        },
        POUR_WATER =
        {
            OUT_OF_WATER = "Where is the water?",
        },
        POUR_WATER_GROUNDTILE =
        {
            OUT_OF_WATER = "Where is the water?",
        },
        USEITEMON =
        {
            --GENERIC = "I can't use this on that!",

            --construction is PREFABNAME_REASON
            BEEF_BELL_INVALID_TARGET = "That is stupid!",
            BEEF_BELL_ALREADY_USED = "It is not mine for some reason.",
            BEEF_BELL_HAS_BEEF_ALREADY = "Only one can fit inside.",
        },
        HITCHUP =
        {
            NEEDBEEF = "I am missing something...",
            NEEDBEEF_CLOSER = "Come here now, mush!",
            BEEF_HITCHED = "It is already there.",
            INMOOD = "It is ready to go up now.",
        },
        MARK =
        {
            ALREADY_MARKED = "This one is not mine.",
            NOT_PARTICIPANT = "I do not want to be a part of this.",
        },
        YOTB_STARTCONTEST =
        {
            DOESNTWORK = "Something is not right. Me being here.",
            ALREADYACTIVE = "That is stupid.",
        },
        YOTB_UNLOCKSKIN =
        {
            ALREADYKNOWN = "I already know how to do this.",
        },
        CARNIVALGAME_FEED =
        {
            TOO_LATE = "I need to keep moving.",
        },
        HERD_FOLLOWERS =
        {
            WEBBERONLY = "Those are not my family.",
        },
        BEDAZZLE =
        {
            BURNING = "only_used_by_webber",
            BURNT = "only_used_by_webber",
            FROZEN = "only_used_by_webber",
            ALREADY_BEDAZZLED = "only_used_by_webber",
        },
        UPGRADE = 
        {
            BEDAZZLED = "only_used_by_webber",
        },
		CAST_POCKETWATCH = 
		{
			GENERIC = "only_used_by_wanda",
			REVIVE_FAILED = "only_used_by_wanda",
			WARP_NO_POINTS_LEFT = "only_used_by_wanda",
			SHARD_UNAVAILABLE = "only_used_by_wanda",
		},
        DISMANTLE_POCKETWATCH =
        {
            ONCOOLDOWN = "only_used_by_wanda",
        },

        ENTER_GYM =
        {
            NOWEIGHT = "only_used_by_wolfang",
            UNBALANCED = "only_used_by_wolfang",
            ONFIRE = "only_used_by_wolfang",
            SMOULDER = "only_used_by_wolfang",
            HUNGRY = "only_used_by_wolfang",
            FULL = "only_used_by_wolfang",
        },
    },

	ACTIONFAIL_GENERIC = "Broke.",
	ANNOUNCE_BOAT_LEAK = "Plug it!!!",
	ANNOUNCE_BOAT_SINK = "No, No wait, I can't swim!",
	ANNOUNCE_DIG_DISEASE_WARNING = "It looks better already.", --removed
	ANNOUNCE_PICK_DISEASE_WARNING = "Uh, is it supposed to smell like that?", --removed
	ANNOUNCE_ADVENTUREFAIL = "That will not work!",
    ANNOUNCE_MOUNT_LOWHEALTH = "It is looking sad",

    --waxwell and wickerbottom specific strings
    ANNOUNCE_TOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
    ANNOUNCE_WAYTOOMANYBIRDS = "only_used_by_waxwell_and_wicker",

    --wolfgang specific
    ANNOUNCE_NORMALTOMIGHTY = "only_used_by_wolfang",
    ANNOUNCE_NORMALTOWIMPY = "only_used_by_wolfang",
    ANNOUNCE_WIMPYTONORMAL = "only_used_by_wolfang",
    ANNOUNCE_MIGHTYTONORMAL = "only_used_by_wolfang",
    ANNOUNCE_EXITGYM = {
        MIGHTY = "only_used_by_wolfang",
        NORMAL = "only_used_by_wolfang",
        WIMPY = "only_used_by_wolfang",
    },

	ANNOUNCE_BEES = "BEEEEEEEEEEEEES!!!!",
	ANNOUNCE_BOOMERANG = "Why did you hit me?!",
	ANNOUNCE_CHARLIE = "",
	ANNOUNCE_CHARLIE_ATTACK = "AH! ",
	ANNOUNCE_CHARLIE_MISSED = "only_used_by_winona", --winona specific
	ANNOUNCE_COLD = "Ch-ch-ch",
	ANNOUNCE_HOT = "My fur is greasy... and I need... water...",
	ANNOUNCE_CRAFTING_FAIL = "That does not work, how stupid.",
	ANNOUNCE_DEERCLOPS = "Something big! From far away is coming closer...",
	ANNOUNCE_CAVEIN = "The roof is going to crush me!",
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"The roof is going to crush me!",
		"",
		"",
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "Here....",
        "I... do not need this..",
        "Take it. I... Do not need it.",
	},
	ANNOUNCE_SACREDCHEST_YES = "Gimmie, Gimmie!",
	ANNOUNCE_SACREDCHEST_NO = "It is broken.",
    ANNOUNCE_DUSK = "",

    --wx-78 specific
    ANNOUNCE_CHARGE = "only_used_by_wx78",
	ANNOUNCE_DISCHARGE = "only_used_by_wx78",

	ANNOUNCE_EAT =
	{
		GENERIC = "",
		PAINFUL = "Bleaugh!",
		SPOILED = "Ah, Finally ripe!",
		STALE = "It has some flavour.",
		INVALID = "Not in the mood to eat.",
        YUCKY = "No!",

        --Warly specific ANNOUNCE_EAT strings
		COOKED = "only_used_by_warly",
		DRIED = "only_used_by_warly",
        PREPARED = "only_used_by_warly",
        RAW = "only_used_by_warly",
		SAME_OLD_1 = "only_used_by_warly",
		SAME_OLD_2 = "only_used_by_warly",
		SAME_OLD_3 = "only_used_by_warly",
		SAME_OLD_4 = "only_used_by_warly",
        SAME_OLD_5 = "only_used_by_warly",
		TASTY = "only_used_by_warly",
    },

    ANNOUNCE_ENCUMBERED =
    {
        "It's.... mine...",
        "This... Is... Mine....",
        "I am... going to steal it...",
        "It's mine... Mine... MINE...",
        "My rats... Should be... doing this!",
        "I think... It is slipping...", 
        "Squeak... Squeak...",
        "Squeeeeak...", 
        "Guuuuhhh...",
    },
    ANNOUNCE_ATRIUM_DESTABILIZING =
    {
		"I think it's time to leave!",
		"What's that?!",
		"It's not safe here.",
	},
    ANNOUNCE_RUINS_RESET = "Evil has returned! AHAHA!",
    ANNOUNCE_SNARED = "Gah! Let me go, Stupid!",
    ANNOUNCE_SNARED_IVY = "This is not Funny!",
    ANNOUNCE_REPELLED = "Keep Hitting.",
	ANNOUNCE_ENTER_DARK = "Huh? where did everything go?",
	ANNOUNCE_ENTER_LIGHT = "My eyes used to work!",
	ANNOUNCE_FREEDOM = "I'm free! I'm finally free!",
	ANNOUNCE_HIGHRESEARCH = "I feel not stupid now!",
	ANNOUNCE_HOUNDS = "They're coming...",
	ANNOUNCE_WORMS = "I can smell worms coming...",
	ANNOUNCE_HUNGRY = "How can there be nothing to eat.",
	ANNOUNCE_HUNT_BEAST_NEARBY = "I tracked you down, stupid animal.",
	ANNOUNCE_HUNT_LOST_TRAIL = "Where did it go?",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "Stupid rain. Stupid animal.",
	ANNOUNCE_INV_FULL = "I NEED ALL THIS.",
	ANNOUNCE_KNOCKEDOUT = "Ughhh. Where am I?",
	ANNOUNCE_LOWRESEARCH = "I do not know how to do that.",
	ANNOUNCE_MOSQUITOS = "I can hear there is buzzing near.",
    ANNOUNCE_NOWARDROBEONFIRE = ".",
    ANNOUNCE_NODANGERGIFT = ".",
    ANNOUNCE_NOMOUNTEDGIFT = ".",
	ANNOUNCE_NODANGERSLEEP = "test",
	ANNOUNCE_NODAYSLEEP = ".",
	ANNOUNCE_NODAYSLEEP_CAVE = "I am not tired.",
	ANNOUNCE_NOHUNGERSLEEP = "!",
	ANNOUNCE_NOSLEEPONFIRE = ".",
	ANNOUNCE_NODANGERSIESTA = "I!",
	ANNOUNCE_NONIGHTSIESTA = ".",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "I.",
	ANNOUNCE_NOHUNGERSIESTA = "I am not napping now.",
	ANNOUNCE_NO_TRAP = "I did it!",
	ANNOUNCE_PECKED = "Stupid thing!",
	ANNOUNCE_QUAKE = "Something is crumbling!",
	ANNOUNCE_RESEARCH = "I think this is good.",
	ANNOUNCE_SHELTER = "I would rather be in my hole.",
	ANNOUNCE_THORNS = "EEP.",
	ANNOUNCE_BURNT = "GAAAH!",
	ANNOUNCE_TORCH_OUT = "Huh? I thougt.. but..",
	ANNOUNCE_THURIBLE_OUT = "The sour-sweet smell is gone....",
	ANNOUNCE_FAN_OUT = "The stupid fan fell apart.",
    ANNOUNCE_COMPASS_OUT = "It stopped spinning, stupid thing.",
	ANNOUNCE_TRAP_WENT_OFF = "What?",
	ANNOUNCE_UNIMPLEMENTED = "It is not real yet.",
	ANNOUNCE_WORMHOLE = "I do not want to be eaten again!",
	ANNOUNCE_TOWNPORTALTELEPORT = "Pleugh! I have sand in my mouth.",
	ANNOUNCE_CANFIX = "\nMaybe I can stick more things on it!",
	ANNOUNCE_ACCOMPLISHMENT = "This is the best I have done!",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "I am satisfied.",
	ANNOUNCE_INSUFFICIENTFERTILIZER = "It is lacking the right stuff.",
	ANNOUNCE_TOOL_SLIP = "I dropped it on purpose.",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "Huh? what happened?",
	ANNOUNCE_TOADESCAPING = "It wants to go smell up somewhere else.",
	ANNOUNCE_TOADESCAPED = "He has gone to stink another place.",


	ANNOUNCE_DAMP = "I do not like being wet.",
	ANNOUNCE_WET = "All this water is terrible!",
	ANNOUNCE_WETTER = "",
	ANNOUNCE_SOAKED = "I am like a big wet rag now..",

	ANNOUNCE_WASHED_ASHORE = "Ah! I am alive.",

    ANNOUNCE_DESPAWN = "I-I Don't want to go yet!",
	ANNOUNCE_BECOMEGHOST = "oOooOooo!!",
	ANNOUNCE_GHOSTDRAIN = "All these ghosts are annoying.",
	ANNOUNCE_PETRIFED_TREES = "Did I just hear trees screaming?",
	ANNOUNCE_KLAUS_ENRAGE = "AH! Time to flee!",
	ANNOUNCE_KLAUS_UNCHAINED = "Someone re-chain him?!",
	ANNOUNCE_KLAUS_CALLFORHELP = "What is he doing now?!",

	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "There's a form trapped inside.",
		GLASS_LOW = "I've almost got it out.",
		GLASS_REVEAL = "You're free!",
		IDOL_MED = "There's a form trapped inside.",
		IDOL_LOW = "I've almost got it out.",
		IDOL_REVEAL = "You're free!",
		SEED_MED = "There's a form trapped inside.",
		SEED_LOW = "I've almost got it out.",
		SEED_REVEAL = "You're free!",
	},

    --hallowed nights
    ANNOUNCE_SPOOKED = "AaaahH!!",
	ANNOUNCE_BRAVERY_POTION = "stupid spooks! I am not afraid.",
	ANNOUNCE_MOONPOTION_FAILED = "Perhaps I didn't let it steep long enough...",

	--winter's feast
	ANNOUNCE_EATING_NOT_FEASTING = "I should really share this with the others.",
	ANNOUNCE_WINTERS_FEAST_BUFF = "I'm feeling a surge of holiday spirit!",
	ANNOUNCE_IS_FEASTING = "Happy Winter's Feast!",
	ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "The holiday goes by so fast...",

    --lavaarena event
    ANNOUNCE_REVIVING_CORPSE = "Get up, lazy.",
    ANNOUNCE_REVIVED_OTHER_CORPSE = "Hurry, get up faster!",
    ANNOUNCE_REVIVED_FROM_CORPSE = "I feel better now.",

    ANNOUNCE_FLARE_SEEN = "What is that in the sky?",
    ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "Why is the boat shaking!",

    --willow specific
	ANNOUNCE_LIGHTFIRE =
	{
		"only_used_by_willow",
    },

    --winona specific
    ANNOUNCE_HUNGRY_SLOWBUILD =
    {
	    "only_used_by_winona",
    },
    ANNOUNCE_HUNGRY_FASTBUILD =
    {
	    "only_used_by_winona",
    },

    --wormwood specific
    ANNOUNCE_KILLEDPLANT =
    {
        "only_used_by_wormwood",
    },
    ANNOUNCE_GROWPLANT =
    {
        "only_used_by_wormwood",
    },
    ANNOUNCE_BLOOMING =
    {
        "only_used_by_wormwood",
    },

    --wortox specfic
    ANNOUNCE_SOUL_EMPTY =
    {
        "only_used_by_wortox",
    },
    ANNOUNCE_SOUL_FEW =
    {
        "only_used_by_wortox",
    },
    ANNOUNCE_SOUL_MANY =
    {
        "only_used_by_wortox",
    },
    ANNOUNCE_SOUL_OVERLOAD =
    {
        "only_used_by_wortox",
    },

    --walter specfic
	ANNOUNCE_SLINGHSOT_OUT_OF_AMMO =
	{
		"only_used_by_walter",
		"only_used_by_walter",
	},
	ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT =
	{
        "only_used_by_walter",
	},
	ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT =
	{
        "only_used_by_walter",
	},

    --quagmire event
    QUAGMIRE_ANNOUNCE_NOTRECIPE = "That is stupid.",
    QUAGMIRE_ANNOUNCE_MEALBURNT = "I made delicious slime!",
    QUAGMIRE_ANNOUNCE_LOSE = "Uh.. This is not good...",
    QUAGMIRE_ANNOUNCE_WIN = "Time to scatter!",

    ANNOUNCE_ROYALTY =
    {
        "Your majesty.",
        "Your stinkyness.",
        "My liege!",
    },

    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "I will zap things now! Ha Ha!",
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "GRaaAhAHaHaHA! Killing time!",
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "Hahaha no one will touch me.",
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "I need to start doing things!",
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "My fur is water-proof.",
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "Yes, I am full of energy!",

    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "Fur still feels... clingy...",
    ANNOUNCE_DETACH_BUFF_ATTACK            = "My claws need to be sharpened again.",
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "I feel sore...",
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "I could use a rat nap now...",
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "I don't want to be wet again!",
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "I could use a rat nap now...",

	ANNOUNCE_OCEANFISHING_LINESNAP = "Graaaah....",
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "Pull harder!",
	ANNOUNCE_OCEANFISHING_GOTAWAY = "Stupid fish...",
	ANNOUNCE_OCEANFISHING_BADCAST = "I threw it wrong.",
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE =
	{
		"I would rather be taking a rat-nap.",
		"This is so boring.",
		"Maybe I am not doing it right?",
		"Are there even fish out here!?",
	},

	ANNOUNCE_WEIGHT = "Weight: {weight}",
	ANNOUNCE_WEIGHT_HEAVY  = "Weight: {weight}\nYes, it is very big.",

	ANNOUNCE_WINCH_CLAW_MISS = "I hit nothing!",
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "These claws are terrible.",

    --Wurt announce strings
    ANNOUNCE_KINGCREATED = "only_used_by_wurt",
    ANNOUNCE_KINGDESTROYED = "only_used_by_wurt",
    ANNOUNCE_CANTBUILDHERE_THRONE = "only_used_by_wurt",
    ANNOUNCE_CANTBUILDHERE_HOUSE = "only_used_by_wurt",
    ANNOUNCE_CANTBUILDHERE_WATCHTOWER = "only_used_by_wurt",
    ANNOUNCE_READ_BOOK =
    {
        BOOK_SLEEP = "only_used_by_wurt",
        BOOK_BIRDS = "only_used_by_wurt",
        BOOK_TENTACLES =  "only_used_by_wurt",
        BOOK_BRIMSTONE = "only_used_by_wurt",
        BOOK_GARDENING = "only_used_by_wurt",
		BOOK_SILVICULTURE = "only_used_by_wurt",
		BOOK_HORTICULTURE = "only_used_by_wurt",
    },
    ANNOUNCE_WEAK_RAT = "He has no meat on him!",

    ANNOUNCE_CARRAT_START_RACE = "Mush carrot-rats!",

    ANNOUNCE_CARRAT_ERROR_WRONG_WAY = {
        "No, no! You're going the wrong way!",
        "Turn around, Stupid!",
    },
    ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "Get up, you're making me look bad.",
    ANNOUNCE_CARRAT_ERROR_WALKING = "Hurry up before I step on your tail.",
    ANNOUNCE_CARRAT_ERROR_STUNNED = "Stupid fake rat.",

    ANNOUNCE_GHOST_QUEST = "only_used_by_wendy",
    ANNOUNCE_GHOST_HINT = "only_used_by_wendy",
    ANNOUNCE_GHOST_TOY_NEAR = {
        "only_used_by_wendy",
    },
	ANNOUNCE_SISTURN_FULL = "only_used_by_wendy",
    ANNOUNCE_ABIGAIL_DEATH = "only_used_by_wendy",
    ANNOUNCE_ABIGAIL_RETRIEVE = "only_used_by_wendy",
	ANNOUNCE_ABIGAIL_LOW_HEALTH = "only_used_by_wendy",
    ANNOUNCE_ABIGAIL_SUMMON =
	{
		LEVEL1 = "only_used_by_wendy",
		LEVEL2 = "only_used_by_wendy",
		LEVEL3 = "only_used_by_wendy",
	},

    ANNOUNCE_GHOSTLYBOND_LEVELUP =
	{
		LEVEL2 = "only_used_by_wendy",
		LEVEL3 = "only_used_by_wendy",
	},

    ANNOUNCE_NOINSPIRATION = "only_used_by_wathgrithr",
    ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr",
    ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr",

    ANNOUNCE_WANDA_YOUNGTONORMAL = "only_used_by_wanda",
    ANNOUNCE_WANDA_NORMALTOOLD = "only_used_by_wanda",
    ANNOUNCE_WANDA_OLDTONORMAL = "only_used_by_wanda",
    ANNOUNCE_WANDA_NORMALTOYOUNG = "only_used_by_wanda",

	ANNOUNCE_POCKETWATCH_PORTAL = "My head is still spinning....",

	ANNOUNCE_POCKETWATCH_MARK = "only_used_by_wanda",
	ANNOUNCE_POCKETWATCH_RECALL = "only_used_by_wanda",
	ANNOUNCE_POCKETWATCH_OPEN_PORTAL = "only_used_by_wanda",
	ANNOUNCE_POCKETWATCH_OPEN_PORTAL_DIFFERENTSHARD = "only_used_by_wanda",

    ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "Oooh! I see now!",
    ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "I already knew that!",
    ANNOUNCE_ARCHIVE_NO_POWER = "Stupid thing! It is broken.",

    ANNOUNCE_PLANT_RESEARCHED =
    {
        "yes, that is precisely what I need to know.",
    },

    ANNOUNCE_PLANT_RANDOMSEED = "It will grow into... something I think...",

    ANNOUNCE_FERTILIZER_RESEARCHED = "I already knew it was good for plants. What else do I need to know?",

	ANNOUNCE_FIRENETTLE_TOXIN =
	{
		"Oooo... I am so warm...",
		"Ah! I am pricked!",
	},
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "The stinging burning is over. Finally.",

	ANNOUNCE_TALK_TO_PLANTS =
	{
        "Grow stupid plant",
        "Get bigger or something!",
		"Here I will sing La lala la!",
        "Grow or I will stomp you.",
        "Stupid plant keep growing",
	},

	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "Now it is time to hide and never look for them.",
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN = "They are hiding. Good!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND = 
	{
		"AH!",
		"No! no! Get away!",
		"I knew you'd be hiding there!",
		"I see you!",
	},
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_ONE_MORE = "Now where's that last one hiding?",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE = "I found the last one!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE_TEAM = "{name} found the last one!",
	ANNOUNCE_KITCOON_HIDANDSEEK_TIME_ALMOST_UP = "These little guys must be getting impatient...",
	ANNOUNCE_KITCOON_HIDANDSEEK_LOSEGAME = "I guess they don't want to play any more...",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR = "They probably wouldn't hide this far away, would they?",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR_RETURN = "The kitcoons should be nearby.",
	ANNOUNCE_KITCOON_FOUND_IN_THE_WILD = "I knew I saw something hiding over here!",

	ANNOUNCE_TICOON_START_TRACKING	= "He's caught the scent!",
	ANNOUNCE_TICOON_NOTHING_TO_TRACK = "Looks like he couldn't find anything.",
	ANNOUNCE_TICOON_WAITING_FOR_LEADER = "I should follow him!",
	ANNOUNCE_TICOON_GET_LEADER_ATTENTION = "He really wants me to follow him.",
	ANNOUNCE_TICOON_NEAR_KITCOON = "He must have found something!",
	ANNOUNCE_TICOON_LOST_KITCOON = "Looks like someone else found what he was looking for.",
	ANNOUNCE_TICOON_ABANDONED = "I'll find those little guys on my own.",
	ANNOUNCE_TICOON_DEAD = "Poor guy... Now where was he leading me?",

    -- YOTB
    ANNOUNCE_CALL_BEEF = "Mush, mush you beast.",
    ANNOUNCE_CANTBUILDHERE_YOTB_POST = "It will not work without the beast I clothed.",
    ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "Why must I learn these things.",

    -- AE4AE
    ANNOUNCE_EYEOFTERROR_ARRIVE = "AAh! What a horrible night!",
    ANNOUNCE_EYEOFTERROR_FLYBACK = "",
    ANNOUNCE_EYEOFTERROR_FLYAWAY = "Is it gone? it is gone.",

    -- PIRATES
    ANNOUNCE_CANT_ESCAPE_CURSE = "It is mine now!",
    ANNOUNCE_MONKEY_CURSE_1 = "Hmmm, this is not my tail!?",
    ANNOUNCE_MONKEY_CURSE_CHANGE = "GaH!!!",
    ANNOUNCE_MONKEY_CURSE_CHANGEBACK = "Mmm yes my whiskers! and tail! Lovely!",

    ANNOUNCE_PIRATES_ARRIVE = "That shanty can only mean one thing...",
	
	BATTLECRY =
	{
		GENERIC = "RAaaaGh!",
		PIG = "This is Rat-land NOW!!",
		PREY = "RAaaaGh!",
		SPIDER = "Get out of here!",
		SPIDER_WARRIOR = "GraAh! You are no match!",
		DEER = "RAgH! DiE!",
	},
	COMBAT_QUIT =
	{
		GENERIC = "I scared off the stupid beast.",
		PIG = "Guh, Stupid pig.",
		PREY = "I can not catch it!",
		SPIDER = "I will come back with more friends.",
		SPIDER_WARRIOR = "I will come back with more friends.",
	},

	DESCRIBE =
	{
		MULTIPLAYER_PORTAL = "A strange hole. I do not understand it.",
        MULTIPLAYER_PORTAL_MOONROCK = "Mmm! Maybe if I enter it will bring me to cheese world!",
        MOONROCKIDOL = "A little one eye guy.",
        CONSTRUCTION_PLANS = "Plans for something most decietful.",

        ANTLION =
        {
            GENERIC = "What are you? Some kind of sand beetle?",
            VERYHAPPY = "It ate my things and it is happy now...",
            UNHAPPY = "You are not getting any of my loot.",
        },
        ANTLIONTRINKET = "Very collectable, I must have more.",
        SANDSPIKE = "GAH! It is coarse and sharp!",
        SANDBLOCK = "Hey, let me out!",
        GLASSSPIKE = "It is sharp! And very stealable.",
        GLASSBLOCK = "I like this shiny tower. It is mine now.",
        ABIGAIL_FLOWER =
        {
            GENERIC ="Some stupid flower, I should eat it.",
			LEVEL1 = "",
			LEVEL2 = ".",
			LEVEL3 = "",

			-- deprecated
            LONG = "It hurts my soul to look at that thing.",
            MEDIUM = "It's giving me the creeps.",
            SOON = "Something is up with that flower!",
            HAUNTED_POCKET = "I don't think I should hang on to this.",
            HAUNTED_GROUND = "I'd die to find out what it does.",
        },

        BALLOONS_EMPTY = "These are worth stealing.",
        BALLOON = "It is shaped like a creature how is that?",
		BALLOONPARTY = "Popping things does make me happy...",
		BALLOONSPEED =
        {
            DEFLATED = "Huh? Where did the hole go.",
            GENERIC = "It has a hole I like it.",
        },
		BALLOONVEST = "The colours are ugly.",
		BALLOONHAT = "I will not wear this, it will make me look stupid.",

        BERNIE_INACTIVE =
        {
            BROKEN = "ha, no more.",
            GENERIC = "Fuzzy somewhat. mostly ash actually.",
        },

        BERNIE_ACTIVE = "How is he doing that?",
        BERNIE_BIG = "I will rip him apart if he turns on me.",

        BOOKSTATION = "I write with my nails, I do not care about this.",
        BOOK_BIRDS = "I like the birds inside.",
        BOOK_TENTACLES = "Paper in stacks.",
        BOOK_GARDENING = "Huh, I don't know what it means.",
		BOOK_SILVICULTURE = "This is about dirt I think.",
		BOOK_HORTICULTURE = "Huh, I don't know what it means.",
        BOOK_SLEEP = "Paper in stacks.",
        BOOK_BRIMSTONE = "Yes, very good, I can't read.",

        BOOK_FISH = "I want to eat afish now.",
        BOOK_FIRE = "Yes, it will suck up all the fire!",
        BOOK_WEB = "Cob webs can be tasty too.",
        BOOK_TEMPERATURE = "Paper about boring weather.",
        BOOK_LIGHT = "I do not like bright light.",
        BOOK_RAIN = "Yes, no more rain now.",
        BOOK_MOON = "This stupid book, it is not about cheese.",
        BOOK_BEES = "These pages they are very sticky.",
        
        BOOK_HORTICULTURE_UPGRADED = "It is dirtier I suppose.",
        BOOK_RESEARCH_STATION = "I am not stupid, I will figure it out.",
        BOOK_LIGHT_UPGRADED = "I do not like bright light.",

        FIREPEN = "Fire is not good for writing I think.",

        PLAYER =
        {
            GENERIC = "Hello you nobody!",
            ATTACKER = "Aha! You are evil!",
            MURDERER = "I know you did it!",
            REVIVER = "You are nice, just don't get handsy.",
            GHOST = "%s died stupidly.",
            FIRESTARTER = "%s is causing destruction!",
        },
        WILSON =
        {
            GENERIC = "No! I will not let you experiment on me.",
            ATTACKER = "Stabbing is not a good experiment.",
            MURDERER = "He has killing down to a science.",
            REVIVER = "I suppose you are not so bad, %s.",
            GHOST = "Now you're my lab rat, Hehe.",
            FIRESTARTER = "You should stop doing fire experiments, %s.",
        },
        WOLFGANG =
        {
            GENERIC = "Stop calling me \"Vinky\", there is not a V.",
            ATTACKER = "are you afraid of me? you should be.",
            MURDERER = "Killing me does not exterminate my family!",
            REVIVER = "You are very brave now I think.",
            GHOST = "If you keep running I won't be able to revive you %s.",
            FIRESTARTER = "Maybe you should burn more fat and less stuff.",
        },
        WAXWELL =
        {
            GENERIC = "The Shadows have taken him too.",
            ATTACKER = "You will not take me!",
            MURDERER = "He is a dark evil killer!",
            REVIVER = "I will not get your suit filthy!",
            GHOST = "Even dead you still have a nice suit.",
            FIRESTARTER = "Why are you burning the world you helped make?",
        },
        WX78 =
        {
            GENERIC = "%s, you are a metal head.",
            ATTACKER = "They have a cold metal heart.",
            MURDERER = "You do not like me, well I hate you too.",
            REVIVER = "This is very nice.",
            GHOST = "",
            FIRESTARTER = "You are very passionate about destruction.",
        },
        WILLOW =
        {
            GENERIC = "Missy burning girl.",
            ATTACKER = "You are very shifty, stop hiding.",
            MURDERER = "she is smiling, You are evil.",
            REVIVER = "Thank you, %s, but stop burning things.",
            GHOST = "I might give you a heart, if you ask nicely.",
            FIRESTARTER = "Stop burning everything for once!",
        },
        WENDY =
        {
            GENERIC = "This one looks broken.",
            ATTACKER = "You won't exterminate me!",
            MURDERER = "%s I do not like being a ghost. Stupid. ",
            REVIVER = "At least you care about me.",
            GHOST = "Should I? Or do you like being dead.",
            FIRESTARTER = "She is desolate and causing ruin!",
        },
        WOODIE =
        {
            GENERIC = "Tra lala la, Yes, yes I've heard it before.",
            ATTACKER = "Do you plan on swinging that axe at me?",
            MURDERER = "The Woodsman is the real monster!",
            REVIVER = "I'll tell all my family about the good woodsman!",
            GHOST = "He is a sheet now.",
            BEAVER = "Stop stealing my look, I should be the only one with teeth like that!",
            BEAVERGHOST = "Did you choke on a stump?",
            MOOSE = "The moose man?!?",
            MOOSEGHOST = "Maybe you should not go charging into rocks haha!",
            GOOSE = "Annoying Squaking noisy beast.",
            GOOSEGHOST = "At least it is quiet now.",
            FIRESTARTER = "I do not think burning that forest was an accident...",
        },
        WICKERBOTTOM =
        {
            GENERIC = "%s, you know many strange words.",
            ATTACKER = "You won't exterminate me!",
            MURDERER = "%s, I'm going to steal all your books now, you killer.",
            REVIVER = "Yes, you are nice. I will not steal your books now.",
            GHOST = "She did not have the right books to live.",
            FIRESTARTER = "Maybe I should start burning books too.",
        },
        WES =
        {
            GENERIC = "Do you even talk %s?",
            ATTACKER = "You are acting very silent all of a sudden.",
            MURDERER = "That is a lot of red paint.",
            REVIVER = "He is the loving silent type.",
            GHOST = "Ask if you want to be alive again.",
            FIRESTARTER = "He has an invisble torch! I see it!",
        },
        WEBBER =
        {
            GENERIC = "We are not related, leave me alone, %s",
            ATTACKER = "You are petty.",
            MURDERER = "Rats and Spiders cannot co-exist.",
            REVIVER = "we are friends, how about that?",
            GHOST = "You must sign a treaty, no more rat killing.",
            FIRESTARTER = "Stupid boy stop burning everything!",
        },
        WATHGRITHR =
        {
            GENERIC = "You are very loud %s.",
            ATTACKER = "You won't exterminate me!",
            MURDERER = "I will always come back to taunt you.",
            REVIVER = "I am warrior like her now. I think.",
            GHOST = "You should get back into doing your thing.",
            FIRESTARTER = "She is a pillager!",
        },
        WINONA =
        {
            GENERIC = "I won't cause a problem, I promise!",
            ATTACKER = "Stealing from you was an accident, no need to fight!",
            MURDERER = "I see... I am just another rat to you.",
            REVIVER = "I will not steal from you, now.",
            GHOST = "",
            FIRESTARTER = "",
        },
        WORTOX =
        {
            GENERIC = "You do not look like you're from around here %s?",
            ATTACKER = "You can not steal my soul!",
            MURDERER = "Stupid imp, I am back to take your soul!",
            REVIVER = "you were scared white, haha!",
            GHOST = "Haha, not enough souls for you?",
            FIRESTARTER = "You stupid imp stop burning everything.",
        },
        WORMWOOD =
        {
            GENERIC = "Plants do not talk, %s. Well you do, but you are weird.",
            ATTACKER = "Stop hitting me, stupid thing!",
            MURDERER = "You should've stayed as a plant, I can make that happen!",
            REVIVER = "Strange plant, but it nice, I guess.",
            GHOST = "I did not know a plant can die.",
            FIRESTARTER = "How have you not lit yourself on fire?",
        },
        WARLY =
        {
            GENERIC = "I don't suppose you have any cheddar on you %s?",
            ATTACKER = "I am sorry, I won't pull your hair again!",
            MURDERER = "Is rat on the menu then?",
            REVIVER = "He might need my help in the kitchen.",
            GHOST = "If I make you fleshy again, you will make me a chef, no?",
            FIRESTARTER = "You stink at cooking. I am better.",
        },

        WURT =
        {
            GENERIC = "%s you have a nice stink today, as usual.",
            ATTACKER = "Claw me and I will claw back!",
            MURDERER = "She is slimey and stinky and evil!",
            REVIVER = "%s, we will stink this place together.",
            GHOST = "Still smells fishy.",
            FIRESTARTER = "You have the spark!",
        },

        WALTER =
        {
            GENERIC = "stop calling me weird names, %s.",
            ATTACKER = "Watch where you throw things!",
            MURDERER = "%s, I will have my revenge!",
            REVIVER = "I will respect you, for now.",
            GHOST = "Aaah... peace and quiet.",
            FIRESTARTER = "Stupid boy, stop burning everything!",
        },

        WANDA =
        {
            GENERIC = "I suppose you like to hoard clocks.",
            ATTACKER = "Look at your clocks, and stay away from me.",
            MURDERER = "So Just because I am not perfect, I am your next target?",
            REVIVER = "she needs me around, maybe?",
            GHOST = "Is dying a time thing.",
            FIRESTARTER = "You have time to burn things, I see...",
        },
		
		WONKEY =
        {
            GENERIC = "You better not take my things...",
            ATTACKER = "GragH! Don't touch me! The loot is mine!",
            MURDERER = "You! Give me my loot.",
            REVIVER = "",
            GHOST = "you probably died for stealing something.", 
            FIRESTARTER = "Stupid, Monkey, stop burning things.",  
        },

        MIGRATION_PORTAL =
        {
        --    GENERIC = "If I had any friends, this could take me to them.",
        --    OPEN = "If I step through, will I still be me?",
        --    FULL = "It seems to be popular over there.",
        },
        GLOMMER =
        {
            GENERIC = "I hope you are Tasty.",
            SLEEPING = "I will smush you into bug jelly. Yes...",
        },
        GLOMMERFLOWER =
        {
            GENERIC = "Pungent, I like this!",
            DEAD = "Crusty flower now.",
        },
        GLOMMERWINGS = "Beetle wings.",
        GLOMMERFUEL = "I could eat this everyday!",
        BELL = "Danger warning.",
        STATUEGLOMMER =
        {
            GENERIC = "Malformed Rocks.",
            EMPTY = "It is broken open and there was nothing for me?",
        },

        LAVA_POND_ROCK = "Black stinky rocks.",

		WEBBERSKULL = "Served him right.",
		WORMLIGHT = "Sticky gooey insides.",
		WORMLIGHT_LESSER = "A little treat.",
		WORM =
		{
		    PLANT = "Was that always there?",
		    DIRT = "I know you are here for me!",
		    WORM = "GAH Worm beasts, come for me!",
		},
        WORMLIGHT_PLANT = "Seems safe to me.",
		MOLE =
		{
			HELD = "I do the holes 'round here!",
			UNDERGROUND = "Stupid, I will eat you!",
			ABOVEGROUND = "Worm part is the tasty part!",
		},
		MOLEHILL = "There better not be any of my things in there.",
		MOLEHAT = "Like seeing with my nose!",

		EEL = "I will bite your head off.",
		EEL_COOKED = "Still slimey and good.",
		UNAGI = "These little bits are sastisfying.",
		EYETURRET = "Stupid fiend, stop looking at me!",
		EYETURRET_ITEM = "I have heard looks can kill.",
		MINOTAURHORN = "Eat it or not to eat...",
		MINOTAURCHEST = "It is full of things for me.",
		THULECITE_PIECES = "Pebbled Stones.",
		POND_ALGAE = "Stomping it is funny!",
		GREENSTAFF = "It has magics!",
		GIFT = "Aw, you should not have!",
        GIFTWRAP = "I like to receive.",
		POTTEDFERN = "They are everywhere undergound. They are not pretty.",
        SUCCULENT_POTTED = "This does not suck!",
		SUCCULENT_PLANT = "Nice looking. Green tasting.",
		SUCCULENT_PICKED = "Oozy.",
		SENTRYWARD = "It can see me?!",
        TOWNPORTAL =
        {
			GENERIC = "I prefer rat by rat highway.",
			ACTIVE = "Not touching.",
		},
        TOWNPORTALTALISMAN =
        {
			GENERIC = "Fun for Kicking.",
			ACTIVE = "Ooo they were special rocks.",
		},
        WETPAPER = "I hope it dries off soon.",
        WETPOUCH = "Is my lunch in there?",
        MOONROCK_PIECES = "Boring.",
        MOONBASE =
        {
            GENERIC = "There's a hole in the middle for something to go in.",
            BROKEN = " Cheese here?",
            STAFFED = "Broken?",
            WRONGSTAFF = "This is not the right hole for it.",
            MOONSTAFF = "Oh haha, the skylight is here!",
        },
        MOONDIAL =
        {
			GENERIC = "It is a bath for the birds.",
			NIGHT_NEW = "It is a bath for the birds.",
			NIGHT_WAX = "It is a bath for the birds.",
			NIGHT_FULL = "It is a bath for the birds.",
			NIGHT_WANE = "It is a bath for the birds.",
			CAVE = "It refelcts the ceiling nicely.",
			WEREBEAVER = "only_used_by_woodie", --woodie specific
			GLASSED = "Yes, it is not water anymore.",
        },
		THULECITE = "Unique stone thing... yes.",
		ARMORRUINS = "The colour brings out my eyes.",
		ARMORSKELETON = "Bones have more uses than I thought.",
		SKELETONHAT = "This is my head hat now.",
		RUINS_BAT = "Good for playing Rat-Ball, you wouldn't get it...",
		RUINSHAT = "I am queen of all rats now!",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = " phew.... It is over...",
            WARN = "This is not good...",
            WAXING = "This is why rats NEVER come here.",
            STEADY = "The Evil is still in the air.",
            WANING = "Evil is still here.",
            DAWN = "I'm almost free!",
            NOMAGIC = "The Evil, it has vanished.",
		},
		BISHOP_NIGHTMARE = "Horrible gnashing metal!",
		ROOK_NIGHTMARE = "Screching metal horror!",
		KNIGHT_NIGHTMARE = "Clunking buzzy metal thing!",
		MINOTAUR = "That thing doesn't look happy.",
		SPIDER_DROPPER = "Why are you white now?",
		NIGHTMARELIGHT = "Many silent whispers.",
		NIGHTSTICK = "I want to lick it, I know I can't but I must.",
		GREENGEM = "My jewels!",
		MULTITOOL_AXE_PICKAXE = "For whacking and hacking.",
		ORANGESTAFF = "eye of jewels.",
		YELLOWAMULET = "It is like an eye of ire.",
		GREENAMULET = "The green jewel makes me better at making, yes I see.",
		SLURPERPELT = "Not bad tasting.",

		SLURPER = "You can not eat what I eat!",
		SLURPER_PELT = "Not bad tasting.",
		ARMORSLURPER = "It is my style.",
		ORANGEAMULET = "Collecting is easy now! I can make so many collections!",
		YELLOWSTAFF = "This light stick is quite nice, yes.",
		YELLOWGEM = "My jewels!",
		ORANGEGEM = "My jewels!",
        OPALSTAFF = "This will be a center piece to all Rat collections!",
        OPALPRECIOUSGEM = "Round and Appealing, It is mine now.",
        TELEBASE =
		{
			VALID = "Purple power",
			GEMS = "It is broken I think.",
		},
		GEMSOCKET =
		{
			VALID = "Good now?",
			GEMS = "It needs a jewel.",
		},
		STAFFLIGHT = "",
        STAFFCOLDLIGHT = "",

        ANCIENT_ALTAR = "Evil Magic is made here!",

        ANCIENT_ALTAR_BROKEN = "Rubble now.",

        ANCIENT_STATUE = "Old thing. We never come here",

        LICHEN = "It's uhh.. Not that good tasting..",
		CUTLICHEN = "Tastes okay at first, but it grows on you.",

		CAVE_BANANA = "Less seeds than I remember.",
		CAVE_BANANA_COOKED = "Never tried them like this! It is good!",
		CAVE_BANANA_TREE = "Those Blue Rascals eat most of them.",
		ROCKY = "I have tried eating gravel, It was not very good.",

		COMPASS =
		{
			GENERIC = "Why is the arrow so spinny?",
			N = "Right way.",
			S = "Wrong way.",
			E = "Facing right.",
			W = "Facing left.",
			NE = "Northeast.",
			SE = "Southeast.",
			NW = "Northwest.",
			SW = "Southwest.",
		},

        HOUNDSTOOTH = "Teeth!",
        ARMORSNURTLESHELL = "I can be imitation snail.",
        BAT = "You are like me but ULGY, and NOT ME!",
        BATBAT = "Whacking Whacker.",
        BATWING = "The wingy part is most delicious.",
        BATWING_COOKED = "Tastes like snake?",
        BATCAVE = "I should crush their home.",
        BEDROLL_FURRY = "Mmm, they are good for something afterall!",
        BUNNYMAN = "They hate us for eating meat. How do you not like meat?",
        FLOWER_CAVE = "Light weeds.",
        GUANO = "Caca.",
        LANTERN = "Glowing nicely.",
        LIGHTBULB = "Tastes bland after a while.",
        MANRABBIT_TAIL = "Useless fluff!",
        MUSHROOMHAT = "It makes me look silly.",
        MUSHROOM_LIGHT2 =
        {
            ON = "How do I make it cheese coloured now?",
            OFF = "It completes the feng shui of the base.",
            BURNT = "Maybe there was an electrical fire?",
        },
        MUSHROOM_LIGHT =
        {
            ON = "This would make for good reading light. If I could read.",
            OFF = "I could use one in my burrow.",
            BURNT = "Maybe there was an electrical fire?",
        },
        SLEEPBOMB = ".",
        MUSHROOMBOMB = "",
        SHROOM_SKIN = "Will I get warts now?",
        TOADSTOOL_CAP =
        {
            EMPTY = "Damp hole.",
            INGROUND = "Bump in the ground.",
            GENERIC = "I have the urge, crush that mushroom.",
        },
        TOADSTOOL =
        {
            GENERIC = "He is so.. Bumpy and stupid looking.",
            RAGE = "AAAAH! He is angry now too!",
        },
        MUSHROOMSPROUT =
        {
            GENERIC = "",
            BURNT = "",
        },
        MUSHTREE_TALL =
        {
            GENERIC = "",
            BLOOM = "Y",
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "T.",
            BLOOM = "s.",
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "?",
            BLOOM = ".",
        },
        MUSHTREE_TALL_WEBBED = "Hmmm, Rats should do that too.",
        SPORE_TALL =
        {
            GENERIC = "Lost, I think.",
            HELD = "Looks tasty!",
        },
        SPORE_MEDIUM =
        {
            GENERIC = "They are always here this time of year.",
            HELD = "Looks tasty!",
        },
        SPORE_SMALL =
        {
            GENERIC = "Floating aimlessly... Boring.",
            HELD = "Looks tasty!",
        },
        RABBITHOUSE =
        {
            GENERIC = "Could make it a rat hutch.",
            BURNT = "Meh, too bad.",
        },
        SLURTLE = "Delicious slime maker!",
        SLURTLE_SHELLPIECES = "sharp bits.",
        SLURTLEHAT = "I am slime now.",
        SLURTLEHOLE = "The most delcious slime is made there.",
        SLURTLESLIME = "It goes good on anything.",
        SNURTLE = "Stupid, runs away.",
        SPIDER_HIDER = "Beat it shorty!",
        SPIDER_SPITTER = "My family can throw futher!",
        SPIDERHOLE = "We must take it over!",
        SPIDERHOLE_ROCK = "It is old and webbed.",
        STALAGMITE = "Looks like a rock to me.",
        STALAGMITE_TALL = "Rocks, rocks, rocks, rocks...",

        TURF_CARPETFLOOR = "I would sleep on it. yes, yes.",
        TURF_CHECKERFLOOR = "It is better than rat stone.",
        TURF_DIRT = "Dirt.",
        TURF_FOREST = "Dirt.",
        TURF_GRASS = "Dirt.",
        TURF_MARSH = "Dirt.",
        TURF_METEOR = "*Sniff* *Sniff* It is supposed to be Cheese?!?",
        TURF_PEBBLEBEACH = "It is very much a thing.",
        TURF_ROAD = "It is worse than rat-stone.",
        TURF_ROCKY = "Dirt.",
        TURF_SAVANNA = "Dirt.",
        TURF_WOODFLOOR = "Tree floor",

		TURF_CAVE="Dirty Dirt.",
		TURF_FUNGUS="Fungi Dirt.",
		TURF_FUNGUS_MOON = "Dirty Dirt.",
		TURF_ARCHIVE = "Dirty Dirt.",
		TURF_SINKHOLE="Dirty Dirt.",
		TURF_UNDERROCK="Dirty Dirt.",
		TURF_MUD="Dirty Dirt.",

		TURF_DECIDUOUS = "Dirty Dirt.",
		TURF_SANDY = "Dirty Dirt.",
		TURF_BADLANDS = "Dirty Dirt.",
		TURF_DESERTDIRT = "Dirt.",
		TURF_FUNGUS_GREEN = "Fungi Dirt.",
		TURF_FUNGUS_RED = "Fungi Dirt.",
		TURF_DRAGONFLY = "Beetle Carpet",

        TURF_SHELLBEACH = "It is very much a thing.",
		
	    TURF_MONKEY_GROUND = "Dirty Dirt.",

        TURF_CARPETFLOOR2 = "I would sleep on it. yes, yes.",
        TURF_MOSAIC_GREY = "It is weird coloured, ground.",
        TURF_MOSAIC_RED = "It is weird coloured, ground.",
        TURF_MOSAIC_BLUE = "It is weird coloured, ground.",
		
		POWCAKE = "Where were you all my miserable life!",
        CAVE_ENTRANCE = "that rock looks good for bashing.",
        CAVE_ENTRANCE_RUINS = "Many silent whispers from there. Scary.",

       	CAVE_ENTRANCE_OPEN =
        {
            GENERIC = "I will find a way back home!",
            OPEN = "Down, down to Rat-Town.",
            FULL = "Who is preventing me from going down!",
        },
        CAVE_EXIT =
        {
            GENERIC = "Wouldn't be the first time it was closed.",
            OPEN = "I've had enough discovery for now.",
            FULL = "I'll gnaw my way up!",
        },

		MAXWELLPHONOGRAPH = "EEhhh, it is making grating sounds.",--single player
		BOOMERANG = "I throw it, and it tries to KILL ME!",
		PIGGUARD = "Keeping me away from the secrects and treasure.",
		ABIGAIL =
		{
            LEVEL1 =
            {
                "She is not as dead. Good?",
                "She is not as dead. Good?",
            },
            LEVEL2 =
            {
                "She is not as dead. Good?",
                "She is not as dead. Good?",
            },
            LEVEL3 =
            {
                "She is not as dead. Good?",
                "She is not as dead. Good?",
            },
		},
		ADVENTURE_PORTAL = "A door to nowhere-land.",
		AMULET = "The Omlette.",
		ANIMAL_TRACK = "Feet marks.",
		ARMORGRASS = "It makes me feel nice.",
		ARMORMARBLE = "I do not like lugging this around.",
		ARMORWOOD = "Knock-knock. Who is there? Wood.",
		ARMOR_SANITY = "Reminds me of my hatred Grrrrr.",
		ASH =
		{
			GENERIC = "Dust from something",
			REMAINS_GLOMMERFLOWER = "The smelly flower is dust.",
			REMAINS_EYE_BONE = "The bone is now a pile of dust.",
			REMAINS_THINGIE = "It is just dust now.",
		},
		AXE = "It is for hacking, and slicing!",
		BABYBEEFALO =
		{
			GENERIC = "You could use a few pounds.",
		    SLEEPING = "Killing you will be easy.",
        },
        BUNDLE = "Stashed Treats for later, E-hehe.",
        BUNDLEWRAP = "Stashing wrap.",
		BACKPACK = "It is very nice, more to carry for my hoard.",
		BACONEGGS = "Egg murder breakfast.",
		BANDAGE = "I like to lick it first!",
		BASALT = "Maybe if we push it.", 
		BEARDHAIR = "Pleugh! It is always in my mouth?!",
		BEARGER = "Time to SQUEAK! Get away!!",
		BEARGERVEST = "Not as greasy as my fur! Soon it will....",
		ICEPACK = "How is it cold if there is no ice?",
		BEARGER_FUR = "my rat bed could use this.",
		BEDROLL_STRAW = "I prefer dirt.",
		BEEQUEEN = "Squeak! AAAH GET AWAY FROM ME!! ",
		BEEQUEENHIVE =
		{
			GENERIC = "Ahaha, I must get inside!",
			GROWING = "Patience is not a virtue of mine!",
		},
        BEEQUEENHIVEGROWN = "Mmmm the gooey sweetness I must have it!",
        BEEGUARD = "Fluffy and stupid!",
        HIVEHAT = "The shapeness of it is perfect!",
        MINISIGN =
        {
            GENERIC = "Ugly pictures!",
            UNDRAWN = "I should scratch on it.",
        },
        MINISIGN_ITEM = "Why are we not throwing everything on one BIG! PILE!",
		BEE =
		{
			GENERIC = "They are making me food. They are not food.",
			HELD = "They are not good for eating. Trust me.",
		},
		BEEBOX =
		{
			READY = "Oozing the stuff I want.",
			FULLHONEY = "Oozing the stuff I want.",
			GENERIC = "They do not like me.",
			NOHONEY = "Make More gooey stuff.",
			SOMEHONEY = "Ooh, I see some!",
			BURNT = "Grumble... It WAS NOT ME.",
		},
		MUSHROOM_FARM =
		{
			STUFFED = "Many snacks for me! Hehehe!",
			LOTS = "I did not know you could force them to grow.",
			SOME = "Interesting..",
			EMPTY = "There should... Be a fungus there.",
			ROTTEN = "soggy and lonely now.",
			BURNT = "Nothing now.",
			SNOWCOVERED = "Useless wood.",
		},
		BEEFALO =
		{
			FOLLOWER = "Hmm I guess we could be \"friends\".",
			GENERIC = "Beefy, how I like my meat.",
			NAKED = "Haha you are naked, and I am not.",
			SLEEPING = "They are snoring so loudly.",
            --Domesticated states:
            DOMESTICATED = "He will make for a meaty shield.",
            ORNERY = "You must despise me. Good.",
            RIDER = "You make for a good slave.",
            PUDGY = "Killing you will be very worthwhile!",
            MYPARTNER = "I guess we are smelly friends now.",
		},

		BEEFALOHAT = "It is good for my ears.",
		BEEFALOWOOL = "Rat den stuffing.",
		BEEHAT = "He-he-he they can not! touch me now.",
        BEESWAX = "still tastes bitter! Bleugh.",
		BEEHIVE = "Once I had a big pustule from stealing their honey.",
		BEEMINE = "Shake them around! HAHAHA!!!",
		BEEMINE_MAXWELL = "Squeak!", --removed
		BERRIES = "Enough to feed each ratling.",
		BERRIES_COOKED = "Mushy.",
        BERRIES_JUICY = "They rippen so quickly!",
        BERRIES_JUICY_COOKED = "They have such a nice smell when they spoil!",
		BERRYBUSH =
		{
			BARREN = "Crooked...",
			WITHERED = "Drier than dirt.",
			GENERIC = "little yummy squishy things on it.",
			PICKED = "Find new bush.",
			DISEASED = "I do not want to eat that!",--removed
			DISEASING = "Hmm smells more yucky!",--removed
			BURNING = "I have had it with fire!",
		},
		BERRYBUSH_JUICY =
		{
			BARREN = "Crooked...",
			WITHERED = "Drier than dirt.",
			GENERIC = "They are higher on this one.",
			PICKED = "Find new bush.",
			DISEASED = "I do not want to eat that!",--removed
			DISEASING = "Hmm smells more yucky!",--removed
			BURNING = "I have had it with fire!",
		},
		BIGFOOT = "SQUEAK!! AAAHH DO NOT CRUSH ME!!!",--removed
		BIRDCAGE =
		{
			GENERIC = "I must find a good slave.",
			OCCUPIED = "He-he you are my mine now!",
			SLEEPING = "Rest now...",
			HUNGRY = "It is MY food though.",
			STARVING = "Keeling over? I do want an egg.",
			DEAD = "Eh... No more eggs...",
			SKELETON = "Teeny, teeny, tiny bones.",
		},
		BIRDTRAP = "My snout was caught in one once.",
		CAVE_BANANA_BURNT = "Not my fault!",
		BIRD_EGG = "They have a nice crunch to them.",
		BIRD_EGG_COOKED = "Yellow part is the most delcious.",
		BISHOP = "Why are you looking at me like that.",
		BLOWDART_FIRE = "I should cover it in my spit too.",
		BLOWDART_SLEEP = "An easy way to get a meal.",
		BLOWDART_PIPE = "He he he, they will never know.",
		BLOWDART_YELLOW = "Ha, I will be a storm of needles now.",
		BLUEAMULET = "I do not want to be cold all them time.",
		BLUEGEM = "My icey jewel.",
		BLUEPRINT =
		{
            COMMON = "It has weird scratches on it, what do they mean?",
            RARE = "This has more scratches and they are fancier.",
        },
        SKETCH = "It is paper with scratches on it.",
		BLUE_CAP = "This one is my favourite.",
		BLUE_CAP_COOKED = "I have not eaten them cooked before.",
		BLUE_MUSHROOM =
		{
			GENERIC = "Aaah What a delicous smell",
			INGROUND = "They are always up where I'm from.",
			PICKED = "Just a little hole now.",
		},
		BOARDS = "Boards.",
		BONESHARD = "Bits of bone.",
		BONESTEW = "A stew to put some meat on your bones.",
		BUGNET = "I can stick my fingers through the holes.",
		BUSHHAT = "I will be able to hide any where.",
		BUTTER = "Greasy and good.",
		BUTTERFLY =
		{
			GENERIC = "Come here, I want to eat you.",
			HELD = "You are mine!",
		},
		BUTTERFLYMUFFIN = "",
		BUTTERFLYWINGS = "Will I grow wings if I eat them?",
		BUZZARD = "Grow fat on some roadkill.",

		SHADOWDIGGER = "Oh good. Now there's more of him.",

		CACTUS =
		{
			GENERIC = "I can not steal that.",
			PICKED = "Deflated now.",
		},
		CACTUS_MEAT_COOKED = "Nice smell and no spikes this time.",
		CACTUS_MEAT = "I do not like the spikes.",
		CACTUS_FLOWER = "I am surprised it is not spiky too.",

		COLDFIRE =
		{
			EMBERS = "",
			GENERIC = "",
			HIGH = "",
			LOW = "",
			NORMAL = "",
			OUT = "",
		},
		CAMPFIRE =
		{
			EMBERS = "",
			GENERIC = "",
			HIGH = "",
			LOW = "",
			NORMAL = "",
			OUT = "",
		},
		CANE = "Sticks are good for whacking, and I guess running.",
		CATCOON = "They scare me...",
		CATCOONDEN =
		{
			GENERIC = "Not. A. Rat hole.",
			EMPTY = "Ha.",
		},
		CATCOONHAT = "Every other rat will trust me more now. Perfect.",
		COONTAIL = "Yes, it is mine now, Stupid cat.",
		CARROT = "",
		CARROT_COOKED = "",
		CARROT_PLANTED = "A snack for me.",
		CARROT_SEEDS = "Crunchy little bits.",
		CARTOGRAPHYDESK =
		{
			GENERIC = "Why would I want to show everyone where I hide my things.",
			BURNING = "It was pointless.",
			BURNT = "I think I like it better.",
		},
		WATERMELON_SEEDS = "Crunchy little bits.",
		CAVE_FERN = "I used to eat these sometimes.",
		CHARCOAL = "",
        CHESSPIECE_PAWN = "Not that impressive.",
        CHESSPIECE_ROOK =
        {
            GENERIC = "A castle.",
            STRUGGLE = "Stone does not hatch, what baby is in there?",
        },
        CHESSPIECE_KNIGHT =
        {
            GENERIC = "A Grotesque.",
            STRUGGLE = "Stone does not hatch, what baby is in there?!",
        },
        CHESSPIECE_BISHOP =
        {
            GENERIC = "A tower.",
            STRUGGLE = "Stone does not hatch, what baby is in there?",
        },
        CHESSPIECE_MUSE = "Who inspired you?",
        CHESSPIECE_FORMAL = "Who inspired you?",
        CHESSPIECE_HORNUCOPIA = "Why lie and make fake food?",
        CHESSPIECE_PIPE = "Smoke bubbles?",
        CHESSPIECE_DEERCLOPS = "I do not like it.",
        CHESSPIECE_BEARGER = "Yes, you could say it is grizzly.",
        CHESSPIECE_MOOSEGOOSE =
        {
            "It is egg shaped, like a bird should.",
        },
        CHESSPIECE_DRAGONFLY = "This one is not as hot. Good.",
		CHESSPIECE_MINOTAUR = "It is very thick headed, like the real one.",
        CHESSPIECE_BUTTERFLY = "This one does not fly as good.",
        CHESSPIECE_ANCHOR = "Yes, I guess art really does imitate life.",
        CHESSPIECE_MOON = "Imitation cheese statue.",
        CHESSPIECE_CARRAT = "Where is my statue?!",
        CHESSPIECE_MALBATROSS = "",
        CHESSPIECE_CRABKING = "He is king of the crabs I think? That sounds stupid.",
        CHESSPIECE_TOADSTOOL = "At least this one does not make mushrooms.",
        CHESSPIECE_STALKER = "If it is not a statue of me, I do not care.",
        CHESSPIECE_KLAUS = "This one does not bring gifts, it is an imitaion.",
        CHESSPIECE_BEEQUEEN = "She has tasted the sting of death.",
        CHESSPIECE_ANTLION = "Maybe it will be destroyed next summer.",
        CHESSPIECE_BEEFALO = "There is no smell to it.",
		CHESSPIECE_KITCOON = "A monument to ugly kitties.",
		CHESSPIECE_CATCOON = "A monument to ugly kitties.",
        CHESSPIECE_GUARDIANPHASE3 = "This was not worth it.",
        CHESSPIECE_EYEOFTERROR = "I do not like looking at it.",
        CHESSPIECE_TWINSOFTERROR = "I do not like looking at it.",

        CHESSJUNK1 = "Scrap metal in a pile.",
        CHESSJUNK2 = "Scrap metal in a pile. It should be in my pile.",
        CHESSJUNK3 = "I could add this junk to my treasure hoard.",
		CHESTER = "You are an odd thing.",
		CHESTER_EYEBONE =
		{
			GENERIC = "what are you looking at?",
			WAITING = "",
		},
		COOKEDMANDRAKE = "Haha! No more screaming, only food.",
		COOKEDMEAT = "I hope it is still juicy.",
		COOKEDMONSTERMEAT = "T",
		COOKEDSMALLMEAT = "",
		COOKPOT =
		{
			COOKING_LONG = "I do not have patince for stupid things.",
			COOKING_SHORT = "It's almost done!",
			DONE = "Mmmmm! It's ready to eat!",
			EMPTY = "It makes me hungry just to look at it.",
			BURNT = "How do these things happen.",
		},
		CORN = "Little Niblets.",
		CORN_COOKED = "it's puffy now.",
		CORN_SEEDS = "Crunchy little bits.",
        CANARY =
		{
			GENERIC = "Why is it yellow? I have not seen yellow birds before.",
			HELD = "Hey, I am asking you! Why are you yellow now?",
		},
        CANARY_POISONED = "It is looking green now, and smells most interesting.",

		CRITTERLAB = "Hello? I have never seen this rat-hole before?",
        CRITTER_GLOMLING = "Lumpy bug thing.",
        CRITTER_DRAGONLING = "You are a okay, for a horrid beetle.",
		CRITTER_LAMB = "Hope you taste as good as you are loud.",
        CRITTER_PUPPY = "Barking annoying thing.",
        CRITTER_KITTEN = "I have heard this is called irony.",
        CRITTER_PERDLING = "I will pluck a feather if you do not stop squacking.",
		CRITTER_LUNARMOTHLING = "Stupid thing, don't stop glowing.",

		CROW =
		{
			GENERIC = "You are not familar.",
			HELD = "Wait, Rats do not have wings, haha.",
		},
		CUTGRASS = "Needs to be Kneaded for Nesting.",
		CUTREEDS = "I will hoard many of this.",
		CUTSTONE = "This shape is very unnatural, I like that.",
		DEADLYFEAST = "I will eat anything!", --unimplemented
		DEER =
		{
			GENERIC = "No eye?",
			ANTLER = "",
		},
        DEER_ANTLER = "Head branch",
        DEER_GEMMED = "No eye? Gem eye.",
		DEERCLOPS = "No, no, get away terrible thing!",
		DEERCLOPS_EYEBALL = "Behold, my meal.",
		EYEBRELLAHAT =	"Waste of food.",
		DEPLETED_GRASS =
		{
			GENERIC = "It is probably a tuft of grass.",
		},
        GOGGLESHAT = "It keeps falling off my head.",
        DESERTHAT = "I can't even hear anything when I wear it.",
		ANTLIONHAT = "Now I can be a noisy, stupid, beetle who eats rocks too.",
		DEVTOOL = "It is probably useless.",
		DEVTOOL_NODEV = "I am stealing it now.",
		DIRTPILE = "Dirty Lump.",
		DIVININGROD =
		{
			COLD = "That noise is horrible!", --singleplayer
			GENERIC = "What stupid thing is this!?", --singleplayer
			HOT = "Gah! Make it stop. Please stop!", --singleplayer
			WARM = "It is terrible, the noise must stop.", --singleplayer
			WARMER = "Why are you louder, now.", --singleplayer
		},
		DIVININGRODBASE =
		{
			GENERIC = "I wonder what it does.", --singleplayer
			READY = "It looks like it needs a large key.", --singleplayer
			UNLOCKED = "Now the machine can work!", --singleplayer
		},
		DIVININGRODSTART = "Terrible, stupid, noisy Box!", --singleplayer
		DRAGONFLY = "How did a bug become so big!",
		ARMORDRAGONFLY = "Beetle armour",
		DRAGON_SCALES = "Beetle scales",
		DRAGONFLYCHEST = "Another stash, this one is not so easy to burn haha!",
		DRAGONFLYFURNACE =
		{
			HAMMERED = ".",
			GENERIC = "", --no gems
			NORMAL = "", --one gem
			HIGH = "", --two gems
		},

        HUTCH = "You do not smell normal.",
        HUTCH_FISHBOWL =
        {
            GENERIC = "I want to eat you.",
            WAITING = "He is... Dead.",
        },
		LAVASPIT =
		{
			HOT = "I am not tocuhing it.",
			COOL = "",
		},
		LAVA_POND = "Lava.",
		LAVAE = "Worm of goo",
		LAVAE_COCOON = "It is dead now?",
		LAVAE_PET =
		{
			STARVING = "Go eat some lava... or something.",
			HUNGRY = "You're not getting my food.",
			CONTENT = "Happier than usual..",
			GENERIC = "Oh, I will not raise a lava worm.",
		},
		LAVAE_EGG =
		{
			GENERIC = "Crack it open!",
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "Try to cook it!",
			COMFY = "still too cold, I said cook it.",
		},
		LAVAE_TOOTH = "It is an eggs tooth!",

		DRAGONFRUIT = "It looks like one big berry.",
		DRAGONFRUIT_COOKED = "Warm and juicy, like meat almost except worse.",
		DRAGONFRUIT_SEEDS = "Crunchy little bits.",
		DRAGONPIE = "Yes, I like this.",
		DRUMSTICK = "It is mine!",
		DRUMSTICK_COOKED = "Maybe I should rub dirt in it for taste.",
		DUG_BERRYBUSH = "I am bringing the berry maker with me.",
		DUG_BERRYBUSH_JUICY = "I am bringing the squishy berry maker with me.",
		DUG_GRASS = "Yes, I need grass somewhere else.",
		DUG_MARSH_BUSH = "",
		DUG_SAPLING = "You are mine now, little tree.",
		DURIAN = "Aaah, ripe and delicious.",
		DURIAN_COOKED = "This is okay, too.",
		DURIAN_SEEDS = "Crunchy little bits.",
		EARMUFFSHAT = "I do not think this will cover my ears right...",
		EGGPLANT = "It is not an egg, why do those people come up with such stupid names.",
		EGGPLANT_COOKED = "This is better.",
		EGGPLANT_SEEDS = "Crunchy little bits.",

		ENDTABLE =
		{
			BURNT = "Its life has ended.",
			GENERIC = "It is the end of a table?",
			EMPTY = "I think the pot is for flowers.",
			WILTED = "The plant is dead.",
			FRESHLIGHT = "I did not know they could be used like this.",
			OLDLIGHT = "Very Dim now.", -- will be wilted soon, light radius will be very small at this point
		},
		DECIDUOUSTREE =
		{
			BURNING = "",
			BURNT = "",
			CHOPPED = "",
			POISON = "",
			GENERIC = ".",
		},
		ACORN = "I like its taste.",
        ACORN_SAPLING = "This will make more nuts",
		ACORN_COOKED = "It is nutty tasting.",
		BIRCHNUTDRAKE = "Grah! Get away you little short thing!",
		EVERGREEN =
		{
			BURNING = "It has a pleasent burning smell actually.",
			BURNT = "Crispy wood now.",
			CHOPPED = "Nothing left.",
			GENERIC = "It smells like the forest.",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "It has a pleasent burning smell actually.",
			BURNT = "Crispy wood now.",
			CHOPPED = "Nothing left.",
			GENERIC = "It smells like the forest",
		},
		TWIGGYTREE =
		{
			BURNING = "It has a pleasent burning smell actually.",
			BURNT = "Crispy wood now.",
			CHOPPED = "Nothing left.",
			GENERIC = "It is so thin.",
			DISEASED = "The black spots give it character.", --unimplemented
		},
		TWIGGY_NUT_SAPLING = "Maybe this one will grow thicker?",
        TWIGGY_OLD = "It is even thinner than before.",
		TWIGGY_NUT = "Crunchy nut.",
		EYEPLANT = "Hands off my things, shorty!",
		INSPECTSELF = "I did not know I looked like that!",
		FARMPLOT =
		{
			GENERIC = "Dirt.",
			GROWING = "I do not want to watch it grow.",
			NEEDSFERTILIZER = "It is less dirty somehow.",
			BURNT = "I thought ash was good for plants.",
		},
		FEATHERHAT = "I like this stupid hat, It is so ugly. that is funny.",
		FEATHER_CROW = "The black flying rats feather.",
		FEATHER_ROBIN = "Red rat feather",
		FEATHER_ROBIN_WINTER = "Yes, snowy feather.",
		FEATHER_CANARY = "I do not have many of these, I need more for my collection.",
		FEATHERPENCIL = "I can draw just fine with my claw.",
        COOKBOOK = "I do not like stupid reading, I like eating.",
		FEM_PUPPET = "That thing is stuck.", --single player
		FIREFLIES =
		{
			GENERIC = "I can't grab them!",
			HELD = "I should eat them.",
		},
		FIREHOUND = "He is filled with a burning anger.",
		FIREPIT =
		{
			EMBERS = "Almost dead.",
			GENERIC = "Good for making food better.",
			HIGH = "Stoke the flames of revenge!",
			LOW = "Needs more fire.",
			NORMAL = "I will never let your passion burn out.",
			OUT = "Eh, I can always burn things another day.",
		},
		COLDFIREPIT =
		{
			EMBERS = "Almost dead.",
			GENERIC = "Good for making food better.",
			HIGH = "Stoke the flames of revenge!",
			LOW = "Needs more fire.",
			NORMAL = "I will not let my passion burn out.",
			OUT = "Eh, I can always burn things another day.",
		},
		FIRESTAFF = "Far away cooking.",
		FIRESUPPRESSOR =
		{
			ON = "It has a good arm for throwing.",
			OFF = "Stupid machine is broken.",
			LOWFUEL = "It is dying.",
		},

		FISH = "It struggled, I didn't.",
		FISHINGROD = "Hook, line and stick!",
		FISHSTICKS = "It needs sauce.",
		FISHTACOS = "Never enough of these.",
		FISH_COOKED = "The fishes are delicious.",
		FLINT = "It is the best kind of rock.",
		FLOWER =
		{
            GENERIC = "I must find better smells. These are boring smells.",
            ROSE = "It doesn't like being touched.",
        },
        FLOWER_WITHERED = "Hm, Now it's ugly.",
		FLOWERHAT = "This is a boring, stupid thing.",
		FLOWER_EVIL = "Mmm interesting smells!",
		FOLIAGE = "They are boring smells...",
		FOOTBALLHAT = "My head gets sweaty when I wear it.",
        FOSSIL_PIECE = "There is no more marrow...",
        FOSSIL_STALKER =
        {
			GENERIC = "A nice pile of bones.",
			FUNNY = "It looks finished to me.",
			COMPLETE = "It looks finished to me.",
        },
        STALKER = "What a terrible thing!",
        STALKER_ATRIUM = "Why do bones keep coming back alive! Stay dead!",
        STALKER_MINION = "AAAH! Anklebiters!",
        THURIBLE = "It smells of the most intriguing sour-sweet wind.",
        ATRIUM_OVERGROWTH = "I can hear the screaming, whisering echos from it. Eughhh...",
		FROG =
		{
			DEAD = "It is twitching still.",
			GENERIC = "It is slimey, that means it is very tasty.",
			SLEEPING = "Your slime will be mine.",
		},
		FROGGLEBUNWICH = "The best way to eat them.",
		FROGLEGS = "Yes, these are very delicious.",
		FROGLEGS_COOKED = "Yes, I love them warm and moist!",
		FRUITMEDLEY = "I prefer moist meat. Not this...",
		FURTUFT = "It is not my fur.",
		GEARS = "Pile of bits and bobs.",
		GHOST = "I am not a grave robber! I promise!",
		GOLDENAXE = "I can hack more with it, and slice too!",
		GOLDENPICKAXE = "I can Smash more rocks!",
		GOLDENPITCHFORK = "Claw more dirt!",
		GOLDENSHOVEL = "I should use this for a bit. My nails need a rest from digging.",
		GOLDNUGGET = "I do not see why this is more valuable? It is a rock and yellow.",
		GRASS =
		{
			BARREN = "Broken.",
			WITHERED = "Weak plant...",
			BURNING = "Aaah! it is up in flames!",
			GENERIC = "Grass.",
			PICKED = "Isn't there something more important you could have me look at?",
			DISEASED = "Eugh. Looks dead, and not good dead.", --unimplemented
			DISEASING = "Ehhh, smells bad, very bad.", --unimplemented
		},
		GRASSGEKKO =
		{
			GENERIC = "Does it taste good?",
			DISEASED = "Must be full of bugs!.", --unimplemented
		},
		GREEN_CAP = "It tastes like mold, Very delicious.",
		GREEN_CAP_COOKED = "Gooey!",
		GREEN_MUSHROOM =
		{
			GENERIC = "Time to eat!",
			INGROUND = "They only come out before dark.",
			PICKED = "Just a little hole now.",
		},
		GUNPOWDER = "This does not seem like food.",
		HAMBAT = "I can eat, and bash things. Very practical.",
		HAMMER = "A good tool for smashing bones.",
		HEALINGSALVE = "This seems like a waste, I should eat it.",
		HEATROCK =
		{
			FROZEN = "It is too cold to hold.",
			COLD = "Chilly smooth stone.",
			GENERIC = "It is anice shape for a rock.",
			WARM = "Warmer smooth stone.",
			HOT = "It is very cozzy now.",
		},
		HOME = "It is a home, but not mine.",
		HOMESIGN =
		{
			GENERIC = "The writting is, \"You are here\".",
            UNWRITTEN = "There are no scratches on it.",
			BURNT = "It was useless anyways",
		},
		ARROWSIGN_POST =
		{
			GENERIC = "The writting is, \"Thataway\".",
            UNWRITTEN = "There are no scratches on it.",
			BURNT = "It was useless anyways",
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "The writting is, \"Thataway\".",
            UNWRITTEN = "There are no scratches on it.",
			BURNT = "It was useless anyways",
		},
		HONEY = "Sweet Sweet slime!",
		HONEYCOMB = "It doesn't taste good...",
		HONEYHAM = "Lip smacking food!",
		HONEYNUGGETS = "I am covered in honey after eating.",
		HORN = "Hard to collect many of these.",
		HOUND = "RAAA!!!! You Like that?! I am big now!",
		HOUNDCORPSE =
		{
			GENERIC = "It is smelling very... Foul? Huh that is not right?",
			BURNING = "The meat was turning weird anyways.",
			REVIVING = "The bugs inside are coming out!",
		},
		HOUNDBONE = "Marrow in there?",
		HOUNDMOUND = "They are hogging the bones.",
		ICEBOX = "Cold food is umm.. not as good tasting.",
		ICEHAT = "It makes me moist and I am sad.",
		ICEHOUND = "Snowy stupid dog.",
		INSANITYROCK =
		{
			ACTIVE = "How did it unbury itself?",
			INACTIVE = "It is stuck in the ground.",
		},
		JAMMYPRESERVES = "I like it mashed and gooey.",

		KABOBS = "bits on a stick.",
		KILLERBEE =
		{
			GENERIC = "Grah! These ones are evil!",
			HELD = "If I eat you, do not sting my insides.",
		},
		KNIGHT = "",
		KOALEFANT_SUMMER = "It is full of juicy fatty meat.",
		KOALEFANT_WINTER = "It is full of juicy fatty meat.",
		KRAMPUS = "My stuff is not yours to steal!",
		KRAMPUS_SACK = "I wish I had one of these starting out.",
		LEIF = "It was not me! I Promise!",
		LEIF_SPARSE = "It was not me! I Promise!",
		LIGHTER  = "Finders keepers.",
		LIGHTNING_ROD =
		{
			CHARGED = "Now... How do I steal thunder from it.",
			GENERIC = "It will steal thunder from the clouds.",
		},
		LIGHTNINGGOAT =
		{
			GENERIC = "You are stupid and loud.",
			CHARGED = "You look fuzzier than usual...",
		},
		LIGHTNINGGOATHORN = "I need a nice collection of these.",
		GOATMILK = "It's buzzing with tastiness!",
		LITTLE_WALRUS = "This one is less fat.",
		LIVINGLOG = "It looks worried.",
		LOG =
		{
			BURNING = "Some piece of a tree, it's mine now.",
			GENERIC = "AH! NooOOooOOO my wood!!",
		},
		LUCY = "I didn't want to steal you anyways!",
		LUREPLANT = "I smell meat?",
		LUREPLANTBULB = "I should eat it!",
		MALE_PUPPET = "That thing is stuck.", --single player

		MANDRAKE_ACTIVE = "I do not like this yapping white carrot",
		MANDRAKE_PLANTED = "What is this? Carrot?",
		MANDRAKE = "I do not like this yapping white carrot",

        MANDRAKESOUP = "It is dead and very tasty looking now.",
        MANDRAKE_COOKED = "Smelling it is so... soothing...",
        MAPSCROLL = "A blank map Does not seem very useful.",
        MARBLE = "This rock is very nice, I will take it now.",
        MARBLEBEAN = "For a bean it is crunchy.",
        MARBLEBEAN_SAPLING = "Yes, this is normal.",
        MARBLESHRUB = "This makes sense to me.",
        MARBLEPILLAR = "That was always there.",
        MARBLETREE = "Trees like that were always there.",
        MARSH_BUSH =
        {
			BURNT = "One less thorn patch to worry about.",
            BURNING = "",
            GENERIC = "I don not want to get tangled in it.",
            PICKED = "Gah! Pricked!.",
        },
        BURNT_MARSH_BUSH = "It's all burnt up.",
        MARSH_PLANT = "It's a plant.",
        MARSH_TREE =
        {
            BURNING = "Spikes and fire!",
            BURNT = "Now it's burnt and spiky.",
            CHOPPED = "Not so spiky now!",
            GENERIC = "It would prick me if I tried climbing it.",
        },
        MAXWELL = "Do I know you?",--single player
        MAXWELLHEAD = "How is he doing that?",--removed
        MAXWELLLIGHT = "Strange light.",--single player
        MAXWELLLOCK = "Hole for something?",--single player
        MAXWELLTHRONE = "The most wretched chair.",--single player
        MEAT = "Ah! Perfect!",
        MEATBALLS = "Balled up so they are easy to eat now.",
        MEATRACK =
        {
            DONE = "Finally.",
            DRYING = "This takes too long. just eat it normaly.",
            DRYINGINRAIN = "I could have just ate it off the bone...",
            GENERIC = "Place to make meat chewy.",
            BURNT = "Guh, terrible.",
            DONE_NOTMEAT = "Finally.",
            DRYING_NOTMEAT = "It won't be wet anymore.",
            DRYINGINRAIN_NOTMEAT = "sigh...",
        },
        MEAT_DRIED = "It is good but too Chewy.",
        MERM = "Not dead for walking on land?",
        MERMHEAD =
        {
            GENERIC = "The Stink looks good on you.",
            BURNT = "Blegh! Not my kind of Stinky",
        },
        MERMHOUSE =
        {
            GENERIC = "Humble stinky home.",
            BURNT = "Broken.",
        },
        MINERHAT = "My eyes are fine in the dark! Well they were...",
        MONKEY = "Stealers! I will steal back what is mine!",
        MONKEYBARREL = "Hiding in plain sight!",
        MONSTERLASAGNA = "Most wonderful meal!",
        FLOWERSALAD = "I do not like this, But I would rather eat than smell it.",
        ICECREAM = "I should let it melt, then drink it.",
        WATERMELONICLE = "Why put the good part behind ice.",
        TRAILMIX = "Maybe I can burry these for later.",
        HOTCHILI = "It is chunky are you supposed to eat it like this.",
        GUACAMOLE = "Mashed into a very delicious paste.",
        MONSTERMEAT = "Ah! Perfect!",
        MONSTERMEAT_DRIED = "I like it squishy. This is fine too.",
        MOOSE = "Why are you here? come back another day.",
        MOOSE_NESTING_GROUND = "Not my nest.",
        MOOSEEGG = "I must crack it!",
        MOSSLING = "They are noisy and annoying.",
        FEATHERFAN = "It will do the trick. Now I need a rat to fan me.",
        MINIFAN = "Barely even works! I need something bigger.",
        GOOSE_FEATHER = "It is very soft I will hoard many of them.",
        STAFF_TORNADO = "Whirling doom stick!",
        MOSQUITO =
        {
            GENERIC = "Parasite thing.",
            HELD = "I am eating you now!",
        },
        MOSQUITOSACK = "Mash it up and eat it!",
        MOUND =
        {
            DUG = "No home there.",
            GENERIC = "Buried hole",
        },
        NIGHTLIGHT = "It eats light.",
        NIGHTMAREFUEL = "Bad memories...",
        NIGHTSWORD = "My passion condensed!",
        NITRE = "Yucky.",
        ONEMANBAND = "I hate it. I HATE IT.",
        OASISLAKE =
		{
			GENERIC = "Is it skinny dipping if I am naked?",
			EMPTY = "All gone...",
		},
        PANDORASCHEST = "It was left for me!",
        PANFLUTE = "It reminds me of my voice, very soothing.",
        PAPYRUS = "It is not very interesting, But I will steal it anyways.",
        WAXPAPER = "Shinier paper.",
        PENGUIN = "You do not desserve to look that nice.",
        PERD = "Stop stuffing your face with my food!?",
        PEROGIES = "Soggy lumps stuffed with stuff.",
        PETALS = "It is not a very interesting smell.",
        PETALS_EVIL = "I must have a bouquet, They smell very nice!",
        PHLEGM = "The texture is good.",
        PICKAXE = "I need this for smashing rocks.",
        PIGGYBACK = "A good way to haul many treasures.",
        PIGHEAD =
        {
            GENERIC = "It is a good look for him.",
            BURNT = "Bacon-y!",
        },
        PIGHOUSE =
        {
            FULL = "Stop watching me. Creep!",
            GENERIC = "Thinking that house of theirs keeps them safe. HaHA!",
            LIGHTSOUT = "Let me in, beast!",
            BURNT = "It was for the best.",
        },
        PIGKING = "Quite the odor you have today!",
        PIGMAN =
        {
            DEAD = "Bye bye! HAHA!",
            FOLLOWER = "This is awkward...",
            GENERIC = "They do not like me.",
            GUARD = "Get out of my way.",
            WEREPIG = "No no! Why is this happening!",
        },
        PIGSKIN = "He will not miss it.",
        PIGTENT = "Smells like bacon.",
        PIGTORCH = "Hahaha look at all their stupid faces.",
        PINECONE = "I like hiding them in soil, but I always lose them.",
        PINECONE_SAPLING = "It is so small and stupid.",
        LUMPY_SAPLING = "It is so small and stupid.",
        PITCHFORK = "My claws are better.",
        PLANTMEAT = "Fake meat? But it tastes like real meat.",
        PLANTMEAT_COOKED = "I like this meat, very moist.",
        PLANT_NORMAL =
        {
            GENERIC = "Leafy!",
            GROWING = "Guh! It's growing so slowly!",
            READY = "Mmmm. Ready to harvest.",
            WITHERED = "Drier than dirt.",
        },
        POMEGRANATE = "Each bit is very squishy and then crunchy.",
        POMEGRANATE_COOKED = "Pulpy warm mush.",
        POMEGRANATE_SEEDS = "Crunchy little bits.",
        POND = "I do not want to take a dip.",
        POOP = "Caca.",
        FERTILIZER = "At least it is east to collect.",
        PUMPKIN = "I like to stomp on it before I eat it.",
        PUMPKINCOOKIE = "Yes, I need another!",
        PUMPKIN_COOKED = "Mushy, warm, and good to eat.",
        PUMPKIN_LANTERN = "I do not understand it.",
        PUMPKIN_SEEDS = "Crunchy little bits.",
        PURPLEAMULET = "It is like staring into an abyss.",
        PURPLEGEM = "My jewels!",
        RABBIT =
        {
            GENERIC = "You are stupid, stop digging holes.",
            HELD = "Stop writhing, it'll be over soon.",
        },
        RABBITHOLE =
        {
            GENERIC = "Not a hole for me.",
            SPRING = "Haha! it is so bad it collapsed!",
        },
        RAINOMETER =
        {
            GENERIC = "I know how weather works already.",
            BURNT = "It was stupid anyways.",
        },
        RAINCOAT = "Yes, I do like having dry fur.",
        RAINHAT = "I can hear all the little raindrops when I wear it.",
        RATATOUILLE = "This has nothing to do with rats.",
        RAZOR = "I would rather keep my fur!",
        REDGEM = "My jewels!",
        RED_CAP = "I should eat these more often.",
        RED_CAP_COOKED = "Mmm smells so tasty!",
        RED_MUSHROOM =
        {
           	GENERIC = "I forgot what it tastes like.",
			INGROUND = "I do not get to eat these ones often.",
			PICKED = "Just a little hole now.",
        },
        REEDS =
        {
            BURNING = "No! How will I collect more now!",
            GENERIC = "These looks good to collect.",
            PICKED = "Waiting is the worst part.",
        },
        RELIC = "These would make for a good collection.",
        RUINS_RUBBLE = "stupid rocks.",
        RUBBLE = "stupid rocks.",
		
        RESEARCHLAB =
        {
            GENERIC = "This machine will be very useful, I think.",
            BURNT = "How can I use it now?.",
        },
        RESEARCHLAB2 =
        {
            GENERIC = "You make a machine to make a new machine. I do not get it.",
            BURNT = "How can I use it now?.",
        },
        RESEARCHLAB3 =
        {
            GENERIC = "Is this what they call a hat trick.",
            BURNT = "The trick was that I was fooled.",
        },
        RESEARCHLAB4 =
        {
            GENERIC = "I manipulate others, I do not need this.",
            BURNT = "Awww, I liked manipulating shadows.",
        },
        RESURRECTIONSTATUE =
        {
            GENERIC = "It has an ugly head.",
            BURNT = "At least I do not have to look at it now.",
        },
        RESURRECTIONSTONE = "Rock magic is very interesing...",
        ROBIN =
        {
            GENERIC = "You will make for an excellent slave.",
            HELD = "Nice colour, You are mine now.",
        },
        ROBIN_WINTER =
        {
            GENERIC = "I have not seen a blue bird. I must have you.",
            HELD = "You will make for an excellent slave.",
        },
        ROBOT_PUPPET = "That thing is stuck.", --single player
        ROCK_LIGHT =
        {
            GENERIC = "It smells like rotten eggs.",--removed
            OUT = "Maybe I could smash it.",--removed
            LOW = "It is becoming hard again?",--removed
            NORMAL = "It smells like rotten eggs.",--removed
        },
        CAVEIN_BOULDER =
        {
            GENERIC = "I should get my rats to carry it for me.",
            RAISED = "It is in a big pile!",
        },
        ROCK = "Why am I looking at this.",
        PETRIFIED_TREE = "How is this tree a rock?",
        ROCK_PETRIFIED_TREE = "How is this tree a rock?",
        ROCK_PETRIFIED_TREE_OLD = "How is this tree a rock?",
        ROCK_ICE =
        {
            GENERIC = "Hard and cold.",
            MELTED = "Just some puddle.",
        },
        ROCK_ICE_MELTED = "Just some puddle.",
        ICE = "It is cold and hard and nice to chew on.",
        ROCKS = "It is something good for bashing bones.",
        ROOK = "Loud and clunky, I hate it!",
        ROPE = "It is like string, but very thick.",
        ROTTENEGG = "*sniff* Aaaah How fragrant!",
        ROYAL_JELLY = "It is so SWEET! Too sweet even...",
        JELLYBEAN = "It is too small, but there are many of them.",
        SADDLE_BASIC = "I could ride a stupid beast with it.",
        SADDLE_RACE = "I could ride a stupid beast with it.",
        SADDLE_WAR = "I could conquer a stupid beast with it.",
        SADDLEHORN = "I could beat someone with it.",
        SALTLICK = "I licked it, it was good.",
        BRUSH = "I would like to be brushed.",
		SANITYROCK =
		{
			ACTIVE = "How did it unbury itself?",
			INACTIVE = "It is stuck in the ground.",
		},
		SAPLING =
		{
			BURNING = "I have had it with fire!",
			WITHERED = "Drier than dirt.",
			GENERIC = "I should pull it apart.",
			PICKED = "It is dead now.",
			DISEASED = "I do not want to eat that!",--removed
			DISEASING = "Hmm smells more yucky!",--removed
		},
   		SCARECROW =
   		{
			GENERIC = "Who is that, and how does he stay up there for so long?",
			BURNING = "He is dying, but not screaming?",
			BURNT = "He is dead now. Very sad.",
   		},
   		SCULPTINGTABLE=
   		{
			EMPTY = "It is like a table.",
			BLOCK = "Hmmmmm...",
			SCULPTURE = "That is handsome. I will keep it.",
			BURNT = "Useless now.",
   		},
        SCULPTURE_KNIGHTHEAD = "",
		SCULPTURE_KNIGHTBODY =
		{
			COVERED = "",
			UNCOVERED = "I have improved it.",
			FINISHED = "",
			READY = "",
		},
        SCULPTURE_BISHOPHEAD = "",
		SCULPTURE_BISHOPBODY =
		{
			COVERED = "",
			UNCOVERED = "It makes more sense looking like this.",
			FINISHED = "",
			READY = "",
		},
        SCULPTURE_ROOKNOSE = "",
		SCULPTURE_ROOKBODY =
		{
			COVERED = "That has always been there.",
			UNCOVERED = "Yes, it looks better now.",
			FINISHED = "",
			READY = "",
		},
        GARGOYLE_HOUND = "Is it watching me?",
        GARGOYLE_WEREPIG = "Very grotesque, who put you here?",
		SEEDS = "Crunchy little bits.",
		SEEDS_COOKED = "Smokey and crunchy bits.",
		SEWING_KIT = "It twirls around my hands when I try and use it.",
		SEWING_TAPE = "Very bitter, and sticky.",
		SHOVEL = "It is like one big nail for digging.",
		SILK = "It sticks to my fur.",
		SKELETON = "I will take your bones.",
		SCORCHED_SKELETON = "I think he died of burning.",
		SKULLCHEST = "More bones inside.", --removed
		SMALLBIRD =
		{
			GENERIC = "She is like a little ratling.",
			HUNGRY = "It wants some of my food!",
			STARVING = "I do not have any food!",
			SLEEPING = "This one is not so ugly, I will name you \"Dinner.\"",
		},
		SMALLMEAT = "mmm yummy.",
		SMALLMEAT_DRIED = "too chewy! I like it soft.",
		SPAT = "Spit right into my mouth!",
		SPEAR = "Why not just use a stick?",
		SPEAR_WATHGRITHR = "Ooooh, I see why now. This is better than stick.",
		WATHGRITHRHAT = "It is not biteable, I tried.",
		SPIDER =
		{
			DEAD = "DIE! HAHA!",
			GENERIC = "Ugly.",
			SLEEPING = "I want to throw a rock at it.",
		},
		SPIDERDEN = "Make room for rats.",
		SPIDEREGGSACK = "I must eat it before it grows.",
		SPIDERGLAND = "Floppy thing.",
		SPIDERHAT = "Why do I need this? Stupid hat! I am Rat.",
		SPIDERQUEEN = "Hit her many times in the head!",
		SPIDER_WARRIOR =
		{
			DEAD = "It was weak.",
			GENERIC = "It thinks it is not ugly.",
			SLEEPING = "Smash its head with a rock!",
		},
		SPOILED_FOOD = "Food when there is no food. But I prefer normal food.",
        STAGEHAND =
        {
			AWAKE = "AAAaah Get away from me!",
			HIDING = "This table is more strange than usual.",
        },
        STATUE_MARBLE =
        {
            GENERIC = "I like how it looks I want it in my burrow.",
            TYPE1 = "Test.",
            TYPE2 = "Test.",
            TYPE3 = "Test.", --vase statue
        },
		STATUEHARP = "Dead thing.",
		STATUEMAXWELL = "I do not know who that is.",
		STEELWOOL = "Don't lick it.",
		STINGER = "I should not eat too many.",
		STRAWHAT = "It's nice actually.",
		STUFFEDEGGPLANT = "I do not know what it is stuffed with.",
		SWEATERVEST = "It will look better after I grease it up.",
		REFLECTIVEVEST = "It is ugly looking.",
		HAWAIIANSHIRT = "Soon, It will smell like me after a while.",
		TAFFY = "Ooey Gooey.",
		TALLBIRD = "She is in the way of my dinner.",
		TALLBIRDEGG = "Dinner.",
		TALLBIRDEGG_COOKED = "Blue part is the most delcious.",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "This is terrible! It is not cooking!",
			GENERIC = "Crack it open!",
			HOT = "Yes, I must cook it!",
			LONG = "This is not worth it, I should just eat it.",
			SHORT = "I will let it hatch, then eat it!",
		},
		TALLBIRDNEST =
		{
			GENERIC = "Dinner.",
			PICKED = "Where is dinner?",
		},
		TEENBIRD =
		{
		    GENERIC = "Huh, you are much taller then I remember.",
			HUNGRY = "It wants some of my food!",
			STARVING = " You eat so much, how are you still hungry!",
			SLEEPING = "I wonder, will Dinner turn me into its dinner when it grows again...",
		},
		TELEPORTATO_BASE =
		{
			ACTIVE = "I see, It was like a puzzle thing.", --single player
			GENERIC = "Interesting thing.", --single player
			LOCKED = "It is still broken?", --single player
			PARTIAL = "I do not see the point of this, They were my things.", --single player
		},
		TELEPORTATO_BOX = "If a shake it, it rattles funny!", --single player
		TELEPORTATO_CRANK = "This will look very good on my pile.", --single player
		TELEPORTATO_POTATO = "How unique! Hoarding this will be very good.", --single player
		TELEPORTATO_RING = "It is mine now!", --single player
		TELESTAFF = "What a nice jewled stick.",
		TENT =
		{
			GENERIC = "I'm more of a day time sleeper.",
			BURNT = "this is fine.",
		},
		SIESTAHUT =
		{
			GENERIC = "Rat nap in the sun. I think I will now!",
			BURNT = "Which Stupid did this?",
		},
		TENTACLE = "Slimy, but it does not like me.",
		TENTACLESPIKE = "Very slimy slapper, I like it.",
		TENTACLESPOTS = "The slime on this tastes funny?",
		TENTACLE_PILLAR = "It is the most slimy tentacle.",
        TENTACLE_PILLAR_HOLE = "This hole... It is not for me.",
		TENTACLE_PILLAR_ARM = "",
		TENTACLE_GARDEN = ".",
		TOPHAT = "A rat in a hat?",
		TORCH = "I do not need this, I can see just fine in the dark.",
		TRANSISTOR = "A little robo thinger.",
		TRAP = "I hope no family get stuck in it.",
		TRAP_TEETH = "He he he...",
		TRAP_TEETH_MAXWELL = "That is not fair!", --single player
		TREASURECHEST =
		{
			GENERIC = "A good place to stash my treasures.",
			BURNT = "No! My things!",
		},
		TREASURECHEST_TRAP = "How convenient!",
		SACRED_CHEST =
		{
			GENERIC = "I hear whispers. It wants something.",
			LOCKED = "It's passing its judgment.",
		},
		TREECLUMP = "I should turn back...", --removed

		TRINKET_1 = "I thought they were jelly beans.", --Melted Marbles
		TRINKET_2 = "No noise. Good.", --Fake Kazoo
		TRINKET_3 = "Thick string? No, Stuck Rope!", --Gord's Knot
		TRINKET_4 = "Who is he.", --Gnome
		TRINKET_5 = "I have one in green.", --Toy Rocketship
		TRINKET_6 = "Tastes pretty good.", --Frazzled Wires
		TRINKET_7 = "Hahaha, I like it!", --Ball and Cup
		TRINKET_8 = "I should start a collection of these.", --Rubber Bung
		TRINKET_9 = "I knew a rat who ate these.", --Mismatched Buttons
		TRINKET_10 = "I do not know what this but it is mine now.", --Dentures
		TRINKET_11 = "How can he lie if he doesn't speak.", --Lying Robot
		TRINKET_12 = "Too old for eating now.", --Dessicated Tentacle
		TRINKET_13 = "Who is She.", --Gnomette
		TRINKET_14 = "I think I have one already.", --Leaky Teacup
		TRINKET_15 = "It teeny little thing", --Pawn
		TRINKET_16 = "It teeny little thing", --Pawn
		TRINKET_17 = "This will look good with the others.", --Bent Spork
		TRINKET_18 = "What creature is this?", --Trojan Horse
		TRINKET_19 = "Wobbler thing.", --Unbalanced Top
		TRINKET_20 = "Oh This one is practical!", --Backscratcher
		TRINKET_21 = "They deserve to be beaten.", --Egg Beater
		TRINKET_22 = "It is fun to roll around.", --Frayed Yarn
		TRINKET_23 = "This one is very funny I will keep it.", --Shoehorn
		TRINKET_24 = "Very handsome. What? I am allowed to like it.", --Lucky Cat Jar
		TRINKET_25 = "Beautiful smell.", --Air Unfreshener
		TRINKET_26 = "Very practical, I need more of these.", --Potato Cup
		TRINKET_27 = "It is like metal wire. Very strange.", --Coat Hanger
		TRINKET_28 = "Teeny castle.", --Rook
        TRINKET_29 = "Teeny castle.", --Rook
        TRINKET_30 = "Head of thing.", --Knight
        TRINKET_31 = "Head of thing.", --Knight
        TRINKET_32 = "I can a see rat trapped in it!", --Cubic Zirconia Ball
        TRINKET_33 = "It makes me look pretty.", --Spider Ring
        TRINKET_34 = "very useful. I am not sure what for yet.", --Monkey Paw
        TRINKET_35 = "I will lick the residue off the bottom.", --Empty Elixir
        TRINKET_36 = "These teeth are very squishy...", --Faux fangs
        TRINKET_37 = "Stabby stick, very good.", --Broken Stake
        TRINKET_38 = "I thought I was supposed to see out of it?", -- Binoculars Griftlands trinket
        TRINKET_39 = "I can not wear it. Oh well, more for me anyways.", -- Lone Glove Griftlands trinket
        TRINKET_40 = "Haha this is very funny I get it.", -- Snail Scale Griftlands trinket
        TRINKET_41 = "Aww... There is no more goo.", -- Goop Canister Hot Lava trinket
        TRINKET_42 = "A little slinky thing.", -- Toy Cobra Hot Lava trinket
        TRINKET_43= "This is not a thing I have seen before.", -- Crocodile Toy Hot Lava trinket
        TRINKET_44 = "I could put this with the rest.", -- Broken Terrarium ONI trinket
        TRINKET_45 = "This is very ugly but I will take it.", -- Odd Radio ONI trinket
        TRINKET_46 = "what is this?", -- Hairdryer ONI trinket

        -- The numbers align with the trinket numbers above.
        LOST_TOY_1  = "ACK What is it?!",
        LOST_TOY_2  = "ACK What is it?!",
        LOST_TOY_7  = "Now I don't like it. Taunting me!",
        LOST_TOY_10 = "ACK What is it?!.",
        LOST_TOY_11 = "ACK What is it?!",
        LOST_TOY_14 = "ACK What is it?!",
        LOST_TOY_18 = "ACK What is it?!",
        LOST_TOY_19 = "ACK What is it?!",
        LOST_TOY_42 = "ACK What is it?!",
        LOST_TOY_43 = "ACK What is it?!",

        HALLOWEENCANDY_1 = "It is very crisp and sweet.", --candy apple
        HALLOWEENCANDY_2 = "This is corn?", --candy corn
        HALLOWEENCANDY_3 = "This is corn.", --not so candy corn
        HALLOWEENCANDY_4 = "It is squishy almost like the real stuff!",  --gummy spider
        HALLOWEENCANDY_5 = "Haha! This is what they get!", --catcoon candy
        HALLOWEENCANDY_6 = "These smell funny.", --"raisins"
        HALLOWEENCANDY_7 = "Wrinkly little bits.", --Raisin box
        HALLOWEENCANDY_8 = "I would rather crunch it than suck on it.", -- Lolipop
        HALLOWEENCANDY_9 = "Mmm I love eating worms!", --jelly worm
        HALLOWEENCANDY_10 = "I would rather crunch it than suck on it.", -- Lolipop
        HALLOWEENCANDY_11 = "Yes, these are tasty! But they are not real pigs?", --choco pigs
        HALLOWEENCANDY_12 = "It is like eating grubs but sweeter tasting.", --ONI meal lice candy
        HALLOWEENCANDY_13 = "They are too crunchy.", --Griftlands themed candy
        HALLOWEENCANDY_14 = "It is like a sweet heat, not bad.", --Hot Lava pepper candy
        CANDYBAG = "A ghouls bag, full of my sweets.",

		HALLOWEEN_ORNAMENT_1 = "It is smaller and less spooky", --ghost
		HALLOWEEN_ORNAMENT_2 = "At least it is not screeching",  --bat
		HALLOWEEN_ORNAMENT_3 = "Why is this upside down.", --depth dweller
		HALLOWEEN_ORNAMENT_4 = "This is one not slimy but I like it.", --tentacle
		HALLOWEEN_ORNAMENT_5 = "It is a creepy crawly but fake", --spider
		HALLOWEEN_ORNAMENT_6 = "I almost wish it were real.", --crow

		HALLOWEENPOTION_DRINKS_WEAK = "It is a dinky drink.",
		HALLOWEENPOTION_DRINKS_POTENT = "Finally, something to quench me.",
        HALLOWEENPOTION_BRAVERY = "I am already the bravest rat!",
		HALLOWEENPOTION_MOON = "It reeks of change!",
		HALLOWEENPOTION_FIRE_FX = "It makes the most beautiful lights and colours.",
		MADSCIENCE_LAB = "For toiling trouble hehe!",
		LIVINGTREE_ROOT = "It whispers for release.",
		LIVINGTREE_SAPLING = "Creaking quietly now and waiting.",

        DRAGONHEADHAT = "Angry evil head!",
        DRAGONBODYHAT = "This is a boring peice.",
        DRAGONTAILHAT = "Not as good as my tail.",
        PERDSHRINE =
        {
            GENERIC = "Why would I give it something.",
            EMPTY = "It is not a real bird...",
            BURNT = "It did not cook well.",
        },
        REDLANTERN = "I see, it is red like berries.",
        LUCKY_GOLDNUGGET = "It is lucky? Well it is mine now!",
        FIRECRACKERS = "I do not like these!",
        PERDFAN = "It makes a good gust.",
        REDPOUCH = "A present for Winky!",
        WARGSHRINE =
        {
            GENERIC = "It is the pound for puppies.",
            EMPTY = "Stop looking at me, it is my stick.",
            BURNING = "It is the pound for puppies.", --for willow to override
            BURNT = "Broken.",
        },
        CLAYWARG =
        {
        	GENERIC = "AAaa! It is UGLY and REAL!",
        	STATUE = "You are a very grotesque thing.",
        },
        CLAYHOUND =
        {
        	GENERIC = "AAaa! It is UGLY and REAL!",
        	STATUE = "You are a very grotesque thing.",
        },
        HOUNDWHISTLE = "I can hear that. Do not blow it.",
        CHESSPIECE_CLAYHOUND = "Looking at it will make me drop dead!",
        CHESSPIECE_CLAYWARG = "This better not come alive or I will die from shock.",

		PIGSHRINE =
		{
            GENERIC = "That could have been my meat.",
            EMPTY = "Some ugly pig shrine.",
            BURNT = "Broken.",
		},
		PIG_TOKEN = "Another round thing.",
		PIG_COIN = "Another round thing.",
		YOTP_FOOD1 = ".",
		YOTP_FOOD2 = "",
		YOTP_FOOD3 = "",

		PIGELITE1 = "", --BLUE
		PIGELITE2 = "!", --RED
		PIGELITE3 = "!", --WHITE
		PIGELITE4 = "", --GREEN

		PIGELITEFIGHTER1 = "What are you looking at?", --BLUE
		PIGELITEFIGHTER2 = "He's got gold fever!", --RED
		PIGELITEFIGHTER3 = "Here's mud in your eye!", --WHITE
		PIGELITEFIGHTER4 = "Wouldn't you rather hit someone else?", --GREEN

		CARRAT_GHOSTRACER = "A gross imitation of my family.",

        YOTC_CARRAT_RACE_START = "The beginning.",
        YOTC_CARRAT_RACE_CHECKPOINT = "It is some marker or other.",
        YOTC_CARRAT_RACE_FINISH =
        {
            GENERIC = "That is the finale.",
            BURNT = "It has had its finale.",
            I_WON = "I am superior rat!",
            SOMEONE_ELSE_WON = "Stupid fake rat, you failed me!",
        },

		YOTC_CARRAT_RACE_START_ITEM = "The beginning part.",
        YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "For telling them where to run.",
		YOTC_CARRAT_RACE_FINISH_ITEM = "The ending part.",

		YOTC_SEEDPACKET = "Full of little crunchy bits.",
		YOTC_SEEDPACKET_RARE = "Tastier Crunchy bits inside.",

		MINIBOATLANTERN = "It glows for me.",

        YOTC_CARRATSHRINE =
        {
            GENERIC = "I like cheese, not carrots?",
            EMPTY = "Is that a shrine for me?",
            BURNT = "That is stupid.",
        },

        YOTC_CARRAT_GYM_DIRECTION =
        {
            GENERIC = "Which way is the right way?",
            RAT = "Go, go, Yes keep moving!",
            BURNT = "At least it will never be my turn.",
        },
        YOTC_CARRAT_GYM_SPEED =
        {
            GENERIC = "I",
            RAT = "Faster... faster!",
            BURNT = "At least it will never be my turn.",
        },
        YOTC_CARRAT_GYM_REACTION =
        {
            GENERIC = "",
            RAT = "It is very entertaining to watch.",
            BURNT = "At least it will never be my turn.",
        },
        YOTC_CARRAT_GYM_STAMINA =
        {
            GENERIC = ".",
            RAT = "!",
            BURNT = "At least it will never be my turn.",
        },

        YOTC_CARRAT_GYM_DIRECTION_ITEM = ".",
        YOTC_CARRAT_GYM_SPEED_ITEM = "I.",
        YOTC_CARRAT_GYM_STAMINA_ITEM = "a",
        YOTC_CARRAT_GYM_REACTION_ITEM = "",

        YOTC_CARRAT_SCALE_ITEM = "It is for weighing rats. Like me.",
        YOTC_CARRAT_SCALE =
        {
            GENERIC = "I wonder what happens if I sit on it.",
            CARRAT = "A real family member would do better.",
            CARRAT_GOOD = "He is much better, for a piece of food.",
            BURNT = "It is broken.",
        },

        YOTB_BEEFALOSHRINE =
        {
            GENERIC = "Why would I praise these beasts?",
            EMPTY = "Why would I praise these beasts?",
            BURNT = "Well, no more of that.",
        },

        BEEFALO_GROOMER =
        {
            GENERIC = "I need a smelly beast to be here.",
            OCCUPIED = "There is something stupid thing blocking me.",
            BURNT = "It is broken.",
        },
        BEEFALO_GROOMER_ITEM = "I need to plop it down.",

		BISHOP_CHARGE_HIT = "Squeak!",
		TRUNKVEST_SUMMER = "Nose fashion.",
		TRUNKVEST_WINTER = "Nose fashion.",
		TRUNK_COOKED = "Ooo Yes! Moist and snotty! Just how I like it!",
		TRUNK_SUMMER = "Full of squishy meat, and yummy snot.",
		TRUNK_WINTER = "Full of squishy meat, and yummy snot.",
		TUMBLEWEED = "Full of stolen goods.",
		TURKEYDINNER = "I will gobble the entire thing up HA-ha!",
		TWIGS = "Good for nests, or poking things.",
		UMBRELLA = "I only need it when it is wet.",
		GRASS_UMBRELLA = "I can gnaw on it later.",
		UNIMPLEMENTED = "It is not ready yet.",
		WAFFLES = "I did not know food could came in this shape.",
		WALL_HAY =
		{
			GENERIC = "I suppose it stands on its own.",
			BURNT = "Huh...",
		},
		WALL_HAY_ITEM = "It could have been nest stuffing.",
		WALL_STONE = "A nice bricked wall.",
		WALL_STONE_ITEM = "Bricks of stone.",
		WALL_RUINS = "Hmm, yes it has a nice glazed look to it.",
		WALL_RUINS_ITEM = "It is better I think.",
		WALL_WOOD =
		{
			GENERIC = "Could be a good scratch post.",
			BURNT = "Burns nicely too.",
		},
		WALL_WOOD_ITEM = "Could be a good scratch post.",
		WALL_MOONROCK = "I am dissapointed it is not a cheese wall.",
		WALL_MOONROCK_ITEM = "It should have been cheese.",
		FENCE = "This won't keep me out you know.",
        FENCE_ITEM = "It is a few branches stuck together.",
        FENCE_GATE = "It squeaks when I open it.",
        FENCE_GATE_ITEM = "Maybe I should plop it down.",
		WALRUS = "He is full of fat.",
		WALRUSHAT = "I feel very cultured wearing it.",
		WALRUS_CAMP =
		{
			EMPTY = "It is a hole, but unfinished.",
			GENERIC = "Ohh, something goes over the pit.",
		},
		WALRUS_TUSK = "Maybe I could replace my teeth with it.",
		WARDROBE =
		{
			GENERIC = "I do not need clothes if you haven't noticed.",
            BURNING = "I do not care.",
			BURNT = "I do not care.",
		},
		WARG = "Grah! It is much scarier and evil then the others!.",
		WASPHIVE = "It looks very evil.",
		WATERBALLOON = "It is funny to make others wet.",
		WATERMELON = "The Shell is very bitter, but the pink is very Juicy.",
		WATERMELON_COOKED = "Warm and Juicy go very good together.",
		WATERMELONHAT = "It's sticky so it stays on.",
		WAXWELLJOURNAL = "This makes me angry, who made such stupid things.",
		WETGOOP = "All slime is good.",
        WHIP = "Everyone will respect me now.",
		WINTERHAT = "Keeps my ears from being nipped.",
		WINTEROMETER =
		{
			GENERIC = "How can it tell when it's getting colder?",
			BURNT = "Now it can't tell anything.",
		},

        WINTER_TREE =
        {
            BURNT = "I liked sitting around that tree...",
            BURNING = "It is even brighter now!",
            CANDECORATE = "We can put all the weird things we find on it!",
            YOUNG = "Something tells me it is almost time.",
        },
		WINTER_TREESTAND =
		{
			GENERIC = "There should be something inside that.",
            BURNT = "I liked sitting around that tree...",
		},
        WINTER_ORNAMENT = "It is shiny and mine!",
        WINTER_ORNAMENTLIGHT = "It is so flashy!",
        WINTER_ORNAMENTBOSS = "Yes, I must have them all...",
		WINTER_ORNAMENTFORGE = "little baubles that look like fiery beasts.",
		WINTER_ORNAMENTGORGE = "This is very goaty.",

        WINTER_FOOD1 = "It should be rat shaped.", --gingerbread cookie
        WINTER_FOOD2 = "Crunchy and crumbly sweetness.", --sugar cookie
        WINTER_FOOD3 = "Swirly, but I do not like how it makes my breathe minty fresh.", --candy cane
        WINTER_FOOD4 = "Why does everyone hate them? They are delicious.", --fruitcake
        WINTER_FOOD5 = "I approve of this.", --yule log cake
        WINTER_FOOD6 = "Plummed pudding is very plummy!", --plum pudding
        WINTER_FOOD7 = "I should leave it to ferment.", --apple cider
        WINTER_FOOD8 = "It makes me feel very warm and cozzy", --hot cocoa
        WINTER_FOOD9 = "Nogged eggs, I like it.", --eggnog

		WINTERSFEASTOVEN =
		{
			GENERIC = "Good place for hiding things!",
			COOKING = "Sizzling in there.",
			ALMOST_DONE_COOKING = "I can hear it bubbling still.",
			DISH_READY = "Ah! finally done.",
		},
		BERRYSAUCE = "Mashed them up into a nice paste.",
		BIBINGKA = "More! More! I need more of this!",
		CABBAGEROLLS = "They are rolled up and very easy to eat.",
		FESTIVEFISH = "Something smells fishy here. I can not put my claw on it.",
		GRAVY = "I did not know there is meaty slime.",
		LATKES = "Most delicious.",
		LUTEFISK = "Something smells fishy here. I can not put my claw on it.",
		MULLEDDRINK = "I love this brew, very tasty!",
		PANETTONE = "It is softer than I expected, but good.",
		PAVLOVA = "Mashy goodness, mashing makes every food better.",
		PICKLEDHERRING = "Things should be pickled more often.",
		POLISHCOOKIE = "All this food is very strange.",
		PUMPKINPIE = "Pumped pie, very tasty.",
		ROASTTURKEY = "I will eat it all! Even the bone.",
		STUFFING = "I do not know what is in it, who cares.",
		SWEETPOTATO = "It is like the normal one, but I like it more.",
		TAMALES = "What even is this?",
		TOURTIERE = "Very Chunky pie, I like this.",

		TABLE_WINTERS_FEAST =
		{
			GENERIC = "Where is the food.",
			HAS_FOOD = "More for me!",
			WRONG_TYPE = "No! What are you crazy.",
			BURNT = "It is horrible!",
		},

		GINGERBREADWARG = "Gooey crumbly cookie thing!",
		GINGERBREADHOUSE = "Crumbly house, most delicious.",
		GINGERBREADPIG = "Grrr Get back here!",
		CRUMBS = "A bit of something bigger.",
		WINTERSFEASTFUEL = "What is this holly jolly stuff?",

        KLAUS = "No no! It was not me who is stealing from you!",
        KLAUS_SACK = "Loot. My loot. Waiting for me...",
		KLAUSSACKKEY = "It is a key, maybe?",
		WORMHOLE =
		{
			GENERIC = "Lumpy ground thing.",
			OPEN = "This is a hole I would rather not see the bottom.",
		},
		WORMHOLE_LIMITED = "It might swallow me up forever!",
		ACCOMPLISHMENT_SHRINE = "Yes, I did it!", --single player
		LIVINGTREE = "I hear creaking and whispering...",
		ICESTAFF = "Yes I see this jewel is very cold.",
		REVIVER = "I like it because it is my heart.",
		SHADOWHEART = "It is bitter. Bitter.",
        ATRIUM_RUBBLE =
        {
			LINE_1 = "",
			LINE_2 = "",
			LINE_3 = ".",
			LINE_4 = ".",
			LINE_5 = "",
		},
        ATRIUM_STATUE = "Older thing, I do not know what it is thinking about.",
        ATRIUM_LIGHT =
        {
			ON = "It is whispering loudly now!",
			OFF = "It is quiet, But there is something inside.",
		},
        ATRIUM_GATE =
        {
			ON = "There is still no hole.",
			OFF = "It is a hole?",
			CHARGING = "See there is the hole.",
			DESTABILIZING = "I.",
			COOLDOWN = "",
        },
        ATRIUM_KEY = "Very unique, I will keep it now.",
		LIFEINJECTOR = "I do not think stabbing is good for healing.",
		SKELETON_PLAYER =
		{
			MALE = "%s had his bones cracked by the %s.",
			FEMALE = "%s had her bones cracked by the %s.",
			ROBOT = "%s become nothing but rubble by the %s.",
			DEFAULT = "%s was ripped apart by the %s",
		},
		HUMANMEAT = "Stringy is this flesh. Tasty.",
		HUMANMEAT_COOKED = "Interesting smell, I must have more!",
		HUMANMEAT_DRIED = "I like it fresh and moist!",
		ROCK_MOON = "Cheese?!",
		MOONROCKNUGGET = "It looks like cheese. It smells like cheese. But it is NOT CHEESE!?",
		MOONROCKCRATER = "A hole, not mine.",
		MOONROCKSEED = "Silly little rock.",

        REDMOONEYE = "The evil eye.",
        PURPLEMOONEYE = "Stareing with intent.",
        GREENMOONEYE = "Greedy envious eye.",
        ORANGEMOONEYE = "It is giving me the lazy eye!",
        YELLOWMOONEYE = "Staring right through me.",
        BLUEMOONEYE = "Stop giving me a cold look.",

        --Arena Event
        LAVAARENA_BOARLORD = "Hey fatty king, let me out of here.",
        BOARRIOR = "",
        BOARON = "",
        PEGHOOK = "",
        TRAILS = "He's got a strong arm on him.",
        TURTILLUS = "Its shell is so spiky!",
        SNAPPER = "This one's got bite.",
		RHINODRILL = "He's got a nose for this kind of work.",
		BEETLETAUR = "",

        LAVAARENA_PORTAL =
        {
            ON = "The hole is open again!",
            GENERIC = "Stupid thing spat us out here!",
        },
        LAVAARENA_KEYHOLE = "It is a little hole for what?",
		LAVAARENA_KEYHOLE_FULL = "Oh, It was hole for that.",
        LAVAARENA_BATTLESTANDARD = "That flag does not go there!",
        LAVAARENA_SPAWNER = "Make a hole for me to leave! Stupid thing.",

        HEALINGSTAFF = "Their smelly pollen is good for something.",
        FIREBALLSTAFF = "It will bring sunder and ruin.",
        HAMMER_MJOLNIR = "Powerful thwacker.",
        SPEAR_GUNGNIR = "Jagged teeth to make them bleed.",
        BLOWDART_LAVA = "I will spit fire into their eyes.",
        BLOWDART_LAVA2 = "I will snuff them out with it.",
        LAVAARENA_LUCY = "It is Angrier.",
        WEBBER_SPIDER_MINION = "I could smush them, but I will not.",
        BOOK_FOSSIL = "I do not want to read this.",
		LAVAARENA_BERNIE = "His little jig will make them upset.",
		SPEAR_LANCE = "I want this drill poker!",
		BOOK_ELEMENTAL = "It brings ruin and destruction.",
		LAVAARENA_ELEMENTAL = "A rock ball of destruction.",

   		LAVAARENA_ARMORLIGHT = "I could claw through it.",
		LAVAARENA_ARMORLIGHTSPEED = "It is mocking me.",
		LAVAARENA_ARMORMEDIUM = "At least it can't be knocked through.",
		LAVAARENA_ARMORMEDIUMDAMAGER = "My claws are sharper with it.",
		LAVAARENA_ARMORMEDIUMRECHARGER = "I will be quick and quicker with it.",
		LAVAARENA_ARMORHEAVY = "Impossible claw through it.",
		LAVAARENA_ARMOREXTRAHEAVY = "It is indestructible!",

		LAVAARENA_FEATHERCROWNHAT = "It makes me feel important.",
        LAVAARENA_HEALINGFLOWERHAT = "Yuck! I do not want to wear it.",
        LAVAARENA_LIGHTDAMAGERHAT = "Spiky hat haha!",
        LAVAARENA_STRONGDAMAGERHAT = "Spikier hat hahaha!",
        LAVAARENA_TIARAFLOWERPETALSHAT = "It will save me from this suffering.",
        LAVAARENA_EYECIRCLETHAT = "I will have a seventh sense with it.",
        LAVAARENA_RECHARGERHAT = "Thinking faster, very smart.",
        LAVAARENA_HEALINGGARLANDHAT = "Eugh... It make me looks stupid, but it is good.",
        LAVAARENA_CROWNDAMAGERHAT = "Most spikiest and best hat! HEHEHE!",

		LAVAARENA_ARMOR_HP = "It will keep me safe from the carnage.",

		LAVAARENA_FIREBOMB = "stinks of burning",
		LAVAARENA_HEAVYBLADE = "Big butchers knife.",

        --Quagmire
        QUAGMIRE_ALTAR =
        {
        	GENERIC = "Is that where we put the food?",
        	FULL = "Hey, but what if I still want it.",
    	},
		QUAGMIRE_ALTAR_STATUE1 = "It is very grotesque",
		QUAGMIRE_PARK_FOUNTAIN = "This would look nice in Rat-Town.",

        QUAGMIRE_HOE = "My claws work just as well.",

        QUAGMIRE_TURNIP = "I suppose it had to turn up somehow.",
        QUAGMIRE_TURNIP_COOKED = "Very bland smelling, and tasting.",
        QUAGMIRE_TURNIP_SEEDS = "Crunchy little bits.",

        QUAGMIRE_GARLIC = "Sometimes I eat to many and throw up afterwards.",
        QUAGMIRE_GARLIC_COOKED = "How delcious!",
        QUAGMIRE_GARLIC_SEEDS = "Crunchy little bits.",

        QUAGMIRE_ONION = "Very Juicy, I must have more.",
        QUAGMIRE_ONION_COOKED = "Delightful pungent aroma I am smelling!",
        QUAGMIRE_ONION_SEEDS = "Crunchy little bits.",

        QUAGMIRE_POTATO = "It is very hard to chew through.",
        QUAGMIRE_POTATO_COOKED = "Ooo cooking makes it softer I see.",
        QUAGMIRE_POTATO_SEEDS = "Crunchy little bits.",

        QUAGMIRE_TOMATO = "Squishy and full of juice, how wonderful!",
        QUAGMIRE_TOMATO_COOKED = "Now it is a bit crispy too.",
        QUAGMIRE_TOMATO_SEEDS = "Crunchy little bits.",

        QUAGMIRE_FLOUR = "Bland tasting dust.",
        QUAGMIRE_WHEAT = "They make for a good meal.",
        QUAGMIRE_WHEAT_SEEDS = "Crunchy little bits.",
        --NOTE: raw/cooked carrot uses regular carrot strings
        QUAGMIRE_CARROT_SEEDS = "Crunchy little bits.",

        QUAGMIRE_ROTTEN_CROP = "Smells like bad bugs.",

		QUAGMIRE_SALMON = "A slimey delicious fish.",
		QUAGMIRE_SALMON_COOKED = "",
		QUAGMIRE_CRABMEAT = "",
		QUAGMIRE_CRABMEAT_COOKED = "",
		QUAGMIRE_SUGARWOODTREE =
		{
			GENERIC = "There is a sweet treat inside, I can feel it.",
			STUMP = "The memory of something wonderful...",
			TAPPED_EMPTY = "I must wait for it. I hate waiting.",
			TAPPED_READY = "Aah! Finally just on time!",
			TAPPED_BUGS = "It is full of bugs! And not even the good kind.",
			WOUNDED = ".",
		},
		QUAGMIRE_SPOTSPICE_SHRUB =
		{
			GENERIC = "The dust is so sweet, I want to lick it dry.",
			PICKED = "I Wish there was more right now.",
		},
		QUAGMIRE_SPOTSPICE_SPRIG = "I could grind it up to make a spice.",
		QUAGMIRE_SPOTSPICE_GROUND = "Flavorful.",
		QUAGMIRE_SAPBUCKET = "We can use it to gather sap from the trees.",
		QUAGMIRE_SAP = "It tastes sweet.",
		QUAGMIRE_SALT_RACK =
		{
			READY = "Time to start Licking.",
			GENERIC = "I hate waiting.",
		},

		QUAGMIRE_POND_SALT = "A little pool of dry water.",
		QUAGMIRE_SALT_RACK_ITEM = ".",

		QUAGMIRE_SAFE =
		{
			GENERIC = "Well, I guess it is no longer a safe place.",
			LOCKED = "Stupid thing, bash it open.",
		},

		QUAGMIRE_KEY = "It is mine now!",
		QUAGMIRE_KEY_PARK = "It is mine now!",
        QUAGMIRE_PORTAL_KEY = "I want to bring it with me!",


		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "There are ",
			PICKED = "Useless stump, no more food.",
		},
		QUAGMIRE_MUSHROOMS = "I like eating these.",
        QUAGMIRE_MEALINGSTONE = "For grinding bones into dust.",
		QUAGMIRE_PEBBLECRAB = "",


		QUAGMIRE_RUBBLE_CARRIAGE = "On the road to nowhere.",
        QUAGMIRE_RUBBLE_CLOCK = "Someone beat the clock. Literally.",
        QUAGMIRE_RUBBLE_CATHEDRAL = "Preyed upon.",
        QUAGMIRE_RUBBLE_PUBDOOR = "",
        QUAGMIRE_RUBBLE_ROOF = "",
        QUAGMIRE_RUBBLE_CLOCKTOWER = "",
        QUAGMIRE_RUBBLE_BIKE = "Crooked metal something.",
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "No one's here.",
            "Something destroyed this town.",
            "I wonder who they angered.",
        },
        QUAGMIRE_RUBBLE_CHIMNEY = "",
        QUAGMIRE_RUBBLE_CHIMNEY2 = "Something put a damper on that chimney.",
        QUAGMIRE_MERMHOUSE = "What an ugly little house.",
        QUAGMIRE_SWAMPIG_HOUSE = "It's seen better days.",
        QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "Some pig's house was ruined.",
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "I guess you're in charge around here?",
            SLEEPING = ".",
        },
        QUAGMIRE_SWAMPIG = "",

        QUAGMIRE_PORTAL = "Stupid hole did it again.",
        QUAGMIRE_SALTROCK = "",
        QUAGMIRE_SALT = "",
        --food--
        QUAGMIRE_FOOD_BURNT = "",
        QUAGMIRE_FOOD =
        {
        	GENERIC = "I should give it up maybe...",
            MISMATCH = "Hey! Stop snarling I gave you food!",
            MATCH = "It liked eating ",
            MATCH_BUT_SNACK = "",
        },

        QUAGMIRE_FERN = "I would rather nibble on something else.",
        QUAGMIRE_FOLIAGE_COOKED = "Smells more eatable now.",
        QUAGMIRE_COIN1 = ".",
        QUAGMIRE_COIN2 = ".",
        QUAGMIRE_COIN3 = "",
        QUAGMIRE_COIN4 = "This one is special for some reason.",
        QUAGMIRE_GOATMILK = "Mmm ",
        QUAGMIRE_SYRUP = "Gooey deliciousness, Winky's favourite!",
        QUAGMIRE_SAP_SPOILED = "It is full of bugs! And not even the good kind.",
        QUAGMIRE_SEEDPACKET = "Bag full of crunchy little bites.",

        QUAGMIRE_POT = "This pot holds more ingredients.",
        QUAGMIRE_POT_SMALL = "Let's get cooking!",
        QUAGMIRE_POT_SYRUP = "I need to sweeten this pot.",
        QUAGMIRE_POT_HANGER = "It has hang-ups.",
        QUAGMIRE_POT_HANGER_ITEM = "For suspension-based cookery.",
        QUAGMIRE_GRILL = "Now all I need is a backyard to put it in.",
        QUAGMIRE_GRILL_ITEM = "I'll have to grill someone about this.",
        QUAGMIRE_GRILL_SMALL = "Barbecurious.",
        QUAGMIRE_GRILL_SMALL_ITEM = "For grilling small meats.",
        QUAGMIRE_OVEN = "It needs ingredients to make the science work.",
        QUAGMIRE_OVEN_ITEM = "For scientifically burning things.",
        QUAGMIRE_CASSEROLEDISH = "A dish for all seasonings.",
        QUAGMIRE_CASSEROLEDISH_SMALL = "For making minuscule motleys.",
        QUAGMIRE_PLATE_SILVER = "A silver plated plate.",
        QUAGMIRE_BOWL_SILVER = "A bright bowl.",
        QUAGMIRE_CRATE = "Kitchen stuff.",

        QUAGMIRE_MERM_CART1 = "Any science in there?", --sammy's wagon
        QUAGMIRE_MERM_CART2 = "I could use some stuff.", --pipton's cart
        QUAGMIRE_PARK_ANGEL = "Take that, creature!",
        QUAGMIRE_PARK_ANGEL2 = "So lifelike.",
        QUAGMIRE_PARK_URN = "Ashes to ashes.",
        QUAGMIRE_PARK_OBELISK = "A monumental monument.",
        QUAGMIRE_PARK_GATE =
        {
            GENERIC = "Turns out a key was the key to getting in.",
            LOCKED = "Locked tight.",
        },
        QUAGMIRE_PARKSPIKE = "The scientific term is: \"Sharp pointy thing\".",
        QUAGMIRE_CRABTRAP = "A crabby trap.",
        QUAGMIRE_TRADER_MERM = "Maybe they'd be willing to trade.",
        QUAGMIRE_TRADER_MERM2 = "Maybe they'd be willing to trade.",

        QUAGMIRE_GOATMUM = "Reminds me of my old nanny.",
        QUAGMIRE_GOATKID = "This goat's much smaller.",
        QUAGMIRE_PIGEON =
        {
            DEAD = "They're dead.",
            GENERIC = "He's just winging it.",
            SLEEPING = "It's sleeping, for now.",
        },
        QUAGMIRE_LAMP_POST = "Huh. Reminds me of home.",

        QUAGMIRE_BEEFALO = "Science says it should have died by now.",
        QUAGMIRE_SLAUGHTERTOOL = "Laboratory tools for surgical butchery.",

        QUAGMIRE_SAPLING = "I can't get anything else out of that.",
        QUAGMIRE_BERRYBUSH = "Those berries are all gone.",

        QUAGMIRE_ALTAR_STATUE2 = "What are you looking at?",
        QUAGMIRE_ALTAR_QUEEN = "A monumental monument.",
        QUAGMIRE_ALTAR_BOLLARD = "As far as posts go, this one is adequate.",
        QUAGMIRE_ALTAR_IVY = "Kind of clingy.",

        QUAGMIRE_LAMP_SHORT = "It is bright.",

        --v2 Winona
        WINONA_CATAPULT =
        {
        	GENERIC = "Hmm yes, a machine with a good purpose.",
        	OFF = "Kick it, so it starts working.",
        	BURNING = "Huh? that is not right.",
        	BURNT = "Now it really is broken haha!",
        },
        WINONA_SPOTLIGHT =
        {
        	GENERIC = "Looking at it hurts my eyes!",
        	OFF = "Kick it, so it starts working.",
        	BURNING = "Huh? that is not right.",
        	BURNT = "Now it really is broken haha!",
        },
        WINONA_BATTERY_LOW =
        {
        	GENERIC = "How do you fill a box full of lightning?",
        	LOWPOWER = "It is dying.",
        	OFF = "It is broken. Stupid thing.",
        	BURNING = "Huh? that is not right.",
        	BURNT = "Now it really is broken haha!",
        },
        WINONA_BATTERY_HIGH =
        {
        	GENERIC = "How do you fill a box full of gem juice?",
        	LOWPOWER = "It is dying.",
        	OFF = "It is broken. Stupid thing.",
        	BURNING = "Huh? that is not right.",
        	BURNT = "Now it really is broken haha!",
        },

        --Wormwood
        COMPOSTWRAP = "That is gross, even for me.",
        ARMOR_BRAMBLE = "Now nobody can touch me, and I can be left alone.",
        TRAP_BRAMBLE = "It's like a spring, but deadly.",

        BOATFRAGMENT03 = "I am happy that wasn't me.",
        BOATFRAGMENT04 = "I am happy that wasn't me.",
        BOATFRAGMENT05 = "I am happy that wasn't me.",
		BOAT_LEAK = "Aaah!! When did that happen!?",
        MAST = "I should get my family to blow on it.",
        SEASTACK = "Who stacked it?",
        FISHINGNET = "Now look at this net, that I found.", --unimplemented
        ANTCHOVIES = "small and crunchy and juicy!", --unimplemented
        STEERINGWHEEL = "Steering makes me feel important.",
        ANCHOR = "I hope it hits a fish.",
        BOATPATCH = "Don't need it, I won't claw holes in the raft.",
        DRIFTWOOD_TREE =
        {
            BURNING = "It will be dead again?",
            BURNT = "Burnt skeleton tree.",
            CHOPPED = "I could claw it up.",
            GENERIC = "The saltyness made it a skeleton.",
        },

        DRIFTWOOD_LOG = "They are tree bones I think?",

        MOON_TREE =
        {
            BURNING = "This is how you burn fat!",
            BURNT = "Broken fat tree.",
            CHOPPED = "I made it lose its weight, ha ha.",
            GENERIC = "It is fat.",
        },
		MOON_TREE_BLOSSOM = "Little sweet tasting thing.",

        MOONBUTTERFLY =
        {
        	GENERIC = "It is like a bug, but glass. Bugs are not normally glassy.",
        	HELD = "You are like a tiny voice.",
        },
		MOONBUTTERFLYWINGS = "Glassy crunchy wings.",
        MOONBUTTERFLY_SAPLING = "At least it is not fat.",
        ROCK_AVOCADO_FRUIT = "Rocks are not food.",
        ROCK_AVOCADO_FRUIT_RIPE = "Oh I had to smash it.",
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "Delicoius rock slime in a cup.",
        ROCK_AVOCADO_FRUIT_SPROUT = "Leave it in dirt, get more rock food.",
        ROCK_AVOCADO_BUSH =
        {
        	BARREN = "Crooked...",
			WITHERED = "Drier than dirt.",
			GENERIC = "It is odd looking.",
			PICKED = "Rockless bush, very strange thing.",
			DISEASED = "I do not want to eat that!", --unimplemented
			DISEASING = "Hmm smells more yucky!", --unimplemented
			BURNING = "I have had it with fire!",
		},
        DEAD_SEA_BONES = "I should gnaw on them.",
        HOTSPRING =
        {
        	GENERIC = "I do not bathe.",
        	BOMBED = "Bubbly water.",
        	GLASS = "See, I am glad I was not in there.",
			EMPTY = "It is still warm.",
        },
        MOONGLASS = "Good for stabbing.",
        MOONGLASS_CHARGED = "I can hear the buzzing inside!",
        MOONGLASS_ROCK = "I wish I could take the whole thing in one piece.",
        BATHBOMB = "I do not bathe?",
        TRAP_STARFISH =
        {
            GENERIC = "Ooo I want to touch it.",
            CLOSED = "HEY! watch the tail!",
        },
        DUG_TRAP_STARFISH = "I cannot believe it was alive...",
        SPIDER_MOON =
        {
        	GENERIC = "He is ugly.",
        	SLEEPING = "Gurgle snores, he is not right.",
        	DEAD = "It was in misery.",
        },
        MOONSPIDERDEN = "Crazy legs!",
		FRUITDRAGON =
		{
			GENERIC = "It doesn't smell ready.",
			RIPE = "Looks tasty.",
			SLEEPING = "I should take a bite out of it.",
		},
        PUFFIN =
        {
            GENERIC = "Bird sitting on the water.",
            HELD = "Why do they call you that? \"puff in?\"",
            SLEEPING = "Honk shuuu...",
        },

		MOONGLASSAXE = "Not very good for smashing.",
		GLASSCUTTER = "It has teeth like me!",

        ICEBERG =
        {
            GENERIC = "Hard water on water.", --unimplemented
            MELTED = "It is water.. again.", --unimplemented
        },
        ICEBERG_MELTED = "It is water.. again.", --unimplemented

        MINIFLARE = "Blinding stick.",
		MEGAFLARE = "I do not want things coming after me.",

		MOON_FISSURE =
		{
			GENERIC = "I like to stare at it...",
			NOLIGHT = "A crater hole.",
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "Yes, I can make you better!",
            GENERIC = "I can hear you, but where are you? Speak louder!",
        },

        MOON_ALTAR_IDOL = "I must bring you somewhere, I must bring you home.",
        MOON_ALTAR_GLASS = "How can you whisper so loudly?",
        MOON_ALTAR_SEED = "I know what you want, but I do not understand the whispers.",

        MOON_ALTAR_ROCK_IDOL = "There is someone inside.",
        MOON_ALTAR_ROCK_GLASS = "The whispers are just as loud no matter how far I am?",
        MOON_ALTAR_ROCK_SEED = "Yes, I am coming to help, stop being so loud.",

        MOON_ALTAR_CROWN = "You belong to me now, yes, thank me later.",
        MOON_ALTAR_COSMIC = "Patience? Why?",

        MOON_ALTAR_ASTRAL = "You are here, What do you want now?",
        MOON_ALTAR_ICON = "It wants to go back the moon place, with its family.",
        MOON_ALTAR_WARD = "You belong with your family.",

        SEAFARING_PROTOTYPER =
        {
            GENERIC = "Helping me learn about why I hate being wet.",
            BURNT = "No more learning. Good.",
        },
        BOAT_ITEM = "I do not trust it, I do not like water.",
        STEERINGWHEEL_ITEM = "I do not need it, but it is mine now.",
        ANCHOR_ITEM = "It is heavy, but I want it.",
        MAST_ITEM = "It catches wind? How do you catch something you can not hold?",
        MUTATEDHOUND =
        {
        	DEAD = "I spit on you.",
        	GENERIC = "NO, It wasn't me! I DIDN'T KILL YOU!",
        	SLEEPING = "Kill it again now!",
        },

        MUTATED_PENGUIN =
        {
			DEAD = "Eugh, smells TERRIBLE!!",
			GENERIC = "The good meat is gone!",
			SLEEPING = "I think it's dying...",
		},
        CARRAT =
        {
        	DEAD = "Good food, is dead food.",
        	GENERIC = "Why are you running!",
        	HELD = "Familiar looking.",
        	SLEEPING = "I need to make it back into food.",
        },

		BULLKELP_PLANT =
        {
            GENERIC = "Sea Leaf.",
            PICKED = "No more.",
        },
		BULLKELP_ROOT = "I can whip it around Ha-ha-HA!",
        KELPHAT = "Slimey thing.",
		KELP = "I think I like, but eating it makes me thirsty.",
		KELP_COOKED = "slimey and hot.",
		KELP_DRIED = "Better slimey, not crunchy.",

		GESTALT = "My.. Desires..?",
        GESTALT_GUARD = "Angry whisperers... I hate you too.",

		COOKIECUTTER = "Drowning face.",
		COOKIECUTTERSHELL = "I will start a new collection of these.",
		COOKIECUTTERHAT = "Spiky hat for Winky!",
		SALTSTACK =
		{
			GENERIC = "Mmmm, seems like good thing.",
			MINED_OUT = "Broken now?",
			GROWING = "It is becoming taller.",
		},
		SALTROCK = "I lick each one, so it is mine!",
		SALTBOX = "You food the salt?",

		TACKLESTATION = "I do not like fishing, but I like to eat.",
		TACKLESKETCH = "Little scritches on the paper.",

        MALBATROSS = "That duck is too big!",
        MALBATROSS_FEATHER = "I like this sea duck feather, it is mine now.",
        MALBATROSS_BEAK = "Look, noow I can be a duck, Quack! Quack! That is funny, right?",
        MAST_MALBATROSS_ITEM = "Birds catch wind, so it is better.",
        MAST_MALBATROSS = "Birds catch wind, so it is better.",
		MALBATROSS_FEATHERED_WEAVE = "It is my blanket.",

        GNARWAIL =
        {
            GENERIC = "Hey, get away from me!",
            BROKENHORN = "Your Stabbing part gone!",
            FOLLOWER = "He likes me now?",
            BROKENHORN_FOLLOWER = "You are not useful, but funny to look at.",
        },
        GNARWAIL_HORN = "Stabber!! AHAHA!",

        WALKINGPLANK = "I am a PiRATe now hahaHA!",
        OAR = "Is it not for whacking things?",
		OAR_DRIFTWOOD = "I carved it, so I will use it how I want.",

		OCEANFISHINGROD = "!",
		OCEANFISHINGBOBBER_NONE = "It is for floating, and the fish like it?",
        OCEANFISHINGBOBBER_BALL = "It is for floating, and the fish like it?",
        OCEANFISHINGBOBBER_OVAL = "It is for floating, and the fish like it?",
		OCEANFISHINGBOBBER_CROW = "Black needle floter thing.",
		OCEANFISHINGBOBBER_ROBIN = "Red needle floter thing.",
		OCEANFISHINGBOBBER_ROBIN_WINTER = "White needle floter thing.",
		OCEANFISHINGBOBBER_CANARY = "Yellow needle floter thing.",
		OCEANFISHINGBOBBER_GOOSE = "Goosey needle floater thing.",
		OCEANFISHINGBOBBER_MALBATROSS = "Blue needle floater thing.",

		OCEANFISHINGLURE_SPINNER_RED = "Mushrooms make for good fish catchers, I think.",
		OCEANFISHINGLURE_SPINNER_GREEN = "Mushrooms make for good fish catchers, I think.",
		OCEANFISHINGLURE_SPINNER_BLUE = "Mushrooms make for good fish catchers, I think.",
		OCEANFISHINGLURE_SPOON_RED = "Mushrooms make for good fish catchers, I think.",
		OCEANFISHINGLURE_SPOON_GREEN = "Mushrooms make for good fish catchers, I think.",
		OCEANFISHINGLURE_SPOON_BLUE = "Mushrooms make for good fish catchers, I think.",
		OCEANFISHINGLURE_HERMIT_RAIN = "I do not like water, why would I fish when there is more of it.",
		OCEANFISHINGLURE_HERMIT_SNOW = "It looks like a snowflake.",
		OCEANFISHINGLURE_HERMIT_DROWSY = "I could just... Chuck it at the fish!",
		OCEANFISHINGLURE_HERMIT_HEAVY = "Why does it look like the drowning faces?",

		OCEANFISH_SMALL_1 = "Some small and stupid fish.", --runty guppy
		OCEANFISH_SMALL_2 = "That does not look like a nose, stupid fish.", --needlenose squirt
		OCEANFISH_SMALL_3 = "I should just eat you for wasting my time.", --bitybaitfish
		OCEANFISH_SMALL_4 = "Yes, maybe I should fry it.", --smolt fry
		OCEANFISH_SMALL_5 = "The fish is popped and puffy.", --PopCorn
		OCEANFISH_SMALL_6 = "How is a fish leaves, are there ocean trees?", --fallounder
		OCEANFISH_SMALL_7 = "Does it make fruit too? I do not get it.", --bloomfin
		OCEANFISH_SMALL_8 = "Too hot to eat. Maybe it will cook itself to death?", --sun
        OCEANFISH_SMALL_9 = "I will spit back at you, stupid fish!", --spittle

		OCEANFISH_MEDIUM_1 = "It is a tasty looking fish.", --mudfish
		OCEANFISH_MEDIUM_2 = "Goo goo eyed fish, strange and stupid looking.", --deepbass
		OCEANFISH_MEDIUM_3 = "Are your spikes supposed to stop me from eating you?", --Lion
		OCEANFISH_MEDIUM_4 = "It is an imitation cat! You can not trick me.", --black catfish
		OCEANFISH_MEDIUM_5 = "it is an uncooked fish, it must be made popped and puffy.", --Corn
		OCEANFISH_MEDIUM_6 = "It has whiskers like a rat, very strange.", --Koi
		OCEANFISH_MEDIUM_7 = "It has whiskers like a rat, very strange.", --Koi
		OCEANFISH_MEDIUM_8 = "Too cold and hard, it must thaw.", --Icebream
        OCEANFISH_MEDIUM_9 = "Yes, you were made for eating!", --sweetish

		PONDFISH = "You will not struggle for long.",
		PONDEEL = "Stop squirming, I will bite your head off.",

        FISHMEAT = "Good to eat it whole.",
        FISHMEAT_COOKED = "Smells nice, but I prefer it slimey.",
        FISHMEAT_SMALL = "Little chunk, I can eat it in one bite.",
        FISHMEAT_SMALL_COOKED = "Smells nice, but I prefer it slimey.",
		SPOILED_FISH = "Very intriguing odor, very pungent. I like this.",

		FISH_BOX = "A prison for my food.",
        POCKET_SCALE = "The arrow moves when I pull the hook.",

		TACKLECONTAINER = "Full of hooks and floaty things.",
		SUPERTACKLECONTAINER = "Full of more hooks and floaty things, and maybe worms.",

		TROPHYSCALE_FISH =
		{
			GENERIC = "It is for seeing how much meat a fish has.",
			HAS_ITEM = "Weight: {weight}\nCaught by: {owner}",
			HAS_ITEM_HEAVY = "Weight: {weight}\nCaught by: {owner}\nYes, the fish is big!",
			BURNING = "It is cooking the fishes on it now.",
			BURNT = "It cooked itself and is broken now.",
			OWNER = "It is mine, I will eat it later. \nWeight: {weight}\nCaught by: {owner}",
			OWNER_HEAVY = "Weight: {weight}\nCaught by: {owner}\nI catch the biggest juiciest fish!",
		},

		OCEANFISHABLEFLOTSAM = "A little mud island.",

		CALIFORNIAROLL = "More of these are needed, they are too small.",
		SEAFOODGUMBO = "I want more of this and I want to to be jumbo.",
		SURFNTURF = "I must eat every creature.",

        WOBSTER_SHELLER = "It is fun to play with your food.",
        WOBSTER_DEN = "Stupid rock.",
        WOBSTER_SHELLER_DEAD = "He is dead and smelly.",
        WOBSTER_SHELLER_DEAD_COOKED = "I will crack you up and eat you.",

        LOBSTERBISQUE = "Soupy lobster drink, yes, I like this.",
        LOBSTERDINNER = "Yes, it was boiled alive!",

        WOBSTER_MOONGLASS = "Hmmm, I do not think I will eat this...",
        MOONGLASS_WOBSTER_DEN = "Stupid rock and stupid glass on it.",

		TRIDENT = "Good for poking things I am not happy at.",

		WINCH =
		{
			GENERIC = "It'll do in a pinch.",
			RETRIEVING_ITEM = "I'll let it do the heavy lifting.",
			HOLDING_ITEM = "What do we have here?",
		},

        HERMITHOUSE = {
            GENERIC = "That is sad and ugly!",
            BUILTUP = "Hey, I want to live there, I made it!",
        },

        SHELL_CLUSTER = "It looks very nice all gooed together, and no noise!",
        --
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "Clunky clanky noises",
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "Clinky clanky noises",
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "Cling clang clunky noises",
        },

        CHUM = "It is fish food? Why would I want to feed them?",

        SUNKENCHEST =
        {
            GENERIC = "I have dredged up, something I can not open, it was pointless!",
            LOCKED = "I have dredged up, something I can not open, it was pointless!",
        },

        HERMIT_BUNDLE = "A stupid gift, and it is my stupid gift for some reason.",
        HERMIT_BUNDLE_SHELLS = "I hear them clunking around inside.",

        RESKIN_TOOL = "I do not like to clean. Things are better in piles.",
        MOON_FISSURE_PLUGGED = "It makes gross sounds now.",


		----------------------- ROT STRINGS GO ABOVE HERE ------------------

		-- Walter
        WOBYBIG =
        {
            "Gah?! It is a monster thing now!?",
            "Gah?! It is a monster thing now!?",
        },
        WOBYSMALL =
        {
            "You are a stinky little creature.",
            "You are a stinky little creature.",
        },
		WALTERHAT = "I do not like cone hats, they are for stupid people.",
		SLINGSHOT = "I like this trinket haha!",
		SLINGSHOTAMMO_ROCK = "pebble.",
		SLINGSHOTAMMO_MARBLE = "pebble.",
		SLINGSHOTAMMO_THULECITE = "pebble.",
        SLINGSHOTAMMO_GOLD = "Shiny pebble.",
        SLINGSHOTAMMO_SLOW = "Jewel pebble.",
        SLINGSHOTAMMO_FREEZE = "Jewel pebble.",
		SLINGSHOTAMMO_POOP = "stinky little ball.",
        PORTABLETENT = "I prefer sleeping in my Rat-hole.",
        PORTABLETENT_ITEM = "I would need help, I do not know how it works.",

        -- Wigfrid
        BATTLESONG_DURABILITY = "Yes, this is very well... Written?",
        BATTLESONG_HEALTHGAIN = "Yes, this is very well... Written?",
        BATTLESONG_SANITYGAIN = "Yes, this is very well... Written?",
        BATTLESONG_SANITYAURA = "Yes, this is very well... Written?",
        BATTLESONG_FIRERESISTANCE = "Yes, this is very well... Written?",
        BATTLESONG_INSTANT_TAUNT = "Huh, what does this say?!",
        BATTLESONG_INSTANT_PANIC = "I can not say I am very scared.",

        -- Webber
        MUTATOR_WARRIOR = "These cookies are very tasty.",
        MUTATOR_DROPPER = "I must have another, they are very delicious!",
        MUTATOR_HIDER = "These cookies are very tasty.",
        MUTATOR_SPITTER = "I must have another, they are very delicious!",
        MUTATOR_MOON = "These cookies are very tasty.",
        MUTATOR_HEALER = "I must have another, they are very delicious!",
        SPIDER_WHISTLE = "I know someone who plays rat songs with one.",
        SPIDERDEN_BEDAZZLER = "It is very distracting.",
        SPIDER_HEALER = "Hmm you have an interesting smell.",
        SPIDER_REPELLENT = "It is very noisy.",
        SPIDER_HEALER_ITEM = "Edible gloop.",

		-- Wendy
		GHOSTLYELIXIR_SLOWREGEN = "What kind of drink is this?",
		GHOSTLYELIXIR_FASTREGEN = "What kind of drink is this?",
		GHOSTLYELIXIR_SHIELD = "What kind of drink is this?",
		GHOSTLYELIXIR_ATTACK = "What kind of drink is this?",
		GHOSTLYELIXIR_SPEED = "What kind of drink is this?",
		GHOSTLYELIXIR_RETALIATION = "What kind of drink is this?",
		SISTURN =
		{
			GENERIC = "It smells sad.",
			SOME_FLOWERS = "The flowers do nothing for it.",
			LOTS_OF_FLOWERS = "Those flowers will die eventually, like everything.",
		},

        --Wortox
        WORTOX_SOUL = "only_used_by_wortox", --only wortox can inspect souls

        PORTABLECOOKPOT_ITEM =
        {
            GENERIC = "Now we're cookin'!",
            DONE = "Now we're done cookin'!",

			COOKING_LONG = "That meal is going to take a while.",
			COOKING_SHORT = "It'll be ready in no-time!",
			EMPTY = "I bet there's nothing in there.",
        },

        PORTABLEBLENDER_ITEM = "It grinds things into dust.",
        PORTABLESPICER_ITEM =
        {
            GENERIC = "Maybe we should grind bones next.",
            DONE = "I do not understand how dust is tasty?",
        },
        SPICEPACK = "Hat bag.",
        SPICE_GARLIC = "Smelling stinky! I like!",
        SPICE_SUGAR = "Crunchy!",
        SPICE_CHILI = "Food tastes like nothing but hotness with it.",
        SPICE_SALT = "Fine as it is.",
        MONSTERTARTARE = "It smells, very, very good!",
        FRESHFRUITCREPES = "I have eaten many creeps before, this one is very sweet.",
        FROGFISHBOWL = "Oooo slime bowl, very yummy!",
        POTATOTORNADO = "Is it full of air?",
        DRAGONCHILISALAD = "euch.. Cough. Cough. It is too much.",
        GLOWBERRYMOUSSE = "Berrys but mushed.",
        VOLTGOATJELLY = "Gummy slime.",
        NIGHTMAREPIE = "I should throw it... hehe.",
        BONESOUP = "Bones make for the most delicious food.",
        MASHEDPOTATOES = "Mashy.",
        POTATOSOUFFLE = "Potato-soufflay? What does that even mean.",
        MOQUECA = "Fishy, fishy, My belly is your new home!",
        GAZPACHO = "It is how you say refreshing.",
        ASPARAGUSSOUP = "Better smelling and tasty.",
        VEGSTINGER = "Oooh! What a powerful taste.",
        BANANAPOP = "Cruncy and banana-y.",
        CEVICHE = "Ice but tastier.",
        SALSA = "I have heard It will make me fart.",
        PEPPERPOPPER = "Food for rhyming.",

        TURNIP = "I suppose it had to turn up somehow.",
        TURNIP_COOKED = "Very bland smelling, and tasting.",
        TURNIP_SEEDS = "Crunchy little bits.",

        GARLIC = "Sometimes I eat too many and throw up afterwards.",
        GARLIC_COOKED = "How delcious!",
        GARLIC_SEEDS = "Crunchy little bits.",

        ONION = "Very Juicy, I must have more.",
        ONION_COOKED = "Delightful pungent aroma I am smelling!",
        ONION_SEEDS = "Crunchy little bits.",

        POTATO = "It is very hard to chew through.",
        POTATO_COOKED = "Ooo cooking makes it softer I see.",
        POTATO_SEEDS = "Crunchy little bits.",

        TOMATO = "Squishy and full of juice, how wonderful!",
        TOMATO_COOKED = "Now it is a bit crispy too.",
        TOMATO_SEEDS = "Crunchy little bits.",

        ASPARAGUS = "dry and crunchy, but it is nice.",
        ASPARAGUS_COOKED = "Floppy, but very nice smelling and good.",
        ASPARAGUS_SEEDS = "Crunchy little bits.",

        PEPPER = "It tricked me, it does not smell hot until you bite it!",
        PEPPER_COOKED = "OooH, I can smell it now.",
        PEPPER_SEEDS = "Crunchy little bits.",

        WEREITEM_BEAVER = "It looks like a rat, is it for me?",
        WEREITEM_GOOSE = "This thing is very... ugly.",
        WEREITEM_MOOSE = "Seems like a waste of food to me.",

        MERMHAT = "Hehe Smelling different tricks them, they are so stupid.",
        MERMTHRONE =
        {
            GENERIC = "I've seen better, smellier, thrones.",
            BURNT = "Did not impress me anyways.",
        },
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "It is not as impressive as what We've built.",
            BURNT = "I am not surprised.",
        },
        MERMHOUSE_CRAFTED =
        {
            GENERIC = "It is very ugly. But smelly.",
            BURNT = "Ashes to fishes.",
        },

        MERMWATCHTOWER_REGULAR = "Very... Patriotic.",
        MERMWATCHTOWER_NOKING = "They are sad now, and smelly, and stupid.",
        MERMKING = "He smells. Smells bad! Ha Ha HA!",
        MERMGUARD = "You are all wrapped up in yourself.",
        MERM_PRINCE = "What are you waiting for?",

        SQUID = "Spatty little inky thing.",

		GHOSTFLOWER = "Not real flower.",
        SMALLGHOST = "Ew, get away. I have No time for you!",

        CRABKING =
        {
            GENERIC = "He is meat right? boil It maybe.",
            INERT = "Boring to look at!",
        },
		CRABKING_CLAW = "The claws are! Uh... they are... ALARMING! YES!",

		MESSAGEBOTTLE = "Treasure for Winky",
		MESSAGEBOTTLEEMPTY = "Good for throwing.",

        MEATRACK_HERMIT =
        {
            DONE = "Finally.",
            DRYING = "This takes too long. just eat it normaly.",
            DRYINGINRAIN = "I could have just ate it off the bone...",
            GENERIC = "Place to make meat chewy.",
            BURNT = "Guh, terrible.",
            DONE_NOTMEAT = "Finally.",
            DRYING_NOTMEAT = "It won't be wet anymore.",
            DRYINGINRAIN_NOTMEAT = "sigh...",
        },
        BEEBOX_HERMIT =
        {
			READY = "Oozing the stuff I want.",
			FULLHONEY = "Oozing the stuff I want.",
			GENERIC = "They do not like me.",
			NOHONEY = "Make More gooey stuff.",
			SOMEHONEY = "Ooh, I see some!",
			BURNT = "Grumble... It WAS NOT ME.",
        },

        HERMITCRAB = "Guh, I do not like being near her.",

        HERMIT_PEARL = "Yes, yes, I am trustworthy with this, yes!",
        HERMIT_CRACKED_PEARL = "Aaaaaw It is ruined now! It was perfect!",

        -- DSEAS
        WATERPLANT = "Give me your rock food.",
        WATERPLANT_BOMB = "Squeak!",
        WATERPLANT_BABY = "We should RIP! it out now.",
        WATERPLANT_PLANTER = "Ugly looking rocks.",

        SHARK = "No, No! I want OFF!!",

        MASTUPGRADE_LAMP_ITEM = "What if it starts burning everything, then what?",
        MASTUPGRADE_LIGHTNINGROD_ITEM = "It is useless gold bits.",

        WATERPUMP = "all this pumping, and for what? Something that is all around?",

        BARNACLE = "Crack it open.",
        BARNACLE_COOKED = "I am on a see food diet now.",

        BARNACLEPITA = "",
        BARNACLESUSHI = "So small. I do not even need to chew it.",
        BARNACLINGUINE = "",
        BARNACLESTUFFEDFISHHEAD = "This is a very good way of eating.",

        LEAFLOAF = "It is looking most appetizing.",
        LEAFYMEATBURGER = "Tastes like a fresh meat. I thought it was imitation?",
        LEAFYMEATSOUFFLE = "",
        MEATYSALAD = "I do not like leafs, BUT! These are very good for some reason.",

        -- GROTTO

		MOLEBAT = "We are NOT related you ugly, stupid thing.",
        MOLEBATHILL = "There better not be any of my things in there.",

        BATNOSE = "Usually it is the snot that tastes better.",
        BATNOSE_COOKED = "I wonder if it can still smell.",
        BATNOSEHAT = "I can eat and steal things.",

        MUSHGNOME = "What a dopey thing! It is very funny.",

        SPORE_MOON = "AGH! I did not expect them to POP!",

        MOON_CAP = "It is a mushroom what is different?",
        MOON_CAP_COOKED = "hmmm this smells odd? Maybe it is different.",

        MUSHTREE_MOON = "Looks normal to me.",

        LIGHTFLIER = "I bet it tastes like the sun!",

        GROTTO_POOL_BIG = "I am not drinking that sparkling water.",
        GROTTO_POOL_SMALL = "I am not drinking that sparkling water.",

        DUSTMOTH = "For something that does cleaning, you are very dusty.",

        DUSTMOTHDEN = "It is a very boring hole.",

        ARCHIVE_LOCKBOX = "Chewing on it did nothing!",
        ARCHIVE_CENTIPEDE = "Rolly Polly!",
        ARCHIVE_CENTIPEDE_HUSK = "Stupid thing, I spit on you!",

        ARCHIVE_COOKPOT =
        {
            COOKING_LONG = "This is going to take a while.",
            COOKING_SHORT = "It's almost done!",
            DONE = "Mmmmm! It's ready to eat!",
            EMPTY = "Let's dust off this old crockery, shall we?",
            BURNT = "The pot got cooked.",
        },

        ARCHIVE_MOON_STATUE = "They are worshipping cheese, as you should.",
        ARCHIVE_RUNE_STATUE =
        {
            LINE_1 = "These are just rat-scratchings.",
            LINE_2 = "Look, I do not do this \"reading\" thing.",
            LINE_3 = "These are just rat-scratchings.",
            LINE_4 = "Look, I do not do this \"reading\" thing.",
            LINE_5 = "I can read this one! Wait no I can't, Haha.",
        },

        ARCHIVE_RESONATOR = {
            GENERIC = "Why use a map when you could use a mind-bogglingly complex piece of machinery?",
            IDLE = "It seems to have found everything worth finding.",
        },

        ARCHIVE_RESONATOR_ITEM = "Aha! I used the secret knowledge to build a device! Why does this feel familiar...",

        ARCHIVE_LOCKBOX_DISPENCER = {
          POWEROFF = "If only there was a way to get it working again...",
          GENERIC =  "I have the strongest urge to stand around it and talk about nothing in particular.",
        },

        ARCHIVE_SECURITY_DESK = {
            POWEROFF = "Whatever it did, it's not doing it anymore.",
            GENERIC = "It looks inviting.",
        },

        ARCHIVE_SECURITY_PULSE = "I am not sure I can steal that.",

        ARCHIVE_SWITCH = {
            VALID = "Ohh! It is there for me to steal!",
            GEMS = "Nothing in there.",
        },

        ARCHIVE_PORTAL = {
            POWEROFF = "Something strange on the floor.",
            GENERIC = "Maybe it is broken.",
        },

        WALL_STONE_2 = "Old and smooth.",
        WALL_RUINS_2 = "Boring wall.",

        REFINED_DUST = "Little cubes, I am not sure if this is food?",
        DUSTMERINGUE = "It is crunchy. Yes, I ate one.",

        SHROOMCAKE = "It is for me! And no one else.",

        NIGHTMAREGROWTH = "I-I do not want to get near it.",

        TURFCRAFTINGSTATION = "Grinding up rocks into nice smooth flatness.",

        MOON_ALTAR_LINK = "",

        -- FARMING
        COMPOSTINGBIN =
        {
            GENERIC = "The sludge machine.",
            WET = "Very slimy.",
            DRY = "coarse and smelly.",
            BALANCED = "very good sludge consistency.",
            BURNT = "No more sludge.",
        },
        COMPOST = "Throw it with the rest of the loot.",
        SOIL_AMENDER =
		{
			GENERIC = "It is a drink?",
			STALE = "Its smells make my nose twitch.",
			SPOILED = "Bleugh this smell I do not like.",
		},

		SOIL_AMENDER_FERMENTED = "Eurgh... Not even I want to drink that",

        WATERINGCAN =
        {
            GENERIC = "I could use a drink.",
            EMPTY = "Maybe I should fill it with rat spit.",
        },
        PREMIUMWATERINGCAN =
        {
            GENERIC = "I can water things with bird spit.",
            EMPTY = "No more spit.",
        },

		FARM_PLOW = "It churns the soil and the worms.",
		FARM_PLOW_ITEM = "Better not put it over any Rat-tunnels.",
		FARM_HOE = "If you wanted to dig a hole, you could've asked.",
		GOLDEN_FARM_HOE = "I see how it is... My claws aren't good enough?",
		NUTRIENTSGOGGLESHAT = "I did not know I needed a fresh pair of eyes.",
		PLANTREGISTRYHAT = "I thought my eyes could see dirt good. I was wrong.",

        FARM_SOIL_DEBRIS = "I will have a rat take it away.",

		FIRENETTLES = "You had given me blisters before.",
		FORGETMELOTS = "When did you get there?",
		SWEETTEA = "It is hot leaf water.",
		TILLWEED = "It looks tasty.",
		TILLWEEDSALVE = "It is good for rubbing into my fur.",
        WEED_IVY = "Hey, I do not think you were planted there.",
        IVY_SNARE = "SQUEAK!",

		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "How much do I weigh?",
			HAS_ITEM = "Weight: {weight}\nHarvested on day: {day}\nIt is a good size.",
			HAS_ITEM_HEAVY = "Weight: {weight}\nHarvested on day: {day}\nI could feed every rat with this.",
            HAS_ITEM_LIGHT = "Stupid machine is broken.",
			BURNING = "I do not think we can weigh fire.",
			BURNT = "I do not think we can weigh fire.",
        },

        CARROT_OVERSIZED = "I did not know they came in new colours.",
        CORN_OVERSIZED = "I would need many rats to carry it.",
        PUMPKIN_OVERSIZED = "I should hollow it out and live in it.",
        EGGPLANT_OVERSIZED = "It is much more purple now.",
        DURIAN_OVERSIZED = "It REEKS. How Wonderful!",
        POMEGRANATE_OVERSIZED = "It is tougher to chew through now.",
        DRAGONFRUIT_OVERSIZED = "I will hoard it, and amass a big pile.",
        WATERMELON_OVERSIZED = "The seeds must be bigger than a whole rat!",
        TOMATO_OVERSIZED = "I don't think that will fit in my home.",
        POTATO_OVERSIZED = "It is like a big rock.",
        ASPARAGUS_OVERSIZED = "It is like a tree, but no roots.",
        ONION_OVERSIZED = "I cannot wait to sink my teeth into it.",
        GARLIC_OVERSIZED = "What a wonderful smell!",
        PEPPER_OVERSIZED = "I wonder if eating it will make me catch on fire.",

        VEGGIE_OVERSIZED_ROTTEN = "Mmm I will take that some where safe.",

		FARM_PLANT =
		{
			GENERIC = "That is some stupid plant.",
			SEED = "They grow. I think.",
			GROWING = "It is still too small to eat.",
			FULL = "I want to eat it now.",
			ROTTEN = "It smells interesting now.",
			FULL_OVERSIZED = "",
			ROTTEN_OVERSIZED = "It is fermenting, it will be much more delicious soon.",
			FULL_WEED = "",

			BURNING = "Smells like burning food!",
		},

        FRUITFLY = "I will eat you!",
        LORDFRUITFLY = "Stupid bug, go back in the soil.",
        FRIENDLYFRUITFLY = "Yes, do all the boring work for me.",
        FRUITFLYFRUIT = "It is very squishy.",

        SEEDPOUCH = "I needed a place to store my snacks.",

		-- Crow Carnival
		CARNIVAL_HOST = "Mr.Beaks",
		CARNIVAL_CROWKID = "Ech... little creature..",
		CARNIVAL_GAMETOKEN = "Not real loot...",
		CARNIVAL_PRIZETICKET =
		{
			GENERIC = "It's worth something?",
			GENERIC_SMALLSTACK = "It's worth something?",
			GENERIC_LARGESTACK = "It's worth something?",
		},

		CARNIVALGAME_FEEDCHICKS_NEST = "Hidden trap.",
		CARNIVALGAME_FEEDCHICKS_STATION =
		{
			GENERIC = "You can not have my treasure!",
			PLAYING = "I am running around like a headless chicken!",
		},
		CARNIVALGAME_FEEDCHICKS_KIT = "Fun and games until I eat the worms.",
		CARNIVALGAME_FEEDCHICKS_FOOD = "Wait... Fake worms?",

		CARNIVALGAME_MEMORY_KIT = "Pointless.",
		CARNIVALGAME_MEMORY_STATION =
		{
			GENERIC = "It is too hard.",
			PLAYING = "",
		},
		CARNIVALGAME_MEMORY_CARD =
		{
			GENERIC = "It's a little trapdoor.",
			PLAYING = "Is this the right one?",
		},

		CARNIVALGAME_HERDING_KIT = "Pointless.",
		CARNIVALGAME_HERDING_STATION =
		{
			GENERIC = "It won't let me play until I give it something shiny.",
			PLAYING = "Those eggs are looking a little runny.",
		},
		CARNIVALGAME_HERDING_CHICK = "Come back here!",
		
			CARNIVALGAME_SHOOTING_KIT = "This really is a pop-up carnival.",
		CARNIVALGAME_SHOOTING_STATION =
		{
			GENERIC = "It won't let me play until I give it something shiny.",
			PLAYING = "I could calculate the trajectory, but it involves a lot of complicated numbers and squiggles.",
		},
		CARNIVALGAME_SHOOTING_TARGET =
		{
			GENERIC = "It's a little trapdoor.",
			PLAYING = "That target's really starting to bug me.",
		},

		CARNIVALGAME_SHOOTING_BUTTON =
		{
			GENERIC = "It won't let me play until I give it something shiny.",
			PLAYING = "Science compels me to press that big shiny button!",
		},
		
			CARNIVALGAME_WHEELSPIN_KIT = "This really is a pop-up carnival.",
		CARNIVALGAME_WHEELSPIN_STATION =
		{
			GENERIC = "I like spinning, let me play!",
			PLAYING = "Yes, the spinning....",
		},

		CARNIVALGAME_PUCKDROP_KIT = "This really is a pop-up carnival.",
		CARNIVALGAME_PUCKDROP_STATION =
		{
			GENERIC = "It won't let me play until I give it something shiny.",
			PLAYING = "Physics don't always work the same way twice.",
		},

		CARNIVAL_PRIZEBOOTH_KIT = "The real prize is the booth we made along the way.",
		CARNIVAL_PRIZEBOOTH =
		{
			GENERIC = "If There was no one around, I would just take everything.",
		},

		CARNIVALCANNON_KIT = "I should hide it",
		CARNIVALCANNON =
		{
			GENERIC = "I do not like this",
			COOLDOWN = "At least it is over now.",
		},

		CARNIVAL_PLAZA_KIT = "It will only bring noisy obnoxius birds here.",
		CARNIVAL_PLAZA =
		{
			GENERIC = "This tree offends my eyes.",
			LEVEL_2 = "",
			LEVEL_3 = "",
		},

		CARNIVALDECOR_EGGRIDE_KIT = "I like things that spin.",
		CARNIVALDECOR_EGGRIDE = "Maybe I could put a ratling in it.",

		CARNIVALDECOR_LAMP_KIT = "Only some light work left to do.",
		CARNIVALDECOR_LAMP = "It's powered by whimsy.",
		CARNIVALDECOR_PLANT_KIT = "Maybe it's a boxwood?",
		CARNIVALDECOR_PLANT = "Either it's small, or I'm gigantic.",

		CARNIVALDECOR_FIGURE =
		{
			RARE = "",
			UNCOMMON = "",
			GENERIC = "",
		},
		CARNIVALDECOR_FIGURE_KIT = "",

        CARNIVAL_BALL = "Ha ha ha, Yes, I like throwing this.", --unimplemented
		CARNIVAL_SEEDPACKET = "Little bits inside for me.",
		CARNIVALFOOD_CORNTEA = "It is nice tasting, very sweet and corny.",

        CARNIVAL_VEST_A = "I have always wanted to wear rags around my neck!",
        CARNIVAL_VEST_B = "I am not a bird, but it does not look bad.",
        CARNIVAL_VEST_C = "It is a nice shade.",

        -- YOTB
        YOTB_SEWINGMACHINE = "I do not understand how you hold the little needle and string.",
        YOTB_SEWINGMACHINE_ITEM = "It is making stuff you wear I think.",
        YOTB_STAGE = "Strange, I never see him enter or leave...",
        YOTB_POST =  "This contest is going to go off without a hitch! Well, figuratively speaking.",
        YOTB_STAGE_ITEM = "It looks like a bit of building is in order.",
        YOTB_POST_ITEM =  "I'd better get that set up.",


        YOTB_PATTERN_FRAGMENT_1 = "Yes, It goes with other patterns.",
        YOTB_PATTERN_FRAGMENT_2 = "Yes, It goes with other patterns.",
        YOTB_PATTERN_FRAGMENT_3 = "Yes, It goes with other patterns.",

        YOTB_BEEFALO_DOLL_WAR = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_DOLL = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_FESTIVE = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_NATURE = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_ROBOT = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_ICE = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_FORMAL = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_VICTORIAN = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },
        YOTB_BEEFALO_DOLL_BEAST = {
            GENERIC = "I do not like playing dress up.",
            YOTB = "We're being rated? on what? ugliness. Haha.",
        },

        WAR_BLUEPRINT = "RAGH! Scary! This is perfect!",
        DOLL_BLUEPRINT = "I do not want a doll! That is not scary.",
        FESTIVE_BLUEPRINT = "I want something hideous, this will not do.",
        ROBOT_BLUEPRINT = "Maybe Its gears will turn things to rubble.",
        NATURE_BLUEPRINT = "Blegh, Too natural.",
        FORMAL_BLUEPRINT = "Too nice looking, I want a monster.",
        VICTORIAN_BLUEPRINT = "Too old.",
        ICE_BLUEPRINT = "It looks too cold.",
        BEAST_BLUEPRINT = "A beastly beast for me to trample and terrorize with!",

        BEEF_BELL = "A bell for beasts.",

		-- YOT Catcoon
		KITCOONDEN = 
		{
			GENERIC = "I do not like... Cats...",
            BURNT = "ha ha!",
			PLAYING_HIDEANDSEEK = "They should stay hidden, so I do not have to see them.",
			PLAYING_HIDEANDSEEK_TIME_ALMOST_UP = "I hope they do not get found...",
		},

		KITCOONDEN_KIT = "I will throw it into the ocean now.",

		TICOON = 
		{
			GENERIC = "He looks like he knows what he's doing!",
			ABANDONED = "I'm sure I can find them on my own.",
			SUCCESS = "",
			LOST_TRACK = "Someone else found them first.",
			NEARBY = "I hear something close.",
			TRACKING = "Go run off.",
			TRACKING_NOT_MINE = "He's leading the way for someone else.",
			NOTHING_TO_TRACK = "It doesn't look like there's anything left to find.",
			TARGET_TOO_FAR_AWAY = "They might be too far away for him to sniff out.",
		},
		
		YOT_CATCOONSHRINE =
        {
            GENERIC = "An alter for wretched things.",
            EMPTY = "An alter for wretched things.",
            BURNT = "You got what you deserve Haha!",
        },

		KITCOON_FOREST = "AH Get away from me you little monster!",
		KITCOON_SAVANNA = "Stop following me, I am very uncomfortable.",
		KITCOON_MARSH = "AH Get away from me you little monster!",
		KITCOON_DECIDUOUS = "Stop following me, I am very uncomfortable.",
		KITCOON_GRASS = "Stop following me, I am very uncomfortable.",
		KITCOON_ROCKY = "I do not like you... Why are you here.",
		KITCOON_DESERT = "I do not like you... Why are you here.",
		KITCOON_MOON = "AH Get away from me you little monster!",
		KITCOON_YOT = "I do not like you... Why are you here.",

        -- Moon Storm
        ALTERGUARDIAN_PHASE1 = {
            GENERIC = "AH! Why is the moon angry at me! What did I do!",
            DEAD = "You are nothing but rubble now!",
        },
        ALTERGUARDIAN_PHASE2 = {
            GENERIC = "You are back!? It wasn't me who killed you!",
            DEAD = "I do not trust that you are dead...",
        },
        ALTERGUARDIAN_PHASE2SPIKE = "AH! I will not be stabbed!",
		
        ALTERGUARDIAN_PHASE3 = "Oh no! It's floating, that is not good...",
        ALTERGUARDIAN_PHASE3TRAP = "Stop throwing these at me I do not want them!",
        ALTERGUARDIAN_PHASE3DEADORB = "That is nothing, I do not want that.",
        ALTERGUARDIAN_PHASE3DEAD = "Haha, You are nothing but rubble now!",

        ALTERGUARDIANHAT = "Oooo spinning, spinning...",
        ALTERGUARDIANHATSHARD = "A bit that is no longer spinning.",

        MOONSTORM_GLASS = {
            GENERIC = "Maybe I should steal it.",
            INFUSED = "It is buzzing, I should steal it!"
        },

        MOONSTORM_STATIC = "Keep it inside!",
        MOONSTORM_STATIC_ITEM = "I have contained it. It is mine now, right?",
        MOONSTORM_SPARK = "Huh what is that?", --moongleam

        BIRD_MUTANT = "It is ugly. Very ugly.",
        BIRD_MUTANT_SPITTER = "Do not spit at me, you stupid ugly bird!",

        WAGSTAFF_NPC = "Huh? Who is there?",
        ALTERGUARDIAN_CONTAINED = "Good! Lock it away!",

        WAGSTAFF_TOOL_1 = "It is MINE! I found it.",
        WAGSTAFF_TOOL_2 = "Very interesting, it is mine now.",
        WAGSTAFF_TOOL_3 = "I am keeping this.",
        WAGSTAFF_TOOL_4 = "I think I've seen one of these before.",
        WAGSTAFF_TOOL_5 = "Yes, I have one already.",

        MOONSTORM_GOGGLESHAT = "I am learning food is used for more than eating.",

        MOON_DEVICE = {
            GENERIC = "Oh, Is that how that works?",
            CONSTRUCTION1 = "It looks broken.",
            CONSTRUCTION2 = "This machine is still broken, isn't it.",
        },

		-- Wanda
        POCKETWATCH_HEAL = {
			GENERIC = "I have heard this tick-tock tick-tock before? But I can not remember.",
			RECHARGING = "I have heard this tick-tock tick-tock before? But I can not remember.",
		},

        POCKETWATCH_REVIVE = {
			GENERIC = "I have heard this tick-tock tick-tock before? But I can not remember.",
			RECHARGING = "I have heard this tick-tock tick-tock before? But I can not remember.",
		},

        POCKETWATCH_WARP = {
			GENERIC = "I have heard this tick-tock tick-tock before? But I can not remember.",
			RECHARGING = "I have heard this tick-tock tick-tock before? But I can not remember.",
		},

        POCKETWATCH_RECALL = {
			GENERIC = "I have heard this tick-tock tick-tock before? But I can not remember.",
			RECHARGING = "I have heard this tick-tock tick-tock before? But I can not remember.",
			UNMARKED = "only_used_by_wanda",
			MARKED_SAMESHARD = "only_used_by_wanda",
			MARKED_DIFFERENTSHARD = "only_used_by_wanda",
		},

        POCKETWATCH_PORTAL = {
			GENERIC = "I have heard this tick-tock tick-tock before? But I can not remember.",
			RECHARGING = "I have heard this tick-tock tick-tock before? But I can not remember.",
			UNMARKED = "only_used_by_wanda unmarked",
			MARKED_SAMESHARD = "only_used_by_wanda same shard",
			MARKED_DIFFERENTSHARD = "only_used_by_wanda other shard",
		},

        POCKETWATCH_WEAPON = {
			GENERIC = "Looks very precious, I must keep it.",
			DEPLETED = "only_used_by_wanda",
		},

        POCKETWATCH_PARTS = "Looks very precious, I must keep them.",
        POCKETWATCH_DISMANTLER = "teeth picks.",

        POCKETWATCH_PORTAL_ENTRANCE = 
		{
			GENERIC = "I think I might walk.",
			DIFFERENTSHARD = "I think I might walk.",
		},
        POCKETWATCH_PORTAL_EXIT = "Some person will fall and break something.",

        -- Waterlog
        WATERTREE_PILLAR = "I did not know they can grow in salt water.",
        OCEANTREE = "I did not know they can grow in salt water.",
        OCEANTREENUT = "Very Nutty, maybe I can eat it.",
        WATERTREE_ROOT = "Reaching out",

        OCEANTREE_PILLAR = "I did not know they can grow in salt water.",
        
        OCEANVINE = "Dangling right in front of me! I must have it.",
        FIG = "A little crunchy and gooey.",
        FIG_COOKED = "It is even better heated.",

        SPIDER_WATER = "Big deal, rats swim too.",
        MUTATOR_WATER = "These cookies are very tasty.",
        OCEANVINE_COCOON = "",
        OCEANVINE_COCOON_BURNT = "",

        GRASSGATOR = "Oh, you are alive, I thought you were a swamp lump.",

        TREEGROWTHSOLUTION = "This slime jelly is very tasty.",

        FIGATONI = "Squishy, but good.",
        FIGKABAB = "Cripsy sticky figs.",
        KOALEFIG_TRUNK = "Ack! The nose slime was the most delicous part!",
        FROGNEWTON = "I love cruhsing animals into food haha!",

        -- The Terrorarium
        TERRARIUM = {
            GENERIC = "It is like another world inside of it.",
            CRIMSON = "Meat world now.",
            ENABLED = "Oooo, very nice. I might go blind staring at it.",
			WAITING_FOR_DARK = "Is it broken now?",
			COOLDOWN = "It is over now.",
			SPAWN_DISABLED = "I think it is off, not broken... Maybe.",
        },

        -- Wolfgang
        MIGHTY_GYM = 
        {
            GENERIC = "Why would you want to carry something without taking it?",
            BURNT = "It was stupid anyways.",
        },

        DUMBBELL = "If I am going to carry something I am going to steal it.",
        DUMBBELL_GOLDEN = "Everything has the same value to me.",
		DUMBBELL_MARBLE = "It would crush my family if they tried to take it!",
        DUMBBELL_GEM = "It is too heavy to steal.",
        POTATOSACK = "I don't smell any food in there.",


        TERRARIUMCHEST = 
		{
			GENERIC = "An evil Chest, not from here.",
			BURNT = "Oh well, it is gone forever.",
			SHIMMER = "Something is not right...",
		},

		EYEMASKHAT = "This is safe to wear?",

        EYEOFTERROR = "I do not like being stared at!",
        EYEOFTERROR_MINI = "I will put you in the ground, Ugly.",
        EYEOFTERROR_MINI_GROUNDED = "Go back in I don't want you out here!",

        FROZENBANANADAIQUIRI = "This yellow paste is quite good.",
        BUNNYSTEW = "Ha ha ha, this is what you get!",
        MILKYWHITES = "Eyes are most tasty when slimey.",

        CRITTER_EYEOFTERROR = "You seem silly.",

        SHIELDOFTERROR ="Bash and bite my enemies.",
        TWINOFTERROR1 = "AAAHH TWO OF THEM!!!",
        TWINOFTERROR2 = "AAAHH TWO OF THEM!!!",

        -- Year of the Catcoon
        CATTOY_MOUSE = "I will NOT be treated like this!!!",
        KITCOON_NAMETAG = "I should name it, Ugly!",

		KITCOONDECOR1 =
        {
            GENERIC = "Stupid Kats think it is real Haha!",
            BURNT = "Gone for good!",
        },
		KITCOONDECOR2 =
        {
            GENERIC = "I do not want to waste my time with them.",
            BURNT = "Gone for good!",
        },

		KITCOONDECOR1_KIT = "Where are the instrcutions for it?",
		KITCOONDECOR2_KIT = "I have to set it up myself?",
	
        -- WX78
        WX78MODULE_MAXHEALTH = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MAXSANITY1 = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MAXSANITY = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MOVESPEED = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MOVESPEED2 = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_HEAT = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_NIGHTVISION = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_COLD = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_TASER = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_LIGHT = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MAXHUNGER1 = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MAXHUNGER = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MUSIC = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_BEE = "They are good to chew on, and there are so many to collect!",
        WX78MODULE_MAXHEALTH2 = "They are good to chew on, and there are so many to collect!",

        WX78_SCANNER = 
        {
            GENERIC ="A little propeller thing. At least it quiet.",
            HUNTING = "It is chasing things.",
            SCANNING = "It is looking for something?",
        },

        WX78_SCANNER_ITEM = "It is my machine now.",
        WX78_SCANNER_SUCCEEDED = "It did the looking, and now it is done.",

        WX78_MODULEREMOVER = "I could use it to steal teeth.",

        SCANDATA = "Useless paper with holes.",
		
		-- QOL 2022
		JUSTEGGS = "I would be better in my mouth now.",
		VEGGIEOMLET = "Not gooey, but I still find it yummy.",
		TALLEGGS = "Crunchy and eggy, yes, most delicious eggs!",
		BEEFALOFEED = "They are twigs, I should just chew on it.",
		BEEFALOTREAT = "It looks good, why should I let those beasts eat it.",
	
	    -- Pirates
        BOAT_ROTATOR = "It will make me sick if it keeps spinning.",
        BOAT_ROTATOR_KIT = "I already do not like boats. This only makes it worse.",
        BOAT_BUMPER_KELP = "What a waste of delicious sea food.",
        BOAT_BUMPER_KELP_KIT = "What a waste of delicious sea food.",
        BOAT_BUMPER_SHELL = "Clinky clunky bumpy thing.",
        BOAT_BUMPER_SHELL_KIT = "I do not like the noise when it hits something.",
        BOAT_CANNON = {
            GENERIC = "It is waiting for me he he he.",
            AMMOLOADED = "Fire! Fire it!",
        },
        BOAT_CANNON_KIT = "With this I can throw rocks that are too big normally.",
        CANNONBALL_ROCK_ITEM = "It is like throwing big rocks. Ones that explode!",

        OCEAN_TRAWLER = {
            GENERIC = "It is a floaty net thing.",
            LOWERED = "Something stupid will get trapped for me.",
            CAUGHT = "Hahaha! There is a stupid fish in there!",
            ESCAPED = "It is a worthless net.",
            FIXED = "I have re-netted it.",
        },
        OCEAN_TRAWLER_KIT = "I could plop it down, and it will steal fish for me.",

        BOAT_MAGNET =
        {
            GENERIC = "I thought these were attractive. It looks very ugly.",
            ACTIVATED = "Why is it blinking now?",
        },
        BOAT_MAGNET_KIT = "Maybe I can collect many coins from the ocean with it.",

        BOAT_MAGNET_BEACON =
        {
            GENERIC = "I thought these were attractive. It looks very ugly.",
            ACTIVATED = "Why is it blinking now?",
        },
        DOCK_KIT = "At least It connects to the land.",
        DOCK_WOODPOSTS_ITEM = "It is wood.",

        MONKEYHUT = "I would not like to live in a tree.",
        POWDER_MONKEY = "Hey! Do not steal my stolen goods!",
        PRIME_MATE = "Hey, Give me that hat!",
		LIGHTCRAB = "If I catch it, I will eat it.",
        CUTLESS = "It is not very sharp but good for slapping things.",
        CURSED_MONKEY_TOKEN = "Stupid Monkeys, these are mine now!",
        OAR_MONKEY = "See, these are very good for whacking.",
        BANANABUSH = "A yellow shrub.",
        DUG_BANANABUSH = "It is mine now, I want this shrub.",
        PALMCONETREE = "I have never seen leaves that are too big like this.",
        PALMCONE_SEED = "It smells very different, from another land.",
        PALMCONE_SAPLING = "Small and stupid.",
        PALMCONE_SCALE = "Trees have scales now?",
        MONKEYTAIL = "It is not a real tail.",
        DUG_MONKEYTAIL = "It is just grass, with a little brown part...",

        MONKEY_MEDIUMHAT = "I really am the pi-RAT now, haha.. ha...",
        MONKEY_SMALLHAT = "I do not like wrapping me ears up.",
        POLLY_ROGERSHAT = "This hat makes me look important, so it is mine.",
        POLLY_ROGERS = "You like stealing, you are like a rat with wings.",

        MONKEYISLAND_PORTAL = "Another hole.",
        MONKEYISLAND_PORTAL_DEBRIS = "A chunk of... Something stupid.",
        MONKEYQUEEN = "You smell like rotten bananas and curses.",
        MONKEYPILLAR = "It is very ugly, I have seen better ones.",
        PIRATE_FLAG_POLE = "Raggedy rags",

        BLACKFLAG = "Raggedy rags.",
        PIRATE_STASH = "Hehehe, I will steal their treasure.",
        STASH_MAP = "This is why I never write down my treasures.",


        BANANAJUICE = "It is slimey mushy juice.",
		
		FENCE_ROTATOR = "Springy poker, I will use this.",
		
		CHARLIE_STAGE_POST = "This was not here before, I think?",
        CHARLIE_LECTURN = "Scritches and scratches, They are fancy.",

        CHARLIE_HECKLER = "Get down here!",

        PLAYBILL_THE_DOLL = "I do not like you, fake person.",
        STATUEHARP_HEDGESPAWNER = "they are dead.",
        HEDGEHOUND = "AH! You are imitation bush!",
        HEDGEHOUND_BUSH = "There is something for me?",

        MASK_DOLLHAT = ".",
        MASK_DOLLBROKENHAT = "It is broken.",
        MASK_DOLLREPAIREDHAT = "It is more broken.",
        MASK_BLACKSMITHHAT = "I",
        MASK_MIRRORHAT = "",
        MASK_QUEENHAT = "",
        MASK_KINGHAT = ".",
        MASK_TREEHAT = "I do not want to be a pine head.",
        MASK_FOOLHAT = ".",

        COSTUME_DOLL_BODY = "These are clothes for.",
        COSTUME_QUEEN_BODY = "",
        COSTUME_KING_BODY = "",
        COSTUME_BLACKSMITH_BODY = "",
        COSTUME_MIRROR_BODY = "",
        COSTUME_TREE_BODY = "It looks like a tree. Why?",
        COSTUME_FOOL_BODY = "",

        STAGEUSHER =
        {
            STANDING = "J?",
            SITTING = "",
        },
        SEWING_MANNEQUIN =
        {
            GENERIC = "This is a fake person, it is weird.",
            BURNT = "Now it is dead.",
        },
    },

    DESCRIBE_GENERIC = "Never have I seen a.... This...",
    DESCRIBE_TOODARK = "Aaaah! What? I cannot see?",
    DESCRIBE_SMOLDERING = "Oh no! It is smoking!",

    DESCRIBE_PLANTHAPPY = "The plant is smiling I think.",
    DESCRIBE_PLANTVERYSTRESSED = "This plant is very, very, mad for some reason.",
    DESCRIBE_PLANTSTRESSED = "It is upset I think?.",
    DESCRIBE_PLANTSTRESSORKILLJOYS = "The Weeds are bullying it.",
    DESCRIBE_PLANTSTRESSORFAMILY = "It is lonely, like me without my family.",
    DESCRIBE_PLANTSTRESSOROVERCROWDING = "They're so smushed together.",
    DESCRIBE_PLANTSTRESSORSEASON = "The elements are killing it.",
    DESCRIBE_PLANTSTRESSORMOISTURE = "Hmmmm it is dry as a bone.",
    DESCRIBE_PLANTSTRESSORNUTRIENTS = "He is not eating right.",
    DESCRIBE_PLANTSTRESSORHAPPINESS = "I must talk with it? That is stupid.",

    EAT_FOOD =
    {
        TALLBIRDEGG_CRACKED = "Mmm. Beaky.",
		WINTERSFEASTFUEL = "Reminds me of happy times.",
    },
}

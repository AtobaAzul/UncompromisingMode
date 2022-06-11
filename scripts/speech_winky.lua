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
            HASPET = "I have a creature, I don't need more.",
			TICOON = "They might KILL me if get another.",
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
        	WRONGKEY = "I think I have the right one... Somewhere",
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
			EMPTY_CATCOONDEN = "Someone Stole it before I could!",
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
            GHOSTHEART = "You want it! Don't you!",
            NOTGEM = "I can keep smashing it! Until it works.",
            WRONGGEM = "Bad.",
            NOTSTAFF = "It's not quite the right shape.",
            MUSHROOMFARM_NEEDSSHROOM = "A mushroom would probably be of more use.",
            MUSHROOMFARM_NEEDSLOG = "A living log would probably be of more use.",
            MUSHROOMFARM_NOMOONALLOWED = "",
            SLOTFULL = "No room. I should make some.",
            FOODFULL = "I want what is in there!.",
            NOTDISH = "What? it's food to me.",
            DUPLICATE = "I knew that!",
            NOTSCULPTABLE = "I can sculpt anything with mud!",
            NOTATRIUMKEY = "Fit, Stupid thing!",
            CANTSHADOWREVIVE = "Work already!",
            WRONGSHADOWFORM = "WHO did this wrong!.",
            NOMOON = "That dumb Round thing at night should be out.",
			PIGKINGGAME_MESSY = "I like things how they are!",
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
            SLEEPING = "Nice pockets. Heh.",
            BUSY = "Hurry up, Stupid.",
        },
        GIVEALLTOPLAYER =
        {
            FULL = "Give me your things!",
            DEAD = "Oh well. It is mine now.",
            SLEEPING = "Don't wake up. This is mine.",
            BUSY = "Hey, you don't want this, right?",
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
            NOHEALTH = "No, no, I don't feel right...",
        },
        MOUNT =
        {
            TARGETINCOMBAT = "",
            INUSE = "",
        },
        SADDLE =
        {
            TARGETINCOMBAT = "",
        },
        TEACH =
        {
            --Recipes/Teacher
            KNOWN = "I already know that one.",
            CANTLEARN = "I can't learn that one.",

            --MapRecorder/MapExplorer
            WRONGWORLD = "This map was made for some other place.",

			--MapSpotRevealer/messagebottle
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "I can't make anything out in this lighting!",--Likely trying to read messagebottle treasure map in caves
        },
        WRAPBUNDLE =
        {
            EMPTY = "I Must fill it with treats.",
        },
        PICKUP =
        {
			RESTRICTION = "I'm not skilled enough to use that.",
			INUSE = "Science says I have to wait my turn.",
            NOTMINE_SPIDER = "only_used_by_webber",
            NOTMINE_YOTC =
            {
                "You're not my carrat.",
                "OW, it bit me!",
            },
			NO_HEAVY_LIFTING = "only_used_by_wanda",
        },
        SLAUGHTER =
        {
            TOOFAR = "It got away.",
        },
        REPLATE =
        {
            MISMATCH = "It needs another type of dish.",
            SAMEDISH = "I only need to use one dish.",
        },
        SAIL =
        {
        	REPAIR = "Not Broken.",
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
            GLASSED = ".",
            ALREADY_BOMBED = "",
        },
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "",
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
            GENERIC = "I have nothing left to learn.",
            FERTILIZER = "I'd rather not know anything further.",
        },
        FILL_OCEAN =
        {
            UNSUITABLE_FOR_PLANTS = ".",
        },
        POUR_WATER =
        {
            OUT_OF_WATER = "Where is water?",
        },
        POUR_WATER_GROUNDTILE =
        {
            OUT_OF_WATER = "Where is water?",
        },
        USEITEMON =
        {
            --GENERIC = "I can't use this on that!",

            --construction is PREFABNAME_REASON
            BEEF_BELL_INVALID_TARGET = "That is stupid!",
            BEEF_BELL_ALREADY_USED = "It is not mine for some reason.",
            BEEF_BELL_HAS_BEEF_ALREADY = "Only one can fit.",
        },
        HITCHUP =
        {
            NEEDBEEF = "If I had a bell I could befriend a beefalo.",
            NEEDBEEF_CLOSER = "My beefalo buddy is too far away.",
            BEEF_HITCHED = "My beefalo is already hitched up.",
            INMOOD = "My beefalo seems to be too lively.",
        },
        MARK =
        {
            ALREADY_MARKED = "I've already made my pick.",
            NOT_PARTICIPANT = "I've got no steak in this contest.",
        },
        YOTB_STARTCONTEST =
        {
            DOESNTWORK = "I guess they don't support the arts here.",
            ALREADYACTIVE = "He must be busy with another contest somewhere.",
        },
        YOTB_UNLOCKSKIN =
        {
            ALREADYKNOWN = "I'm seeing a familiar pattern... I've learned this already!",
        },
        CARNIVALGAME_FEED =
        {
            TOO_LATE = "I need to be quicker!",
        },
        HERD_FOLLOWERS =
        {
            WEBBERONLY = "They won't listen to me, but they might listen to Webber.",
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

	ACTIONFAIL_GENERIC = "Nope.",
	ANNOUNCE_BOAT_LEAK = "Plug it!!!",
	ANNOUNCE_BOAT_SINK = "No, No wait, I can't swim!",
	ANNOUNCE_DIG_DISEASE_WARNING = "It looks better already.", --removed
	ANNOUNCE_PICK_DISEASE_WARNING = "Uh, is it supposed to smell like that?", --removed
	ANNOUNCE_ADVENTUREFAIL = "",
    ANNOUNCE_MOUNT_LOWHEALTH = "",

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
	ANNOUNCE_CHARLIE = "That presence... it's familiar! Hello?",
	ANNOUNCE_CHARLIE_ATTACK = "OW! Something bit me!",
	ANNOUNCE_CHARLIE_MISSED = "only_used_by_winona", --winona specific
	ANNOUNCE_COLD = "Ch-ch-ch",
	ANNOUNCE_HOT = "Need... ice... or... shade!",
	ANNOUNCE_CRAFTING_FAIL = "I'm missing a couple key ingredients.",
	ANNOUNCE_DEERCLOPS = "That sounded big!",
	ANNOUNCE_CAVEIN = "The ceiling is destabilizing!",
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"The ground is destabilizing!",
		"A tremor!",
		"Terrible terralogical waves!",
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "Allow me to pay tribute.",
        "A tribute for you, great Antlion.",
        "That'll appease it, for now...",
	},
	ANNOUNCE_SACREDCHEST_YES = "I guess I'm worthy.",
	ANNOUNCE_SACREDCHEST_NO = "It didn't like that.",
    ANNOUNCE_DUSK = "It's getting late. It will be dark soon.",

    --wx-78 specific
    ANNOUNCE_CHARGE = "only_used_by_wx78",
	ANNOUNCE_DISCHARGE = "only_used_by_wx78",

	ANNOUNCE_EAT =
	{
		GENERIC = "",
		PAINFUL = "I don't feel so good.",
		SPOILED = "",
		STALE = "I.",
		INVALID = "",
        YUCKY = "I refuse to eat it!",

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
        "My Rats... Should be... doing this!",
        "Is this... messing up my hair?",
        "Huff... Huff...!",
        "Huff...",
        "This is the worst... experiment...",
    },
    ANNOUNCE_ATRIUM_DESTABILIZING =
    {
		"I think it's time to leave!",
		"What's that?!",
		"It's not safe here.",
	},
    ANNOUNCE_RUINS_RESET = "Evil has returned! AHAHA!",
    ANNOUNCE_SNARED = "Let me go, Stupid!",
    ANNOUNCE_SNARED_IVY = "This is not Funny.",
    ANNOUNCE_REPELLED = "Keep Hitting.",
	ANNOUNCE_ENTER_DARK = "",
	ANNOUNCE_ENTER_LIGHT = "",
	ANNOUNCE_FREEDOM = "I'm free! I'm finally free!",
	ANNOUNCE_HIGHRESEARCH = "I feel so smart now!",
	ANNOUNCE_HOUNDS = "They're coming...",
	ANNOUNCE_WORMS = "I can smell them coming...",
	ANNOUNCE_HUNGRY = "How can there be nothing to eat.",
	ANNOUNCE_HUNT_BEAST_NEARBY = "I tracked you down, stupid animal.",
	ANNOUNCE_HUNT_LOST_TRAIL = "Where did it go?",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "Stupid rain, Stupid animal",
	ANNOUNCE_INV_FULL = "I NEED ALL THIS.",
	ANNOUNCE_KNOCKEDOUT = "Ughhh. Where am I?",
	ANNOUNCE_LOWRESEARCH = "",
	ANNOUNCE_MOSQUITOS = "",
    ANNOUNCE_NOWARDROBEONFIRE = "",
    ANNOUNCE_NODANGERGIFT = "",
    ANNOUNCE_NOMOUNTEDGIFT = "",
	ANNOUNCE_NODANGERSLEEP = "",
	ANNOUNCE_NODAYSLEEP = "",
	ANNOUNCE_NODAYSLEEP_CAVE = "I'm not tired.",
	ANNOUNCE_NOHUNGERSLEEP = "!",
	ANNOUNCE_NOSLEEPONFIRE = ".",
	ANNOUNCE_NODANGERSIESTA = "I!",
	ANNOUNCE_NONIGHTSIESTA = ".",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "I.",
	ANNOUNCE_NOHUNGERSIESTA = "!",
	ANNOUNCE_NO_TRAP = "I did it!",
	ANNOUNCE_PECKED = "Stupid thing!",
	ANNOUNCE_QUAKE = "Something is crumbling.",
	ANNOUNCE_RESEARCH = "I think, this is good.",
	ANNOUNCE_SHELTER = "I would rather be in my hole.",
	ANNOUNCE_THORNS = "EEP.",
	ANNOUNCE_BURNT = "GAAAH.",
	ANNOUNCE_TORCH_OUT = "Huh, I thougt.. but..",
	ANNOUNCE_THURIBLE_OUT = ".",
	ANNOUNCE_FAN_OUT = ".",
    ANNOUNCE_COMPASS_OUT = "",
	ANNOUNCE_TRAP_WENT_OFF = "What?",
	ANNOUNCE_UNIMPLEMENTED = ".",
	ANNOUNCE_WORMHOLE = ".",
	ANNOUNCE_TOWNPORTALTELEPORT = "",
	ANNOUNCE_CANFIX = "\nMaybe I can stick more things on it!",
	ANNOUNCE_ACCOMPLISHMENT = "!",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "",
	ANNOUNCE_INSUFFICIENTFERTILIZER = "A",
	ANNOUNCE_TOOL_SLIP = "I dropped it on purpose.",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "Huh? what happened?",
	ANNOUNCE_TOADESCAPING = "It wants to go smell up somewhere else.",
	ANNOUNCE_TOADESCAPED = "He is quite fast...",


	ANNOUNCE_DAMP = "I am becoming damp.",
	ANNOUNCE_WET = "All this water is terrible!",
	ANNOUNCE_WETTER = "",
	ANNOUNCE_SOAKED = ".",

	ANNOUNCE_WASHED_ASHORE = "I'm wet, but alive.",

    ANNOUNCE_DESPAWN = "I-I Don't want to go yet!",
	ANNOUNCE_BECOMEGHOST = "oOooOooo!!",
	ANNOUNCE_GHOSTDRAIN = "All these ghosts are annoying.",
	ANNOUNCE_PETRIFED_TREES = "Did I just hear trees screaming?",
	ANNOUNCE_KLAUS_ENRAGE = "AH! Time to flee.",
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
    ANNOUNCE_SPOOKED = "Did you see that?!",
	ANNOUNCE_BRAVERY_POTION = "Those trees don't seem so spooky anymore.",
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
    ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "Why is the boat rocking!",

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
    QUAGMIRE_ANNOUNCE_MEALBURNT = "I made slime!",
    QUAGMIRE_ANNOUNCE_LOSE = "Uh this is not good...",
    QUAGMIRE_ANNOUNCE_WIN = "Time to leave!",

    ANNOUNCE_ROYALTY =
    {
        "Your majesty.",
        "Your stinkyness.",
        "My liege!",
    },

    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "I feel positively electric!",
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "Let me at 'em!",
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "I feel much safer now!",
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "Productivity intensifying!",
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "I feel as dry as one of Wickerbottom's lectures!",
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "I feel so refreshed, I'll never get tired again!",

    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "The electricity's gone, but the static clings.",
    ANNOUNCE_DETACH_BUFF_ATTACK            = "It seems my brawniness was short-lived.",
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "Well, that was nice while it lasted.",
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "Desire to procrastinate... creeping back...",
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "Looks like my dry spell is over.",
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "I'll... (yawn) never get... tired...",

	ANNOUNCE_OCEANFISHING_LINESNAP = "All my hard work, gone in a snap!",
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "Maybe reeling would help.",
	ANNOUNCE_OCEANFISHING_GOTAWAY = "It got away.",
	ANNOUNCE_OCEANFISHING_BADCAST = "My casting needs work...",
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE =
	{
		"Where are the fish?",
		"Maybe I should find a better fishing spot.",
		"I thought there were supposed to be plenty of fish in the sea!",
		"I could be doing so many more scientific things right now...",
	},

	ANNOUNCE_WEIGHT = "Weight: {weight}",
	ANNOUNCE_WEIGHT_HEAVY  = "Weight: {weight}\nI'm a fishing heavyweight!",

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

    ANNOUNCE_CARRAT_START_RACE = "",

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

    ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "My mind is expanding with new ancient knowledge!",
    ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "I already knew that.",
    ANNOUNCE_ARCHIVE_NO_POWER = "Maybe it needs more juice.",

    ANNOUNCE_PLANT_RESEARCHED =
    {
        "My knowledge about this plant is growing!",
    },

    ANNOUNCE_PLANT_RANDOMSEED = "Is it dead?",

    ANNOUNCE_FERTILIZER_RESEARCHED = "I never thought I'd be applying my scientific mind to... this.",

	ANNOUNCE_FIRENETTLE_TOXIN =
	{
		"Oooo... I am so warm...",
		"Ah! pricked",
	},
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "Note to self: no more experiments with Fire Nettle toxin.",

	ANNOUNCE_TALK_TO_PLANTS =
	{
        "Grow plant, grow!",
        "I always wanted a plant like you.",
		"Hello plant, I'm here for your daily dose of socializing!",
        "What a nice plant you are.",
        "Plant, you are such a good listener.",
	},

	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "3, 2, 1... Ready or not, here I come!",
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN = "Aww, they're playing hide and seek.",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND = 
	{
		"Found you!",
		"There you are.",
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
    ANNOUNCE_CALL_BEEF = "Come on over!",
    ANNOUNCE_CANTBUILDHERE_YOTB_POST = "The judge won't be able to see my beefalo from here.",
    ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "My mind has been filled with beefalo styling inspiration!",

    -- AE4AE
    ANNOUNCE_EYEOFTERROR_ARRIVE = "What is that- a giant floating eyeball?!",
    ANNOUNCE_EYEOFTERROR_FLYBACK = "Finally!",
    ANNOUNCE_EYEOFTERROR_FLYAWAY = "Get back here, I'm not finished with you yet!",

	BATTLECRY =
	{
		GENERIC = "RAaaaGh!",
		PIG = "Here piggy piggy!",
		PREY = "I will destroy you!",
		SPIDER = "I'm going to stomp you dead!",
		SPIDER_WARRIOR = "Better you than me!",
		DEER = "Die, doe!",
	},
	COMBAT_QUIT =
	{
		GENERIC = "I sure showed him!",
		PIG = "I'll let him go. This time.",
		PREY = "He's too fast!",
		SPIDER = "He's too gross, anyway.",
		SPIDER_WARRIOR = "Shoo, you nasty thing!",
	},

	DESCRIBE =
	{
		MULTIPLAYER_PORTAL = "This ought to be a scientific impossibility.",
        MULTIPLAYER_PORTAL_MOONROCK = "I'm sure there's some scientific explanation for this.",
        MOONROCKIDOL = "I only worship science.",
        CONSTRUCTION_PLANS = "Stuff for science!",

        ANTLION =
        {
            GENERIC = "It wants something from me.",
            VERYHAPPY = "I think we're on good terms.",
            UNHAPPY = "It looks mad.",
        },
        ANTLIONTRINKET = "Someone might be interested in this.",
        SANDSPIKE = "I could've been skewered!",
        SANDBLOCK = "It's so gritty!",
        GLASSSPIKE = "Memories of the time I wasn't skewered.",
        GLASSBLOCK = "That's science for you.",
        ABIGAIL_FLOWER =
        {
            GENERIC ="It's hauntingly beautiful.",
			LEVEL1 = "Do you need some alone time?",
			LEVEL2 = "I think she's starting to open up to us.",
			LEVEL3 = "Looks like someone's feeling especially spirited today!",

			-- deprecated
            LONG = "It hurts my soul to look at that thing.",
            MEDIUM = "It's giving me the creeps.",
            SOON = "Something is up with that flower!",
            HAUNTED_POCKET = "I don't think I should hang on to this.",
            HAUNTED_GROUND = "I'd die to find out what it does.",
        },

        BALLOONS_EMPTY = "It looks like clown currency.",
        BALLOON = "How are they floating?",
		BALLOONPARTY = "How did he get the smaller balloons inside?",
		BALLOONSPEED =
        {
            DEFLATED = "Now it's just another balloon.",
            GENERIC = "The hole in the center makes it more aerodynamic, that's just physics!",
        },
		BALLOONVEST = "If the bright colors don't attract some horrible creature, the squeaking will.",
		BALLOONHAT = "The static does terrible things to my hair.",

        BERNIE_INACTIVE =
        {
            BROKEN = "hah.",
            GENERIC = "Fuzzy. somewhat.",
        },

        BERNIE_ACTIVE = "How is he doing that?",
        BERNIE_BIG = "I will rip him apart if he turns on me.",

        BOOK_BIRDS = "I like the images.",
        BOOK_TENTACLES = "Paper in stacks.",
        BOOK_GARDENING = "Huh, I don't know what it means.",
		BOOK_SILVICULTURE = "Huh, I don't know what it means.",
		BOOK_HORTICULTURE = "Huh, I don't know what it means.",
        BOOK_SLEEP = "Paper in stacks.",
        BOOK_BRIMSTONE = "Yes, very good, I can't read.",

        PLAYER =
        {
            GENERIC = "Hello you nobody!",
            ATTACKER = "Aha! you are evil!",
            MURDERER = "I know you did it!",
            REVIVER = "You are nice, just don't get handsy.",
            GHOST = "%s could use a heart.",
            FIRESTARTER = "%s is causing chaos!",
        },
        WILSON =
        {
            GENERIC = "No! I will not let you experiment on me.",
            ATTACKER = "Stabbing is not a good experiment",
            MURDERER = "He has killing down to a science.",
            REVIVER = "I suppse we're freinds now, %s.",
            GHOST = "Now you're my lab rat, Hehe.",
            FIRESTARTER = "You should already know what fire does, %s.",
        },
        WOLFGANG =
        {
            GENERIC = "Stop calling me \"Vinky\", there is not a V.",
            ATTACKER = "are you afraid of me? you should be.",
            MURDERER = "",
            REVIVER = "You are very brave now I think?",
            GHOST = "If you keep running I won't be able to revive you %s.",
            FIRESTARTER = ".",
        },
        WAXWELL =
        {
            GENERIC = "!",
            ATTACKER = "S",
            MURDERER = "",
            REVIVER = "",
            GHOST = "",
            FIRESTARTER = "",
        },
        WX78 =
        {
            GENERIC = "%s, you are a metal head.",
            ATTACKER = "He has a cold metal heart.",
            MURDERER = "Well he did say he hated all life.",
            REVIVER = ".",
            GHOST = "",
            FIRESTARTER = "You are very passionate about destruction.",
        },
        WILLOW =
        {
            GENERIC = "Missy burning girl.",
            ATTACKER = "You are very shifty",
            MURDERER = "she is smiling",
            REVIVER = "",
            GHOST = "I might give you a heart, if you ask nicely.",
            FIRESTARTER = "These things, they are expected.",
        },
        WENDY =
        {
            GENERIC = "This one looks broken.",
            ATTACKER = "",
            MURDERER = "",
            REVIVER = "",
            GHOST = "",
            FIRESTARTER = "",
        },
        WOODIE =
        {
            GENERIC = "Tra lala la, Yes, yes i've heard it before.",
            ATTACKER = "Do you plan on swinging that axe at me?",
            MURDERER = "",
            REVIVER = "I'll tell all my rat friends about you!",
            GHOST = "",
            BEAVER = "",
            BEAVERGHOST = "",
            MOOSE = "",
            MOOSEGHOST = "",
            GOOSE = "!",
            GOOSEGHOST = "",
            FIRESTARTER = "I don't think burning that forest was an accident.",
        },
        WICKERBOTTOM =
        {
            GENERIC = "",
            ATTACKER = "",
            MURDERER = "",
            REVIVER = "",
            GHOST = "",
            FIRESTARTER = "Maybe we should start burning books too.",
        },
        WES =
        {
            GENERIC = "Do you ever talk %s?",
            ATTACKER = "You are acting very silent all of a sudden.",
            MURDERER = "That is a lot of red paint.",
            REVIVER = "He is the loving silent type.",
            GHOST = "Just ask if you want to be alive again.",
            FIRESTARTER = "He has an invisble torch!",
        },
        WEBBER =
        {
            GENERIC = "",
            ATTACKER = "This feels petty.",
            MURDERER = "",
            REVIVER = "I ",
            GHOST = ".",
            FIRESTARTER = "",
        },
        WATHGRITHR =
        {
            GENERIC = "",
            ATTACKER = "",
            MURDERER = "%",
            REVIVER = "",
            GHOST = "You should get back into character.",
            FIRESTARTER = "She is a pillager!.",
        },
        WINONA =
        {
            GENERIC = "",
            ATTACKER = "Stealing from you was an accident, no need to fight!",
            MURDERER = "",
            REVIVER = "",
            GHOST = ".",
            FIRESTARTER = ".",
        },
        WORTOX =
        {
            GENERIC = "You don't look like you're from around here.",
            ATTACKER = "",
            MURDERER = "",
            REVIVER = "",
            GHOST = "",
            FIRESTARTER = ".",
        },
        WORMWOOD =
        {
            GENERIC = "",
            ATTACKER = "",
            MURDERER = "",
            REVIVER = "",
            GHOST = "",
            FIRESTARTER = "",
        },
        WARLY =
        {
            GENERIC = "I don't suppose you have any cheddar on you %s?",
            ATTACKER = "I am sorry I won't pull your hair again!",
            MURDERER = "I guess rat is on the menu then?",
            REVIVER = "And ",
            GHOST = "I must bring you back",
            FIRESTARTER = "",
        },

        WURT =
        {
            GENERIC = "",
            ATTACKER = "",
            MURDERER = "",
            REVIVER = "",
            GHOST = "",
            FIRESTARTER = "",
        },

        WALTER =
        {
            GENERIC = "",
            ATTACKER = "Watch where you throw things!",
            MURDERER = "",
            REVIVER = "",
            GHOST = "",
            FIRESTARTER = "",
        },

        WANDA =
        {
            GENERIC = "I suppose you like to hoard clocks.",
            ATTACKER = "",
            MURDERER = "So Just because I am not perfect I do not belong",
            REVIVER = "",
            GHOST = "Was this part of the plan?",
            FIRESTARTER = "",
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
            SLEEPING = "Smush you into bug jelly. Yes...",
        },
        GLOMMERFLOWER =
        {
            GENERIC = "Pungent, I like this!",
            DEAD = "Crusty flower.",
        },
        GLOMMERWINGS = "Beetle wings.",
        GLOMMERFUEL = "I could eat this eveyrday!",
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
		UNAGI = "Little bits are sastisfying.",
		EYETURRET = "H-hello?",
		EYETURRET_ITEM = "I have heard looks can kill.",
		MINOTAURHORN = "Eat it or not to eat...",
		MINOTAURCHEST = "It may contain a something fantastic! Or something horrible.",
		THULECITE_PIECES = "Pebbled Stones.",
		POND_ALGAE = "Stomping it is funny!",
		GREENSTAFF = "It has magic!",
		GIFT = "Aw, you should not have!",
        GIFTWRAP = "I like to receive.",
		POTTEDFERN = "They are everywhere in cave...",
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
			GLASSED = "Well, it is not water anymore.",
        },
		THULECITE = "Unique thing... yes.",
		ARMORRUINS = "The Yellow brings out my eyes.",
		ARMORSKELETON = "Bones have more uses than I thought.",
		SKELETONHAT = "This my head hat now.",
		RUINS_BAT = "Good for playing Rat-Ball, you wouldn't get it...",
		RUINSHAT = "I am queen of all rats!",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = " \"phew...\".",
            WARN = "This is not good...",
            WAXING = "This is why rats NEVER come here.",
            STEADY = "The Evil is holding on.",
            WANING = "It's still here.",
            DAWN = "I'm almost free!",
            NOMAGIC = "It has vanished for now.",
		},
		BISHOP_NIGHTMARE = "Horrible gnashing metal!",
		ROOK_NIGHTMARE = "Screching metal horror!",
		KNIGHT_NIGHTMARE = "Clunking buzzy metal!",
		MINOTAUR = "That thing doesn't look happy.",
		SPIDER_DROPPER = "Why are you white now?",
		NIGHTMARELIGHT = "Many silent whispers.",
		NIGHTSTICK = "I want to lick it, I know I can't but I must.",
		GREENGEM = "My jewels!",
		MULTITOOL_AXE_PICKAXE = "For whacking and hacking.",
		ORANGESTAFF = ".",
		YELLOWAMULET = "",
		GREENAMULET = "",
		SLURPERPELT = "",

		SLURPER = "You can not eat what I eat!",
		SLURPER_PELT = "Not bad tasting.",
		ARMORSLURPER = "It is my style.",
		ORANGEAMULET = "Collecting is easy now! I can make so many collections!",
		YELLOWSTAFF = "This quite nice, yes.",
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
			VALID = "Looks ready.",
			GEMS = "It needs a gem.",
		},
		STAFFLIGHT = "That seems really dangerous.",
        STAFFCOLDLIGHT = "Brr! Chilling.",

        ANCIENT_ALTAR = "Evil Magic is made here!",

        ANCIENT_ALTAR_BROKEN = "Rubble now.",

        ANCIENT_STATUE = "old thing. We never come here",

        LICHEN = "It's uhh.. not that good..",
		CUTLICHEN = "Tastes yucky, but it grows on you.",

		CAVE_BANANA = "Less seeds than I remember.",
		CAVE_BANANA_COOKED = "Never tried them like this! It is good!",
		CAVE_BANANA_TREE = "The Monkeys eat most of them.",
		ROCKY = "I have tried eating gravel, It was not very good.",

		COMPASS =
		{
			GENERIC="Which way am I facing?",
			N = "Right way.",
			S = "Wrong way.",
			E = "East.",
			W = "West.",
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
        MANRABBIT_TAIL = "Useless Garbage!",
        MUSHROOMHAT = "Makes me look silly!",
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
        SLEEPBOMB = "It makes snooze circles when I throw it.",
        MUSHROOMBOMB = "A mushroom cloud in the making!",
        SHROOM_SKIN = "Will I get warts now?",
        TOADSTOOL_CAP =
        {
            EMPTY = "Damp hole.",
            INGROUND = "Bump in the ground.",
            GENERIC = "I have the urge, crush that mushroom.",
        },
        TOADSTOOL =
        {
            GENERIC = "He is so.. Bumpy.",
            RAGE = "AAAAH! He is angry and bumpy now!",
        },
        MUSHROOMSPROUT =
        {
            GENERIC = "Sigh, They grow up so fast.",
            BURNT = "Smells like throw-up.",
        },
        MUSHTREE_TALL =
        {
            GENERIC = "That mushroom got too big for its own good.",
            BLOOM = "You can't tell from far away, but it's quite smelly.",
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "These used to grow in my bathroom.",
            BLOOM = "I'm mildly offended by this.",
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "A magic mushroom?",
            BLOOM = "It's trying to reproduce.",
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
            GENERIC = "Floating Aimlessly... Boring.",
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
        SPIDER_SPITTER = "My fellow rats can throw futher!",
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
        TURF_METEOR = "\"sniff\",\"sniff\" It is supposed to be Cheese?!?",
        TURF_PEBBLEBEACH = "It is very much a thing.",
        TURF_ROAD = "It is worse than rat stone.",
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
		ARMOR_SANITY = "Reminds me of my hatred, grrrrr.",
		ASH =
		{
			GENERIC = "Dust from somehthing",
			REMAINS_GLOMMERFLOWER = "The flower was consumed by fire in the teleportation!",
			REMAINS_EYE_BONE = "The eyebone was consumed by fire in the teleportation!",
			REMAINS_THINGIE = "There's a perfectly scientific explanation for that.",
		},
		AXE = "It is for hacking, and slicing!",
		BABYBEEFALO =
		{
			GENERIC = "You could use a few pounds.",
		    SLEEPING = "Killing you will be easy.",
        },
        BUNDLE = "Stashed Treats for later, E-hehe.",
        BUNDLEWRAP = "Stashing wrap.",
		BACKPACK = "It is very nice, more for my hoard.",
		BACONEGGS = "Egg murder breakfast.",
		BANDAGE = "I like to lick it first!",
		BASALT = "Maybe if we push it.", --removed
		BEARDHAIR = "/Pleugh!/ Always in my mouth?!",
		BEARGER = "Time to /Squeak/ away!!",
		BEARGERVEST = "Not as greasy as my fur! Soon it will....",
		ICEPACK = "How is it cold if there is no ice?",
		BEARGER_FUR = "my rat bed could use this.",
		BEDROLL_STRAW = "I prefer dirt.",
		BEEQUEEN = "/Squeak!/ AAAH get AWAY FROM ME!! ",
		BEEQUEENHIVE =
		{
			GENERIC = "Ahaha, I must get inside!",
			GROWING = "\"Patience is not a virtue of mine!\"",
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
			NOHONEY = "Make More.",
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
            ORNERY = "You must despise me, good.",
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
		BEEMINE_MAXWELL = "/Squeak!/",--removed
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
		BIGFOOT = "/Squeak!!/ AAAHH DO NOT CRUSH ME!!!",--removed
		BIRDCAGE =
		{
			GENERIC = "I must find a good slave.",
			OCCUPIED = "He-he you are my mine now!",
			SLEEPING = "Rest now...",
			HUNGRY = "It is MY food though.",
			STARVING = "Keeling over? I do want an egg...",
			DEAD = "Eh... No more eggs...",
			SKELETON = "Teeny, teeny, tiny bones.",
		},
		BIRDTRAP = "My snout was caught in one once.",
		CAVE_BANANA_BURNT = "Not my fault!",
		BIRD_EGG = "They have a nice crunch to them.",
		BIRD_EGG_COOKED = "Yellow part is the most delcious.",
		BISHOP = "",
		BLOWDART_FIRE = "I should cover it in my spit too.",
		BLOWDART_SLEEP = "An easy way to get a meal.",
		BLOWDART_PIPE = "He he he, they will never know.",
		BLOWDART_YELLOW = "",
		BLUEAMULET = "",
		BLUEGEM = "A cold blue rock.",
		BLUEPRINT =
		{
            COMMON = "",
            RARE = "",
        },
        SKETCH = "",
		BLUE_CAP = "It's weird and gooey.",
		BLUE_CAP_COOKED = "It's different now...",
		BLUE_MUSHROOM =
		{
			GENERIC = "It's a mushroom.",
			INGROUND = "It's sleeping.",
			PICKED = "I wonder if it will come back?",
		},
		BOARDS = "Boards.",
		BONESHARD = "Bits of bone.",
		BONESTEW = "A stew to put some meat on your bones.",
		BUGNET = "I can stick my fingers through the holes.",
		BUSHHAT = "I will be able to hide in plain view!",
		BUTTER = "Greasy and good.",
		BUTTERFLY =
		{
			GENERIC = "",
			HELD = "",
		},
		BUTTERFLYMUFFIN = "",
		BUTTERFLYWINGS = ".",
		BUZZARD = "Grow fat on some roadkill.",

		SHADOWDIGGER = "Oh good. Now there's more of him.",

		CACTUS =
		{
			GENERIC = "Sharp but delicious.",
			PICKED = "Deflated, but still spiny.",
		},
		CACTUS_MEAT_COOKED = "",
		CACTUS_MEAT = ".",
		CACTUS_FLOWER = ".",

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
		CATCOONHAT = "",
		COONTAIL = "",
		CARROT = "",
		CARROT_COOKED = "",
		CARROT_PLANTED = "",
		CARROT_SEEDS = "",
		CARTOGRAPHYDESK =
		{
			GENERIC = "Why would I want to show everyone where I hide my things.",
			BURNING = "It was pointless.",
			BURNT = "I think I like it better.",
		},
		WATERMELON_SEEDS = "",
		CAVE_FERN = "It's a fern.",
		CHARCOAL = "It's small, dark, and smells like burnt wood.",
        CHESSPIECE_PAWN = "Not that impressive.",
        CHESSPIECE_ROOK =
        {
            GENERIC = "A castle.",
            STRUGGLE = "Stone does not hatch, what baby is in there?",
        },
        CHESSPIECE_KNIGHT =
        {
            GENERIC = "A Grotesque",
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
        CHESSPIECE_DEERCLOPS = "",
        CHESSPIECE_BEARGER = "",
        CHESSPIECE_MOOSEGOOSE =
        {
            "",
        },
        CHESSPIECE_DRAGONFLY = "",
		CHESSPIECE_MINOTAUR = "",
        CHESSPIECE_BUTTERFLY = "",
        CHESSPIECE_ANCHOR = "",
        CHESSPIECE_MOON = "",
        CHESSPIECE_CARRAT = "Where is my statue?!",
        CHESSPIECE_MALBATROSS = "",
        CHESSPIECE_CRABKING = "",
        CHESSPIECE_TOADSTOOL = "At least this one doesn't make mushrooms.",
        CHESSPIECE_STALKER = "",
        CHESSPIECE_KLAUS = "",
        CHESSPIECE_BEEQUEEN = "She has tasted the sting of death.",
        CHESSPIECE_ANTLION = "",
        CHESSPIECE_BEEFALO = "No smell to it.",
		CHESSPIECE_KITCOON = "A monument to ugly kitties.",
		CHESSPIECE_CATCOON = "A monument to ugly kitties.",
        CHESSPIECE_GUARDIANPHASE3 = "",
        CHESSPIECE_EYEOFTERROR = "Terror is ",
        CHESSPIECE_TWINSOFTERROR = "Eye see why everyone likes this one.",

        CHESSJUNK1 = "Scrap metal in a pile.",
        CHESSJUNK2 = "Scrap metal in a pile. It should be in my pile.",
        CHESSJUNK3 = "I could add this junk to my treasure hoard.",
		CHESTER = "You are an odd thing.",
		CHESTER_EYEBONE =
		{
			GENERIC = "",
			WAITING = "",
		},
		COOKEDMANDRAKE = "P",
		COOKEDMEAT = "",
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
		CORN_SEEDS = "Den food.",
        CANARY =
		{
			GENERIC = "",
			HELD = "",
		},
        CANARY_POISONED = "",

		CRITTERLAB = "Hello? Never seen this rat-hole before?",
        CRITTER_GLOMLING = "Lumpy bug thing.",
        CRITTER_DRAGONLING = "You are a little cute, for a horrid beetle.",
		CRITTER_LAMB = "Hope you taste as good as you are loud.",
        CRITTER_PUPPY = "Barking annoying thing.",
        CRITTER_KITTEN = "I've heard this is irony.",
        CRITTER_PERDLING = "I will pluck a feather daily.",
		CRITTER_LUNARMOTHLING = "",

		CROW =
		{
			GENERIC = "You are not familar.",
			HELD = "Wait, Rats do not have wings, haha.",
		},
		CUTGRASS = "Needs to be Kneaded for Nesting.",
		CUTREEDS = "I will hoard many of this.",
		CUTSTONE = "This shape is very unnatural, I like that.",
		DEADLYFEAST = "I can eat anything!", --unimplemented
		DEER =
		{
			GENERIC = "",
			ANTLER = "",
		},
        DEER_ANTLER = "Head branch",
        DEER_GEMMED = "No eye? Gem eye.",
		DEERCLOPS = "No, no, get away terrible thing!",
		DEERCLOPS_EYEBALL = "Behold, my meal.",
		EYEBRELLAHAT =	"Waste of food.",
		DEPLETED_GRASS =
		{
			GENERIC = "It's probably a tuft of grass.",
		},
        GOGGLESHAT = "It keeps falling off.",
        DESERTHAT = "I can't even hear anything when I wear it.",
		DEVTOOL = "It is probably useless.",
		DEVTOOL_NODEV = "I'm stealing it now.",
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
		DIVININGRODSTART = "Terrible Stick Box", --singleplayer
		DRAGONFLY = "How did a bug become so big!",
		ARMORDRAGONFLY = "Beetle armour",
		DRAGON_SCALES = "Beetle scales",
		DRAGONFLYCHEST = "Next best thing to a lockbox!",
		DRAGONFLYFURNACE =
		{
			HAMMERED = "If no one wants it I will take it.",
			GENERIC = "Produces a lot of heat, but not much light.", --no gems
			NORMAL = "Is it winking at me?", --one gem
			HIGH = "It's scalding!", --two gems
		},

        HUTCH = "You do not smell normal.",
        HUTCH_FISHBOWL =
        {
            GENERIC = "I want to eat you.",
            WAITING = "He is... Dead.",
        },
		LAVASPIT =
		{
			HOT = "Hot spit!",
			COOL = "I like to call it \"Basaliva\".",
		},
		LAVA_POND = "Lava.",
		LAVAE = "Worm of goo",
		LAVAE_COCOON = "Dead?",
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
			COMFY = "hmmm, I said cook it.",
		},
		LAVAE_TOOTH = "It's an egg tooth!",

		DRAGONFRUIT = "",
		DRAGONFRUIT_COOKED = "",
		DRAGONFRUIT_SEEDS = "",
		DRAGONPIE = "",
		DRUMSTICK = "",
		DRUMSTICK_COOKED = "",
		DUG_BERRYBUSH = "",
		DUG_BERRYBUSH_JUICY = "",
		DUG_GRASS = "",
		DUG_MARSH_BUSH = "",
		DUG_SAPLING = "",
		DURIAN = "Aaah, ripe.",
		DURIAN_COOKED = "This is okay, too.",
		DURIAN_SEEDS = ".",
		EARMUFFSHAT = "I do not think this will cover my ears right...",
		EGGPLANT = "",
		EGGPLANT_COOKED = ".",
		EGGPLANT_SEEDS = "It's a seed.",

		ENDTABLE =
		{
			BURNT = "",
			GENERIC = "",
			EMPTY = "",
			WILTED = "The plant is dead.",
			FRESHLIGHT = "I did not know they could be used like this.",
			OLDLIGHT = "Very Dim now.", -- will be wilted soon, light radius will be very small at this point
		},
		DECIDUOUSTREE =
		{
			BURNING = "What a waste of wood.",
			BURNT = "I feel like I could have prevented that.",
			CHOPPED = "Take that, nature!",
			POISON = "It looks unhappy about me stealing those birchnuts!",
			GENERIC = "It's all leafy. Most of the time.",
		},
		ACORN = "I like its taste.",
        ACORN_SAPLING = "More nuts?",
		ACORN_COOKED = "Nutty Tasty.",
		BIRCHNUTDRAKE = "/GRAH/, get away.",
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
			GROWING = "!",
			NEEDSFERTILIZER = "",
			BURNT = "",
		},
		FEATHERHAT = "!",
		FEATHER_CROW = ".",
		FEATHER_ROBIN = "",
		FEATHER_ROBIN_WINTER = ".",
		FEATHER_CANARY = "",
		FEATHERPENCIL = ".",
        COOKBOOK = "",
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
			NORMAL = "Never let your passion burn out.",
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
		FISHSTICKS = "No Tartar?",
		FISHTACOS = "Never enough of these.",
		FISH_COOKED = "The fishes are delicious.",
		FLINT = "Best kind of rock.",
		FLOWER =
		{
            GENERIC = "I must find better smells. These are boring smells.",
            ROSE = "It doesn't like being touched.",
        },
        FLOWER_WITHERED = "Hm, Now it's ugly.",
		FLOWERHAT = "Eyuck",
		FLOWER_EVIL = "Mmm interesting!",
		FOLIAGE = "They are boring...",
		FOOTBALLHAT = "My head gets sweaty when I wear it.",
        FOSSIL_PIECE = "There is no more marrow.",
        FOSSIL_STALKER =
        {
			GENERIC = "A nice pile of bones.",
			FUNNY = "It looks finished to me.",
			COMPLETE = "It looks finished to me.",
        },
        STALKER = "What a terrible thing!",
        STALKER_ATRIUM = "Why do bones keep coming back alive! Stay dead!",
        STALKER_MINION = "Anklebiters!",
        THURIBLE = "",
        ATRIUM_OVERGROWTH = "I can hear the screaming, whisering echos from it. Eughhh...",
		FROG =
		{
			DEAD = "It is twitching still.",
			GENERIC = "",
			SLEEPING = "Ugly.",
		},
		FROGGLEBUNWICH = "The best way to eat them.",
		FROGLEGS = "",
		FROGLEGS_COOKED = "",
		FRUITMEDLEY = "Fruity.",
		FURTUFT = "Black and white fur.",
		GEARS = "Pile of bits and bobs.",
		GHOST = "",
		GOLDENAXE = "",
		GOLDENPICKAXE = "",
		GOLDENPITCHFORK = "",
		GOLDENSHOVEL = ".",
		GOLDNUGGET = "I do not see why this is more valuable? It is a rock and yellow.",
		GRASS =
		{
			BARREN = "Broken.",
			WITHERED = "Weak plant...",
			BURNING = "Aaa it is up in flames!",
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
		GREEN_CAP = "It seems pretty normal.",
		GREEN_CAP_COOKED = "It's different now...",
		GREEN_MUSHROOM =
		{
			GENERIC = "It's a mushroom.",
			INGROUND = "It's sleeping.",
			PICKED = "I wonder if it will come back?",
		},
		GUNPOWDER = "This does not seem like food.",
		HAMBAT = "I can eat, and bash things. Very practical.",
		HAMMER = "A good tool for smashing bones.",
		HEALINGSALVE = "This seems like a waste, I should eat it.",
		HEATROCK =
		{
			FROZEN = "",
			COLD = "Chilly smooth stone.",
			GENERIC = "Nice shape for a rock.",
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
		HOUND = "/RAAA/, You Like that?! I am big now!",
		HOUNDCORPSE =
		{
			GENERIC = "It is smelling very... Foul? Huh that is not right?",
			BURNING = ".",
			REVIVING = "The bugs inside are coming out!",
		},
		HOUNDBONE = "Marrow in there?",
		HOUNDMOUND = "They are hogging the bones.",
		ICEBOX = "Cold food is umm.. not as good tasting.",
		ICEHAT = "It makes me moist and I am sad.",
		ICEHOUND = "Snowy.",
		INSANITYROCK =
		{
			ACTIVE = "How did it unbury itself?",
			INACTIVE = "It is stuck in the ground.",
		},
		JAMMYPRESERVES = "Probably should have made a jar.",

		KABOBS = "Lunch on a stick.",
		KILLERBEE =
		{
			GENERIC = "/Grah!/ These ones are evil!",
			HELD = "If I eat you, do not sting my insides.",
		},
		KNIGHT = "",
		KOALEFANT_SUMMER = "",
		KOALEFANT_WINTER = "",
		KRAMPUS = "That is not yours to steal!",
		KRAMPUS_SACK = "This would've mad",
		LEIF = "It was not me! I Promise!",
		LEIF_SPARSE = "It was not me! I Promise!",
		LIGHTER  = "Finders keepers.",
		LIGHTNING_ROD =
		{
			CHARGED = "The power is mine!",
			GENERIC = "To harness the heavens!",
		},
		LIGHTNINGGOAT =
		{
			GENERIC = "/Baaaah/ yourself!",
			CHARGED = "I don't think it liked being struck by lightning.",
		},
		LIGHTNINGGOATHORN = "",
		GOATMILK = "It's buzzing with tastiness!",
		LITTLE_WALRUS = ".",
		LIVINGLOG = "It looks worried.",
		LOG =
		{
			BURNING = "That's some hot wood!",
			GENERIC = "It's big, it's heavy, and it's wood.",
		},
		LUCY = "I didn't want to steal you anyways!",
		LUREPLANT = "",
		LUREPLANTBULB = "",
		MALE_PUPPET = "That thing is stuck.", --single player

		MANDRAKE_ACTIVE = "",
		MANDRAKE_PLANTED = ".",
		MANDRAKE = "",

        MANDRAKESOUP = "",
        MANDRAKE_COOKED = "I.",
        MAPSCROLL = "A blank map. Doesn't seem very useful.",
        MARBLE = "Fancy!",
        MARBLEBEAN = "",
        MARBLEBEAN_SAPLING = "",
        MARBLESHRUB = "Makes sense to me.",
        MARBLEPILLAR = "I think I could use that.",
        MARBLETREE = ".",
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
        MAXWELLTHRONE = "Most wretched chair.",--single player
        MEAT = "Ah! Perfect!",
        MEATBALLS = "Balled up, easy to eat now.",
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
        MEAT_DRIED = "Not the best, But it is good...",
        MERM = "Not dead for walking on land?",
        MERMHEAD =
        {
            GENERIC = "The Stink looks good on you.",
            BURNT = "Blegh! Not my kind of /Stinky/",
        },
        MERMHOUSE =
        {
            GENERIC = "Humble home.",
            BURNT = "Broken.",
        },
        MINERHAT = "My eyes are fine in the dark! well they were...",
        MONKEY = "Stealers! I will steal back what is mine!",
        MONKEYBARREL = "Hiding in plain sight!",
        MONSTERLASAGNA = "Most wonderful meal!",
        FLOWERSALAD = "Freak food.",
        ICECREAM = "",
        WATERMELONICLE = "",
        TRAILMIX = "Maybe I can burry these for later.",
        HOTCHILI = "!",
        GUACAMOLE = ".",
        MONSTERMEAT = ".",
        MONSTERMEAT_DRIED = "S.",
        MOOSE = "I",
        MOOSE_NESTING_GROUND = "Not my nest.",
        MOOSEEGG = "I must crack it!",
        MOSSLING = "",
        FEATHERFAN = "It will do the trick. Now I need a rat to fan me.",
        MINIFAN = "Barely even works! I need something bigger.",
        GOOSE_FEATHER = "",
        STAFF_TORNADO = "Whirling doom.",
        MOSQUITO =
        {
            GENERIC = "Parasite thing.",
            HELD = "Eating you now!",
        },
        MOSQUITOSACK = "Mash it up and eat it!",
        MOUND =
        {
            DUG = "No home.",
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
        PANFLUTE = "",
        PAPYRUS = "It is not very interesting, But I will steal it anyways.",
        WAXPAPER = "Shinier.",
        PENGUIN = "Dressed to kill.",
        PERD = "Stuffing your face with my food!?",
        PEROGIES = "",
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
            DEAD = "Bye, bye! HAHA!",
            FOLLOWER = "This is awkward...",
            GENERIC = "They do not like me.",
            GUARD = "Alert of all things.",
            WEREPIG = "No no, why is this happening!",
        },
        PIGSKIN = "He will not miss it.",
        PIGTENT = "Smells like bacon.",
        PIGTORCH = "Sure looks cozy.",
        PINECONE = "",
        PINECONE_SAPLING = "",
        LUMPY_SAPLING = "",
        PITCHFORK = "",
        PLANTMEAT = "Fake meat? But it tastes like real meat.",
        PLANTMEAT_COOKED = "",
        PLANT_NORMAL =
        {
            GENERIC = "Leafy!",
            GROWING = "Guh! It's growing so slowly!",
            READY = "Mmmm. Ready to harvest.",
            WITHERED = "The heat killed it.",
        },
        POMEGRANATE = ".",
        POMEGRANATE_COOKED = "!",
        POMEGRANATE_SEEDS = "",
        POND = "I do not want to take a dip.",
        POOP = "Caca.",
        FERTILIZER = ".",
        PUMPKIN = "I like to stomp on it before I eat it.",
        PUMPKINCOOKIE = "",
        PUMPKIN_COOKED = "Mushy, warm, and good to eat.",
        PUMPKIN_LANTERN = "I do not get it.",
        PUMPKIN_SEEDS = ".",
        PURPLEAMULET = "",
        PURPLEGEM = "My jewels!",
        RABBIT =
        {
            GENERIC = "",
            HELD = "Stop writhing, it'll be over soon.",
        },
        RABBITHOLE =
        {
            GENERIC = "Not a hole for me.",
            SPRING = "Haha! it is so bad it collapsed!",
        },
        RAINOMETER =
        {
            GENERIC = "",
            BURNT = "",
        },
        RAINCOAT = "Yes, I do like having dry fur.",
        RAINHAT = "I can hear all the little raindrops when I wear it.",
        RATATOUILLE = "",
        RAZOR = "I'd rather keep my fur.",
        REDGEM = "",
        RED_CAP = "It smells funny.",
        RED_CAP_COOKED = "It's different now...",
        RED_MUSHROOM =
        {
            GENERIC = "It's a mushroom.",
            INGROUND = "It's sleeping.",
            PICKED = "I wonder if it will come back?",
        },
        REEDS =
        {
            BURNING = "!",
            GENERIC = "",
            PICKED = "Waiting is the worst part.",
        },
        RELIC = ".",
        RUINS_RUBBLE = "",
        RUBBLE = "",
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
            GENERIC = "Red is a nice colour.",
            HELD = "You will make for an excellent slave.",
        },
        ROBIN_WINTER =
        {
            GENERIC = "",
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
            GENERIC = ".",
            MELTED = "",
        },
        ROCK_ICE_MELTED = ".",
        ICE = "It is cold and hard, and nice to chew on.",
        ROCKS = "It is something good for bashing bones.",
        ROOK = "Loud and clunky, I hate it!",
        ROPE = "It is like string, but very thick.",
        ROTTENEGG = "*/sniff*/ Aaaa how fragrant!",
        ROYAL_JELLY = "It is so /SWEET!/ Too sweet even...",
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
			BLOCK = "",
			SCULPTURE = "",
			BURNT = "Useless now.",
   		},
        SCULPTURE_KNIGHTHEAD = "Where's the rest of it?",
		SCULPTURE_KNIGHTBODY =
		{
			COVERED = "It's an odd marble statue.",
			UNCOVERED = "I guess he cracked under the pressure.",
			FINISHED = "At least it's back in one piece now.",
			READY = "Something's moving inside.",
		},
        SCULPTURE_BISHOPHEAD = "Is that a head?",
		SCULPTURE_BISHOPBODY =
		{
			COVERED = "It looks old, but it feels new.",
			UNCOVERED = "There's a big piece missing.",
			FINISHED = "Now what?",
			READY = "Something's moving inside.",
		},
        SCULPTURE_ROOKNOSE = "Where did this come from?",
		SCULPTURE_ROOKBODY =
		{
			COVERED = "It's some sort of marble statue.",
			UNCOVERED = "It's not in the best shape.",
			FINISHED = "All patched up.",
			READY = "Something's moving inside.",
		},
        GARGOYLE_HOUND = "It is alawys watching...",
        GARGOYLE_WEREPIG = "",
		SEEDS = ".",
		SEEDS_COOKED = "!",
		SEWING_KIT = "It twirls around my hands when I try and use it.",
		SEWING_TAPE = "Very bitter, and sticky.",
		SHOVEL = ".",
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
		SPIDERDEN = "Make room for rats!",
		SPIDEREGGSACK = "Eat it before it grows.",
		SPIDERGLAND = "Floppy thing.",
		SPIDERHAT = "Why do I need this? Stupid hat! I am Rat.",
		SPIDERQUEEN = "Hit her, many times!",
		SPIDER_WARRIOR =
		{
			DEAD = "It was weak.",
			GENERIC = "It thinks it is not ugly.",
			SLEEPING = "Smash its head with a rock!",
		},
		SPOILED_FOOD = "Food when there is no food. But I prefer normal food.",
        STAGEHAND =
        {
			AWAKE = "Don't touch me!",
			HIDING = "This table is more fiend-like than normal.",
        },
        STATUE_MARBLE =
        {
            GENERIC = "It's a fancy marble statue.",
            TYPE1 = "Don't lose your head now!",
            TYPE2 = "Statuesque.",
            TYPE3 = "I wonder who the artist is.", --bird bath type statue
        },
		STATUEHARP = "Dead thing.",
		STATUEMAXWELL = "I do not know who that is.",
		STEELWOOL = "Don't lick it.",
		STINGER = "Don't eat too many.",
		STRAWHAT = "It's nice actually.",
		STUFFEDEGGPLANT = "",
		SWEATERVEST = "",
		REFLECTIVEVEST = "It is ugly.",
		HAWAIIANSHIRT = "",
		TAFFY = "Ooey Gooey.",
		TALLBIRD = "She is in the way of dinner.",
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
			GENERIC = "Interesting.", --single player
			LOCKED = "It is still broken?", --single player
			PARTIAL = "I do not see the point of this, They were my things.", --single player
		},
		TELEPORTATO_BOX = "If a shake it, it rattles funny!", --single player
		TELEPORTATO_CRANK = "This will look very good on my pile.", --single player
		TELEPORTATO_POTATO = "How unique! Hoarding this will be very good.", --single player
		TELEPORTATO_RING = "It is mine now!", --single player
		TELESTAFF = "What a nice stick.",
		TENT =
		{
			GENERIC = "I'm more of a day time sleeper.",
			BURNT = "this is fine.",
		},
		SIESTAHUT =
		{
			GENERIC = "Rat Nap, in the sun. I think I will now!",
			BURNT = "Which Stupid did this?",
		},
		TENTACLE = ".",
		TENTACLESPIKE = ".",
		TENTACLESPOTS = "The slime on this tastes funny?",
		TENTACLE_PILLAR = ".",
        TENTACLE_PILLAR_HOLE = "Seems stinky, but worth exploring.",
		TENTACLE_PILLAR_ARM = "Little slippery arms.",
		TENTACLE_GARDEN = ".",
		TOPHAT = "A rat in a hat?",
		TORCH = "I do not need this, I can see just fine in the dark.",
		TRANSISTOR = "A little robo thinger.",
		TRAP = "I hope no friends get stuck in it.",
		TRAP_TEETH = "He he he...",
		TRAP_TEETH_MAXWELL = "That is not fair!", --single player
		TREASURECHEST =
		{
			GENERIC = "",
			BURNT = "",
		},
		TREASURECHEST_TRAP = "How convenient!",
		SACRED_CHEST =
		{
			GENERIC = "I hear whispers. It wants something.",
			LOCKED = "It's passing its judgment.",
		},
		TREECLUMP = "These trees look imposing, I should turn back...", --removed

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
		TRINKET_15 = "", --Pawn
		TRINKET_16 = "", --Pawn
		TRINKET_17 = "This will look good with the others.", --Bent Spork
		TRINKET_18 = "What creature is this?", --Trojan Horse
		TRINKET_19 = ".", --Unbalanced Top
		TRINKET_20 = "Oh This one is practical!", --Backscratcher
		TRINKET_21 = "They deserve to be beaten.", --Egg Beater
		TRINKET_22 = "", --Frayed Yarn
		TRINKET_23 = "This one is very funny I will keep it.", --Shoehorn
		TRINKET_24 = "Very handsome. What? I'm allowed to like it.", --Lucky Cat Jar
		TRINKET_25 = "Beautiful smell.", --Air Unfreshener
		TRINKET_26 = "Very practical, I need more of these.", --Potato Cup
		TRINKET_27 = "", --Coat Hanger
		TRINKET_28 = "Teeny castle.", --Rook
        TRINKET_29 = "Teeny castle.", --Rook
        TRINKET_30 = "Head of thing.", --Knight
        TRINKET_31 = "Head of thing.", --Knight
        TRINKET_32 = "I can a see rat trapped in it!", --Cubic Zirconia Ball
        TRINKET_33 = "It makes me look pretty.", --Spider Ring
        TRINKET_34 = "", --Monkey Paw
        TRINKET_35 = "", --Empty Elixir
        TRINKET_36 = "I might need these after all that candy.", --Faux fangs
        TRINKET_37 = "Stabby stick, very good.", --Broken Stake
        TRINKET_38 = " ", -- Binoculars Griftlands trinket
        TRINKET_39 = "", -- Lone Glove Griftlands trinket
        TRINKET_40 = "Haha this is very funny, I get it.", -- Snail Scale Griftlands trinket
        TRINKET_41 = "", -- Goop Canister Hot Lava trinket
        TRINKET_42 = "A little slinky thing.", -- Toy Cobra Hot Lava trinket
        TRINKET_43= ".", -- Crocodile Toy Hot Lava trinket
        TRINKET_44 = "I could put this with the rest.", -- Broken Terrarium ONI trinket
        TRINKET_45 = "", -- Odd Radio ONI trinket
        TRINKET_46 = "", -- Hairdryer ONI trinket

        -- The numbers align with the trinket numbers above.
        LOST_TOY_1  = "ACK, What is it?!",
        LOST_TOY_2  = "ACK, What is it?!",
        LOST_TOY_7  = "Now I don't like it. Taunting me!",
        LOST_TOY_10 = "ACK, What is it?!.",
        LOST_TOY_11 = "ACK, What is it?!",
        LOST_TOY_14 = "ACK, What is it?!",
        LOST_TOY_18 = "ACK, What is it?!",
        LOST_TOY_19 = "ACK, What is it?!",
        LOST_TOY_42 = "ACK, What is it?!",
        LOST_TOY_43 = "ACK, What is it?!",

        HALLOWEENCANDY_1 = "The cavities are probably worth it, right?",
        HALLOWEENCANDY_2 = "What corruption of science grew these?",
        HALLOWEENCANDY_3 = "It's... corn.",
        HALLOWEENCANDY_4 = "They wriggle on the way down.",
        HALLOWEENCANDY_5 = "My teeth are going to have something to say about this tomorrow.",
        HALLOWEENCANDY_6 = "I... don't think I'll be eating those.",
        HALLOWEENCANDY_7 = "Everyone'll be raisin' a fuss over these.",
        HALLOWEENCANDY_8 = "Only a sucker wouldn't love this.",
        HALLOWEENCANDY_9 = "Sticks to your teeth.",
        HALLOWEENCANDY_10 = "Only a sucker wouldn't love this.",
        HALLOWEENCANDY_11 = "Much better tasting than the real thing.",
        HALLOWEENCANDY_12 = "Did that candy just move?", --ONI meal lice candy
        HALLOWEENCANDY_13 = "Oh, my poor jaw.", --Griftlands themed candy
        HALLOWEENCANDY_14 = "I don't do well with spice.", --Hot Lava pepper candy
        CANDYBAG = "It's some sort of delicious pocket dimension for sugary treats.",

		HALLOWEEN_ORNAMENT_1 = "A spectornament I could hang in a tree.",
		HALLOWEEN_ORNAMENT_2 = "Completely batty decoration.",
		HALLOWEEN_ORNAMENT_3 = "This wood look good hanging somewhere.",
		HALLOWEEN_ORNAMENT_4 = "Almost i-tentacle to the real ones.",
		HALLOWEEN_ORNAMENT_5 = "Eight-armed adornment.",
		HALLOWEEN_ORNAMENT_6 = "Everyone's raven about tree decorations these days.",

		HALLOWEENPOTION_DRINKS_WEAK = "I was hoping for something bigger.",
		HALLOWEENPOTION_DRINKS_POTENT = "A potent potion.",
        HALLOWEENPOTION_BRAVERY = "Full of grit.",
		HALLOWEENPOTION_MOON = "Infused with transforming such-and-such.",
		HALLOWEENPOTION_FIRE_FX = "Crystallized inferno.",
		MADSCIENCE_LAB = "Sanity is a small price to pay for science!",
		LIVINGTREE_ROOT = "Something's in there! I'll have to root it out.",
		LIVINGTREE_SAPLING = "It'll grow up big and horrifying.",

        DRAGONHEADHAT = "So who gets to be the head?",
        DRAGONBODYHAT = "I'm middling on this middle piece.",
        DRAGONTAILHAT = "Someone has to bring up the rear.",
        PERDSHRINE =
        {
            GENERIC = "I feel like it wants something.",
            EMPTY = "I've got to plant something there.",
            BURNT = "That won't do at all.",
        },
        REDLANTERN = ".",
        LUCKY_GOLDNUGGET = "It is lucky? Well it is mine now!",
        FIRECRACKERS = "I do not like these!",
        PERDFAN = "",
        REDPOUCH = "A present for Winky!",
        WARGSHRINE =
        {
            GENERIC = "I should make something fun.",
            EMPTY = "I need to put a torch in it.",
            BURNING = "I should make something fun.", --for willow to override
            BURNT = "It burned down.",
        },
        CLAYWARG =
        {
        	GENERIC = "A terror cotta monster!",
        	STATUE = "Did it just move?",
        },
        CLAYHOUND =
        {
        	GENERIC = "It's been unleashed!",
        	STATUE = "It looks so real.",
        },
        HOUNDWHISTLE = "This'd stop a dog in its tracks.",
        CHESSPIECE_CLAYHOUND = "That thing's the leashed of my worries.",
        CHESSPIECE_CLAYWARG = "And I didn't even get eaten!",

		PIGSHRINE =
		{
            GENERIC = "More stuff to make.",
            EMPTY = "It's hungry for meat.",
            BURNT = "Burnt out.",
		},
		PIG_TOKEN = "This looks important.",
		PIG_COIN = "This'll pay off in a fight.",
		YOTP_FOOD1 = "A feast fit for me.",
		YOTP_FOOD2 = "A meal only a beast would love.",
		YOTP_FOOD3 = "Nothing fancy.",

		PIGELITE1 = "What are you looking at?", --BLUE
		PIGELITE2 = "He's got gold fever!", --RED
		PIGELITE3 = "Here's mud in your eye!", --WHITE
		PIGELITE4 = "Wouldn't you rather hit someone else?", --GREEN

		PIGELITEFIGHTER1 = "What are you looking at?", --BLUE
		PIGELITEFIGHTER2 = "He's got gold fever!", --RED
		PIGELITEFIGHTER3 = "Here's mud in your eye!", --WHITE
		PIGELITEFIGHTER4 = "Wouldn't you rather hit someone else?", --GREEN

		CARRAT_GHOSTRACER = "That's... disconcerting.",

        YOTC_CARRAT_RACE_START = "It's a good enough place to start.",
        YOTC_CARRAT_RACE_CHECKPOINT = "You've made your point.",
        YOTC_CARRAT_RACE_FINISH =
        {
            GENERIC = "It's really more of a finish circle than a line.",
            BURNT = "It's all gone up in flames!",
            I_WON = "Ha HA! Science prevails!",
            SOMEONE_ELSE_WON = "Sigh... congratulations, {winner}.",
        },

		YOTC_CARRAT_RACE_START_ITEM = "Well, it's a start.",
        YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "That checks out.",
		YOTC_CARRAT_RACE_FINISH_ITEM = "The end's in sight.",

		YOTC_SEEDPACKET = "Looks pretty seedy, if you ask me.",
		YOTC_SEEDPACKET_RARE = "Hey there, fancy-plants!",

		MINIBOATLANTERN = "How illuminating!",

        YOTC_CARRATSHRINE =
        {
            GENERIC = "What to make...",
            EMPTY = "Hm... what does a carrat like to eat?",
            BURNT = "Smells like roasted carrots.",
        },

        YOTC_CARRAT_GYM_DIRECTION =
        {
            GENERIC = "This'll get things moving in the right direction.",
            RAT = "You would make an excellent lab rat.",
            BURNT = "My training regimen crashed and burned.",
        },
        YOTC_CARRAT_GYM_SPEED =
        {
            GENERIC = "I need to get my carrat up to speed.",
            RAT = "Faster... faster!",
            BURNT = "I may have overdone it.",
        },
        YOTC_CARRAT_GYM_REACTION =
        {
            GENERIC = "Let's train those carrat-like reflexes!",
            RAT = "The subject's response time is steadily improving!",
            BURNT = "A small loss to take in the pursuit of science.",
        },
        YOTC_CARRAT_GYM_STAMINA =
        {
            GENERIC = "Getting strong now!",
            RAT = "This carrat... will be unstoppable!!",
            BURNT = "You can't stop progress! But this will delay it...",
        },

        YOTC_CARRAT_GYM_DIRECTION_ITEM = "I'd better get training!",
        YOTC_CARRAT_GYM_SPEED_ITEM = "I'd better get this assembled.",
        YOTC_CARRAT_GYM_STAMINA_ITEM = "This should help improve my carrat's stamina",
        YOTC_CARRAT_GYM_REACTION_ITEM = "This should improve my carrat's reaction time considerably.",

        YOTC_CARRAT_SCALE_ITEM = "This will help car-rate my car-rat.",
        YOTC_CARRAT_SCALE =
        {
            GENERIC = "Hopefully the scales tip in my favor.",
            CARRAT = "I suppose no matter what, it's still just a sentient vegetable.",
            CARRAT_GOOD = "This carrat looks ripe for racing!",
            BURNT = "What a mess.",
        },

        YOTB_BEEFALOSHRINE =
        {
            GENERIC = "What to make...",
            EMPTY = "Hm... what makes a beefalo?",
            BURNT = "Smells like barbeque.",
        },

        BEEFALO_GROOMER =
        {
            GENERIC = "There's no beefalo here to groom.",
            OCCUPIED = "",
            BURNT = "",
        },
        BEEFALO_GROOMER_ITEM = "I need to plop it down.",

		BISHOP_CHARGE_HIT = "/Squeak!/",
		TRUNKVEST_SUMMER = "Nose fashion.",
		TRUNKVEST_WINTER = "Nose fashion.",
		TRUNK_COOKED = "Ooo Yes! Moist and snotty! Just how I like it!",
		TRUNK_SUMMER = "Full of squishy meat, and yummy snot.",
		TRUNK_WINTER = "Full of squishy meat, and yummy snot.",
		TUMBLEWEED = "Full of stollen goods.",
		TURKEYDINNER = "I will gobble the entire thing up HA-ha!",
		TWIGS = "",
		UMBRELLA = "I only need it when it is wet.",
		GRASS_UMBRELLA = "I can gnaw on it later.",
		UNIMPLEMENTED = "",
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
		WALL_MOONROCK_ITEM = "It should be cheese.",
		FENCE = "This won't keep me out you know.",
        FENCE_ITEM = "It is a few branches stuck together.",
        FENCE_GATE = "It squeaks when I open it.",
        FENCE_GATE_ITEM = "Maybe I should plop it down.",
		WALRUS = "He is full of fat.",
		WALRUSHAT = "I feel very cultured wearing it.",
		WALRUS_CAMP =
		{
			EMPTY = "Unfinished pit.",
			GENERIC = "Ohh, something goes over the pit.",
		},
		WALRUS_TUSK = "Maybe I could replace my teeth with it.",
		WARDROBE =
		{
			GENERIC = "I do not need clothes if you haven't noticed.",
            BURNING = "I do not care.",
			BURNT = "I do not care.",
		},
		WARG = ".",
		WASPHIVE = "It looks very evil.",
		WATERBALLOON = "",
		WATERMELON = ".",
		WATERMELON_COOKED = ".",
		WATERMELONHAT = "It's sticky so it stays on.",
		WAXWELLJOURNAL = ".",
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
        WINTER_ORNAMENT = "",
        WINTER_ORNAMENTLIGHT = "",
        WINTER_ORNAMENTBOSS = "",
		WINTER_ORNAMENTFORGE = "",
		WINTER_ORNAMENTGORGE = "",

        WINTER_FOOD1 = "Some should be rat shaped.", --gingerbread cookie
        WINTER_FOOD2 = ".", --sugar cookie
        WINTER_FOOD3 = "n.", --candy cane
        WINTER_FOOD4 = "Why does everyone hate them? They are delicious.", --fruitcake
        WINTER_FOOD5 = ".", --yule log cake
        WINTER_FOOD6 = "", --plum pudding
        WINTER_FOOD7 = ".", --apple cider
        WINTER_FOOD8 = "", --hot cocoa
        WINTER_FOOD9 = "Nogged eggs, I like it.", --eggnog

		WINTERSFEASTOVEN =
		{
			GENERIC = "Good place for hiding things!",
			COOKING = "Cooking really is a science.",
			ALMOST_DONE_COOKING = "The science is almost done!",
			DISH_READY = "Science says it's done.",
		},
		BERRYSAUCE = "For sauce it.",
		BIBINGKA = "Soft and spongy.",
		CABBAGEROLLS = "The meat hides inside the cabbage to avoid predators.",
		FESTIVEFISH = "I wouldn't mind sampling some seasonal seafood.",
		GRAVY = "Meat sauce.",
		LATKES = "I could eat a latke more of these.",
		LUTEFISK = "Is there any trumpetfisk?",
		MULLEDDRINK = "This punch has a kick to it.",
		PANETTONE = "This Yuletide bread really rose to the occasion.",
		PAVLOVA = "I lova good Pavlova.",
		PICKLEDHERRING = "You won't be herring any complaints from me.",
		POLISHCOOKIE = "I'll polish off this whole plate!",
		PUMPKINPIE = "I should probably just eat the whole thing... for science.",
		ROASTTURKEY = "I see a big juicy drumstick with my name on it.",
		STUFFING = "That's the good stuff!",
		SWEETPOTATO = "Science has created a hybrid between dinner and dessert.",
		TAMALES = "If I eat much more I'm going to start feeling a bit husky.",
		TOURTIERE = "Pleased to eat you.",

		TABLE_WINTERS_FEAST =
		{
			GENERIC = "A feastival table.",
			HAS_FOOD = "Time to eat!",
			WRONG_TYPE = "It's not the season for that.",
			BURNT = "Who would do such a thing?",
		},

		GINGERBREADWARG = "Time to desert this dessert.",
		GINGERBREADHOUSE = "Room and board all rolled into one.",
		GINGERBREADPIG = "I'd better follow him.",
		CRUMBS = "A crummy way to hide yourself.",
		WINTERSFEASTFUEL = "The spirit of the season!",

        KLAUS = "What on earth is that thing!",
        KLAUS_SACK = "We should definitely open that.",
		KLAUSSACKKEY = "It's really fancy for a deer antler.",
		WORMHOLE =
		{
			GENERIC = "Soft and undulating.",
			OPEN = "Science compels me to jump in.",
		},
		WORMHOLE_LIMITED = "Guh, that thing looks worse off than usual.",
		ACCOMPLISHMENT_SHRINE = "I want to use it, and I want the world to know that I did.", --single player
		LIVINGTREE = "Is it watching me?",
		ICESTAFF = "It's cold to the touch.",
		REVIVER = "The beating of this hideous heart will bring a ghost back to life!",
		SHADOWHEART = "The power of science must have reanimated it...",
        ATRIUM_RUBBLE =
        {
			LINE_1 = "It depicts an old civilization. The people look hungry and scared.",
			LINE_2 = "This tablet is too worn to make out.",
			LINE_3 = "Something dark creeps over the city and its people.",
			LINE_4 = "The people are shedding their skins. They look different underneath.",
			LINE_5 = "It shows a massive, technologically advanced city.",
		},
        ATRIUM_STATUE = "It doesn't seem fully real.",
        ATRIUM_LIGHT =
        {
			ON = "A truly unsettling light.",
			OFF = "Something must power it.",
		},
        ATRIUM_GATE =
        {
			ON = "Back in working order.",
			OFF = "The essential components are still intact.",
			CHARGING = "It's gaining power.",
			DESTABILIZING = "The gateway is destabilizing.",
			COOLDOWN = "It needs time to recover. Me too.",
        },
        ATRIUM_KEY = "There is power emanating from it.",
		LIFEINJECTOR = "",
		SKELETON_PLAYER =
		{
			MALE = "%s cracked the bones of %s.",
			FEMALE = "%s cracked the bones of %s.",
			ROBOT = "%s  %s.",
			DEFAULT = "%s ripped %s. to shreds",
		},
		HUMANMEAT = "Flesh is flesh. Tasty.",
		HUMANMEAT_COOKED = "Interesting smell, I must have more!",
		HUMANMEAT_DRIED = "I like it fresh and moist!",
		ROCK_MOON = "Cheese?!",
		MOONROCKNUGGET = "It looks like cheese. It smells like cheese. But it is NOT CHEESE!?",
		MOONROCKCRATER = "A hole, not mine.",
		MOONROCKSEED = "Silly little rock.",

        REDMOONEYE = "Evil eye.",
        PURPLEMOONEYE = "",
        GREENMOONEYE = "",
        ORANGEMOONEYE = "",
        YELLOWMOONEYE = "",
        BLUEMOONEYE = "",

        --Arena Event
        LAVAARENA_BOARLORD = "That's the guy in charge here.",
        BOARRIOR = "You sure are big!",
        BOARON = "I can take him!",
        PEGHOOK = "That spit is corrosive!",
        TRAILS = "He's got a strong arm on him.",
        TURTILLUS = "Its shell is so spiky!",
        SNAPPER = "This one's got bite.",
		RHINODRILL = "He's got a nose for this kind of work.",
		BEETLETAUR = "I can smell him from here!",

        LAVAARENA_PORTAL =
        {
            ON = "I'll just be going now.",
            GENERIC = "That's how we got here. Hopefully how we get back, too.",
        },
        LAVAARENA_KEYHOLE = "It needs a key.",
		LAVAARENA_KEYHOLE_FULL = "That should do it.",
        LAVAARENA_BATTLESTANDARD = "Everyone, break the Battle Standard!",
        LAVAARENA_SPAWNER = "This is where those enemies are coming from.",

        HEALINGSTAFF = "It conducts regenerative energy.",
        FIREBALLSTAFF = "It calls a meteor from above.",
        HAMMER_MJOLNIR = "It's a heavy hammer for hitting things.",
        SPEAR_GUNGNIR = "I could do a quick charge with that.",
        BLOWDART_LAVA = "That's a weapon I could use from range.",
        BLOWDART_LAVA2 = "It uses a strong blast of air to propel a projectile.",
        LAVAARENA_LUCY = "That weapon's for throwing.",
        WEBBER_SPIDER_MINION = "I guess they're fighting for us.",
        BOOK_FOSSIL = "This'll keep those monsters held for a little while.",
		LAVAARENA_BERNIE = "He might make a good distraction for us.",
		SPEAR_LANCE = "It gets to the point.",
		BOOK_ELEMENTAL = "I can't make out the text.",
		LAVAARENA_ELEMENTAL = "It's a rock monster!",

   		LAVAARENA_ARMORLIGHT = "Light, but not very durable.",
		LAVAARENA_ARMORLIGHTSPEED = "Lightweight and designed for mobility.",
		LAVAARENA_ARMORMEDIUM = "It offers a decent amount of protection.",
		LAVAARENA_ARMORMEDIUMDAMAGER = "That could help me hit a little harder.",
		LAVAARENA_ARMORMEDIUMRECHARGER = "I'd have energy for a few more stunts wearing that.",
		LAVAARENA_ARMORHEAVY = "That's as good as it gets.",
		LAVAARENA_ARMOREXTRAHEAVY = "This armor has been petrified for maximum protection.",

		LAVAARENA_FEATHERCROWNHAT = "Those fluffy feathers make me want to run!",
        LAVAARENA_HEALINGFLOWERHAT = "The blossom interacts well with healing magic.",
        LAVAARENA_LIGHTDAMAGERHAT = "My strikes would hurt a little more wearing that.",
        LAVAARENA_STRONGDAMAGERHAT = "It looks like it packs a wallop.",
        LAVAARENA_TIARAFLOWERPETALSHAT = "Looks like it amplifies healing expertise.",
        LAVAARENA_EYECIRCLETHAT = "It has a gaze full of science.",
        LAVAARENA_RECHARGERHAT = "Those crystals will quicken my abilities.",
        LAVAARENA_HEALINGGARLANDHAT = "This garland will restore a bit of my vitality.",
        LAVAARENA_CROWNDAMAGERHAT = "That could cause some major destruction.",

		LAVAARENA_ARMOR_HP = "That should keep me safe.",

		LAVAARENA_FIREBOMB = "It smells like brimstone.",
		LAVAARENA_HEAVYBLADE = "A sharp looking instrument.",

        --Quagmire
        QUAGMIRE_ALTAR =
        {
        	GENERIC = "Is that where we put the meals?",
        	FULL = "Hey, but what if I still want it.",
    	},
		QUAGMIRE_ALTAR_STATUE1 = "It is very grotesque",
		QUAGMIRE_PARK_FOUNTAIN = "This would look nice in Rat-Town.",

        QUAGMIRE_HOE = "My claws work just as well.",

        QUAGMIRE_TURNIP = "It's a raw turnip.",
        QUAGMIRE_TURNIP_COOKED = "Cooking is science in practice.",
        QUAGMIRE_TURNIP_SEEDS = "A handful of odd seeds.",

        QUAGMIRE_GARLIC = "The number one breath enhancer.",
        QUAGMIRE_GARLIC_COOKED = "Perfectly browned.",
        QUAGMIRE_GARLIC_SEEDS = "A handful of odd seeds.",

        QUAGMIRE_ONION = "Looks crunchy.",
        QUAGMIRE_ONION_COOKED = "A successful chemical reaction.",
        QUAGMIRE_ONION_SEEDS = "A handful of odd seeds.",

        QUAGMIRE_POTATO = "The apples of the earth.",
        QUAGMIRE_POTATO_COOKED = "A successful temperature experiment.",
        QUAGMIRE_POTATO_SEEDS = "A handful of odd seeds.",

        QUAGMIRE_TOMATO = "It's red because it's full of science.",
        QUAGMIRE_TOMATO_COOKED = "Cooking's easy if you understand chemistry.",
        QUAGMIRE_TOMATO_SEEDS = "A handful of odd seeds.",

        QUAGMIRE_FLOUR = "Bland tasting dust.",
        QUAGMIRE_WHEAT = "They make for a good meal.",
        QUAGMIRE_WHEAT_SEEDS = "A handful of odd seeds.",
        --NOTE: raw/cooked carrot uses regular carrot strings
        QUAGMIRE_CARROT_SEEDS = "A handful of odd seeds.",

        QUAGMIRE_ROTTEN_CROP = "I don't think the altar will want that.",

		QUAGMIRE_SALMON = "Mm, fresh fish.",
		QUAGMIRE_SALMON_COOKED = "Ready for the dinner table.",
		QUAGMIRE_CRABMEAT = "No imitations here.",
		QUAGMIRE_CRABMEAT_COOKED = "I can put a meal together in a pinch.",
		QUAGMIRE_SUGARWOODTREE =
		{
			GENERIC = "It's full of delicious, delicious sap.",
			STUMP = "Where'd the tree go? I'm stumped.",
			TAPPED_EMPTY = "Here sappy, sappy, sap.",
			TAPPED_READY = "Sweet golden sap.",
			TAPPED_BUGS = "That's how you get ants.",
			WOUNDED = "It looks ill.",
		},
		QUAGMIRE_SPOTSPICE_SHRUB =
		{
			GENERIC = "It reminds me of those tentacle monsters.",
			PICKED = "I can't get anymore out of that shrub.",
		},
		QUAGMIRE_SPOTSPICE_SPRIG = "I could grind it up to make a spice.",
		QUAGMIRE_SPOTSPICE_GROUND = "Flavorful.",
		QUAGMIRE_SAPBUCKET = "We can use it to gather sap from the trees.",
		QUAGMIRE_SAP = "It tastes sweet.",
		QUAGMIRE_SALT_RACK =
		{
			READY = "Salt has gathered on the rope.",
			GENERIC = "Science takes time.",
		},

		QUAGMIRE_POND_SALT = "A little salty spring.",
		QUAGMIRE_SALT_RACK_ITEM = "For harvesting salt from the pond.",

		QUAGMIRE_SAFE =
		{
			GENERIC = "It's a safe. For keeping things safe.",
			LOCKED = "It won't open without the key.",
		},

		QUAGMIRE_KEY = "Safe bet this'll come in handy.",
		QUAGMIRE_KEY_PARK = "I'll park it in my pocket until I get to the park.",
        QUAGMIRE_PORTAL_KEY = "This looks science-y.",


		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "Are those mushrooms? I'm stumped.",
			PICKED = "I don't think it's growing back.",
		},
		QUAGMIRE_MUSHROOMS = "These are edible mushrooms.",
        QUAGMIRE_MEALINGSTONE = "The daily grind.",
		QUAGMIRE_PEBBLECRAB = "That rock's alive!",


		QUAGMIRE_RUBBLE_CARRIAGE = "On the road to nowhere.",
        QUAGMIRE_RUBBLE_CLOCK = "Someone beat the clock. Literally.",
        QUAGMIRE_RUBBLE_CATHEDRAL = "Preyed upon.",
        QUAGMIRE_RUBBLE_PUBDOOR = "No longer a-door-able.",
        QUAGMIRE_RUBBLE_ROOF = "Someone hit the roof.",
        QUAGMIRE_RUBBLE_CLOCKTOWER = "That clock's been punched.",
        QUAGMIRE_RUBBLE_BIKE = "Must have mis-spoke.",
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "No one's here.",
            "Something destroyed this town.",
            "I wonder who they angered.",
        },
        QUAGMIRE_RUBBLE_CHIMNEY = "Something put a damper on that chimney.",
        QUAGMIRE_RUBBLE_CHIMNEY2 = "Something put a damper on that chimney.",
        QUAGMIRE_MERMHOUSE = "What an ugly little house.",
        QUAGMIRE_SWAMPIG_HOUSE = "It's seen better days.",
        QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "Some pig's house was ruined.",
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "I guess you're in charge around here?",
            SLEEPING = "It's sleeping, for now.",
        },
        QUAGMIRE_SWAMPIG = "It's a super hairy pig.",

        QUAGMIRE_PORTAL = "Another dead end.",
        QUAGMIRE_SALTROCK = "Salt. The tastiest mineral.",
        QUAGMIRE_SALT = "It's full of salt.",
        --food--
        QUAGMIRE_FOOD_BURNT = "That one was an experiment.",
        QUAGMIRE_FOOD =
        {
        	GENERIC = "I should offer it on the Altar of Gnaw.",
            MISMATCH = "That's not what it wants.",
            MATCH = "Science says this will appease the sky God.",
            MATCH_BUT_SNACK = "It's more of a light snack, really.",
        },

        QUAGMIRE_FERN = "Probably chock full of vitamins.",
        QUAGMIRE_FOLIAGE_COOKED = "We cooked the foliage.",
        QUAGMIRE_COIN1 = "I'd like more than a penny for my thoughts.",
        QUAGMIRE_COIN2 = "A decent amount of coin.",
        QUAGMIRE_COIN3 = "Seems valuable.",
        QUAGMIRE_COIN4 = "We can use these to reopen the Gateway.",
        QUAGMIRE_GOATMILK = "Good if you don't think about where it came from.",
        QUAGMIRE_SYRUP = "Adds sweetness to the mixture.",
        QUAGMIRE_SAP_SPOILED = "Might as well toss it on the fire.",
        QUAGMIRE_SEEDPACKET = "Sow what?",

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
        	OFF = "Kick it so it starts working.",
        	BURNING = "Huh? that is not right.",
        	BURNT = "Now it really is broken haha!",
        },
        WINONA_SPOTLIGHT =
        {
        	GENERIC = "Looking at it hurts my eyes!",
        	OFF = "Kick it so it starts working.",
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
        TRAP_BRAMBLE = "It's like a spring but deadly.",

        BOATFRAGMENT03 = "I am happy that wasn't me.",
        BOATFRAGMENT04 = "I am happy that wasn't me.",
        BOATFRAGMENT05 = "I am happy that wasn't me.",
		BOAT_LEAK = "Aaah When did that happen!?",
        MAST = "I should get many rats to blow on it.",
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
        	GENERIC = "It is like a bug, but blue. Bugs are not normally blue.",
        	HELD = "You are like a tiny voice.",
        },
		MOONBUTTERFLYWINGS = "Glassy crunchy wings.",
        MOONBUTTERFLY_SAPLING = "At least it is not fat.",
        ROCK_AVOCADO_FRUIT = "Rocks are not food.",
        ROCK_AVOCADO_FRUIT_RIPE = "Oh, I had to smash it.",
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "",
        ROCK_AVOCADO_FRUIT_SPROUT = ".",
        ROCK_AVOCADO_BUSH =
        {
        	BARREN = "Crooked...",
			WITHERED = "Drier than dirt.",
			GENERIC = "It is odd looking.",
			PICKED = "Find new bush.",
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
        MOONGLASS_CHARGED = "",
        MOONGLASS_ROCK = "",
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
            HELD = "Why do they call you that \"puff in?\".",
            SLEEPING = "Honk shuuu...",
        },

		MOONGLASSAXE = "Not very good for smashing.",
		GLASSCUTTER = "It has teeth, like me!",

        ICEBERG =
        {
            GENERIC = "Hard water on water.", --unimplemented
            MELTED = "It is water.. again.", --unimplemented
        },
        ICEBERG_MELTED = "It is water.. again.", --unimplemented

        MINIFLARE = "Blinding stick.",

		MOON_FISSURE =
		{
			GENERIC = "I like to stare at it...",
			NOLIGHT = "A crater hole.",
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "Yes, I will make you good!",
            GENERIC = "",
        },

        MOON_ALTAR_IDOL = "I feel compelled to carry it somewhere.",
        MOON_ALTAR_GLASS = "It doesn't want to be on the ground.",
        MOON_ALTAR_SEED = "It wants me to give it a home.",

        MOON_ALTAR_ROCK_IDOL = "There's something trapped inside.",
        MOON_ALTAR_ROCK_GLASS = "There's something trapped inside.",
        MOON_ALTAR_ROCK_SEED = "There's something trapped inside.",

        MOON_ALTAR_CROWN = "I fished it up, now to find a fissure!",
        MOON_ALTAR_COSMIC = "It feels like it's waiting for something.",

        MOON_ALTAR_ASTRAL = "It seems to be part of a larger mechanism.",
        MOON_ALTAR_ICON = "I think I know just where you belong.",
        MOON_ALTAR_WARD = "It wants to be with the others.",

        SEAFARING_PROTOTYPER =
        {
            GENERIC = "Helping me learn about why I hate being wet.",
            BURNT = "No more learning. Good.",
        },
        BOAT_ITEM = ".",
        STEERINGWHEEL_ITEM = "",
        ANCHOR_ITEM = ".",
        MAST_ITEM = ".",
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
		COOKIECUTTERHAT = "Fancy hat for Winky!",
		SALTSTACK =
		{
			GENERIC = "Mmmm, seems like good thing.",
			MINED_OUT = "Broken now?",
			GROWING = "It is becoming taller.",
		},
		SALTROCK = "I lick each one, so it is mine!",
		SALTBOX = "You food the salt?",

		TACKLESTATION = "It .",
		TACKLESKETCH = "A picture of some fishing tackle. I bet I could make this...",

        MALBATROSS = "",
        MALBATROSS_FEATHER = "",
        MALBATROSS_BEAK = "Now I can be a duck, /Quack! Quack!/",
        MAST_MALBATROSS_ITEM = "",
        MAST_MALBATROSS = "",
		MALBATROSS_FEATHERED_WEAVE = "",

        GNARWAIL =
        {
            GENERIC = "Hey, get away from me!",
            BROKENHORN = "Your Stabbing part gone!",
            FOLLOWER = "He likes me now?",
            BROKENHORN_FOLLOWER = "You are not useful, but funny to look at.",
        },
        GNARWAIL_HORN = "Stabber!! AHAHA!",

        WALKINGPLANK = "I am a PiRATe now haha-HA!",
        OAR = "",
		OAR_DRIFTWOOD = "",

		OCEANFISHINGROD = "Now this is the reel deal!",
		OCEANFISHINGBOBBER_NONE = "A bobber might improve its accuracy.",
        OCEANFISHINGBOBBER_BALL = "The fish will have a ball with this.",
        OCEANFISHINGBOBBER_OVAL = "Those fish won't give me the slip this time!",
		OCEANFISHINGBOBBER_CROW = "I'd rather eat fish than crow.",
		OCEANFISHINGBOBBER_ROBIN = "Hopefully it won't attract any red herrings.",
		OCEANFISHINGBOBBER_ROBIN_WINTER = "The snowbird quill helps me stay frosty.",
		OCEANFISHINGBOBBER_CANARY = "Say y'ello to my little friend!",
		OCEANFISHINGBOBBER_GOOSE = "You're going down, fish!",
		OCEANFISHINGBOBBER_MALBATROSS = "Where there's a quill, there's a way.",

		OCEANFISHINGLURE_SPINNER_RED = "Some fish might find this a-luring!",
		OCEANFISHINGLURE_SPINNER_GREEN = "Some fish might find this a-luring!",
		OCEANFISHINGLURE_SPINNER_BLUE = "Some fish might find this a-luring!",
		OCEANFISHINGLURE_SPOON_RED = "Some smaller fish might find this a-luring!",
		OCEANFISHINGLURE_SPOON_GREEN = "Some smaller fish might find this a-luring!",
		OCEANFISHINGLURE_SPOON_BLUE = "Some smaller fish might find this a-luring!",
		OCEANFISHINGLURE_HERMIT_RAIN = "Soaking myself might help me think like a fish...",
		OCEANFISHINGLURE_HERMIT_SNOW = "The fish won't snow what hit them!",
		OCEANFISHINGLURE_HERMIT_DROWSY = "My brain is protected by a thick layer of hard science!",
		OCEANFISHINGLURE_HERMIT_HEAVY = "This feels a bit heavy handed.",

		OCEANFISH_SMALL_1 = "Looks like the runt of its school.",
		OCEANFISH_SMALL_2 = "I won't win any bragging rights with this one.",
		OCEANFISH_SMALL_3 = "It's a bit on the small side.",
		OCEANFISH_SMALL_4 = "A fish this size won't tide me over for long.",
		OCEANFISH_SMALL_5 = "I can't wait to pop it in my mouth.",
		OCEANFISH_SMALL_6 = "You have to sea it to beleaf it.",
		OCEANFISH_SMALL_7 = "I finally caught this bloomin' fish!",
		OCEANFISH_SMALL_8 = "It's a scorcher!",
        OCEANFISH_SMALL_9 = "Just spit-balling, but I might have a use for you...",

		OCEANFISH_MEDIUM_1 = "I certainly hope it tastes better than it looks.",
		OCEANFISH_MEDIUM_2 = "I went to a lot of treble to catch it.",
		OCEANFISH_MEDIUM_3 = "I wasn't lion about my aptitude for fishing!",
		OCEANFISH_MEDIUM_4 = "I'm sure this won't bring me any bad luck.",
		OCEANFISH_MEDIUM_5 = "This one seems kind of corny.",
		OCEANFISH_MEDIUM_6 = "Now that's the real McKoi!",
		OCEANFISH_MEDIUM_7 = "Now that's the real McKoi!",
		OCEANFISH_MEDIUM_8 = "Ice bream, youse bream.",
        OCEANFISH_MEDIUM_9 = "That's the sweet smell of a successful fishing trip.",

		PONDFISH = ".",
		PONDEEL = "",

        FISHMEAT = "Good to eat it whole.",
        FISHMEAT_COOKED = "Smells nice, but I prefer it slimey.",
        FISHMEAT_SMALL = "Little chunk, I can eat it in one bite.",
        FISHMEAT_SMALL_COOKED = "Smells nice, but I prefer it slimey.",
		SPOILED_FISH = "Very intriguing odor, very pungent. I like this.",

		FISH_BOX = "",
        POCKET_SCALE = "The arrow moves when I pull the hook.",

		TACKLECONTAINER = "!",
		SUPERTACKLECONTAINER = "",

		TROPHYSCALE_FISH =
		{
			GENERIC = "!",
			HAS_ITEM = "Weight: {weight}\nCaught by: {owner}",
			HAS_ITEM_HEAVY = "Weight: {weight}\nCaught by: {owner}\nWhat a catch!",
			BURNING = "",
			BURNT = "!",
			OWNER = "Not to throw my weight around, buuut...\nWeight: {weight}\nCaught by: {owner}",
			OWNER_HEAVY = "Weight: {weight}\nCaught by: {owner}\nIt's the one that DIDN'T get away!",
		},

		OCEANFISHABLEFLOTSAM = "A little mud island.",

		CALIFORNIAROLL = "More of these are needed, they are too small.",
		SEAFOODGUMBO = ".",
		SURFNTURF = "I must eat every creature.",

        WOBSTER_SHELLER = "It is fun to play with your food.",
        WOBSTER_DEN = "Stupid rock.",
        WOBSTER_SHELLER_DEAD = "He is dead and smelly.",
        WOBSTER_SHELLER_DEAD_COOKED = "I will crack you up and eat you.",

        LOBSTERBISQUE = ".",
        LOBSTERDINNER = "?",

        WOBSTER_MOONGLASS = "",
        MOONGLASS_WOBSTER_DEN = "Stupid rock and stupid glass on it.",

		TRIDENT = "",

		WINCH =
		{
			GENERIC = "It'll do in a pinch.",
			RETRIEVING_ITEM = "I'll let it do the heavy lifting.",
			HOLDING_ITEM = "What do we have here?",
		},

        HERMITHOUSE = {
            GENERIC = "That is sad, and ugly!",
            BUILTUP = ".",
        },

        SHELL_CLUSTER = "It looks appealing all gooed together.",
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

        CHUM = "",

        SUNKENCHEST =
        {
            GENERIC = "The real treasure is the treasure we found along the way.",
            LOCKED = "It's clammed right up!",
        },

        HERMIT_BUNDLE = "A stupid gift, and it is my stupid gift.",
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
		WALTERHAT = "It looks like a stupid hat.",
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
        BATTLESONG_INSTANT_PANIC = "I can't say I'm very scared.",

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
        SPICE_CHILI = "Food tastes like nothing with it.",
        SPICE_SALT = "Fine as it is.",
        MONSTERTARTARE = "It smells, very, very good!",
        FRESHFRUITCREPES = ".",
        FROGFISHBOWL = "Oooo slime bowl, very yummy!",
        POTATOTORNADO = "Is it full of air?",
        DRAGONCHILISALAD = "euch.. Cough. Cough. It is too much.",
        GLOWBERRYMOUSSE = "Berry, but mushed.",
        VOLTGOATJELLY = "Gummy slime.",
        NIGHTMAREPIE = "I should throw it... hehe.",
        BONESOUP = "Bones make for the most delicious food.",
        MASHEDPOTATOES = "Mashy.",
        POTATOSOUFFLE = "Potato-soufflay? What does that even mean.",
        MOQUECA = "Fishy, fishy, My belly is your new homey!",
        GAZPACHO = "It is how you say refreshing.",
        ASPARAGUSSOUP = "Smelling better and tasty.",
        VEGSTINGER = "Oooh! What a powerful taste.",
        BANANAPOP = "Cruncy and banana-y.",
        CEVICHE = "Ice but tastier.",
        SALSA = "I have heard It will make me toot.",
        PEPPERPOPPER = "Food for rhyming.",

        TURNIP = "I suppose it had to turn up somehow.",
        TURNIP_COOKED = "Very bland smelling, and tasting.",
        TURNIP_SEEDS = "Crunchy little bits.",

        GARLIC = "Sometimes I eat to many and throw up afterwards.",
        GARLIC_COOKED = "How delcious!",
        GARLIC_SEEDS = "Crunchy little bits.",

        ONION = "Very Juicy, I must have more.",
        ONION_COOKED = "Delightful pungent aroma I am smelling.",
        ONION_SEEDS = "Crunchy little bits.",

        POTATO = "It is very hard to chew through.",
        POTATO_COOKED = "Ooo cooking makes it softer I see.",
        POTATO_SEEDS = "Crunchy little bits.",

        TOMATO = "Squishy and full of juice, how wonderful!",
        TOMATO_COOKED = "Now it is a bit crispy too.",
        TOMATO_SEEDS = "Crunchy little bits.",

        ASPARAGUS = "dry and crunchy, but it is nice.",
        ASPARAGUS_COOKED = ".",
        ASPARAGUS_SEEDS = "Crunchy little bits.",

        PEPPER = "How decieving, it does not smell hot until you bite it!",
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

        MERMWATCHTOWER_REGULAR = "Very... Patriotic?",
        MERMWATCHTOWER_NOKING = "They are sad now, and smelly, and stupid.",
        MERMKING = "He smells. Smells bad! Ha Ha HA!",
        MERMGUARD = "You are all wrapped up in yourself.",
        MERM_PRINCE = "What are you waiting for?",

        SQUID = "Spatty little inky thing.",

		GHOSTFLOWER = "Not real flower.",
        SMALLGHOST = "Ew. get away. No time for you!",

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
			NOHONEY = "Make More.",
			SOMEHONEY = "Ooh, I see some!",
			BURNT = "Grumble... It WAS NOT ME.",
        },

        HERMITCRAB = "Guh, I do not like being near her.",

        HERMIT_PEARL = "Yes, yes I am trustworthy with this, yes!",
        HERMIT_CRACKED_PEARL = "Aaaaa It is ruined now! It was perfect!",

        -- DSEAS
        WATERPLANT = "Give me your rock food.",
        WATERPLANT_BOMB = "Squeak!",
        WATERPLANT_BABY = "We should RIP! it out now.",
        WATERPLANT_PLANTER = "Ugly looking rocks.",

        SHARK = "No, No, I want OFF!!",

        MASTUPGRADE_LAMP_ITEM = "What if it starts burning everything, then what?",
        MASTUPGRADE_LIGHTNINGROD_ITEM = "It is useless like this.",

        WATERPUMP = "all this pumping, and for what? Something it is all around?",

        BARNACLE = "Crack it open.",
        BARNACLE_COOKED = "I am on a see food diet now.",

        BARNACLEPITA = "Barnacles taste better when you can't see them.",
        BARNACLESUSHI = "I still seem to have misplaced my chopsticks.",
        BARNACLINGUINE = "Pass the pasta!",
        BARNACLESTUFFEDFISHHEAD = "I'm just hungry enough to consider it...",

        LEAFLOAF = "It is looking most appetizing.",
        LEAFYMEATBURGER = "Tastes like a fresh beast. I thought it was imitation?",
        LEAFYMEATSOUFFLE = "",
        MEATYSALAD = "I do not like leafs, BUT! These are very good for some reason.",

        -- GROTTO

		MOLEBAT = "We are NOT related you ugly, stupid thing.",
        MOLEBATHILL = "There better not be any of my things in there.",

        BATNOSE = "Usually it is the snot that tastes better.",
        BATNOSE_COOKED = "I wonder if it can still smell.",
        BATNOSEHAT = "Eat and steal on the go.",

        MUSHGNOME = "What a dopey thing! It is very funny.",

        SPORE_MOON = "/AGH!/ I did not expect them to POP!",

        MOON_CAP = "It is a mushroom what is the difference?",
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

        ARCHIVE_SECURITY_PULSE = "",

        ARCHIVE_SWITCH = {
            VALID = "Those gems seem to power it... through entirely scientific means, I'm sure.",
            GEMS = "The socket is empty.",
        },

        ARCHIVE_PORTAL = {
            POWEROFF = "Something strange on the floor.",
            GENERIC = "Maybe it is broken.",
        },

        WALL_STONE_2 = "Old.",
        WALL_RUINS_2 = "Boring wall.",

        REFINED_DUST = "Little cubes, I am not sure if this is food?",
        DUSTMERINGUE = "It is crunchy. Yes, I ate one.",

        SHROOMCAKE = "Desert. For me and no one else.",

        NIGHTMAREGROWTH = "",

        TURFCRAFTINGSTATION = "Grinding up rocks into nice smooth flat land.",

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
			SPOILED = "Bleugh, this smell I do not like.",
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
		FARM_PLOW_ITEM = "Better not put it over any Rat-homes.",
		FARM_HOE = "If you wanted to dig a hole, you could've asked.",
		GOLDEN_FARM_HOE = "I see how it is... My claws aren't good enough?",
		NUTRIENTSGOGGLESHAT = "I did not know I needed a fresh pair of eyes.",
		PLANTREGISTRYHAT = "I thought my eyes could see dirt good, I was wrong.",

        FARM_SOIL_DEBRIS = "I'll have a rat take it away.",

		FIRENETTLES = "You had given me blisters before.",
		FORGETMELOTS = "When did you get there?",
		SWEETTEA = "It is hot leaf water.",
		TILLWEED = "It looks tasty.",
		TILLWEEDSALVE = "It is good for rubbing into my fur.",
        WEED_IVY = "Hey, I do not think you were planted there.",
        IVY_SNARE = "/SQUEAK!/",

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
        EGGPLANT_OVERSIZED = "It is very purple.",
        DURIAN_OVERSIZED = "It /REEKS./ How Wonderful!",
        POMEGRANATE_OVERSIZED = "It has tougher skin now.",
        DRAGONFRUIT_OVERSIZED = ".",
        WATERMELON_OVERSIZED = "The seeds must be bigger than a rat!",
        TOMATO_OVERSIZED = "I don't think that will fit in a Rat-hole.",
        POTATO_OVERSIZED = "It is like a big earth rock.",
        ASPARAGUS_OVERSIZED = "",
        ONION_OVERSIZED = "",
        GARLIC_OVERSIZED = "What a wonderful smell!",
        PEPPER_OVERSIZED = "",

        VEGGIE_OVERSIZED_ROTTEN = "Mmm We can take that off your hands if you want.",

		FARM_PLANT =
		{
			GENERIC = "That's a plant!",
			SEED = ".",
			GROWING = "",
			FULL = "",
			ROTTEN = "Drat! If only I'd picked it while I had the chance!",
			FULL_OVERSIZED = "With the power of science, I've produced monstrous produce!",
			ROTTEN_OVERSIZED = "What rotten luck.",
			FULL_WEED = "I knew I'd weed out the imposter eventually!",

			BURNING = "",
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
		CARNIVALGAME_FEEDCHICKS_KIT = "/\"Fun and games\"/ until I eat the worms.",
		CARNIVALGAME_FEEDCHICKS_FOOD = "Wait... fake food?",

		CARNIVALGAME_MEMORY_KIT = "Pointless.",
		CARNIVALGAME_MEMORY_STATION =
		{
			GENERIC = "It won't let me play until I give it something shiny.",
			PLAYING = "Not to brag, but I've been called a bit of an egghead in the past.",
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

		CARNIVAL_PRIZEBOOTH_KIT = "The real prize is the booth we made along the way.",
		CARNIVAL_PRIZEBOOTH =
		{
			GENERIC = "I've got my eyes on the prize. That one, over there!",
		},

		CARNIVALCANNON_KIT = "I've got a lot of experience in making things explode.",
		CARNIVALCANNON =
		{
			GENERIC = "This experiment blows up on purpose!",
			COOLDOWN = "What a blast!",
		},

		CARNIVAL_PLAZA_KIT = "It's a scientifically proven fact that birds love trees.",
		CARNIVAL_PLAZA =
		{
			GENERIC = "It doesn't really scream \"Cawnival\" yet, does it?",
			LEVEL_2 = "A little birdy told me it could use some more decorations around here.",
			LEVEL_3 = "This tree is caws for celebration!",
		},

		CARNIVALDECOR_EGGRIDE_KIT = "I hope this prize is all it's cracked up to be.",
		CARNIVALDECOR_EGGRIDE = "I could watch it for hours.",

		CARNIVALDECOR_LAMP_KIT = "Only some light work left to do.",
		CARNIVALDECOR_LAMP = "It's powered by whimsy.",
		CARNIVALDECOR_PLANT_KIT = "Maybe it's a boxwood?",
		CARNIVALDECOR_PLANT = "Either it's small, or I'm gigantic.",

		CARNIVALDECOR_FIGURE =
		{
			RARE = "See? Proof that trying the exact same thing over and over will eventually lead to success!",
			UNCOMMON = "You don't see this kind of design too often.",
			GENERIC = "I seem to be getting a lot of these...",
		},
		CARNIVALDECOR_FIGURE_KIT = "The thrill of discovery!",

        CARNIVAL_BALL = "It's genius in its simplicity.", --unimplemented
		CARNIVAL_SEEDPACKET = "I was feeling a bit peckish.",
		CARNIVALFOOD_CORNTEA = "Is this drink supposed to be crunchy?",

        CARNIVAL_VEST_A = "I think it makes me look adventurous.",
        CARNIVAL_VEST_B = "It's like wearing my own shade tree.",
        CARNIVAL_VEST_C = "I hope there's no bugs in it...",

        -- YOTB
        YOTB_SEWINGMACHINE = "Sewing can't be that hard... can it?",
        YOTB_SEWINGMACHINE_ITEM = "There looks to be a bit of assembly required.",
        YOTB_STAGE = "Strange, I never see him enter or leave...",
        YOTB_POST =  "This contest is going to go off without a hitch! Well, figuratively speaking.",
        YOTB_STAGE_ITEM = "It looks like a bit of building is in order.",
        YOTB_POST_ITEM =  "I'd better get that set up.",


        YOTB_PATTERN_FRAGMENT_1 = "If I put some of these together, I bet I could make a beefalo costume.",
        YOTB_PATTERN_FRAGMENT_2 = "If I put some of these together, I bet I could make a beefalo costume.",
        YOTB_PATTERN_FRAGMENT_3 = "If I put some of these together, I bet I could make a beefalo costume.",

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

        WAR_BLUEPRINT = "How ferocious!",
        DOLL_BLUEPRINT = "My beefalo will look as cute as a button!",
        FESTIVE_BLUEPRINT = "This is just the occasion for some festivity!",
        ROBOT_BLUEPRINT = "This requires a suspicious amount of welding for a sewing project.",
        NATURE_BLUEPRINT = "You really can't go wrong with flowers.",
        FORMAL_BLUEPRINT = "This is a costume for some Grade A beefalo.",
        VICTORIAN_BLUEPRINT = "I think my grandmother wore something similar.",
        ICE_BLUEPRINT = "I usually like my beefalo fresh, not frozen.",
        BEAST_BLUEPRINT = "I'm feeling lucky about this one!",

        BEEF_BELL = "It makes beefalo friendly. I'm sure there's a very scientific explanation.",

		-- YOT Catcoon
		KITCOONDEN = 
		{
			GENERIC = "You'd have to be pretty small to fit in there.",
            BURNT = "NOOOO!",
			PLAYING_HIDEANDSEEK = "Now where could they be...",
			PLAYING_HIDEANDSEEK_TIME_ALMOST_UP = "Not much time left! Where are they?!",
		},

		KITCOONDEN_KIT = "The whole kit and caboodle.",

		TICOON = 
		{
			GENERIC = "He looks like he knows what he's doing!",
			ABANDONED = "I'm sure I can find them on my own.",
			SUCCESS = "Hey, he found one!",
			LOST_TRACK = "Someone else found them first.",
			NEARBY = "Looks like there's something nearby.",
			TRACKING = "I should follow his lead.",
			TRACKING_NOT_MINE = "He's leading the way for someone else.",
			NOTHING_TO_TRACK = "It doesn't look like there's anything left to find.",
			TARGET_TOO_FAR_AWAY = "They might be too far away for him to sniff out.",
		},
		
		YOT_CATCOONSHRINE =
        {
            GENERIC = "What to make...",
            EMPTY = "Maybe it would like a feather to play with...",
            BURNT = "Smells like scorched fur.",
        },

		KITCOON_FOREST = "Aren't you the cutest little cat thing!",
		KITCOON_SAVANNA = "Aren't you the cutest little cat thing!",
		KITCOON_MARSH = "I must collect more... for research!",
		KITCOON_DECIDUOUS = "Aren't you the cutest little cat thing!",
		KITCOON_GRASS = "Aren't you the cutest little cat thing!",
		KITCOON_ROCKY = "I must collect more... for research!",
		KITCOON_DESERT = "I must collect more... for research!",
		KITCOON_MOON = "I must collect more... for research!",
		KITCOON_YOT = "I must collect more... for research!",

        -- Moon Storm
        ALTERGUARDIAN_PHASE1 = {
            GENERIC = "You'll pay for breaking all that science!",
            DEAD = "Gotcha!",
        },
        ALTERGUARDIAN_PHASE2 = {
            GENERIC = "I think I just made it angry...",
            DEAD = "This time I'm sure I got it.",
        },
        ALTERGUARDIAN_PHASE2SPIKE = "You've made your point!",
        ALTERGUARDIAN_PHASE3 = "It's definitely angry now!",
        ALTERGUARDIAN_PHASE3TRAP = "After rigorous testing, I can confirm that they make me want to take a nap.",
        ALTERGUARDIAN_PHASE3DEADORB = "Is it dead? That strange energy still seems to be lingering around it.",
        ALTERGUARDIAN_PHASE3DEAD = "Maybe someone should go poke it... just to be sure.",

        ALTERGUARDIANHAT = "It shows me infinite possibilities...",
        ALTERGUARDIANHATSHARD = "Even a single piece is pretty illuminating!",

        MOONSTORM_GLASS = {
            GENERIC = "It's glassy.",
            INFUSED = "It's glowing with unearthly energy."
        },

        MOONSTORM_STATIC = "A new discovery, how electrifying!",
        MOONSTORM_STATIC_ITEM = "It makes my hair do crazy things.",
        MOONSTORM_SPARK = "I think I'll call it the \"Higgsbury Particle.\"",

        BIRD_MUTANT = "I think that used to be a crow.",
        BIRD_MUTANT_SPITTER = "I don't like the way it's looking at me...",

        WAGSTAFF_NPC = "As a fellow man of science, I'm compelled to help him!",
        ALTERGUARDIAN_CONTAINED = "It's draining the energy right out of that monster!",

        WAGSTAFF_TOOL_1 = "That has to be the tool I'm looking for!",
        WAGSTAFF_TOOL_2 = "Of course I know what it is! It's just, er... too complicated to explain.",
        WAGSTAFF_TOOL_3 = "Clearly a very scientific tool!",
        WAGSTAFF_TOOL_4 = "My scientific instincts tell me that this is the tool I'm looking for!",
        WAGSTAFF_TOOL_5 = "I know exactly what it does! Science!",

        MOONSTORM_GOGGLESHAT = "Of course! Combining moon energy with potato energy, why didn't I think of that?",

        MOON_DEVICE = {
            GENERIC = "It's containing the energy! I knew what it was for all along, of course.",
            CONSTRUCTION1 = "The science has only just started.",
            CONSTRUCTION2 = "That's looking much more science-y already!",
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
            ENABLED = "Oooo, very nice, I might go blind staring at it.",
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
        EYEOFTERROR_MINI = "I will put you in the ground, ugly.",
        EYEOFTERROR_MINI_GROUNDED = "Go back in I don't want you out here!",

        FROZENBANANADAIQUIRI = "Yellow paste is quite good.",
        BUNNYSTEW = "Ha ha ha, this is what you get!",
        MILKYWHITES = "Yum!",

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
    },

    DESCRIBE_GENERIC = "Never have I seen a.... This...",
    DESCRIBE_TOODARK = "Aaaah What? I cannot see?",
    DESCRIBE_SMOLDERING = "Oh no! It is smoking!",

    DESCRIBE_PLANTHAPPY = "The plant is smiling, I think.",
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

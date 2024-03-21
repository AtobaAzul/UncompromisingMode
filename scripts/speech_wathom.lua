
return{
	ACTIONFAIL =
	{
        APPRAISE =
        {
            NOTNOW = "Give attention.",
        },
        REPAIR =
        {
            WRONGPIECE = "No, wrong.",
        },
        BUILD =
        {
            MOUNTED = "Need, get down.",
            HASPET = "Enough noise around.",
			TICOON = "Enough noise around.",
        },
		SHAVE =
		{
			AWAKEBEEFALO = "I like un-concaved face.",
			GENERIC = "No.",
			NOBITS = "Not best way, taking meat.",
--fallback to speech_wilson.lua             REFUSE = "only_used_by_woodie",
            SOMEONEELSESBEEFALO = "Not mine? Matters?",
		},
		STORE =
		{
			GENERIC = "Need more storage.",
			NOTALLOWED = "Wouldn't work.",
			INUSE = "Need this.",
            NOTMASTERCHEF = "Fine, raw meat chunks.",
		},
        CONSTRUCT =
        {
            INUSE = "Need this.",
            NOTALLOWED = "Wouldn't work.",
            EMPTY = "I-... Oops.",
            MISMATCH = "Mistake. Hard to read.",
            NOTREADY = "Earth, shaking. Unable to build.",
        },
		RUMMAGE =
		{
			GENERIC = "Wouldn't work.",
			INUSE = "Need this.",
            NOTMASTERCHEF = "Fine, raw meat chunks.",
		},
		UNLOCK =
        {
        	WRONGKEY = "No click. Wrong.",
        },
		USEKLAUSSACKKEY =
        {
        	WRONGKEY = "No click. Wrong.",
        	KLAUS = "Approaching! Big! Fight!",
			QUAGMIRE_WRONGKEY = "No click. Wrong.",
        },
		ACTIVATE =
		{
			LOCKED_GATE = "Curious, other side.",
            HOSTBUSY = "Why?",
            CARNIVAL_HOST_HERE = "Come, exciting sounds, games!",
            NOCARNIVAL = "Where, excitement?",
			EMPTY_CATCOONDEN = "No breathing, no life.",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDERS = "Want me, do this alone?",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDING_SPOTS = "Searching, hiding spot.",
			KITCOON_HIDEANDSEEK_ONE_GAME_PER_DAY = "Later. Not exciting, over, over.",
			MANNEQUIN_EQUIPSWAPFAILED = "Clothing, undesired.",
            PILLOWFIGHT_NO_HANDPILLOW = "Softer weapon, required.",
            NOTMYBERNIE = "Lingering magic. Commands, useless.",
		},
		OPEN_CRAFTING =
		{
            PROFESSIONALCHEF = "Fine, raw meat chunks.",
			SHADOWMAGIC = "Painful, chest, head, everything. No.",
		},
        COOK =
        {
            GENERIC = "Dangerous, fire.",
            INUSE = "Space, both?",
            TOOFAR = "Get back, fire!",
        },
        START_CARRAT_RACE =
        {
            NO_RACERS = "What's racing? Me?",
        },

		DISMANTLE =
		{
			COOKING = "Hot coals, wait!",
			INUSE = "Need this.",
			NOTEMPTY = "Contents, might break.",
        },
        FISH_OCEAN =
		{
			TOODEEP = "Dark water, string not reach.",
		},
        OCEAN_FISHING_POND =
		{
			WRONGGEAR = "Mistake.",
		},
        --wickerbottom specific action
--fallback to speech_wilson.lua         READ =
--fallback to speech_wilson.lua         {
--fallback to speech_wilson.lua             GENERIC = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOBIRDS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOWATERNEARBY = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             TOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             WAYTOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOFIRES =       "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOSILVICULTURE = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOHORTICULTURE = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOTENTACLEGROUND = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOSLEEPTARGETS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             TOOMANYBEES = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             NOMOONINCAVES = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua             ALREADYFULLMOON = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua         },

        GIVE =
        {
            GENERIC = "You need it!",
            DEAD = "Better things, do.",
            SLEEPING = "Tomorrow, need strength. Rest.",
            BUSY = "Give attention.",
            ABIGAILHEART = "Better than darkness. I know.",
            GHOSTHEART = "Didn't die, this island. No anchor point.",
            NOTGEM = "Mistake.",
            WRONGGEM = "No, mistake. Wrong shape.",
            NOTSTAFF = "Not stick. Need staff handle.",
            MUSHROOMFARM_NEEDSSHROOM = "Need mushroom seeds.",
            MUSHROOMFARM_NEEDSLOG = "Need log-life, make more life.",
            MUSHROOMFARM_NOMOONALLOWED = "Can't grow here.",
            SLOTFULL = "Unable, no room.",
            FOODFULL = "Want fat? Eat food now, more later.",
            NOTDISH = "Not edible. Probably tried earlier.",
            DUPLICATE = "Remember design.",
            NOTSCULPTABLE = "Mistake, not quite.",
            NOTATRIUMKEY = "Wrong key, magic lacking.",
            CANTSHADOWREVIVE = "Refusing, magic take hold.",
            WRONGSHADOWFORM = "To you, appear correct?",
            NOMOON = "Need serenity.",
			PIGKINGGAME_MESSY = "Trip hazard.",
			PIGKINGGAME_DANGER = "Join us! Fun game!",
			PIGKINGGAME_TOOLATE = "Diurnal, pigmen.",
			CARNIVALGAME_INVALID_ITEM = "Not working, mistake, must.",
			CARNIVALGAME_ALREADY_PLAYING = "Let, assist! I do!",
            SPIDERNOHAT = "Wiggling, leaping. Be still.",
            TERRARIUM_REFUSE = "No reaction.",
            TERRARIUM_COOLDOWN = "Magic focus, lacking.",
            NOTAMONKEY = "Not maker's tongue.",
            QUEENBUSY = "How preoccupied? You do nothing.",
        },
        GIVETOPLAYER =
        {
            FULL = "No free hands.",
            DEAD = "Better things, do.",
            SLEEPING = "Tomorrow, need strength. Rest.",
            BUSY = "You need this.",
        },
        GIVEALLTOPLAYER =
        {
            FULL = "No free hands.",
            DEAD = "Better things, do.",
            SLEEPING = "Tomorrow, need strength. Rest.",
            BUSY = "You need this.",
        },
        WRITE =
        {
            GENERIC = "Can't scratch. Ruins wood.",
            INUSE = "Outran me.",
        },
        DRAW =
        {
            NOIMAGE = "Others expect color. Perform, them.",
        },
        CHANGEIN =
        {
            GENERIC = "More drag.",
            BURNING = "Yes, wear fire, intelligent.",
            INUSE = "Body, shame? No shame, body acceptable.",
            NOTENOUGHHAIR = "Need more hair.",
            NOOCCUPANT = "Need beefalo.",
        },
        ATTUNE =
        {
            NOHEALTH = "More? More fuel?",
        },
        MOUNT =
        {
            TARGETINCOMBAT = "Jump on! Wrangle! Come!",
            INUSE = "Outran me.",
			SLEEPING = "Large, costly. Regaining energy.",
        },
        SADDLE =
        {
            TARGETINCOMBAT = "Jump on! Wrangle! Come!",
        },
        TEACH =
        {
            --Recipes/Teacher
            KNOWN = "Recognize design.",
            CANTLEARN = "Words? Pictures? Scratches?",

            --MapRecorder/MapExplorer
            WRONGWORLD = "Here, irrelevant.",

			--MapSpotRevealer/messagebottle
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "Here, irrelevant.",--Likely trying to read messagebottle treasure map in caves

            STASH_MAP_NOT_FOUND = "Dead end, after dead end.",-- Likely trying to read stash map  in world without stash
        },
        WRAPBUNDLE =
        {
            EMPTY = "Wrapping air, yes.",
        },
        PICKUP =
        {
			RESTRICTION = "Idea, smart?",
			INUSE = "Need that.",
--fallback to speech_wilson.lua             NOTMINE_SPIDER = "only_used_by_webber",
            NOTMINE_YOTC =
            {
                "Come here! Chase!",
                "Chase? Fine!",
            },
--fallback to speech_wilson.lua 			NO_HEAVY_LIFTING = "only_used_by_wanda",
            FULL_OF_CURSES = "I dislike monkeys.",
        },
        SLAUGHTER =
        {
            TOOFAR = "You will die!",
        },
        REPLATE =
        {
            MISMATCH = "Wrong, believe?",
            SAMEDISH = "Did, done.",
        },
        SAIL =
        {
        	REPAIR = "For now, holds.",
        },
        ROW_FAIL =
        {
            BAD_TIMING0 = "Calm. Calm. Calm...",
            BAD_TIMING1 = "Slow. Calm.",
            BAD_TIMING2 = "Go faster!",
        },
        LOWER_SAIL_FAIL =
        {
            "Why?",
            "Agh! Hurt, hands!",
            "Work, need!",
        },
        BATHBOMB =
        {
            GLASSED = "Choose another.",
            ALREADY_BOMBED = "Choose another.",
        },
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "Recognize, design.",
		},
		COMPARE_WEIGHABLE =
		{
            FISH_TOO_SMALL = "Bite-sized, small.",
            OVERSIZEDVEGGIES_TOO_SMALL = "Note, nothing.",
		},
        BEGIN_QUEST =
        {
            ONEGHOST = "only_used_by_wendy",
        },
		TELLSTORY =
		{
			GENERIC = "only_used_by_walter",
--fallback to speech_wilson.lua 			NOT_NIGHT = "only_used_by_walter",
--fallback to speech_wilson.lua 			NO_FIRE = "only_used_by_walter",
		},
        SING_FAIL =
        {
--fallback to speech_wilson.lua             SAMESONG = "only_used_by_wathgrithr",
        },
        PLANTREGISTRY_RESEARCH_FAIL =
        {
            GENERIC = "Simple, tending. Each, niche, needs.",
            FERTILIZER = "Nutrients, craving.",
        },
        FILL_OCEAN =
        {
            UNSUITABLE_FOR_PLANTS = "Salt. Inside, kill.",
        },
        POUR_WATER =
        {
            OUT_OF_WATER = "Hm. Refill.",
        },
        POUR_WATER_GROUNDTILE =
        {
            OUT_OF_WATER = "Hm. Refill.",
        },
        USEITEMON =
        {
            --GENERIC = "I can't use this on that!",

            --construction is PREFABNAME_REASON
            BEEF_BELL_INVALID_TARGET = "Hate bells.",
            BEEF_BELL_ALREADY_USED = "Not approaching. Loyalty, elsewhere.",
            BEEF_BELL_HAS_BEEF_ALREADY = "Multiple, why?",
        },
        HITCHUP =
        {
            NEEDBEEF = "Beefalo required.",
            NEEDBEEF_CLOSER = "What, no, back here.",
            BEEF_HITCHED = "Ready.",
            INMOOD = "Mating season, Obnoxious.",
        },
        MARK =
        {
            ALREADY_MARKED = "Marked.",
            NOT_PARTICIPANT = "Can play! Let in!",
        },
        YOTB_STARTCONTEST =
        {
            DOESNTWORK = "Reason?",
            ALREADYACTIVE = "Let go!",
        },
        YOTB_UNLOCKSKIN =
        {
            ALREADYKNOWN = "Again?",
        },
        CARNIVALGAME_FEED =
        {
            TOO_LATE = "Hungrier, myself.",
        },
        HERD_FOLLOWERS =
        {
            WEBBERONLY = "Leader, spiderborn.",
        },
        BEDAZZLE =
        {
--fallback to speech_wilson.lua             BURNING = "only_used_by_webber",
--fallback to speech_wilson.lua             BURNT = "only_used_by_webber",
--fallback to speech_wilson.lua             FROZEN = "only_used_by_webber",
--fallback to speech_wilson.lua             ALREADY_BEDAZZLED = "only_used_by_webber",
        },
        UPGRADE =
        {
--fallback to speech_wilson.lua             BEDAZZLED = "only_used_by_webber",
        },
		CAST_POCKETWATCH =
		{
--fallback to speech_wilson.lua 			GENERIC = "only_used_by_wanda",
--fallback to speech_wilson.lua 			REVIVE_FAILED = "only_used_by_wanda",
--fallback to speech_wilson.lua 			WARP_NO_POINTS_LEFT = "only_used_by_wanda",
--fallback to speech_wilson.lua 			SHARD_UNAVAILABLE = "only_used_by_wanda",
		},
        DISMANTLE_POCKETWATCH =
        {
--fallback to speech_wilson.lua             ONCOOLDOWN = "only_used_by_wanda",
        },

        ENTER_GYM =
        {
--fallback to speech_wilson.lua             NOWEIGHT = "only_used_by_wolfang",
--fallback to speech_wilson.lua             UNBALANCED = "only_used_by_wolfang",
--fallback to speech_wilson.lua             ONFIRE = "only_used_by_wolfang",
--fallback to speech_wilson.lua             SMOULDER = "only_used_by_wolfang",
--fallback to speech_wilson.lua             HUNGRY = "only_used_by_wolfang",
--fallback to speech_wilson.lua             FULL = "only_used_by_wolfang",
        },

        APPLYMODULE =
        {
            COOLDOWN = "only_used_by_wx78",
            NOTENOUGHSLOTS = "only_used_by_wx78",
        },
        REMOVEMODULES =
        {
            NO_MODULES = "only_used_by_wx78",
        },
        CHARGE_FROM =
        {
            NOT_ENOUGH_CHARGE = "only_used_by_wx78",
            CHARGE_FULL = "only_used_by_wx78",
        },

        HARVEST =
        {
            DOER_ISNT_MODULE_OWNER = "No.",
        },

		CAST_SPELLBOOK =
		{
--fallback to speech_wilson.lua 			NO_TOPHAT = "only_used_by_waxwell",
		},

		CASTAOE =
		{
--fallback to speech_wilson.lua 			NO_MAX_SANITY = "only_used_by_waxwell",
            NOT_ENOUGH_EMBERS = "only_used_by_willow",
            NO_TARGETS = "only_used_by_willow",
            CANT_SPELL_MOUNTED = "only_used_by_willow",
            SPELL_ON_COOLDOWN = "only_used_by_willow", 
		},
    },

	ANNOUNCE_CANNOT_BUILD =
	{
		NO_INGREDIENTS = "Mistake, materials lacking.",
		NO_TECH = "Hm. Complex. I'll learn.",
		NO_STATION = "Components, tools lacking.",
	},

	ACTIONFAIL_GENERIC = "Unable.",
	ANNOUNCE_BOAT_LEAK = "Drowning drowning, sinking sinking!",
	ANNOUNCE_BOAT_SINK = "REFUSAL OF ABYSS, WORLD DAMNED!",
	ANNOUNCE_DIG_DISEASE_WARNING = "Dead roots. Diseased.", --removed
	ANNOUNCE_PICK_DISEASE_WARNING = "Dying from roots. Diseased.", --removed
	ANNOUNCE_ADVENTUREFAIL = "Maker be damned.",
    ANNOUNCE_MOUNT_LOWHEALTH = "Do or die!",

    --waxwell and wickerbottom specific strings
--fallback to speech_wilson.lua     ANNOUNCE_TOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua     ANNOUNCE_WAYTOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua     ANNOUNCE_NOWATERNEARBY = "only_used_by_waxwell_and_wicker",

	--waxwell specific
--fallback to speech_wilson.lua 	ANNOUNCE_SHADOWLEVEL_ITEM = "only_used_by_waxwell",
--fallback to speech_wilson.lua 	ANNOUNCE_EQUIP_SHADOWLEVEL_T1 = "only_used_by_waxwell",
--fallback to speech_wilson.lua 	ANNOUNCE_EQUIP_SHADOWLEVEL_T2 = "only_used_by_waxwell",
--fallback to speech_wilson.lua 	ANNOUNCE_EQUIP_SHADOWLEVEL_T3 = "only_used_by_waxwell",
--fallback to speech_wilson.lua 	ANNOUNCE_EQUIP_SHADOWLEVEL_T4 = "only_used_by_waxwell",

    --wolfgang specific
--fallback to speech_wilson.lua     ANNOUNCE_NORMALTOMIGHTY = "only_used_by_wolfang",
--fallback to speech_wilson.lua     ANNOUNCE_NORMALTOWIMPY = "only_used_by_wolfang",
--fallback to speech_wilson.lua     ANNOUNCE_WIMPYTONORMAL = "only_used_by_wolfang",
--fallback to speech_wilson.lua     ANNOUNCE_MIGHTYTONORMAL = "only_used_by_wolfang",
    ANNOUNCE_EXITGYM = {
--fallback to speech_wilson.lua         MIGHTY = "only_used_by_wolfang",
--fallback to speech_wilson.lua         NORMAL = "only_used_by_wolfang",
--fallback to speech_wilson.lua         WIMPY = "only_used_by_wolfang",
    },

	ANNOUNCE_BEES = "This really do be a bee moment am I right fellas?",
	ANNOUNCE_BOOMERANG = "ARK!",
	ANNOUNCE_CHARLIE = "Not you!",
	ANNOUNCE_CHARLIE_ATTACK = "BEGONE! NOT AGAIN!",
--fallback to speech_wilson.lua 	ANNOUNCE_CHARLIE_MISSED = "only_used_by_winona", --winona specific
	ANNOUNCE_COLD = "Can't... Stop... Now...",
	ANNOUNCE_HOT = "Can't breathe!",
	ANNOUNCE_CRAFTING_FAIL = "What.",
	ANNOUNCE_DEERCLOPS = "Megafauna. Let's dance.",
	ANNOUNCE_CAVEIN = "Earthquake. Mindful, head.",
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"Earthquake.",
		"Rare, surface earthquakes.",
		"Curious, source.",
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "Halt, earthquakes.",
        "Spiteful, servitude.",
        "Trade, appeasment.",
	},
	ANNOUNCE_SACREDCHEST_YES = "I am recognized.",
	ANNOUNCE_SACREDCHEST_NO = "Curious, unrecognized.",
    ANNOUNCE_DUSK = "Serenity, calm.",

    --wx-78 specific
--fallback to speech_wilson.lua     ANNOUNCE_CHARGE = "only_used_by_wx78",
--fallback to speech_wilson.lua 	ANNOUNCE_DISCHARGE = "only_used_by_wx78",

	ANNOUNCE_EAT =
	{
		GENERIC = "Food.",
		PAINFUL = "Arg!",
		SPOILED = "Potency lost. Enjoyment, additionally.",
		STALE = "Hm. Required, fresh hunts.",
		INVALID = "Unable.",
        YUCKY = "Unable.",

        --Warly specific ANNOUNCE_EAT strings
--fallback to speech_wilson.lua 		COOKED = "only_used_by_warly",
--fallback to speech_wilson.lua 		DRIED = "only_used_by_warly",
--fallback to speech_wilson.lua         PREPARED = "only_used_by_warly",
--fallback to speech_wilson.lua         RAW = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_1 = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_2 = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_3 = "only_used_by_warly",
--fallback to speech_wilson.lua 		SAME_OLD_4 = "only_used_by_warly",
--fallback to speech_wilson.lua         SAME_OLD_5 = "only_used_by_warly",
--fallback to speech_wilson.lua 		TASTY = "only_used_by_warly",
    },

	ANNOUNCE_FOODMEMORY = "only_used_by_warly",

    ANNOUNCE_ENCUMBERED =
    {
        "Huff... puff...",
        "Arrrrfff...",
        "I... Can!",
        "Grrr...",
        "Heavy... object...",
        "Strain... on body...",
        "Tsk...",
        "Grrk...",
        "Pain...",
    },
    ANNOUNCE_ATRIUM_DESTABILIZING =
    {
		"Shadows stir. Magic climaxing.",
		"Unstable magic, proximity, ill-advised.",
		"World not unravelling. Rather, reinforcing.",
	},
    ANNOUNCE_RUINS_RESET = "Never-ending cycle. Why?",
    ANNOUNCE_SNARED = "NO!",
    ANNOUNCE_SNARED_IVY = "NO!",
    ANNOUNCE_REPELLED = "LET IN! LET IIIINNNN!",
	ANNOUNCE_ENTER_DARK = "Blind! Blind!",
	ANNOUNCE_ENTER_LIGHT = "Sight returned. Odd.",
	ANNOUNCE_FREEDOM = "Maker, abyss-bound. Poetic.",
	ANNOUNCE_HIGHRESEARCH = "bruh",
	ANNOUNCE_HOUNDS = "The Maker's Dogs.",
	ANNOUNCE_WORMS = "Worms. Must've been heard.",
    ANNOUNCE_ACIDBATS = "Flying creatures, angry, coming.",
	ANNOUNCE_HUNGRY = "Energy lacking.",
	ANNOUNCE_HUNT_BEAST_NEARBY = "Found you.",
	ANNOUNCE_HUNT_LOST_TRAIL = "Lost it. I lost it...",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "Through the mud, escaped.",
    ANNOUNCE_HUNT_START_FORK = "Two trails, intriguing.",
    ANNOUNCE_HUNT_SUCCESSFUL_FORK = "Ambush, prey surprised.",
    ANNOUNCE_HUNT_WRONG_FORK = "Something, stalking. Predator?",
    ANNOUNCE_HUNT_AVOID_FORK = "Complications, avoided.",
	ANNOUNCE_INV_FULL = "Not required, which provision?",
	ANNOUNCE_KNOCKEDOUT = "Sucks.",
	ANNOUNCE_LOWRESEARCH = "That wasn't very enlightening.",
	ANNOUNCE_MOSQUITOS = "Why.",
    ANNOUNCE_NOWARDROBEONFIRE = "Really?",
    ANNOUNCE_NODANGERGIFT = "What? No!",
    ANNOUNCE_NOMOUNTEDGIFT = "... Mistake. Right.",
	ANNOUNCE_NODANGERSLEEP = "NOT GOOD WEAPON!",
	ANNOUNCE_NODAYSLEEP = "Too advantageous, predators.",
	ANNOUNCE_NODAYSLEEP_CAVE = "Too advantageous, predators.",
	ANNOUNCE_NOHUNGERSLEEP = "Refusal, lay down, die.",
	ANNOUNCE_NOSLEEPONFIRE = "Really?",
    ANNOUNCE_NOSLEEPHASPERMANENTLIGHT = "Light, in face.",
	ANNOUNCE_NODANGERSIESTA = "NOT GOOD WEAPON!",
	ANNOUNCE_NONIGHTSIESTA = "Not preferable, risk.",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "Too advantageous, predators.",
	ANNOUNCE_NOHUNGERSIESTA = "Refusal, lay down, die.",
	ANNOUNCE_NO_TRAP = "Not good enough!",
	ANNOUNCE_PECKED = "I. Will. Eat. You.",
	ANNOUNCE_QUAKE = "Earthquake. Mind, head.",
	ANNOUNCE_RESEARCH = "My mind has expanded!",
	ANNOUNCE_SHELTER = "Dislike, rain.",
	ANNOUNCE_THORNS = "Rrf.",
	ANNOUNCE_BURNT = "Too hot for my impish paws!",
	ANNOUNCE_TORCH_OUT = "Farewell, sweet flame!",
	ANNOUNCE_THURIBLE_OUT = "Shadow disappated. Skeleton hold fading!",
	ANNOUNCE_FAN_OUT = "Subpar design.",
    ANNOUNCE_COMPASS_OUT = "Non-issue, land memorized.",
	ANNOUNCE_TRAP_WENT_OFF = "Mistake.",
	ANNOUNCE_UNIMPLEMENTED = "What on earth could it be!",
	ANNOUNCE_WORMHOLE = "Displeased, felt each individual ridged.",
	ANNOUNCE_TOWNPORTALTELEPORT = "Called forth.",
	ANNOUNCE_CANFIX = "\nReconstruction possible.",
	ANNOUNCE_ACCOMPLISHMENT = "I feel excellent about myself!",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "I've done the thing!",
	ANNOUNCE_INSUFFICIENTFERTILIZER = "Excrement needed. Self-production lacking.",
	ANNOUNCE_TOOL_SLIP = "No no no!",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "Hrah!",
	ANNOUNCE_TOADESCAPING = "NOT GOING ANYWHERE!",
	ANNOUNCE_TOADESCAPED = "Escaped. Likely, underground, parasite regrowing.",


	ANNOUNCE_DAMP = "Bothersome, water.",
	ANNOUNCE_WET = "All water, drip to abyss.",
	ANNOUNCE_WETTER = "Water mixture, fuel. Blackwater born.",
	ANNOUNCE_SOAKED = "Like Abyss, soaked!",

	ANNOUNCE_WASHED_ASHORE = "LAND! Yes, land! Not abyss!",

    ANNOUNCE_DESPAWN = "Vessel, unravelling. The next step.",
	ANNOUNCE_BECOMEGHOST = "ooOooooO!",
	ANNOUNCE_GHOSTDRAIN = "Assets failing.",
	ANNOUNCE_PETRIFED_TREES = "Nearby leaves, cracking, breaking.",
	ANNOUNCE_KLAUS_ENRAGE = "WANT TO JUMP? I CAN JUMP!",
	ANNOUNCE_KLAUS_UNCHAINED = "Life magic! Alarmed, fauna utilizing magic!",
	ANNOUNCE_KLAUS_CALLFORHELP = "King commands, pawns called forth.",

	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "Magic source!",
		GLASS_LOW = "Will be...",
		GLASS_REVEAL = "Mine!",
		IDOL_MED = "Magic source!",
		IDOL_LOW = "Will be...",
		IDOL_REVEAL = "Mine!",
		SEED_MED = "Magic source!",
		SEED_LOW = "Will be...",
		SEED_REVEAL = "Mine!",
	},

    --hallowed nights
    ANNOUNCE_SPOOKED = "Underground bat, aboveground!",
	ANNOUNCE_BRAVERY_POTION = "I AM APEX PREDATOR.",
	ANNOUNCE_MOONPOTION_FAILED = "Unsatisfactory.",

	--winter's feast
	ANNOUNCE_EATING_NOT_FEASTING = "Gaudy.",
	ANNOUNCE_WINTERS_FEAST_BUFF = "Allies welcome!",
	ANNOUNCE_IS_FEASTING = "Accepted as kin. Far from Abyss. Life, good.",
	ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "Warmth, allyship.",

    --lavaarena event
    ANNOUNCE_REVIVING_CORPSE = "Magic destabilized! Press advantage!",
    ANNOUNCE_REVIVED_OTHER_CORPSE = "Ghost tethered! Can't die!",
    ANNOUNCE_REVIVED_FROM_CORPSE = "Magma, beckoning for killer.",

    ANNOUNCE_FLARE_SEEN = "Explosion, the sky. Signal?",
    ANNOUNCE_MEGA_FLARE_SEEN = "Bait, laid out. Awaiting prey.",
    ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "Underneath!",

    --willow specific
--fallback to speech_wilson.lua 	ANNOUNCE_LIGHTFIRE =
--fallback to speech_wilson.lua 	{
--fallback to speech_wilson.lua 		"only_used_by_willow",
--fallback to speech_wilson.lua     },

    --winona specific
--fallback to speech_wilson.lua     ANNOUNCE_HUNGRY_SLOWBUILD =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua 	    "only_used_by_winona",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_HUNGRY_FASTBUILD =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua 	    "only_used_by_winona",
--fallback to speech_wilson.lua     },

    --wormwood specific
--fallback to speech_wilson.lua     ANNOUNCE_KILLEDPLANT =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_GROWPLANT =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_BLOOMING =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },

    --wortox specfic
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_EMPTY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_FEW =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_MANY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_OVERLOAD =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },

    --walter specfic
	ANNOUNCE_SLINGHSOT_OUT_OF_AMMO =
	{
		"Uh oh... I'm all out of ammo.",
		"Uh... just kidding!",
	},
	ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT =
	{
        "Darnit, the fire went out right at the best part!",
	},
	ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT =
	{
        "To be continued...",
	},

    -- wx specific
    ANNOUNCE_WX_SCANNER_NEW_FOUND = "only_used_by_wx78",
--fallback to speech_wilson.lua     ANNOUNCE_WX_SCANNER_FOUND_NO_DATA = "only_used_by_wx78",

    --quagmire event
    QUAGMIRE_ANNOUNCE_NOTRECIPE = "Fancy feast, unfamiliar.",
    QUAGMIRE_ANNOUNCE_MEALBURNT = "Mistake.",
    QUAGMIRE_ANNOUNCE_LOSE = "Failure. Consequence incoming.",
    QUAGMIRE_ANNOUNCE_WIN = "Next step awaits.",

    ANNOUNCE_ROYALTY =
    {
        "Crown, royalty.",
        "Symbol of power.",
        "Bow? Curious.",
    },

    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "Amp! Amp! Amp!",
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "Fear me.",
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "I still stand.",
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "Dawn to dusk, Practically effective.",
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "No more fears.",
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "Go forth, no halt!",

    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "Muscles relaxing.",
    ANNOUNCE_DETACH_BUFF_ATTACK            = "Nothing changes.",
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "Alarm!",
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "Break, breathing.",
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "The past, must live.",
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "Others... Rest before me.",

	ANNOUNCE_OCEANFISHING_LINESNAP = "Broken tool. Unsatisfactory.",
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "Bad string. Bring in.",
	ANNOUNCE_OCEANFISHING_GOTAWAY = "Hmph.",
	ANNOUNCE_OCEANFISHING_BADCAST = "Bad throw.",
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE =
	{
		"Looking down, induce stress.",
		"In the abyss, hold water.",
		"Idle, idle...",
		"Baited, in waiting.",
	},

	ANNOUNCE_WEIGHT = "Weight: {weight}",
	ANNOUNCE_WEIGHT_HEAVY  = "Weight: {weight}\nGood.",

	ANNOUNCE_WINCH_CLAW_MISS = "Try again.",
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "Positive, false.",

    --Wurt announce strings
--fallback to speech_wilson.lua     ANNOUNCE_KINGCREATED = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_KINGDESTROYED = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_THRONE = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_HOUSE = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_WATCHTOWER = "only_used_by_wurt",
    ANNOUNCE_READ_BOOK =
    {
--fallback to speech_wilson.lua         BOOK_SLEEP = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_BIRDS = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_TENTACLES =  "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_BRIMSTONE = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_GARDENING = "only_used_by_wurt",
--fallback to speech_wilson.lua 		BOOK_SILVICULTURE = "only_used_by_wurt",
--fallback to speech_wilson.lua 		BOOK_HORTICULTURE = "only_used_by_wurt",

--fallback to speech_wilson.lua         BOOK_FISH = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_FIRE = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_WEB = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_TEMPERATURE = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_LIGHT = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_RAIN = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_MOON = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_BEES = "only_used_by_wurt",

--fallback to speech_wilson.lua         BOOK_HORTICULTURE_UPGRADED = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_RESEARCH_STATION = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_LIGHT_UPGRADED = "only_used_by_wurt",
    },
    ANNOUNCE_WEAK_RAT = "Strength lacking. Lucky, I am carnivore.",

    ANNOUNCE_CARRAT_START_RACE = "On!",

    ANNOUNCE_CARRAT_ERROR_WRONG_WAY = {
        "I race better!",
        "Why?!",
    },
    ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "This game, bad.",
    ANNOUNCE_CARRAT_ERROR_WALKING = "No energy?!",
    ANNOUNCE_CARRAT_ERROR_STUNNED = "Go! Go!",

    ANNOUNCE_GHOST_QUEST = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_GHOST_HINT = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_GHOST_TOY_NEAR = {
--fallback to speech_wilson.lua         "only_used_by_wendy",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua 	ANNOUNCE_SISTURN_FULL = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_ABIGAIL_DEATH = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_ABIGAIL_RETRIEVE = "only_used_by_wendy",
--fallback to speech_wilson.lua 	ANNOUNCE_ABIGAIL_LOW_HEALTH = "only_used_by_wendy",
    ANNOUNCE_ABIGAIL_SUMMON =
	{
--fallback to speech_wilson.lua 		LEVEL1 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL2 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL3 = "only_used_by_wendy",
	},

    ANNOUNCE_GHOSTLYBOND_LEVELUP =
	{
--fallback to speech_wilson.lua 		LEVEL2 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL3 = "only_used_by_wendy",
	},

--fallback to speech_wilson.lua     ANNOUNCE_NOINSPIRATION = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_NOTSKILLEDENOUGH = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_REVIVE_BUFF = "only_used_by_wathgrithr",

--fallback to speech_wilson.lua     ANNOUNCE_WANDA_YOUNGTONORMAL = "only_used_by_wanda",
--fallback to speech_wilson.lua     ANNOUNCE_WANDA_NORMALTOOLD = "only_used_by_wanda",
--fallback to speech_wilson.lua     ANNOUNCE_WANDA_OLDTONORMAL = "only_used_by_wanda",
--fallback to speech_wilson.lua     ANNOUNCE_WANDA_NORMALTOYOUNG = "only_used_by_wanda",

	ANNOUNCE_POCKETWATCH_PORTAL = "Reality distain, foreign perversions. However, useful.",

--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_MARK = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_RECALL = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_OPEN_PORTAL = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_OPEN_PORTAL_DIFFERENTSHARD = "only_used_by_wanda",

    ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "I needed this. All life.",
    ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "Information, duplicate.",
    ANNOUNCE_ARCHIVE_NO_POWER = "Curious, power source?",

    ANNOUNCE_PLANT_RESEARCHED =
    {
        "Others appreciate. I don't.",
    },

    ANNOUNCE_PLANT_RANDOMSEED = "Anything, outcome.",

    ANNOUNCE_FERTILIZER_RESEARCHED = "Utilization possible.",

	ANNOUNCE_FIRENETTLE_TOXIN =
	{
		"Rrh! Hot!",
		"Heat, triumphed!",
	},
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "Hot taste, forgotten.",

	ANNOUNCE_TALK_TO_PLANTS =
	{
        "Grow good. Die bad.",
        "Accept magic. Embrace. Grants strength.",
        "Grow, nourishment provides.",
        "Will feed, when grown.",
        "Plant matter, listening.",
	},

	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "This game? Exceptional, my skill.",
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN = "I am in!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND =
	{
		"Found you.",
		"Conceal appendages. Fun, impacted.",
		"Hidden, no longer.",
		"Revealed, hidden no longer.",
	},
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_ONE_MORE = "One left. Victory, assured.",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE = "Myself, entertained!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE_TEAM = "Consumption, when?",
	ANNOUNCE_KITCOON_HIDANDSEEK_TIME_ALMOST_UP = "Mistake, must be. Sit still, listen.",
	ANNOUNCE_KITCOON_HIDANDSEEK_LOSEGAME = "Outsmarted. Something new, learned.",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR = "Small animal, small legs. Not this far.",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR_RETURN = "Sound! Hunt, commencing.",
	ANNOUNCE_KITCOON_FOUND_IN_THE_WILD = "One found.",

	ANNOUNCE_TICOON_START_TRACKING	= "Game, underwhelming.",
	ANNOUNCE_TICOON_NOTHING_TO_TRACK = "Plans, now?",
	ANNOUNCE_TICOON_WAITING_FOR_LEADER = "One moment.",
	ANNOUNCE_TICOON_GET_LEADER_ATTENTION = "Attention recieved.",
	ANNOUNCE_TICOON_NEAR_KITCOON = "Sound. Alert.",
	ANNOUNCE_TICOON_LOST_KITCOON = "Myself, disappointed.",
	ANNOUNCE_TICOON_ABANDONED = "Attention wavering.",
	ANNOUNCE_TICOON_DEAD = "Important, why?",

    -- YOTB
    ANNOUNCE_CALL_BEEF = "Here.",
    ANNOUNCE_CANTBUILDHERE_YOTB_POST = "Incorrect. Not here.",
    ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "New. Learning, great feeling.",

    -- AE4AE
    ANNOUNCE_EYEOFTERROR_ARRIVE = "Another claim, apex role?",
    ANNOUNCE_EYEOFTERROR_FLYBACK = "What started, will finish.",
    ANNOUNCE_EYEOFTERROR_FLYAWAY = "Retreat. Presumably, not last sighting.",

    -- PIRATES
    ANNOUNCE_CANT_ESCAPE_CURSE = "Ways, always. I will find one.",
    ANNOUNCE_MONKEY_CURSE_1 = "I am no furry.",
    ANNOUNCE_MONKEY_CURSE_CHANGE = "SHADOW FUEL... Fading...?",
    ANNOUNCE_MONKEY_CURSE_CHANGEBACK = "Familiarity, shadow fuel, returned.",

    ANNOUNCE_PIRATES_ARRIVE = "The horizon, approaching boat. Not friendly!",

--fallback to speech_wilson.lua     ANNOUNCE_BOOK_MOON_DAYTIME = "only_used_by_waxwell_and_wicker",

    ANNOUNCE_OFF_SCRIPT = "Speech, off script.",

    ANNOUNCE_COZY_SLEEP = "Energy renewed, hungry..",

	--
	ANNOUNCE_TOOL_TOOWEAK = "Chains... pillars... stronger implement.",

    ANNOUNCE_LUNAR_RIFT_MAX = "The above ones influence.",
    ANNOUNCE_SHADOW_RIFT_MAX = "Deep ones, unveiled!",

    ANNOUNCE_SCRAPBOOK_FULL = "Knowledge recorded, preserved.",

    ANNOUNCE_CHAIR_ON_FIRE = "Danger, hot seat.",

    ANNOUNCE_HEALINGSALVE_ACIDBUFF_DONE = "Acid protection, worn off.",

    ANNOUNCE_COACH = 
    {
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
    },
    ANNOUNCE_WOLFGANG_WIMPY_COACHING = "only_used_by_wolfgang",
    ANNOUNCE_WOLFGANG_MIGHTY_COACHING = "only_used_by_wolfgang",
    ANNOUNCE_WOLFGANG_BEGIN_COACHING = "only_used_by_wolfgang",
    ANNOUNCE_WOLFGANG_END_COACHING = "only_used_by_wolfgang",
    ANNOUNCE_WOLFGANG_NOTEAM = 
    {
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
        "only_used_by_wolfgang",
    },

    ANNOUNCE_YOTD_NOBOATS = "Too far.",
    ANNOUNCE_YOTD_NOCHECKPOINTS = "Path, required.",
    ANNOUNCE_YOTD_NOTENOUGHBOATS = "Competitors, required.",
	
	BATTLECRY =
	{
		GENERIC = "Rrah!",
		PIG = "Fat, mouthful craving!",
		PREY = "I want to play!",
		SPIDER = "Light snack!",
		SPIDER_WARRIOR = "Who jump faster?",
		DEER = "Venizen!",
	},
	COMBAT_QUIT =
	{
		GENERIC = "I will return.",
		PIG = "I will return.",
		PREY = "I will return.",
		SPIDER = "I will return.",
		SPIDER_WARRIOR = "I will return.",
	},

	DESCRIBE =
	{
		MULTIPLAYER_PORTAL = "Escape, broke curse, banishment. Never again.",
        MULTIPLAYER_PORTAL_MOONROCK = "Curious, lies beyond.",
        MOONROCKIDOL = "Missing piece, puzzle?",
        CONSTRUCTION_PLANS = "All success, planning.",

        ANTLION =
        {
            GENERIC = "Destabilizer, tectonics.",
            VERYHAPPY = "Peace.",
            UNHAPPY = "Digging, disrupting tectonics. Something, expecting?",
        },
        ANTLIONTRINKET = "Treasure, little practical values.",
        SANDSPIKE = "Missed!",
        SANDBLOCK = "No room, jumping!",
        GLASSSPIKE = "Looked better, myself.",
        GLASSBLOCK = "Looked better, myself.",
        ABIGAIL_FLOWER =
        {
            GENERIC ="Tied down, trapped below.",
			LEVEL1 = "Tied down, trapped below.",
			LEVEL2 = "Rage bubbling, power growing.",
			LEVEL3 = "Transcending limits, bond. Protection, duty.",

			-- deprecated
            LONG = "It's very sad. Full of regrets.",
            MEDIUM = "Waking up, are we?",
            SOON = "It seems the fun will soon begin.",
            HAUNTED_POCKET = "Sadly, it is not mine to keep.",
            HAUNTED_GROUND = "Ohh, you're hungry too.",
        },

        BALLOONS_EMPTY = "What purpose?",
        BALLOON = "Curious. Simple air, but floating.",
		BALLOONPARTY = "Why?",
		BALLOONSPEED =
        {
            DEFLATED = "Too rough, burst.",
            GENERIC = "Drifting, pulling, wind.",
        },
		BALLOONVEST = "I like this.",
		BALLOONHAT = "I dislike this.",

        BERNIE_INACTIVE =
        {
            BROKEN = "Worn, torn, everything here.",
            GENERIC = "Staring. Judging.",
        },

        BERNIE_ACTIVE = "Staring, unwavering. Distrustful.",
        BERNIE_BIG = "Not me! Not me!",

		BOOKSTATION =
		{
			GENERIC = "Curious, Scribeswoman. Language, knowledge, teach.",
			BURNT = "Reconstruction, priority.",
		},
        BOOK_BIRDS = "Birds, compulsion? Why? Curious.",
        BOOK_TENTACLES = "Marsh-born compulsion. Location, rapid burrowing.",
        BOOK_GARDENING = "Vegetation, stimulation. Soil, roots? Nutrients, where?",
		BOOK_SILVICULTURE = "Flora, stimulation. Soil, roots? Nutrients, where?",
		BOOK_HORTICULTURE = "Vegetation, stimulation. Soil, roots? Nutrients, where?",
        BOOK_SLEEP = "Unrelated, lunar magic. Similar outcome.",
        BOOK_BRIMSTONE = "Destabilization magic. Of what, unsure. Clouds, air?",

        BOOK_FISH = "More magic, compulsion.",
        BOOK_FIRE = "Fire suffocation, presumably.",
        BOOK_WEB = "Can't move, easier hit.",
        BOOK_TEMPERATURE = "Wonders abound, scribeswoman. Teach me more.",
        BOOK_LIGHT = "Lunar magic. Show me more.",
        BOOK_RAIN = "No escape.",
        BOOK_MOON = "Ritual, mass importance! Mine!",
        BOOK_BEES = "Compulsion magic, royal bees.",
        
        BOOK_HORTICULTURE_UPGRADED = "Vegetation, stimulation. Potent, particularly.",
        BOOK_RESEARCH_STATION = "So much knowledge, and none of it forbidden!",
        BOOK_LIGHT_UPGRADED = "Lunar magic! Show me more!",

        FIREPEN = "Fire staff, diminutive?",

        PLAYER =
        {
            GENERIC = "Who are you?",
            ATTACKER = "Liability, %s.",
            MURDERER = "Fittest, survival!",
            REVIVER = "%s, helpful.",
            GHOST = "Failure, survivor.",
            FIRESTARTER = "Explanation required. Fire cause, you.",
        },
         WILSON =
        {
            GENERIC = "%s. Riddles, nonsense.",
            ATTACKER = "%s, facade falling.",
            MURDERER = "%s, place, forgotten.",
            REVIVER = "%s, Progress, science understanding?",
            GHOST = "Unfortunate.",
            FIRESTARTER = "Frequent \"experiment mishaps\". Too frequent, %s.",
        },
        WOLFGANG =
        {
            GENERIC = "Scary, but scared. Peculiar, %s.",
            ATTACKER = "Unaware, own size. Harming!",
            MURDERER = "%s, not indominable. Who fatigues first?",
            REVIVER = "%s, Good-willed muscle.",
            GHOST = "Failed, emotional state.",
            FIRESTARTER = "Fire, ash. %s, reasoning?",
        },
        WAXWELL =
        {
            GENERIC = "Maker. Damn you.",
            ATTACKER = "False king.",
            MURDERER = "Come, time. Abyss beckoning, creator!",
            REVIVER = "I never forget, Maker. Nor forgive.",
            GHOST = "Day, joyous!",
            FIRESTARTER = "%s, flushing me out?",
        },
        WX78 =
        {
            GENERIC = "%s. False leader.",
            ATTACKER = "%s, real alignment?",
            MURDERER = "Rust, rot, fate.",
            REVIVER = "Fellow asset, %s.",
            GHOST = "Appearance, soul. Hm.",
            FIRESTARTER = "%s, liability.",
        },
        WILLOW =
        {
            GENERIC = "%s, flamewoman.",
            ATTACKER = "Unstable, mental.",
            MURDERER = "Reality touch, lost. Death, mental reset.",
            REVIVER = "%s, expect kinship?",
            GHOST = "No playground, here.",
            FIRESTARTER = "Again?",
        },
        WENDY =
        {
            GENERIC = "%s, ectoherbologist.",
            ATTACKER = "Blood recognized, %s.",
            MURDERER = "%s, Maker's blood. Kin, same fate.",
            REVIVER = "%s, practical family.",
            GHOST = "Linked, bond. One pulled, other taken.",
            FIRESTARTER = "Destruction, wanton. Why, %s?",
        },
        WOODIE =
        {
            GENERIC = "Axe, vocal. Maker's work?",
            ATTACKER = "Axe, brandished. Issues, %s?",
            MURDERER = "Subpar weapon, axe. Observe. This is better.",
            REVIVER = "%s, soft, helping.",
            GHOST = "Unfortunate, %s.",
            BEAVER = "Variant lycanthropic.",
            BEAVERGHOST = "Burden, bared?",
            MOOSE = "Variant lycanthropic.",
            MOOSEGHOST = "Burden, bared?",
            GOOSE = "Variant lycanthropic?",
            GOOSEGHOST = "%s, fickle form.",
            FIRESTARTER = "%s, several sides.",
        },
        WICKERBOTTOM =
        {
            GENERIC = "%s, scribeswoman.",
            ATTACKER = "Why, %s?",
            MURDERER = "Shame. %s, assistance possible.",
            REVIVER = "Curious, %s. Curious, knowledge.",
            GHOST = "Magic, resurrection!",
            FIRESTARTER = "Flame magic, %s?",
        },
        WES =
        {
            GENERIC = "...?",
            ATTACKER = "%s, motives?",
            MURDERER = "%s, motives revealed.",
            REVIVER = "%s.",
            GHOST = "There, no surprise.",
            FIRESTARTER = "Ash, soot.",
        },
        WEBBER =
        {
            GENERIC = "%s, behavior inconsistent. Survival, odd.",
            ATTACKER = "Spider, personality dominant.",
            MURDERER = "Observe, true predator.",
            REVIVER = "Child, personality dominant.",
            GHOST = "Naivity, children.",
            FIRESTARTER = "%s, destruction cause.",
        },
        WATHGRITHR =
        {
            GENERIC = "No enemy, %s.",
            ATTACKER = "Discard, spear.",
            MURDERER = "Hunter status, challenged?",
            REVIVER = "%s. Tactics, alike.",
            GHOST = "%s, missed.",
            FIRESTARTER = "%s, religious rituals, flame?",
        },
        WINONA =
        {
            GENERIC = "%s, Machination-maker.",
            ATTACKER = "%s, abrasive.",
            MURDERER = "Machines, survival, unnecessary. Begone.",
            REVIVER = "Curious, art, machine.",
            GHOST = "Shame, %s.",
            FIRESTARTER = "Malfunction, %s?",
        },
        WORTOX =
        {
            GENERIC = "%s, Klaus-born.",
            ATTACKER = "Theft. Destruction, wanton.",
            MURDERER = "Just another creature.",
            REVIVER = "%s, humor passing.",
            GHOST = "Poetic, %s.",
            FIRESTARTER = "Humor, explanation. Now.",
        },
        WORMWOOD =
        {
            GENERIC = "%s, Alter-born!",
            ATTACKER = "Dislike, inherent.",
            MURDERER = "Inevitable, supposedly. Come, %s.",
            REVIVER = "Magics, intertwined. World, conquered.",
            GHOST = "Staring, headache.",
            FIRESTARTER = "%s, charred. Burnt.",
        },
        WARLY =
        {
            GENERIC = "Food, too picky. %s, survival expected?",
            ATTACKER = "Brandished, cutting tools.",
            MURDERER = "Location, cooked bone marrow?",
            REVIVER = "%s. Tastes, expanded.",
            GHOST = "Surprised, starvation, not causation.",
            FIRESTARTER = "%s, kitchen, liability.",
        },

        WURT =
        {
            GENERIC = "%s, Marsh-born.",
            ATTACKER = "%s, blankly staring.",
            MURDERER = "%s, colonization ending.",
            REVIVER = "%s, behavior not average.",
            GHOST = "%s, ambassador progress?",
            FIRESTARTER = "%s, liability.",
        },

        WALTER =
        {
            GENERIC = "%s, stick, poking me. Cease.",
            ATTACKER = "%s, instable.",
            MURDERER = "%s, absent dog, functional tools? Let us discover.",
            REVIVER = "Naive, %s. Safety, concern.",
            GHOST = "Dog, protection failed.",
            FIRESTARTER = "&s, dog, both liability.",
        },

        WANDA =
        {
            GENERIC = "%s, fuel utilizer. Uses, strange. Intriguing.",
            ATTACKER = "Place, forgotten.",
            MURDERER = "%s, fuel, exploited. Me, fuel-born. Power unlocked.",
            REVIVER = "Come, %s. Discussion, time rammifications.",
            GHOST = "Spirit, wibbly, wobbily.",
            FIRESTARTER = "%s, liability.",
        },

        WONKEY =
        {
            GENERIC = "A primate. Behavior familial.",
            ATTACKER = "Curse, behavioral affection.",
            MURDERER = "Mind, gone. Misery, ending.",
            REVIVER = "%s, recognized!",
            GHOST = "Shame.",
            FIRESTARTER = "%s, common sense, forgotten.",
        },

--fallback to speech_wilson.lua         MIGRATION_PORTAL =
--fallback to speech_wilson.lua         {
--fallback to speech_wilson.lua         --    GENERIC = "If I had any friends, this could take me to them.",
--fallback to speech_wilson.lua         --    OPEN = "If I step through, will I still be me?",
--fallback to speech_wilson.lua         --    FULL = "It seems to be popular over there.",
--fallback to speech_wilson.lua         },
        GLOMMER =
        {
            GENERIC = "Elder, respect. Protection promised.",
            SLEEPING = "Rest. Safety assured.",
        },
        GLOMMERFLOWER =
        {
            GENERIC = "Elder, compulsion magic. Potential, abuse.",
            DEAD = "Event, unfortunate.",
        },
        GLOMMERWINGS = "Mistake. Sincerity.",
        GLOMMERFUEL = "Magic, cacophany. Stable, somehow.",
        BELL = "BONG.",
        STATUEGLOMMER =
        {
            GENERIC = "Depiction, elders.",
            EMPTY = "History, defiled.",
        },

        LAVA_POND_ROCK = "Rocks, no dire need.",

		WEBBERSKULL = "Skull.",
		WORMLIGHT = "Bait. Attention attraction.",
		WORMLIGHT_LESSER = "Bait, potency lacking.",
		WORM =
		{
		    PLANT = "Halt. Moisture, creature giveaway.",
		    DIRT = "Worms.",
		    WORM = "Worm, basic. Excess energy, excerted in bite..",
		},
        WORMLIGHT_PLANT = "Halt. Moisture, creature giveaway.",
		MOLE =
		{
			HELD = "Calm, soothed. Whatever's next, inevitable.",
			UNDERGROUND = "Moleworm.",
			ABOVEGROUND = "Burrow, rock content. Couldn't hurt, investigate.",
		},
		MOLEHILL = "Elaborate tunnels. Standing above one, all times.",
		MOLEHAT = "Pain, too bright.",

		EEL = "Good source, poison-free meat.",
		EEL_COOKED = "Poison, current-free.",
		UNAGI = "Survival possible - resourcefulness required.",
		EYETURRET = "Sentient eyeball. Pain reception? Memories, Deerclops?",
		EYETURRET_ITEM = "Glaring, anticipation.",
		MINOTAURHORN = "Self lost, price paid. Intact, myself?",
		MINOTAURCHEST = "Myself akin, Guardian. Could have been me.",
		THULECITE_PIECES = "Pieces, thulecite. Fuel conductivity, currently subpar.",
		POND_ALGAE = "Inedible. Attempted. Bad.",
		GREENSTAFF = "World, unravelled.",
		GIFT = "Contents, security uncertain.",
        GIFTWRAP = "Purpose, ribbon?",
		POTTEDFERN = "Plant.",
        SUCCULENT_POTTED = "Plant.",
		SUCCULENT_PLANT = "Plant.",
		SUCCULENT_PICKED = "Dead plant fiber.",
		SENTRYWARD = "Sense stimulation, feeds mind.",
        TOWNPORTAL =
        {
			GENERIC = "Desert sands, molecules, magic.",
			ACTIVE = "Dune magic holding.",
		},
        TOWNPORTALTALISMAN =
        {
			GENERIC = "Aboveground desert. Unique magic. Antlion causation?",
			ACTIVE = "Dune magic holding.",
		},
        WETPAPER = "Unfortunate.",
        WETPOUCH = "Self-destructing.",
        MOONROCK_PIECES = "Alter-magic. Alter... Familiar-sounding, why?",
        MOONBASE =
        {
            GENERIC = "Resemblance, Ancients' structural architecture. If Ancient, why Alter-magic?",
            BROKEN = "Familiar striking. Defaced.",
            STAFFED = "Abound, wonders! Answers awaiting!",
            WRONGSTAFF = "Mistake.",
            MOONSTAFF = "Ancient, Alter, singular infusement! Stable!",
        },
        MOONDIAL =
        {
			GENERIC = "Shrine, cardiovascular manipulation.",
			NIGHT_NEW = "Blood, pumping maximum!",
			NIGHT_WAX = "Calming.",
			NIGHT_FULL = "My heartbeat, stabilizing.",
			NIGHT_WANE = "Alter fading.",
			CAVE = "... Mistake.",
--fallback to speech_wilson.lua 			WEREBEAVER = "only_used_by_woodie", --woodie specific
			GLASSED = "Peculiar.",
        },
		THULECITE = "Ancient alloy, peak nightmare conductivity. \nStory telling, context lacking.",
		ARMORRUINS = "Infused nightmare fuel, absorption. Elsewhere sent, kinetic force.",
		ARMORSKELETON = "I am sorry...",
		SKELETONHAT = "Cooporation requested, denied. Past, history, wasted.",
		RUINS_BAT = "Surrounding fuel, stimulation! Earth itself, assist me.",
		RUINSHAT = "Life Gem, enhanced. Magic, thulecite amplification. \n Knowledge still seeking, Ancients. Discovery, one day.",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "Nightmare stability holding.",
            WARN = "Nightmare stability, fleeting. ",
            WAXING = "Entropy, nightmare stability!",
            STEADY = "Heart, in tune, with nightmare, entropy!",
            WANING = "Nightmare stability, re-establishing.",
            DAWN = "Nightmare stability established.",
            NOMAGIC = "This location, surrounding nightmares, stable.",
		},
		BISHOP_NIGHTMARE = "Displacement!",
		ROOK_NIGHTMARE = "Obliteration!",
		KNIGHT_NIGHTMARE = "Persistance!",
		MINOTAUR = "Your belongings, I require.",
		SPIDER_DROPPER = "Hundreds, thousands above. Ceiling littered, colonies.",
		NIGHTMARELIGHT = "Warning me. Similar fates, ones before.\n Maybe...",
		NIGHTSTICK = "Electrical conductivity. Hydrophillic.",
		GREENGEM = "Ravellation Magic.",
		MULTITOOL_AXE_PICKAXE = "Tools, ancients. Civilization, truly advanced.",
		ORANGESTAFF = "Teleportation focus, mobile.",
		YELLOWAMULET = "Throbs with my heart!",
		GREENAMULET = "Missing material, replacements ravelled.",
		SLURPERPELT = "No meat, all hair.",
		
		SLURPER = "All hair, but tongue.",
		SLURPERP_ELT = "No meat, all hair.",
		ARMORSLURPER = "Constriction. Sucks.",
		ORANGEAMULET = "Teleportation focus, stationary.",
		YELLOWSTAFF = "Birth, life of light.",
		YELLOWGEM = "Darkness maximum, collapses, inverses.",
		ORANGEGEM = "Teleportation. Common utilization, Ancients. Imagine society.",
        OPALSTAFF = "My core, coiling. Match attempting, lacking Alter material.",
        OPALPRECIOUSGEM = "Entire ecosystem, differing magics. Amazing...",
        TELEBASE =
		{
			VALID = "Nightmare bridge nominal.",
			GEMS = "Nightmare bridge, magic focus required.",
		},
		GEMSOCKET =
		{
			VALID = "Sufficient, magic flowing.",
			GEMS = "Magic focus, required.",
		},
		STAFFLIGHT = "Overabundance, nightmare fuel. Light generation cause, collapse.",
        STAFFCOLDLIGHT = "Explanation, unable. Curious.",

        ANCIENT_ALTAR = "Direct line, ancient knowledge. Perhaps, diety.\n Prayed sometimes. Days, weeks. Mistake, seemingly.",

        ANCIENT_ALTAR_BROKEN = "Ancient structure, multipurpose. Workshop, shrine, gathering.",

        ANCIENT_STATUE = "Your story, seeking. Soon, discovery. Soon...",

        LICHEN = "Biology carnivoric. However, choices dwindle.",
		CUTLICHEN = "Awful, little alternatives.",

		CAVE_BANANA = "Monkey, gift. Fatten up.",
		CAVE_BANANA_COOKED = "Pass.",
		CAVE_BANANA_TREE = "Curious. Never understood, monkeys cultivate?",
		ROCKY = "Once aboveground. Evidently, banishing things, Maker enjoys.",

		COMPASS =
		{
			GENERIC="Myself, easily tack.",
			N = "North.",
			S = "South.",
			E = "East.",
			W = "West.",
			NE = "Northeast.",
			SE = "Southeast.",
			NW = "Northwest.",
			SW = "Southwest.",
		},

        HOUNDSTOOTH = "Place, forgotten.",
        ARMORSNURTLESHELL = "Oddly rare. Failure, evolution.",
        BAT = "Inconsequencial.",
        BATBAT = "Living Log, blood conversion, Gemstone, feeding energy.",
        BATWING = "Hunger holding, currently.",
        BATWING_COOKED = "Pleasing smell.",
        BATCAVE = "Hunting grounds, adequate.",
        BEDROLL_FURRY = "Comfort, rare.",
        BUNNYMAN = "Sentient, barely. Logic primitive.",
        FLOWER_CAVE = "Light, presumably?",
        GUANO = "Riveting.",
        LANTERN = "Human tools.",
        LIGHTBULB = "Stomach turning.",
        MANRABBIT_TAIL = "Bones inedible. Painful, last time.",
        MUSHROOMHAT = "Head weight.",
        MUSHROOM_LIGHT2 =
        {
            ON = "Industrialized mushroom.",
            OFF = "Industrialized mushroom.",
            BURNT = "All-consuming.",
        },
        MUSHROOM_LIGHT =
        {
            ON = "Industrialized mushroom.",
            OFF = "Industrialized mushroom.",
            BURNT = "All-consuming.",
        },
        SLEEPBOMB = "Light comatose, only.",
        MUSHROOMBOMB = "Watch it!",
        SHROOM_SKIN = "Thick, uses practical?",
        TOADSTOOL_CAP =
        {
            EMPTY = "Return, guaranteed.",
            INGROUND = "Parasite forming.",
            GENERIC = "False mushroom.",
        },
        TOADSTOOL =
        {
            GENERIC = "Parasite controlling! Cut off, toad dies!",
            RAGE = "CUT PARASITE! CUT PARASITE!",
        },
        MUSHROOMSPROUT =
        {
            GENERIC = "Unusual.",
            BURNT = "Unfortunate.",
        },
        MUSHTREE_TALL =
        {
            GENERIC = "Underground fungus. Sizes normal.",
            BLOOM = "Underground fungus. Evidently, blooming season.",
            ACIDCOVERED = "Composition, deteriorated.",
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "Underground fungus. Sizes normal.",
            BLOOM = "Underground fungus. Evidently, blooming season.",
            ACIDCOVERED = "Composition, deteriorated.",
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "Underground fungus. Sizes normal.",
            BLOOM = "Underground fungus. Evidently, blooming season.",
            ACIDCOVERED = "Composition, deteriorated.",
        },
        MUSHTREE_TALL_WEBBED = 
		{
			GENERIC = "Sit still, examine. Small string, ceiling hanging.",
            ACIDCOVERED = "Composition, deteriorated.",
		},
        SPORE_TALL =
        {
            GENERIC = "Happenings, nature.",
            HELD = "Caught, unsure.",
        },
        SPORE_MEDIUM =
        {
            GENERIC = "Happenings, nature.",
            HELD = "Caught, unsure.",
        },
        SPORE_SMALL =
        {
            GENERIC = "Happenings, nature.",
            HELD = "Caught, unsure.",
        },
        RABBITHOUSE =
        {
            GENERIC = "Knock knock, hunger waxing.",
            BURNT = "Food, alternative required.",
        },
        SLURTLE = "Bottom-feeder.",
        SLURTLE_SHELLPIECES = "Mistake.",
        SLURTLEHAT = "Partially guaranteed, safety.",
        SLURTLEHOLE = "Home. Never investigated. Hm.",
        SLURTLESLIME = "Violent expansion, flame cause.",
        SNURTLE = "Valuable mutation!",
        SPIDER_HIDER = "Impatience, bait.",
        SPIDER_SPITTER = "Aim, respectable.",
        SPIDERHOLE = "A den.",
        SPIDERHOLE_ROCK = "A den.",
        STALAGMITE = "Thousands in abyss.",
        STALAGMITE_TALL = "Thousands in abyss.",

        TURF_CARPETFLOOR = "Floor.",
        TURF_CHECKERFLOOR = "Floor.",
        TURF_DIRT = "Floor.",
        TURF_FOREST = "Floor.",
        TURF_GRASS = "Floor.",
        TURF_MARSH = "Floor.",
        TURF_METEOR = "Floor.",
        TURF_PEBBLEBEACH = "Floor.",
        TURF_ROAD = "Floor.",
        TURF_ROCKY = "Floor.",
        TURF_SAVANNA = "Floor.",
        TURF_WOODFLOOR = "Floor.",

		TURF_CAVE="Floor.",
		TURF_FUNGUS="Floor.",
		TURF_FUNGUS_MOON = "Floor.",
		TURF_ARCHIVE = "Floor.",
		TURF_SINKHOLE="Floor.",
		TURF_UNDERROCK="Floor.",
		TURF_MUD="Floor.",

		TURF_DECIDUOUS = "Floor.",
		TURF_SANDY = "Floor.",
		TURF_BADLANDS = "Floor.",
		TURF_DESERTDIRT = "Floor.",
		TURF_FUNGUS_GREEN = "Floor.",
		TURF_FUNGUS_RED = "Floor.",
		TURF_DRAGONFLY = "Floor.",

        TURF_SHELLBEACH = "Floor.",

		TURF_RUINSBRICK = "Floor",
		TURF_RUINSBRICK_GLOW = "Floor",
		TURF_RUINSTILES = "Floor",
		TURF_RUINSTILES_GLOW = "Floor",
		TURF_RUINSTRIM = "Floor",
		TURF_RUINSTRIM_GLOW = "Floor",

        TURF_MONKEY_GROUND = "Floor.",

        TURF_CARPETFLOOR2 = "Floor.",
        TURF_MOSAIC_GREY = "Floor.",
        TURF_MOSAIC_RED = "Floor.",
        TURF_MOSAIC_BLUE = "Floor.",

        TURF_BEARD_RUG = "Floor.",

		POWCAKE = "Some things, forever.",
        CAVE_ENTRANCE = "Maker, sealed exits, kept me in.",
        CAVE_ENTRANCE_RUINS = "Calling, heard.",

       	CAVE_ENTRANCE_OPEN =
        {
            GENERIC = "Closer to abyss. One accident, all it takes...",
            OPEN = "Similar, up here. Ceiling, difference being.",
            FULL = "Descent crowded.",
        },
        CAVE_EXIT =
        {
            GENERIC = "Underground preferred.",
            OPEN = "Warm, inviting. Unfamiliar.",
            FULL = "Ascent crowded.",
        },

		MAXWELLPHONOGRAPH = "Fun.",--single player
		BOOMERANG = "Attention obtainer.",
		PIGGUARD = "Mechanically apt, combat. Apt enough?",
		ABIGAIL =
		{
            LEVEL1 =
            {
                "Vengeance, rage. In tact, psychology?",
                "Vengeance, rage. In tact, psychology?",
            },
            LEVEL2 =
            {
                "Vengeance, rage. In tact, psychology?",
                "Vengeance, rage. In tact, psychology?",
            },
            LEVEL3 =
            {
                "Vengeance, rage. In tact, psychology?",
                "Vengeance, rage. In tact, psychology?",
            },
		},
		ADVENTURE_PORTAL = "My turn.",
		AMULET = "Simple spell, invaluable.",
		ANIMAL_TRACK = "Prompted defeat, heavy feet.",
		ARMORGRASS = "Greater than nothing.",
		ARMORMARBLE = "Leaping hindered, encumbered.",
		ARMORWOOD = "Vital organs, protected. Good enough.",
		ARMOR_SANITY = "My own being, malleable.",
		ASH =
		{
			GENERIC = "Remains of annihilation.",
			REMAINS_GLOMMERFLOWER = "Mistake. Apologies.",
			REMAINS_EYE_BONE = "Mistake.",
			REMAINS_THINGIE = "Mistake.",
		},
		AXE = "Unrefined implement, cutting, slashing.",
		BABYBEEFALO =
		{
			GENERIC = "Prize, amongst herd.",
		    SLEEPING = "Now, perfect time.",
        },
        BUNDLE = "Condensed, space management, optimal.",
        BUNDLEWRAP = "Increased durability, Wax.",
		BACKPACK = "For trinkets, baubles.",
		BACONEGGS = "Ah! Pleasant awakening.",
		BANDAGE = "I will live.",
		BASALT = "Rock.", --removed
		BEARDHAIR = "Hair, either human, deranged rabbit.",
		BEARGER = "Slow arms! Ha ha!",
		BEARGERVEST = "Trinket, another false apex.",
		ICEPACK = "Preferrable, long expiditions.",
		BEARGER_FUR = "Required, winter hibernation.",
		BEDROLL_STRAW = "To lay my sweet little head down.",
		BEEQUEEN = "Loud! Screeching!!",
		BEEQUEENHIVE =
		{
			GENERIC = "Bee reproduction, uncertain.",
			GROWING = "New queen, born?",
		},
        BEEQUEENHIVEGROWN = "Bee reproduction, uncertain.",
        BEEGUARD = "Mindless insect.",
        HIVEHAT = "Confidence, surging!",
        MINISIGN =
        {
            GENERIC = "Don't trip.",
            UNDRAWN = "Sight hindered, subpar artist.",
        },
        MINISIGN_ITEM = "Marker.",
		BEE =
		{
			GENERIC = "Temperament, enjoys conflicts.",
			HELD = "Sting, die.",
		},
		BEEBOX =
		{
			READY = "More than enough. Bees, idling.",
			FULLHONEY = "More than enough. Bees, idling.",
			GENERIC = "Constant buzzing. Distain.",
			NOHONEY = "Time, patience.",
			SOMEHONEY = "Production started.",
			BURNT = "Mistake.",
		},
		MUSHROOM_FARM =
		{
			STUFFED = "Good, good.",
			LOTS = "Good, good.",
			SOME = "Spores, hold taken.",
			EMPTY = "No spores, simple log.",
			ROTTEN = "Not worth it.",
			BURNT = "Not again.",
			SNOWCOVERED = "Dead of winter, nothing lives.",
		},
		BEEFALO =
		{
			FOLLOWER = "Trusting, easily.",
			GENERIC = "Fat, sufficient!",
			NAKED = "Winter survival, doomed.",
			SLEEPING = "Now, my time.",
            --Domesticated states:
            DOMESTICATED = "Unsure, domestication. Practicality outweighed, maintenance.",
            ORNERY = "War beast.",
            RIDER = "Fast, I'm faster!",
            PUDGY = "Tempting, tempting!",
            MYPARTNER = "Judgement holding.",
		},

		BEEFALOHAT = "Beefalo stares, unsettling.",
		BEEFALOWOOL = "Cold insulation, possible.",
		BEEHAT = "Beehives, bearable.",
        BEESWAX = "Common preservatives. Food, not quite. Other practicalities.",
		BEEHIVE = "Ambient noise, grating.",
		BEEMINE = "Practicality scrutinized. Spear, better alternative?",
		BEEMINE_MAXWELL = "Maker!",--removed
		BERRIES = "Eggs, fertility compromised.",
		BERRIES_COOKED = "Nutrients lacking.",
        BERRIES_JUICY = "Juice, liquid, multi-color. Crab egg, unlikely.",
        BERRIES_JUICY_COOKED = "Nutrients lacking.",
		BERRYBUSH =
		{
			BARREN = "Mother, long gone.",
			WITHERED = "Mother, long gone.",
			GENERIC = "Small bush-crab eggs, incubating.",
			PICKED = "Fertility disrupted.",
			DISEASED = "Now it stinks really good!",--removed
			DISEASING = "It's started to stink.",--removed
			BURNING = "Dying.",
		},
		BERRYBUSH_JUICY =
		{
			BARREN = "Work needed.",
			WITHERED = "Deathly heat.",
			GENERIC = "No sighting, crabs. Safe, presumably.",
			PICKED = "Natural. It will grow.",
			DISEASED = "Now it stinks really good!",--removed
			DISEASING = "It's started to stink.",--removed
			BURNING = "Dying.",
		},
		BIGFOOT = "OH-",--removed
		BIRDCAGE =
		{
			GENERIC = "Weak vulnerable, strong.",
			OCCUPIED = "Quiet enough.",
			SLEEPING = "Uses, alive.",
			HUNGRY = "Starving it.",
			STARVING = "Hungry, miserable. Known, seen.",
			DEAD = "Good job.",
			SKELETON = "Charming.",
		},
		BIRDTRAP = "Clever work, greater reward.",
		CAVE_BANANA_BURNT = "Monkey possession, few niceties. One less.",
		BIRD_EGG = "Egg. Shell, yolk. Possible fetus, ignore it.",
		BIRD_EGG_COOKED = "Storage, ruined, messy liquids!",
		BISHOP = "One of his. Exceptional shot, simply overwhelm.",
		BLOWDART_FIRE = "Bores me, little needle.",
		BLOWDART_SLEEP = "Bores me, little needle.",
		BLOWDART_PIPE = "Bores me, little needle.",
		BLOWDART_YELLOW = "Bores me, little needle.",
		BLUEAMULET = "Carapace, kept cold.",
		BLUEGEM = "Frost magic, source.",
		BLUEPRINT =
		{
            COMMON = "More designs, well invited.",
            RARE = "Knowing everything, impossible. Intentions, get close.",
        },
        SKETCH = "No tool, nor weapon, armor. Design, survival-lacking.",
		COOKINGRECIPECARD = 
		{
			GENERIC = "Artistry, cullinary.",
		},
		BLUE_CAP = "Hallucinagenic. Pass.",
		BLUE_CAP_COOKED = "To do, better things.",
		BLUE_MUSHROOM =
		{
			GENERIC = "Common hallucinagenic. Full control, preferred.",
			INGROUND = "Common mushroom. Type unknown.",
			PICKED = "Already growing.",
		},
		BOARDS = "Refined, progression.",
		BONESHARD = "Death, byproduct.",
		BONESTEW = "Broth, filling!",
		BUGNET = "Easy work.",
		BUSHHAT = "Mimicry of crab.",
		BUTTER = "Condensed flower.",
		BUTTERFLY =
		{
			GENERIC = "Flying flower.",
			HELD = "Fragility, personified.",
		},
		BUTTERFLYMUFFIN = "Contents, real flowers.",
		BUTTERFLYWINGS = "Petals, once special.",
		BUZZARD = "Stay unfulfilled, your hunger. Nothing from me.",

		SHADOWDIGGER = "Weak. Himself, no labor.",
        SHADOWDANCER = "Makers creation, taunts me.",

		CACTUS =
		{
			GENERIC = "Exterior defensive.",
			PICKED = "Heat, flourishes. Regrowth certain.",
		},
		CACTUS_MEAT_COOKED = "Spikes plucked. Good enough.",
		CACTUS_MEAT = "Eaten worse, myself.",
		CACTUS_FLOWER = "Other plants die, cactus thrives.",

		COLDFIRE =
		{
			EMBERS = "Embers untended. Now, any moment.",
			GENERIC = "Cold enough.",
			HIGH = "Curious. Frozen objects, if engulfed?",
			LOW = "Can be colder.",
			NORMAL = "Cold enough.",
			OUT = "Wood, expended.",
		},
		CAMPFIRE =
		{
			EMBERS = "Embers untended. Now, any moment.",
			GENERIC = "Hot enough.",
			HIGH = "Halt, fuel! Irrational.",
			LOW = "Can be hotter.",
			NORMAL = "Hot enough.",
			OUT = "Wood, expended.",
		},
		CANE = "Kinetic balance. Ground, pushing off.",
		CATCOON = "Bigger, once. Bipedal.",
		CATCOONDEN =
		{
			GENERIC = "Hallow log. Home, woodland creatures.",
			EMPTY = "Breathing, not heard.",
		},
		CATCOONHAT = "Beefalo, warmer.",
		COONTAIL = "Entertaining, swatting. Floaty, frilly.",
		CARROT = "Elsewhere, better.",
		CARROT_COOKED = "Inedible, shape regardless.",
		CARROT_PLANTED = "Carrot. Incompatible metabolism, myself.",
		CARROT_SEEDS = "Seeds.",
		CARTOGRAPHYDESK =
		{
			GENERIC = "For allies, slow to follow.",
			BURNING = "Unfortunate.",
			BURNT = "Unfortunate.",
		},
		WATERMELON_SEEDS = "Seeds.",
		CAVE_FERN = "Seen one, seen all.",
		CHARCOAL = "Alloy ingredient, possibly.",
        CHESSPIECE_PAWN = "Reeks, maker.",
        CHESSPIECE_ROOK =
        {
            GENERIC = "Of course, chess.",
            STRUGGLE = "Alter, restrained!",
        },
        CHESSPIECE_KNIGHT =
        {
            GENERIC = "I hate chess.",
            STRUGGLE = "Alter, restrained!",
        },
        CHESSPIECE_BISHOP =
        {
            GENERIC = "Good piece, bad game.",
            STRUGGLE = "Alter, restrained!",
        },
        CHESSPIECE_MUSE = "Charming.",
        CHESSPIECE_FORMAL = "Entertainment, mere moment.",
        CHESSPIECE_HORNUCOPIA = "Tease, mockery.",
        CHESSPIECE_PIPE = "Maker owned one. Lost?",
        CHESSPIECE_DEERCLOPS = "Another falls.",
        CHESSPIECE_BEARGER = "Another down.",
        CHESSPIECE_MOOSEGOOSE =
        {
            "Moose?",
            "Goose?",
        },
        CHESSPIECE_DRAGONFLY = "Another, dust-bitten.",
		CHESSPIECE_MINOTAUR = "True ruins guardian. Me.",
        CHESSPIECE_BUTTERFLY = "Detail acknowledged, cares given lacking.",
        CHESSPIECE_ANCHOR = "Thematic, oceanically.",
        CHESSPIECE_MOON = "Alter. Importance recognized. Reasoning sought.",
        CHESSPIECE_CARRAT = "It was slow.",
        CHESSPIECE_MALBATROSS = "Oceanic battles, personal distain.",
        CHESSPIECE_CRABKING = "Long gone, now.",
        CHESSPIECE_TOADSTOOL = "Another gone.",
        CHESSPIECE_STALKER = "Skeletal structure, ancient? Myself, built incorrectly.",
        CHESSPIECE_KLAUS = "Krampus deterrent. Theoretical.",
        CHESSPIECE_BEEQUEEN = "Another dead.",
        CHESSPIECE_ANTLION = "Should have dug away.",
        CHESSPIECE_BEEFALO = "Hungry.",
		CHESSPIECE_KITCOON = "Misunderstanding. \"cute\", meaning?",
		CHESSPIECE_CATCOON = "Hungry.",
        CHESSPIECE_MANRABBIT = "Lifeless, brainless.",
        CHESSPIECE_GUARDIANPHASE3 = "Elder man, knowledge stolen!",
        CHESSPIECE_EYEOFTERROR = "Reality perversion, gone.",
        CHESSPIECE_TWINSOFTERROR = "Piles, scrap.",
        CHESSPIECE_DEERCLOPS_MUTATED = "Last moments, thrashing. Lifeless.",
        CHESSPIECE_WARG_MUTATED = "Empty, corpselike.",
        CHESSPIECE_BEARGER_MUTATED = "Twisted from inside, lunar influence.",

        CHESSJUNK1 = "Maker's work. Unfinished. Unwelcomed, his perversions.",
        CHESSJUNK2 = "Maker's work. Unfinished. Unwelcomed, his perversions.",
        CHESSJUNK3 = "Maker's work. Unfinished. Unwelcomed, his perversions.",
		CHESTER = "Spontanious regurgitation. Multi-stomached. Hutch, evolution?",
		CHESTER_EYEBONE =
		{
			GENERIC = "Curious. Chester's sight, connected? If covered, blind?",
			WAITING = "Resting eye, none looking through.",
		},
		COOKEDMANDRAKE = "Awkward magic usage. Applications plausible.",
		COOKEDMEAT = "Losses negligable, nutritional value. Fat, maybe.",
		COOKEDMONSTERMEAT = "Poisons, partially subsided.",
		COOKEDSMALLMEAT = "Fat, micro-organisms, purged.",
		COOKPOT =
		{
			COOKING_LONG = "Meantime, hunting time.",
			COOKING_SHORT = "Momentary.",
			DONE = "Food, equals food.",
			EMPTY = "Fruit, vegetables, majority incompatible. However, nutritous accessory.",
			BURNT = "How, mistake? Simple task, flames below!",
		},
		CORN = "Hard, awkward, no.",
		CORN_COOKED = "Noisemakers, natural.",
		CORN_SEEDS = "Seeds.",
        CANARY =
		{
			GENERIC = "Rare breed. Flight uncommon.",
			HELD = "Rare. However, physicality average.",
		},
        CANARY_POISONED = "Curious. Air, plentiful feeling. Micro-organic plague?",

		CRITTERLAB = "Temptation resisted.",
        CRITTER_GLOMLING = "Elder's spawn. Survival, guaranteed alongside.",
        CRITTER_DRAGONLING = "Aboveground, once before. Dragonfly, this size.",
		CRITTER_LAMB = "Salivation, unintentional!",
        CRITTER_PUPPY = "More intimidating, usually.",
        CRITTER_KITTEN = "Lazy, sleeping dawn, day, dusk. Pairing, maker.",
        CRITTER_PERDLING = "Curious. Survival, until now?",
		CRITTER_LUNARMOTHLING = "Sapience lacking. Shame, questions arise.",

		CROW =
		{
			GENERIC = "Curious, kinship felt. Behind eyes, another watches.",
			HELD = "Who are you?",
		},
		CUTGRASS = "Malleable, strength exceptional. Rope material.",
		CUTREEDS = "Hydrophobic. Envious.",
		CUTSTONE = "Civilization, beginning.",
		DEADLYFEAST = "Yum.", --unimplemented
		DEER =
		{
			GENERIC = "Venizen!",
			ANTLER = "Horn prominent.",
		},
        DEER_ANTLER = "key hole, deer head?",
        DEER_GEMMED = "Gems, mammals, natural combination.",
		DEERCLOPS = "Faux Apex.",
		DEERCLOPS_EYEBALL = "Success, no doubts.",
		EYEBRELLAHAT =	"Not first idea.",
		DEPLETED_GRASS =
		{
			GENERIC = "Nothing here.",
		},
        GOGGLESHAT = "Confidence!",
        DESERTHAT = "Weather concerns, nil.",
        ANTLIONHAT = "Fits, familiar. Ancestry? Possible.",
		DEVTOOL = "dst funny moments",
		DEVTOOL_NODEV = "trolled",
		DIRTPILE = "Ground, disturbed.",
		DIVININGROD =
		{
			COLD = "The trail's gone cold, I feel cajoled.", --singleplayer
			GENERIC = "It will guide me where I wish to go.", --singleplayer
			HOT = "Red hot! We're near the spot!", --singleplayer
			WARM = "Hey, hey, hey! We're on our way!", --singleplayer
			WARMER = "I have to boast, we're getting close!", --singleplayer
		},
		DIVININGRODBASE =
		{
			GENERIC = "How very, very curious!", --singleplayer
			READY = "Let's hop, skip and jump out of here!", --singleplayer
			UNLOCKED = "Ooo, my fur's standing on end in anticipation!", --singleplayer
		},
		DIVININGRODSTART = "And now begins a thrilling game!", --singleplayer
		DRAGONFLY = "Game, most dangerous.",
		ARMORDRAGONFLY = "Protection, exothermal.",
		DRAGON_SCALES = "Exothermic, continuous.",
		DRAGONFLYCHEST = "Treasure horde, ours, ours alone.",
		DRAGONFLYFURNACE =
		{
			HAMMERED = "Life magic, fire, forever.",
			GENERIC = "Life magic, fire, forever.", --no gems
			NORMAL = "Life magic, fire, forever.", --one gem
			HIGH = "Life magic, fire, forever.", --two gems
		},

        HUTCH = "Nine stomachs. Space sufficient, ancient trinkets.",
        HUTCH_FISHBOWL =
        {
            GENERIC = "Used Hutch, before. Many times. Reliable.",
            WAITING = "Another approaching. Call heard, likely.",
        },
		LAVASPIT =
		{
			HOT = "Hot, alert!",
			COOL = "Self-nullified.",
		},
		LAVA_POND = "Generic, death pool.",
		LAVAE = "Hah, cute! Die!",
		LAVAE_COCOON = "Pacified.",
		LAVAE_PET =
		{
			STARVING = "Neglect, murder.",
			HUNGRY = "Hunger? Eat rocks, go.",
			CONTENT = "Disrupted, natural aging. Deemed important, them.",
			GENERIC = "Disrupted, natural aging. Deemed important, them.",
		},
		LAVAE_EGG =
		{
			GENERIC = "Dragonfly spawn.",
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "Dragonfly-spawn, heat required.",
			COMFY = "Beneficiality, doubtful.",
		},
		LAVAE_TOOTH = "My mom still has mine somewhere.",

		DRAGONFRUIT = "Minute magics, minor healing.",
		DRAGONFRUIT_COOKED = "Hm, mistake. Preparation, incorrect.",
		DRAGONFRUIT_SEEDS = "Seeds.",
		DRAGONPIE = "Magic fostered. Metabolism, incompatible.",
		DRUMSTICK = "Taste, particularly pleasant.",
		DRUMSTICK_COOKED = "It will last.",
		DUG_BERRYBUSH = "Shell relocatable.",
		DUG_BERRYBUSH_JUICY = "Near fortifications, better location.",
		DUG_GRASS = "Near fortifications, better location.",
		DUG_MARSH_BUSH = "Near fortifications, better location.",
		DUG_SAPLING = "Near fortifications, better location.",
		DURIAN = "Sense suppression, over-time learning.",
		DURIAN_COOKED = "Manure smell, preferrable.",
		DURIAN_SEEDS = "Seeds.",
		EARMUFFSHAT = "Noise suppression; hinderence, senses.",
		EGGPLANT = "More vegetables.",
		EGGPLANT_COOKED = "Smooth, odd.",
		EGGPLANT_SEEDS = "Seeds.",

		ENDTABLE =
		{
			BURNT = "Appreciation, Maker?",
			GENERIC = "Unnatural perversion.",
			EMPTY = "Holder, empty.",
			WILTED = "Lightbulb wilting.",
			FRESHLIGHT = "Lightbulb planted.",
			OLDLIGHT = "Roots, seperated. Lifespan limited.", -- will be wilted soon, light radius will be very small at this point
		},
		DECIDUOUSTREE =
		{
			BURNING = "Smoke generation, rampant.",
			BURNT = "Resources, converted.",
			CHOPPED = "Done here.",
			POISON = "Nightmare, manifested!",
			GENERIC = "Roots, fuel-soaked. Minute, mutation chance.",
		},
		ACORN = "Defensive acorn.",
        ACORN_SAPLING = "It will grow. Everything grows, dies here.",
		ACORN_COOKED = "Dead.",
		BIRCHNUTDRAKE = "Manifestations, premature!",
		EVERGREEN =
		{
			BURNING = "Smoke generation, rampant.",
			BURNT = "Resources, converted.",
			CHOPPED = "Done here.",
			GENERIC = "Large manifestation, nature.",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "Smoke generation, rampant.",
			BURNT = "Resources, converted.",
			CHOPPED = "Done here.",
			GENERIC = "Melancholic.",
		},
		TWIGGYTREE =
		{
			BURNING = "Smoke generation, rampant.",
			BURNT = "Resources, converted.",
			CHOPPED = "Done here.",
			GENERIC = "Fickle, breakable.",
			DISEASED = "Oh jeez, oh ick, that tree looks sick!", --unimplemented
		},
		TWIGGY_NUT_SAPLING = "Saplings, preferable...",
        TWIGGY_OLD = "Resources, lacking.",
		TWIGGY_NUT = "Resource, alternative.",
		EYEPLANT = "Underground, web of nerves.",
		INSPECTSELF = "Looked better, myself.",
		FARMPLOT =
		{
			GENERIC = "Cultivated dirt.",
			GROWING = "Cultivated dirt.",
			NEEDSFERTILIZER = "Cultivated dirt.",
			BURNT = "Ash.",
		},
		FEATHERHAT = "Faux kin, birds mistaken.",
		FEATHER_CROW = "Elements imbued, minor. Black, benign.",
		FEATHER_ROBIN = "Elements imbued, minor. Red, flame.",
		FEATHER_ROBIN_WINTER = "Elements imbued, minor. Blue, frost.",
		FEATHER_CANARY = "Elements imbued, minor. Yellow, electricity.",
		FEATHERPENCIL = "History, recorded. If only.",
        COOKBOOK = "Records, crafts.",
		FEM_PUPPET = "Woman.", --single player
		FIREFLIES =
		{
			GENERIC = "Beetles, congregation.",
			HELD = "Little uses, personal.",
		},
		FIREHOUND = "Offensive properties, minimal, impractical.",
		FIREPIT =
		{
			EMBERS = "Soon to extinguish.",
			GENERIC = "Hot enough.",
			HIGH = "Caution, mass.",
			LOW = "Could be hotter.",
			NORMAL = "Hot enough.",
			OUT = "Encampment center.",
		},
		COLDFIREPIT =
		{
			EMBERS = "Soon to extinguish.",
			GENERIC = "Transmutation, temperature.",
			HIGH = "Curious. Frozen, objects inserted?",
			LOW = "Can be colder.",
			NORMAL = "Transmutation, temperature.",
			OUT = "Extinguished.",
		},
		FIRESTAFF = "Life magic, instable, weaponized!",
		FIRESUPPRESSOR =
		{
			ON = "Prevention, mistakes.",
			OFF = "Fuel, conserved.",
			LOWFUEL = "Source, low energy.",
		},

		FISH = "Prey aquatic.",
		FISHINGROD = "Mind wandering. Better stimulation, Land hunting.",
		FISHSTICKS = "Sweet, fish meat.",
		FISHTACOS = "Preparation, food, luxurious.",
		FISH_COOKED = "Scraps, delicious. Issue, obtainment.",
		FLINT = "Sedimentary chert. Applications, toolworking.",
		FLOWER =
		{
            GENERIC = "Flora benign.",
            ROSE = "Odd, shape strange.",
        },
        FLOWER_WITHERED = "Dead, dying.",
		FLOWERHAT = "Ward, mental.",
		FLOWER_EVIL = "Fuel-absorbed.",
		FOLIAGE = "Purpled leaves from down below.",
		FOOTBALLHAT = "Exoskeleton, failure. Helm protective, success.",
        FOSSIL_PIECE = "...",
        FOSSIL_STALKER =
        {
			GENERIC = "Skeleton, incomplete.",
			FUNNY = "No, no! Humanoid! Aspect, insect! Ignorance!",
			COMPLETE = "Ready.",
        },
        STALKER = "Reminds me. Me.",
        STALKER_ATRIUM = "Please! Cease combat!",
        STALKER_MINION = "Speak. Please...",
        THURIBLE = "Calling. Heavy urge. Submit...",
        ATRIUM_OVERGROWTH = "Speak!",
		FROG =
		{
			DEAD = "Dead.",
			GENERIC = "Aquatic pest.",
			SLEEPING = "Snack time.",
		},
		FROGGLEBUNWICH = "Questionable.",
		FROGLEGS = "Something.",
		FROGLEGS_COOKED = "Caloric, satisfaction.",
		FRUITMEDLEY = "Passing.",
		FURTUFT = "Byproduct of hunt.",
		GEARS = "Blessings counted. Creation process, mechanisms uninvolved.",
		GHOST = "Vessel lost. Here, the outcome.",
		GOLDENAXE = "Labourous tasks, tool molding.",
		GOLDENPICKAXE = "Exploration's favorite.",
		GOLDENPITCHFORK = "Why.",
		GOLDENSHOVEL = "Long expiditions.",
		GOLDNUGGET = "Useful metals here, few, far between.",
		GRASS =
		{
			BARREN = "Flora, particular needs.",
			WITHERED = "Dying.",
			BURNING = "Flammable, particular.",
			GENERIC = "Concentration, greenery. Hand gathered.",
			PICKED = "Growth, death, same speeds.",
			DISEASED = "Dying.", --unimplemented
			DISEASING = "Dying.", --unimplemented
		},
		GRASSGEKKO =
		{
			GENERIC = "Faux fauna.",
			DISEASED = "Dying.", --unimplemented
		},
		GREEN_CAP = "Psychedelic, major.",
		GREEN_CAP_COOKED = "Properties nullified, psychadelic.",
		GREEN_MUSHROOM =
		{
			GENERIC = "Common hallucinagenic. Full control, preferred.",
			INGROUND = "Common mushroom. Type unknown.",
			PICKED = "Already growing.",
		},
		GUNPOWDER = "Destruction, en masse.",
		HAMBAT = "Food option. Supposedly.",
		HAMMER = "Mistakes, inevitable.",
		HEALINGSALVE = "Intelligent provision.",
		HEATROCK =
		{
			FROZEN = "Temperature minimal.",
			COLD = "Temperature dropping.",
			GENERIC = "Temperatures nominal.",
			WARM = "Temperature rising.",
			HOT = "Temperature maximal.",
		},
		HOME = "Home, never mine.",
		HOMESIGN =
		{
			GENERIC = "Reading, still student.",
            UNWRITTEN = "Wooden board.",
			BURNT = "Message means \"fire\".",
		},
		ARROWSIGN_POST =
		{
			GENERIC = "Reading, still student.",
            UNWRITTEN = "Wooden board.",
			BURNT = "Message means \"fire\".",
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "Reading, still student.",
            UNWRITTEN = "Wooden board.",
			BURNT = "Message means \"fire\".",
		},
		HONEY = "Nectar. Healing stimulation.",
		HONEYCOMB = "House, living maggots.",
		HONEYHAM = "Favorite, suitable!",
		HONEYNUGGETS = "Treat!",
		HORN = "Replication, mating call. Caution, consequences.",
		HOUND = "Irritant, persistant.",
		HOUNDCORPSE =
		{
			GENERIC = "Handled.",
			BURNING = "Regeneration contested.",
			REVIVING = "Curious. Regeneration magic, unknown source.",
		},
		HOUNDBONE = "Extinction, predators. Hunters, poor etiquette.",
		HOUNDMOUND = "Burrow, underground. Varglings, feral.",
		ICEBOX = "Preservation, rations.",
		ICEHAT = "Hatred.",
		ICEHOUND = "Winter's ambassador.",
		INSANITYROCK =
		{
			ACTIVE = "Sufficiently compromised, mental.",
			INACTIVE = "Mental structure, feeding.",
		},
		JAMMYPRESERVES = "Omnivores, odd.",

		KABOBS = "Less practical, more ritual.",
		KILLERBEE =
		{
			GENERIC = "Offensive, irksome.",
			HELD = "You could die.",
		},
		KNIGHT = "I hate chess.",
		KOALEFANT_SUMMER = "Dangerous hunt. Issues solved, food however.",
		KOALEFANT_WINTER = "Winter coat, thick.",
		KOALEFANT_CARCASS = "Deceased, meat taken. Another predator?",
		KRAMPUS = "Klaus-born!",
		KRAMPUS_SACK = "Karmic enchantments, Klaus-born.",
		LEIF = "Tree guardian; Fauna corrupted.",
		LEIF_SPARSE = "Tree guardian; Fauna corrupted.",
		LIGHTER  = "Owner worrisome, not tool.",
		LIGHTNING_ROD =
		{
			CHARGED = "Energy concentrated.",
			GENERIC = "Safeguard, spring weather.",
		},
		LIGHTNINGGOAT =
		{
			GENERIC = "Endangered; Prey to dogs.",
			CHARGED = "Wire-like anatomy. Conductive, offensive.",
		},
		LIGHTNINGGOATHORN = "Electric utility, knowledge lacking. Curious.",
		GOATMILK = "Mammary liquid, ionized. Enticing, not particularly.",
		LITTLE_WALRUS = "Offspring. Much to learn.",
		LIVINGLOG = "Nightmare manifestation.",
		LOG =
		{
			BURNING = "Charring rapid.",
			GENERIC = "Tree logs, basic purposes.",
		},
		LUCY = "Suspicion, curse's source.",
		LUREPLANT = "Lureplant infestation. Propogate, springtime.",
		LUREPLANTBULB = "Curious. Assumption, faux optics?",
		MALE_PUPPET = "Man.", --single player

		MANDRAKE_ACTIVE = "Rrrgh...",
		MANDRAKE_PLANTED = "Mandrake! Potent regeneration, rare flora!",
		MANDRAKE = "Properties remain, regeneration. Use wisely - no natural growth.",

        MANDRAKESOUP = "Magic propogation, hot broth.",
        MANDRAKE_COOKED = "Use it well.",
        MAPSCROLL = "Direction sense, exceptional. For others, moreso.",
        MARBLE = "Structural material. Lackluster, tool durability.",
        MARBLEBEAN = "Magic, naturally odd.",
        MARBLEBEAN_SAPLING = "Reasons for everything.",
        MARBLESHRUB = "Incubation successful.",
        MARBLEPILLAR = "Architecture. Scribed history, however ineligible.",
        MARBLETREE = "Mass sufficient, collection.",
        MARSH_BUSH =
        {
			BURNT = "Largely unchanged.",
            BURNING = "Loss, little value.",
            GENERIC = "Branches, commodity. Pass.",
            PICKED = "Subpar idea.",
        },
        BURNT_MARSH_BUSH = "Burnt.",
        MARSH_PLANT = "Generic flora.",
        MARSH_TREE =
        {
			BURNING = "Smoke generation, rampant.",
			BURNT = "Resources, converted.",
			CHOPPED = "Done here.",
			GENERIC = "In Marshlands, life struggles.",
        },
        MAXWELL = "I hate you.",--single player
        MAXWELLHEAD = "Boy if you don get outta here with yo yeeyee ass haircut.",--removed GO DO IT
        MAXWELLLIGHT = "Closer, confrontation.",--single player
        MAXWELLLOCK = "Behind it, knowledge. Curious.",--single player
        MAXWELLTHRONE = "Tool, research. I am ready.",--single player
        MEAT = "Flesh, sustainable.",
        MEATBALLS = "Condensed mass, meat.",
        MEATRACK =
        {
            DONE = "Fat, sufficiently removed.",
            DRYING = "Dehydration, unhealthy fat, dried out.",
            DRYINGINRAIN = "Likeminded, rain distaste.",
            GENERIC = "Unhealthy fat, dehydrated meat. Stimulates healing, drying.",
            BURNT = "Too dried.",
            DONE_NOTMEAT = "Dry enough.",
            DRYING_NOTMEAT = "Still drying.",
            DRYINGINRAIN_NOTMEAT = "Likeminded, rain distaste.",
        },
        MEAT_DRIED = "Fat-less, stimulates healing.",
        MERM = "Mysteries themselves, long-lasting species.",
        MERMHEAD =
        {
            GENERIC = "If caution disrespected, might be mine.",
            BURNT = "Pigmen, no power.",
        },
        MERMHOUSE =
        {
            GENERIC = "Pigman design, flawed copy.",
            BURNT = "Issue, solved.",
        },
        MINERHAT = "For surface creatures.",
        MONKEY = "Relocated here, maker's choice. An unfunny joke.",
        MONKEYBARREL = "Colony, mud monkeys. Ruins, closeby.",
        MONSTERLASAGNA = "Exceptional effort, purpose?",
        FLOWERSALAD = "Not for me.",
        ICECREAM = "Bleh! Too sweet, too sweet!",
        WATERMELONICLE = "Internal temperature, lowered.",
        TRAILMIX = "Contents, remember?",
        HOTCHILI = "...Ah! Blagh! Hot!?",
        GUACAMOLE = "Moleworm extremeties, flavor additive.",
        MONSTERMEAT = "Partial fat, partial poison. Beneficial, neither half.",
        MONSTERMEAT_DRIED = "Fat removed. Poisons remain.",
		MOOSE = { "Migrating Moose. Origin unknown.", "Migrating Goose. Origin unknown.", },
		MOOSE_NESTING_GROUND = { "Moose nest.", "Goose nest.", },
        MOOSEEGG = "Warm, sparking. Fortification, electrical?",
        MOSSLING = "Offspring. As such, unpredictable behavior.",
        FEATHERFAN = "Summer-free, caverns...",
        MINIFAN = "Really?",
        GOOSE_FEATHER = "Conductivity, electrical. Curious, elemental creature?",
        STAFF_TORNADO = "Aggrovation, climate.",
        MOSQUITO =
        {
            GENERIC = "Don't.",
            HELD = "My blood, lethal.",
        },
        MOSQUITOSACK = "Contents, mammal blood, fresh.",
        MOUND =
        {
            DUG = "Deceased, violated.",
            GENERIC = "Human grave. Sentimental items, cadaver accompanied.",
        },
        NIGHTLIGHT = "Unique enchantment, bright shadows.",
        NIGHTMAREFUEL = "My flesh, my blood.",
        NIGHTSWORD = "To live, to sacrifice.",
        NITRE = "Endothermic, flora-stimulating mineral.",
        ONEMANBAND = "My presense, remove it!",
        OASISLAKE =
		{
			GENERIC = "Deceptively deep...",
			EMPTY = "Desert shelter, off-season.",
		},
        PANDORASCHEST = "The true test.",
        PANFLUTE = "Onset incapacitation. Unsure, magic category.",
        PAPYRUS = "History, potential.",
        WAXPAPER = "Friction nil.",
        PENGUIN = "Winter, migration season.",
        PERD = "Better than berries!",
        PEROGIES = "Flavor, amalgamation. Outcome, good.",
        PETALS = "Colorful flora, handful.",
        PETALS_EVIL = "Corruption, another example.",
        PHLEGM = "Some drawbacks, hunting lifestyle.",
        PICKAXE = "Earthbreaker.",
        PIGGYBACK = "Scent, hungers me.",
        PIGHEAD =
        {
            GENERIC = "Pigs, merms, war long-lasting.",
            BURNT = "Defiled twice.",
        },
        PIGHOUSE =
        {
            FULL = "Not coming out.",
            GENERIC = "Structure, obtuse. Few strikes, hammer, destroyed.",
            LIGHTSOUT = "Door, tightly locked.",
            BURNT = "Defenses removed.",
        },
        PIGKING = "Hm. If only.",
        PIGMAN =
        {
            DEAD = "Now, meat flaying.",
            FOLLOWER = "Don't dare try.",
            GENERIC = "Limited sentience, explicit biases. Very fat, nutrient-rich.",
            GUARD = "Threatening, combat training.",
            WEREPIG = "Pigman curse! Precision lost, power gained!",
        },
        PIGSKIN = "Nutrition limited. Practical uses, however.",
        PIGTENT = "Pigmen, adapting.",
        PIGTORCH = "All creatures, ritualistic.",
        PINECONE = "Tree seed. Plant it.",
        PINECONE_SAPLING = "Come back later.",
        LUMPY_SAPLING = "What.",
        PITCHFORK = "Tool agricultural. Loose ground, lifting.",
        PLANTMEAT = "Biological lure, predators tempting. Meaty scent, lacking.",
        PLANTMEAT_COOKED = "Resemblence, steak. Myself, the judge.",
        PLANT_NORMAL =
        {
            GENERIC = "Agriculture.",
            GROWING = "Others benefitting, gatherer lifestyle.",
            READY = "Big enough.",
            WITHERED = "Eluding me, agriculture.",
        },
        POMEGRANATE = "Liquid full.",
        POMEGRANATE_COOKED = "Storage pack, liquid stained!",
        POMEGRANATE_SEEDS = "Seeds.",
        POND = "Utop fish pond, reflection... Looked better, before.",
        POOP = "Obscuration, nearby scents.",
        FERTILIZER = "Eludes me, agriculture.",
        PUMPKIN = "Large vegetation.",
        PUMPKINCOOKIE = "Value, sweet? Curious, practicalities legitimate.",
        PUMPKIN_COOKED = "Still a vegetable.",
        PUMPKIN_LANTERN = "Intimidator, maybe.",
        PUMPKIN_SEEDS = "Seeds.",
        PURPLEAMULET = "View, true world.",
        PURPLEGEM = "Shadow pseudoscience, focus.",
        RABBIT =
        {
            GENERIC = "Hunt opportunities, never overlooked.",
            HELD = "For the future.",
        },
        RABBITHOLE =
        {
            GENERIC = "Underground system, rabbit burrows. Caution, ankle injuries.",
            SPRING = "Easy fix, dig again. Rabbits preoccupied, mating season.",
        },
        RAINOMETER =
        {
            GENERIC = "Alternative better, observe clouds.",
            BURNT = "Loss, minor.",
        },
        RAINCOAT = "Feeling reassuring.",
        RAINHAT = "Needed this, before.",
        RATATOUILLE = "Bowl, greenery.",
        RAZOR = "Cutting implement, minor.",
        REDGEM = "Life magic. Flame, common manifestation.",
        RED_CAP = "Red. Clear indicator, poison.",
        RED_CAP_COOKED = "Dried out, poison. Hallucinagens remain.",
        RED_MUSHROOM =
        {
		GENERIC = "Red, assumably? Relied sense, auditory; Visual lacking.",
		INGROUND = "Common mushroom. Type unknown.",
		PICKED = "Already growing.",
        },
        REEDS =
        {
            BURNING = "Unlucky. Rare, natural growth.",
            GENERIC = "Marsh grass, thick. Paper ingredient.",
            PICKED = "Single benefit, marshland: Rich soil.",
        },
        RELIC = "Social implements, Ancients. Caution, with age, brittle.",
        RUINS_RUBBLE = "Mistake! Reconstruction?",
        RUBBLE = "History, lost.",
        RESEARCHLAB =
        {
            GENERIC = "New designs, not your own. Machine, ritualistic over science.",
            BURNT = "Science machines, replacable.",
        },
        RESEARCHLAB2 =
        {
            GENERIC = "Information granted, new sources, new categories.",
            BURNT = "Mistake. Important, machine.",
        },
        RESEARCHLAB3 =
        {
            GENERIC = "Nightmare pseudoscience, unrefined.",
            BURNT = "That's one way to nullify magic.",
        },
        RESEARCHLAB4 =
        {
            GENERIC = "Nightmare pseudoscience, ameteur level.",
            BURNT = "Hm. Time, more rabbits.",
        },
        RESURRECTIONSTATUE =
        {
            GENERIC = "Now, blood sacrifice. Later, blood restoration.",
            BURNT = "Pray, utility unused.",
        },
        RESURRECTIONSTONE = "Altar religious. Cadaver placed, consciousness restored.",
        ROBIN =
        {
            GENERIC = "Southbirds. Come winter, migrate south. Destination uncertain.",
            HELD = "Uses evaluating.",
        },
        ROBIN_WINTER =
        {
            GENERIC = "Northbirds. Origin... North. Winter magic, minor source.",
            HELD = "Uses evaluating.",
        },
        ROBOT_PUPPET = "Machine.", --single player
        ROCK_LIGHT =
        {
            GENERIC = "Rock.",--removed
            OUT = "Rock.",--removed
            LOW = "Rock.",--removed
            NORMAL = "Rock.",--removed
        },
        CAVEIN_BOULDER =
        {
            GENERIC = "Common byproduct, tectonic activity.",
            RAISED = "Stone pile, high notably.",
        },
        ROCK = "Vein, sedimentary stone. Rock, chert, nitre, common.",
        PETRIFIED_TREE = "Magic uncertain, source unseen.",
        ROCK_PETRIFIED_TREE = "Magic uncertain, source unseen.",
        ROCK_PETRIFIED_TREE_OLD = "Magic uncertain, source unseen.",
        ROCK_ICE =
        {
            GENERIC = "Important reminder, body temperature.",
            MELTED = "Dirtwater.",
        },
        ROCK_ICE_MELTED = "Dirtwater.",
        ICE = "Solid state, better.",
        ROCKS = "Generic pebbles. Tough, heat resistant, applications great.",
        ROOK = "Weaponized weight. Between rushes, downtime vulnerable.",
        ROPE = "Functions endless.",
        ROTTENEGG = "Vomit response, triggering... Bleh.",
        ROYAL_JELLY = "Queen reproduction. Nature, magical - other uses.",
        JELLYBEAN = "Magic, many forms.",
        SADDLE_BASIC = "Mounted animal, limiting. Myself, held back.",
        SADDLE_RACE = "Mounted animal, limiting. Myself, held back.",
        SADDLE_WAR = "Mounted animal, limiting. Myself, held back.",
        SADDLEHORN = "Mount, bigger target. Maintainence practicality, unseen personal.",
        SALTLICK = "Beefalo, mind not taste. Diet, grass, dirt, rocks now.",
        BRUSH = "Dirt, knots, parasites combed.",
		SANITYROCK =
		{
			ACTIVE = "Curious. Nightmare pseudoscience, sophisticated. \n Pigman ownership, why?",
			INACTIVE = "Mental compromised. Invisibility rendered.",
		},
		SAPLING =
		{
			BURNING = "Shame.",
			WITHERED = "Dreadful, summer heat.",
			GENERIC = "Exploitable runt, tree species.",
			PICKED = "It will heal.",
			DISEASED = "Dying.", --removed
			DISEASING = "Dying.", --removed
		},
   		SCARECROW =
   		{
			GENERIC = "Incorrect. I did not jump. Deterrent, not scary.",
			BURNING = "Shame.",
			BURNT = "Beholder dependent, intimidator greater, or weaker.",
   		},
   		SCULPTINGTABLE=
   		{
			EMPTY = "Blueprint understood. Now, material.",
			BLOCK = "Material primed.",
			SCULPTURE = "Trophy, large proportions.",
			BURNT = "We will live.",
   		},
        SCULPTURE_KNIGHTHEAD = "Recognization immediate, chess piece. Hmph.",
		SCULPTURE_KNIGHTBODY =
		{
			COVERED = "Natural growth, obstruction.",
			UNCOVERED = "Chess piece, broken.",
			FINISHED = "Repaired, sadly.",
			READY = "Alert! Alert!",
		},
        SCULPTURE_BISHOPHEAD = "Recognization immediate, chess piece. Hmph.",
		SCULPTURE_BISHOPBODY =
		{
			COVERED = "Natural growth, obstruction.",
			UNCOVERED = "Chess piece, broken.",
			FINISHED = "Repaired, sadly.",
			READY = "Alert! Alert!",
		},
        SCULPTURE_ROOKNOSE = "Recognization immediate, chess piece. Hmph.",
		SCULPTURE_ROOKBODY =
		{
			COVERED = "Natural growth, obstruction.",
			UNCOVERED = "Chess piece, broken.",
			FINISHED = "Repaired, sadly.",
			READY = "Alert! Alert!",
		},
        GARGOYLE_HOUND = "Too detailed, depiction artistic. Alter petrification?",
        GARGOYLE_WEREPIG = "Theory, alter shrine, important somehow.",
		SEEDS = "Seeds.",
		SEEDS_COOKED = "Agriculture invalid.",
		SEWING_KIT = "Accessory, clothing maintainence.",
		SEWING_TAPE = "Silk adhesive, application smart!",
		SHOVEL = "Implement, dirt, plant relocation.",
		SILK = "Arachnid, material biological. Adhesive, however strong.",
		SKELETON = "Stripped clean, meat, material. Now, simple reminder, mortality.",
		SCORCHED_SKELETON = "Their mistakes, learning opportunity.",
        SKELETON_NOTPLAYER = "Ancient creature? Unsure.",
		SKULLCHEST = "Subplanar magic, could learn more.", --removed
		SMALLBIRD =
		{
			GENERIC = "Tallbird adolesent. Pet, sentimental.",
			HUNGRY = "Tallbird, hunger.",
			STARVING = "If valued, sentimental, feed it now.",
			SLEEPING = "Prey, easiest possible.",
		},
		SMALLMEAT = "Make do, for now.",
		SMALLMEAT_DRIED = "Food choice, luxury.",
		SPAT = "Takedown, particularly hard. Hunt, reconsidering.",
		SPEAR = "Trademark, kings of foodchains.",
		SPEAR_WATHGRITHR = "Signature, warrior ally.",
		WATHGRITHRHAT = "Cosmetic adornments. Well served, still.",
		SPIDER =
		{
			DEAD = "Better dead!",
			GENERIC = "Anatomy, eighty percent stomach.",
			SLEEPING = "Arising, opportunity.",
		},
		SPIDERDEN = "Spider queen, incubating.",
		SPIDEREGGSACK = "Spider queen, infantile.",
		SPIDERGLAND = "Bacteria killer. Uses, wound cleaning.",
		SPIDERHAT = "Arachnids, foolish. Magic, not involved, simply appearance.",
		SPIDERQUEEN = "A spider queen. Within webbing, spider colony.",
		SPIDER_WARRIOR =
		{
			DEAD = "Done, next problem.",
			GENERIC = "Colony defender. Agile.",
			SLEEPING = "Good.",
		},
		SPOILED_FOOD = "Foodstuff, decomposed.",
        STAGEHAND =
        {
			AWAKE = "Curious, not Maker's work.",
			HIDING = "Arachnid?",
        },
        STATUE_MARBLE =
        {
            GENERIC = "Marble sculpture, history's art.",
            TYPE1 = "To time, partially lost.",
            TYPE2 = "To time, partially lost.",
            TYPE3 = "Marble sculpture, history's art.", --bird bath type statue
        },
		STATUEHARP = "Curious, feeling of love.",
		STATUEMAXWELL = "Ptoo.",
		STEELWOOL = "Clump, tough fibers. ",
		STINGER = "Venom applicant. Small, sharp, utility niche.",
		STRAWHAT = "Ward, heat fatigue.",
		STUFFEDEGGPLANT = "Nutritional surely, everything but me.",
		SWEATERVEST = "Confidence, surging.",
		REFLECTIVEVEST = "Heat wave, deflective.",
		HAWAIIANSHIRT = "Camouflage, out the window.",
		TAFFY = "Blah. Sticky mouth, floor, ceiling. Eghh.",
		TALLBIRD = "Tallbird. To a fault, territorial. Hard hitter.",
		TALLBIRDEGG = "Energizing, effort, well worth!",
		TALLBIRDEGG_COOKED = "The spoils, to victor!",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "Heat incubation, requiring.",
			GENERIC = "When adulthood reached, guardian attacked, remember my warning.",
			HOT = "Heat, killing it.",
			LONG = "When adulthood reached, guardian attacked, remember my warning.",
			SHORT = "Parenthood, prepared?",
		},
		TALLBIRDNEST =
		{
			GENERIC = "For any predator, temptation massive.",
			PICKED = "Positive, egg theft. In check, tallbird population kept.",
		},
		TEENBIRD =
		{
			GENERIC = "Any time now, instincts activate.",
			HUNGRY = "Food expecting.",
			STARVING = "Hunting experience nil, no mentor.",
			SLEEPING = "Betrayal, any day.",
		},
		TELEPORTATO_BASE =
		{
			ACTIVE = "Progress.", --single player
			GENERIC = "Progress.", --single player
			LOCKED = "Progress.", --single player
			PARTIAL = "Progress.", --single player
		},
		TELEPORTATO_BOX = "A thing.", --single player
		TELEPORTATO_CRANK = "A thing.", --single player
		TELEPORTATO_POTATO = "A thing.", --single player
		TELEPORTATO_RING = "A thing.", --single player
		TELESTAFF = "Receiver, nightmare bridge. Without focus, destination unstable.",
		TENT =
		{
			GENERIC = "Occasional rest, energy regained.",
			BURNT = "Shame.",
		},
		SIESTAHUT =
		{
			GENERIC = "Occasional rest, energy regained.",
			BURNT = "Shame.",
		},
		TENTACLE = "Limb, from abyss. Deeper. Deeper.",
		TENTACLESPIKE = "Tentacle extremity, one of many.",
		TENTACLESPOTS = "Reproduction, it spreads.",
		TENTACLE_PILLAR = "Limb, From Abyss. Getting closer.",
        TENTACLE_PILLAR_HOLE = "New caverns, open.",
		TENTACLE_PILLAR_ARM = "Recent offspring.",
		TENTACLE_GARDEN = "Garden variety.",
		TOPHAT = "Darkness appeased, fashion sense.",
		TORCH = "Darkness ward, surface dwellers.",
		TRANSISTOR = "Uncertain. Battery, perhaps.",
		TRAP = "Hunt, non-lethal.",
		TRAP_TEETH = "Smartest, always wins.",
		TRAP_TEETH_MAXWELL = "What a rude thing to leave lying around.", --single player
		TREASURECHEST =
		{
			GENERIC = "Protected storage, provisions, treasures.",
			BURNT = "At risk, contents.",
            UPGRADED_STACKSIZE = "Supplies, stacking, efficiency.",
		},
		TREASURECHEST_TRAP = "This trap, seen before.",
        CHESTUPGRADE_STACKSIZE = "Container modification, efficient.", -- Describes the kit upgrade item.
		SACRED_CHEST =
		{
			GENERIC = "Contained, potential history.",
			LOCKED = "An obstacle, to overcome.",
		},
		TREECLUMP = "Unnatural.", --removed

		TRINKET_1 = "False, not marble. Glass, rather.", --Melted Marbles
		TRINKET_2 = "Noise maker. Thankfuly, non-operational.", --Fake Kazoo
		TRINKET_3 = "A Gord's Knot. Those smart, attempt untangling. Those wise, simply cut.", --Gord's Knot
		TRINKET_4 = "Little man.", --Gnome
		TRINKET_5 = "Vehicle, some sort.", --Toy Rocketship
		TRINKET_6 = "Machination implements. Quality uncertain.", --Frazzled Wires
		TRINKET_7 = "Time waster.", --Ball and Cup
		TRINKET_8 = "Plug, odd material. Unfamiliar, curious.", --Rubber Bung
		TRINKET_9 = "Clothing accessories, degraded.", --Mismatched Buttons
		TRINKET_10 = "Repairs enamel, my saliva.", --Dentures
		TRINKET_11 = "Plaything, machine replica.", --Lying Robot
		TRINKET_12 = "Purpose, pondering.", --Dessicated Tentacle
		TRINKET_13 = "Little woman.", --Gnomette
		TRINKET_14 = "Repairable, sculpting station?", --Leaky Teacup
		TRINKET_15 = "Chess, reminder of Maker. Bad.", --Pawn
		TRINKET_16 = "Chess, reminder of Maker. Bad.", --Pawn
		TRINKET_17 = "Eating implement, germaphobes.", --Bent Spork
		TRINKET_18 = "\"Trojan Horse\" term heard, definition unaware.", --Trojan Horse
		TRINKET_19 = "The world, akin.", --Unbalanced Top
		TRINKET_20 = "Carapace, itch sensations rare.", --Backscratcher
		TRINKET_21 = "Tool, unknown.", --Egg Beater
		TRINKET_22 = "For practical uses, too brittle, torn.", --Frayed Yarn
		TRINKET_23 = "Human history, unknown. At a time, one thing.", --Shoehorn
		TRINKET_24 = "Denied, resemblence to self.", --Lucky Cat Jar
		TRINKET_25 = "Scent, decay.", --Air Unfreshener
		TRINKET_26 = "Resourceful, credit.", --Potato Cup
		TRINKET_27 = "Space management, clothing.", --Coat Hanger
		TRINKET_28 = "Feh.", --Rook
        TRINKET_29 = "Feh.", --Rook
        TRINKET_30 = "Feh.", --Knight
        TRINKET_31 = "Feh.", --Knight
        TRINKET_32 = "Trash items.", --Cubic Zirconia Ball
        TRINKET_33 = "To children, leave it.", --Spider Ring
        TRINKET_34 = "Ritual, luck.", --Monkey Paw
        TRINKET_35 = "Curious, contents previous.", --Empty Elixir
        TRINKET_36 = "Likely snap, contact with flesh.", --Faux fangs
        TRINKET_37 = "Weapon, superstitions.", --Broken Stake
        TRINKET_38 = "Shame. Optics, nonfunctional.", -- Binoculars Griftlands trinket
        TRINKET_39 = "Claws, ruining gloves.", -- Lone Glove Griftlands trinket
        TRINKET_40 = "Upper limit, nonpractical.", -- Snail Scale Griftlands trinket
        TRINKET_41 = "Non-toxic, hopefully.", -- Goop Canister Hot Lava trinket
        TRINKET_42 = "Trash items.", -- Toy Cobra Hot Lava trinket
        TRINKET_43= "Trash items.", -- Crocodile Toy Hot Lava trinket
        TRINKET_44 = "Non-toxic, hopefully.", -- Broken Terrarium ONI trinket
        TRINKET_45 = "Music. Soft. Curious, power source?", -- Odd Radio ONI trinket
        TRINKET_46 = "Nonfunctional.", -- Hairdryer ONI trinket

        -- The numbers align with the trinket numbers above.
        LOST_TOY_1  = "Trash items.",
        LOST_TOY_2  = "Trash items.",
        LOST_TOY_7  = "Trash items.",
        LOST_TOY_10 = "Trash items.",
        LOST_TOY_11 = "Trash items.",
        LOST_TOY_14 = "Trash items.",
        LOST_TOY_18 = "Trash items.",
        LOST_TOY_19 = "Trash items.",
        LOST_TOY_42 = "Trash items.",
        LOST_TOY_43 = "Trash items.",

        HALLOWEENCANDY_1 = "Various food, cosmetic.",
        HALLOWEENCANDY_2 = "Various food, cosmetic.",
        HALLOWEENCANDY_3 = "Various food, cosmetic.",
        HALLOWEENCANDY_4 = "Various food, cosmetic.",
        HALLOWEENCANDY_5 = "Various food, cosmetic.",
        HALLOWEENCANDY_6 = "Various food, cosmetic.",
        HALLOWEENCANDY_7 = "Various food, cosmetic.",
        HALLOWEENCANDY_8 = "Various food, cosmetic.",
        HALLOWEENCANDY_9 = "Various food, cosmetic.",
        HALLOWEENCANDY_10 = "Various food, cosmetic.",
        HALLOWEENCANDY_11 = "Various food, cosmetic.",
        HALLOWEENCANDY_12 = "Various food, cosmetic.", --ONI meal lice candy
        HALLOWEENCANDY_13 = "Various food, cosmetic.", --Griftlands themed candy
        HALLOWEENCANDY_14 = "Various food, cosmetic.", --Hot Lava pepper candy
        CANDYBAG = "Small size, practicalities little.",

		HALLOWEEN_ORNAMENT_1 = "Adornments cosmetic.",
		HALLOWEEN_ORNAMENT_2 = "Adornments cosmetic.",
		HALLOWEEN_ORNAMENT_3 = "Adornments cosmetic.",
		HALLOWEEN_ORNAMENT_4 = "Adornments cosmetic.",
		HALLOWEEN_ORNAMENT_5 = "Adornments cosmetic.",
		HALLOWEEN_ORNAMENT_6 = "Adornments cosmetic.",

		HALLOWEENPOTION_DRINKS_WEAK = "Elixr, potency lacking.",
		HALLOWEENPOTION_DRINKS_POTENT = "Elixr, potent.",
        HALLOWEENPOTION_BRAVERY = "Supression, flight response.",
		HALLOWEENPOTION_MOON = "Alter transmutation.",
		HALLOWEENPOTION_FIRE_FX = "Alert!",
		MADSCIENCE_LAB = "Brewery, middling elixrs.",
		LIVINGTREE_ROOT = "Unnatural growth, forced.",
		LIVINGTREE_SAPLING = "Sapling state lacking, living trees, natural.",

        DRAGONHEADHAT = "Celebration's spearhead!",
        DRAGONBODYHAT = "Celebration's core!",
        DRAGONTAILHAT = "Celebration's legs!",
        PERDSHRINE =
        {
            GENERIC = "Celebration, annual.",
            EMPTY = "Bush offering, ritualistic.",
            BURNT = "Melancholy.",
        },
        REDLANTERN = "Appeasing, visual.",
        LUCKY_GOLDNUGGET = "Gold, shape peculiar.",
        FIRECRACKERS = "Bad! Bad!",
        PERDFAN = "Heat defense, minor.",
        REDPOUCH = "Magic, unknown. Chance manipulation?",
        WARGSHRINE =
        {
            GENERIC = "Celebration, annual.",
            EMPTY = "Meat offering, ritualistic.",
            BURNING = "In flames.", --for willow to override
            BURNT = "Melancholy.",
        },
        CLAYWARG =
        {
        	GENERIC = "Pierce resistant!",
        	STATUE = "Absent before, statue. ",
        },
        CLAYHOUND =
        {
        	GENERIC = "New tactic, crushing method!",
        	STATUE = "Whistling, faint.",
        },
        HOUNDWHISTLE = "AAAAGGH!",
        CHESSPIECE_CLAYHOUND = "Replica, non-magical.",
        CHESSPIECE_CLAYWARG = "Replica, non-magical... Correct?",

		PIGSHRINE =
		{
            GENERIC = "Celebration, annual.",
            EMPTY = "Torch offering, ritualistic.",
            BURNT = "Melancholy.",
		},
		PIG_TOKEN = "Token, social ritual.",
		PIG_COIN = "Contract informal.",
		YOTP_FOOD1 = "Foodstuff, social importance.",
		YOTP_FOOD2 = "Foodstuff, social importance.",
		YOTP_FOOD3 = "Foodstuff, social importance.",

		PIGELITE1 = "Watch, learn!", --BLUE
		PIGELITE2 = "Watch, learn!", --RED
		PIGELITE3 = "Watch, learn!", --WHITE
		PIGELITE4 = "Watch, learn!", --GREEN

		PIGELITEFIGHTER1 = "Watch, learn!", --BLUE
		PIGELITEFIGHTER2 = "Watch, learn!", --RED
		PIGELITEFIGHTER3 = "Watch, learn!", --WHITE
		PIGELITEFIGHTER4 = "Watch, learn!", --GREEN

		CARRAT_GHOSTRACER = "Entertainer, competition social.",

        YOTC_CARRAT_RACE_START = "Beginning.",
        YOTC_CARRAT_RACE_CHECKPOINT = "Progress marker.",
        YOTC_CARRAT_RACE_FINISH =
        {
            GENERIC = "Ending.",
            BURNT = "Too fast.",
            I_WON = "Any doubts?",
            SOMEONE_ELSE_WON = "The victor, {winner}.",
        },

		YOTC_CARRAT_RACE_START_ITEM = "Beginning.",
        YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "Progress marker.",
		YOTC_CARRAT_RACE_FINISH_ITEM = "Ending.",

		YOTC_SEEDPACKET = "More seeds.",
		YOTC_SEEDPACKET_RARE = "Seeds, extraordinary.",

		MINIBOATLANTERN = "Curious, meaning.",

        YOTC_CARRATSHRINE =
        {
            GENERIC = "Celebration, annual.",
            EMPTY = "Carrot offering, ritualistic.",
            BURNT = "Melancholy.",
        },

        YOTC_CARRAT_GYM_DIRECTION =
        {
            GENERIC = "Training, geographical.",
            RAT = "In use.",
            BURNT = "We will live.",
        },
        YOTC_CARRAT_GYM_SPEED =
        {
            GENERIC = "Keep up.",
            RAT = "Work, satisfactory.",
            BURNT = "We will live.",
        },
        YOTC_CARRAT_GYM_REACTION =
        {
            GENERIC = "Reaction speeds, survival necessity.",
            RAT = "Dodge this.",
            BURNT = "We will live.",
        },
        YOTC_CARRAT_GYM_STAMINA =
        {
            GENERIC = "Training, stamina.",
            RAT = "In use.",
            BURNT = "We will live.",
        },

        YOTC_CARRAT_GYM_DIRECTION_ITEM = "Training implement, Carrat.",
        YOTC_CARRAT_GYM_SPEED_ITEM = "Training implement, Carrat.",
        YOTC_CARRAT_GYM_STAMINA_ITEM = "Training implement, Carrat.",
        YOTC_CARRAT_GYM_REACTION_ITEM = "Training implement, Carrat.",

        YOTC_CARRAT_SCALE_ITEM = "Suboptimal, rodents untamed.",
        YOTC_CARRAT_SCALE =
        {
            GENERIC = "Ability measurement.",
            CARRAT = "Dissapointing.",
            CARRAT_GOOD = "Satisfactory.",
            BURNT = "We will live.",
        },

        YOTB_BEEFALOSHRINE =
        {
            GENERIC = "Celebration, annual.",
            EMPTY = "Ritual. Beefalo, bare.",
            BURNT = "Melancholy.",
        },

        BEEFALO_GROOMER =
        {
            GENERIC = "Myself, not artistic.",
            OCCUPIED = "Here, an attempt.",
            BURNT = "We will live.",
        },
        BEEFALO_GROOMER_ITEM = "Myself, not artistic.",

        YOTR_RABBITSHRINE =
        {
            GENERIC = "What should we make, Woby?",
            EMPTY = "That's a hungry-looking rabbit statue.",
            BURNT = "What a waste of good supplies...",
        },

        NIGHTCAPHAT = "It's a little sleeping bag for your head.",

        YOTR_FOOD1 = "Time for a dessert break!",
        YOTR_FOOD2 = "Is that what the moon tastes like?",
        YOTR_FOOD3 = "It's so jiggly!",
        YOTR_FOOD4 = "They're not marshmallows, but they're still pretty good!",

        YOTR_TOKEN = "It's rude to hit people with gloves. You might start a fight!",

        COZY_BUNNYMAN = "They seem friendly!",

        HANDPILLOW_BEEFALOWOOL = "It's almost as good of a pillow as Woby!",
        HANDPILLOW_KELP = "Well, um... I guess there are worse things to use for a pillow?",
        HANDPILLOW_PETALS = "Don't worry, I already checked it for bees.",
        HANDPILLOW_STEELWOOL = "It's not so bad, I once made a bed out of pine needles.",

        BODYPILLOW_BEEFALOWOOL = "It's almost as good of a pillow as Woby!",
        BODYPILLOW_KELP = "Well, um... I guess there are worse things to use for a pillow?",
        BODYPILLOW_PETALS = "Don't worry, I already checked it for bees.",
        BODYPILLOW_STEELWOOL = "It's not so bad, I once made a bed out of pine needles.",

		BISHOP_CHARGE_HIT = "Rrahg!",
		TRUNKVEST_SUMMER = "Clothing, comfort.",
		TRUNKVEST_WINTER = "Clothing, frost protection.",
		TRUNK_COOKED = "All at once, swallow. Experience, easier.",
		TRUNK_SUMMER = "First, cook it. Snot, possible illnesses.",
		TRUNK_WINTER = "Thick, furry. Curious, winter aid?",
		TUMBLEWEED = "Caught bramble, wind currents.",
		TURKEYDINNER = "Context of food, amongst favorites!",
		TWIGS = "Branches. Utility, wooden implements.",
		UMBRELLA = "Yearned for, before.",
		GRASS_UMBRELLA = "Better than nothing.",
		UNIMPLEMENTED = "Bruh.",
		WAFFLES = "Crunch lacking.",
		WALL_HAY =
		{
			GENERIC = "Physical obstruction, protection.",
			BURNT = "Unfortunate.",
		},
		WALL_HAY_ITEM = "Now, weight compounded.",
		WALL_STONE = "Physical obstruction, protection.",
		WALL_STONE_ITEM = "Now, weight compounded.",
		WALL_RUINS = "Physical obstruction, protection.",
		WALL_RUINS_ITEM = "Now, weight compounded.",
		WALL_WOOD =
		{
			GENERIC = "Physical obstruction, protection.",
			BURNT = "Unfortunate.",
		},
		WALL_WOOD_ITEM = "Now, weight compounded.",
		WALL_MOONROCK = "Physical obstruction, protection.",
		WALL_MOONROCK_ITEM = "Now, weight compounded.",
		WALL_DREADSTONE = "Encased, entraped. Eternity, felt like.",
		WALL_DREADSTONE_ITEM = "Prison, known. Do not wish to re-live.",
		WALL_SCRAP = "Weak, material inefficient.",
        WALL_SCRAP_ITEM = "Weak, material inefficient.",
		FENCE = "Physical obstruction, protection.",
        FENCE_ITEM = "Now, weight compounded.",
        FENCE_GATE = "Entryway. Durability low.",
        FENCE_GATE_ITEM = "Now, weight compounded.",
		WALRUS = "Sentient hunter. Darts, traps, hound taming.",
		WALRUSHAT = "Confidence! Hunt, never hunted!",
		WALRUS_CAMP =
		{
			EMPTY = "Curious. Appearance, stonework.",
			GENERIC = "Abode of hunters. Other side, door blocked.",
		},
		WALRUS_TUSK = "Hunter, turned hunted.",
		WARDROBE =
		{
			GENERIC = "Functions, cosmetic.",
            BURNING = "Sad.",
			BURNT = "We will live.",
		},
		WARG = "Alpha! Pack leader!",
        WARGLET = "ALpha-spawn!",

		WASPHIVE = "Hostile innate.",
		WATERBALLOON = "STOP IT.",
		WATERMELON = "Water fruit. Feh.",
		WATERMELON_COOKED = "Water fruit, dried. Hm.",
		WATERMELONHAT = "Ugh.",
		WAXWELLJOURNAL =
		{
			GENERIC = "Everything's reason. My birth, included.",
--fallback to speech_wilson.lua 			NEEDSFUEL = "only_used_by_waxwell",
		},
		WETGOOP = "Mistake.",
        WHIP = "Loud! Still, hearing impaired!",
		WINTERHAT = "Warm enough.",
		WINTEROMETER =
		{
			GENERIC = "Meteorology, automated.",
			BURNT = "Evidently, too hot.",
		},

        WINTER_TREE =
        {
            BURNT = "Saddened, the others.",
            BURNING = "Saddened, the others.",
            CANDECORATE = "Barren, adornments.",
            YOUNG = "More mass, more festivity.",
        },
		WINTER_TREESTAND =
		{
			GENERIC = "Correct, missing contents?",
            BURNT = "Saddened, the others.",
		},
        WINTER_ORNAMENT = "Cosmetic adornment.",
        WINTER_ORNAMENTLIGHT = "Cosmetic adornment.",
        WINTER_ORNAMENTBOSS = "Reduced to baubles.",
		WINTER_ORNAMENTFORGE = "Story, unknown?",
		WINTER_ORNAMENTGORGE = "Story, unknown?",

        WINTER_FOOD1 = "Powder plenty. Bleh.", --gingerbread cookie
        WINTER_FOOD2 = "Too sweet.", --sugar cookie
        WINTER_FOOD3 = "Too sweet.", --candy cane
        WINTER_FOOD4 = "No.", --fruitcake
        WINTER_FOOD5 = "Lumberjack's favorite.", --yule log cake
        WINTER_FOOD6 = "Taste unappealing.", --plum pudding
        WINTER_FOOD7 = "Scent strong. Curious.", --apple cider
        WINTER_FOOD8 = "Scent appealing. Curious.", --hot cocoa
        WINTER_FOOD9 = "Scent appealing. Curious.", --eggnog

		WINTERSFEASTOVEN =
		{
			GENERIC = "Survival atmosphere, too extravogant.",
			COOKING = "Magic imbuing. Category uncertain.",
			ALMOST_DONE_COOKING = "Nearing completion, magic imbuement.",
			DISH_READY = "Contents revealed.",
		},
		BERRYSAUCE = "Curious, \"cheer\" magic? Hm.",
		BIBINGKA = "Curious, \"cheer\" magic? Hm.",
		CABBAGEROLLS = "Curious, \"cheer\" magic? Hm.",
		FESTIVEFISH = "Curious, \"cheer\" magic? Hm.",
		GRAVY = "Curious, \"cheer\" magic? Hm.",
		LATKES = "Curious, \"cheer\" magic? Hm.",
		LUTEFISK = "Curious, \"cheer\" magic? Hm.",
		MULLEDDRINK = "Curious, \"cheer\" magic? Hm.",
		PANETTONE = "Curious, \"cheer\" magic? Hm.",
		PAVLOVA = "Curious, \"cheer\" magic? Hm.",
		PICKLEDHERRING = "Curious, \"cheer\" magic? Hm.",
		POLISHCOOKIE = "Curious, \"cheer\" magic? Hm.",
		PUMPKINPIE = "Curious, \"cheer\" magic? Hm.",
		ROASTTURKEY = "Curious, \"cheer\" magic? Hm.",
		STUFFING = "Curious, \"cheer\" magic? Hm.",
		SWEETPOTATO = "Curious, \"cheer\" magic? Hm.",
		TAMALES = "Curious, \"cheer\" magic? Hm.",
		TOURTIERE = "Curious, \"cheer\" magic? Hm.",

		TABLE_WINTERS_FEAST =
		{
			GENERIC = "Table, foodstuffs.",
			HAS_FOOD = "Cheer ritual, ready.",
			WRONG_TYPE = "Incorrect.",
			BURNT = "Mistake, unfortunate.",
		},

		GINGERBREADWARG = "Sugar alpha? Cheer magic, hostile?",
		GINGERBREADHOUSE = "Sugar dogs!",
		GINGERBREADPIG = "Odd. Animation, nightmare fuel? Importance?",
		CRUMBS = "Trail, sweet scents.",
		WINTERSFEASTFUEL = "New category, magic. Intriguing.",

        KLAUS = "King of Krampii!",
        KLAUS_SACK = "Belongings, King of Krampii. Likely noticed, theft.",
		KLAUSSACKKEY = "Key, to keyhole.",
		WORMHOLE =
		{
			GENERIC = "Earthworm. Slow digestion, exploitable.",
			OPEN = "Caution, hold breath. Belongings, tightly held.",
		},
		WORMHOLE_LIMITED = "Infected.",
		ACCOMPLISHMENT_SHRINE = "Congratulations.", --single player
		LIVINGTREE = "Living Tree. Elder tree, eventually corrupted. Death, all leaves.",
		ICESTAFF = "Winter's staff!",
		REVIVER = "Blood for blood.",
		SHADOWHEART = "Exciting! The next step!",
        ATRIUM_RUBBLE =
        {
			LINE_1 = "Story, memorized. Ancient Civilization, insectoid-like.",
			LINE_2 = "Nightmare fuel, discovered.",
			LINE_3 = "Applied, accepted, utilized... Dependent.",
			LINE_4 = "Physical conversions. Mental degredation.",
			LINE_5 = "... Extinction.",
		},
        ATRIUM_STATUE = "I am close. So close.",
        ATRIUM_LIGHT =
        {
			ON = "Active!",
			OFF = "Curious, activation.",
		},
        ATRIUM_GATE =
        {
			ON = "Gateway, active!",
			OFF = "Escape, not seeking. Answers, however.",
			CHARGING = "Cacophany, nearby magic! Everything, siphoned!",
			DESTABILIZING = "I will return! Soon! Very soon!",
			COOLDOWN = "Focus power, remanifesting. Still operational.",
        },
        ATRIUM_KEY = "Curious, Guardian's treasure. Important, highly.",
		LIFEINJECTOR = "Degredation counter-acted.",
		SKELETON_PLAYER =
		{
			MALE = "%s, dead. Cause, %s.",
			FEMALE = "%s, dead. Cause, %s.",
			ROBOT = "%s, dead. Cause, %s.",
			DEFAULT = "%s, dead. Cause, %s.",
		},
--fallback to speech_wilson.lua 		HUMANMEAT = "Flesh is flesh. Where do I draw the line?",
--fallback to speech_wilson.lua 		HUMANMEAT_COOKED = "Cooked nice and pink, but still morally gray.",
--fallback to speech_wilson.lua 		HUMANMEAT_DRIED = "Letting it dry makes it not come from a human, right?",

		ROCK_MOON = "Heart, stomach, twisting, turning!",
		MOONROCKNUGGET = "Alter rock... Alter? Curious, definition instinctual.",
		MOONROCKCRATER = "Alter magic. Modification external, visual sense.",
		MOONROCKSEED = "Do tell, knowledge.",

        REDMOONEYE = "Color, difficult to recognize.",
        PURPLEMOONEYE = "Color, difficult to recognize.",
        GREENMOONEYE = "Color, difficult to recognize.",
        ORANGEMOONEYE = "Color, difficult to recognize.",
        YELLOWMOONEYE = "Color, difficult to recognize.",
        BLUEMOONEYE = "Color, difficult to recognize.",

        --Arena Event
        LAVAARENA_BOARLORD = "Another king, familiar.",
        BOARRIOR = "Loud, clumsy.",
        BOARON = "Who invited a pig to this shindig?",
        PEGHOOK = "This will be a cinch if I don't get pinched!",
        TRAILS = "You wouldn't pummel a tiny imp, would you?!",
        TURTILLUS = "We can't fight well when it's in its shell.",
        SNAPPER = "I'll have a fit if I touch that spit!",
		RHINODRILL = "Is that double I do see?",
		BEETLETAUR = "My oh my, you're a big guy!",

        LAVAARENA_PORTAL =
        {
            ON = "Hop, skip and a jump! Hyuyu!",
            GENERIC = "A fire-powered hopper.",
        },
        LAVAARENA_KEYHOLE = "It's a one-piece puzzle.",
		LAVAARENA_KEYHOLE_FULL = "And away I go!",
        LAVAARENA_BATTLESTANDARD = "Break that stake!",
        LAVAARENA_SPAWNER = "Short range hoppery!",

        HEALINGSTAFF = "A little heal will improve how you feel.",
        FIREBALLSTAFF = "Ooohoo, how delightfully chaotic!",
        HAMMER_MJOLNIR = "Clamor for the hammer!",
        SPEAR_GUNGNIR = "Live in fear of the spear!",
        BLOWDART_LAVA = "A gust of breath means flaming death!",
        BLOWDART_LAVA2 = "A gust of breath means flaming death!",
        LAVAARENA_LUCY = "Axe to the max!",
        WEBBER_SPIDER_MINION = "The itsy-iest bitsy-iest spiders!!",
        BOOK_FOSSIL = "Rock their socks off.",
		LAVAARENA_BERNIE = "How do you do, fine sir?",
		SPEAR_LANCE = "Live in fear of the spear!",
		BOOK_ELEMENTAL = "Well, it won't summon an imp!",
		LAVAARENA_ELEMENTAL = "Hyuyu, what are you!",

   		LAVAARENA_ARMORLIGHT = "So light and breezy!",
		LAVAARENA_ARMORLIGHTSPEED = "Skittery imp!",
		LAVAARENA_ARMORMEDIUM = "Knock on wood for protection!",
		LAVAARENA_ARMORMEDIUMDAMAGER = "Covered in claws!",
		LAVAARENA_ARMORMEDIUMRECHARGER = "Better! Faster!",
		LAVAARENA_ARMORHEAVY = "Hyuyu, that looks heavy!",
		LAVAARENA_ARMOREXTRAHEAVY = "I can barely move my little imp legs in it!",

		LAVAARENA_FEATHERCROWNHAT = "It tickles my horns!",
        LAVAARENA_HEALINGFLOWERHAT = "I don't want to die, hyuyu!",
        LAVAARENA_LIGHTDAMAGERHAT = "Gives me a bit of extra bite!",
        LAVAARENA_STRONGDAMAGERHAT = "Gives me a lot of extra bite!",
        LAVAARENA_TIARAFLOWERPETALSHAT = "This imp is here to help!",
        LAVAARENA_EYECIRCLETHAT = "Ooo, I feel so fancy!",
        LAVAARENA_RECHARGERHAT = "More power, faster!",
        LAVAARENA_HEALINGGARLANDHAT = "A bloom to do a bit of good!",
        LAVAARENA_CROWNDAMAGERHAT = "Hyuyu, oh the magic!",

		LAVAARENA_ARMOR_HP = "Fortified imp!",

		LAVAARENA_FIREBOMB = "Boom! Kabloom! Doom!!",
		LAVAARENA_HEAVYBLADE = "A giant sword to cut down this horde!",

        --Quagmire
        QUAGMIRE_ALTAR =
        {
        	GENERIC = "A place to place a plate!",
        	FULL = "It's full as full can be!",
    	},
		QUAGMIRE_ALTAR_STATUE1 = "A monumental statue! Hyuyu!",
		QUAGMIRE_PARK_FOUNTAIN = "How disappointing, it's all dried up.",

        QUAGMIRE_HOE = "To turn the soil, row by row.",

        QUAGMIRE_TURNIP = "That's a tiny turnip.",
        QUAGMIRE_TURNIP_COOKED = "Cooked, but not into a dish.",
        QUAGMIRE_TURNIP_SEEDS = "Strange little seeds, indeed, indeed.",

        QUAGMIRE_GARLIC = "Hissss!",
        QUAGMIRE_GARLIC_COOKED = "Hissssss!",
        QUAGMIRE_GARLIC_SEEDS = "Strange little seeds, indeed, indeed.",

        QUAGMIRE_ONION = "You'll see no tears from my eye. I cannot cry!",
        QUAGMIRE_ONION_COOKED = "Cooked, but not into a dish.",
        QUAGMIRE_ONION_SEEDS = "Strange little seeds, indeed, indeed.",

        QUAGMIRE_POTATO = "Mortals like this in all its forms. Will a wyrm?",
        QUAGMIRE_POTATO_COOKED = "Cooked, but not into a dish.",
        QUAGMIRE_POTATO_SEEDS = "Strange little seeds, indeed, indeed.",

        QUAGMIRE_TOMATO = "I could throw it at the wyrm!",
        QUAGMIRE_TOMATO_COOKED = "Cooked, but not into a dish.",
        QUAGMIRE_TOMATO_SEEDS = "Strange little seeds, indeed, indeed.",

        QUAGMIRE_FLOUR = "Mortal food powder!",
        QUAGMIRE_WHEAT = "The mortals grind it up with big rocks.",
        QUAGMIRE_WHEAT_SEEDS = "Strange little seeds, indeed, indeed.",
        --NOTE: raw/cooked carrot uses regular carrot strings
        QUAGMIRE_CARROT_SEEDS = "Strange little seeds, indeed, indeed.",

        QUAGMIRE_ROTTEN_CROP = "Yuck, muck.",

		QUAGMIRE_SALMON = "It doesn't like the air, oh no.",
		QUAGMIRE_SALMON_COOKED = "So long, sweet fish soul.",
		QUAGMIRE_CRABMEAT = "The humans like it, they do, they do!",
		QUAGMIRE_CRABMEAT_COOKED = "They like it more like this, I hear!",
		QUAGMIRE_SUGARWOODTREE =
		{
			GENERIC = "Fweehee, what a special tree!",
			STUMP = "That's a wrap on the sap.",
			TAPPED_EMPTY = "The tap will soon make sap!",
			TAPPED_READY = "Sweet, sugary sap!",
			TAPPED_BUGS = "Those bugs are tree thugs!",
			WOUNDED = "An unfortunate mishap befell the tree sap.",
		},
		QUAGMIRE_SPOTSPICE_SHRUB =
		{
			GENERIC = "I bet the mortals would like some of that.",
			PICKED = "Gone, all gone.",
		},
		QUAGMIRE_SPOTSPICE_SPRIG = "Spice! ...How nice!",
		QUAGMIRE_SPOTSPICE_GROUND = "Mortals say grinding it brings out the flavor.",
		QUAGMIRE_SAPBUCKET = "It's for filling up with sap.",
		QUAGMIRE_SAP = "Sticky, icky sap!",
		QUAGMIRE_SALT_RACK =
		{
			READY = "The minerals are ready.",
			GENERIC = "The mortals crave these minerals.",
		},

		QUAGMIRE_POND_SALT = "It's very salty water.",
		QUAGMIRE_SALT_RACK_ITEM = "It's meant to go above a pond.",

		QUAGMIRE_SAFE =
		{
			GENERIC = "None can impede this imp!",
			LOCKED = "Oh whiskers. It's locked tight.",
		},

		QUAGMIRE_KEY = "I wish to pry into hidden supplies.",
		QUAGMIRE_KEY_PARK = "No gate can stop a sneaky imp!",
        QUAGMIRE_PORTAL_KEY = "Hyuyu! Let us hop away!",


		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "A mushroom metropolis!",
			PICKED = "It's been picked clean.",
		},
		QUAGMIRE_MUSHROOMS = "There's morel where that came from, hyuyu!",
        QUAGMIRE_MEALINGSTONE = "I do enjoy this mortal chore.",
		QUAGMIRE_PEBBLECRAB = "What a funny creature!",


		QUAGMIRE_RUBBLE_CARRIAGE = "Which squeaky wheel will get the grease?",
        QUAGMIRE_RUBBLE_CLOCK = "Hickory dickory dock, hyuyu!",
        QUAGMIRE_RUBBLE_CATHEDRAL = "It all comes tumbling down.",
        QUAGMIRE_RUBBLE_PUBDOOR = "A door to nowhere, hyuyu!",
        QUAGMIRE_RUBBLE_ROOF = "It all comes tumbling down.",
        QUAGMIRE_RUBBLE_CLOCKTOWER = "The hands have stopped. Time is difficult to grasp.",
        QUAGMIRE_RUBBLE_BIKE = "Cycles spinning round and round. Bicycles double the spinning!",
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "Rubble, ruin!",
            "No souls to see.",
            "Huff and puff, and blow your house down!",
        },
        QUAGMIRE_RUBBLE_CHIMNEY = "It all comes tumbling down.",
        QUAGMIRE_RUBBLE_CHIMNEY2 = "Tumbley, rumbley, falling right down.",
        QUAGMIRE_MERMHOUSE = "Looks a bit run-down.",
        QUAGMIRE_SWAMPIG_HOUSE = "A house that's cobbled from bits and bobs.",
        QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "Nothing but bits and bobs left.",
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "My oh my, you look ill! Low of spirit, green 'round the gill.",
            SLEEPING = "Sleeping like the fishes. Hyuyu!",
        },
        QUAGMIRE_SWAMPIG = "Do you feel it loom? Your impending doom?",

        QUAGMIRE_PORTAL = "A way out or in, depending who you are.",
        QUAGMIRE_SALTROCK = "Humans use it as a \"spice\".",
        QUAGMIRE_SALT = "Mortals tongues seem to like it.",
        --food--
        QUAGMIRE_FOOD_BURNT = "Oospadoodle.",
        QUAGMIRE_FOOD =
        {
        	GENERIC = "Let's roll the dice with this sacrifice!",
            MISMATCH = "This meal looks wrong, but we don't have long.",
            MATCH = "This meal is splendid, just as intended!",
            MATCH_BUT_SNACK = "Better to serve something small than nothing at all.",
        },

        QUAGMIRE_FERN = "I wonder what it tastes like.",
        QUAGMIRE_FOLIAGE_COOKED = "Humans have odd palates.",
        QUAGMIRE_COIN1 = "Pithy pennies.",
        QUAGMIRE_COIN2 = "The Gnaw expelled it from its craw.",
        QUAGMIRE_COIN3 = "The Gnaw has spoken. We've earned its token.",
        QUAGMIRE_COIN4 = "It's a big hop token.",
        QUAGMIRE_GOATMILK = "Hyuyu! Fresh from the source.",
        QUAGMIRE_SYRUP = "For making sweet treats.",
        QUAGMIRE_SAP_SPOILED = "Whoops-a-doodle!",
        QUAGMIRE_SEEDPACKET = "Plant them in a plot of land.",

        QUAGMIRE_POT = "Mortals don't like it when you burn the things inside.",
        QUAGMIRE_POT_SMALL = "A little vessel for mortal food.",
        QUAGMIRE_POT_SYRUP = "Mortals don't like raw tree insides.",
        QUAGMIRE_POT_HANGER = "You can hang a pot on it.",
        QUAGMIRE_POT_HANGER_ITEM = "We need to build that, yes indeed.",
        QUAGMIRE_GRILL = "Mortals have lots of different cooking things.",
        QUAGMIRE_GRILL_ITEM = "We need to build that, yes indeed.",
        QUAGMIRE_GRILL_SMALL = "Mortals cook stuff on it.",
        QUAGMIRE_GRILL_SMALL_ITEM = "We need to build that, yes indeed.",
        QUAGMIRE_OVEN = "It's a thing mortals cook with.",
        QUAGMIRE_OVEN_ITEM = "We need to build that, yes indeed.",
        QUAGMIRE_CASSEROLEDISH = "I wonder how the wyrm got a taste for mortal food.",
        QUAGMIRE_CASSEROLEDISH_SMALL = "This dish is so itty bitty!",
        QUAGMIRE_PLATE_SILVER = "Are there any souls on the menu?",
        QUAGMIRE_BOWL_SILVER = "The mortals like it when food looks nice.",
--fallback to speech_wilson.lua         QUAGMIRE_CRATE = "Kitchen stuff.",

        QUAGMIRE_MERM_CART1 = "Anything fun inside?", --sammy's wagon
        QUAGMIRE_MERM_CART2 = "Mind if I take a little peek?", --pipton's cart
        QUAGMIRE_PARK_ANGEL = "I could draw a little moustache on it when no one's looking.",
        QUAGMIRE_PARK_ANGEL2 = "This one's already got a beard.",
        QUAGMIRE_PARK_URN = "There's probably nothing fun inside.",
        QUAGMIRE_PARK_OBELISK = "Nothing fun to find here.",
        QUAGMIRE_PARK_GATE =
        {
            GENERIC = "This way to the park!",
            LOCKED = "Let me out! Hyuyu, just kidding.",
        },
        QUAGMIRE_PARKSPIKE = "A wall, a wall, so very tall.",
        QUAGMIRE_CRABTRAP = "They'll feel so silly once I catch them!",
        QUAGMIRE_TRADER_MERM = "What a funny face you have!",
        QUAGMIRE_TRADER_MERM2 = "Hyuyu, what a funny moustache!",

        QUAGMIRE_GOATMUM = "I'd ask hircine, but I think it's Capricorn.",
        QUAGMIRE_GOATKID = "And who might you be?",
        QUAGMIRE_PIGEON =
        {
            DEAD = "Oh goodness, oh gracious.",
            GENERIC = "I've heard they make good pie.",
            SLEEPING = "Sleep and dream, little wing.",
        },
        QUAGMIRE_LAMP_POST = "If it were raining I could sing!",

        QUAGMIRE_BEEFALO = "I'll take the beef, you keep the \"lo\"!",
        QUAGMIRE_SLAUGHTERTOOL = "I don't like this sort of prank.",

        QUAGMIRE_SAPLING = "Tiny little baby tree.",
        QUAGMIRE_BERRYBUSH = "Mortals like berries, I think.",

        QUAGMIRE_ALTAR_STATUE2 = "No relation.",
        QUAGMIRE_ALTAR_QUEEN = "My vessel is not her vassal.",
        QUAGMIRE_ALTAR_BOLLARD = "Nothing of interest to me, I see.",
        QUAGMIRE_ALTAR_IVY = "Creeping ivy, growing strong.",

        QUAGMIRE_LAMP_SHORT = "If it were raining I could sing!",

        --v2 Winona
        WINONA_CATAPULT =
        {
        	GENERIC = "Simple atomaton, flings rocks.",
        	OFF = "Drained, lifeless.",
        	BURNING = "Unfortunate.",
        	BURNT = "Unfortunate.",
        },
        WINONA_SPOTLIGHT =
        {
        	GENERIC = "Focused light, tracking.",
        	OFF = "Lights off.",
        	BURNING = "Unfortunate.",
        	BURNT = "Unfortunate.",
        },
        WINONA_BATTERY_LOW =
        {
        	GENERIC = "Machine, lifeblood.",
        	LOWPOWER = "Power, leeched.",
        	OFF = "Drained, lifeless.",
        	BURNING = "Unfortunate.",
        	BURNT = "Unfortunate.",
        },
        WINONA_BATTERY_HIGH =
        {
        	GENERIC = "Experiments, how it starts...",
        	LOWPOWER = "Magic waning, need gems.",
        	OFF = "Drained, lifeless.",
        	BURNING = "Unfortunate.",
        	BURNT = "Unfortunate.",
        },

        --Wormwood
        COMPOSTWRAP = "Perplexing, use unknown.",
        ARMOR_BRAMBLE = "Defenses, evolution..",
        TRAP_BRAMBLE = "Trap, limited intelligence.",

        BOATFRAGMENT03 = "Fragments.",
        BOATFRAGMENT04 = "Fragments.",
        BOATFRAGMENT05 = "Fragments.",
		BOAT_LEAK = "Water damage, growing.",
        MAST = "Wind power. Simple, clever.",
        SEASTACK = "Sediment, rising from seafloor.",
        FISHINGNET = "Simple tool, effective.", --unimplemented
        ANTCHOVIES = "Little meat. Pitiful.", --unimplemented
        STEERINGWHEEL = "Destination, in control.",
        ANCHOR = "Heavy weight. Static position.",
        BOATPATCH = "Wooden, suture.",
        DRIFTWOOD_TREE =
        {
            BURNING = "Smoke generation, rampant.",
            BURNT = "Resources, converted.",
            CHOPPED = "Done here.",
            GENERIC = "Another tree, cycle ended.",
        },

        DRIFTWOOD_LOG = "Flimsy, limited use.",

        MOON_TREE =
        {
            BURNING = "Smoke generation, rampant.",
            BURNT = "Resources, converted.",
            CHOPPED = "Done here.",
            GENERIC = "Magic here, threat unknown.",
        },
		MOON_TREE_BLOSSOM = "Fallen blossom.",

        MOONBUTTERFLY =
        {
        	GENERIC = "No threat, seemingly.",
        	HELD = "Curiosity, fragile.",
        },
		MOONBUTTERFLYWINGS = "Traces here, familiar magic.",
        MOONBUTTERFLY_SAPLING = "Life renewed, curious.",
        ROCK_AVOCADO_FRUIT = "Nutrition, armored. Hurts teeth.",
        ROCK_AVOCADO_FRUIT_RIPE = "Armor broken, edible now.",
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "Sediment removed, edible.",
        ROCK_AVOCADO_FRUIT_SPROUT = "Sediment, nutritional?.",
        ROCK_AVOCADO_BUSH =
        {
			BARREN = "Work needed.",
			WITHERED = "Deathly heat.",
			GENERIC = "Curious, lunar magic.",
			PICKED = "Fruit gone, will regrow.",
			DISEASED = "Dying.", --unimplemented
            DISEASING = "Dying.", --unimplemented
			BURNING = "In flames. Death.",
		},
        DEAD_SEA_BONES = "Removed from water, 'beached'. Slow death.",
        HOTSPRING =
        {
        	GENERIC = "Hot water, good for skin. Bad for chittin.", -- scrimbles do a google, does chittin check out?
        	BOMBED = "Reaction, violent.",
        	GLASS = "Heat, pressure. Transforms water?",
			EMPTY = "Water returns, slowly.",
        },
        MOONGLASS = "Numbing feeling, bad magic?",
        MOONGLASS_CHARGED = "Stinging, bad reaction.",
        MOONGLASS_ROCK = "Glass, formed from magic.",
        BATHBOMB = "Bath... bomb? Why?",
        TRAP_STARFISH =
        {
            GENERIC = "Trap, waiting. Won't fool me.",
            CLOSED = "Grrr...",
        },
        DUG_TRAP_STARFISH = "Hunter, become hunted.",
        SPIDER_MOON =
        {
        	GENERIC = "Mutation, lunar induced.",
        	SLEEPING = "Sleeping, perfect for ambush..",
        	DEAD = "Dead.",
        },
        MOONSPIDERDEN = "Spider Queen, crushed, mutated.",
		FRUITDRAGON =
		{
			GENERIC = "Prey, thinks itself predator.",
			RIPE = "Prey, angry.",
			SLEEPING = "Feels safe. Comfortable.",
		},
        PUFFIN =
        {
            GENERIC = "Destination unknown, sea preferred.",
            HELD = "Still wet, from sea, likely.",
            SLEEPING = "Feels safe. Comfortable.",
        },

		MOONGLASSAXE = "Simple instrument, enchanted.",
		GLASSCUTTER = "Sharp, enchanted. Shadows fear it.",

        ICEBERG =
        {
            GENERIC = "Icy tooth, floating, aimless.", --unimplemented
            MELTED = "Returns to the sea.", --unimplemented
        },
        ICEBERG_MELTED = "Returns to the sea", --unimplemented

        MINIFLARE = "Provides light.",
        MEGAFLARE = "colored light? Unsure.",

		MOON_FISSURE =
		{
			GENERIC = "Proximity effect, hurts brain.",
			NOLIGHT = "A scar, deep.",
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "Unsure.",
            GENERIC = "Whispers, meaning unclear.",
        },

        MOON_ALTAR_IDOL = "One piece, removed from the whole.",
        MOON_ALTAR_GLASS = "One piece, removed from the whole.",
        MOON_ALTAR_SEED = "One piece, removed from the whole.",

        MOON_ALTAR_ROCK_IDOL = "Hidden within, lunar influence.",
        MOON_ALTAR_ROCK_GLASS = "Hidden within, lunar influence.",
        MOON_ALTAR_ROCK_SEED = "Hidden within, lunar influence.",

        MOON_ALTAR_CROWN = "Something missing, fissure perhaps?",
        MOON_ALTAR_COSMIC = "Something missing.",

        MOON_ALTAR_ASTRAL = "One piece, removed from the whole.",
        MOON_ALTAR_ICON = "One piece, removed from the whole.",
        MOON_ALTAR_WARD = "One piece, removed from the whole.",

        SEAFARING_PROTOTYPER =
        {
            GENERIC = "Adapt, conquer ocean.",
            BURNT = "Irony.",
        },
        BOAT_ITEM = "Flotation device, primitive.",
        BOAT_GRASS_ITEM = "Unreliable flotation, dangerous.",
        STEERINGWHEEL_ITEM = "Destination, control.",
        ANCHOR_ITEM = "Weight, to keep in place.",
        MAST_ITEM = "Harness wind, quicken pace.",
        MUTATEDHOUND =
        {
        	DEAD = "Death, finally.",
        	GENERIC = "Reanimated, tormented.",
        	SLEEPING = "Sleeping, ambush possible.",
        },

        MUTATED_PENGUIN =
        {
			DEAD = "Death, finally.",
			GENERIC = "Vital organs showing, easy target.",
			SLEEPING = "Sleeping, ambush possible.",
		},
        CARRAT =
        {
        	DEAD = "Death finally.",
        	GENERIC = "Walking vegetation, inedible.",
        	HELD = "Strange.",
        	SLEEPING = "Sleeping, ambush possible.",
        },

		BULLKELP_PLANT =
        {
            GENERIC = "A weed, of the sea.",
            PICKED = "Will regrow.",
        },
		BULLKELP_ROOT = "In water, could plant. No use to me.",
        KELPHAT = "Uncomfortable, madness inducing.",
		KELP = "Useless to me, leaves residue.",
		KELP_COOKED = "Useles to me, bad smells.",
		KELP_DRIED = "Dried, cracking. Still useless.",

		GESTALT = "They do not like me.",
        GESTALT_GUARD = "Hostile, natural reaction.",

		COOKIECUTTER = "Omnivore? Danger to flotation device.",
		COOKIECUTTERSHELL = "Armor, in pieces.",
		COOKIECUTTERHAT = "Spikes, natural protection. Evolution.",
		SALTSTACK =
		{
			GENERIC = "Minerals, provide flavor.",
			MINED_OUT = "Gone.",
			GROWING = "Regrowing, collecting.",
		},
		SALTROCK = " Useful material.",
		SALTBOX = "Food preservation, storage limited.",

		TACKLESTATION = "Tools, tactics.",
		TACKLESKETCH = "Reference, recreation possible.",

        MALBATROSS = "Sea dwelling beast, will take its beak.",
        MALBATROSS_FEATHER = "Shedding quickly, excess feathers.",
        MALBATROSS_BEAK = "It is mine.",
        MAST_MALBATROSS_ITEM = "Useful tool.",
        MAST_MALBATROSS = "Wind powered, natural affinity.",
		MALBATROSS_FEATHERED_WEAVE = "Together, weaved.",

        GNARWAIL =
        {
            GENERIC = "Meat, plenty. Horn, problem.",
            BROKENHORN = "Defenses lost, hunting easy.",
            FOLLOWER = "Following, assist me.",
            BROKENHORN_FOLLOWER = "Following, threat limited.",
        },
        GNARWAIL_HORN = "Weapon, dull and lacking.",

        WALKINGPLANK = "Abandon ship, if situation dangerous.",
        WALKINGPLANK_GRASS = "Abandon ship, if situation dangerous.",
        OAR = "Phyiscal instrument, acceleration.",
		OAR_DRIFTWOOD = "Phyiscal instrument, acceleration.",

		OCEANFISHINGROD = "Advanced tool, hunting, baiting.",
		OCEANFISHINGBOBBER_NONE = "Floating, baiting.",
        OCEANFISHINGBOBBER_BALL = "Floating, baiting.",
        OCEANFISHINGBOBBER_OVAL = "Floating, baiting.",
		OCEANFISHINGBOBBER_CROW = "Floating, baiting.",
		OCEANFISHINGBOBBER_ROBIN = "Floating, baiting.",
		OCEANFISHINGBOBBER_ROBIN_WINTER = "Floating, baiting.",
		OCEANFISHINGBOBBER_CANARY = "Floating, baiting.",
		OCEANFISHINGBOBBER_GOOSE = "Floating, baiting.",
		OCEANFISHINGBOBBER_MALBATROSS = "Floating, baiting.",

		OCEANFISHINGLURE_SPINNER_RED = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_SPINNER_GREEN = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_SPINNER_BLUE = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_SPOON_RED = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_SPOON_GREEN = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_SPOON_BLUE = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_HERMIT_RAIN = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_HERMIT_SNOW = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_HERMIT_DROWSY = "Mesmerising, attracts sealife.",
		OCEANFISHINGLURE_HERMIT_HEAVY = "Mesmerising, attracts sealife.",

		OCEANFISH_SMALL_1 = "Small, nutrition limited.",
		OCEANFISH_SMALL_2 = "Small, nutrition limited.",
		OCEANFISH_SMALL_3 = "Small, nutrition limited.",
		OCEANFISH_SMALL_4 = "Small, nutrition limited.",
		OCEANFISH_SMALL_5 = "Small, vegetation. Nutrition limited.",
		OCEANFISH_SMALL_6 = "Small, nutrition limited.",
		OCEANFISH_SMALL_7 = "Small, nutrition limited.",
		OCEANFISH_SMALL_8 = "Small, nutrition limited. Heat emitted.",
        OCEANFISH_SMALL_9 = "Small, nutrition limited.",

		OCEANFISH_MEDIUM_1 = "Meat, fat. Feeds for a day.",
		OCEANFISH_MEDIUM_2 = "Meat, fat. Feeds for a day.",
		OCEANFISH_MEDIUM_3 = "Meat, fat. Feeds for a day.",
		OCEANFISH_MEDIUM_4 = "Meat, fat. Feeds for a day.",
		OCEANFISH_MEDIUM_5 = "Meat, fat. Feeds for a day.",
		OCEANFISH_MEDIUM_6 = "Meat, fat. Feeds for a day.",
		OCEANFISH_MEDIUM_7 = "Meat, fat. Feeds for a day.",
		OCEANFISH_MEDIUM_8 = "Meat, fat. Feeds for a day. Emits cold.",
        OCEANFISH_MEDIUM_9 = "Meat, fat. Feeds for a day.",

		PONDFISH = "Meat, fat. Feeds for a day.",
		PONDEEL = "Meat, fat. Feeds for a day.",

        FISHMEAT = "Fish meat. Delicious.",
        FISHMEAT_COOKED = "Fish meat. Cooked. Delicious.",
        FISHMEAT_SMALL = "Fish meat, limited. Unfufilling.",
        FISHMEAT_SMALL_COOKED = "Fish meat, cooked. Still unfufilling.",
		SPOILED_FISH = "Fou smell, disgusting.",

		FISH_BOX = "Small space, stores fish. Makes aggrivating noise.", --spelling
        POCKET_SCALE = "Measures weight. Fish, specified. For show?",

		TACKLECONTAINER = "Tools, contained. For fishing.",
		SUPERTACKLECONTAINER = "Larger container, more tools contained.",

		TROPHYSCALE_FISH =
		{
			GENERIC = "Another prison, fish contained.",
			HAS_ITEM = "Weight: {weight}\nContained by: {owner}",
			HAS_ITEM_HEAVY = "Weight: {weight}\nContained by: {owner}\nMeat, plenty.",
			BURNING = "Not water, opposite element.",
			BURNT = "No water, no fish.",
			OWNER = "Fish, contained.\nWeight: {weight}\nContained by: {owner}",
			OWNER_HEAVY = "Weight: {weight}\nContained by: {owner}\nMeat, stored for later.",
		},

		OCEANFISHABLEFLOTSAM = "Grrah!",

		CALIFORNIAROLL = "Meat. Contained, easy consumption.",
		SEAFOODGUMBO = "Bowl of fish. Filling.",
		SURFNTURF = "Fish, meat, mixture. Perfect.",

        WOBSTER_SHELLER = "Shell, armored. Little protection provided.",
        WOBSTER_DEN = "Shelled creatures, hiding.",
        WOBSTER_SHELLER_DEAD = "Shell pierced, easily.",
        WOBSTER_SHELLER_DEAD_COOKED = "Just meat.",

        LOBSTERBISQUE = "Wobster meat, diluted.",
        LOBSTERDINNER = "Delicious, fattening. More butter.",

        WOBSTER_MOONGLASS = "More armor, less meat.",
        MOONGLASS_WOBSTER_DEN = "Shelled creatures, mutated. Hiding.",

		TRIDENT = "Three pronged, effective weapon.",

		WINCH =
		{
			GENERIC = "Claws, pierce water. Sunken objects, collected.",
			RETRIEVING_ITEM = "Anticipation, surprise coming.",
			HOLDING_ITEM = "Sunken object, collected.",
		},

        HERMITHOUSE = {
            GENERIC = "Creature lives here, moderate intelligence.",
            BUILTUP = "Assisted creature, still unwelcome.",
        },

        SHELL_CLUSTER = "Creature shells, missing creatures.",
        --
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "Quiet, low sound.",
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "Resonant, pleasant sound.",
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "Loud sounds, hurts.",
        },

        CHUM = "Bait, for fish. Cannot eat. Will not eat.",

        SUNKENCHEST =
        {
            GENERIC = "Mysterious object. Lost, then retrieved.", -- spelling
            LOCKED = "Locked, cannot breat.",
        },

        HERMIT_BUNDLE = "zzz remind scrimbles to look these up.", -- SCRIMBLES LOOK UP WHAT THESE ARE
        HERMIT_BUNDLE_SHELLS = "zzz remind scrimbles to look these up",

        RESKIN_TOOL = "Decorative, faint magic.",
        MOON_FISSURE_PLUGGED = "Lunar presence, contained. Effective.", -- spelling : presence


		----------------------- ROT STRINGS GO ABOVE HERE ------------------

		-- Walter
        WOBYBIG =
        {
            "Canine, mutated. Still, no threat.",
            "Canine, mutated. Still, no threat.",
        },
        WOBYSMALL =
        {
            "Canime, small. No threat.",
            "Canime, small. No threat.",
        },
		WALTERHAT = "Small, unprotective. Symbolic?",
		SLINGSHOT = "Ineffective weapon.",
		SLINGSHOTAMMO_ROCK = "Projectile, irritating.",
		SLINGSHOTAMMO_MARBLE = "Projectile, irritating.",
		SLINGSHOTAMMO_THULECITE = "Projectile, irritating.",
        SLINGSHOTAMMO_GOLD = "Projectile, irritating.",
        SLINGSHOTAMMO_SLOW = "Projectile, irritating.",
        SLINGSHOTAMMO_FREEZE = "Projectile, irritating.",
		SLINGSHOTAMMO_POOP = "Projectile, foul smell.",
        PORTABLETENT = "Small, serves its purpose ",
        PORTABLETENT_ITEM = "Portable, efficient.",

        -- Wigfrid
        BATTLESONG_DURABILITY = "Songs, performance. Familiar, yet far away.",
        BATTLESONG_HEALTHGAIN = "Songs, performance. Familiar, yet far away.",
        BATTLESONG_SANITYGAIN = "Songs, performance. Familiar, yet far away.",
        BATTLESONG_SANITYAURA = "Songs, performance. Familiar, yet far away.",
        BATTLESONG_FIRERESISTANCE = "Songs, performance. Familiar, yet far away.",
        BATTLESONG_INSTANT_TAUNT = "Songs, magic here.",
        BATTLESONG_INSTANT_PANIC = "Songs, magic here.",

        -- Webber
        MUTATOR_WARRIOR = "Not food. Refuse to eat.",
        MUTATOR_DROPPER = "Not food. Refuse to eat.",
        MUTATOR_HIDER = "Not food. Refuse to eat.",
        MUTATOR_SPITTER = "Not food. Refuse to eat.",
        MUTATOR_MOON = "Not food. Refuse to eat.",
        MUTATOR_HEALER = "Not food. Refuse to eat.",
        SPIDER_WHISTLE = "Spiders call.",
        SPIDERDEN_BEDAZZLER = "Strange symbols, undecipherable", -- zzz
        SPIDER_HEALER = "Self healing. Prime targets.",
        SPIDER_REPELLENT = "Ineffective deterrent, in my hands.",
        SPIDER_HEALER_ITEM = "Not food. Refuse to eat.", -- zzz

		-- Wendy
		GHOSTLYELIXIR_SLOWREGEN = "Vial, magic essence. Consumption dangerous.",
		GHOSTLYELIXIR_FASTREGEN = "Vial, magic essence. Consumption dangerous.",
		GHOSTLYELIXIR_SHIELD = "Vial, magic essence. Consumption dangerous.",
		GHOSTLYELIXIR_ATTACK = "Vial, magic essence. Consumption dangerous.",
		GHOSTLYELIXIR_SPEED = "Vial, magic essence. Consumption dangerous.",
		GHOSTLYELIXIR_RETALIATION = "Vial, magic essence. Consumption dangerous.",
		SISTURN =
		{
			GENERIC = "Powered, by flowers.",
			SOME_FLOWERS = "Magic, stirring.",
			LOTS_OF_FLOWERS = "Intriguing.", -- zzz
		},

        --Wortox
        WORTOX_SOUL = "only_used_by_wortox", --only wortox can inspect souls

        PORTABLECOOKPOT_ITEM =
        {
            GENERIC = "Portable device. Convenient.",
			DONE = "Food, equals food.",

			COOKING_LONG = "Meantime, hunting time.",
			COOKING_SHORT = "Momentary.",
			EMPTY = "Fruit, vegetables, majority incompatible. However, nutritous accessory.",
        },

        PORTABLEBLENDER_ITEM = "Grinding machine, produces flavor powder.",
        PORTABLESPICER_ITEM =
        {
            GENERIC = "Adds flavor. Taste is not mandatory.",
            DONE = "Excessive.",
        },
        SPICEPACK = "Food storage. Stainless, somehow.",
        SPICE_GARLIC = "With meat, goes well.",
        SPICE_SUGAR = "Fills with energy.",
        SPICE_CHILI = "Heat, spice provides adrenaline.",
        SPICE_SALT = "Minerals, ground up.",
        MONSTERTARTARE = "Visually appetizing, still poison.",
        FRESHFRUITCREPES = "No meat, just sugar. Poison.",
        FROGFISHBOWL = "Unappetizing, but filling.",
        POTATOTORNADO = "Starch, unappealing,",
        DRAGONCHILISALAD = "Spicy vegetation. Not for me.",
        GLOWBERRYMOUSSE = "No meat, all treat.",
        VOLTGOATJELLY = "Animal byproduct. Jiggly.",
        NIGHTMAREPIE = "Cruel mockery, poor idea.",
        BONESOUP = "Flavor drawn from bones.",
        MASHEDPOTATOES = "Assaulted starch. Not interested.",
        POTATOSOUFFLE = "Fancy starch. Not interested.",
        MOQUECA = "Another food.", -- zzz
        GAZPACHO = "Flavoured water. Incompatible.",
        ASPARAGUSSOUP = "Flavored water. Uninterested.",
        VEGSTINGER = "Vegetable matter, drinkable. Incompatible.",
        BANANAPOP = "Skewered fruit. Amusing, inedible.",
        CEVICHE = "zzz.", -- unsure if edible
        SALSA = "Mashed vegetables. Not interested.",
        PEPPERPOPPER = "Inedible, seems dangerous.",

        TURNIP = "From ground. Inedible, not meat.",
        TURNIP_COOKED = "Cooked. Inedible, still.",
        TURNIP_SEEDS =  "Seeds.",

        GARLIC = "From ground. Inedible, not meat.",
        GARLIC_COOKED = "Cooked. Inedible, still.",
        GARLIC_SEEDS = "Seeds.",

        ONION = "From ground. Inedible, not meat.",
        ONION_COOKED = "Cooked. Inedible, still.",
        ONION_SEEDS = "Seeds.",

        POTATO = "From ground. Inedible, not meat.",
        POTATO_COOKED = "Cooked. Inedible, still.",
        POTATO_SEEDS = "Seeds.",

        TOMATO = "From ground. Inedible, not meat.",
        TOMATO_COOKED = "Cooked. Inedible, still.",
        TOMATO_SEEDS = "Seeds.",

        ASPARAGUS = "From ground. Inedible, not meat.",
        ASPARAGUS_COOKED = "Cooked. Inedible, still.",
        ASPARAGUS_SEEDS = "Seeds.",

        PEPPER = "From ground. Inedible, not meat.",
        PEPPER_COOKED = "Cooked. Inedible, still.",
        PEPPER_SEEDS = "Seeds.",

        WEREITEM_BEAVER = "Experimenting with magic, dangerous. Unadvised.",
        WEREITEM_GOOSE = "Experimenting with magic, dangerous. Unadvised.",
        WEREITEM_MOOSE = "Experimenting with magic, dangerous. Unadvised.",

        MERMHAT = "Simple disguise, avoid bloodshed.",
        MERMTHRONE =
        {
            GENERIC = "King? Mockery. Following patterns they do not understand.",
            BURNT = "Better this way.",
        },
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "Incomplete. Primitive plan, at work.",
            BURNT = "Dust, plans faded away.",
        },
        MERMHOUSE_CRAFTED =
        {
            GENERIC = "Architecture, influence unknown.",
            BURNT = "Burnt away.",
        },

        MERMWATCHTOWER_REGULAR = "Under leadership, prosperous.", -- spelling
        MERMWATCHTOWER_NOKING = "No leader, no strength.",
        MERMKING = "Rulers, chosen by convenience. No inherent value.",
        MERMGUARD = "Evolved, stronger, faster.",
        MERM_PRINCE = "It waits, expectant.",

        SQUID = "Single eye, single purpose.",

		GHOSTFLOWER = "Life, from unlife. Many flourish here.",
        SMALLGHOST = "Young one, lost, and preserved.",

        CRABKING =
        {
            GENERIC = "Power, self inposed. Smash it.",
            INERT = "Walls, fragile to time. Build and build again.",
        },
		CRABKING_CLAW = "Claws!",

		MESSAGEBOTTLE = "Message contained. Out to sea.",
		MESSAGEBOTTLEEMPTY = "Container, nothing contained.",

        MEATRACK_HERMIT =
        {
            DONE = "Fat, sufficiently removed.",
            DRYING = "Dehydration, unhealthy fat, dried out.",
            DRYINGINRAIN = "Likeminded, rain distaste.",
            GENERIC = "Unhealthy fat, dehydrated meat. Stimulates healing, drying.",
            BURNT = "Too dried.",
            DONE_NOTMEAT = "Dry enough.",
            DRYING_NOTMEAT = "Still drying.",
            DRYINGINRAIN_NOTMEAT = "Likeminded, rain distaste.",
        },
        BEEBOX_HERMIT =
        {
			READY = "More than enough. Bees, idling.",
			FULLHONEY = "More than enough. Bees, idling.",
			GENERIC = "Constant buzzing. Distain.",
			NOHONEY = "Time, patience.",
			SOMEHONEY = "Production started.",
			BURNT = "Mistake.",
        },

        HERMITCRAB = "Exoskeleton, lonesome. Similarities end there.",

        HERMIT_PEARL = "Ocean stone, smooth. No magic, only meaning...?",
        HERMIT_CRACKED_PEARL = "Damaged. Unfortunate.",

        -- DSEAS
        WATERPLANT = "Harmless, unless provoked.",
        WATERPLANT_BOMB = "Under attack!",
        WATERPLANT_BABY = "Child, growing.",
        WATERPLANT_PLANTER = "Needs home. Perch at sea.",

        SHARK = "Formidable predator, in water.",

        MASTUPGRADE_LAMP_ITEM = "Safety, at sea.",
        MASTUPGRADE_LIGHTNINGROD_ITEM = "Safeguard, on the water.",

        WATERPUMP = "Machine, moves water.",

        BARNACLE = "Foul smell, good food.",
        BARNACLE_COOKED = "'Delicacy' means nothing.",

        BARNACLEPITA = "Wrapped in bread, mostly meat.",
        BARNACLESUSHI = "Decorative, inefficient.",
        BARNACLINGUINE = "Long wheat, unappealing.",
        BARNACLESTUFFEDFISHHEAD = "Others are picky, not me.",

        LEAFLOAF = "Meat-like, but not.",
        LEAFYMEATBURGER = "Strange form, others enjoy it.",
        LEAFYMEATSOUFFLE = "Protein, no meat smell.",
        MEATYSALAD = "Dislike 'salad'.", -- zzz can wathom eat any of this...?

        -- GROTTO

		MOLEBAT = "Mutation, purpose unclear.",
        MOLEBATHILL = "Hiding place, secrets stashed.",

        BATNOSE = "Edible, in dire situations.",
        BATNOSE_COOKED = "Food. Servicable.",
        BATNOSEHAT = "Rediculous device. 'Embarassment' known.", -- zzz / spelling

        MUSHGNOME = "Animate inanimate, lunar influence.",

        SPORE_MOON = "Dangerous, keep distance.",

        MOON_CAP = "Odd smell, poisonous?.",
        MOON_CAP_COOKED = "Odd smell still present.",

        MUSHTREE_MOON = "Lunar influence, again.",

        LIGHTFLIER = "No threat, only light.",

        GROTTO_POOL_BIG = "Glass grows, water flows. Pierced the earth, familiar.",
        GROTTO_POOL_SMALL = "Glass grows, water flows. Pierced the earth, familiar.",

        DUSTMOTH = "Another slave, born from experiments. Disgusted, but apathetic...", -- zzz spelling

        DUSTMOTHDEN = "A home.",

        ARCHIVE_LOCKBOX = "Ancient knowledge, locked away, for better, and worse.",
        ARCHIVE_CENTIPEDE = "Reanimated, guard protocols active.",
        ARCHIVE_CENTIPEDE_HUSK = "Inanimate. For now.",

        ARCHIVE_COOKPOT =
        {
			COOKING_LONG = "Meantime, hunting time.",
			COOKING_SHORT = "Momentary.",
			DONE = "Food, equals food.",
			EMPTY = "Fruit, vegetables, majority incompatible. However, nutritous accessory.",
			BURNT = "How, mistake? Simple task, flames below!",
        },

        ARCHIVE_MOON_STATUE = "Old. Forgotten. Another time, better time.",
        ARCHIVE_RUNE_STATUE =
        {
            LINE_1 = "Unfamiliar, meaning lost.",
            LINE_2 = "Language, by touch? Not sight...",
            LINE_3 = "Unfamiliar, meaning lost.",
            LINE_4 = "Language, by touch? Not sight...",
            LINE_5 = "Unfamiliar, meaning lost.",
        },

        ARCHIVE_RESONATOR = {
            GENERIC = "Searching, linking.",
            IDLE = "Everything, found.",
        },

        ARCHIVE_RESONATOR_ITEM = "Seek and discover.",

        ARCHIVE_LOCKBOX_DISPENCER = {
          POWEROFF = "Empty, no charge.",
          GENERIC =  "Ancient knowledge, liquified.",
        },

        ARCHIVE_SECURITY_DESK = {
            POWEROFF = "Locked away.",
            GENERIC = "Containment, breached.",
        },

        ARCHIVE_SECURITY_PULSE = "Artificial soul?",

        ARCHIVE_SWITCH = {
            VALID = "Siphoning power.",
            GEMS = "Power source, missing.",
        },

        ARCHIVE_PORTAL = {
            POWEROFF = "Other places, seeking, taking.",
            GENERIC = "Disconnected, long ago.",
        },

        WALL_STONE_2 = "Physical obstruction, protection.",
        WALL_RUINS_2 = "Physical obstruction, protection.",

        REFINED_DUST = "Powder, scraps.",
        DUSTMERINGUE = "Not for my kind.",

        SHROOMCAKE = "Nothing edible.",
        SHROOMBAIT = "Trap, poisonous. For lesser minds.",

        NIGHTMAREGROWTH = "From below, brings madness.",

        TURFCRAFTINGSTATION = "The prize?",

        MOON_ALTAR_LINK = "Making connection.",

        -- FARMING
        COMPOSTINGBIN =
        {
            GENERIC = "Foul smell, byproduct... useful.",
            WET = "Wet, mixture incorrect.",
            DRY = "Dry, mixture incorrect.",
            BALANCED = "Mixture, acceptable.",
            BURNT = "Nothing useful.",
        },
        COMPOST = "Farming, growing.",
        SOIL_AMENDER =
		{
			GENERIC = "Change occuring, slowly.",
			STALE = "Change is progressing.",
			SPOILED = "Chemical mixture, potent.",
		},

		SOIL_AMENDER_FERMENTED = "Ready.",

        WATERINGCAN =
        {
            GENERIC = "Liquid carrier. Cannot drink.",
            EMPTY = "Find liquids, can carry.",
        },
        PREMIUMWATERINGCAN =
        {
            GENERIC = "Beak applied. Liquid capacity, increased.",
            EMPTY = "Find liquids, can carry.",
        },

		FARM_PLOW = "For dirt.",
		FARM_PLOW_ITEM = "Creates holes, in dirt.",
		FARM_HOE = "Manual labor, little use to me.",
		GOLDEN_FARM_HOE = "Aesthetics purpose? Unknown",
		NUTRIENTSGOGGLESHAT = "Magnification, filters, knowledge revealed.",
		PLANTREGISTRYHAT = "Telekenetic link, established.",

        FARM_SOIL_DEBRIS = "Debris, to be removed.",

		FIRENETTLES = "Defense mechanism, burning.",
		FORGETMELOTS = "Memory, unclear. Threat known.",
		SWEETTEA = "Relaxing. Pleasant.",
		TILLWEED = "Parasite, removal recommended.",
		TILLWEEDSALVE = "Healing properties, intriguing.",
        WEED_IVY = "Snares, binding.",
        IVY_SNARE = "Graah!",

		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "Useless, to me",
			HAS_ITEM = "Weight: {weight}\nHarvested: {day}\nIntriguing.",
			HAS_ITEM_HEAVY = "Weight: {weight}\nHarvested: {day}\nAccomplishment?",
            HAS_ITEM_LIGHT = "Unimpressive.",
			BURNING = "Wasted.",
			BURNT = "Gone.",
        },

        CARROT_OVERSIZED = "Large vegetable. Still, inedible",
        CORN_OVERSIZED = "Large vegetable. Still, inedible",
        PUMPKIN_OVERSIZED = "Large vegetable. Still, inedible",
        EGGPLANT_OVERSIZED = "Large vegetable. Still, inedible",
        DURIAN_OVERSIZED = "Large fruit. Still, inedible",
        POMEGRANATE_OVERSIZED = "Large fruit. Still, inedible",
        DRAGONFRUIT_OVERSIZED = "Large fruit. Still, inedible",
        WATERMELON_OVERSIZED = "Large fruit. Still, inedible",
        TOMATO_OVERSIZED = "Large fruit. Still, inedible",
        POTATO_OVERSIZED = "Large vegetable. Still, inedible",
        ASPARAGUS_OVERSIZED = "Large vegetable. Still, inedible",
        ONION_OVERSIZED = "Large vegetable. Still, inedible",
        GARLIC_OVERSIZED = "Large vegetable. Still, inedible",
        PEPPER_OVERSIZED = "Large vegetable. Still, inedible",

        VEGGIE_OVERSIZED_ROTTEN = "Large vegetable. Rotted.",

		FARM_PLANT =
		{
			GENERIC = "Sprung from the earth.",
			SEED = "Mystery, waiting.",
			GROWING = "Growing, slowly",
			FULL = "Ready for harvest.",
			ROTTEN = "Rotten. Useless, to all.",
			FULL_OVERSIZED = "Apex vegetable.",
			ROTTEN_OVERSIZED = "Apex vegetable, dead.",
			FULL_WEED = "Suspect.", -- AMONG AMONG MONGUS MONGY AMON GON GON GOOSE

			BURNING = "To ashes.",
		},

        FRUITFLY = "Pest, infests crops. Irritating.",
        LORDFRUITFLY = "Pests leader, invasive, irritating.",
        FRIENDLYFRUITFLY = "Pacified, helpful.",
        FRUITFLYFRUIT = "Pheremones, controls the lesser ones.",

        SEEDPOUCH = "Storage, for plant seeds.",

		-- Crow Carnival
		CARNIVAL_HOST = "Leader, little ones follow.",
		CARNIVAL_CROWKID = "Little crow, not food.",
		CARNIVAL_GAMETOKEN = "Currency?",
		CARNIVAL_PRIZETICKET =
		{
			GENERIC = "Do not understand.",
			GENERIC_SMALLSTACK = "'Tickets'. Value, vague.",
			GENERIC_LARGESTACK = "Many 'tickets'. Good?",
		},

		CARNIVALGAME_FEEDCHICKS_NEST = "Something hiding, no scent.",
		CARNIVALGAME_FEEDCHICKS_STATION =
		{
			GENERIC = "'Game', needs currency.",
			PLAYING = "Faster to eat little ones.",
		},
		CARNIVALGAME_FEEDCHICKS_KIT = "Unfinished, to be built.",
		CARNIVALGAME_FEEDCHICKS_FOOD = "Not food. Not interested.",

		CARNIVALGAME_MEMORY_KIT = "Unfinished, to be built.",
		CARNIVALGAME_MEMORY_STATION =
		{
			GENERIC = "Sharp mind, no challenge.",
			PLAYING = "Sharp mind, no challenge.",
		},
		CARNIVALGAME_MEMORY_CARD =
		{
			GENERIC = "Memory challenge, strengthen mind.",
			PLAYING = "Memory challenge, strengthen mind.",
		},

		CARNIVALGAME_HERDING_KIT = "Unfinished, to be built.",
		CARNIVALGAME_HERDING_STATION =
		{
			GENERIC = "Control, redirection.",
			PLAYING = "Control, redirection.",
		},
		CARNIVALGAME_HERDING_CHICK = "Do not run.",

		CARNIVALGAME_SHOOTING_KIT = "Unfinished, to be built.",
		CARNIVALGAME_SHOOTING_STATION =
		{
			GENERIC = "Prefer claws over ranged implement.",
			PLAYING = "Prefer claws over ranged implement.",
		},
		CARNIVALGAME_SHOOTING_TARGET =
		{
			GENERIC = "Tear it apart.",
			PLAYING = "Tear it apart.",
		},

		CARNIVALGAME_SHOOTING_BUTTON =
		{
			GENERIC = "Activation.",
			PLAYING = "Activation.",
		},

		CARNIVALGAME_WHEELSPIN_KIT = "Unfinished, to be built.",
		CARNIVALGAME_WHEELSPIN_STATION =
		{
			GENERIC = "Round and round.",
			PLAYING = "Round and round.",
		},

		CARNIVALGAME_PUCKDROP_KIT = "Unfinished, to be built..",
		CARNIVALGAME_PUCKDROP_STATION =
		{
			GENERIC = "Result, undeterminable.",
			PLAYING = "Result, undeterminable.",
		},

		CARNIVAL_PRIZEBOOTH_KIT = "Prizes? Where?",
		CARNIVAL_PRIZEBOOTH =
		{
			GENERIC = "Junk.",
		},

		CARNIVALCANNON_KIT = "Setup required.",
		CARNIVALCANNON =
		{
			GENERIC = "Loud sounds, ineffective weapon.",
			COOLDOWN = "Pain.",
		},

		CARNIVAL_PLAZA_KIT = "Setup required.",
		CARNIVAL_PLAZA =
		{
			GENERIC = "A tree, like many others.",
			LEVEL_2 = "Decorated.",
			LEVEL_3 = "Is this 'festive'? I feel the same.",
		},

		CARNIVALDECOR_EGGRIDE_KIT = "Setup required.",
		CARNIVALDECOR_EGGRIDE = "Incubator?",

		CARNIVALDECOR_LAMP_KIT = "Setup required",
		CARNIVALDECOR_LAMP = "Little light, little protection.",
		CARNIVALDECOR_PLANT_KIT = "Setup required.",
		CARNIVALDECOR_PLANT = "Vegetation. Festive.",
		CARNIVALDECOR_BANNER_KIT = "Setup required.",
		CARNIVALDECOR_BANNER = "Decorative, bright.",

		CARNIVALDECOR_FIGURE =
		{
			RARE = "Rare. Still, worthless.",
			UNCOMMON = "Uncommon. No value.",
			GENERIC = "Common trinket, worthless.",
		},
		CARNIVALDECOR_FIGURE_KIT = "A mystery.",
		CARNIVALDECOR_FIGURE_KIT_SEASON2 = "A mystery.",

        CARNIVAL_BALL = "It bounces.", --unimplemented
		CARNIVAL_SEEDPACKET = "Cannot digest, useless to me.",
		CARNIVALFOOD_CORNTEA = "Liquid, contains chunks.",

        CARNIVAL_VEST_A = "Camoflage.", -- zzz look up colors for a b c
        CARNIVAL_VEST_B = "Camoflage.",
        CARNIVAL_VEST_C = "Camoflage.",

        -- YOTB
        YOTB_SEWINGMACHINE = "For repairing? For creation.",
        YOTB_SEWINGMACHINE_ITEM = "Setup required.",
        YOTB_STAGE = "Stranger, comes and goes. Unknown.",
        YOTB_POST =  "Beasts, on leashes.",
        YOTB_STAGE_ITEM = "Setup required.",
        YOTB_POST_ITEM =  "Setup required.",


        YOTB_PATTERN_FRAGMENT_1 = "Fragments. Sewn together, could make patterns.",
        YOTB_PATTERN_FRAGMENT_2 = "Fragments. Sewn together, could make patterns.",
        YOTB_PATTERN_FRAGMENT_3 = "Fragments. Sewn together, could make patterns.",

        YOTB_BEEFALO_DOLL_WAR = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_DOLL = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_FESTIVE = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_NATURE = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_ROBOT = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_ICE = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_FORMAL = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_VICTORIAN = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },
        YOTB_BEEFALO_DOLL_BEAST = {
            GENERIC = "Totem, soft. Brush, brush.",
            YOTB = "My handiwork, to be judged.",
        },

        WAR_BLUEPRINT = "War, mockery.",
        DOLL_BLUEPRINT = "'Cuteness', defense mechanism.",
        FESTIVE_BLUEPRINT = "Celebration, warm feelings.",
        ROBOT_BLUEPRINT = "Construct, future designs.",
        NATURE_BLUEPRINT = "All natural.",
        FORMAL_BLUEPRINT = "Elegant.",
        VICTORIAN_BLUEPRINT = "Ancient fashion, from another world.",
        ICE_BLUEPRINT = "Frozen..",
        BEAST_BLUEPRINT = "Fearson, scare opponents.",

        BEEF_BELL = "Controlling noise, instinctive.", -- spelling

		-- YOT Catcoon
		KITCOONDEN =
		{
			GENERIC = "Something, hiding?",
            BURNT = "Gone.",
			PLAYING_HIDEANDSEEK = "They are hiding.",
			PLAYING_HIDEANDSEEK_TIME_ALMOST_UP = "Hiding, hunt ends soon.",
		},

		KITCOONDEN_KIT = "Setup required.",

		TICOON =
		{
			GENERIC = "Searching, hunting.",
			ABANDONED = "I'll find, alone.",
			SUCCESS = "Ally, hunt succesful",
			LOST_TRACK = "Mark found, too late.",
			NEARBY = "Closing in.",
			TRACKING = "On the hunt, I will follow.",
			TRACKING_NOT_MINE = "Not my hunt.",
			NOTHING_TO_TRACK = "Nothing to find. Hunt is over.",
			TARGET_TOO_FAR_AWAY = "Far away, cannot track.",
		},

		YOT_CATCOONSHRINE =
        {
            GENERIC = "Altar, knowledge, inspiration.",
            EMPTY = "With feather, pact made.",
            BURNT = "Inspiration, gone.",
        },

		KITCOON_FOREST = "Tracking beast, no threat to me.",
		KITCOON_SAVANNA = "Tracking beast, no threat to me.",
		KITCOON_MARSH = "Tracking beast, no threat to me.",
		KITCOON_DECIDUOUS = "Tracking beast, no threat to me.",
		KITCOON_GRASS = "Tracking beast, no threat to me.",
		KITCOON_ROCKY = "Tracking beast, no threat to me.",
		KITCOON_DESERT = "Tracking beast, no threat to me.",
		KITCOON_MOON = "Tracking beast, no threat to me.",
		KITCOON_YOT = "Tracking beast, no threat to me.",

        -- Moon Storm
        ALTERGUARDIAN_PHASE1 = {
            GENERIC = "Challenger, protector!",
            DEAD = "Playing dead.",
        },
        ALTERGUARDIAN_PHASE2 = {
            GENERIC = "Armor, shedding.",
            DEAD = "Living... breathing.",
        },
        ALTERGUARDIAN_PHASE2SPIKE = "Piercing!",
        ALTERGUARDIAN_PHASE3 = "Lunar magic, resonant!", -- spelling : resonant
        ALTERGUARDIAN_PHASE3TRAP = "Sleep... induced...",
        ALTERGUARDIAN_PHASE3DEADORB = "Lunar magic, fading.",
        ALTERGUARDIAN_PHASE3DEAD = "Light, gone.",

        ALTERGUARDIANHAT = "Thoughts become clear. It pulls me together.",
        ALTERGUARDIANHATSHARD = "Essence, split.", -- spelling : essence

        MOONSTORM_GLASS = {
            GENERIC = "Lunar fragment, sharp. Magic lingering.",
            INFUSED = "Magic flows, skin tingles."
        },

        MOONSTORM_STATIC = "Lunar energy.",
        MOONSTORM_STATIC_ITEM = "Argh! Hurts skin.",
        MOONSTORM_SPARK = "zzz", -- whats a lunar spark vs static?

        BIRD_MUTANT = "'Crow', mutated.",
        BIRD_MUTANT_SPITTER = "Southbird, mutated.",

        WAGSTAFF_NPC = "Stuck, between the worlds.",

        WAGSTAFF_NPC_MUTATIONS = "Stuck, between the worlds.",
        WAGSTAFF_NPC_WAGPUNK = "Stuck, between the worlds.",
		
        ALTERGUARDIAN_CONTAINED = "Lunar soul, trapped. Empathy? Something wrong.",

        WAGSTAFF_TOOL_1 = "A tool, useless in my hands.",
        WAGSTAFF_TOOL_2 = "A tool, useless in my hands.",
        WAGSTAFF_TOOL_3 = "A tool, useless in my hands.",
        WAGSTAFF_TOOL_4 = "A tool, useless in my hands.",
        WAGSTAFF_TOOL_5 = "A tool, useless in my hands.",

        MOONSTORM_GOGGLESHAT = "Purpose of vegetable? Unknown.",

        MOON_DEVICE = {
            GENERIC = "Contains the soul.",
            CONSTRUCTION1 = "Device, unfinished.",
            CONSTRUCTION2 = "Work, still required.",
        },

		-- Wanda
        POCKETWATCH_HEAL = {
			GENERIC = "Magic, contained. Unsure of origin.",
			RECHARGING = "Gathering energy.",
		},

        POCKETWATCH_REVIVE = {
			GENERIC = "Magic, contained. Unsure of origin.",
			RECHARGING = "Gathering energy.",
		},

        POCKETWATCH_WARP = {
			GENERIC = "Magic, contained. Unsure of origin.",
			RECHARGING = "Gathering energy.",
		},

        POCKETWATCH_RECALL = {
			GENERIC = "Magic, contained. Unsure of origin.",
			RECHARGING = "Gathering energy.",
			UNMARKED = "only_used_by_wanda",
			MARKED_SAMESHARD = "only_used_by_wanda",
			MARKED_DIFFERENTSHARD = "only_used_by_wanda",
		},

        POCKETWATCH_PORTAL = {
			GENERIC = "Magic, contained. Unsure of origin.",
			RECHARGING = "Gathering energy.",
			UNMARKED = "only_used_by_wanda unmarked",
			MARKED_SAMESHARD = "only_used_by_wanda same shard",
			MARKED_DIFFERENTSHARD = "only_used_by_wanda other shard",
		},

        POCKETWATCH_WEAPON = {
			GENERIC = "Magic, contained. Unsure of origin.",
			DEPLETED = "only_used_by_wanda",
		},

        POCKETWATCH_PARTS = "Magic, technology, combined. Knowledge gained, how?",
        POCKETWATCH_DISMANTLER = "Clockmakers tool.",

        POCKETWATCH_PORTAL_ENTRANCE =
		{
			GENERIC = "Portal, localized.",
			DIFFERENTSHARD = "Portal, localized.",
		},
        POCKETWATCH_PORTAL_EXIT = "No entry, from this end.",

        -- Waterlog
        WATERTREE_PILLAR = "Size, impressive. Magically altered?",
        OCEANTREE = "Water, all around, lives in its food source.",
        OCEANTREENUT = "To be planted, waiting.",
        WATERTREE_ROOT = "Spreding, entangling.",

        OCEANTREE_PILLAR = "Size, impressive. Growth? Surprising.",

        OCEANVINE = "Alive, perhaps. Careful.",
        FIG = "Another incompatible food.",
        FIG_COOKED = "No good.",

        SPIDER_WATER = "Adapted to enviornments.",
        MUTATOR_WATER = "Not food. Refuse to eat.",
        OCEANVINE_COCOON = "Home of the water predator.",
        OCEANVINE_COCOON_BURNT = "Home, no longer.",

        GRASSGATOR = "Large prey, poses little threat, if undisturbed.",

        TREEGROWTHSOLUTION = "Food, for the trees.",

        FIGATONI = "Efficient food shape. Cannot eat.",
        FIGKABAB = "Pierced and skewered.",
        KOALEFIG_TRUNK = "Meat is ruined.",
        FROGNEWTON = "Disrupting the nutrients.",

        -- The Terrorarium
        TERRARIUM = {
            GENERIC = "Another dimesion, connected.",
            CRIMSON = "Fueled, reacting typically.",
            ENABLED = "Suprising, bad feeling.",
			WAITING_FOR_DARK = "It grows in darkness.",
			COOLDOWN = "Regenerating.",
			SPAWN_DISABLED = "Magic, inert.",
        },

        -- Wolfgang
        MIGHTY_GYM =
        {
            GENERIC = "For growing muscles. Inefficient design.",
            BURNT = "For nothing, evermore.",
        },

        DUMBBELL = "Inefficient weapon, too heavy.",
        DUMBBELL_GOLDEN = "Distracting.",
		DUMBBELL_MARBLE = "Can lift, barely.",
        DUMBBELL_GEM = "Magic, inert. It is just heavier.",
        POTATOSACK = "Potato storage.",

        DUMBBELL_HEAT = "Takes properties of enviornment.",
        DUMBBELL_REDGEM = "Waste of magic.",
        DUMBBELL_BLUEGEM = "Waste of magic.",

        TERRARIUMCHEST =
		{
			GENERIC = "Storage, from another dimension.",
			BURNT = "Magic removed.",
			SHIMMER = "Careful...",
		},

		EYEMASKHAT = "Head of enemy, now protective tool.",

        EYEOFTERROR = "Weak spot, located.",
        EYEOFTERROR_MINI = "Minions, destroy them.",
        EYEOFTERROR_MINI_GROUNDED = "Egg, hatching.",

        FROZENBANANADAIQUIRI = "Cold, inedible.",
        BUNNYSTEW = "Little food. Will do.",
        MILKYWHITES = "Organic material.",

        CRITTER_EYEOFTERROR = "Watches, for me.",

        SHIELDOFTERROR ="Protective, can smash.",
        TWINOFTERROR1 = "Watch out, magical influence.",
        TWINOFTERROR2 = "Watch out, magical influence.",

		-- Cult of the Lamb
		COTL_TRINKET = "Another crown, worthless.",
		TURF_COTL_GOLD = "Floor.",
		TURF_COTL_BRICK = "Floor.",
		COTL_TABERNACLE_LEVEL1 =
		{
			LIT = "Illuminates.",
			GENERIC = "Fire, could host.",
		},
		COTL_TABERNACLE_LEVEL2 =
		{
			LIT = "Illuminates Magical prescence.", -- spelling, precense pressence uhhh
			GENERIC = "Fire, could host.",
		},
		COTL_TABERNACLE_LEVEL3 =
		{
			LIT = "Magical influence, mind altering...",
			GENERIC = "Fire, could host.",
		},

        -- Year of the Catcoon
        CATTOY_MOUSE = "Will not play with. Refuse.",
        KITCOON_NAMETAG = "Names, ownership.",

		KITCOONDECOR1 =
        {
            GENERIC = "Pacify the creatures.",
            BURNT = "Burnt.",
        },
		KITCOONDECOR2 =
        {
            GENERIC = "Lures the Kits.",
            BURNT = "Lures nothing.",
        },

		KITCOONDECOR1_KIT = "Setup, required.",
		KITCOONDECOR2_KIT = "Setup, required.",

        -- WX78
        WX78MODULE_MAXHEALTH = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MAXSANITY1 = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MAXSANITY = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MOVESPEED = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MOVESPEED2 = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_HEAT = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_NIGHTVISION = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_COLD = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_TASER = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_LIGHT = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MAXHUNGER1 = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MAXHUNGER = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MUSIC = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_BEE = "Technology, path to corruption. Careful, around false one.",
        WX78MODULE_MAXHEALTH2 = "Technology, path to corruption. Careful, around false one.",

        WX78_SCANNER =
        {
            GENERIC ="Automaton, similar to Ancients design.",
            HUNTING = "Hunting.",
            SCANNING = "Something, found.",
        },

        WX78_SCANNER_ITEM = "Inactive, safe this way.",
        WX78_SCANNER_SUCCEEDED = "Knowledge, contained. Waiting to share.",

        WX78_MODULEREMOVER = "Disasembly implement.", -- spelling : disasembly??

        SCANDATA = "Cannot read this.",

		-- QOL 2022
		JUSTEGGS = "Life, gone. Only good to eat.",
		VEGGIEOMLET = "Egg, diluted.", -- zzz can wathom eat? probably
		TALLEGGS = "More eggs. More food.",
		BEEFALOFEED = "Digestive system, incompatible.",
		BEEFALOTREAT = "Insulting.",

        -- Pirates
        BOAT_ROTATOR = "Direction, readjustment. Master of seas.",
        BOAT_ROTATOR_KIT = "Machinery, spins around.",
        BOAT_BUMPER_KELP = "Weak cushioning, inefficient.",
        BOAT_BUMPER_KELP_KIT = "Like cloth, little protection.",
        BOAT_BUMPER_SHELL = "Another creatures protection, once. Now ours.",
        BOAT_BUMPER_SHELL_KIT = "Shell, repurposed.",
        BOAT_CANNON = {
            GENERIC = "War machinery.",
            AMMOLOADED = "Aim, shoot, kill.",
            NOAMMO = "Ammunition, required.",
        },
        BOAT_CANNON_KIT = "War machinery. Setup required.",
        CANNONBALL_ROCK_ITEM = "Ammunition, machinery required.",

        OCEAN_TRAWLER = {
            GENERIC = "Plunders the depths, automated.",
            LOWERED = "Might catch fish, or debris.",
            CAUGHT = "Something, caught.",
            ESCAPED = "Eluded net, intelligent creature.", -- speling : eluded
            FIXED = "Repaired, renewed.",
        },
        OCEAN_TRAWLER_KIT = "Could catch fish.",

        BOAT_MAGNET =
        {
            GENERIC = "Facinating, magnets. How do they work?", -- spelling: facinating
            ACTIVATED = "Invisible force, at work.",
        },
        BOAT_MAGNET_KIT = "Practical use, unclear.",

        BOAT_MAGNET_BEACON =
        {
            GENERIC = "Guiding beacon, attracts.",
            ACTIVATED = "Attracting opposites.", -- spelling: opposite ... REAL
        },
        DOCK_KIT = "Land extension, artificial.",
        DOCK_WOODPOSTS_ITEM = "Decorative, function unclear.",

        MONKEYHUT =
        {
            GENERIC = "Stable land, preferabble. Height... worrysome.", -- spelling: worrysome worry-some? 
            BURNT = "Flammable, regardless.",
        },
        POWDER_MONKEY = "Semi intelligent, dangerous all the same.",
        PRIME_MATE = "Leader, prime target.", -- HEHEHE SCRIMBLES WUZ HERE
		LIGHTCRAB = "Anti defense mechanism.",
        CUTLESS = "Wood, poor material for weapons.",
        CURSED_MONKEY_TOKEN = "Magic, form changing. Clinging.",
        OAR_MONKEY = "Efficient.",
        BANANABUSH = "Grows food, for primates.",
        DUG_BANANABUSH = "Plant, waiting for dirt.",
        PALMCONETREE = "Nature, wrong climate.",
        PALMCONE_SEED = "Tree, infant.",
        PALMCONE_SAPLING = "Thin, weak.",
        PALMCONE_SCALE = "Tree, armored.",
        MONKEYTAIL = "Inedible. Practical use, unsure..",
        DUG_MONKEYTAIL = "Plant, waiting for dirt.",

        MONKEY_MEDIUMHAT = "Imposing, sea hat.",
        MONKEY_SMALLHAT = "Keeps dry.",
        POLLY_ROGERSHAT = "Some magic, strange.",
        POLLY_ROGERS = "Search, retreive.", -- spelling : retreive

        MONKEYISLAND_PORTAL = "Portal, one way.",
        MONKEYISLAND_PORTAL_DEBRIS = "Machinesry, distant transportation.",
        MONKEYQUEEN = "Ruler. Lazy, demanding.",
        MONKEYPILLAR = "Material does not belong to them.",
        PIRATE_FLAG_POLE = "Symbols.",

        BLACKFLAG = "Symbolic, death.",
        PIRATE_STASH = "Treasure, stored here.",
        STASH_MAP = "Guidance, treausre hidden?",

        BANANAJUICE = "Inedible.",

        FENCE_ROTATOR = "Inefficient weapon, preferable as tool.",

        CHARLIE_STAGE_POST = "What is this?",
        CHARLIE_LECTURN = "Performance, of some kind.",

        CHARLIE_HECKLER = "Prey, talkative.",

        PLAYBILL_THE_DOLL = "Inanimate.",
        STATUEHARP_HEDGESPAWNER = "Overgrown, plantlife.",
        HEDGEHOUND = "Animated, vegetation!",
        HEDGEHOUND_BUSH = "Something, lurking.",

        MASK_DOLLHAT = "A mask.",
        MASK_DOLLBROKENHAT = "A mask..",
        MASK_DOLLREPAIREDHAT = "A mask.",
        MASK_BLACKSMITHHAT = "A mask.",
        MASK_MIRRORHAT = "A mask.",
        MASK_QUEENHAT = "A mask.",
        MASK_KINGHAT = "A mask.",
        MASK_TREEHAT = "A mask.",
        MASK_FOOLHAT = "A mask.",

        COSTUME_DOLL_BODY = "Clothing.",
        COSTUME_QUEEN_BODY = "Clothing.",
        COSTUME_KING_BODY = "Clothing.",
        COSTUME_BLACKSMITH_BODY = "Clothing.",
        COSTUME_MIRROR_BODY = "Clothing.",
        COSTUME_TREE_BODY = "Clothing.",
        COSTUME_FOOL_BODY = "Clothing.",

        STAGEUSHER =
        {
            STANDING = "Hands, off.",
            SITTING = "Magic lurking.",
        },
        SEWING_MANNEQUIN =
        {
            GENERIC = "Icon, idol.",
            BURNT = "Icon, idol. Burnt.",
        },

		-- Waxwell
		MAGICIAN_CHEST = "Makers box, magic imbued.",
		TOPHAT_MAGICIAN = "Makers hat, magic imbued.",

        -- Year of the Rabbit
        YOTR_FIGHTRING_KIT = "Setup, required.",
        YOTR_FIGHTRING_BELL =
        {
            GENERIC = "No violence, toothless fight.", -- zzz
            PLAYING = "Weapons, fluffy. No harm done.",
        },

        YOTR_DECOR_1 = {
            GENERAL = "Luminescent, glow.",
            OUT = "Kindling, required.",
        },
        YOTR_DECOR_2 = {
            GENERAL = "Luminescent, glow.",
            OUT = "Kindling, required.",
        },

        HAREBALL = "Disgusting.",
        YOTR_DECOR_1_ITEM = "Setup, required.",
        YOTR_DECOR_2_ITEM = "Setup, required.",

		--
		DREADSTONE = "It has emerged.",
		HORRORFUEL = "Their fuel, further manifested.",
		DAYWALKER =
		{
			GENERIC = "With freedom, we hunt.",
			IMPRISONED = "Locked away, like me.",
		},
		DAYWALKER_PILLAR =
		{
			GENERIC = "Deep rock, bleeding through.",
			EXPOSED = "Fuel, merged with deep rock.",
		},
		DAYWALKER2 =
		{
			GENERIC = "Lost? Confused. Dangerous.",
			BURIED = "Trapped. Familiar, feeling.",
			HOSTILE = "Threatened, threatening.",
		},
		ARMORDREADSTONE = "Deep rock, made to protect.",
		DREADSTONEHAT = "Encased, armored.",

        -- Rifts 1
        LUNARRIFT_PORTAL = "Lunar precense, broken through", -- spelling : precense
        LUNARRIFT_CRYSTAL = "Lunar prescence, manifested.",

        LUNARTHRALL_PLANT = "Vegetation, sentient. Dangerous.",
        LUNARTHRALL_PLANT_VINE_END = "Stinging, thrashing.",

		LUNAR_GRAZER = "Induced sleep, natural weapon.",

        PUREBRILLIANCE = "Bright, glows unnaturally.", -- spelling: unnatural?
        LUNARPLANT_HUSK = "Lunar magic, lingers here.",

		LUNAR_FORGE = "Lunar magic, innovations.", -- spelling: innovation
		LUNAR_FORGE_KIT = "Setup, required.",

		LUNARPLANT_KIT = "zzz.", -- lunarplant... kit?
		ARMOR_LUNARPLANT = "Lunar armor, reaches inside.",
		LUNARPLANTHAT = "Encased, extra protection.",
		BOMB_LUNARPLANT = "Lunar blast, volatile.",
		STAFF_LUNARPLANT = "Lunar magic. Can unleash, in close combat.",
		SWORD_LUNARPLANT = "Lunar essence, manifested.",
		PICKAXE_LUNARPLANT = "Threat, turned tool.",
		SHOVEL_LUNARPLANT = "Multitool, practical.",

		BROKEN_FORGEDITEM = "Broken.",

        PUNCHINGBAG = "Idol, measures damage.",

        -- Rifts 2
        SHADOWRIFT_PORTAL = "Earth cracked, abyss calls.",

		SHADOW_FORGE = "Dark magic, creation.",
		SHADOW_FORGE_KIT = "Setup, required.",

        FUSED_SHADELING = "Danger, caustic bomb.",
        FUSED_SHADELING_BOMB = "A bomb!",

		VOIDCLOTH = "Tattered, pieces.",
		VOIDCLOTH_KIT = "Pieces, together makes a whole.",
		VOIDCLOTHHAT = "Concealed, cloaked.",
		ARMOR_VOIDCLOTH = "Cloaked, in shadow.",

        VOIDCLOTH_UMBRELLA = "A shield, against the sky.",
        VOIDCLOTH_SCYTHE = "Possesed, cannot trust the weapon.",

		SHADOWTHRALL_HANDS = "Twisted, chaotic form.",
		SHADOWTHRALL_HORNS = "Maw, dangerous.",
		SHADOWTHRALL_WINGS = "Strikes, from above.",

        CHARLIE_NPC = "Infused, like me. Linked to maker.",
        CHARLIE_HAND = "Grasping, wanting.",

        NITRE_FORMATION = "Sediment, collected.",
        DREADSTONE_STACK = "Fused rock, breaking through.",
        
        SCRAPBOOK_PAGE = "Knowledge, for the collection.",

        LEIF_IDOL = "Magic infused, call of the forest.",
        WOODCARVEDHAT = "Flammable, protective.",
        WALKING_STICK = "Locmotion, assisted.",

        IPECACSYRUP = "Food, not for me.",
        BOMB_LUNARPLANT_WORMWOOD = "Stronger, dangerous.", -- Unused
        WORMWOOD_MUTANTPROXY_CARRAT =
        {
        	DEAD = "Death finally.",
        	GENERIC = "Walking vegetation, inedible.",
        	HELD = "Strange.",
        	SLEEPING = "Sleeping, ambush possible.",
        },
        WORMWOOD_MUTANTPROXY_LIGHTFLIER = "No threat, only light.",
		WORMWOOD_MUTANTPROXY_FRUITDRAGON =
		{
			GENERIC = "Prey, thinks itself predator.",
			RIPE = "Prey, angry.",
			SLEEPING = "Feels safe. Comfortable.",
		},

        SUPPORT_PILLAR_SCAFFOLD = "Construction, hidden.",
        SUPPORT_PILLAR = "Support structure.",
        SUPPORT_PILLAR_COMPLETE = "Structure, secure.",
        SUPPORT_PILLAR_BROKEN = "Broken, no support.",

		SUPPORT_PILLAR_DREADSTONE_SCAFFOLD = "Construction, hidden.",
		SUPPORT_PILLAR_DREADSTONE = "Support structure.",
		SUPPORT_PILLAR_DREADSTONE_COMPLETE = "Structure, secure.",
		SUPPORT_PILLAR_DREADSTONE_BROKEN = "Broken, no support.",

        WOLFGANG_WHISTLE = "Do not order me.",

        -- Rifts 3

        MUTATEDDEERCLOPS = "Dead, husk. Possessed.", -- spelling : posessed check scythe
        MUTATEDWARG = "Fire spitting, threatening.",
        MUTATEDBEARGER = "Revived, exoskeleton added.",

        LUNARFROG = "All directions, sees.",

        DEERCLOPSCORPSE =
        {
            GENERIC  = "Was no Apex.",
            BURNING  = "Safety.",
            REVIVING = "Corpse, taken.",
        },

        WARGCORPSE =
        {
            GENERIC  = "Slain.",
            BURNING  = "Safety.",
            REVIVING = "Corpse, taken.",
        },

        BEARGERCORPSE =
        {
            GENERIC  = "Another one, slain.",
            BURNING  = "Safety.",
            REVIVING = "Corpse, taken.",
        },

        BEARGERFUR_SACK = "Container, cooling.",
        HOUNDSTOOTH_BLOWPIPE = "Teeth taken, teeth projected.",
        DEERCLOPSEYEBALL_SENTRYWARD =
        {
            GENERIC = "It watches.",    -- Enabled.
            NOEYEBALL = "Eye missing, watches nothing.",  -- Disabled.
        },
        DEERCLOPSEYEBALL_SENTRYWARD_KIT = "Setup, required.",

        SECURITY_PULSE_CAGE = "Containment, for what?",
        SECURITY_PULSE_CAGE_FULL = "Energy, contained.",

		CARPENTRY_STATION =
        {
            GENERIC = "Cutting, crafting.",
            BURNT = "Gone.",
        },

        WOOD_TABLE = -- Shared between the round and square tables.
        {
            GENERIC = "A table.",
            HAS_ITEM = "Stable.",
            BURNT = "Gone.",
        },

        WOOD_CHAIR =
        {
            GENERIC = "Resting? No time.",
            OCCUPIED = "Relax, while you can.",
            BURNT = "Gone.",
        },

        DECOR_CENTERPIECE = "Don't understand.",
        DECOR_LAMP = "Minimal light, use unclear.",
        DECOR_FLOWERVASE =
        {
            GENERIC = "'Decorative'. Not edible.",
            EMPTY = "Vase, small.",
            WILTED = "Death.",
            FRESHLIGHT = "Light flower, transplanted.",
            OLDLIGHT = "Light flower, dying.",
        },
        DECOR_PICTUREFRAME =
        {
            GENERIC = "'Art'.",
            UNDRAWN = "Etchings, paintings, waiting.",
        },
        DECOR_PORTRAITFRAME = "Ask someone else.",

        PHONOGRAPH = "Insanity tool.",
        RECORD = "Fractured anthem.",
        RECORD_CREEPYFOREST = "The forest speaks.",
        RECORD_DANGER = "Heart, beats.",
        RECORD_DAWN = "Awakening.",
        RECORD_DRSTYLE = "Whose style?",
        RECORD_DUSK = "Dusk, brings danger.",
        RECORD_EFS = "Heart beating, quicker.",
        RECORD_END = "The end.",
        RECORD_MAIN = "Familiar.",
        RECORD_WORKTOBEDONE = "Busy, busy.",

        ARCHIVE_ORCHESTRINA_MAIN = "Cryptic, inaccesible to ones of lesser intelligences.",

        WAGPUNKHAT = "Alternate vision.",
        ARMORWAGPUNK = "Manufactured, safety.",
        WAGSTAFF_MACHINERY = "Leftovers, creator left.",
        WAGPUNK_BITS = "Scraps, leftovers.",
        WAGPUNKBITS_KIT = "Creation, waiting.",

        WAGSTAFF_MUTATIONS_NOTE = "Research. Knowledge, in parts.",

        -- Meta 3

        BATTLESONG_INSTANT_REVIVE = "Songs, performance. Familiar, yet far away.",

        WATHGRITHR_IMPROVEDHAT = "Aerodynamic.",
        SPEAR_WATHGRITHR_LIGHTNING = "Electricity, harnessed.",

        BATTLESONG_CONTAINER = "Storage, paper.",

        SADDLE_WATHGRITHR = "Command the beasts.",

        WATHGRITHR_SHIELD = "Offense, best defense.",

        BATTLESONG_SHADOWALIGNED = "Songs, performance. Familiar, yet far away.",
        BATTLESONG_LUNARALIGNED = "Songs, performance. Familiar, yet far away.",

		SHARKBOI = "Lesser apex.",
        BOOTLEG = "No meat left.",
        OCEANWHIRLPORTAL = "Transportation, oceanbound.",

        EMBERLIGHT = "Glowing. Magical essence.",
        WILLOW_EMBER = "only_used_by_willow",

        -- Year of the Dragon
        YOTD_DRAGONSHRINE =
        {
            GENERIC = "Alter, praise.",
            EMPTY = "Ash, required.",
            BURNT = "Useless.",
        },

        DRAGONBOAT_KIT = "Boat, prepared.",
        DRAGONBOAT_PACK = "Efficient.",

        BOATRACE_CHECKPOINT = "Path, guiding.",
        BOATRACE_CHECKPOINT_THROWABLE_DEPLOYKIT = "Device, throwable.",
        BOATRACE_START = "Beginning.",
        BOATRACE_START_THROWABLE_DEPLOYKIT = "Device, throwable.",

        BOATRACE_PRIMEMATE = "Competitor, flawed.",
        BOATRACE_SPECTATOR_DRAGONLING = "Spectacle. Watching, waiting.",

        YOTD_STEERINGWHEEL = "Guidance, provided.",
        YOTD_STEERINGWHEEL_ITEM = "Setup, required.",
        YOTD_OAR = "A dragon boat needs a dragon paddle.",
        YOTD_ANCHOR = "Weight.",
        YOTD_ANCHOR_ITEM = "Setup, required.",
        MAST_YOTD = "Scales, protective.",
        MAST_YOTD_ITEM = "Setup, required.",
        BOAT_BUMPER_YOTD = "Scales, protective.",
        BOAT_BUMPER_YOTD_KIT = "Setup, required.",
        BOATRACE_SEASTACK = "Threat, beware.",
        BOATRACE_SEASTACK_THROWABLE_DEPLOYKIT = "Device, throwable.",
        BOATRACE_SEASTACK_MONKEY = "Threat, beware.",
        BOATRACE_SEASTACK_MONKEY_THROWABLE_DEPLOYKIT = "Device, throwable.",
        MASTUPGRADE_LAMP_YOTD = "Light, protective.",
        MASTUPGRADE_LAMP_ITEM_YOTD = "Setup, required.",
        WALKINGPLANK_YOTD = "Abandon ship, if situation dangerous.",
        CHESSPIECE_YOTD = "Another relic.",

        -- Rifts / Meta QoL

        HEALINGSALVE_ACID = "Coating, for shell. Made resistant to acid.",

        BEESWAX_SPRAY = "Protective layer, in sprayable form.",
        WAXED_PLANT = "Thin layer, protected from elements.", -- Used for all waxed plants, from farm plants to trees.

        STORAGE_ROBOT = {
            GENERIC = "Seeks, collects, automation creates apathy.",
            BROKEN = "A broken machine. Worthless now.",
        },

        SCRAP_MONOCLEHAT = "Sense heightened, curious.",
        SCRAP_CONEHAT = "Inefficient design.",

        FENCE_JUNK = "Unstable, easy to break.",
        JUNK_PILE = "Treasures hidden, perhaps.",
        JUNK_PILE_BIG = "Heartbeat, underneath. Beware.",
    },

    DESCRIBE_GENERIC = "Thing, it is...",
    DESCRIBE_TOODARK = "Cannot... see?",
    DESCRIBE_SMOLDERING = "Flame, building.",

    DESCRIBE_PLANTHAPPY = "Conditions optimal. Thriving.",
    DESCRIBE_PLANTVERYSTRESSED = "Conditions dangerous, dying.",
    DESCRIBE_PLANTSTRESSED = "Stress, mounting..",
    DESCRIBE_PLANTSTRESSORKILLJOYS = "Weeds, invasive.",
    DESCRIBE_PLANTSTRESSORFAMILY = "Lonely.",
    DESCRIBE_PLANTSTRESSOROVERCROWDING = "Surrounded, too many.",
    DESCRIBE_PLANTSTRESSORSEASON = "Season, incorrect.",
    DESCRIBE_PLANTSTRESSORMOISTURE = "Thirst, dying.",
    DESCRIBE_PLANTSTRESSORNUTRIENTS = "Nutrients, needed.",
    DESCRIBE_PLANTSTRESSORHAPPINESS = "Idle noise, required.",

    EAT_FOOD =
    {
        TALLBIRDEGG_CRACKED = "Gone.",
		WINTERSFEASTFUEL = "Magic, holidays.",
    },
}

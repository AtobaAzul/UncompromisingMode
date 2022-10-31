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
--fallback to speech_wilson.lua             NOTATRIUMKEY = "It's not quite the right shape.",
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
	ANNOUNCE_DEERCLOPS = "Deerclops. Let's dance.",
	ANNOUNCE_CAVEIN = "Earthquake. Mindful, head.",
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"Earthquake.",
		"Rare, surface earthquakes. Curious, source.",
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "Halt, earthquakes.",
        "Spiteful, servitude.",
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

    ANNOUNCE_ENCUMBERED =
    {
        "Huff... puff...",
        "Arrrrfff...",
        "I... Can!",
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
	ANNOUNCE_HUNGRY = "Energy lacking.",
	ANNOUNCE_HUNT_BEAST_NEARBY = "Found you.",
	ANNOUNCE_HUNT_LOST_TRAIL = "Lost it. I lost it...",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "Through the mud, escaped.",
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
    ANNOUNCE_SOUL_EMPTY =
    {
        "Woe be to a soul-starved imp!",
        "I don't want to suck anymore souls!",
        "What gruesome things I must do to live!",
    },
    ANNOUNCE_SOUL_FEW =
    {
        "I'll need more souls soon.",
        "I feel the soul hunger stirring.",
    },
    ANNOUNCE_SOUL_MANY =
    {
        "I've enough souls to sustain me.",
        "I hope I was not too greedy.",
    },
    ANNOUNCE_SOUL_OVERLOAD =
    {
        "I can't handle that much soul power!",
        "That was one soul too many!",
    },

    --walter specfic
--fallback to speech_wilson.lua 	ANNOUNCE_SLINGHSOT_OUT_OF_AMMO =
--fallback to speech_wilson.lua 	{
--fallback to speech_wilson.lua 		"only_used_by_walter",
--fallback to speech_wilson.lua 		"only_used_by_walter",
--fallback to speech_wilson.lua 	},
--fallback to speech_wilson.lua 	ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT =
--fallback to speech_wilson.lua 	{
--fallback to speech_wilson.lua         "only_used_by_walter",
--fallback to speech_wilson.lua 	},
--fallback to speech_wilson.lua 	ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT =
--fallback to speech_wilson.lua 	{
--fallback to speech_wilson.lua         "only_used_by_walter",
--fallback to speech_wilson.lua 	},

    -- wx specific
    ANNOUNCE_WX_SCANNER_NEW_FOUND = "only_used_by_wx78",
--fallback to speech_wilson.lua     ANNOUNCE_WX_SCANNER_FOUND_NO_DATA = "only_used_by_wx78",

    --quagmire event
    QUAGMIRE_ANNOUNCE_NOTRECIPE = "Fancy feast, unfamiliar.",
    QUAGMIRE_ANNOUNCE_MEALBURNT = "Mistake.",
    QUAGMIRE_ANNOUNCE_LOSE = "Failure. Consequence incoming.",
    QUAGMIRE_ANNOUNCE_WIN = "Next step awaits.",

--fallback to speech_wilson.lua     ANNOUNCE_ROYALTY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "Your majesty.",
--fallback to speech_wilson.lua         "Your highness.",
--fallback to speech_wilson.lua         "My liege!",
--fallback to speech_wilson.lua     },

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
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr",

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
	},

	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "This game? Exceptional, my skill.",
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN = "I am in!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND =
	{
		"Found you.",
		"Conceal appendages. Fun, impacted.",
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
		THULECITE = "Ancient alloy, peak nightmare conductivity. \nStory telling, context lacking. ",
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
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "Underground fungus. Sizes normal.",
            BLOOM = "Underground fungus. Evidently, blooming season.",
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "Underground fungus. Sizes normal.",
            BLOOM = "Underground fungus. Evidently, blooming season.",
        },
        MUSHTREE_TALL_WEBBED = "Sit still, examine. Small string, ceiling hanging.",
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

        TURF_MONKEY_GROUND = "Floor.",

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
        CHESSPIECE_GUARDIANPHASE3 = "Elder man, knowledge stolen!",
        CHESSPIECE_EYEOFTERROR = "Reality perversion, gone.",
        CHESSPIECE_TWINSOFTERROR = "Piles, scrap.",

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
        MAXWELLHEAD = "Boy if you don get outta here with yo yeeyee ass haircut.",--removed
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
    MOOSE =
    {
        "Migrating Moose. Origin unknown.",
        "Migrating Goose. Origin unknown.",
    },
    MOOSE_NESTING_GROUND =
    {
        "Moose nest.",
        "Goose nest.",
    },
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
            GENERIC = "Underground sytem, rabbit burrows. Caution, ankle injuries.",
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
		SPOILED_FOOD = "foodstuff, decomposed.",
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
		TENTACLE = "Limb, Marsh Quacken, adolescent.",
		TENTACLESPIKE = "Tentacle extremity, Marsh Quacken.",
		TENTACLESPOTS = "Reproduction, quacken gland.",
		TENTACLE_PILLAR = "Limb, Marsh Quacken, adult.",
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
		},
		TREASURECHEST_TRAP = "This trap, seen before.",
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
		WAXWELLJOURNAL = "Everything's reason. My birth, included.",
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
        LAVAARENA_BOARLORD = "I have no real quest, I'm just here to jest!",
        BOARRIOR = "Catch me if you can!",
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
        	GENERIC = "She's made a sort of automatic defense system.",
        	OFF = "It needs some electricity.",
        	BURNING = "It's on fire!",
        	BURNT = "Science couldn't save it.",
        },
        WINONA_SPOTLIGHT =
        {
        	GENERIC = "What an ingenious idea!",
        	OFF = "It needs some electricity.",
        	BURNING = "It's on fire!",
        	BURNT = "Science couldn't save it.",
        },
        WINONA_BATTERY_LOW =
        {
        	GENERIC = "Looks science-y. How does it work?",
        	LOWPOWER = "It's getting low on power.",
        	OFF = "I could get it working, if Winona's busy.",
        	BURNING = "It's on fire!",
        	BURNT = "Science couldn't save it.",
        },
        WINONA_BATTERY_HIGH =
        {
        	GENERIC = "Hey! That's not science!",
        	LOWPOWER = "It'll turn off soon.",
        	OFF = "Science beats magic, every time.",
        	BURNING = "It's on fire!",
        	BURNT = "Science couldn't save it.",
        },

        --Wormwood
        COMPOSTWRAP = "Wormwood offered me a bite, but I respectfully declined.",
        ARMOR_BRAMBLE = "The best offense is a good defense.",
        TRAP_BRAMBLE = "It'd really poke whoever stepped on it.",

        BOATFRAGMENT03 = "Not much left of it.",
        BOATFRAGMENT04 = "Not much left of it.",
        BOATFRAGMENT05 = "Not much left of it.",
		BOAT_LEAK = "I should patch that up before we sink.",
        MAST = "Avast! A mast!",
        SEASTACK = "It's a rock.",
        FISHINGNET = "Nothing but net.", --unimplemented
        ANTCHOVIES = "Yeesh. Can I toss it back?", --unimplemented
        STEERINGWHEEL = "I could have been a sailor in another life.",
        ANCHOR = "I wouldn't want my boat to float away.",
        BOATPATCH = "Just in case of disaster.",
        DRIFTWOOD_TREE =
        {
            BURNING = "That driftwood's burning!",
            BURNT = "Doesn't look very useful anymore.",
            CHOPPED = "There might still be something worth digging up.",
            GENERIC = "A dead tree that washed up on shore.",
        },

        DRIFTWOOD_LOG = "It floats on water.",

        MOON_TREE =
        {
            BURNING = "The tree is burning!",
            BURNT = "The tree burned down.",
            CHOPPED = "That was a pretty thick tree.",
            GENERIC = "I didn't know trees grew on the moon.",
        },
		MOON_TREE_BLOSSOM = "It fell from the moon tree.",

        MOONBUTTERFLY =
        {
        	GENERIC = "My vast scientific knowledge tells me it's... a moon butterfly.",
        	HELD = "I've got you now.",
        },
		MOONBUTTERFLYWINGS = "We're really winging it now.",
        MOONBUTTERFLY_SAPLING = "A moth turned into a tree? Lunacy!",
        ROCK_AVOCADO_FRUIT = "I'd shatter my teeth on that.",
        ROCK_AVOCADO_FRUIT_RIPE = "Uncooked stone fruit is the pits.",
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "It's actually soft enough to eat now.",
        ROCK_AVOCADO_FRUIT_SPROUT = "It's growing.",
        ROCK_AVOCADO_BUSH =
        {
        	BARREN = "Its fruit growing days are over.",
			WITHERED = "It's pretty hot out.",
			GENERIC = "It's a bush... from the moon!",
			PICKED = "It'll take awhile to grow more fruit.",
			DISEASED = "It looks pretty sick.", --unimplemented
            DISEASING = "Err, something's not right.", --unimplemented
			BURNING = "It's burning!",
		},
        DEAD_SEA_BONES = "That's what they get for coming up on land.",
        HOTSPRING =
        {
        	GENERIC = "If only I could soak my weary bones.",
        	BOMBED = "Just a simple chemical reaction.",
        	GLASS = "Water turns to glass under the moon. That's just science.",
			EMPTY = "I'll just have to wait for it to fill up again.",
        },
        MOONGLASS = "It's very sharp.",
        MOONGLASS_CHARGED = "I should put this to scientific use before the energy fades!",
        MOONGLASS_ROCK = "I can practically see my reflection in it.",
        BATHBOMB = "It's just textbook chemistry.",
        TRAP_STARFISH =
        {
            GENERIC = "Aw, what a cute little starfish!",
            CLOSED = "It tried to chomp me!",
        },
        DUG_TRAP_STARFISH = "It's not fooling anyone now.",
        SPIDER_MOON =
        {
        	GENERIC = "Oh good. The moon mutated it.",
        	SLEEPING = "Thank science, it stopped moving.",
        	DEAD = "Is it really dead?",
        },
        MOONSPIDERDEN = "That's not a normal spider den.",
		FRUITDRAGON =
		{
			GENERIC = "It's cute, but it's not ripe yet.",
			RIPE = "I think it's ripe now.",
			SLEEPING = "It's snoozing.",
		},
        PUFFIN =
        {
            GENERIC = "I've never seen a live puffin before!",
            HELD = "Catching one ain't puffin to brag about.",
            SLEEPING = "Peacefully huffin' and puffin'.",
        },

		MOONGLASSAXE = "I've made it extra effective.",
		GLASSCUTTER = "I'm not really cut out for fighting.",

        ICEBERG =
        {
            GENERIC = "Let's steer clear of that.", --unimplemented
            MELTED = "It's completely melted.", --unimplemented
        },
        ICEBERG_MELTED = "It's completely melted.", --unimplemented

        MINIFLARE = "I can light it to let everyone know I'm here.",
        MEGAFLARE = "It will let everything know I'm here. Everything.",

		MOON_FISSURE =
		{
			GENERIC = "My brain pulses with peace and terror.",
			NOLIGHT = "The cracks in this place are starting to show.",
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "It wants to be finished.",
            GENERIC = "Hm? What did you say?",
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
            GENERIC = "I think tanks are in order.",
            BURNT = "The science has been lost to sea.",
        },
        BOAT_ITEM = "It would be nice to do some experiments on the water.",
        BOAT_GRASS_ITEM = "It's technically a boat.",
        STEERINGWHEEL_ITEM = "That's going to be the steering wheel.",
        ANCHOR_ITEM = "Now I can build an anchor.",
        MAST_ITEM = "Now I can build a mast.",
        MUTATEDHOUND =
        {
        	DEAD = "Now I can breathe easy.",
        	GENERIC = "Science save us!",
        	SLEEPING = "I have a very strong desire to run.",
        },

        MUTATED_PENGUIN =
        {
			DEAD = "That's the end of that.",
			GENERIC = "That thing's terrifying!",
			SLEEPING = "Thank goodness. It's sleeping.",
		},
        CARRAT =
        {
        	DEAD = "That's the end of that.",
        	GENERIC = "Are carrots supposed to have legs?",
        	HELD = "You're kind of ugly up close.",
        	SLEEPING = "It's almost cute.",
        },

		BULLKELP_PLANT =
        {
            GENERIC = "Welp. It's kelp.",
            PICKED = "I just couldn't kelp myself.",
        },
		BULLKELP_ROOT = "I can plant it in deep water.",
        KELPHAT = "Sometimes you have to feel worse to feel better.",
		KELP = "It gets my pockets all wet and gross.",
		KELP_COOKED = "It's closer to a liquid than a solid.",
		KELP_DRIED = "The sodium content's kinda high.",

		GESTALT = "They're promising me... knowledge.",
        GESTALT_GUARD = "They're promising me... a good smack if I get too close.",

		COOKIECUTTER = "I don't like the way it's looking at my boat...",
		COOKIECUTTERSHELL = "A shell of its former self.",
		COOKIECUTTERHAT = "At least my hair will stay dry.",
		SALTSTACK =
		{
			GENERIC = "Are those natural formations?",
			MINED_OUT = "It's mined... it's all mined!",
			GROWING = "I guess it just grows like that.",
		},
		SALTROCK = "Science compels me to lick it.",
		SALTBOX = "Just the cure for spoiling food!",

		TACKLESTATION = "Time to tackle my reel problems.",
		TACKLESKETCH = "A picture of some fishing tackle. I bet I could make this...",

        MALBATROSS = "A fowl beast indeed!",
        MALBATROSS_FEATHER = "Plucked from a fine feathered fiend.",
        MALBATROSS_BEAK = "Smells fishy.",
        MAST_MALBATROSS_ITEM = "It's lighter than it looks.",
        MAST_MALBATROSS = "Spread my wings and sail away!",
		MALBATROSS_FEATHERED_WEAVE = "I'm making a quill-t!",

        GNARWAIL =
        {
            GENERIC = "My, what a big horn you have.",
            BROKENHORN = "Got your nose!",
            FOLLOWER = "This is all whale and good.",
            BROKENHORN_FOLLOWER = "That's what happens when you nose around!",
        },
        GNARWAIL_HORN = "Gnarly!",

        WALKINGPLANK = "Couldn't we have just made a lifeboat?",
        WALKINGPLANK_GRASS = "Couldn't we have just made a lifeboat?",
        OAR = "Manual ship acceleration.",
		OAR_DRIFTWOOD = "Manual ship acceleration.",

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

		PONDFISH = "Now I shall eat for a day.",
		PONDEEL = "This will make a delicious meal.",

        FISHMEAT = "A chunk of fish meat.",
        FISHMEAT_COOKED = "Grilled to perfection.",
        FISHMEAT_SMALL = "A small bit of fish.",
        FISHMEAT_SMALL_COOKED = "A small bit of cooked fish.",
		SPOILED_FISH = "I'm not terribly curious about the smell.",

		FISH_BOX = "They're stuffed in there like sardines!",
        POCKET_SCALE = "A scaled-down weighing device.",

		TACKLECONTAINER = "This extra storage space has me hooked!",
		SUPERTACKLECONTAINER = "I had to shell out quite a bit to get this.",

		TROPHYSCALE_FISH =
		{
			GENERIC = "I wonder how my catch of the day will measure up!",
			HAS_ITEM = "Weight: {weight}\nCaught by: {owner}",
			HAS_ITEM_HEAVY = "Weight: {weight}\nCaught by: {owner}\nWhat a catch!",
			BURNING = "On a scale of 1 to on fire... that's pretty on fire.",
			BURNT = "All my bragging rights, gone up in flames!",
			OWNER = "Not to throw my weight around, buuut...\nWeight: {weight}\nCaught by: {owner}",
			OWNER_HEAVY = "Weight: {weight}\nCaught by: {owner}\nIt's the one that DIDN'T get away!",
		},

		OCEANFISHABLEFLOTSAM = "Just some muddy grass.",

		CALIFORNIAROLL = "But I don't have chopsticks.",
		SEAFOODGUMBO = "It's a jumbo seafood gumbo.",
		SURFNTURF = "It's perf!",

        WOBSTER_SHELLER = "What a wascally Wobster.",
        WOBSTER_DEN = "It's a rock with Wobsters in it.",
        WOBSTER_SHELLER_DEAD = "You should cook up nicely.",
        WOBSTER_SHELLER_DEAD_COOKED = "I can't wait to eat you.",

        LOBSTERBISQUE = "Could use more salt, but that's none of my bisque-ness.",
        LOBSTERDINNER = "If I eat it in the morning is it still dinner?",

        WOBSTER_MOONGLASS = "What a wascally Lunar Wobster.",
        MOONGLASS_WOBSTER_DEN = "It's a chunk of moonglass with Lunar Wobsters in it.",

		TRIDENT = "This is going to be a blast!",

		WINCH =
		{
			GENERIC = "It'll do in a pinch.",
			RETRIEVING_ITEM = "I'll let it do the heavy lifting.",
			HOLDING_ITEM = "What do we have here?",
		},

        HERMITHOUSE = {
            GENERIC = "It's just an empty shell of a house.",
            BUILTUP = "It just needed a little love.",
        },

        SHELL_CLUSTER = "I bet there's some nice shells in there.",
        --
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "It's a bit more toned down.",
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "Is that what the ocean sounds like?",
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "It's ready for the high C's.",
        },

        CHUM = "It's a fish meal!",

        SUNKENCHEST =
        {
            GENERIC = "The real treasure is the treasure we found along the way.",
            LOCKED = "It's clammed right up!",
        },

        HERMIT_BUNDLE = "She shore shells out a lot of these.",
        HERMIT_BUNDLE_SHELLS = "She DOES sell sea shells!",

        RESKIN_TOOL = "I like the dust! It feels scholarly!",
        MOON_FISSURE_PLUGGED = "It's not very scientific... but pretty effective.",


		----------------------- ROT STRINGS GO ABOVE HERE ------------------

		-- Walter
        WOBYBIG =
        {
            "What in the name of science have you been feeding her?",
            "What in the name of science have you been feeding her?",
        },
        WOBYSMALL =
        {
            "It's a scientific fact that petting a good dog will improve your day.",
            "It's a scientific fact that petting a good dog will improve your day.",
        },
		WALTERHAT = "I was never exactly \"outdoorsy\" in my youth.",
		SLINGSHOT = "The bane of windows everywhere.",
		SLINGSHOTAMMO_ROCK = "Shots to be slinged.",
		SLINGSHOTAMMO_MARBLE = "Shots to be slinged.",
		SLINGSHOTAMMO_THULECITE = "Shots to be slinged.",
        SLINGSHOTAMMO_GOLD = "Shots to be slinged.",
        SLINGSHOTAMMO_SLOW = "Shots to be slinged.",
        SLINGSHOTAMMO_FREEZE = "Shots to be slinged.",
		SLINGSHOTAMMO_POOP = "Poop projectiles.",
        PORTABLETENT = "I feel like I haven't had a proper night's sleep in ages!",
        PORTABLETENT_ITEM = "This requires some a-tent-tion.",

        -- Wigfrid
        BATTLESONG_DURABILITY = "Theater makes me fidgety.",
        BATTLESONG_HEALTHGAIN = "Theater makes me fidgety.",
        BATTLESONG_SANITYGAIN = "Theater makes me fidgety.",
        BATTLESONG_SANITYAURA = "Theater makes me fidgety.",
        BATTLESONG_FIRERESISTANCE = "I once burned my vest before seeing a play. I call that dramatic ironing.",
        BATTLESONG_INSTANT_TAUNT = "I'm afraid I'm not a licensed poetic.",
        BATTLESONG_INSTANT_PANIC = "I'm afraid I'm not a licensed poetic.",

        -- Webber
        MUTATOR_WARRIOR = "Oh wow, that looks um... delicious, Webber!",
        MUTATOR_DROPPER = "Ah, I... just ate! Why don't you give it to one of your spider friends?",
        MUTATOR_HIDER = "Oh wow, that looks um... delicious, Webber!",
        MUTATOR_SPITTER = "Ah, I... just ate! Why don't you give it to one of your spider friends?",
        MUTATOR_MOON = "Oh wow, that looks um... delicious, Webber!",
        MUTATOR_HEALER = "Ah, I... just ate! Why don't you give it to one of your spider friends?",
        SPIDER_WHISTLE = "I don't want to call any spiders over to me!",
        SPIDERDEN_BEDAZZLER = "It looks like someone's been getting crafty.",
        SPIDER_HEALER = "Oh wonderful. Now the spiders can heal themselves.",
        SPIDER_REPELLENT = "If only science could make it work for me.",
        SPIDER_HEALER_ITEM = "If I see any spiders around I'll be sure to give it to them. Maybe.",

		-- Wendy
		GHOSTLYELIXIR_SLOWREGEN = "Ah yes. Very science-y.",
		GHOSTLYELIXIR_FASTREGEN = "Ah yes. Very science-y.",
		GHOSTLYELIXIR_SHIELD = "Ah yes. Very science-y.",
		GHOSTLYELIXIR_ATTACK = "Ah yes. Very science-y.",
		GHOSTLYELIXIR_SPEED = "Ah yes. Very science-y.",
		GHOSTLYELIXIR_RETALIATION = "Ah yes. Very science-y.",
		SISTURN =
		{
			GENERIC = "Some flowers would liven it up a bit.",
			SOME_FLOWERS = "A few more flowers should do the trick.",
			LOTS_OF_FLOWERS = "What a brilliant boo-quet!",
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

        PORTABLEBLENDER_ITEM = "It mixes all the food.",
        PORTABLESPICER_ITEM =
        {
            GENERIC = "This will spice things up.",
            DONE = "Should make things a little tastier.",
        },
        SPICEPACK = "A breakthrough in culinary science!",
        SPICE_GARLIC = "A powerfully potent powder.",
        SPICE_SUGAR = "Sweet! It's sweet!",
        SPICE_CHILI = "A flagon of fiery fluid.",
        SPICE_SALT = "A little sodium's good for the heart.",
        MONSTERTARTARE = "There's got to be something else to eat around here.",
        FRESHFRUITCREPES = "Sugary fruit! Part of a balanced breakfast.",
        FROGFISHBOWL = "Is that just... frogs stuffed inside a fish?",
        POTATOTORNADO = "Potato, scientifically infused with the power of a tornado!",
        DRAGONCHILISALAD = "I hope I can handle the spice level.",
        GLOWBERRYMOUSSE = "Warly sure can cook.",
        VOLTGOATJELLY = "It's shockingly delicious.",
        NIGHTMAREPIE = "It's a little spooky.",
        BONESOUP = "No bones about it, Warly can cook.",
        MASHEDPOTATOES = "I've heard cooking is basically chemistry. I should try it.",
        POTATOSOUFFLE = "I forgot what good food tasted like.",
        MOQUECA = "He's as talented a chef as I am a scientist.",
        GAZPACHO = "How in science does it taste so good?",
        ASPARAGUSSOUP = "Smells like it tastes.",
        VEGSTINGER = "Can you use the celery as a straw?",
        BANANAPOP = "No, not brain freeze! I need that for science!",
        CEVICHE = "Can I get a bigger bowl? This one looks a little shrimpy.",
        SALSA = "So... hot...!",
        PEPPERPOPPER = "What a mouthful!",

        TURNIP = "It's a raw turnip.",
        TURNIP_COOKED = "Cooking is science in practice.",
        TURNIP_SEEDS = "A handful of odd seeds.",

        GARLIC = "The number one breath enhancer.",
        GARLIC_COOKED = "Perfectly browned.",
        GARLIC_SEEDS = "A handful of odd seeds.",

        ONION = "Looks crunchy.",
        ONION_COOKED = "A successful chemical reaction.",
        ONION_SEEDS = "A handful of odd seeds.",

        POTATO = "The apples of the earth.",
        POTATO_COOKED = "A successful temperature experiment.",
        POTATO_SEEDS = "A handful of odd seeds.",

        TOMATO = "It's red because it's full of science.",
        TOMATO_COOKED = "Cooking's easy if you understand chemistry.",
        TOMATO_SEEDS = "A handful of odd seeds.",

        ASPARAGUS = "A vegetable.",
        ASPARAGUS_COOKED = "Science says it's good for me.",
        ASPARAGUS_SEEDS = "It's some seeds.",

        PEPPER = "Nice and spicy.",
        PEPPER_COOKED = "It was already hot to begin with.",
        PEPPER_SEEDS = "A handful of seeds.",

        WEREITEM_BEAVER = "I guess science works differently up North.",
        WEREITEM_GOOSE = "That thing's giving ME goosebumps!",
        WEREITEM_MOOSE = "A perfectly normal cursed moose thing.",

        MERMHAT = "Finally, I can show my face in public.",
        MERMTHRONE =
        {
            GENERIC = "Looks fit for a swamp king!",
            BURNT = "There was something fishy about that throne anyway.",
        },
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "Just what is she planning?",
            BURNT = "I suppose we'll never know what it was for now.",
        },
        MERMHOUSE_CRAFTED =
        {
            GENERIC = "It's actually kind of cute.",
            BURNT = "Ugh, the smell!",
        },

        MERMWATCHTOWER_REGULAR = "They seem happy to have found a king.",
        MERMWATCHTOWER_NOKING = "A royal guard with no Royal to guard.",
        MERMKING = "Your Majesty!",
        MERMGUARD = "I feel very guarded around these guys...",
        MERM_PRINCE = "They operate on a first-come, first-sovereigned basis.",

        SQUID = "I have an inkling they'll come in handy.",

		GHOSTFLOWER = "My scientific brain refuses to perceive it.",
        SMALLGHOST = "Aww, does someone have a little boo-boo?",

        CRABKING =
        {
            GENERIC = "Yikes! A little too crabby for me.",
            INERT = "That castle needs a little decoration.",
        },
		CRABKING_CLAW = "That's claws for alarm!",

		MESSAGEBOTTLE = "I wonder if it's for me!",
		MESSAGEBOTTLEEMPTY = "It's full of nothing.",

        MEATRACK_HERMIT =
        {
            DONE = "Jerky time!",
            DRYING = "Meat takes a while to dry.",
            DRYINGINRAIN = "Meat takes even longer to dry in rain.",
            GENERIC = "Those look like they could use some meat.",
            BURNT = "The rack got dried.",
            DONE_NOTMEAT = "In laboratory terms, we would call that \"dry\".",
            DRYING_NOTMEAT = "Drying things is not an exact science.",
            DRYINGINRAIN_NOTMEAT = "Rain, rain, go away. Be wet again another day.",
        },
        BEEBOX_HERMIT =
        {
            READY = "It's full of honey.",
            FULLHONEY = "It's full of honey.",
            GENERIC = "I'm sure there's a little sweetness to be found inside.",
            NOHONEY = "It's empty.",
            SOMEHONEY = "Need to wait a bit.",
            BURNT = "How did it get burned?!!",
        },

        HERMITCRAB = "Living by yourshellf must get abalonely.",

        HERMIT_PEARL = "I'll take good care of it.",
        HERMIT_CRACKED_PEARL = "I... didn't take good care of it.",

        -- DSEAS
        WATERPLANT = "As long as we don't take their barnacles, they'll stay our buds.",
        WATERPLANT_BOMB = "We're under seedge!",
        WATERPLANT_BABY = "This one's just a sprout.",
        WATERPLANT_PLANTER = "They seem to grow best on oceanic rocks.",

        SHARK = "We may need a bigger boat...",

        MASTUPGRADE_LAMP_ITEM = "I'm full of bright ideas.",
        MASTUPGRADE_LIGHTNINGROD_ITEM = "I've harnessed the power of electricity over land and sea!",

        WATERPUMP = "It puts out fires very a-fish-iently.",

        BARNACLE = "They don't look like knuckles to me.",
        BARNACLE_COOKED = "I'm told it's quite a delicacy.",

        BARNACLEPITA = "Barnacles taste better when you can't see them.",
        BARNACLESUSHI = "I still seem to have misplaced my chopsticks.",
        BARNACLINGUINE = "Pass the pasta!",
        BARNACLESTUFFEDFISHHEAD = "I'm just hungry enough to consider it...",

        LEAFLOAF = "Mystery leaf meat.",
        LEAFYMEATBURGER = "Vegetarian, but not cruelty-free.",
        LEAFYMEATSOUFFLE = "Has science gone too far?",
        MEATYSALAD = "Strangely filling, for a salad.",

        -- GROTTO

		MOLEBAT = "A regular Noseferatu.",
        MOLEBATHILL = "I wonder what might be stuck in that rat's nest.",

        BATNOSE = "Who knows whose nose this is?",
        BATNOSE_COOKED = "It came out smelling like a nose.",
        BATNOSEHAT = "For hands-free dairy drinking.",

        MUSHGNOME = "It might be aggressive, but only sporeradically.",

        SPORE_MOON = "I'll keep as mushroom between me and those spores as I can.",

        MOON_CAP = "It doesn't look particularly appetizing.",
        MOON_CAP_COOKED = "The things I do in the name of science...",

        MUSHTREE_MOON = "This mushroom tree is clearly stranger than the rest.",

        LIGHTFLIER = "How strange, carrying one makes my pocket feel lighter!",

        GROTTO_POOL_BIG = "The moon water makes the glass grow. That's just science.",
        GROTTO_POOL_SMALL = "The moon water makes the glass grow. That's just science.",

        DUSTMOTH = "Tidy little guys, aren't they?",

        DUSTMOTHDEN = "They're snug as bugs in there.",

        ARCHIVE_LOCKBOX = "Now how do I get the knowledge out?",
        ARCHIVE_CENTIPEDE = "You won't centimpede my progress!",
        ARCHIVE_CENTIPEDE_HUSK = "A pile of old spare parts.",

        ARCHIVE_COOKPOT =
        {
            COOKING_LONG = "This is going to take a while.",
            COOKING_SHORT = "It's almost done!",
            DONE = "Mmmmm! It's ready to eat!",
            EMPTY = "Let's dust off this old crockery, shall we?",
            BURNT = "The pot got cooked.",
        },

        ARCHIVE_MOON_STATUE = "These magnificent moon statues have me waxing poetic.",
        ARCHIVE_RUNE_STATUE =
        {
            LINE_1 = "So much knowledge, if only I could read it!",
            LINE_2 = "These markings look different from the ones in the rest of the ruins.",
            LINE_3 = "So much knowledge, if only I could read it!",
            LINE_4 = "These markings look different from the ones in the rest of the ruins.",
            LINE_5 = "So much knowledge, if only I could read it!",
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

        ARCHIVE_SECURITY_PULSE = "Where are you going? Someplace interesting?",

        ARCHIVE_SWITCH = {
            VALID = "Those gems seem to power it... through entirely scientific means, I'm sure.",
            GEMS = "The socket is empty.",
        },

        ARCHIVE_PORTAL = {
            POWEROFF = "Dead as a dead doornail.",
            GENERIC = "Strange, the power is on but this isn't.",
        },

        WALL_STONE_2 = "That's a nice wall.",
        WALL_RUINS_2 = "An ancient piece of wall.",

        REFINED_DUST = "Ah-CHOO!",
        DUSTMERINGUE = "Who or what would eat this?",

        SHROOMCAKE = "It lives up to its name.",

        NIGHTMAREGROWTH = "Those crystals might be cause for some concern.",

        TURFCRAFTINGSTATION = "A true scientist is always breaking new ground!",

        MOON_ALTAR_LINK = "It must be building up to something.",

        -- FARMING
        COMPOSTINGBIN =
        {
            GENERIC = "I can barrel-y stand the smell.",
            WET = "That looks too soggy.",
            DRY = "Hm... too dry.",
            BALANCED = "Just right!",
            BURNT = "I didn't think it could smell any worse...",
        },
        COMPOST = "Food for plants, and not much else.",
        SOIL_AMENDER =
		{
			GENERIC = "Now we wait for science to do its work.",
			STALE = "It's creating what we scientists call a chemical reaction!",
			SPOILED = "That stomach-churning smell means it's working!",
		},

		SOIL_AMENDER_FERMENTED = "That's some strong science!",

        WATERINGCAN =
        {
            GENERIC = "I can water the plants with this.",
            EMPTY = "Maybe there's a pond around here somewhere...",
        },
        PREMIUMWATERINGCAN =
        {
            GENERIC = "It's been improved with science... and bird parts!",
            EMPTY = "It won't do me much good without water.",
        },

		FARM_PLOW = "A convenient plot device.",
		FARM_PLOW_ITEM = "I'd better find a good spot for my garden before I use it.",
		FARM_HOE = "I have to make the ground more comfortable for the seeds.",
		GOLDEN_FARM_HOE = "Do I really need something this fancy to move dirt around?",
		NUTRIENTSGOGGLESHAT = "This will help me see all the science hiding in the dirt.",
		PLANTREGISTRYHAT = "To understand the plant, you must wear the plant.",

        FARM_SOIL_DEBRIS = "It's making a mess of my garden.",

		FIRENETTLES = "If you can't stand the heat, stay out of the garden.",
		FORGETMELOTS = "Hm. I can't remember what I was going to say about those.",
		SWEETTEA = "A nice cup of tea to forget all my problems.",
		TILLWEED = "Out of my garden, you!",
		TILLWEEDSALVE = "My salve-ation.",
        WEED_IVY = "Hey, you're not a vegetable!",
        IVY_SNARE = "Now that's just rude.",

		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "I can scientifically measure my harvest's heftiness.",
			HAS_ITEM = "Weight: {weight}\nHarvested on day: {day}\nNot bad.",
			HAS_ITEM_HEAVY = "Weight: {weight}\nHarvested on day: {day}\nWho knew they grew that big?",
            HAS_ITEM_LIGHT = "It's so average the scale isn't even bothering to tell me its weight.",
			BURNING = "Mmm, what's cooking?",
			BURNT = "I suppose that wasn't the best way to cook it.",
        },

        CARROT_OVERSIZED = "That's one big bunch of carrots!",
        CORN_OVERSIZED = "What a big ear you have!",
        PUMPKIN_OVERSIZED = "A rather pumped up pumpkin.",
        EGGPLANT_OVERSIZED = "I still don't see any resemblance to an egg.",
        DURIAN_OVERSIZED = "I'm sure it'll make an even bigger stink.",
        POMEGRANATE_OVERSIZED = "That might be the biggest pomegranate I've ever seen.",
        DRAGONFRUIT_OVERSIZED = "I half expect it to sprout wings.",
        WATERMELON_OVERSIZED = "A big, juicy watermelon.",
        TOMATO_OVERSIZED = "A tomato of incredible proportions.",
        POTATO_OVERSIZED = "That's a tater lot.",
        ASPARAGUS_OVERSIZED = "I guess we'll be eating asparagus for a while...",
        ONION_OVERSIZED = "They grow up so fast! It's... it's bringing a tear to my eye.",
        GARLIC_OVERSIZED = "A gargantuan garlic!",
        PEPPER_OVERSIZED = "A pepper of rather unusual size.",

        VEGGIE_OVERSIZED_ROTTEN = "What rotten luck.",

		FARM_PLANT =
		{
			GENERIC = "That's a plant!",
			SEED = "And now, we wait.",
			GROWING = "Grow my beautiful creation, grow!",
			FULL = "Time to reap science's rewards.",
			ROTTEN = "Drat! If only I'd picked it while I had the chance!",
			FULL_OVERSIZED = "With the power of science, I've produced monstrous produce!",
			ROTTEN_OVERSIZED = "What rotten luck.",
			FULL_WEED = "I knew I'd weed out the imposter eventually!",

			BURNING = "That can't be good for the plants...",
		},

        FRUITFLY = "Buzz off!",
        LORDFRUITFLY = "Hey, stop upsetting the plants!",
        FRIENDLYFRUITFLY = "The garden seems happier with it around.",
        FRUITFLYFRUIT = "Now I'm in charge!",

        SEEDPOUCH = "I was getting tired of carrying loose seeds in my pockets.",

		-- Crow Carnival
		CARNIVAL_HOST = "What an odd fellow.",
		CARNIVAL_CROWKID = "Good day to you, small bird person.",
		CARNIVAL_GAMETOKEN = "One shiny token.",
		CARNIVAL_PRIZETICKET =
		{
			GENERIC = "That's the ticket!",
			GENERIC_SMALLSTACK = "That's the tickets!",
			GENERIC_LARGESTACK = "That's a lot of tickets!",
		},

		CARNIVALGAME_FEEDCHICKS_NEST = "It's a little trapdoor.",
		CARNIVALGAME_FEEDCHICKS_STATION =
		{
			GENERIC = "It won't let me play until I give it something shiny.",
			PLAYING = "This looks like fun!",
		},
		CARNIVALGAME_FEEDCHICKS_KIT = "This really is a pop-up carnival.",
		CARNIVALGAME_FEEDCHICKS_FOOD = "I don't need to chew them up first, do I?",

		CARNIVALGAME_MEMORY_KIT = "This really is a pop-up carnival.",
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

		CARNIVALGAME_HERDING_KIT = "This really is a pop-up carnival.",
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
			GENERIC = "It won't let me play until I give it something shiny.",
			PLAYING = "It turns out that spinning your wheels is actually very productive.",
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
		CARNIVALDECOR_BANNER_KIT = "I have to build it myself? I should have known there'd be a catch.",
		CARNIVALDECOR_BANNER = "I think all these shiny decorations reflect well on me.",

		CARNIVALDECOR_FIGURE =
		{
			RARE = "See? Proof that trying the exact same thing over and over will eventually lead to success!",
			UNCOMMON = "You don't see this kind of design too often.",
			GENERIC = "I seem to be getting a lot of these...",
		},
		CARNIVALDECOR_FIGURE_KIT = "The thrill of discovery!",
		CARNIVALDECOR_FIGURE_KIT_SEASON2 = "The thrill of discovery!",

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
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_DOLL = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_FESTIVE = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_NATURE = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_ROBOT = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_ICE = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_FORMAL = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_VICTORIAN = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
        },
        YOTB_BEEFALO_DOLL_BEAST = {
            GENERIC = "Scientifically formulated for maximum huggableness.",
            YOTB = "I wonder what the Judge would say about this?",
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
			GENERIC = "I bet there's a lot of interesting science inside.",
			RECHARGING = "I guess it needs time to... recalibrate the, uh... time whatsit.",
		},

        POCKETWATCH_REVIVE = {
			GENERIC = "I bet there's a lot of interesting science inside.",
			RECHARGING = "I guess it needs time to... recalibrate the, uh... time whatsit.",
		},

        POCKETWATCH_WARP = {
			GENERIC = "I bet there's a lot of interesting science inside.",
			RECHARGING = "It's doing \"time stuff\", that's the technical term.",
		},

        POCKETWATCH_RECALL = {
			GENERIC = "I bet there's a lot of interesting science inside.",
			RECHARGING = "It's doing \"time stuff\", that's the technical term.",
			UNMARKED = "only_used_by_wanda",
			MARKED_SAMESHARD = "only_used_by_wanda",
			MARKED_DIFFERENTSHARD = "only_used_by_wanda",
		},

        POCKETWATCH_PORTAL = {
			GENERIC = "I bet there's a lot of interesting science inside.",
			RECHARGING = "It's doing \"time stuff\", that's the technical term.",
			UNMARKED = "only_used_by_wanda unmarked",
			MARKED_SAMESHARD = "only_used_by_wanda same shard",
			MARKED_DIFFERENTSHARD = "only_used_by_wanda other shard",
		},

        POCKETWATCH_WEAPON = {
			GENERIC = "That looks like a bad time just waiting to happen.",
			DEPLETED = "only_used_by_wanda",
		},

        POCKETWATCH_PARTS = "Wait a minute, this is starting to look more like magic than science!",
        POCKETWATCH_DISMANTLER = "I wonder if she got them second hand.",

        POCKETWATCH_PORTAL_ENTRANCE =
		{
			GENERIC = "Onward, to discovery!",
			DIFFERENTSHARD = "Onward, to discovery!",
		},
        POCKETWATCH_PORTAL_EXIT = "It's a long drop down.",

        -- Waterlog
        WATERTREE_PILLAR = "That tree is massive!",
        OCEANTREE = "I think these trees are a little lost.",
        OCEANTREENUT = "There's something alive inside.",
        WATERTREE_ROOT = "It's not a square root.",

        OCEANTREE_PILLAR = "It's not quite as great as the original, but still pretty good.",

        OCEANVINE = "The scientific term is \"tree noodles\".",
        FIG = "I'll call it \"Newton's Fig\".",
        FIG_COOKED = "It's been warmed by science.",

        SPIDER_WATER = "Why in the name of science do they get to float?",
        MUTATOR_WATER = "Oh wow, that looks um... delicious, Webber!",
        OCEANVINE_COCOON = "What if I just gave it a little poke?",
        OCEANVINE_COCOON_BURNT = "I smell burnt toast.",

        GRASSGATOR = "I don't think he likes me very much.",

        TREEGROWTHSOLUTION = "Mmmm, tree food!",

        FIGATONI = "Mama mia!",
        FIGKABAB = "Fig with a side of stick.",
        KOALEFIG_TRUNK = "Great, now I've got a stuffed nose.",
        FROGNEWTON = "The fig really brings it all together.",

        -- The Terrorarium
        TERRARIUM = {
            GENERIC = "Looking at it makes my head feel fuzzy... or... blocky?",
            CRIMSON = "I have a nasty feeling about this...",
            ENABLED = "Am I on the other side of the rainbow?!",
			WAITING_FOR_DARK = "What could it be? Maybe I'll sleep on it.",
			COOLDOWN = "It needs to cool down after that.",
			SPAWN_DISABLED = "I shouldn't be bothered by anymore prying eyes now.",
        },

        -- Wolfgang
        MIGHTY_GYM =
        {
            GENERIC = "I think I pulled a muscle just looking at it...",
            BURNT = "It won't pull any muscles now.",
        },

        DUMBBELL = "I usually let my mind do all the heavy lifting.",
        DUMBBELL_GOLDEN = "It's worth its weight in gold.",
		DUMBBELL_MARBLE = "I've trained my brain to be the strongest muscle in my body.",
        DUMBBELL_GEM = "I'll conquer this weight with the power of-- ACK! My spine!!",
        POTATOSACK = "It's either filled with potato-shaped rocks or rock-shaped potatoes.",


        TERRARIUMCHEST =
		{
			GENERIC = "What harm ever came from peeking inside a box?",
			BURNT = "It won't be bothering anyone anymore.",
			SHIMMER = "That seems a bit out of place...",
		},

		EYEMASKHAT = "You could say I have an eye for style.",

        EYEOFTERROR = "Go for the eye!",
        EYEOFTERROR_MINI = "I'm starting to feel self-conscious.",
        EYEOFTERROR_MINI_GROUNDED = "I think it's about to hatch...",

        FROZENBANANADAIQUIRI = "Yellow and mellow.",
        BUNNYSTEW = "This one's luck has run out.",
        MILKYWHITES = "...Ew.",

        CRITTER_EYEOFTERROR = "Always good to have another set of eyes! Er... eye.",

        SHIELDOFTERROR ="The best defense is a good mawfence.",
        TWINOFTERROR1 = "Maybe they're friendly? ...Maybe not.",
        TWINOFTERROR2 = "Maybe they're friendly? ...Maybe not.",

        -- Year of the Catcoon
        CATTOY_MOUSE = "Mice with wheels, what will science think up next?",
        KITCOON_NAMETAG = "I should think of some names! Let's see, Wilson Jr., Wilson Jr. 2...",

		KITCOONDECOR1 =
        {
            GENERIC = "It's not a real bird, but the kits don't know that.",
            BURNT = "Combustion!",
        },
		KITCOONDECOR2 =
        {
            GENERIC = "Those kits are so easily distracted. Now what was I doing again?",
            BURNT = "It went up in flames.",
        },

		KITCOONDECOR1_KIT = "It looks like there's some assembly required.",
		KITCOONDECOR2_KIT = "It doesn't look too hard to build.",

        -- WX78
        WX78MODULE_MAXHEALTH = "So much science packed into one tiny gizmo.",
        WX78MODULE_MAXSANITY1 = "So much science packed into one tiny gizmo.",
        WX78MODULE_MAXSANITY = "So much science packed into one tiny gizmo.",
        WX78MODULE_MOVESPEED = "So much science packed into one tiny gizmo.",
        WX78MODULE_MOVESPEED2 = "So much science packed into one tiny gizmo.",
        WX78MODULE_HEAT = "So much science packed into one tiny gizmo.",
        WX78MODULE_NIGHTVISION = "So much science packed into one tiny gizmo.",
        WX78MODULE_COLD = "So much science packed into one tiny gizmo.",
        WX78MODULE_TASER = "So much science packed into one tiny gizmo.",
        WX78MODULE_LIGHT = "So much science packed into one tiny gizmo.",
        WX78MODULE_MAXHUNGER1 = "So much science packed into one tiny gizmo.",
        WX78MODULE_MAXHUNGER = "So much science packed into one tiny gizmo.",
        WX78MODULE_MUSIC = "So much science packed into one tiny gizmo.",
        WX78MODULE_BEE = "So much science packed into one tiny gizmo.",
        WX78MODULE_MAXHEALTH2 = "So much science packed into one tiny gizmo.",

        WX78_SCANNER =
        {
            GENERIC ="WX-78 really puts a piece of themselves into their work.",
            HUNTING = "Get that data!",
            SCANNING = "Seems like it's found something.",
        },

        WX78_SCANNER_ITEM = "I wonder if it dreams about scanning sheep.",
        WX78_SCANNER_SUCCEEDED = "It's got the look of someone eager to show their work.",

        WX78_MODULEREMOVER = "Obviously a very delicate and complicated scientific instrument.",

        SCANDATA = "Smells like fresh research.",

		-- QOL 2022
		JUSTEGGS = "It could use some bacon.",
		VEGGIEOMLET = "Breakfast is the most scientific meal of the day.",
		TALLEGGS = "A breakthrough in breakfast technology!",
		BEEFALOFEED = "None for me, thank you.",
		BEEFALOTREAT = "A bit too grainy for my taste.",

        -- Pirates
        BOAT_ROTATOR = "Things are going in the right direction. Or maybe the left.",
        BOAT_ROTATOR_KIT = "I think I'll take it out for a spin.",
        BOAT_BUMPER_KELP = "It won't save the boat from everything, but it sure kelps.",
        BOAT_BUMPER_KELP_KIT = "A soon-to-be boat bumper.",
        BOAT_BUMPER_SHELL = "It gives the boat a little shellf defence.",
        BOAT_BUMPER_SHELL_KIT = "A soon-to-be boat bumper.",
        BOAT_CANNON = {
            GENERIC = "I should load it with something.",
            AMMOLOADED = "The cannon is ready to fire!",
            NOAMMO = "I didn't forget the cannonballs, I'm just letting the anticipation build.",
        },
        BOAT_CANNON_KIT = "It's not a cannon yet, but it will be.",
        CANNONBALL_ROCK_ITEM = "This will fit into a cannon perfectly.",

        OCEAN_TRAWLER = {
            GENERIC = "It makes fishing more effishient.",
            LOWERED = "And now we wait.",
            CAUGHT = "It caught something!",
            ESCAPED = "Looks like something was caught, but it escaped...",
            FIXED = "All ready to catch fish again!",
        },
        OCEAN_TRAWLER_KIT = "I should put it somewhere with lots of fish.",

        BOAT_MAGNET =
        {
            GENERIC = "I'm always drawn to physics, like a... ah, can't think of the word.",
            ACTIVATED = "It's working!! Er, I knew it would work, of course.",
        },
        BOAT_MAGNET_KIT = "One of my more genius ideas, if I do say so myself.",

        BOAT_MAGNET_BEACON =
        {
            GENERIC = "This will attract any strong magnets nearby.",
            ACTIVATED = "Magnetism!",
        },
        DOCK_KIT = "Everything I need to build a dock for my boat.",
        DOCK_WOODPOSTS_ITEM = "Aha! I thought the dock was missing something.",

        MONKEYHUT =
        {
            GENERIC = "Treehouses are terribly flammable places to conduct experiments.",
            BURNT = "Like I said!",
        },
        POWDER_MONKEY = "Don't you dare monkey around with my boat!",
        PRIME_MATE = "A nice hat is always a clear indicator of who's in charge.",
		LIGHTCRAB = "It's bioluminous!",
        CUTLESS = "What it lacks in slicing it makes up for in splinters.",
        CURSED_MONKEY_TOKEN = "It seems harmless.",
        OAR_MONKEY = "It really puts the paddle to the battle.",
        BANANABUSH = "That bush is bananas!",
        DUG_BANANABUSH = "That bush is bananas!",
        PALMCONETREE = "Kind of piney, for a palm tree.",
        PALMCONE_SEED = "The very beginnings of a tree.",
        PALMCONE_SAPLING = "It has big dreams of being a tree one day.",
        PALMCONE_SCALE = "If trees had toenails, I imagine they'd look like this.",
        MONKEYTAIL = "I wonder if they're edible? Maybe an experiment is in order.",
        DUG_MONKEYTAIL = "I wonder if they're edible? Maybe an experiment is in order.",

        MONKEY_MEDIUMHAT = "I think it makes me look very dashing and captain-like.",
        MONKEY_SMALLHAT = "At least it will keep my hair dry.",
        POLLY_ROGERSHAT = "A little bird told me it will come in handy.",
        POLLY_ROGERS = "That's the little bird.",

        MONKEYISLAND_PORTAL = "Nothing can get in, but it keeps spitting things out.",
        MONKEYISLAND_PORTAL_DEBRIS = "This machinery looks oddly familiar...",
        MONKEYQUEEN = "She looks like the top banana around here.",
        MONKEYPILLAR = "A real pillar of the community.",
        PIRATE_FLAG_POLE = "Ahoy!",

        BLACKFLAG = "Gentleman Pirate-Scientist does have a bit of a ring to it.",
        PIRATE_STASH = "I'm diggin' the decor.",
        STASH_MAP = "It's nice to have some direction in life.",

        BANANAJUICE = "Makes me feel a bit rogueish.",

        FENCE_ROTATOR = "Enguard! Re-post!",

        CHARLIE_STAGE_POST = "It's a setup! It feels too... staged.",
        CHARLIE_LECTURN = "Is someone doing a play?",

        CHARLIE_HECKLER = "They're just here to stir up drama.",

        PLAYBILL_THE_DOLL = "\"Authored by C.W.\"",
        STATUEHARP_HEDGESPAWNER = "The flowers grew back, but the head didn't.",
        HEDGEHOUND = "It's an ambush!",
        HEDGEHOUND_BUSH = "It's a bush.",

        MASK_DOLLHAT = "It's a doll mask.",
        MASK_DOLLBROKENHAT = "It's a cracked doll mask.",
        MASK_DOLLREPAIREDHAT = "It was a doll mask at one point.",
        MASK_BLACKSMITHHAT = "It's a blacksmith mask.",
        MASK_MIRRORHAT = "It's a mask, but it looks like a mirror.",
        MASK_QUEENHAT = "It's a Queen mask.",
        MASK_KINGHAT = "It's a King mask.",
        MASK_TREEHAT = "It's a tree mask.",
        MASK_FOOLHAT = "It's a fool's mask.",

        COSTUME_DOLL_BODY = "It's a doll costume.",
        COSTUME_QUEEN_BODY = "It's a Queen costume.",
        COSTUME_KING_BODY = "It's a King costume.",
        COSTUME_BLACKSMITH_BODY = "It's a blacksmith costume.",
        COSTUME_MIRROR_BODY = "It's a costume.",
        COSTUME_TREE_BODY = "It's a tree costume.",
        COSTUME_FOOL_BODY = "It's a fool's costume.",

        STAGEUSHER =
        {
            STANDING = "Just keep your hand to yourself, alright?",
            SITTING = "Something's odd here, but I can't put my finger on it.",
        },
        SEWING_MANNEQUIN =
        {
            GENERIC = "All dressed up and nowhere to go.",
            BURNT = "All burnt up and nowhere to go.",
        },
    },

    DESCRIBE_GENERIC = "It's a... thing.",
    DESCRIBE_TOODARK = "It's too dark to see!",
    DESCRIBE_SMOLDERING = "That thing is about to catch fire.",

    DESCRIBE_PLANTHAPPY = "What a happy plant!",
    DESCRIBE_PLANTVERYSTRESSED = "This plant seems to be under a lot of stress.",
    DESCRIBE_PLANTSTRESSED = "It's a little cranky.",
    DESCRIBE_PLANTSTRESSORKILLJOYS = "I might have to do a bit of weeding...",
    DESCRIBE_PLANTSTRESSORFAMILY = "It's my scientific conclusion that this plant seems lonely.",
    DESCRIBE_PLANTSTRESSOROVERCROWDING = "There are too many plants competing for this small space.",
    DESCRIBE_PLANTSTRESSORSEASON = "This season is not being kind to this plant.",
    DESCRIBE_PLANTSTRESSORMOISTURE = "This looks really dehydrated.",
    DESCRIBE_PLANTSTRESSORNUTRIENTS = "This poor plant needs nutrients!",
    DESCRIBE_PLANTSTRESSORHAPPINESS = "It's hungry for some good conversation.",

    EAT_FOOD =
    {
        TALLBIRDEGG_CRACKED = "Mmm. Beaky.",
		WINTERSFEASTFUEL = "Tastes like the holidays.",
    },
}

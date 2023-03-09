--Layout generated from PropagateSpeech.bat via speech_tools.lua
return{
	WIXIE_SPAWN =
        {
            "Wait... where am I?",
            "Oh, it's this place again...",
            "Last thing I remember was dying. It sucked!",
        },

	ACTIONFAIL =
	{
        APPRAISE =
        {
            NOTNOW = "A waste of time.",
        },
        REPAIR =
        {
            WRONGPIECE = "Somehow that's wrong, and it's not my fault!",
        },
        BUILD =
        {
            MOUNTED = "Let me down you stupid beast!",
            HASPET = "The last thing I need are more nagging critters near me.",
			TICOON = "One is more than enough!",
        },
		SHAVE =
		{
			AWAKEBEEFALO = "It's like it doesn't WANT to be shaved.",
			GENERIC = "No matter how hard I try, it's not gonna work.",
			NOBITS = "Would you just grow your fur back already?",
--fallback to speech_wilson.lua             REFUSE = "only_used_by_woodie",
            SOMEONEELSESBEEFALO = "Oh come on, it would have been a good prank!",
		},
		STORE =
		{
			GENERIC = "I can't cram anything else in there!",
			NOTALLOWED = "What? Why not?!",
			INUSE = "Move over, block head!",
            NOTMASTERCHEF = "I think 'master chef' is a subjective title.",
		},
        CONSTRUCT =
        {
            INUSE = "Could you hurry up?",
            NOTALLOWED = "No, that isn't happening.",
            EMPTY = "I need more... stuff.",
            MISMATCH = "I'm trying to force it, but it just won't work.",
        },
		RUMMAGE =
		{
			GENERIC = "That's not happening.",
			INUSE = "Move over, mush for brains!",
            NOTMASTERCHEF = "I think 'master chef' is a subjective title.",
		},
		UNLOCK =
        {
        	WRONGKEY = "Doesn't fit, even when I force it.",
        },
		USEKLAUSSACKKEY =
        {
        	WRONGKEY = "What? Stupid lock!",
        	KLAUS = "I'm suddenly feeling very nervous.",
			QUAGMIRE_WRONGKEY = "Did I get ripped off? This key doesn't work!",
        },
		ACTIVATE =
		{
			LOCKED_GATE = "Locked, and I can't break in...",
            HOSTBUSY = "Hey, you! ...Are you ignoring me?",
            CARNIVAL_HOST_HERE = "Where's that greasy feather bag?",
            NOCARNIVAL = "The flock of feathered freaks flew off!",
			EMPTY_CATCOONDEN = "No more? Oh well.",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDERS = "Won't be fun if there's no one to seek.",
			KITCOON_HIDEANDSEEK_NOT_ENOUGH_HIDING_SPOTS = "Not much fun if there's nowhere to hide.",
			KITCOON_HIDEANDSEEK_ONE_GAME_PER_DAY = "Bored now!",
            MANNEQUIN_EQUIPSWAPFAILED = "Yeah, you WOULD look pretty dumb wearing that...",
            PILLOWFIGHT_NO_HANDPILLOW = "What, are my fists not enough for a fight?",
		},
		OPEN_CRAFTING = 
		{
            PROFESSIONALCHEF = "I think 'master chef' is a subjective title.",
			SHADOWMAGIC = "Oh come on, I could handle some dark magic!",
		},
        COOK =
        {
            GENERIC = "I promise I won't burn anything... that I'M going to eat atleast.",
            INUSE = "Your cooking stinks! Let me do it!",
            TOOFAR = "Could someone move it closer?",
        },
        START_CARRAT_RACE =
        {
            NO_RACERS = "I need some racing rats to race rats.",
        },

		DISMANTLE =
		{
			COOKING = "It's taking too long!",
			INUSE = "Could you take a few steps back?",
			NOTEMPTY = "If I do that, my ingredients will spill on the floor.",
        },
        FISH_OCEAN =
		{
			TOODEEP = "This rod is too small and weak!",
		},
        OCEAN_FISHING_POND =
		{
			WRONGGEAR = "This rod is too large and unwieldy!",
		},
        --wickerbottom specific action
--fallback to speech_wilson.lua         READ =
--fallback to speech_wilson.lua         {
--fallback to speech_wilson.lua             GENERIC = "only_used_by_wickerbottom",
--fallback to speech_wilson.lua             NOBIRDS = "only_used_by_wickerbottom"
--fallback to speech_wilson.lua         },

        GIVE =
        {
            GENERIC = "I can't put that there, but I'm still trying to.",
            DEAD = "No, no, corpses are for looting, not storing!",
            SLEEPING = "Hey! Wake up!",
            BUSY = "They're busy, probably doing something unimportant.",
            ABIGAILHEART = "I just wanted to get her hopes up.",
            GHOSTHEART = "They prefer the benefits of ghostly-ness.",
            NOTGEM = "The cut is all wrong.",
            WRONGGEM = "Truly, truly outrageous.",
            NOTSTAFF = "Needs something stick-like.",
            MUSHROOMFARM_NEEDSSHROOM = "Needs more fungus.",
            MUSHROOMFARM_NEEDSLOG = "I'll try using more of those screaming logs.",
            MUSHROOMFARM_NOMOONALLOWED = "I don't think it'll grow, even if I threaten it.",
            SLOTFULL = "I've packed it till it could be packed no more.",
            FOODFULL = "It's stuffed.",
            NOTDISH = "This ain't edible, I've tried.",
            DUPLICATE = "Don't teach your Grandmother to suck eggs.",
            NOTSCULPTABLE = "It's unscrupulously unsculptable.",
            NOTATRIUMKEY = "Probably needs a key with a more magic touch.",
            CANTSHADOWREVIVE = "Somethings wrong. Now who should I blame...",
            WRONGSHADOWFORM = "I ain't a fossil worker.",
            NOMOON = "Let's wait until dark.",
			PIGKINGGAME_MESSY = "This place is a mess, but I don't want to clean up!",
			PIGKINGGAME_DANGER = "I'll try again when I have less noses in my business.",
			PIGKINGGAME_TOOLATE = "It's too late!",
			CARNIVALGAME_INVALID_ITEM = "Wrong thingamajig.",
			CARNIVALGAME_ALREADY_PLAYING = "Hurry up would ya? I want a turn!",
            SPIDERNOHAT = "Seems like more of a hat guy to me.",
            TERRARIUM_REFUSE = "Well, I think it would make an interesting addition...",
            TERRARIUM_COOLDOWN = "The tree's made like a leaf, and left.",
            NOTAMONKEY = "What? I don't speak that language.",
            QUEENBUSY = "You don't look busy to me!",
        },
        GIVETOPLAYER =
        {
            FULL = "Quit cramming your pockets with stuff.",
            DEAD = "Maybe this would have helped you not die.",
            SLEEPING = "Hey you! Wake up!",
            BUSY = "Could you hurry up?",
        },
        GIVEALLTOPLAYER =
        {
            FULL = "Quit cramming your pockets with stuff.",
            DEAD = "Maybe this would have helped you not die.",
            SLEEPING = "Hey you! Wake up!",
            BUSY = "Could you hurry up?",
        },
        WRITE =
        {
            GENERIC = "Aw come on...",
            INUSE = "Hurry up, so I can make some corrections.",
        },
        DRAW =
        {
            NOIMAGE = "A master artist always need a reference.",
        },
        CHANGEIN =
        {
            GENERIC = "I'm good, thanks.",
            BURNING = "Oh no. What a loss.",
            INUSE = "Seems a bit... cramped.",
            NOTENOUGHHAIR = "The lack of hair might be a problem.",
            NOOCCUPANT = "Ain't nobody here but us chickens.",
        },
        ATTUNE =
        {
            NOHEALTH = "Not while I'm hurting, thanks",
        },
        MOUNT =
        {
            TARGETINCOMBAT = "That's fine, I'm okay with walking.",
            INUSE = "Literally get off your metaphorical high horse.",
			SLEEPING = "Hey! Wake up!",
        },
        SADDLE =
        {
            TARGETINCOMBAT = "That's fine, I'm okay with walking.",
        },
        TEACH =
        {
            --Recipes/Teacher
            KNOWN = "Don't teach your Grandmother to suck eggs.",
            CANTLEARN = "Kind of boring, if I'm being honest.",

            --MapRecorder/MapExplorer
            WRONGWORLD = "Am I holding it upside down?",

			--MapSpotRevealer/messagebottle
			MESSAGEBOTTLEMANAGER_NOT_FOUND = "Strange, I don't see any oceans down here.",--Likely trying to read messagebottle treasure map in caves
        
            STASH_MAP_NOT_FOUND = "This... this doesn't lead anywhere!",-- Likely trying to read stash map  in world without stash
		},
        WRAPBUNDLE =
        {
            EMPTY = "As funny as it would be, you can't wrap air as a gift.",
        },
        PICKUP =
        {
			RESTRICTION = "It's not mine. For now.",
			INUSE = "I'll just stand around and wait.",
--fallback to speech_wilson.lua             NOTMINE_SPIDER = "only_used_by_webber",
            NOTMINE_YOTC =
            {
                "I would recognize that face anywhere!\n... is what I would say if you were mine.",
                "It ain't mine, and I'm not a pet thief.",
            },
--fallback to speech_wilson.lua 			NO_HEAVY_LIFTING = "only_used_by_wanda",
            FULL_OF_CURSES = "I'm not a thief!",
        },
        SLAUGHTER =
        {
            TOOFAR = "You're smart to run away.",
        },
        REPLATE =
        {
            MISMATCH = "What do you mean \"wrong food\"?",
            SAMEDISH = "No room for leftovers?",
        },
        SAIL =
        {
        	REPAIR = "Don't fix what ain't broke!",
        },
        ROW_FAIL =
        {
            BAD_TIMING0 = "Hey! Cut it out, ocean!",
            BAD_TIMING1 = "Just a bit of anger management, nothing to worry about.",
            BAD_TIMING2 = "Not my tempo!",
        },
        LOWER_SAIL_FAIL =
        {
            "I'll knock you over if you don't cooperate!",
            "Dang rope!",
            "Ow! Dumb sail!",
        },
        BATHBOMB =
        {
            GLASSED = "Nothing to bomb. What a shame.",
            ALREADY_BOMBED = "Bombed away.",
        },
		GIVE_TACKLESKETCH =
		{
			DUPLICATE = "I don't mean to be a know-it-all, but...",
		},
		COMPARE_WEIGHABLE =
		{
            FISH_TOO_SMALL = "Light as a proverbial feather.",
            OVERSIZEDVEGGIES_TOO_SMALL = "Merely a morsel.",
		},
        BEGIN_QUEST =
        {
--fallback to speech_wilson.lua             ONEGHOST = "only_used_by_wendy",
        },
		TELLSTORY =
		{
			GENERIC = "no spoop.",
			NOT_NIGHT = "not spoopy time.",
			NO_FIRE = "no fiar",
		},
        SING_FAIL =
        {
--fallback to speech_wilson.lua             SAMESONG = "only_used_by_wathgrithr",
        },
        PLANTREGISTRY_RESEARCH_FAIL =
        {
            GENERIC = "Not to sound like a know-it all, but...",
            FERTILIZER = "I'm all caught up on my goo-oligy, thanks.",
        },
        FILL_OCEAN =
        {
            UNSUITABLE_FOR_PLANTS = "What, is it not wet enough?",
        },
        POUR_WATER =
        {
            OUT_OF_WATER = "\"And not a drop to drink.\"",
        },
        POUR_WATER_GROUNDTILE =
        {
            OUT_OF_WATER = "\"And not a drop to drink.\"",
        },
        USEITEMON =
        {
            --GENERIC = "I can't use this on that!",

            --construction is PREFABNAME_REASON
            BEEF_BELL_INVALID_TARGET = "Not a fan of cowbell, it seems.",
            BEEF_BELL_ALREADY_USED = "That would be annoying, and I'd never annoy anyone.",
            BEEF_BELL_HAS_BEEF_ALREADY = "Already got one too many, thanks.",
        },
        HITCHUP =
        {
            NEEDBEEF = "I need one of those hairy beasts for this.",
            NEEDBEEF_CLOSER = "My beefalo needs to be closer, but not too close.",
            BEEF_HITCHED = "Successfully wrangled.",
            INMOOD = "Relax! ...Jerk.",
        },
        MARK =
        {
            ALREADY_MARKED = "I'm confident in my choices.",
            NOT_PARTICIPANT = "Well, I didn't want in on this crummy contest anyways.",
        },
        YOTB_STARTCONTEST =
        {
            DOESNTWORK = "Laziness, that's what I'd call it.",
            ALREADYACTIVE = "Must have started without me.",
        },
        YOTB_UNLOCKSKIN =
        {
            ALREADYKNOWN = "Not to sound like a know-it-all, but...",
        },
        CARNIVALGAME_FEED =
        {
            TOO_LATE = "Too slow!",
        },
        HERD_FOLLOWERS =
        {
            WEBBERONLY = "Believe it or not, I ain't a spider.",
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
            DOER_ISNT_MODULE_OWNER = "Hey, are you ignoring me?!",
        },
    },

	ANNOUNCE_CANNOT_BUILD =
	{
		NO_INGREDIENTS = "Can't make something out of nothing.",
		NO_TECH = "I think I'll need to do more reading on this.",
		NO_STATION = "Maybe with some better tools, or a proper work station?",
	},

	ACTIONFAIL_GENERIC = "Ain't happening.",
	ANNOUNCE_BOAT_LEAK = "I'd like to avoid drowning, if possible.",
	ANNOUNCE_BOAT_SINK = "Ah! Help!",
	ANNOUNCE_DIG_DISEASE_WARNING = "Work the sickness away.", --removed
	ANNOUNCE_PICK_DISEASE_WARNING = "I think it's rotten to the core.", --removed
	ANNOUNCE_ADVENTUREFAIL = "I'm going to sock-it to that jerk one way or another!",
    ANNOUNCE_MOUNT_LOWHEALTH = "What? It's just a few scrapes and bruises.",

    --waxwell and wickerbottom specific strings
--fallback to speech_wilson.lua     ANNOUNCE_TOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
--fallback to speech_wilson.lua     ANNOUNCE_WAYTOOMANYBIRDS = "only_used_by_waxwell_and_wicker",

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

	ANNOUNCE_BEES = "Buzz off.",
	ANNOUNCE_BOOMERANG = "Some nerve picking a fight with your owner!",
	ANNOUNCE_CHARLIE = "I can't see! I can't breathe!",
	ANNOUNCE_CHARLIE_ATTACK = "G-get away!",
--fallback to speech_wilson.lua 	ANNOUNCE_CHARLIE_MISSED = "only_used_by_winona", --winona specific
	ANNOUNCE_COLD = "C-colder than a p-popsicle...",
	ANNOUNCE_HOT = "I gotta find some shelter!",
	ANNOUNCE_CRAFTING_FAIL = "I can't make something out of nothing.",
	ANNOUNCE_DEERCLOPS = "What the heck was that?!",
	ANNOUNCE_CAVEIN = "Everything is shaking like a packed ballroom!",
	ANNOUNCE_ANTLION_SINKHOLE =
	{
		"Whose shaking the ground around?!",
		"Someones causing a racket!",
		"I hate earthquakes!",
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "Do you want this?",
        "Here, it's useless to me anyways.",
        "You're welcome?",
	},
	ANNOUNCE_SACREDCHEST_YES = "Easy enough.",
	ANNOUNCE_SACREDCHEST_NO = "Anyone have a pry-bar?",
    ANNOUNCE_DUSK = "It's getting dark, I'm going to need some light soon.",

    --wx-78 specific
--fallback to speech_wilson.lua     ANNOUNCE_CHARGE = "only_used_by_wx78",
--fallback to speech_wilson.lua 	ANNOUNCE_DISCHARGE = "only_used_by_wx78",

	ANNOUNCE_EAT =
	{
		GENERIC = "Can't complain.",
		PAINFUL = "That hit my gut like a hammer...",
		SPOILED = "I hardly recognize what I just ate, ugh...",
		STALE = "A bit stale, but I'll take it.",
		INVALID = "Is that even edible?",
        YUCKY = "Maybe as a prank?",

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
        "Just need the right... leverage...",
        "I'm too young to have... back... problems...!",
        "I should... make someone else carry this...!",
        "Deep breaths now...",
        "Breath in... and out...",
        "Where's a mule when you... need one...",
        "Just... a little... exercise...",
        "Errgh...",
        "I'm good... I'm good...",
    },
    ANNOUNCE_ATRIUM_DESTABILIZING =
    {
		"Whose shaking the ground?",
		"Quit making so much noise!",
		"Calm down, cave!",
	},
    ANNOUNCE_RUINS_RESET = "Wait, what?",
    ANNOUNCE_SNARED = "Hey! Hands off!",
    ANNOUNCE_SNARED_IVY = "Get back!",
    ANNOUNCE_REPELLED = "That makes two of us!",
	ANNOUNCE_ENTER_DARK = "I... I can't see! It's all around me!",
	ANNOUNCE_ENTER_LIGHT = "Phew, much better.",
	ANNOUNCE_FREEDOM = "Finally some fresh air...",
	ANNOUNCE_HIGHRESEARCH = "Not to sound like a know-it-all, but...",
	ANNOUNCE_HOUNDS = "Whose making all that racket?",
	ANNOUNCE_WORMS = "There's something under the ground.",
	ANNOUNCE_HUNGRY = "I'm hungry enough to eat a horse.",
	ANNOUNCE_HUNT_BEAST_NEARBY = "I can smell it from here. Gross.",
	ANNOUNCE_HUNT_LOST_TRAIL = "The trail has vanished into thin air!",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "Maybe it got washed away in a storm?",
	ANNOUNCE_INV_FULL = "Sorry, I'm all out of hidden pockets.",
	ANNOUNCE_KNOCKEDOUT = "Huh? Did I get hit on the head or something?",
	ANNOUNCE_LOWRESEARCH = "Yeah, I know that already.",
	ANNOUNCE_MOSQUITOS = "Nobody takes my blood and gets away with it!",
    ANNOUNCE_NOWARDROBEONFIRE = "Good.",
    ANNOUNCE_NODANGERGIFT = "Maybe when there's a few less nuisances around.",
    ANNOUNCE_NOMOUNTEDGIFT = "Gifts?! Outta my way!",
	ANNOUNCE_NODANGERSLEEP = "Maybe when there's a few less nuisances around.",
	ANNOUNCE_NODAYSLEEP = "Why sleep when we can run around and cause trouble all day?",
	ANNOUNCE_NODAYSLEEP_CAVE = "I'm not tired.",
	ANNOUNCE_NOHUNGERSLEEP = "My stomach is making too much noise.",
	ANNOUNCE_NOSLEEPONFIRE = "No rest for the wicked.",
    ANNOUNCE_NOSLEEPHASPERMANENTLIGHT = "Dim the light you dim-wit!",
	ANNOUNCE_NODANGERSIESTA = "Not much of a nap if I'm getting hounded.",
	ANNOUNCE_NONIGHTSIESTA = "Can't nap at night, don't be ridiculous.",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "I'd rather get a full nights rest.",
	ANNOUNCE_NOHUNGERSIESTA = "My stomach is making too much noise.",
	ANNOUNCE_NO_TRAP = "No tricks? How unfortunate...",
	ANNOUNCE_PECKED = "Ow! Jerk!",
	ANNOUNCE_QUAKE = "Sounds like an earthquake.",
	ANNOUNCE_RESEARCH = "Homework? Aw...",
	ANNOUNCE_SHELTER = "Dumb tree, it barely even protects me!",
	ANNOUNCE_THORNS = "Ow! I hate nature!",
	ANNOUNCE_BURNT = "Ow! Fire hurts!",
	ANNOUNCE_TORCH_OUT = "I could use some more light right about now...",
	ANNOUNCE_THURIBLE_OUT = "Needs more... something.",
	ANNOUNCE_FAN_OUT = "What can I say? I play hard.",
    ANNOUNCE_COMPASS_OUT = "Uh, okay... I'll give it a shot.",
	ANNOUNCE_TRAP_WENT_OFF = "I meant to do that.",
	ANNOUNCE_UNIMPLEMENTED = "Is it done yet?",
	ANNOUNCE_WORMHOLE = "I'm... I'm okay...",
	ANNOUNCE_TOWNPORTALTELEPORT = "I bet they'll be glad to see me.",
	ANNOUNCE_CANFIX = "\nI can fix it, then break it again!",
	ANNOUNCE_ACCOMPLISHMENT = "Finally I feel useful.",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "Well, this was a huge waste of my time.",
	ANNOUNCE_INSUFFICIENTFERTILIZER = "I need more ground food.",
	ANNOUNCE_TOOL_SLIP = "It jumped right out of my hand",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "I'm immune to your tricks, lightning!",
	ANNOUNCE_TOADESCAPING = "Coward!",
	ANNOUNCE_TOADESCAPED = "It ran away. I guess it was intimidated.",


	ANNOUNCE_DAMP = "I hate the rain.",
	ANNOUNCE_WET = "Ugh, it's like wearing an extra layer.",
	ANNOUNCE_WETTER = "I don't like being drenched by all this water...",
	ANNOUNCE_SOAKED = "I feel crowded! Get this water off me!",

	ANNOUNCE_WASHED_ASHORE = "I hate swimming, I prefer open air...",

    ANNOUNCE_DESPAWN = "Oh, my head...",
	ANNOUNCE_BECOMEGHOST = "Boo!",
	ANNOUNCE_GHOSTDRAIN = "How come everyones dying but me?",
	ANNOUNCE_PETRIFED_TREES = "Did they turn to rock? Or are they... encased by it?",
	ANNOUNCE_KLAUS_ENRAGE = "Now he's even scarier!",
	ANNOUNCE_KLAUS_UNCHAINED = "He's unleashed, and after me!",
	ANNOUNCE_KLAUS_CALLFORHELP = "More of them?!",

	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "Time to see what prize is hidden inside...",
		GLASS_LOW = "This sure is taking awhile...",
		GLASS_REVEAL = "Oh. I got a rock.",
		IDOL_MED = "Time to see what prize is hidden inside...",
		IDOL_LOW = "This sure is taking awhile...",
		IDOL_REVEAL = "Oh. I got a rock.",
		SEED_MED = "Time to see what prize is hidden inside...",
		SEED_LOW = "This sure is taking awhile...",
		SEED_REVEAL = "Oh. I got a rock.",
	},

    --hallowed nights
    ANNOUNCE_SPOOKED = "H-Hey!",
	ANNOUNCE_BRAVERY_POTION = "Nope, still anxious.",
	ANNOUNCE_MOONPOTION_FAILED = "They never taught potion making in school, okay?!",

	--winter's feast
	ANNOUNCE_EATING_NOT_FEASTING = "Better get some before I eat it all!",
	ANNOUNCE_WINTERS_FEAST_BUFF = "Finally some good food!",
	ANNOUNCE_IS_FEASTING = "Don't mind if I do!",
	ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "Any leftovers?",

    --lavaarena event
    ANNOUNCE_REVIVING_CORPSE = "Don't say I never did anything for you!",
    ANNOUNCE_REVIVED_OTHER_CORPSE = "See? I can be nice when I feel like it!",
    ANNOUNCE_REVIVED_FROM_CORPSE = "Yup, definitely better than being dead.",

    ANNOUNCE_FLARE_SEEN = "Whose setting off fireworks without me?!",
    ANNOUNCE_MEGA_FLARE_SEEN = "Something about that flare is making me mad!",
    ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "...What was that?",

    -- wx specific
    ANNOUNCE_WX_SCANNER_NEW_FOUND = "only_used_by_wx78",
--fallback to speech_wilson.lua     ANNOUNCE_WX_SCANNER_FOUND_NO_DATA = "only_used_by_wx78",
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
		"I need more things to shoot!",
		"Bang! Now you play dead.",
		"Gotcha! Wait, no...",
		"Can you just pretend you got hit?",
	},
	ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT =
	{
        "And thats why Wacky stinks! The end.",
	},
	ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT =
	{
        "And that's why Variant owes me 50 bucks. The End!",
	},

    -- wx specific
    ANNOUNCE_WX_SCANNER_NEW_FOUND = "only_used_by_wx78",
--fallback to speech_wilson.lua     ANNOUNCE_WX_SCANNER_FOUND_NO_DATA = "only_used_by_wx78",

    --quagmire event
    QUAGMIRE_ANNOUNCE_NOTRECIPE = "Huh. That always works out when I make it at home.",
    QUAGMIRE_ANNOUNCE_MEALBURNT = "Ah, perfectly seared charcoal. Classic recipe.",
    QUAGMIRE_ANNOUNCE_LOSE = "Not my fault that the big mouth is a picky eater.",
    QUAGMIRE_ANNOUNCE_WIN = "I knew it, my cooking was impeccable!",

    ANNOUNCE_ROYALTY =
    {
        "Oh, yes, you're soooo regal...",
        "Hail, your royal honey glazed sticky-ness.",
        "Don't let that crown go to your massive head.",
    },

    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "You'll be shocked!",
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "Hot head? HOT HEAD?! I'LL SHOW YOU A HOT HEAD!!",
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "What can I say? I've got thick skin!",
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "I could get my chores done in half the time!",
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "Now I can rough house in the rain without getting wet!",
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "I wasn't planning on sleeping anyways.",

    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "I've lost my glow.",
    ANNOUNCE_DETACH_BUFF_ATTACK            = "I can still throw a good punch.",
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "Don't need thick skin if you keep everyone away.",
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "I didn't want to do chores anyways.",
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "I. Hate. Rain.",
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "I COULD go for a nap right about now...",

	ANNOUNCE_OCEANFISHING_LINESNAP = "Aw you broke it!",
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "Needs a bit more muscle.",
	ANNOUNCE_OCEANFISHING_GOTAWAY = "Hey! Come back here!",
	ANNOUNCE_OCEANFISHING_BADCAST = "Stupid wind!",
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE =
	{
		"Come on... come on...",
		"How boring.",
		"Here fishy fishy...",
		"Maybe I should just jump in and grab one?",
	},

	ANNOUNCE_WEIGHT = "{weight}, could have put on a few more pounds.",
	ANNOUNCE_WEIGHT_HEAVY  = "{weight} ...how much we're you eating?",

	ANNOUNCE_WINCH_CLAW_MISS = "I missed? Oh, come on!",
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "What a waste of time!",

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
    },
    ANNOUNCE_WEAK_RAT = "Get some exercise.",

    ANNOUNCE_CARRAT_START_RACE = "AND THEY'RE OFF!",

    ANNOUNCE_CARRAT_ERROR_WRONG_WAY = {
        "Where are you going?!",
        "BOO! AHH! RUN THE OTHER WAY!",
    },
    ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "Hey! This ain't the time for a nap!",
    ANNOUNCE_CARRAT_ERROR_WALKING = "Put some leg work into it!",
    ANNOUNCE_CARRAT_ERROR_STUNNED = "Quit playing around and race!",

--fallback to speech_wilson.lua     ANNOUNCE_GHOST_QUEST = "only_used_by_wendy",
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

	ANNOUNCE_POCKETWATCH_PORTAL = "I just hope it's not cramped in there.",

--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_MARK = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_RECALL = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_OPEN_PORTAL = "only_used_by_wanda",
--fallback to speech_wilson.lua 	ANNOUNCE_POCKETWATCH_OPEN_PORTAL_DIFFERENTSHARD = "only_used_by_wanda",

    ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "Huh, sounds like some pretty worthless knowledge.",
    ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "I already knew that, though I wish I didn't.",
    ANNOUNCE_ARCHIVE_NO_POWER = "Needs some electricity.",

    ANNOUNCE_PLANT_RESEARCHED =
    {
        "I'm learning their weaknesses.",
    },

    ANNOUNCE_PLANT_RANDOMSEED = "I'm wary of surprises.",

    ANNOUNCE_FERTILIZER_RESEARCHED = "I'm learning about goop.",

	ANNOUNCE_FIRENETTLE_TOXIN =
	{
		"Ow! Yeah we'll see about that!",
		"Jerk!",
	},
	ANNOUNCE_FIRENETTLE_TOXIN_DONE = "Add whatever that plant was to the vendettas list...",

	ANNOUNCE_TALK_TO_PLANTS =
	{
        "Hurry up, or I'll grab my shovel...",
        "I'll tell your friends mean rumors if you don't grow faster...",
		"I know a couple of aphids that would love to meet you...",
        "You're looking extra flammable today, would be a shame if something were to happen...",
        "Grow. Or else.",
	},

	ANNOUNCE_KITCOON_HIDEANDSEEK_START = "Okay, fine... Ten... Nine... Six... One...",
	ANNOUNCE_KITCOON_HIDEANDSEEK_JOIN = "Make way for the seek-master!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND = 
	{
		"Easy!",
		"Try harder!",
		"Ha! Gotcha!",
		"Find a better spot next time!",
	},
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_ONE_MORE = "Only one more! Ha!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE = "I got them all! You all didn't stand a chance!",
	ANNOUNCE_KITCOON_HIDANDSEEK_FOUND_LAST_ONE_TEAM = "Hey! That one was mine!",
	ANNOUNCE_KITCOON_HIDANDSEEK_TIME_ALMOST_UP = "Not much time left!",
	ANNOUNCE_KITCOON_HIDANDSEEK_LOSEGAME = "The only thing I 'lost' is interest in this game!",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR = "Hiding this far away would be cheating.",
	ANNOUNCE_KITCOON_HIDANDSEEK_TOOFAR_RETURN = "Getting closer!",
	ANNOUNCE_KITCOON_FOUND_IN_THE_WILD = "Another stray, huh? Lots of you guys back home...",

	ANNOUNCE_TICOON_START_TRACKING	= "What, are you trying to lead me on or something?!",
	ANNOUNCE_TICOON_NOTHING_TO_TRACK = "Don't waste my time!",
	ANNOUNCE_TICOON_WAITING_FOR_LEADER = "Don't rush me!",
	ANNOUNCE_TICOON_GET_LEADER_ATTENTION = "Geez! Calm down, I'm coming!",
	ANNOUNCE_TICOON_NEAR_KITCOON = "Did you find something? Better be good.",
	ANNOUNCE_TICOON_LOST_KITCOON = "What a waste of time...",
	ANNOUNCE_TICOON_ABANDONED = "I don't need help from no stinkin' cat!",
	ANNOUNCE_TICOON_DEAD = "Sad to say, you see a lot of those around my home.",

    -- YOTB
    ANNOUNCE_CALL_BEEF = "Quit standing around and get over here!",
    ANNOUNCE_CANTBUILDHERE_YOTB_POST = "Building it this far away would just be inconvenient.",
    ANNOUNCE_YOTB_LEARN_NEW_PATTERN =  "Oh goodie, Beefalo clothes. Because I have nothing better to do.",

    -- AE4AE
    ANNOUNCE_EYEOFTERROR_ARRIVE = "What are YOU looking at?",
    ANNOUNCE_EYEOFTERROR_FLYBACK = "Back for another round?",
    ANNOUNCE_EYEOFTERROR_FLYAWAY = "Yeah, you'd better run!",

    -- PIRATES
    ANNOUNCE_CANT_ESCAPE_CURSE = "It's mine! No one else can have it!",
    ANNOUNCE_MONKEY_CURSE_1 = "Sweaty palms, loss of appetite, irritability... this can only mean one thing!",
    ANNOUNCE_MONKEY_CURSE_CHANGE = "I'd better not end up as some side act for a street performer!",
    ANNOUNCE_MONKEY_CURSE_CHANGEBACK = "No more monkey business!",

    ANNOUNCE_PIRATES_ARRIVE = "I like that tune, but it sounds like trouble.",

    ANNOUNCE_OFF_SCRIPT = "What? I was improvising!",

    ANNOUNCE_COZY_SLEEP = "Oh, so this wasn't a dream after all...",
	
	ANNOUNCE_TOOL_TOOWEAK = "Loathed as a I am to say it, we need a stronger tool!",
	
	BATTLECRY =
	{
		GENERIC = "Shove off why dontcha!",
		PIG = "I've had enough of you stinking up the place!",
		PREY = "Everyone has to eat!",
		SPIDER = "I've squashed tougher spiders than you!",
		SPIDER_WARRIOR = "Well, so what if you're big mean and scary!",
		DEER = "Survival of the fittest!",
	},
	COMBAT_QUIT =
	{
		GENERIC = "Quit being a wimp!",
		PIG = "Yeah that's right, make some room!",
		PREY = "Looks like we're not eating tonight.",
		SPIDER = "Yeah! Run!",
		SPIDER_WARRIOR = "You gonna cry?",
	},

	DESCRIBE =
	{
		MULTIPLAYER_PORTAL = "A big dumb door.",
        MULTIPLAYER_PORTAL_MOONROCK = "A big dumb fancy door",
        MOONROCKIDOL = "It's making me feel a bit light headed.",
        CONSTRUCTION_PLANS = "Just leave it to me! Everyone else might mess it up.",

        ANTLION =
        {
            GENERIC = "So... you live underground? Sounds awful.",
            VERYHAPPY = "So, you'll stop wrecking my stuff now, right?",
            UNHAPPY = "Yeah, you and me both...",
        },
        ANTLIONTRINKET = "I'm too old for toys like this! No offense, Charles...",
        SANDSPIKE = "What a dirty trick!",
        SANDBLOCK = "W-what? Are you trying to box me in or something?",
        GLASSSPIKE = "Luckily I don't have a glass jaw.",
        GLASSBLOCK = "I still don't like it, even when it's see through.",
        ABIGAIL_FLOWER =
        {
            GENERIC = "What a dumb flower.",
			LEVEL1 = "I don't think flowers are supposed to do this.",
			LEVEL2 = "Yes, you're real spooky.",
			LEVEL3 = "A haunted flower? Big deal...",

			-- deprecated
            LONG = "It's a shame they removed all this stuff.",
            MEDIUM = "",
            SOON = "",
            HAUNTED_POCKET = "",
            HAUNTED_GROUND = "",
        },

        BALLOONS_EMPTY = "Who just discards perfectly good balloons like that?",
        BALLOON = "Where did the helium come from?",
		BALLOONPARTY = "I don't like surprise parties.",
		BALLOONSPEED =
        {
            DEFLATED = "Looks like it's got the air knocked out of it.",
            GENERIC = "This makes me lighter, which lets me run faster? That makes sense. I think.",
        },
		BALLOONVEST = "Feels like I'm wearing nothing at all.",
		BALLOONHAT = "Lightweight and clear. I can get behind this hat!",

        BERNIE_INACTIVE =
        {
            BROKEN = "That's how most of my toys ended up.",
            GENERIC = "Just a regular old teddy bear.",
        },

        BERNIE_ACTIVE = "Dance for me! Dance!",
        BERNIE_BIG = "What, is he going to pillow fight me to death?",

		BOOKSTATION =
		{
			GENERIC = "It's where books go when you don't want to throw them out.",
			BURNT = "It was Willow. Probably.",
		},
        BOOK_BIRDS = "This book is for the birds!",
        BOOK_TENTACLES = "Should I ask why the book is wet and slimy too?",
        BOOK_GARDENING = "What's there to learn? You plant seeds, and they grow.",
		BOOK_SILVICULTURE = "I can't wait to learn about wood. And bark. And twigs.",
		BOOK_HORTICULTURE = "What's there to learn? You plant seeds, and they grow.",
        BOOK_SLEEP = "My dad used to sing me to sleep. Books don't sing, so I'm not interested.",
        BOOK_BRIMSTONE = "A bit of a downer, to be honest.",

        BOOK_FISH = "I hope it's not a scam.",
        BOOK_FIRE = "I wonder how well it would burn?",
        BOOK_WEB = "Is this a prank? Is it filled with spiders?",
        BOOK_TEMPERATURE = "From the north pole to the tropics, it covers it all.",
        BOOK_LIGHT = "You can even read it in the dark!",
        BOOK_RAIN = "The pages are laminated! That librarian thought of everything...",
        BOOK_MOON = "It's big, round, and glows in the dark. What else do you need to know?",
        BOOK_BEES = "It's the bees, minus the knees.",
        
        BOOK_HORTICULTURE_UPGRADED = "It's trying to plant ideas in my head.",
        BOOK_RESEARCH_STATION = "It's like every other book.",
        BOOK_LIGHT_UPGRADED = "The perfect 'past bedtime' book!",

        FIREPEN = "Four eyes was right, this pen IS mightier than the sword!",

        PLAYER =
        {
            GENERIC = "Oh, great, it's %s...",
            ATTACKER = "%s should keep their distance!",
            MURDERER = "Oh NOW you've done it, %s!",
            REVIVER = "%s is a goodie two shoes.",
            GHOST = "%s? Dead? I'm shocked.",
            FIRESTARTER = "You're wild, %s!",
        },
        WILSON =
        {
            GENERIC = "Hey %s! Any new failures lately? Besides you, that is.",
            ATTACKER = "If the experiment was to make me mad, it worked!",
            MURDERER = "%s has finally lost his marbles!",
            REVIVER = "Leave me out of your experiments, %s!",
            GHOST = "So... which experiment blew up in your face this time?",
            FIRESTARTER = "Congratulations %s, you discovered fire.",
        },
        WOLFGANG =
        {
            GENERIC = "Watch where you're walking, %s, you muscled moron!",
            ATTACKER = "Oh yeah, you're SO tough.",
            MURDERER = "What, did you trip and fall on someone?",
            REVIVER = "Looks like %s has a brain after all!",
            GHOST = "All that muscle and you STILL died?",
            FIRESTARTER = "%s learned that fire hurts.",
        },
        WAXWELL =
        {
            GENERIC = "It's the snobbiest one of them all, %s!",
            ATTACKER = "%s is hurting people, but that's nothing new.",
            MURDERER = "What's one more, right %s?",
            REVIVER = "Playing with people's lives again I see.",
            GHOST = "You had that coming, %s.",
            FIRESTARTER = "Reckless doesn't suit you, %s.",
        },
        WX78 =
        {
            GENERIC = "%s is a rust bucket.",
            ATTACKER = "I think %s is faulty.",
            MURDERER = "%s has a few wires loose.",
            REVIVER = "Unexpectedly mushy of you, %s.",
            GHOST = "What kind of stupid upgrade is that, %s?",
            FIRESTARTER = "I wonder if %s is fire proof...",
        },
        WILLOW =
        {
            GENERIC = "%s is such a creep.",
            ATTACKER = "%s has a mean streak.",
            MURDERER = "Didn't you parents teach you any manners, %s?!",
            REVIVER = "%s's just as likely to help as she is to hurt.",
            GHOST = "%s is less dangerous like this.",
            FIRESTARTER = "Lighting fires? That's just what %s does. Why is anyone surprised?",
        },
        WENDY =
        {
            GENERIC = "Oh no, it's %s, crying a river as usual.",
            ATTACKER = "Go take it out on someone else, %s!",
            MURDERER = "Is that what you did to Abby, %s?",
            REVIVER = "Surprised %s could bring me back to life.",
            GHOST = "What? Isn't this what you wanted %s?",
            FIRESTARTER = "Children shouldn't play with fire.",
        },
        WOODIE =
        {
            GENERIC = "%s is nuttier than a candy bar.",
            ATTACKER = "What happened to that Canadian hospitality, %s?",
            MURDERER = "I knew Canadians were nothing but trouble!",
            REVIVER = "Canadians are suckers!",
            GHOST = "Looks like %s kindness didn't save them.",
            BEAVER = "Maybe I'm just desensitized, but this doesn't surprise me.",
            BEAVERGHOST = "Do beavers have souls?",
            MOOSE = "Seems a bit derivative.",
            MOOSEGHOST = "Not so tough, it seems.",
            GOOSE = "He's gone and turned himself into something even more annoying.",
            GOOSEGHOST = "Finally, a break from all that honking.",
            FIRESTARTER = "There goes all your precious wood.",
        },
        WICKERBOTTOM =
        {
            GENERIC = "Can %s even see where she's going?",
            ATTACKER = "Maybe if you opened your eyes you would see what you're attacking.",
            MURDERER = "People die when you hurt them. Didn't you know that?",
            REVIVER = "Finally, that brain made itself useful!",
            GHOST = "You were only a couple years away, anyways.",
            FIRESTARTER = "Burn any good books lately?",
        },
        WES =
        {
            GENERIC = "Do you think being trapped in a box is amusing, %s?",
            ATTACKER = "It's not pantomime when you actually hit someone.",
            MURDERER = "It's always the quiet ones!",
            REVIVER = "I'm glad %s didn't try to use a balloon heart.",
            GHOST = "Why didn't you just yell for help?",
            FIRESTARTER = "Is starting fires part of some new act?",
        },
        WEBBER =
        {
            GENERIC = "Careful %s. You wouldn't want to get squashed.",
            ATTACKER = "You're letting the spider part take over.",
            MURDERER = "Just another killer spider.",
            REVIVER = "Ew, don't let your fur touch me next time.",
            GHOST = "Why don't the other spiders turn into ghosts?",
            FIRESTARTER = "You're too young to play with fire!",
        },
        WATHGRITHR =
        {
            GENERIC = "You need some more singing lessons, %s",
            ATTACKER = "This isn't a play!",
            MURDERER = "%s is taking acting too far!",
            REVIVER = "%s can do more than hurt things, how nice.",
            GHOST = "Look, %s's playing dead! HAH!",
            FIRESTARTER = "Just don't go burning people.",
        },
        WINONA =
        {
            GENERIC = "Oh, it's %s. You kinda remind me of my mom.",
            ATTACKER = "More brawn than brain, huh %s?",
            MURDERER = "This is what work related stress does to a person!",
            REVIVER = "%s knows a valuable asset when she sees one.",
            GHOST = "The only thing %s's producing now is ectoplasm.",
            FIRESTARTER = "%s is into demolition too!",
        },
        WORTOX =
        {
            GENERIC = "Don't go playing any tricks, %s!",
            ATTACKER = "%s always looked shifty.",
            MURDERER = "I knew %s was a monster!",
            REVIVER = "Thanks, soul eater.",
            GHOST = "So much for 'going where you please'.",
            FIRESTARTER = "Burning things? What a creative prank.",
        },
        WORMWOOD =
        {
            GENERIC = "Should I speak slowly, %s?",
            ATTACKER = "Harming people is a bad way to make friends.",
            MURDERER = "Don't you know what death is, twig for brains?",
            REVIVER = "Don't think this makes us friends, hollow-head.",
            GHOST = "Pushing daisies again twig for brains?",
            FIRESTARTER = "%s learned what fire does.",
        },
        WARLY =
        {
            GENERIC = "Keep the snacks coming, %s!",
            ATTACKER = "Trying to keep all the food to yourself, %s?",
            MURDERER = "This is what starvation does to a person.",
            REVIVER = "Glad to be alive, but I could go for a snack.",
            GHOST = "Did one of your recipes finally blow up in your face?",
            FIRESTARTER = "%s likes his trees charbroiled.",
        },

        WURT =
        {
            GENERIC = "Eat any good books lately, %s?",
            ATTACKER = "%s is bloodthirsty!",
            MURDERER = "I'd expect nothing less of the creatures that live here!",
            REVIVER = "I doubt %s smart enough to have done that herself.",
            GHOST = "What, did you walk into a tentacle or something?",
            FIRESTARTER = "God help us, the merms are learning to make fire.",
        },

        WALTER =
        {
            GENERIC = "It's the goodie two shoes, %s.",
            ATTACKER = "And I thought you were a 'nice' guy!",
            MURDERER = "This isn't a horror show, %s!",
            REVIVER = "Was helping ghosts part of your training?",
            GHOST = "I think %s's better like this, a lot less talkative.",
            FIRESTARTER = "Is there a fire un-safety badge, %s?",
        },

        WANDA =
        {
            GENERIC = "I don't really care how it works, %s.",
            ATTACKER = "'Time heals all wounds' is not a justification.",
            MURDERER = "You can't time travel out of this one, %s!",
            REVIVER = "Couldn't you just have time traveled and stopped my death?",
            GHOST = "You can rewind time but couldn't stop yourself from dying?",
            FIRESTARTER = "Maybe you could go back and stop yourself from lighting that fire.",
        },

        WONKEY =
        {
            GENERIC = "Know any tricks?",
            ATTACKER = "Get your hairy hands away from me!",
            MURDERER = "They've gone bananas!",
            REVIVER = "Don't expect any favors for helping me!",
            GHOST = "Too dumb to live.", 
            FIRESTARTER = "Oh no, the apes have discovered fire.",  
        },

        WIXIE =
        {
            GENERIC = "What a jerk.",
            ATTACKER = "Bullying people is my job!",
            MURDERER = "Not even I would go THAT far, %s!",
            REVIVER = "I wouldn't have done the same in your... my shoes?",
            GHOST = "There's only room for one of me around here!",
            FIRESTARTER = "Great minds think alike!",
        },

        MIGRATION_PORTAL =
        {
        --    GENERIC = "If I had any friends, this could take me to them.",
        --    OPEN = "If I step through, will I still be me?",
        --    FULL = "It seems to be popular over there.",
        },
        GLOMMER =
        {
            GENERIC = "I don't want that thing anywhere near me.",
            SLEEPING = "I could sneak away now.",
        },
        GLOMMERFLOWER =
        {
            GENERIC = "It's got a pleasant smell, I get why that thing likes it.",
            DEAD = "Not so pleasant anymore.",
        },
        GLOMMERWINGS = "I always dreamt of flying, but I don't think these will help.",
        GLOMMERFUEL = "Next thing that insults me gets goop in their face.",
        BELL = "I wonder what happens if I ring it?",
        STATUEGLOMMER =
        {
            GENERIC = "Who made this? And why?",
            EMPTY = "I broke it. Because I wanted to.",
        },

        LAVA_POND_ROCK = "A crusty old rock.",

		WEBBERSKULL = "I'm surprised a spider could eat someone whole.",
		WORMLIGHT = "Looks juicy.",
		WORMLIGHT_LESSER = "Seems a bit dried out.",
		WORM =
		{
		    PLANT = "Let's stomp on it!",
		    DIRT = "Did that dirt just move?",
		    WORM = "It's going to stomp US!",
		},
        WORMLIGHT_PLANT = "Let's stomp on it!",
		MOLE =
		{
			HELD = "I don't want its dirty claws on me!",
			UNDERGROUND = "How could something live underground like that?",
			ABOVEGROUND = "Needed some fresh air? Me too.",
		},
		MOLEHILL = "I have no desire to jump in.",
		MOLEHAT = "It's a bit stuffy in there.",

		EEL = "I can't imagine living in a filthy pond.",
		EEL_COOKED = "I think if cooked off most of the grime.",
		UNAGI = "Huh, never heard of this kind of food before.",
		EYETURRET = "I don't like being stared at.",
		EYETURRET_ITEM = "I need to find a nice, open space to put it.",
		MINOTAURHORN = "It's not trying to kill me anymore, thankfully.",
		MINOTAURCHEST = "What goodies has it left for me?",
		THULECITE_PIECES = "Someone smashed it to pieces!",
		POND_ALGAE = "It's slimey and gross.",
		GREENSTAFF = "Takes the fun out of breaking things.",
		GIFT = "I don't think it's mine, but I'll still take it.",
        GIFTWRAP = "I could wrap up some spiders, or some glommer goop.",
		POTTEDFERN = "Should we pick a pack of purple plants?",
        SUCCULENT_POTTED = "It needs more room to spread out.",
		SUCCULENT_PLANT = "It's found a nice water source.",
		SUCCULENT_PICKED = "It weighs more than you'd think.",
		SENTRYWARD = "Perfect for spying.",
        TOWNPORTAL =
        {
			GENERIC = "I don't mind walking, but a quicker trip could be nice.",
			ACTIVE = "Alright, show me what you've got!",
		},
        TOWNPORTALTALISMAN =
        {
			GENERIC = "This could make some good slinging material.",
			ACTIVE = "I'd rather shoot it!",
		},
        WETPAPER = "Would make a good spit ball.",
        WETPOUCH = "Won't hold much when wet.",
        MOONROCK_PIECES = "More rocks. Fun.",
        MOONBASE =
        {
            GENERIC = "Huh, there's a hole. For something.",
            BROKEN = "Smashed up.",
            STAFFED = "I think that's right? Maybe something else is needed.",
            WRONGSTAFF = "I can't jam that in there.",
            MOONSTAFF = "Oh, huh, neat.",
        },
        MOONDIAL =
        {
			GENERIC = "Oh, neat, the moon.",
			NIGHT_NEW = "Where'd the moon go?",
			NIGHT_WAX = "The moon is hiding.",
			NIGHT_FULL = "The moon is just showing off.",
			NIGHT_WANE = "Goodbye moon.",
			CAVE = "It's a CAVE. There's no moon down here.",
--fallback to speech_wilson.lua 			WEREBEAVER = "only_used_by_woodie", --woodie specific
			GLASSED = "Is that how glass is made?",
        },
		THULECITE = "Old spooky rocks.",
		ARMORRUINS = "It's lightweight, but I still don't like it.",
		ARMORSKELETON = "How are dusty old bones supposed to protect me?",
		SKELETONHAT = "Glad he was thick headed!",
		RUINS_BAT = "Batter up!",
		RUINSHAT = "Makes me feel important, because I am!",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "It's uh, just a fancy rock.",
            WARN = "Huh, it's changing.",
            WAXING = "Troubles brewing!",
            STEADY = "Were all in trouble!",
            WANING = "The monsters are starting to run away.",
            DAWN = "Everything is starting to calm down!",
            NOMAGIC = "Back to normal. Relatively speaking...",
		},
		BISHOP_NIGHTMARE = "You are what you preach.",
		ROOK_NIGHTMARE = "The castle is falling apart!",
		KNIGHT_NIGHTMARE = "Its got goop in it's gears.",
		MINOTAUR = "What's the matter? Can't find your way out of the maze?",
		SPIDER_DROPPER = "Go crawl back where you came from!",
		NIGHTMARELIGHT = "Who knew you could make light out of shadows?",
		NIGHTSTICK = "It makes for a good night light. Not that I need one...",
		GREENGEM = "It's green, but not very mean.",
		MULTITOOL_AXE_PICKAXE = "Seems too fancy for such mundane tasks.",
		ORANGESTAFF = "Perfect for when I don't feel like shoving people.",
		YELLOWAMULET = "Practical jewelry? Now this I can get behind!",
		GREENAMULET = "Seems like cheating, and that's fine by me!",
		SLURPERPELT = "It was ninety percent pelt",

		SLURPER = "You'll let flies in if you don't shut your mouth!",
		SLURPER_PELT = "It was ninety percent skin",
		ARMORSLURPER = "I could also just tighten my belt a notch.",
		ORANGEAMULET = "I don't mind letting others do the work for me.",
		YELLOWSTAFF = "I'm the star around here!",
		YELLOWGEM = "It's bright... Annoyingly bright.",
		ORANGEGEM = "You can't rhyme it with anything.",
        OPALSTAFF = "Cool staff!",
        OPALPRECIOUSGEM = "Looking at it gives me a migraine.",
        TELEBASE =
		{
			VALID = "Looks good.",
			GEMS = "Maybe a few more of those purple gems would work?",
		},
		GEMSOCKET =
		{
			VALID = "Crammed it in there.",
			GEMS = "Need a gem to cram in this thing.",
		},
		STAFFLIGHT = "A light bulb would have worked just fine.",
        STAFFCOLDLIGHT = "What kind of light acts like a refrigerator?",

        ANCIENT_ALTAR = "Mom told me not to talk to strangers, especially dead ones.",

        ANCIENT_ALTAR_BROKEN = "What was that? Speak up!",

        ANCIENT_STATUE = "What a creep.",

        LICHEN = "I just want to know if you can eat it.",
		CUTLICHEN = "Only one way to find out.",

		CAVE_BANANA = "Now, who can I get to slip on the peel...",
		CAVE_BANANA_COOKED = "It's just mush. Maybe I could throw it at someone?",
		CAVE_BANANA_TREE = "I thought these only grew in the tropics! What a rip off!",
		ROCKY = "Thick skin? We'll see about that.",

		COMPASS =
		{
			GENERIC= "Magnets, I think.",
			N = "Never.",
			S = "Sour.",
			E = "Eat.",
			W = "Wheat.",
			NE = "Never Eat? Well that's just bad advice...",
			SE = "Sour Eat? What?",
			NW = "Never Wheat? ...I'll try?",
			SW = "Sour Wheat. Gross.",
		},

        HOUNDSTOOTH = "Ha! Knocked its tooth out!",
        ARMORSNURTLESHELL = "I am NOT hiding in that thing.",
        BAT = "Fly away, guano for brains.",
        BATBAT = "One step closer to flight!",
        BATWING = "It's too small to lift me off the ground.",
        BATWING_COOKED = "It's definitely not going to help me fly.",
        BATCAVE = "I'm not about to check whats hiding in there.",
        BEDROLL_FURRY = "It's almost like having a real bed again!",
        BUNNYMAN = "I'm gonna call you \"Bucky\".",
        FLOWER_CAVE = "Light my way, jerks!",
        GUANO = "How barbaric.",
        LANTERN = "Nice and reliable.",
        LIGHTBULB = "It's mine now.",
        MANRABBIT_TAIL = "Got your tail! Ha-ha!",
        MUSHROOMHAT = "It's got that gross mushroom smell, puts my appetite off.",
        MUSHROOM_LIGHT2 =
        {
            ON = "This... wasn't worth all the effort.",
            OFF = "Can I smash it now?",
            BURNT = "Oh no. What a shame.",
        },
        MUSHROOM_LIGHT =
        {
            ON = "I'll try not to break this one.",
            OFF = "So... is it just... decorative?",
            BURNT = "I tried, I promise!",
        },
        SLEEPBOMB = "Call me Ms. Sandman!",
        MUSHROOMBOMB = "That mushroom is going to blow!",
        SHROOM_SKIN = "It's icky and slimy.",
        TOADSTOOL_CAP =
        {
            EMPTY = "It's just a hole.",
            INGROUND = "Come out where I can see you!",
            GENERIC = "Oh, it's just a big mushroom.",
        },
        TOADSTOOL =
        {
            GENERIC = "Ha-ha! Look at its fat little legs!",
            RAGE = "Aww, did I make you mad?",
        },
        MUSHROOMSPROUT =
        {
            GENERIC = "That fat frog really likes these.",
            BURNT = "Ha-ha! Now it's gone!",
        },
        MUSHTREE_TALL =
        {
            GENERIC = "They kinda look like drum cymbals.",
            BLOOM = "Someone's been drumming too hard.",
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "It's a weird conjoined mushroom.",
            BLOOM = "Is this some kinda threat? Are you threatening me?!",
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "Hey there stumpy.",
            BLOOM = "Your bloomers are showing.", -- these mushtree lines are some of my favorites :)
        },
        MUSHTREE_TALL_WEBBED = "Why would anyone want to live in a mushroom?",
        SPORE_TALL =
        {
            GENERIC = "You better not go up my nose.",
            HELD = "Nowhere left to float!",
        },
        SPORE_MEDIUM =
        {
            GENERIC = "You better not go up my nose.",
            HELD = "Nowhere left to float!",
        },
        SPORE_SMALL =
        {
            GENERIC = "You better not go up my nose.",
            HELD = "Nowhere left to float!",
        },
        RABBITHOUSE =
        {
            GENERIC = "I'm going to take a bite out of it!",
            BURNT = "I just wanted to cook it.",
        },
        SLURTLE = "You'd go a lot faster if you ditched the shell.",
        SLURTLE_SHELLPIECES = "I smashed it.",
        SLURTLEHAT = "I'd rather kick it around than wear it.",
        SLURTLEHOLE = "I christen thee 'Fort Crusty'.", --yes im proud of this one :)
        SLURTLESLIME = "Maybe I could hide it in someones sleeping bag.",
        SNURTLE = "You'd go a lot faster if you ditched the shell.",
        SPIDER_HIDER = "Quit hiding!",
        SPIDER_SPITTER = "Spit at me? I'll spit at you!",
        SPIDERHOLE = "Why does their house need to be creepy too?",
        SPIDERHOLE_ROCK = "Why does their house need to be creepy too?",
        STALAGMITE = "Someones been growing rocks around here.",
        STALAGMITE_TALL = "Someones been growing rocks around here.",

        TURF_CARPETFLOOR = "Roll it out for me!",
        TURF_CHECKERFLOOR = "Huh, kinda reminds me of a ballroom.",
        TURF_DIRT = "A clump of dirt.",
        TURF_FOREST = "A clump of dirt.",
        TURF_GRASS = "A bunch of grass.",
        TURF_MARSH = "A clump of dirt.",
        TURF_METEOR = "A clump of dirt.",
        TURF_PEBBLEBEACH = "A clump of dirt.",
        TURF_ROAD = "It's my road, and no one elses.",
        TURF_ROCKY = "A clump of rocks.",
        TURF_SAVANNA = "A bunch of grass.",
        TURF_WOODFLOOR = "Not as creaky as my houses floorboards.",

		TURF_CAVE= "A clump of dank dirt.",
		TURF_FUNGUS= "A clump of dirt.",
		TURF_FUNGUS_MOON = "A clump of dirt.",
		TURF_ARCHIVE = "A clump of dirt.",
		TURF_SINKHOLE= "A clump of dirt.",
		TURF_UNDERROCK= "A clump of dirt.",
		TURF_MUD= "A clump of dirt.",

		TURF_DECIDUOUS = "A clump of dirt.",
		TURF_SANDY = "A clump of sand.",
		TURF_BADLANDS = "A clump of dirt.",
		TURF_DESERTDIRT = "A clump of dirt.",
		TURF_FUNGUS_GREEN = "A clump of dirt.",
		TURF_FUNGUS_RED = "A clump of dirt.",
		TURF_DRAGONFLY = "Fireproof scales.",

        TURF_SHELLBEACH = "I hate sand.",

		TURF_RUINSBRICK = "A clump of very old dirt.",
		TURF_RUINSBRICK_GLOW = "A clump of very old dirt.",
		TURF_RUINSTILES = "A clump of very old dirt.",
		TURF_RUINSTILES_GLOW = "A clump of very old dirt.",
		TURF_RUINSTRIM = "A clump of very old dirt.",
		TURF_RUINSTRIM_GLOW = "A clump of very old dirt.",

        TURF_MONKEY_GROUND = "I hate sand.",

        TURF_CARPETFLOOR2 = "Ugh, I HATE Opera!",
        TURF_MOSAIC_GREY = "A clump of dirt.",
        TURF_MOSAIC_RED = "A clump of dirt.",
        TURF_MOSAIC_BLUE = "A clump of dirt.",
		
        TURF_BEARD_RUG = "Gross.",

		POWCAKE = "I love sweets as much as the next person, but this might stop my heart.",
        CAVE_ENTRANCE = "Smash the rock!",
        CAVE_ENTRANCE_RUINS = "This rock is asking to be smashed!",

       	CAVE_ENTRANCE_OPEN =
        {
            GENERIC = "I didn't want to go anyways!",
            OPEN = "I'm not sure about this...",
            FULL = "Sounds like a party down there. I'll just keep my distance.",
        },
        CAVE_EXIT =
        {
            GENERIC = "I hate feeling trapped.",
            OPEN = "Can we go? Please?",
            FULL = "Oh come on, clear out already!",
        },

		MAXWELLPHONOGRAPH = "As nice as it is, this doesn't beat a live preformance.",--single player
		BOOMERANG = "It knows who the boss is!",
		PIGGUARD = "This guy needs an attitude adjustment.",
		ABIGAIL =
		{
            LEVEL1 =
            {
                "You're almost as creepy as your sister!",
                "You're almost as creepy as your sister!",
            },
            LEVEL2 =
            {
                "You're almost as creepy as your sister!",
                "You're almost as creepy as your sister!",
            },
            LEVEL3 =
            {
                "You're almost as creepy as your sister!",
                "You're almost as creepy as your sister!",
            },
		},
		ADVENTURE_PORTAL = "Time to prove I'm better than the rest of you!",
		AMULET = "Who needs a heart?",
		ANIMAL_TRACK = "You can't hide from me!",
		ARMORGRASS = "It's not so bad.",
		ARMORMARBLE = "Why would I want to wear a refrigerator?",
		ARMORWOOD = "It's like being trapped in a box...",
		ARMOR_SANITY = "Feels like... nothing!",
		ASH =
		{
			GENERIC = "Ha-ha!",
			REMAINS_GLOMMERFLOWER = "So much for composting.",
			REMAINS_EYE_BONE = "Ashes to ashes, bones to... ashes.",
			REMAINS_THINGIE = "Something burned, who cares what it was?",
		},
		AXE = "Axe me a question, I dare you!",
		BABYBEEFALO =
		{
			GENERIC = "You're so tiny, and ugly!",
		    SLEEPING = "Rest while you can.",
        },
        BUNDLE = "It's not filled with snakes, I promise.",
        BUNDLEWRAP = "I could wrap up all sorts of nasty things!",
		BACKPACK = "Perfect for hoarding all sorts of things!",
		BACONEGGS = "I like to make a face out of the bacon. Then, I eat that face.",
		BANDAGE = "I'm used to applying these.",
		BASALT = "It's both an immovable object, and a hard place.", --removed
		BEARDHAIR = "I hate this stuff.",
		BEARGER = "All it does is eat and sleep.",
		BEARGERVEST = "So, this is what it's like to be a bear, huh?",
		ICEPACK = "I'd prefer to have snacks in my mouth than in a bag.",
		BEARGER_FUR = "I got a piece of him!",
		BEDROLL_STRAW = "I still prefer this over a tent.",
		BEEQUEEN = "Try fighting me one on one!",
		BEEQUEENHIVE =
		{
			GENERIC = "Creepy.",
			GROWING = "I should stomp on it.",
		},
        BEEQUEENHIVEGROWN = "I've found the mother-lode of honey!",
        BEEGUARD = "Hey, that's no fair!",
        HIVEHAT = "It's perfect for me!",
        MINISIGN =
        {
            GENERIC = "Did I draw that? If not, then it stinks.",
            UNDRAWN = "Let a master show you how it's done!",
        },
        MINISIGN_ITEM = "I could draw all sorts of crude things on this.",
		BEE =
		{
			GENERIC = "I wish I had a stinger...",
			HELD = "The last thing they would expect is a pocket full of bees!",
		},
		BEEBOX =
		{
			READY = "Those guys work way too hard.",
			FULLHONEY = "My teeth are already aching!",
			GENERIC = "How can they stand all that crowding around?",
			NOHONEY = "...Work harder!",
			SOMEHONEY = "More! MORE!!",
			BURNT = "Someone got carried away trying to smoke them out.",
		},
		MUSHROOM_FARM =
		{
			STUFFED = "They look pretty packed in there.",
			LOTS = "Look at all those mushrooms!",
			SOME = "They're sure taking their sweet time...",
			EMPTY = "Why is it called a mushroom planter if I can't plant mushrooms?",
			ROTTEN = "No nutrition for the 'shrooms.",
			BURNT = "Can't mushrooms grow on charcoal?",
			SNOWCOVERED = "What, can't handle the cold?",
		},
		BEEFALO =
		{
			FOLLOWER = "Oh no, it's following me.",
			GENERIC = "Take a bath!",
			NAKED = "Look how sad it looks! Ha-ha!",
			SLEEPING = "Now is the perfect time for a prank!",
            --Domesticated states:
            DOMESTICATED = "Just... don't start slobbering on me, okay?!",
            ORNERY = "You wanna fight or something?",
            RIDER = "Use that speed to get away from me!",
            PUDGY = "Pudgy is right! This guy is huge!",
            MYPARTNER = "Don't get cute with me, you hear?!",
		},

		BEEFALOHAT = "Let's lock horns!",
		BEEFALOWOOL = "It's MY fur now!",
		BEEHAT = "I've got a bee proof shield now!",
        BEESWAX = "Wax-off why dontcha!",
		BEEHIVE = "I wanna kick it!",
		BEEMINE = "Wanna see a funny prank? He-he-he...",
		BEEMINE_MAXWELL = "Great minds think alike, eh Max?",--removed
		BERRIES = "They're red, which means they're good! That's my general rule.",
		BERRIES_COOKED = "If they WERE poisonous, they probably aren't anymore.",
        BERRIES_JUICY = "Atleast they won't stain my jumper!",
        BERRIES_JUICY_COOKED = "They're already starting to stink...",
		BERRYBUSH =
		{
			BARREN = "Finally, an excuse to fertilize!",
			WITHERED = "Too hot? Well, I'm not going to fan you!",
			GENERIC = "I'm going to pick every last berry, they're all mine!",
			PICKED = "Hurry up and make more!",
			DISEASED = "Better not be contagious.",--removed
			DISEASING = "You'd better not be sick.",--removed
			BURNING = "If I can't have the berries, no one can!",
		},
		BERRYBUSH_JUICY =
		{
			BARREN = "Finally, an excuse to fertilize!",
			WITHERED = "Too hot? Well, I'm not going to fan you!",
			GENERIC = "All for me!",
			PICKED = "Hurry up and make more!",
			DISEASED = "Better not be contagious.",--removed
			DISEASING = "You'd better not be sick.",--removed
			BURNING = "If I can't have the berries, no one can!",
		},
		BIGFOOT = "YES! STOMP ALL OVER THEM!!",--removed
		BIRDCAGE =
		{
			GENERIC = "Now I just need a victi- I mean, bird!",
			OCCUPIED = "You're in the slammer, pal!",
			SLEEPING = "I'm tempted to wake them.",
			HUNGRY = "I should probably feed them.",
			STARVING = "Okay, now I feel bad, I should get them food.",
			DEAD = "Oops.",
			SKELETON = "Nothing but bones.",
		},
		BIRDTRAP = "You'd have to be pretty dumb to fall for this.",
		CAVE_BANANA_BURNT = "Whoops...",
		BIRD_EGG = "Egg in the face!",
		BIRD_EGG_COOKED = "Not much fun to throw anymore.",
		BISHOP = "No more sunday school.... forever!",
		BLOWDART_FIRE = "It's not as good as my slingshot, but it'll do the trick.",
		BLOWDART_SLEEP = "It's not as good as my slingshot, but it'll do the trick.",
		BLOWDART_PIPE = "It's not as good as my slingshot, but it'll do the trick.",
		BLOWDART_YELLOW = "It's not as good as my slingshot, but it'll do the trick.",
		BLUEAMULET = "So, it's like an ice cube on a chain?",
		BLUEGEM = "It's got the blues.",
		BLUEPRINT =
		{
            COMMON = "I hate following directions!",
            RARE = "Looks fancy.",
        },
        SKETCH = "This would make a good reference for sculpting.",
		COOKINGRECIPECARD = 
		{
			GENERIC = "Don't tell ME how to cook!",
		},
		BLUE_CAP = "It's blue, but it ain't no blueberry.",
		BLUE_CAP_COOKED = "Still not a blueberry...",
		BLUE_MUSHROOM =
		{
			GENERIC = "I don't trust it.",
			INGROUND = "Hey! Stop hiding!",
			PICKED = "Just a hole.",
		},
		BOARDS = "Just some boring old boards.",
		BONESHARD = "Just some old bones.",
		BONESTEW = "It would be rude not to share.",
		BUGNET = "Now look at this net that I just found!",
		BUSHHAT = "I... I ain't hiding from nothin'!",
		BUTTER = "Oh, there it is!",
		BUTTERFLY =
		{
			GENERIC = "I see the \"fly\" part, but where's the butter?",
			HELD = "Upon closer inspection, it's not made of butter. Liar!",
		},
		BUTTERFLYMUFFIN = "I had to substitute for the lack of butter.",
		BUTTERFLYWINGS = "I'd need a hundred of these things to take flight!",
		BUZZARD = "Buzz off, you freeloader!",

		SHADOWDIGGER = "Oh, the trouble I could get up to with clones...",
        SHADOWDANCER = "Careful not to break a hip.",

		CACTUS =
		{
			GENERIC = "What a prick!",
			PICKED = "Another plant defeated!",
		},
		CACTUS_MEAT_COOKED = "He-he, now it's spineless!",
		CACTUS_MEAT = "I hope it's worth the spines.",
		CACTUS_FLOWER = "How pretty. I want to eat it!",

		COLDFIRE =
		{
			EMBERS = "It's not bedtime yet!",
			GENERIC = "Nothing like a good bonfire.",
			HIGH = "Yes! Burn!",
			LOW = "Needs more fire-food.",
			NORMAL = "Nice and comfy.",
			OUT = "Aww.",
		},
		CAMPFIRE =
		{
			EMBERS = "It's not bedtime yet!",
			GENERIC = "Nothing like a good bonfire.",
			HIGH = "Yes! Burn!",
			LOW = "Needs more fire-food.",
			NORMAL = "Nice and comfy.",
			OUT = "Aww.",
		},
		CANE = "These are for old people!",
		CATCOON = "This is what I pictured being trapped in the wardrobe.",
		CATCOONDEN =
		{
			GENERIC = "Looks like a home for gnomes.",
			EMPTY = "Squatters rights!",
		},
		CATCOONHAT = "Smells like wet fur and pine needles. Yuck.",
		COONTAIL = "It's like a fuzzy snake.",
		CARROT = "What's up, doc?",
		CARROT_COOKED = "I love em!",
		CARROT_PLANTED = "Thanks for the free food, dirt!",
		CARROT_SEEDS = "I hate gardening!",
		CARTOGRAPHYDESK =
		{
			GENERIC = "It's where I like to plan my pranks.",
			BURNING = "No one can reveal my secrets!",
			BURNT = "Plan B: Improvise.",
		},
		WATERMELON_SEEDS = "Don't swallow it!",
		CAVE_FERN = "What do you 'do' exactly?",
		CHARCOAL = "Chalk's expensive, this will have to do.",
        CHESSPIECE_PAWN = "Huh, this doesn't look like any the pawns I've seen.",
        CHESSPIECE_ROOK =
        {
            GENERIC = "That's just inaccurate.",
            STRUGGLE = "Hey look, it's dancing!",
        },
        CHESSPIECE_KNIGHT =
        {
            GENERIC = "It's kinda like the ones on a carousel!",
            STRUGGLE = "Hey look, it's dancing!",
        },
        CHESSPIECE_BISHOP =
        {
            GENERIC = "Looks like a weird fish when you tilt your head sideways.",
            STRUGGLE = "Hey look, it's dancing!",
        },
        CHESSPIECE_MUSE = "Her heads come off!", -- impossible reference :)
        CHESSPIECE_FORMAL = "You can't even wear it!",
        CHESSPIECE_HORNUCOPIA = "Looks like a fuzzy worm having quite a feast.",
        CHESSPIECE_PIPE = "Maybe it's filled with spinach?",
        CHESSPIECE_DEERCLOPS = "I wonder if he would smash it...",
        CHESSPIECE_BEARGER = "Hungry? Too bad! Ha-ha!",
        CHESSPIECE_MOOSEGOOSE =
        {
            "What an idiot.",
        },
        CHESSPIECE_DRAGONFLY = "We could have been friends, in another life.",
		CHESSPIECE_MINOTAUR = "Schnoz-so-scary anymore!", -- i made a funni :)
        CHESSPIECE_BUTTERFLY = "What are YOU smiling about?",
        CHESSPIECE_ANCHOR = "What the heck was the point of making this?!",
        CHESSPIECE_MOON = "Did someone take a bite out of it?",
        CHESSPIECE_CARRAT = "Look at him... sitting there... RELAXING.",
        CHESSPIECE_MALBATROSS = "Ugh, I can almost HEAR it.",
        CHESSPIECE_CRABKING = "Which was a bigger waste of time; Fighting that thing, or making this statue?",
        CHESSPIECE_TOADSTOOL = "Perfectly captures the look on it's face when it died.",
        CHESSPIECE_STALKER = "What was he saying again? Dark powers? A curse? Eh, who cares.",
        CHESSPIECE_KLAUS = "Can I PLEASE just smash it? It's making me feel... bad.",
        CHESSPIECE_BEEQUEEN = "Much more quiet, that's a huge improvement.",
        CHESSPIECE_ANTLION = "Huh, I thought \"You are what you eat\" was just a saying.",
        CHESSPIECE_BEEFALO = "What a dope.",
		CHESSPIECE_KITCOON = "I'm going to knock it over!",
		CHESSPIECE_CATCOON = "Caught red handed!",
        CHESSPIECE_MANRABBIT = "Their smugness irritates me.", -- spelling
        CHESSPIECE_GUARDIANPHASE3 = "A reminder of the time we killed an alien. That was fun.",
        CHESSPIECE_EYEOFTERROR = "It looks shocked. How can an EYEBALL look shocked?",
        CHESSPIECE_TWINSOFTERROR = "Boy, am I sure glad I don't have a whiney sibling!",

        CHESSJUNK1 = "I don't trust it, maybe I should keep my distance...",
        CHESSJUNK2 = "I don't trust it, maybe I should keep my distance...",
        CHESSJUNK3 = "I don't trust it, maybe I should keep my distance...",
		CHESTER = "Keep away from me you mangy mutt!",
		CHESTER_EYEBONE =
		{
			GENERIC = "I can't beat it in a staring contest.",
			WAITING = "Ha-ha! You lost!",
		},
		COOKEDMANDRAKE = "Well, at least it's not making noise anymore.",
		COOKEDMEAT = "Please, don't kiss the chef.",
		COOKEDMONSTERMEAT = "I've heard pink is good, maybe purple is better?",
		COOKEDSMALLMEAT = "Just a bite to eat. Literally.",
		COOKPOT =
		{
			COOKING_LONG = "Can't I just turn the heat up? This is taking forever!",
			COOKING_SHORT = "Hurry up already!",
			DONE = "I call dibs! It's mine!",
			EMPTY = "What's cookin'? Oh, it's nothing.",
			BURNT = "I meant to do that. It's an acquired taste.",
		},
		CORN = "I hate corn.",
		CORN_COOKED = "It's corn, but good!",
		CORN_SEEDS = "I hate gardening!",
        CANARY =
		{
			GENERIC = "Sing me a song, little bird.",
			HELD = "Peck me, I dare you! See what happens!",
		},
        CANARY_POISONED = "A bomb!",

		CRITTERLAB = "More critters? In a cramped space? No thank you.",
        CRITTER_GLOMLING = "Why is this creep following me?",
        CRITTER_DRAGONLING = "Stop spitting on everything, thats my job!",
		CRITTER_LAMB = "Your coat is itchy, I hate it.",
        CRITTER_PUPPY = "Quit slobbering on me!",
        CRITTER_KITTEN = "Another straw, there's a lot of you back home.",
        CRITTER_PERDLING = "Get lost, pip-squawk!",
		CRITTER_LUNARMOTHLING = "This one has GOT to be the most useless!",

		CROW =
		{
			GENERIC = "Quit gawking and squawking.",
			HELD = "Don't pick my pockets while you're in there!",
		},
		CUTGRASS = "Good thing I'm not worried about grass stains.",
		CUTREEDS = "I'm sure I'll find a use for it.",
		CUTSTONE = "I'll knock your block off!",
		DEADLYFEAST = "That... that's just death.", --unimplemented
		DEER =
		{
			GENERIC = "Watch where you're walking!",
			ANTLER = "Nice antler! I want it.",
		},
        DEER_ANTLER = "I got it! ...Now what?",
        DEER_GEMMED = "Would I get super powers if I stuck a gem in my forehead?",
		DEERCLOPS = "That guy is such a bully! ...That's my job!",
		DEERCLOPS_EYEBALL = "I popped his eye out!",
		EYEBRELLAHAT =	"Warn me if you see any dive bombers.",
		DEPLETED_GRASS =
		{
			GENERIC = "I've got better things to do than watch grass grow.",
		},
        GOGGLESHAT = "It sits on my head and does *what* exactly?",
        DESERTHAT = "I'd prefer my peripheral vision.",
        ANTLIONHAT = "She better not have layed eggs in it.",
		DEVTOOL = "Let's make trouble.",
		DEVTOOL_NODEV = "Hey! Stop blocking me!",
		DIRTPILE = "It calls to me, it says \"Kick Me\".",
		DIVININGROD =
		{
			COLD = "The signal sucks!", --singleplayer
			GENERIC = "We used to have a radio, but mom got rid of it when...", --singleplayer
			HOT = "Where's the volume knob on this thing?", --singleplayer
			WARM = "Loud and clear.", --singleplayer
			WARMER = "Doesn't sound like a song...", --singleplayer
		},
		DIVININGRODBASE =
		{
			GENERIC = "Looks evil.", --singleplayer
			READY = "There's a hole in the middle. Hmm.", --singleplayer
			UNLOCKED = "I think that did the trick!", --singleplayer
		},
		DIVININGRODSTART = "Radio... What's going on with that radio?", --singleplayer
		DRAGONFLY = "Cool spot you got here...",
		ARMORDRAGONFLY = "Now I've got your power!",
		DRAGON_SCALES = "I wasn't scaled for a minute!",
		DRAGONFLYCHEST = "Fancy looking boxes have the best stuff.",
		DRAGONFLYFURNACE =
		{
			HAMMERED = "I wrecked it! Woo!",
			GENERIC = "I'd prefer a fire.", --no gems
			NORMAL = "Toasty!", --one gem
			HIGH = "Roasty!", --two gems
		},

        HUTCH = "Ew! What do you want you creep?",
        HUTCH_FISHBOWL =
        {
            GENERIC = "I'd sure hate to be that fish.",
            WAITING = "They couldn't take the stress. You and me both...",
        },
		LAVASPIT =
		{
			HOT = "Nice loogie!",
			COOL = "Aw.",
		},
		LAVA_POND = "Is this her spittoon?",
		LAVAE = "Why can't it ever be a fair fight!",
		LAVAE_COCOON = "Stomp it!",
		LAVAE_PET =
		{
			STARVING = "Quite whining!",
			HUNGRY = "Don't beg.",
			CONTENT = "There, are you happy now?",
			GENERIC = "It's creepy, and crawly.",
		},
		LAVAE_EGG =
		{
			GENERIC = "Is it too late to make omelettes?",
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "No one likes cold eggs.",
			COMFY = "I can't tell if it's cooking or not.",
		},
		LAVAE_TOOTH = "It's pretty spiffy... I just wish that thing would stop following it.",

		DRAGONFRUIT = "What treasure are you guarding?",
		DRAGONFRUIT_COOKED = "Not so fireproof, huh?",
		DRAGONFRUIT_SEEDS = "I hate gardening!",
		DRAGONPIE = "But would a dragon eat it?",
		DRUMSTICK = "No one should be drumming with these.",
		DRUMSTICK_COOKED = "I think it's safe to eat now.",
		DUG_BERRYBUSH = "You picked an inconvenient spot to grow, so I'm moving you.",
		DUG_BERRYBUSH_JUICY = "You picked an inconvenient spot to grow, so I'm moving you.",
		DUG_GRASS = "You picked an inconvenient spot to grow, so I'm moving you.",
		DUG_MARSH_BUSH = "You picked an inconvenient spot to grow, so I'm moving you.",
		DUG_SAPLING = "You picked an inconvenient spot to grow, so I'm moving you.",
		DURIAN = "Would make a good stink bomb!",
		DURIAN_COOKED = "Yum, roasted gym socks.",
		DURIAN_SEEDS = "I hate gardening!",
		EARMUFFSHAT = "Atleast it doesn't mess up my bow!",
		EGGPLANT = "I could go for a good eggplant parmesan right about now.", -- check spelling
		EGGPLANT_COOKED = "It's definitely my favorite vegetable!",
		EGGPLANT_SEEDS = "I hate gardening!",

		ENDTABLE =
		{
			BURNT = "That's how forest fires get started!",
			GENERIC = "Why so fancy?",
			EMPTY = "Come out, coward!",
			WILTED = "Ol' dead flowers.",
			FRESHLIGHT = "And then there was light!",
			OLDLIGHT = "How many of you dolts does it take to change a lightbulb?", -- will be wilted soon, light radius will be very small at this point
		},
		DECIDUOUSTREE =
		{
			BURNING = "Someone likes their trees well done.",
			BURNT = "Crispy.",
			CHOPPED = "Hey, shorty!",
			POISON = "The trees have eyes!",
			GENERIC = "How do you pronounce deciduous?",
		},
		ACORN = "Let's crack it!",
        ACORN_SAPLING = "It's growing a snack tree.",
		ACORN_COOKED = "Festive.",
		BIRCHNUTDRAKE = "I'm just glad I don't have a younger sibling.",
		EVERGREEN =
		{
			BURNING = "Someone likes their trees well done.",
			BURNT = "Crispy.",
			CHOPPED = "Hey, shorty!",
			GENERIC = "I bet I could climb it. If I wanted to...",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "Someone likes their trees well done.",
			BURNT = "Crispy.",
			CHOPPED = "Hey, shorty!",
			GENERIC = "This tree is a wimp!",
		},
		TWIGGYTREE =
		{
			BURNING = "Someone likes their trees well done.",
			BURNT = "Crispy.",
			CHOPPED = "Hey, shorty!",
			GENERIC = "Twiggy.",
			DISEASED = "Hope it's not contagious.", --unimplemented
		},
		TWIGGY_NUT_SAPLING = "Time to branch out!",
        TWIGGY_OLD = "It's a grandma tree now.",
		TWIGGY_NUT = "Doesn't taste good. I'll just plant it instead...",
		EYEPLANT = "Take a picture, it will last longer!",
		INSPECTSELF = "No one messes with me!",
		FARMPLOT =
		{
			GENERIC = "Gardening? No thanks.",
			GROWING = "I don't want to take care of it!",
			NEEDSFERTILIZER = "I HATE responsibility.",
			BURNT = "No more garden, no more gardening!",
		},
		FEATHERHAT = "Now I can blend in with the birds.",
		FEATHER_CROW = "Birds of a feather...",
		FEATHER_ROBIN = "I robbed the robin!",
		FEATHER_ROBIN_WINTER = "Birds of a feather...",
		FEATHER_CANARY = "It makes my fingers tingle.",
		FEATHERPENCIL = "Now I just need a sleeping victim to draw on.",
        COOKBOOK = "This takes all the fun out of cooking!",
		FEM_PUPPET = "Hey, that's MY throne!", --single player
		FIREFLIES =
		{
			GENERIC = "Hey! Don't run away from me!",
			HELD = "Can't escape now!",
		},
		FIREHOUND = "Gonna turn you into hot dogs!",
		FIREPIT =
		{
			EMBERS = "It's gonna go out!",
			GENERIC = "Light of my life!",
			HIGH = "Now THAT'S a good fire!",
			LOW = "It's a wimpy little fire.",
			NORMAL = "Let there be light! Or life. I forget which.",
			OUT = "Let's get a bonfire going!",
		},
		COLDFIREPIT =
		{
			EMBERS = "It's gonna go out!",
			GENERIC = "Light of my life!",
			HIGH = "Now THATS a good fire!",
			LOW = "It's a wimpy little fire.",
			NORMAL = "It's a perfectly normal... cold... fire...",
			OUT = "Let's get a bonfire going!",
		},
		FIRESTAFF = "F stands for Fire, and Fun!",
		FIRESUPPRESSOR =
		{
			ON = "Now, how do I get it to target the others...",
			OFF = "The ultimate in snowball fight technology.",
			LOWFUEL = "It's chugging along.",
		},

		FISH = "You're mine now!",
		FISHINGROD = "I don't even have to bait it, those dumb fish still fall for it!",
		FISHSTICKS = "I love finger food!",
		FISHTACOS = "I wouldn't trust fish from a food cart, but this looks okay.",
		FISH_COOKED = "This fish is FRIED!",
		FLINT = "Probably not good slinging material.",
		FLOWER =
		{
            GENERIC = "Should I smell them or stomp them? Decisions, decisions...",
            ROSE = "Careful, they fight back.",
        },
        FLOWER_WITHERED = "You died as you lived. Smelly.",
		FLOWERHAT = "Fit for a princess!",
		FLOWER_EVIL = "Are you trying to show me up?",
		FOLIAGE = "Barely even a salad.",
		FOOTBALLHAT = "People know better than to crowd me when I've got the ball!",
        FOSSIL_PIECE = "These bones are extra dusty.",
        FOSSIL_STALKER =
        {
			GENERIC = "Hm, something just isn't right. What's missing?",
			FUNNY = "That looks too ridiculous to have existed!",
			COMPLETE = "That look good. Silly, but good.",
        },
        STALKER = "You're nothing, you ol' bag of bones!",
        STALKER_ATRIUM = "No one tells ME what to do! Let's take this guy down!",
        STALKER_MINION = "Where's a can of bug spray when you need it?!",
        THURIBLE = "What the heck is this thing burning?",
        ATRIUM_OVERGROWTH = "Can someone translate?",
		FROG =
		{
			DEAD = "See ya.",
			GENERIC = "Hop along, slimey.",
			SLEEPING = "Perfect time for a sneak attack!",
		},
		FROGGLEBUNWICH = "At least the breads looks good.",
		FROGLEGS = "It was mean and green. Now it's dead.", -- :)
		FROGLEGS_COOKED = "And now it's cooked.",
		FRUITMEDLEY = "It's a good pick-me-up!",
		FURTUFT = "What the heck could I use this for?",
		GEARS = "Those clockworks really grind my gears.", --PEETAH
		GHOST = "Quit moaning you whiner!",
		GOLDENAXE = "Makes a nice last impression. He-he-he.",
		GOLDENPICKAXE = "I'll use their minerals against them!",
		GOLDENPITCHFORK = "I'm sure the dirt will be impressed.",
		GOLDENSHOVEL = "Digging for buried treasure, with treasure!",
		GOLDNUGGET = "I'd prefer food.",
		GRASS =
		{
			BARREN = "Finally, an excuse to fertilize!",
			WITHERED = "Too hot? Well, I'm not going to fan you!",
			BURNING = "That burns up nicely!",
			GENERIC = "It's grass. You can find it outdoors.",
			PICKED = "Ripped up, ripped off!",
			DISEASED = "Better not be contagious.",--removed
			DISEASING = "You better not be sick.",--removed
		},
		GRASSGEKKO =
		{
			GENERIC = "Great Gonko! I mean, Gecko!",
			DISEASED = "It's probably not hayfever.", --unimplemented
		},
		GREEN_CAP = "Looks like candy!", --kids dont try this at home :)
		GREEN_CAP_COOKED = "Yum!",
		GREEN_MUSHROOM =
		{
			GENERIC = "Looks delicious.",
			INGROUND = "Hey! Come out of there so I can eat you!",
			PICKED = "I want more!",
		},
		GUNPOWDER = "How far am I willing to go for a prank?",
		HAMBAT = "Fake them out with a snack, it's perfect!",
		HAMMER = "Yeah! Smash em up!", -- :)
		HEALINGSALVE = "Good for some cuts and bruises.",
		HEATROCK =
		{
			FROZEN = "What? No... it's totally a snowball!", -- :)
			COLD = "Chilly.",
			GENERIC = "That's a nice rock.",
			WARM = "It's comfy on a cold night.",
			HOT = "Hot potato, hot potato!",
		},
		HOME = "Hey! Hello?! Let me in!",
		HOMESIGN =
		{
			GENERIC = "No losers allowed!",
            UNWRITTEN = "Graffiti time!",
			BURNT = "It probably wasn't important.",
		},
		ARROWSIGN_POST =
		{
			GENERIC = "I won't fall for that one!",
            UNWRITTEN = "I could write on it and trick someone!",
			BURNT = "This way to the bonfire?", -- :)
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "I won't fall for that one!",
            UNWRITTEN = "I could write on it and trick someone!",
			BURNT = "Maybe it was a fire warning.",
		},
		HONEY = "I'm going to get it all over my slingshot!",
		HONEYCOMB = "It's neither honey, nor comb.",
		HONEYHAM = "Delicious, and festive.",
		HONEYNUGGETS = "I'm double dipping, and you can't stop me!", -- :)
		HORN = "Perfect for a lil' devil like me.",
		HOUND = "You're barking up the wrong tree!",
		HOUNDCORPSE =
		{
			GENERIC = "He's DOG tired.", -- :)
			BURNING = "Just to be safe.",
			REVIVING = "It's alive!",
		},
		HOUNDBONE = "I'm bad to the bone!",
		HOUNDMOUND = "Nothing but hound dogs in there.",
		ICEBOX = "This is where my food goes.",
		ICEHAT = "Hey, I'm not the block head around here!",
		ICEHOUND = "Cool off, jerk!",
		INSANITYROCK =
		{
			ACTIVE = "It's making my head hurt.",
			INACTIVE = "A weird shaped rock.",
		},
		JAMMYPRESERVES = "It's just mashed berries, nothing to it.",

		KABOBS = "The food has been impaled!", -- spelling
		KILLERBEE =
		{
			GENERIC = "How can something so small be a killer?",
			HELD = "What're you going to do now, killer?",
		},
		KNIGHT = "Oh come on, just one piggyback ride!",
		KOALEFANT_SUMMER = "A big snotty baby.",
		KOALEFANT_WINTER = "Looks like someone's packed on the blubber!",
		KRAMPUS = "I don't believe in Karma!",
		KRAMPUS_SACK = "If Karma exists, then how did I get so lucky?",
		LEIF = "I'll chop you like the rest, pines for brains!",
		LEIF_SPARSE = "I'll chop you like the rest, leafs for brains!",
		LIGHTER  = "Fire is a lot less fun when it's so convenient.",
		LIGHTNING_ROD =
		{
			CHARGED = "I command you, lightning!",
			GENERIC = "Go ahead, just TRY and strike me down!",
		},
		LIGHTNINGGOAT =
		{
			GENERIC = "I've got this goat!",
			CHARGED = "Now this goat's trying to get ME!",
		},
		LIGHTNINGGOATHORN = "They didn't need it, anyways.",
		GOATMILK = "Who knew milk could be exciting?",
		LITTLE_WALRUS = "A pint sized pipsqueak!",
		LIVINGLOG = "Tell me your secrets, spooky log.",
		LOG =
		{
			BURNING = "Burns about how you'd expect.",
			GENERIC = "Fuel for a fire!",
		},
		LUCY = "She's loud and annoying.",
		LUREPLANT = "Oh, a prankster huh?",
		LUREPLANTBULB = "No more pranks for you!",
		MALE_PUPPET = "Hey, that's MY throne!", --single player

		MANDRAKE_ACTIVE = "Put it back! Put it back!!",
		MANDRAKE_PLANTED = "Some kind of root? I want it!",
		MANDRAKE = "No more screaming!",

        MANDRAKESOUP = "It's chilling out, having some 'me' time.",
        MANDRAKE_COOKED = "Feels kinda weird to take a bite.",
        MAPSCROLL = "This isn't a map, it's just a bland piece of paper!",
        MARBLE = "The perfect slinging material.",
        MARBLEBEAN = "This will work, trust me.",
        MARBLEBEAN_SAPLING = "I told you it would grow!",
        MARBLESHRUB = "Just a little bit of marble.",
        MARBLEPILLAR = "Looks fancy. Let's smash it!",
        MARBLETREE = "The marble is bountiful this time of year.", -- :)
        MARSH_BUSH =
        {
			BURNT = "It wasn't very useful anyways.",
            BURNING = "No poking for you.",
            GENERIC = "Don't poke me.",
            PICKED = "I told you not to poke me!",
        },
        BURNT_MARSH_BUSH = "It wasn't very useful anyways.",
        MARSH_PLANT = "Just some useless greens.",
        MARSH_TREE =
        {
            BURNING = "Goodbye, tree.",
            BURNT = "It's better this way.",
            CHOPPED = "Not much firewood in this tree.",
            GENERIC = "It's mostly just spines.",
        },
        MAXWELL = "Hey! Get back here you jerk!",--single player
        MAXWELLHEAD = "Ha-ha! You gonna squash me with your BIG HEAD?",--removed
        MAXWELLLIGHT = "It lights my way, it knows I'm important!",--single player
        MAXWELLLOCK = "There's a hole in the middle.",--single player
        MAXWELLTHRONE = "A perfect throne for me!",--single player
        MEAT = "It may look tasty, but you shouldn't eat it.",
        MEATBALLS = "Boring!",
        MEATRACK =
        {
            DONE = "Now you're a jerk!",
            DRYING = "It's begun the process of becoming a jerk.",
            DRYINGINRAIN = "It can't dry in the rain!",
            GENERIC = "For making a jerk extra jerky!",
            BURNT = "Whose the jerk who burnt it?",
            DONE_NOTMEAT = "It's a jerk, no more, no less.",
            DRYING_NOTMEAT = "It's begun the process of becoming a jerk.",
            DRYINGINRAIN_NOTMEAT = "It can't dry in the rain!",
        },
        MEAT_DRIED = "What a jerk!",
        MERM = "Ha-ha! Cross-eyes!",
        MERMHEAD =
        {
            GENERIC = "A little too barbaric for me.",
            BURNT = "Was it burnt in some kind of ritual?",
        },
        MERMHOUSE =
        {
            GENERIC = "I hate communal homes...", -- spelling
            BURNT = "Well, it's not much of a home anymore.",
        },
        MINERHAT = "I'm a bright minded individual!",
        MONKEY = "You better not give me monkeynucleosis.",
        MONKEYBARREL = "It's where they live, of course.",
        MONSTERLASAGNA = "Looks tasty... at a distance.",
        FLOWERSALAD = "Eat your greens! Or else!",
        ICECREAM = "It's the best I can expect from the wilderness.",
        WATERMELONICLE = "Cold and crunchy!",
        TRAILMIX = "Hope it's more food than trail.",
        HOTCHILI = "I like the challenge of spicy foods.",
        GUACAMOLE = "Where did the mole go?",
        MONSTERMEAT = "I bet I'm made of this stuff!",
        MONSTERMEAT_DRIED = "Came from a jerk, became a jerk.",
        MOOSE = "You're a dope! ...Hey! Can you hear me up there?!",
        MOOSE_NESTING_GROUND = "Whose making their nest on MY island?",
        MOOSEEGG = "I could make giant omelettes, or giant sunny side ups!", -- :)
        MOSSLING = "So, they're just born looking dumb?",
        FEATHERFAN = "Now I just need a couple of chumps to fan me!",
        MINIFAN = "Too small for flight.",
        GOOSE_FEATHER = "It's soft, unlike me!",
        STAFF_TORNADO = "All roads lead to pain!",
        MOSQUITO =
        {
            GENERIC = "Just try and sting me, see what happens!",
            HELD = "Don't you DARE take my blood.",
        },
        MOSQUITOSACK = "Could make a good blood bomb.",
        MOUND =
        {
            DUG = "Aww, no corpse.",
            GENERIC = "Maybe there's treasure, or a musty old corpse!",
        },
        NIGHTLIGHT = "That's MY kind of night light!",
        NIGHTMAREFUEL = "Careful, or it may swallow you whole.",
        NIGHTSWORD = "He-he-he, I like this shadow magic stuff!",
        NITRE = "With the right materials, it could go BOOM!",
        ONEMANBAND = "Finally, I can show off my musical talents!", -- :)
        OASISLAKE =
		{
			GENERIC = "I'm going to be very angry if it tastes like sand,",
			EMPTY = "More dirt in the desert. Wonderful.",
		},
        PANDORASCHEST = "What was Pandora's Box about again? Cool treasure in a box?", -- :)
        PANFLUTE = "I'm not much of a woodwind fan.",
        PAPYRUS = "Could make a good spitball.",
        WAXPAPER = "This would make a terrible spitball!",
        PENGUIN = "Waaaung, WAAAUNG!",
        PERD = "Why don't you gobble up a knuckle sandwich!",
        PEROGIES = "I hope no one put anything nasty inside.",
        PETALS = "Love me NEVER!",
        PETALS_EVIL = "No one tries to upstage me and gets away with it!",
        PHLEGM = "Hmm, maybe I could sling it... I'll write that one down...", -- :)
        PICKAXE = "I'm mining for diamonds!",
        PIGGYBACK = "I ain't giving a piggyback ride to anything but my gear!",
        PIGHEAD =
        {
            GENERIC = "It's like a giants lollipop!",
            BURNT = "A sacrifice of some sort?",
        },
        PIGHOUSE =
        {
            FULL = "Little pig, little pig!",
            GENERIC = "Looks a bit cramped. I'm okay out here.",
            LIGHTSOUT = "Oh, you did NOT just do that!",
            BURNT = "I told you I'd burn your house down!",
        },
        PIGKING = "What a slob! What a blubber butt! What a... uh... pig!",
        PIGMAN =
        {
            DEAD = "Nothing but bacon now!",
            FOLLOWER = "Shove off, greasebag!",
            GENERIC = "Hey look, walking bacon!",
            GUARD = "Bacon, with extra grit.",
            WEREPIG = "Furry fury!",
        },
        PIGSKIN = "Who wants to play football? Full contact!",
        PIGTENT = "Tentative, at best.", -- spelling
        PIGTORCH = "Look at their dumb little faces.",
        PINECONE = "Maybe I could chuck it at someone.",
        PINECONE_SAPLING = "This should only take... what, thirty years?",
        LUMPY_SAPLING = "Where'd that come from?",
        PITCHFORK = "Pointy.",
        PLANTMEAT = "Meats and veggies, all in one!",
        PLANTMEAT_COOKED = "It cooked well, hopefully it tastes just as good.",
        PLANT_NORMAL =
        {
            GENERIC = "I hate surprises! Hurry up and show me!",
            GROWING = "Quit slacking!",
            READY = "Let's eat!",
            WITHERED = "Can't work while dehydrated!",
        },
        POMEGRANATE = "I bet it would make a nice mess if I threw it at someones head.",
        POMEGRANATE_COOKED = "It kinda just... dried out a bit.",
        POMEGRANATE_SEEDS = "I hate gardening!",
        POND = "It's cramped, and probably filled with frogs!",
        POOP = "Laugh it up, very funny.",
        FERTILIZER = "You know what it is.",
        PUMPKIN = "I want to carve a face in it!",
        PUMPKINCOOKIE = "It was me! I stole the cookie from the cookie jar!",
        PUMPKIN_COOKED = "Squishy squash.",
        PUMPKIN_LANTERN = "I could wear it and scare someone!",
        PUMPKIN_SEEDS = "I hate gardening!",
        PURPLEAMULET = "Keep your fears close to your heart.",
        PURPLEGEM = "Looking closely at it makes me feel... trapped...",
        RABBIT =
        {
            GENERIC = "A jerk-alope!",
            HELD = "No running away now!",
        },
        RABBITHOLE =
        {
            GENERIC = "I hope I don't fall in when walking around!",
            SPRING = "Atleast I won't fall in!",
        },
        RAINOMETER =
        {
            GENERIC = "What a waste of supplies.",
            BURNT = "Couldn't see that coming, could you?",
        },
        RAINCOAT = "Now I can roughhouse in the rain!", -- spelling
        RAINHAT = "I hate it when my hair gets wet.",
        RATATOUILLE = "It looks like someone beat up a salad.",
        RAZOR = "Sleep with an eye open, unless you don't mind losing your eyebrows!",
        REDGEM = "Just like my bow!",
        RED_CAP = "I know it's poisonous, but it looks so good!",
        RED_CAP_COOKED = "This isn't helping me avoid eating it.",
        RED_MUSHROOM =
        {
            GENERIC = "Why must it be so tempting...",
            INGROUND = "Maybe it's better that way.",
            PICKED = "Hope no one ate it.",
        },
        REEDS =
        {
            BURNING = "I'm surprised it's burning in such a wet environment.",
            GENERIC = "Now, if only I could find a saxaphone...", -- :)
            PICKED = "Gone.",
        },
        RELIC = "How's something so old gone un-smashed?",
        RUINS_RUBBLE = "About time!",
        RUBBLE = "More rocks.",
        RESEARCHLAB =
        {
            GENERIC = "This is just the start of my devious plot!",
            BURNT = "A small setback!",
        },
        RESEARCHLAB2 =
        {
            GENERIC = "I could make all sorts of ammo with this thing!",
            BURNT = "If I catch who did this...",
        },
        RESEARCHLAB3 =
        {
            GENERIC = "So, magic tricks are REAL?",
            BURNT = "Was that part of the act?",
        },
        RESEARCHLAB4 =
        {
            GENERIC = "This can only lead to good things.",
            BURNT = "This wasn't part of the plan...",
        },
        RESURRECTIONSTATUE =
        {
            GENERIC = "I tried sculpting my likeness, and this is what came out...",
            BURNT = "I wasn't proud of that piece anyways.",
        },
        RESURRECTIONSTONE = "I do like touching stuff...",
        ROBIN =
        {
            GENERIC = "Go tweet around elsewhere.",
            HELD = "Don't go robin me!",
        },
        ROBIN_WINTER =
        {
            GENERIC = "I thought you all flew away in winter!",
            HELD = "Keep warm while you can...",
        },
        ROBOT_PUPPET = "Hey, that's MY throne!", --single player
        ROCK_LIGHT =
        {
            GENERIC = "Quite a light.",--removed
            OUT = "Nothing doing.",--removed
            LOW = "Crusty.",--removed
            NORMAL = "Pretty comfy.",--removed
        },
        CAVEIN_BOULDER =
        {
            GENERIC = "I bet I could toss it!",
            RAISED = "Hey! Get down here!",
        },
        ROCK = "Can't wait to sling it at an unsuspecting victim!",
        PETRIFIED_TREE = "Bet it got scared!",
        ROCK_PETRIFIED_TREE = "Bet it got scared!",
        ROCK_PETRIFIED_TREE_OLD = "Bet it got scared!",
        ROCK_ICE =
        {
            GENERIC = "Did a glacier wash ashore?",
            MELTED = "Perfect for splashing!",
        },
        ROCK_ICE_MELTED = "Perfect for splashing!",
        ICE = "Melty.",
        ROCKS = "They're rocks, you block-head!",
        ROOK = "Watch where you're walking you big-nosed buffoon!",
        ROPE = "I'm could hog-tie some varmints!",
        ROTTENEGG = "Not many houses to egg around here.",
        ROYAL_JELLY = "It's fancy goop, but it's goop all the same.",
        JELLYBEAN = "That's at least a dollars worth!",
        SADDLE_BASIC = "I don't plan on using it.",
        SADDLE_RACE = "What a huge waste of time.",
        SADDLE_WAR = "Couldn't I just put it on the ground and sit on it?",
        SADDLEHORN = "They can keep the saddles for all I care.",
        SALTLICK = " If it keeps the dumb cows away from me, then I'm happy.",
        BRUSH = "Too rough for my hair, and I don't plan on brushing any dumb animals.",
		SANITYROCK =
		{
			ACTIVE = "Hey! Get out of my way!",
			INACTIVE = "And stay down!",
		},
		SAPLING =
		{
			BURNING = "So long, twiggy.",
			WITHERED = "Too hot? Well, I'm not going to fan you!",
			GENERIC = "Aww look, it's a pathetic little baby tree!",
			PICKED = "Ha-ha!",
			DISEASED = "Better not be contagious.",--removed
			DISEASING = "You better not be sick.",--removed
		},
   		SCARECROW =
   		{
			GENERIC = "You ain't scaring nobody, mister.",
			BURNING = "Now you're getting there!",
			BURNT = "And now you're gone.",
   		},
   		SCULPTINGTABLE=
   		{
			EMPTY = "Need some materials to make a masterpiece.",
			BLOCK = "Visualize the sculpture within, then...", -- :)
			SCULPTURE = "I'm a master at my craft!",
			BURNT = "No fun allowed!",
   		},
        SCULPTURE_KNIGHTHEAD = "Aw, poor horse.",
		SCULPTURE_KNIGHTBODY =
		{
			COVERED = "It's broken down... let's break it some more!",
			UNCOVERED = "Is it a horse? Can we fix it?",
			FINISHED = "I'm tempted to climb on it, but I don't want anyone to see.",
			READY = "Is that thing moving?",
		},
        SCULPTURE_BISHOPHEAD = "Hope you prayed hard enough.",
		SCULPTURE_BISHOPBODY =
		{
			COVERED = "It's broken down... let's break it some more!",
			UNCOVERED = "Hmm, I COULD fix it...",
			FINISHED = "Great! Now we can smash it again, right?",
			READY = "Is that thing moving?",
		},
        SCULPTURE_ROOKNOSE = "I don't know what this is.",
		SCULPTURE_ROOKBODY =
		{
			COVERED = "It's broken down... let's break it some more!",
			UNCOVERED = "Where's your nose? Me don't nose!", -- :)
			FINISHED = "Great! Now we can smash it again, right?",
			READY = "Is that thing moving?",
		},
        GARGOYLE_HOUND = "They ain't hounding anyone anymore.",
        GARGOYLE_WEREPIG = "Stone cold dead.",
		SEEDS = "Better than nothing.",
		SEEDS_COOKED = "Better than \"better than nothing\".",
		SEWING_KIT = "I learned to stitch after my favorite jumper kept ripping.",
		SEWING_TAPE = "Mom would kill me if I patched my clothes with this.",
		SHOVEL = "Perfect for burying all my dark secrets.",
		SILK = "It's not the soft and smooth kind.",
		SKELETON = "Bummer.",
		SCORCHED_SKELETON = "Roasted bones.",
		SKULLCHEST = "It's my kind of style!", --removed
		SMALLBIRD =
		{
			GENERIC = "The only mouth I care to feed is my own.",
			HUNGRY = "Quit whining!",
			STARVING = "Go find some worms to eat or something!",
			SLEEPING = "I'm just... going to leave now...",
		},
		SMALLMEAT = "More bone than meat.",
		SMALLMEAT_DRIED = "It's a nice snack.",
		SPAT = "Go spit on someone who deserves it!",
		SPEAR = "It will do in a pinch, but I'd prefer my slingshot.",
		SPEAR_WATHGRITHR = "Do the wings help me throw it? ...No? I'll pass.",
		WATHGRITHRHAT = "It's heavy, uncomfortable, and I look silly wearing it.",
		SPIDER =
		{
			DEAD = "Squish!",
			GENERIC = "I'll squash you, bug!",
			SLEEPING = "Perfect time for a sneak attack!",
		},
		SPIDERDEN = "Where's a lighter when you need one...",
		SPIDEREGGSACK = "Gross! Just toss it in a fire already!",
		SPIDERGLAND = "Maybe I could stick it on a small scrap or cut.",
		SPIDERHAT = "Attract more spiders? No thanks!",
		SPIDERQUEEN = "There's only room for ONE queen around here!",
		SPIDER_WARRIOR =
		{
			DEAD = "Don't mess with Wixie!",
			GENERIC = "I'll stomp you dead!",
			SLEEPING = "You're letting your guard down.",
		},
		SPOILED_FOOD = "I dare you to eat it!",
        STAGEHAND =
        {
			AWAKE = "Get out of here, stalker!",
			HIDING = "I hate hide and seek.",
        },
        STATUE_MARBLE =
        {
            GENERIC = "I wonder who made these?",
            TYPE1 = "It looks like something from a museum.",
            TYPE2 = "It's nice, I guess.",
            TYPE3 = "That one's just asking for birds to land on it.", --bird bath type statue
        },
		STATUEHARP = "Harps are nice, but it's not my style.",
		STATUEMAXWELL = "First it was people, then random objects started disappearing.",
		STEELWOOL = "Essential for cleaning all the aluminum pots and pans we've got lying around.",
		STINGER = "I took it's butt as a trophy.",
		STRAWHAT = "Not bad, for a hat...",
		STUFFEDEGGPLANT = "It makes me anxious.",
		SWEATERVEST = "Spiffy!",
		REFLECTIVEVEST = "It might bounce a few light rays into my enemies eyes.",
		HAWAIIANSHIRT = "What the heck is a \"Hawaii\"?",
		TAFFY = "I lost my first tooth in one of these things. Gimme!",
		TALLBIRD = "It's practically a walking bullseye!",
		TALLBIRDEGG = "I could make a giant omelette. Or I could egg someones house.",
		TALLBIRDEGG_COOKED = "It's not too late to egg someones house.",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "No one likes cold eggs.",
			GENERIC = "Oh no... it's hatching.",
			HOT = "Nice and toasty!",
			LONG = "Are you going to hatch or what?",
			SHORT = "It's not too late to cook it.",
		},
		TALLBIRDNEST =
		{
			GENERIC = "Ripe for the picking.",
			PICKED = "Where's the eggs?",
		},
		TEENBIRD =
		{
			GENERIC = "I'm a teenager too, but we are NOTHING alike!",
			HUNGRY = "I hope that's not what I sound like.",
			STARVING = "I'd never hit my parents, you jerk!",
			SLEEPING = "Finally, some peace and quiet.",
		},
		TELEPORTATO_BASE =
		{
			ACTIVE = "Trust the giant metal head.", --single player
			GENERIC = "It definetly needs... something.", --single player
			LOCKED = "Needs a key of some sort.", --single player
			PARTIAL = "It's not done yet, so don't go judging it.", --single player
		},
		TELEPORTATO_BOX = "Boy am I glad that we're out here.", --single player
		TELEPORTATO_CRANK = "Cranky?! I'll show YOU cranky!", --single player
		TELEPORTATO_POTATO = "Definitely not edible.", --single player
		TELEPORTATO_RING = "Hm... I'll call it... The Wixie-hoop!", --single player
		TELESTAFF = "But getting there is half the fun!",
		TENT =
		{
			GENERIC = "Couldn't we make it a little bigger?",
			BURNT = "Guess we'll sleep under the stars instead.",
		},
		SIESTAHUT =
		{
			GENERIC = "That pesky sun won't bother me now!",
			BURNT = "It's taking a dirt nap.",
		},
		TENTACLE = "It's all one creature... Wait, how do I know that?",
		TENTACLESPIKE = "It's mine now!",
		TENTACLESPOTS = "It stinks.",
		TENTACLE_PILLAR = "Whatever's down there must be massive... I wonder if I'll see it one day?",
        TENTACLE_PILLAR_HOLE = "I... I'm okay with staying up here.",
		TENTACLE_PILLAR_ARM = "Beat it, shrimp!",
		TENTACLE_GARDEN = "Whatever is down there must be massive... I wonder if I'll see it one day?", --Unused?
		TOPHAT = "Think I could pull a rabbit out of it?",
		TORCH = "Ah yes, fire on a stick.",
		TRANSISTOR = "I think I saw these in that radio I brok- I mean, uh...",
		TRAP = "I don't know how I made it, to be honest.",
		TRAP_TEETH = "I'm particularly proud of this one.", -- spelling
		TRAP_TEETH_MAXWELL = "I'd like to meet whoever made these!", --single player
		TREASURECHEST =
		{
			GENERIC = "It's full of my stuff.",
			BURNT = "The only thing stored inside it is disappointment.",
		},
		TREASURECHEST_TRAP = "It better have something good inside!",
		SACRED_CHEST =
		{
			GENERIC = "Ancient treasure? It's all mine!",
			LOCKED = "Can't I just break the lock?",
		},
		TREECLUMP = "You're all a bunch of jerks!", --removed

		TRINKET_1 = "Such a waste of perfectly good marbles. Atleast I can still shoot them!", --Melted Marbles
		TRINKET_2 = "It doesn't even make sound when you blow it! What a rip off!", --Fake Kazoo
		TRINKET_3 = "This is just practice for tying someones shoelaces together.", --Gord's Knot
		TRINKET_4 = "Not a whole lot of gardens in a city.", --Gnome
		TRINKET_5 = "All that Buck Rogers stuff is fake, I doubt anyone will go to space...", --Toy Rocketship - Buck Rogers was created in 1929 :)
		TRINKET_6 = "It's okay to play with them, there's no electrici-- OW!!", --Frazzled Wires
		TRINKET_7 = "The ball refuses to cooperate.", --Ball and Cup
		TRINKET_8 = "I know a few loud mouths I could use this on.", --Rubber Bung
		TRINKET_9 = "I tend to lose a lot of these.", --Mismatched Buttons
		TRINKET_10 = "I hope it's a long time before I need a set of these...", --Dentures
		TRINKET_11 = "I think we'll make good friends.", --Lying Robot
		TRINKET_12 = "One of many pieces.", --Dessicated Tentacle
		TRINKET_13 = "What exactly do these gnomes do?", --Gnomette
		TRINKET_14 = "This one wasn't my fault!", --Leaky Teacup
		TRINKET_15 = "It's mine to control.", --Pawn
		TRINKET_16 = "It's mine to control.", --Pawn
		TRINKET_17 = "It doesn't beat my hands.", --Bent Spork
		TRINKET_18 = "Oh, it's like something my mom would make!", --Trojan Horse
		TRINKET_19 = "Don't give up, top!", --Unbalanced Top
		TRINKET_20 = "It's some kind of primitive weapon.", --Backscratcher
		TRINKET_21 = "Can't handle the heat? Then get out of my kitchen!", --Egg Beater
		TRINKET_22 = "It's too flimsy to be useful.", --Frayed Yarn
		TRINKET_23 = "I've been wearing these shoes since I was nine.", --Shoehorn
		TRINKET_24 = "I saw these in a store down town.", --Lucky Cat Jar
		TRINKET_25 = "Smells like an automobile.", --Air Unfreshener
		TRINKET_26 = "Where did all the potato go?!", --Potato Cup
		TRINKET_27 = "I miss my rain coat.", --Coat Hanger
		TRINKET_28 = "I can easily knock this castle over.", --Rook
        TRINKET_29 = "I can easily knock this castle over.", --Rook
        TRINKET_30 = "This is my favorite piece.", --Knight
        TRINKET_31 = "This is my favorite piece.", --Knight
        TRINKET_32 = "I don't believe in this stuff.", --Cubic Zirconia Ball
        TRINKET_33 = "It doesn't fit...", --Spider Ring
        TRINKET_34 = "I don't believe in wishes!", --Monkey Paw
        TRINKET_35 = "Don't trust random elixirs you find in the wild.", --Empty Elixir
        TRINKET_36 = "I'm scary enough as is, thanks.", --Faux fangs
        TRINKET_37 = "We're all done for if a vampire shows up.", --Broken Stake
        TRINKET_38 = "I like to keep things at a distance.", -- Binoculars Griftlands trinket
        TRINKET_39 = "It's too big for me.", -- Lone Glove Griftlands trinket
        TRINKET_40 = "It takes awhile to weigh things.", -- Snail Scale Griftlands trinket
        TRINKET_41 = "Maybe someone was thirsty?", -- Goop Canister Hot Lava trinket
        TRINKET_42 = "Snakes are great.", -- Toy Cobra Hot Lava trinket
        TRINKET_43 = "I like the detail work!", -- Crocodile Toy Hot Lava trinket
        TRINKET_44 = "It's fake.", -- Broken Terrarium ONI trinket
        TRINKET_45 = "I prefer live music. Or any music, this thing doesn't work!", -- Odd Radio ONI trinket
        TRINKET_46 = "Why does no one else recognize it? They were just invented...", -- Hairdryer ONI trinket - Hair Dryers were invented in 1920 :)

        -- The numbers align with the trinket numbers above.
        LOST_TOY_1  = "Cool! A haunted toy!",
        LOST_TOY_2  = "Cool! A haunted toy!",
        LOST_TOY_7  = "Cool! A haunted toy!",
        LOST_TOY_10 = "Cool! A haunted toy!",
        LOST_TOY_11 = "Cool! A haunted toy!",
        LOST_TOY_14 = "Cool! A haunted toy!",
        LOST_TOY_18 = "Cool! A haunted toy!",
        LOST_TOY_19 = "Cool! A haunted toy!",
        LOST_TOY_42 = "Cool! A haunted toy!",
        LOST_TOY_43 = "Cool! A haunted toy!",

        HALLOWEENCANDY_1 = "It's an apple, but better!", -- apple
        HALLOWEENCANDY_2 = "Yuck, this is even worse than corn!", -- candy corn
        HALLOWEENCANDY_3 = "Is this a joke?! I hate corn!", -- corn?
        HALLOWEENCANDY_4 = "If only all spiders were this tasty!", -- spider?
        HALLOWEENCANDY_5 = "It's got cat hair on it.", -- ghost?
        HALLOWEENCANDY_6 = "They don't *smell* bad...", -- "raisins"
        HALLOWEENCANDY_7 = "Ye olde grapes.", -- raisins
        HALLOWEENCANDY_8 = "Don't haunt my stomach, please.",
        HALLOWEENCANDY_9 = "I don't know what it's supposed to be, but it tastes good.",
        HALLOWEENCANDY_10 = "Not sure I should lick this.",
        HALLOWEENCANDY_11 = "I wonder if they are alive. Ah, who cares! They're delicious!",
        HALLOWEENCANDY_12 = "I'll take the risk.", --ONI meal lice candy
        HALLOWEENCANDY_13 = "The only jawbreaker around here is me!", --Griftlands themed candy
        HALLOWEENCANDY_14 = "Who knew sweet and spicy could be so good!", --Hot Lava pepper candy
        CANDYBAG = "Could I get one that's twice as big?",

		HALLOWEEN_ORNAMENT_1 = "This isn't scary at all, where are the REAL decorations?",
		HALLOWEEN_ORNAMENT_2 = "One of these got in the boarding house once. Good times.",
		HALLOWEEN_ORNAMENT_3 = "It looks happy!",
		HALLOWEEN_ORNAMENT_4 = "It's not so much scary as it is gross.",
		HALLOWEEN_ORNAMENT_5 = "I bet I could scare the strongman with this.",
		HALLOWEEN_ORNAMENT_6 = "If it starts squawking I'm tossing it in the ocean.",

		HALLOWEENPOTION_DRINKS_WEAK = "I'm not used to making magic potions, give me a break okay?!",
		HALLOWEENPOTION_DRINKS_POTENT = "Nothing but the best!",
        HALLOWEENPOTION_BRAVERY = "I doubt it will make things less... cluttered.",
		HALLOWEENPOTION_MOON = "I wonder what would happen if I drank it...",
		HALLOWEENPOTION_FIRE_FX = "I don't care what fire looks like, as long as it does it's job!",
		MADSCIENCE_LAB = "I'm mad, but not crazy.",
		LIVINGTREE_ROOT = "I'm sure this was a good idea.",
		LIVINGTREE_SAPLING = "Are you hiding from someone?",

        DRAGONHEADHAT = "Who needs the rest of the costume when you've got this!",
        DRAGONBODYHAT = "I'd rather not be stuck in the middle.",
        DRAGONTAILHAT = "Better than the middle.",
        PERDSHRINE =
        {
            GENERIC = "A greedy gobbler.",
            EMPTY = "Do you... want something?",
            BURNT = "That turkey's been cooked.",
        },
        REDLANTERN = "It's my favorite color!",
        LUCKY_GOLDNUGGET = "I can't even make anything useful with it!",
        FIRECRACKERS = "Boom boom boom!",
        PERDFAN = "Now I just need some sucker to fan me.",
        REDPOUCH = "Let's see whats inside already!",
        WARGSHRINE =
        {
            GENERIC = "You'd better have something good...",
            EMPTY = "Some fire would liven it up.",
            BURNING = "Oops.", --for willow to override
            BURNT = "It's better this way, it might have attracted hounds.",
        },
        CLAYWARG =
        {
        	GENERIC = "It's alive!",
        	STATUE = "I want to tip it over!",
        },
        CLAYHOUND =
        {
        	GENERIC = "Smash it! SMASH IT!",
        	STATUE = "Let's smash it!",
        },
        HOUNDWHISTLE = "It doesn't make any sound! Stupid whistle!",
        CHESSPIECE_CLAYHOUND = "Lifeless, once again.",
        CHESSPIECE_CLAYWARG = "You look upset. Good.",

		PIGSHRINE =
		{
            GENERIC = "Got anything good?",
            EMPTY = "Maybe it's hungry?",
            BURNT = "Mmm, roasted pig.",
		},
		PIG_TOKEN = "Who needs a belt when you've got a jumper!",
		PIG_COIN = "It looks like a pig's snout! I wonder if that's on purpose.",
		YOTP_FOOD1 = "I wonder what that king of theirs would taste like...",
		YOTP_FOOD2 = "It's for pigs who like to play with their food.",
		YOTP_FOOD3 = "There's barely any meat on it!",

		PIGELITE1 = "Your paint is telling me to punch you in the snout!", --BLUE
		PIGELITE2 = "This one's my favorite, but he will suffer like the rest.", --RED
		PIGELITE3 = "Just try it, dots!", --WHITE
		PIGELITE4 = "Green with envy, I presume?", --GREEN

		PIGELITEFIGHTER1 = "Your paint is telling me to punch you in the snout!", --BLUE
		PIGELITEFIGHTER2 = "This ones my favorite, but he will suffer like the rest.", --RED
		PIGELITEFIGHTER3 = "Just try it, dots!", --WHITE
		PIGELITEFIGHTER4 = "Green with envy, I presume?", --GREEN

		CARRAT_GHOSTRACER = "Ooh, I want that one!",

        YOTC_CARRAT_RACE_START = "It's not a horse race, but it'll have to do.",
        YOTC_CARRAT_RACE_CHECKPOINT = "Can't just be a straight line.",
        YOTC_CARRAT_RACE_FINISH =
        {
            GENERIC = "I get to decide where they start!",
            BURNT = "He-he-he...",
            I_WON = "Of course I won!",
            SOMEONE_ELSE_WON = "What?! {winner} is cheating!",
        },

		YOTC_CARRAT_RACE_START_ITEM = "It's not a horse race, but it'll have to do.",
        YOTC_CARRAT_RACE_CHECKPOINT_ITEM = "Can't just be a straight line.",
		YOTC_CARRAT_RACE_FINISH_ITEM = "I wonder how long they would keep running without this...",
	
		YOTC_SEEDPACKET = "...Seeds?!",
		YOTC_SEEDPACKET_RARE = "What kind of reward is THIS?!",

		MINIBOATLANTERN = "Light the way, little guy.",

        YOTC_CARRATSHRINE =
        {
            GENERIC = "Should we really be inviting rats here?",
            EMPTY = "Do carrats eat carrots?",
            BURNT = "Don't worry everyone, I smoked them out!",
        },

        YOTC_CARRAT_GYM_DIRECTION =
        {
            GENERIC = "It helps the rats learn their left from their right.",
            RAT = "Left! LEFT!! No, that's right! I mean, wrong!", -- :)
            BURNT = "Now we will never know our cardinal directions.",
        },
        YOTC_CARRAT_GYM_SPEED =
        {
            GENERIC = "I bet I'm the fastest runner around here.",
            RAT = "Run as you may, you'll never get away.",
            BURNT = "No one will out run me now!",
        },
        YOTC_CARRAT_GYM_REACTION =
        {
            GENERIC = "I'd rather just throw stuff at them.",
            RAT = "Ha-ha, too slow!",
            BURNT = "Someone was too slow to put it out.",
        },
        YOTC_CARRAT_GYM_STAMINA =
        {
            GENERIC = "Lincoln, Lincoln...",
            RAT = "Boys are rotten, made out of cotton! Girls are sassy, made of molassey!", -- :)
            BURNT = "Oh my gosh it's turpentine!",
        },

        YOTC_CARRAT_GYM_DIRECTION_ITEM = "Lets put it somewhere out of the way, where we don't have to see it.",
        YOTC_CARRAT_GYM_SPEED_ITEM = "Lets put it somewhere out of the way, where we don't have to see it.",
        YOTC_CARRAT_GYM_STAMINA_ITEM = "Lets put it somewhere out of the way, where we don't have to see it.",
        YOTC_CARRAT_GYM_REACTION_ITEM = "Lets put it somewhere out of the way, where we don't have to see it.",

        YOTC_CARRAT_SCALE_ITEM = "Is it worth the weight?",
        YOTC_CARRAT_SCALE =
        {
            GENERIC = "It measures the weight of their brain, and muscles... I think.",
            CARRAT = "This guy is a pip-squeak!",
            CARRAT_GOOD = "This is a rat I'd like in a fight!",
            BURNT = "Someone got mad at their results.",
        },

        YOTB_BEEFALOSHRINE =
        {
            GENERIC = "Look at its dopey little face.",
            EMPTY = "Needs more padding. As if all of this wasn't enough...",
            BURNT = "Great! Let's go do something else.",
        },

        BEEFALO_GROOMER =
        {
            GENERIC = "Lookin' good!",
            OCCUPIED = "Yeah, whatever.",
            BURNT = "Problem solved, let's move on.",
        },
        BEEFALO_GROOMER_ITEM = "I could just toss it in the ocean instead.",

        YOTR_RABBITSHRINE =
        {
            GENERIC = "Shut yer yap!",
            EMPTY = "You're going to swallow a bug with your mouth open like that.",
            BURNT = "They swallowed fire.",
        },

        NIGHTCAPHAT = "I'll look silly...",

        YOTR_FOOD1 = "Rolls of the plate and on to my tongue!",
        YOTR_FOOD2 = "I'm not so sure about the filling...",
        YOTR_FOOD3 = "It jiggles when you poke it.",
        YOTR_FOOD4 = "Brutal.",

        YOTR_TOKEN = "Who dares to challenge me?",

        COZY_BUNNYMAN = "You're in for a rude awakening", -- :)

        HANDPILLOW_BEEFALOWOOL = "Ah, I miss my pillow.",
        HANDPILLOW_KELP = "No way I'm sleeping on a soggy pillow.",
        HANDPILLOW_PETALS = "Atleast it smells nice.",
        HANDPILLOW_STEELWOOL = "What? No, I promise I didn't fill it with steel...",

        BODYPILLOW_BEEFALOWOOL = "Ah, I miss my pillow.",
        BODYPILLOW_KELP = "No way I'm sleeping on a soggy pillow.",
        BODYPILLOW_PETALS = "Atleast it smells nice.",
        BODYPILLOW_STEELWOOL = "What? No, I promise I didn't fill it with steel...",

		BISHOP_CHARGE_HIT = "Yeouch!",
		TRUNKVEST_SUMMER = "Nice and loose.",
		TRUNKVEST_WINTER = "A bit restraining, but I'd rather wear this than be out in the cold.",
		TRUNK_COOKED = "It's hefty. Might make a good weapon!",
		TRUNK_SUMMER = "Snot alive anymore.",
		TRUNK_WINTER = "It's a portable booger cannon.",
		TUMBLEWEED = "Get back here and show me your secrets!",
		TURKEYDINNER = "I did it all for you, Mirabelle.", -- :)
		TWIGS = "Poking sticks.",
		UMBRELLA = "Singin' and dancin' in the rain!",
		GRASS_UMBRELLA = "This won't cut it.",
		UNIMPLEMENTED = "Just like Waldo!", -- :)
		WAFFLES = "Waffles are just pancakes with little squares on them.",
		WALL_HAY =
		{
			GENERIC = "Walls are walls, I don't like them.",
			BURNT = "That's about what I expected.",
		},
		WALL_HAY_ITEM = "Hey, hay.",
		WALL_STONE = "We could do without these...",
		WALL_STONE_ITEM = "Who needs walls when you have open space?",
		WALL_RUINS = "Doesn't matter how light they are, they still take up too much space.",
		WALL_RUINS_ITEM = "It's pretty light.",
		WALL_WOOD =
		{
			GENERIC = "I like the spikes, but not the whole *wall* part.",
			BURNT = "Good.",
		},
		WALL_WOOD_ITEM = "Extra pointy.",
		WALL_MOONROCK = "I don't care if it's from the moon, I don't like it!",
		WALL_MOONROCK_ITEM = "This does NOT rock.",
		FENCE = "It's less restrictive than a wall.",
        FENCE_ITEM = "I don't like being fenced in.",
        FENCE_GATE = "Atleast I can shove it out of the way.",
        FENCE_GATE_ITEM = "It's a fence.",
		WALRUS = "Try not to break a tusk, old man!",
		WALRUSHAT = "Reminds me of my dinner dress. I hate plaid.",
		WALRUS_CAMP =
		{
			EMPTY = "Maybe it's a big horse hoof print?",
			GENERIC = "There's no room in there! How can anyone live like that?",
		},
		WALRUS_TUSK = "He-he-he, I broke it.",
		WARDROBE =
		{
			GENERIC = "I'd steer clear if I were you...",
            BURNING = "Torment me no longer!",
			BURNT = "It's better this way.",
		},
		WARG = "You stink like a dog!",
        WARG_WAVE = "I smell an angry wet dog!",
		
		WASPHIVE = "Bees can't kill me!",
		WATERBALLOON = "Now who should I hit...",
		WATERMELON = "I want to hit it with a big mallet!",
		WATERMELON_COOKED = "It was already crisp.",
		WATERMELONHAT = "It's going to stain my bow...",
		WAXWELLJOURNAL = "Shouldn't mess with stuff you don't understand.",
		WETGOOP = "It's a delicacy!",
        WHIP = "This is gonna sting!",
		WINTERHAT = "I don't want to mess up my bow...",
		WINTEROMETER =
		{
			GENERIC = "Maybe it would help if we weren't outside all the time.",
			BURNT = "Hot. Definetly hot.",
		},

        WINTER_TREE =
        {
            BURNT = "This is why you shouldn't get excited for things.",
            BURNING = "There goes the holiday spirit.", -- :)
            CANDECORATE = "I've never had one before.",
            YOUNG = "Might be good for a small apartment, I guess.",
        },
		WINTER_TREESTAND =
		{
			GENERIC = "So, we stick a tree inside?",
            BURNT = "The fun is over before it began.",
		},
        WINTER_ORNAMENT = "We never used these back home.",
        WINTER_ORNAMENTLIGHT = "Practical and stylish, not bad!",
        WINTER_ORNAMENTBOSS = "A reminder of my feats of strength!",
		WINTER_ORNAMENTFORGE = "Forged in magma, to be hung on a tree for decoration.",
		WINTER_ORNAMENTGORGE = "I've got the goat!",

        WINTER_FOOD1 = "Which part should I eat first...", --gingerbread cookie
        WINTER_FOOD2 = "Gimme gimme!", --sugar cookie
        WINTER_FOOD3 = "No good for walking.", --candy cane
        WINTER_FOOD4 = "That's not food.", --fruitcake
        WINTER_FOOD5 = "The icing is rolled up tight.", --yule log cake
        WINTER_FOOD6 = "Do I just eat it with my hands?", --plum pudding
        WINTER_FOOD7 = "Why'd the adults hog it back home? It's just apple juice...", --apple cider
        WINTER_FOOD8 = "Piping hot!", --hot cocoa
        WINTER_FOOD9 = "It's not the \"special\" kind.", --eggnog

		WINTERSFEASTOVEN =
		{
			GENERIC = "I can almost smell the turkey!",
			COOKING = "Food! Food! Food!",
			ALMOST_DONE_COOKING = "My mouth is watering!",
			DISH_READY = "GIMME!",
		},
		BERRYSAUCE = "I thought I was sick of berries!",
		BIBINGKA = "Oh, I recognize these!",
		CABBAGEROLLS = "I hate cabbage... but I can't be picky.",
		FESTIVEFISH = "It's no catfish, but it will do.",
		GRAVY = "Turkey, fish, beef, who cares!",
		LATKES = "It's... a thin pancake?",
		LUTEFISK = "It smells, but it probably tastes good.",
		MULLEDDRINK = "It's a bit tart.",
		PANETTONE = "It's not exactly my favorite...",
		PAVLOVA = "It doesn't look very healthy. Wait a second, I don't care!",
		PICKLEDHERRING = "So many fish to choose from, but nary a catfish.",
		POLISHCOOKIE = "It doesn't *look* polished.",
		PUMPKINPIE = "If only we had some ice cream...",
		ROASTTURKEY = "It's one of my favorites!",
		STUFFING = "All I care about is stuffing it in my mouth.",
		SWEETPOTATO = "I yam what I yam, and that's all that I yam!", -- :)
		TAMALES = "Hot tamales!",
		TOURTIERE = "It's some kind of Canadian food.",

		TABLE_WINTERS_FEAST =
		{
			GENERIC = "Where's the food?!",
			HAS_FOOD = "I'm not waiting for anybody!",
			WRONG_TYPE = "That's boring food!",
			BURNT = "Who cooked the table?",
		},

		GINGERBREADWARG = "Go goop someone else!",
		GINGERBREADHOUSE = "You shouldn't have made your house so delicious.",
		GINGERBREADPIG = "I promise I won't bite...",
		CRUMBS = "The hunt is on!",
		WINTERSFEASTFUEL = "It looks like magic!",

        KLAUS = "AAH! WHAT IS THAT?!", -- :)
        KLAUS_SACK = "I wonder what's inside?",
		KLAUSSACKKEY = "I'm glad that guy's dead.",
		WORMHOLE =
		{
			GENERIC = "Gross, it's moving.",
			OPEN = "It's dark... and cramped...",
		},
		WORMHOLE_LIMITED = "I'm sick of you too.",
		ACCOMPLISHMENT_SHRINE = "Wow, this is worthless!", --single player
		LIVINGTREE = "If I chop you down and no one is around, will you make a sound?",
		ICESTAFF = "Pfft, I could do better.",
		REVIVER = "See? I have a heart!",
		SHADOWHEART = "Looking at it fills me with a sense of dread... like something bad is coming...",
        ATRIUM_RUBBLE =
        {
			LINE_1 = "It's easy to make mistakes when you're afraid...",
			LINE_2 = "Eyes. Lots of eyes. What's with all the eyes?",
			LINE_3 = "A heart? Something down below...",
			LINE_4 = "They all kind look like... those things...",
			LINE_5 = "Looks like a portal... A huge one down below...",
		},
        ATRIUM_STATUE = "Well, they won't be bugging us any time soon.",
        ATRIUM_LIGHT =
        {
			ON = "How'd they make light out of dark magic anyways?",
			OFF = "I could use a light right about now...",
		},
        ATRIUM_GATE =
        {
			ON = "Let there be light!",
			OFF = "It's missing something. A key, I guess.",
			CHARGING = "It's powering up!",
			DESTABILIZING = "That can't be good.",
			COOLDOWN = "It needs time to recharge its... magic-ness.",
        },
        ATRIUM_KEY = "Imagine having to drag this around to open your front door!",
		LIFEINJECTOR = "I usually wouldn't go around jabbing myself with needles I found in the wilderness.",
		SKELETON_PLAYER =
		{
			MALE = "He-he-he, %s was too dumb to avoid %s!",
			FEMALE = "He-he-he, %s was too dumb to avoid %s!",
			ROBOT = "He-he-he, %s was too dumb to avoid %s!",
			DEFAULT = "He-he-he, %s was too dumb to avoid %s!",
		},
		HUMANMEAT = "No, I'm not eating that.",
		HUMANMEAT_COOKED = "Ew, now it smells even worse.",
		HUMANMEAT_DRIED = "I've had plenty of time to think, and the answer is still no.",
		ROCK_MOON = "Well, it's not made of cheese.",
		MOONROCKNUGGET = "I did a taste test to be sure, it's not cheese.",
		MOONROCKCRATER = "What're you looking at?",
		MOONROCKSEED = "It glows. And uh... glows.",

        REDMOONEYE = "Red eyes are so cool...", -- :)
        PURPLEMOONEYE = "I feel like I'm being watched.",
        GREENMOONEYE = "Seems like a waste of a perfectly good gem.",
        ORANGEMOONEYE = "Lazy eye!",
        YELLOWMOONEYE = "A yellow fellow.",
        BLUEMOONEYE = "I've got those baby blues.",

        --Arena Event
        LAVAARENA_BOARLORD = "Come fight me yourself, you big jerk!",
        BOARRIOR = "He's got a gut on him.",
        BOARON = "Oh boy, ham!", -- :)
        PEGHOOK = "I wish *I* could spit toxic goo...",
        TRAILS = "This guy knows how to roll with the punches!",
        TURTILLUS = "You can't win a fight by hiding!",
        SNAPPER = "Don't get snappy with me, green skin!",
		RHINODRILL = "Two idiots are dumber than one.",
		BEETLETAUR = "He's locked his ability to smell.",

        LAVAARENA_PORTAL =
        {
            ON = "Finally! This heat is unbearable...",
            GENERIC = "Well, this wasn't what I was expecting.",
        },
        LAVAARENA_KEYHOLE = "Where's the key?",
		LAVAARENA_KEYHOLE_FULL = "That'll work.",
        LAVAARENA_BATTLESTANDARD = "Knock it down! Break it!",
        LAVAARENA_SPAWNER = "It spawns ham headed brutes.",

        HEALINGSTAFF = "Hurting is more rewarding than healing!",
        FIREBALLSTAFF = "Destruction! Desolation!",
        HAMMER_MJOLNIR = "I usually like keeping my distance, but I do like smashing things...",
        SPEAR_GUNGNIR = "Can I throw it? Nah...",
        BLOWDART_LAVA = "I'd prefer my slingshot.",
        BLOWDART_LAVA2 = "Ooh, flamey! Wish I had a flaming slingshot...",
        LAVAARENA_LUCY = "If I tried to pick her up she'd just start yapping my ear off.",
        WEBBER_SPIDER_MINION = "It's too scared to try fighting me!",
        BOOK_FOSSIL = "Another crusty old book.",
		LAVAARENA_BERNIE = "He's going to get the stuffing beat out of him!",
		SPEAR_LANCE = "Sharp and pokey.",
		BOOK_ELEMENTAL = "It's full of scribbles.", -- ME!!!
		LAVAARENA_ELEMENTAL = "That hot head has rocks for brain!",

   		LAVAARENA_ARMORLIGHT = "Not very protective, but atleast it's lightweight.",
		LAVAARENA_ARMORLIGHTSPEED = "I like to stay on the move!",
		LAVAARENA_ARMORMEDIUM = "It's better than nothing, but I'd prefer something lighter.",
		LAVAARENA_ARMORMEDIUMDAMAGER = "Hit me, I dare you!",
		LAVAARENA_ARMORMEDIUMRECHARGER = "I feel a lot more focused wearing it.",
		LAVAARENA_ARMORHEAVY = "It'll protect me, but just looking at it stresses me out.",
		LAVAARENA_ARMOREXTRAHEAVY = "I don't want to put that thing on!",

		LAVAARENA_FEATHERCROWNHAT = "Feels like I'm flying!",
        LAVAARENA_HEALINGFLOWERHAT = "I like my bow better.",
        LAVAARENA_LIGHTDAMAGERHAT = "Like the vikings!",
        LAVAARENA_STRONGDAMAGERHAT = "Looks as tough as me!",
        LAVAARENA_TIARAFLOWERPETALSHAT = "Lame!",
        LAVAARENA_EYECIRCLETHAT = "It unlocks my third eye.",
        LAVAARENA_RECHARGERHAT = "I'm the toughest princess you'll ever meet!",
        LAVAARENA_HEALINGGARLANDHAT = "I feel relaxed when wearing it.",
        LAVAARENA_CROWNDAMAGERHAT = "Seems a bit excessive.",

		LAVAARENA_ARMOR_HP = "Filled with energy!",

		LAVAARENA_FIREBOMB = "He-he-he...",
		LAVAARENA_HEAVYBLADE = "I should leave this to one of the meat heads.",

        --Quagmire
        QUAGMIRE_ALTAR =
        {
        	GENERIC = "Hope it's not a picky eater.",
        	FULL = "Eat up! Fatty...",
    	},
		QUAGMIRE_ALTAR_STATUE1 = "Bored now!",
		QUAGMIRE_PARK_FOUNTAIN = "And not a drop to drink.",

        QUAGMIRE_HOE = "It makes holes in things.",

        QUAGMIRE_TURNIP = "More veggies.",
        QUAGMIRE_TURNIP_COOKED = "Ready to eat!",
        QUAGMIRE_TURNIP_SEEDS = "More boring seeds.",

        QUAGMIRE_GARLIC = "Smells like the strongmans breath...",
        QUAGMIRE_GARLIC_COOKED = "Yuck!",
        QUAGMIRE_GARLIC_SEEDS = "More boring seeds.",

        QUAGMIRE_ONION = "Go cry about it.",
        QUAGMIRE_ONION_COOKED = "I've got something in my eyes!",
        QUAGMIRE_ONION_SEEDS = "More boring seeds.",

        QUAGMIRE_POTATO = "I'd sling it, if we weren't in such a hurry.",
        QUAGMIRE_POTATO_COOKED = "I think it's edible now.",
        QUAGMIRE_POTATO_SEEDS = "More boring seeds.",

        QUAGMIRE_TOMATO = "I'll toss it at the mime next time he does one of his lame acts.",
        QUAGMIRE_TOMATO_COOKED = "Twice as crispy.",
        QUAGMIRE_TOMATO_SEEDS = "More boring seeds.",

        QUAGMIRE_FLOUR = "Hmm... maybe a smoke bomb...",
        QUAGMIRE_WHEAT = "Neat. It's wheat. Golly, I'm bored...", -- :)
        QUAGMIRE_WHEAT_SEEDS = "More boring seeds.",
        --NOTE: raw/cooked carrot uses regular carrot strings
        QUAGMIRE_CARROT_SEEDS = "More boring seeds.",

        QUAGMIRE_ROTTEN_CROP = "This is what the big greedy mouth in the sky deserves.",

		QUAGMIRE_SALMON = "Get ready for the grill, mister fish.", -- :)
		QUAGMIRE_SALMON_COOKED = "I wish we could eat it...",
		QUAGMIRE_CRABMEAT = "Don't be crabby!",
		QUAGMIRE_CRABMEAT_COOKED = "You ain't pinching anyone anymore.",
		QUAGMIRE_SUGARWOODTREE =
		{
			GENERIC = "Maybe some Canadian would know what to do.",
			STUMP = "Tree's gone, and so is the sap.",
			TAPPED_EMPTY = "The life has been sucked out of it.",
			TAPPED_READY = "It probably looks better than it tastes.",
			TAPPED_BUGS = "Get outta there you varmints!",
			WOUNDED = "It's weak and wilted.",
		},
		QUAGMIRE_SPOTSPICE_SHRUB =
		{
			GENERIC = "I don't know what it is, but it smells good.",
			PICKED = "Hurry up and grow some more!",
		},
		QUAGMIRE_SPOTSPICE_SPRIG = "Time to grind it up! My favorite part!", -- Maybe wixies unique gorge perk?
		QUAGMIRE_SPOTSPICE_GROUND = "The dirt it's sitting on will add texture.",
		QUAGMIRE_SAPBUCKET = "I'm not much of a wilderness person.",
		QUAGMIRE_SAP = "I thought you had to refine this stuff before eating it...",
		QUAGMIRE_SALT_RACK =
		{
			READY = "Nice and briney.",
			GENERIC = "I'm just making it up as I go.",
		},

		QUAGMIRE_POND_SALT = "Extra salty salt water.",
		QUAGMIRE_SALT_RACK_ITEM = "Sucks the salt right out of salt water. I think.",

		QUAGMIRE_SAFE =
		{
			GENERIC = "No safe is safe from Wixie!",
			LOCKED = "Hey! Open up!",
		},

		QUAGMIRE_KEY = "What could it unlock?",
		QUAGMIRE_KEY_PARK = "No private property is safe from me!",
        QUAGMIRE_PORTAL_KEY = "I'm sick of this sickly place, lets get out of here!", -- spelling (lets?)


		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "It's damp and smelly.",
			PICKED = "Just a dank stump.",
		},
		QUAGMIRE_MUSHROOMS = "I think these are edible.",
        QUAGMIRE_MEALINGSTONE = "Crush! Smash!",
		QUAGMIRE_PEBBLECRAB = "Kick the crab!",


		QUAGMIRE_RUBBLE_CARRIAGE = "Is this what old people traveled in?",
        QUAGMIRE_RUBBLE_CLOCK = "Someone smashed their alarm clock.",
        QUAGMIRE_RUBBLE_CATHEDRAL = "No more church. No more free snacks...",
        QUAGMIRE_RUBBLE_PUBDOOR = "Now I'll never see what's inside!", -- spelling (what's)
        QUAGMIRE_RUBBLE_ROOF = "Atleast the roof is intact. Mostly.",
        QUAGMIRE_RUBBLE_CLOCKTOWER = "Is that why time has stopped here?",
        QUAGMIRE_RUBBLE_BIKE = "I miss my bike.", -- lore :)
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "No one's home.",
            "Did a giant roll through town?",
            "It's all smashed to bits.",
        },
        QUAGMIRE_RUBBLE_CHIMNEY = "Chim chim cheree!",
        QUAGMIRE_RUBBLE_CHIMNEY2 = "Chim chim cheree!",
        QUAGMIRE_MERMHOUSE = "Termites, for sure.",
        QUAGMIRE_SWAMPIG_HOUSE = "Are they too lazy to fix it up?",
        QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "Blown down.",
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "Stop sitting around and help us, you layabout!",
            SLEEPING = "How could you sleep at a time like this?",
        },
        QUAGMIRE_SWAMPIG = "Take a bath!",

        QUAGMIRE_PORTAL = "Atleast we're out of the heat.",
        QUAGMIRE_SALTROCK = "Sadly it's not sugar.",
        QUAGMIRE_SALT = "Salt makes it clean, right?",
        --food--
        QUAGMIRE_FOOD_BURNT = "This is what that big mouthed jerk deserves.",
        QUAGMIRE_FOOD =
        {
        	GENERIC = "All this good looking food, and it's going to waste...",
            MISMATCH = "Quit being so picky!",
            MATCH = "I think it approves.",
            MATCH_BUT_SNACK = "You want MORE?",
        },

        QUAGMIRE_FERN = "Pitful greens.",
        QUAGMIRE_FOLIAGE_COOKED = "Huh, it didn't turn to ash.",
        QUAGMIRE_COIN1 = "Could get a gumball or two for this.", -- :)
        QUAGMIRE_COIN2 = "A whole bag of candies worth...",
        QUAGMIRE_COIN3 = "So wheres the candy shop?",
        QUAGMIRE_COIN4 = "Freedom, or candy... it's a tough choice.",
        QUAGMIRE_GOATMILK = "No way I'm drinking this!",
        QUAGMIRE_SYRUP = "Where's the pancakes?",
        QUAGMIRE_SAP_SPOILED = "Now it's just gross and sticky.",
        QUAGMIRE_SEEDPACKET = "Can someone else plant these?",

        QUAGMIRE_POT = "Wish us pot-luck.", -- :)
        QUAGMIRE_POT_SMALL = "Could make a small meal in this.",
        QUAGMIRE_POT_SYRUP = "Yup, it's syrup.",
        QUAGMIRE_POT_HANGER = "We could hang something on it.", -- had to do a double take when proof-reading this
        QUAGMIRE_POT_HANGER_ITEM = "Let's hang it up already!",
        QUAGMIRE_GRILL = "Start cooking!",
        QUAGMIRE_GRILL_ITEM = "Now, where should we put this...",
        QUAGMIRE_GRILL_SMALL = "Wouldn't suit a backyard barbeque.",
        QUAGMIRE_GRILL_SMALL_ITEM = "Now, where should we put this...",
        QUAGMIRE_OVEN = "Let's toss some food in.",
        QUAGMIRE_OVEN_ITEM = "I can build it!",
        QUAGMIRE_CASSEROLEDISH = "What does casserole MEAN anyways?",
        QUAGMIRE_CASSEROLEDISH_SMALL = "A mouthful meal.",
        QUAGMIRE_PLATE_SILVER = "That big mouth can't be mad if we serve food on this!",
        QUAGMIRE_BOWL_SILVER = "Fancy.",
        QUAGMIRE_CRATE = "What am I gonna get?",

        QUAGMIRE_MERM_CART1 = "It's probably full of vegetables.", --sammy's wagon
        QUAGMIRE_MERM_CART2 = "Got any ice cream?", --pipton's cart
        QUAGMIRE_PARK_ANGEL = "Nice orb you got there.", -- 3am line, for sure
        QUAGMIRE_PARK_ANGEL2 = "Looks very... judgemental.",
        QUAGMIRE_PARK_URN = "I would never tip them over...",
        QUAGMIRE_PARK_OBELISK = "I hope whoever built it got paid.",
        QUAGMIRE_PARK_GATE =
        {
            GENERIC = "If we had more time I could have broken in.",
            LOCKED = "Let me in! LET ME IN!!", -- :)
        },
        QUAGMIRE_PARKSPIKE = "It's dangerous to jump over.",
        QUAGMIRE_CRABTRAP = "Couldn't they just snap their way out?",
        QUAGMIRE_TRADER_MERM = "Better have something good for sale.",
        QUAGMIRE_TRADER_MERM2 = "Better have something good for sale.",

        QUAGMIRE_GOATMUM = "You remind me of Wickerbottom. You're both old goats!", -- :)
        QUAGMIRE_GOATKID = "Baaaaa!",
        QUAGMIRE_PIGEON =
        {
            DEAD = "I've seen plenty of dead pigeons around my city.",
            GENERIC = "These pests are everywhere.",
            SLEEPING = "Sleeping out in the open? That's dangerous!",
        },
        QUAGMIRE_LAMP_POST = "They had electricity back then?",

        QUAGMIRE_BEEFALO = "This guy's got one foot in the grave.",
        QUAGMIRE_SLAUGHTERTOOL = "I try not to think about where the meat comes from.",

        QUAGMIRE_SAPLING = "Sapped of its twigs.",
        QUAGMIRE_BERRYBUSH = "How's it a berry bush if it grows no berries?",

        QUAGMIRE_ALTAR_STATUE2 = "You can almost hear it going 'baaaaa'.",
        QUAGMIRE_ALTAR_QUEEN = "Hey look! A goat in a coat!",
        QUAGMIRE_ALTAR_BOLLARD = "I could chisel that easily!",
        QUAGMIRE_ALTAR_IVY = "I can't tell what it was supposed to be.",

        QUAGMIRE_LAMP_SHORT = "I wanna touch it.",

        --v2 Winona
        WINONA_CATAPULT =
        {
        	GENERIC = "She's trying to show off.",
        	OFF = "Good. No one out does me when it comes to shooting rocks.",
        	BURNING = "Ha-ha!",
        	BURNT = "Ha-ha! That would NEVER happen to me!",
        },
        WINONA_SPOTLIGHT =
        {
        	GENERIC = "All it does is shine light in my eyes.",
        	OFF = "It can't blind me like this.",
        	BURNING = "Went up like a light!",
        	BURNT = "No big loss.",
        },
        WINONA_BATTERY_LOW =
        {
        	GENERIC = "I wonder if she will use it for anything practical.",
        	LOWPOWER = "Couldn't we just harness the power of the sun?",
        	OFF = "Now it's just a big hunk of metal.",
        	BURNING = "There goes the power!",
        	BURNT = "Looks like it malfunctioned.",
        },
        WINONA_BATTERY_HIGH =
        {
        	GENERIC = "This takes magic down to a mundane level.",
        	LOWPOWER = "I ain't handing over any of my gems when it runs out!",
        	OFF = "Needs more magic.",
        	BURNING = "Magic overload!",
        	BURNT = "Looks like it malfunctioned.",
        },

        --Wormwood
        COMPOSTWRAP = "Gross! Get that out of my face, hollow-head!",
        ARMOR_BRAMBLE = "Maybe NOW people will learn to stay away from me!",
        TRAP_BRAMBLE = "Maybe that hollow-head ain't so bad!",

        BOATFRAGMENT03 = "Woods been chucked.",
        BOATFRAGMENT04 = "Woods been chucked.",
        BOATFRAGMENT05 = "Woods been chucked.",
		BOAT_LEAK = "Stick some gum over it! Quick!",
        MAST = "It makes the boat 'go'.",
        SEASTACK = "Don't rock the boat!",
        FISHINGNET = "I bet I could get a hundred fish in one throw!", --unimplemented OR IS IT????
        ANTCHOVIES = "Bite sized snacks!", --unimplemented
        STEERINGWHEEL = "Out of the way! I'm going to be the captain!",
        ANCHOR = "Dropping it is fun! As long as I don't have to lift it again...",
        BOATPATCH = "It's a band-aid for a boat.",
        DRIFTWOOD_TREE =
        {
            BURNING = "Didn't look like a great source of firewood anyways.",
            BURNT = "Sea ya, tree.",
            CHOPPED = "I coulda knocked it over without an axe!",
            GENERIC = "Another tree. I'm falling asleep over here!",
        },

        DRIFTWOOD_LOG = "Let's burn it!",

        MOON_TREE =
        {
            BURNING = "Moon magic won't save you now!",
            BURNT = "Mutated or not, it burns like the rest!",
            CHOPPED = "Doesn't seem too different from a regular tree.",
            GENERIC = "Let's chop it down and see whats inside!",
        },
		MOON_TREE_BLOSSOM = "I dare you to eat it!",

        MOONBUTTERFLY =
        {
        	GENERIC = "I wonder what goes on in that puny little brain.",
        	HELD = "You'd better not make holes in my clothes!",
        },
		MOONBUTTERFLYWINGS = "Is this what tooth fairy wings look like?",
        MOONBUTTERFLY_SAPLING = "Aw, moth balls.",
        ROCK_AVOCADO_FRUIT = "I don't think it's going to go soft.",
        ROCK_AVOCADO_FRUIT_RIPE = "What kind of person eats this stuff?",
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "Huh, this might actually be good!",
        ROCK_AVOCADO_FRUIT_SPROUT = "I'm growing rocks, and you can't stop me!", -- :)
        ROCK_AVOCADO_BUSH =
        {
        	BARREN = "Aw, this doesn't rock.",
			WITHERED = "I guess rocks don't like the heat.",
			GENERIC = "And thats how rocks are made!", -- spelling that's or thats
			PICKED = "All the ripe rocks have been picked.",
			DISEASED = "I can't tell if this is normal or not.", --unimplemented
            DISEASING = "These rocks are attracting flies.", --unimplemented
			BURNING = "Oh no! My rocks!",
		},
        DEAD_SEA_BONES = "I bet I could play a tune on those bones, like a xylophone!", -- :)
        HOTSPRING =
        {
        	GENERIC = "It's kinda small, isn't it?",
        	BOMBED = "Bomb's away! He-he-he.",
        	GLASS = "I should blow up more things!",
			EMPTY = "It's just a hole.",
        },
        MOONGLASS = "These could do a lot of damage if I slinged em'!",
        MOONGLASS_CHARGED = "They're shaking!",
        MOONGLASS_ROCK = "Tough stuff.",
        BATHBOMB = "Next person who takes a bath gets bombed!",
        TRAP_STARFISH =
        {
            GENERIC = "Alright pinhead, your time is up!",
            CLOSED = "Watch it, pinhead!",
        },
        DUG_TRAP_STARFISH = "You're coming with me, pinhead!",
        SPIDER_MOON =
        {
        	GENERIC = "I want to be mutated next!",
        	SLEEPING = "They think they're safe just because they're scary looking.",
        	DEAD = "I'm not afraid of you!",
        },
        MOONSPIDERDEN = "Looks like one of their queens got squashed!",
		FRUITDRAGON =
		{
			GENERIC = "We have a lot in common. Except being green.",
			RIPE = "You come in RED?!",
			SLEEPING = "Let sleeping salads lie.",
		},
        PUFFIN =
        {
            GENERIC = "Too scared to land closer, huh?",
            HELD = "It's huffing and puffing.",
            SLEEPING = "You shouldn't let your guard down around me.",
        },

		MOONGLASSAXE = "I couldn't be more clear cut if I tried!",
		GLASSCUTTER = "Now THIS is a knife!",

        ICEBERG =
        {
            GENERIC = "Iceburger!", --unimplemented
            MELTED = "It's been sunk!", --unimplemented
        },
        ICEBERG_MELTED = "It's been sunk!", --unimplemented

        MINIFLARE = "I bet I could scare someone with this...",
		MEGAFLARE = "Something about it makes me mad.",

		MOON_FISSURE =
		{
			GENERIC = "Light up my life!",
			NOLIGHT = "Try not to fall in.",
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "Something compels me to complete it!",
            GENERIC = "You're singing my kind of tune!",
        },

        MOON_ALTAR_IDOL = "You want me to *carry* you?",
        MOON_ALTAR_GLASS = "You're asking a lot of me, you know that?",
        MOON_ALTAR_SEED = "Fine, fine, where to?",

        MOON_ALTAR_ROCK_IDOL = "You're coming out whether you like it or not!",
        MOON_ALTAR_ROCK_GLASS = "You're coming out whether you like it or not!",
        MOON_ALTAR_ROCK_SEED = "You're coming out whether you like it or not!",

        MOON_ALTAR_CROWN = "If I help you, it better be worth it.",
        MOON_ALTAR_COSMIC = "What? Yeah, I'm listening. Totally.",

        MOON_ALTAR_ASTRAL = "Am I done yet? ...I think I'm done.",
        MOON_ALTAR_ICON = "Quit pestering me!",
        MOON_ALTAR_WARD = "Don't rush me!",

        SEAFARING_PROTOTYPER =
        {
            GENERIC = "Land or sea, nothing is safe from me!",
            BURNT = "No way that is seaworthy.",
        },
        BOAT_ITEM = "Just a little manual labor.",
        BOAT_GRASS_ITEM = "Ha-ha! This will NEVER float!",
        STEERINGWHEEL_ITEM = "I'll steer the boat!",
        ANCHOR_ITEM = "Huh, it doesn't seem that heavy.",
        MAST_ITEM = "The wind will work for us.",
        MUTATEDHOUND =
        {
        	DEAD = "Now it's extra dead.",
        	GENERIC = "I wish I could turn inside out...",
        	SLEEPING = "Is it dead yet?",
        },

        MUTATED_PENGUIN =
        {
			DEAD = "How was it alive in the first place?",
			GENERIC = "That heart makes a good bullseye!",
			SLEEPING = "Are you dead yet? No?",
		},
        CARRAT =
        {
        	DEAD = "Is it okay to eat now?",
        	GENERIC = "Food shouldn't run away!",
        	HELD = "I can feel it squirming in my pocket.",
        	SLEEPING = "Now it's just like a regular old carrot.",
        },

		BULLKELP_PLANT =
        {
            GENERIC = "What a slimeball.",
            PICKED = "It's useless now.",
        },
		BULLKELP_ROOT = "What a load of bullkelp!",
        KELPHAT = "It's going to get tangled in my hair! Gross!",
		KELP = "Is this edible?",
		KELP_COOKED = "Most of the slime has been cooked off.",
		KELP_DRIED = "I've seen this stuff at the downtown markets, but I've never tried it before.",

		GESTALT = "What's that? Speak up!",
        GESTALT_GUARD = "What did shadow magic ever do to you?",

		COOKIECUTTER = "That's one mean cookie!",
		COOKIECUTTERSHELL = "That's how the cookie crumbles!",
		COOKIECUTTERHAT = "Go ahead, hit me! See what happens!",
		SALTSTACK =
		{
			GENERIC = "Is that a... person? No, don't think about it too much...",
			MINED_OUT = "Well, whatever it was, it's been smashed now.",
			GROWING = "More salt for me!",
		},
		SALTROCK = "Definetly not sugar.",
		SALTBOX = "It's for making food taste saltier, I think.",

		TACKLESTATION = "Tackle? I'll show you what a real tackle looks like!",
		TACKLESKETCH = "And this is going to help me tackle... how?",

        MALBATROSS = "Shut your gullet!",
        MALBATROSS_FEATHER = "I could get some serious air time with these!",
        MALBATROSS_BEAK = "I shut its gullet for good!",
        MAST_MALBATROSS_ITEM = "This will help me fly for sure!",
        MAST_MALBATROSS = "What do you MEAN it won't fly?!",
		MALBATROSS_FEATHERED_WEAVE = "Only the finest canvas will do!",

        GNARWAIL =
        {
            GENERIC = "I should hang a carrot off that horn, see if it swims in circles.",
            BROKENHORN = "You didn't need it in the first place!",
            FOLLOWER = "Careful who you hit with that horn.",
            BROKENHORN_FOLLOWER = "You'd be more helpful with a horn.",
        },
        GNARWAIL_HORN = "It's hardly even sharp!",

        WALKINGPLANK = "Walk the plank, fools!",
        WALKINGPLANK_GRASS = "Walk the plank, fools!",
        OAR = "I don't mind a bit of hard labor, but I'd prefer a sail.",
		OAR_DRIFTWOOD = "I don't mind a bit of hard labor, but I'd prefer a sail.",

		OCEANFISHINGROD = "Nice and sturdy. I want to catch a shark!",
		OCEANFISHINGBOBBER_NONE = "It's not very eye catching.",
        OCEANFISHINGBOBBER_BALL = "Is a fish really going to fall for this?",
        OCEANFISHINGBOBBER_OVAL = "Less round, more pointy.",
		OCEANFISHINGBOBBER_CROW = "Early bird gets the fish, right?",
		OCEANFISHINGBOBBER_ROBIN = "Early bird gets the fish, right?",
		OCEANFISHINGBOBBER_ROBIN_WINTER = "Early bird gets the fish, right?",
		OCEANFISHINGBOBBER_CANARY = "Early bird gets the fish, right?",
		OCEANFISHINGBOBBER_GOOSE = "I've got their goose!",
		OCEANFISHINGBOBBER_MALBATROSS = "That big dope was good for something!",

		OCEANFISHINGLURE_SPINNER_RED = "You'd have to have a peanut brain to fall for this!",
		OCEANFISHINGLURE_SPINNER_GREEN = "You'd have to have a peanut brain to fall for this!",
		OCEANFISHINGLURE_SPINNER_BLUE = "You'd have to have a peanut brain to fall for this!",
		OCEANFISHINGLURE_SPOON_RED = "Hey, that's not a spoon!",
		OCEANFISHINGLURE_SPOON_GREEN = "Hey, that's not a spoon!",
		OCEANFISHINGLURE_SPOON_BLUE = "Hey, that's not a spoon!",
		OCEANFISHINGLURE_HERMIT_RAIN = "Don't fish hate the rain?",
		OCEANFISHINGLURE_HERMIT_SNOW = "Nothing like a cold fish.",
		OCEANFISHINGLURE_HERMIT_DROWSY = "This fishing stuff is putting me to sleep...",
		OCEANFISHINGLURE_HERMIT_HEAVY = "I hope it doesn't sink.",

		OCEANFISH_SMALL_1 = "It's barely even bite sized!",
		OCEANFISH_SMALL_2 = "Get lost, squirt!",
		OCEANFISH_SMALL_3 = "Bait gets bit!",
		OCEANFISH_SMALL_4 = "It might shrink out of existance if I fry it.",
		OCEANFISH_SMALL_5 = "Pop it in your mouth!",
		OCEANFISH_SMALL_6 = "What an ugly little thing.",
		OCEANFISH_SMALL_7 = "I think its brain was replaced with a flower.",
		OCEANFISH_SMALL_8 = "That thing is going to burn a hole in my pocket!",
        OCEANFISH_SMALL_9 = "Yes! Show them how it's done!",

		OCEANFISH_MEDIUM_1 = "You LIVE in the OCEAN. How can you not wash yourself?!",
		OCEANFISH_MEDIUM_2 = "The horrors it must have seen in the deep.",
		OCEANFISH_MEDIUM_3 = "Yeah, a real dandy.",
		OCEANFISH_MEDIUM_4 = "Bad luck is for suckers!", 
		OCEANFISH_MEDIUM_5 = "Can't we just throw this one back?",
		OCEANFISH_MEDIUM_6 = "You don't look like anything special.",
		OCEANFISH_MEDIUM_7 = "You don't look like anything special.",
		OCEANFISH_MEDIUM_8 = "It's hard to keep hold!",
        OCEANFISH_MEDIUM_9 = "For the fishy chowder, we have the fishy fish!", --GET IT?? SWEDISH FISH?? my references are impeccable 

		PONDFISH = "It'll have to do.",
		PONDEEL = "Eeling lucky, punk?",

        FISHMEAT = "It kinda smells.",
        FISHMEAT_COOKED = "Yup, still smells.",
        FISHMEAT_SMALL = "Better than nothing.",
        FISHMEAT_SMALL_COOKED = "Perfectly grilled!",
		SPOILED_FISH = "It smells like an old garbage filled shoe.",

		FISH_BOX = "It will keep the smell contained.",
        POCKET_SCALE = "Who cares about their weight? Just eat them!",

		TACKLECONTAINER = "It's got room for all sorts of useless trinkets.",
		SUPERTACKLECONTAINER = "If only something useful could be stored inside...",

		TROPHYSCALE_FISH =
		{
			GENERIC = "Doesn't look like a comfortable place to live.",
			HAS_ITEM = "Weight: {weight}\nCaught by: {owner}",
			HAS_ITEM_HEAVY = "Weight: {weight}\nCaught by: {owner}\nCan we eat it now?",
			BURNING = "No regrets.",
			BURNT = "It was already a waste of supplies, now it's free charcoal.",
			OWNER = "I'm the master fisher around here!\nWeight: {weight}\nCaught by: {owner}",
			OWNER_HEAVY = "Weight: {weight}\nCaught by: {owner}\nNow, on to the grill!",
		},

		OCEANFISHABLEFLOTSAM = "It's just dirt. And mud. And garbage.",

		CALIFORNIAROLL = "Bite sized bits of fish.",
		SEAFOODGUMBO = "The skeleton adds flavor.",
		SURFNTURF = "Perfect for building muscles.",

        WOBSTER_SHELLER = "Natural armor, claws for hands, it's the perfect animal!",
        WOBSTER_DEN = "It's their armored fortress.",
        WOBSTER_SHELLER_DEAD = "I have conquered natures perfect beast.",
        WOBSTER_SHELLER_DEAD_COOKED = "Now I will eat it, and gain its power!",

        LOBSTERBISQUE = "Fish soup. It doesn't sound appetizing when you say it out loud.",
        LOBSTERDINNER = "Who needs a fancy chef anyways?",

        WOBSTER_MOONGLASS = "You can see all the meat squirming around inside.",
        MOONGLASS_WOBSTER_DEN = "How'd the glass get stuck in there anyways?",

		TRIDENT = "Ain't I a lil' devil?",

		WINCH =
		{
			GENERIC = "Let's rob the ocean of its treasure!",
			RETRIEVING_ITEM = "Better be something good...",
			HOLDING_ITEM = "What did we get?",
		},

        HERMITHOUSE = {
            GENERIC = "This house is rubbish!",
            BUILTUP = "Now make with the cookies, granny!",
        },

        SHELL_CLUSTER = "Maybe there is something valuable inside.",
        --
		SINGINGSHELL_OCTAVE3 =
		{
			GENERIC = "A cool {note}, I think.",
		},
		SINGINGSHELL_OCTAVE4 =
		{
			GENERIC = "Yep, it's a {note}.",
		},
		SINGINGSHELL_OCTAVE5 =
		{
			GENERIC = "A hot {note}!",
        },

        CHUM = "Talk about bad taste.",

        SUNKENCHEST =
        {
            GENERIC = "I'd hate to get caught in those jaws.",
            LOCKED = "Open up you stupid clam!",
        },

        HERMIT_BUNDLE = "Got any candy? No?",
        HERMIT_BUNDLE_SHELLS = "That's it? Shells? Really?",

        RESKIN_TOOL = "Aw, I hate cleaning!",
        MOON_FISSURE_PLUGGED = "She's turned moon magic into music!",


		----------------------- ROT STRINGS GO ABOVE HERE ------------------

		-- Walter
        WOBYBIG =
        {
            "Quit slobbering, mutt.",
            "Keep to yourself, flea-bag.",
        },
        WOBYSMALL =
        {
            "Quit slobbering, mutt.",
            "Keep to yourself, flea-bag.",
        },
		WALTERHAT = "It looks like a dunce cap.",
		SLINGSHOT = "Perfect for long distance harassment.",
		SLINGSHOT_MATILDA = "Third time's the charm!",
		SLINGSHOT_GNASHER = "You're barking up the wrong tree!",
		SLINGSHOTAMMO_ROCK = "It's more annoying than anything.",
		SLINGSHOTAMMO_MARBLE = "These will knock the wind out of them!",
		SLINGSHOTAMMO_THULECITE = "Perfect for the 'other' kind of cursing.",
        SLINGSHOTAMMO_GOLD = "I always spread the love around!",
        SLINGSHOTAMMO_SLOW = "This shadow magic stuff is pretty neat!",
        SLINGSHOTAMMO_FREEZE = "This will freeze them in their tracks!",
		SLINGSHOTAMMO_POOP = "Nothing could keep focused smelling like this!",
		
        SLINGSHOTAMMO_FIRECRACKERS = "This is my kind of party!",
        SLINGSHOTAMMO_HONEY = "That should slow them down!",
        SLINGSHOTAMMO_RUBBER = "I put a rock in the center as a prank.",
        SLINGSHOTAMMO_TREMOR = "Portable earthquakes!",
        SLINGSHOTAMMO_MOONROCK = "The shadows don't seem to like this stuff.",
        SLINGSHOTAMMO_MOONGLASS = "I should watch my fingers when launching these.",
        SLINGSHOTAMMO_SALT = "I'm all for rubbing salt in wounds.",
        SLINGSHOTAMMO_TAR = "Gross, it's getting on my hands!",
        SLINGSHOTAMMO_OBSIDIAN = "A fire safety hazard? Well of course, that's the point!",
        SLINGSHOTAMMO_GOOP = "But I don't wanna share!",
        SLINGSHOTAMMO_SLIME = "Don't get it in my hair!",
        SLINGSHOTAMMO_LAZY = "Catch me if you can!",
        SLINGSHOTAMMO_SHADOW = "I'm in control! And don't you forget it!",
		
        COCONUT = "Careful you don't get clonked on the head!",
		
        PORTABLETENT = "Atleast it's not a two person tent...",
        PORTABLETENT_ITEM = "I'm fine with a sleeping bag, honest.",

        -- Wigfrid
        BATTLESONG_DURABILITY = "This is ametuer stuff!",
        BATTLESONG_HEALTHGAIN = "This is ametuer stuff!",
        BATTLESONG_SANITYGAIN = "This is ametuer stuff!",
        BATTLESONG_SANITYAURA = "This is ametuer stuff!",
        BATTLESONG_FIRERESISTANCE = "Fire proof indeed.",
        BATTLESONG_INSTANT_TAUNT = "Her vocabulary is... lacking.",
        BATTLESONG_INSTANT_PANIC = "Any song would make people panic with how awful she sings.",

        -- Webber
        MUTATOR_WARRIOR = "Are these made of mud? What are you, five?",
        MUTATOR_DROPPER = "I'd rather eat dirt.",
        MUTATOR_HIDER = "Are these made of mud? What are you, five?",
        MUTATOR_SPITTER = "I'd rather eat dirt.",
        MUTATOR_MOON = "Are these made of mud? What are you, five?",
        MUTATOR_HEALER = "I'd rather eat dirt.",
        SPIDER_WHISTLE = "Don't call those creeps over here!",
        SPIDERDEN_BEDAZZLER = "That spider kid needs to grow up.",
        SPIDER_HEALER = "Don't get your goop on me!",
        SPIDER_REPELLENT = "Can it keep them away for good?",
        SPIDER_HEALER_ITEM = "This is useless to me!",

		-- Wendy
		GHOSTLYELIXIR_SLOWREGEN = "Seem's like a waste of good materials.",
		GHOSTLYELIXIR_FASTREGEN = "Seem's like a waste of good materials.",
		GHOSTLYELIXIR_SHIELD = "Seem's like a waste of good materials.",
		GHOSTLYELIXIR_ATTACK = "Seem's like a waste of good materials.",
		GHOSTLYELIXIR_SPEED = "Seem's like a waste of good materials.",
		GHOSTLYELIXIR_RETALIATION = "Seem's like a waste of good materials.",
		SISTURN =
		{
			GENERIC = "Whose wasting their time with pottery?",
			SOME_FLOWERS = "Whats with the flowers?",
			LOTS_OF_FLOWERS = "Boring!",
		},

        --Wortox
--fallback to speech_wilson.lua         WORTOX_SOUL = "only_used_by_wortox", --only wortox can inspect souls

        PORTABLECOOKPOT_ITEM =
        {
            GENERIC = "Does looking fancy make food taste any better?",
            DONE = "Dibs on the food!",

			COOKING_LONG = "Can't I just turn the heat up? This is taking forever!",
			COOKING_SHORT = "Hurry up already!",
			EMPTY = "What's cookin'? Oh, it's nothing.",
        },

        PORTABLEBLENDER_ITEM = "It crushes things.",
        PORTABLESPICER_ITEM =
        {
            GENERIC = "A little extra flavour never hurt anyone.",
            DONE = "Mmm, looks good!",
        },
        SPICEPACK = "It's not a stupid hat, it's a stupid bag!",
        SPICE_GARLIC = "One of the essentials.",
        SPICE_SUGAR = "I'm told I get hyper active when I eat too much sugar.",
        SPICE_CHILI = "Let's turn up the heat!",
        SPICE_SALT = "It brings out the flavor, somehow.",
        MONSTERTARTARE = "It's some kind of disgusting delicacy.",
        FRESHFRUITCREPES = "What a load of crepe!",
        FROGFISHBOWL = "It's got a health coating of slime.",
        POTATOTORNADO = "Very fancy, it even comes with a tooth pick!",
        DRAGONCHILISALAD = "If it wasn't so delicious, I would think he's trying to kill us!",
        GLOWBERRYMOUSSE = "I'm pretty sure this is radioactive.",
        VOLTGOATJELLY = "This feels like something you'd buy at a joke shop!",
        NIGHTMAREPIE = "I hope it won't scream when I eat it.",
        BONESOUP = "You're not supposed to eat the bone, right?",
        MASHEDPOTATOES = "I didn't think mashed potatoes could be fancy.",
        POTATOSOUFFLE = "It better not blow up in my face.",
        MOQUECA = "Moqueca, la biblioteca.",
        GAZPACHO = "Asparagus juice? Really?",
        ASPARAGUSSOUP = "Where's the main course?",
        VEGSTINGER = "It's got a nice zing to it.",
        BANANAPOP = "I don't really need the stick...",
        CEVICHE = "Edible goop.",
        SALSA = "I can't help but double dip if I only get one chip!",
        PEPPERPOPPER = "It's got some kick!",

        TURNIP = "I like vegetables with a good heft.",
        TURNIP_COOKED = "I think it's edible now.",
        TURNIP_SEEDS = "More boring seeds.",

        GARLIC = "It's probably poisonous unless you cook it.",
        GARLIC_COOKED = "I'm tempted to eat it whole.",
        GARLIC_SEEDS = "More boring seeds.",

        ONION = "It's got layers.",
        ONION_COOKED = "I've got something in my eye! I swear!",
        ONION_SEEDS = "More boring seeds.",

        POTATO = "You say potato, I say ammo.",
        POTATO_COOKED = "The most boring of all vegetables.",
        POTATO_SEEDS = "More boring seeds.",

        TOMATO = "I'll throw it at the mime next time he preforms.",
        TOMATO_COOKED = "It was hard to cook with all the juice.",
        TOMATO_SEEDS = "More boring seeds.",

        ASPARAGUS = "Don't eat it raw, I learned that the hard way...",
        ASPARAGUS_COOKED = "It's one of my favorites!",
        ASPARAGUS_SEEDS = "More boring seeds.",

        PEPPER = "It might kill me if I eat it.",
        PEPPER_COOKED = "Extra hot and spicy!",
        PEPPER_SEEDS = "More boring seeds.",

        WEREITEM_BEAVER = "It looks like a beaver carved it.",
        WEREITEM_GOOSE = "I... I don't even know what this is supposed to be.",
        WEREITEM_MOOSE = "Awful woodwork, just awful...",

        MERMHAT = "I can disguise myself as a drooling moron.",
        MERMTHRONE =
        {
            GENERIC = "The fish are trying to play \"people\".",
            BURNT = "It was never going to last.",
        },
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "Maybe if they put all their heads together they can make something useful.",
            BURNT = "I think they discovered fire.",
        },
        MERMHOUSE_CRAFTED =
        {
            GENERIC = "Quaint.",
            BURNT = "Tried to light a fire inside, I presume.",
        },

        MERMWATCHTOWER_REGULAR = "Why do fish need houses?",
        MERMWATCHTOWER_NOKING = "No way they built it themselves.",
        MERMKING = "You get to be in charge if you're fat enough, apparently.",
        MERMGUARD = "Yeah, you're real tough pal.",
        MERM_PRINCE = "It's a \"finders keepers\" type of society.",

        SQUID = "Don't get your ink on me!",

		GHOSTFLOWER = "Speak up or I'll stomp all over you!",
        SMALLGHOST = "I probably shouldn't make jokes.",

        CRABKING =
        {
            GENERIC = "He's snapped!",
            INERT = "No way that's natural.",
        },
		CRABKING_CLAW = "Don't get snippy!",

		MESSAGEBOTTLE = "Better be something good.",
		MESSAGEBOTTLEEMPTY = "It might be fun to break!",

        MEATRACK_HERMIT =
        {
            DONE = "Jerky's done... jerk.",
            DRYING = "It's begun the process of becoming a jerk.",
            DRYINGINRAIN = "It can't dry in the rain!",
            GENERIC = "For making a jerk extra jerky!",
            BURNT = "Whose the jerk who burnt it?",
            DONE_NOTMEAT = "Hey! Lady! You'd better get this before I take it!",
            DRYING_NOTMEAT = "It's begun the process of becoming a jerk.",
            DRYINGINRAIN_NOTMEAT = "It can't dry in the rain!",
        },
        BEEBOX_HERMIT =
        {
            READY = "She's got them running a racket!",
            FULLHONEY = "She's got them running a racket!",
            GENERIC = "How can they stand all that crowding around?",
            NOHONEY = "...Work harder!",
            SOMEHONEY = "They could be working harder.",
            BURNT = "Smoked out!",
        },

        HERMITCRAB = "I'm not too fond of you either, you old wind bag!",

        HERMIT_PEARL = "Bad idea to let me have this.",
        HERMIT_CRACKED_PEARL = "She shouldn't have trusted me with it!",

        -- DSEAS
        WATERPLANT = "It's guarding a delicious treasure.",
        WATERPLANT_BOMB = "Watch where you're spitting those!",
        WATERPLANT_BABY = "It's a veritable bouquet of barnacles!",
        WATERPLANT_PLANTER = "Now where should I plant these...",

        SHARK = "You're swimming in MY waters!",

        MASTUPGRADE_LAMP_ITEM = "Better than sailing in the dark.",
        MASTUPGRADE_LIGHTNINGROD_ITEM = "Is it safe to be so close to a lightning rod?",

        WATERPUMP = "The \"scientist\" is trying to take credit for things that already exist.",

        BARNACLE = "They were expensive back home, but now I can eat as many as I want!",
        BARNACLE_COOKED = "Definetly over priced.",

        BARNACLEPITA = "It can hardly hold all of them!",
        BARNACLESUSHI = "No one can say I'm not sophisticated!",
        BARNACLINGUINE = "I could eat ten bowls of this stuff!",
        BARNACLESTUFFEDFISHHEAD = "This is just... trash.",

        LEAFLOAF = "It's got a bland, musty taste.",
        LEAFYMEATBURGER = "Wish I had a side of onion rings...",
        LEAFYMEATSOUFFLE = "No matter how much I shake it, it won't fall apart!",
        MEATYSALAD = "If I keep eating it I'll be the strongest around!",

        -- GROTTO

		MOLEBAT = "PFFFT-HAHAHA! LOOK AT ITS NOSE! HAHAHAHA!!",
        MOLEBATHILL = "Pfft, I could do better...",

        BATNOSE = "Alright, jokes over, I got it out of my system...",
        BATNOSE_COOKED = "I think I cooked all the snot out.",
        BATNOSEHAT = "Just like the ones at the baseball stadium!",

        MUSHGNOME = "Hey! Stop being so jaunty!",

        SPORE_MOON = "Looks unstable!",

        MOON_CAP = "That can't be safe to eat.",
        MOON_CAP_COOKED = "Maybe it's safe now?",

        MUSHTREE_MOON = "Looks kinda... tacky.",

        LIGHTFLIER = "Hey, watch it! No crowding!",

        GROTTO_POOL_BIG = "No way I'm drinking that stuff!",
        GROTTO_POOL_SMALL = "No way I'm drinking that stuff!",

        DUSTMOTH = "Gee, you sure look sad! ...Anyways, bye!",

        DUSTMOTHDEN = "That can't SERIOUSLY be how that stuff is made, right?",

        ARCHIVE_LOCKBOX = "Maybe if I stare at it long enough I'll get smarter...",
        ARCHIVE_CENTIPEDE = "Bug off!",
        ARCHIVE_CENTIPEDE_HUSK = "Busted and blue.",

        ARCHIVE_COOKPOT =
        {
            COOKING_LONG = "Can't I just turn the heat up? This is taking forever!",
			COOKING_SHORT = "Hurry up already!",
			DONE = "Time to eat!",
			EMPTY = "Empty as these ruins.",
			BURNT = "I meant to do that. It's an acquired taste.",
        },

        ARCHIVE_MOON_STATUE = "Looks like they carried rocks around. Neat.",
        ARCHIVE_RUNE_STATUE =
        {
            LINE_1 = "I don't care what it says.",
            LINE_2 = "Blah blah blah.",
            LINE_3 = "I don't care what it says.",
            LINE_4 = "Blah blah blah.",
            LINE_5 = "I don't care what it says.",
        },

        ARCHIVE_RESONATOR = {
            GENERIC = "Fine, show me the way!",
            IDLE = "Was that it? Nothing left?",
        },

        ARCHIVE_RESONATOR_ITEM = "It's uh... one of those fancy... things.",

        ARCHIVE_LOCKBOX_DISPENCER = {
          POWEROFF = "Got anything for me? No?",
          GENERIC =  "I wonder if they gathered around these to have mundane conversations.",
        },

        ARCHIVE_SECURITY_DESK = {
            POWEROFF = "It's art. I think.",
            GENERIC = "Is this a threat?",
        },

        ARCHIVE_SECURITY_PULSE = "I'm not sure if this is a good or bad thing...",

        ARCHIVE_SWITCH = {
            VALID = "Well, I'm stumped.",
            GEMS = "Who knew magic was so picky?",
        },

        ARCHIVE_PORTAL = {
            POWEROFF = "Can't wait to see whats through it!",
            GENERIC = "Stupid portal! Wake up!",
        },

        WALL_STONE_2 = "It's a wall.",
        WALL_RUINS_2 = "It's an extra special wall.",

        REFINED_DUST = "It's a compact brick of dust.",
        DUSTMERINGUE = "Maybe I can feed it to one of those sad looking moths",

        SHROOMCAKE = "Mushrooms and cake do NOT mix.",

        NIGHTMAREGROWTH = "I've felt this before...",

        TURFCRAFTINGSTATION = "ALL THAT JUST FOR DIRT? ARE YOU KIDDING ME?!",

        MOON_ALTAR_LINK = "It's a big ball of energy, just sitting there. Doing nothing.",

        -- FARMING
        COMPOSTINGBIN =
        {
            GENERIC = "I'll steer clear, thanks.",
            WET = "It's all wet and gross.",
            DRY = "It's dried up.",
            BALANCED = "This is the best recipe for garbage you'll ever see!",
            BURNT = "So much for recycling.",
        },
        COMPOST = "Gross.",
        SOIL_AMENDER =
		{
			GENERIC = "It needs time to ferment.",
			STALE = "Waiting... waiting...",
			SPOILED = "Still waiting...",
		},

		SOIL_AMENDER_FERMENTED = "Done!",

        WATERINGCAN =
        {
            GENERIC = "I'll try not to drown the plants.",
            EMPTY = "Now where can I find some water...",
        },
        PREMIUMWATERINGCAN =
        {
            GENERIC = "Can it whistle a tune, or does it just spout water?",
            EMPTY = "Don't expect me to fetch any sparkling water.",
        },

		FARM_PLOW = "By all means, do all the hard work for me!",
		FARM_PLOW_ITEM = "It does all the work for me!",
		FARM_HOE = "And here I thought all the hard work was done...",
		GOLDEN_FARM_HOE = "It's going to look great planted in the dirt!",
		NUTRIENTSGOGGLESHAT = "Can't I just take the monocle off? Do I need to stick the pot on my head?",
		PLANTREGISTRYHAT = "Magic works in mysterious ways.",

        FARM_SOIL_DEBRIS = "Who tipped their junk in my garden?",

		FIRENETTLES = "I think it's burning a hole in my pocket!",
		FORGETMELOTS = "When did I pick these up?",
		SWEETTEA = "Have I tried it before?",
		TILLWEED = "All it does is take up space.",
		TILLWEEDSALVE = "And how is this supposed to help?",
        WEED_IVY = "Touch me and I'll uproot you!",
        IVY_SNARE = "Hey! Hands off!",

		TROPHYSCALE_OVERSIZEDVEGGIES =
		{
			GENERIC = "Who cares?",
			HAS_ITEM = "Weight: {weight}\nHarvested on day: {day}\nYup, it's a vegetable.",
			HAS_ITEM_HEAVY = "Weight: {weight}\nHarvested on day: {day}\nI could eat for a week!",
            HAS_ITEM_LIGHT = "Did someone hollow it out?",
			BURNING = "It makes for a great bonfire!",
			BURNT = "I'd give it a ten for flammability!",
        },

        CARROT_OVERSIZED = "I didn't know carrots came in more colors!",
        CORN_OVERSIZED = "I don't care what colors it comes in, I still don't like it!",
        PUMPKIN_OVERSIZED = "Sing me a song, O' Great Pumpkin!",
        EGGPLANT_OVERSIZED = "Smells peppery.",
        DURIAN_OVERSIZED = "Maybe now people will stay away.",
        POMEGRANATE_OVERSIZED = "I sense a great evil emanating from it.",
        DRAGONFRUIT_OVERSIZED = "I'm hoarding it all to myself!",
        WATERMELON_OVERSIZED = "Imagine the mess it would make if we smashed it!",
        TOMATO_OVERSIZED = "I'll save it for the mimes next big performance.",
        POTATO_OVERSIZED = "Peeling it would take hours!",
        ASPARAGUS_OVERSIZED = "How the heck are we supposed to cook THAT?",
        ONION_OVERSIZED = "Oh, I thought it was an eggplant for a second there.",
        GARLIC_OVERSIZED = "I like the braids!",
        PEPPER_OVERSIZED = "Quite the peppy pepper!",

        VEGGIE_OVERSIZED_ROTTEN = "Aw, now it's just a giant waste of my time!",

		FARM_PLANT =
		{
			GENERIC = "A boring old plant.",
			SEED = "You'd better grow into something good!",
			GROWING = "Good, keep it up!",
			FULL = "My hard work pays off!",
			ROTTEN = "Hey! I didn't plant garbage!",
			FULL_OVERSIZED = "Let's feast!",
			ROTTEN_OVERSIZED = "Its a giant waste!",
			FULL_WEED = "Hey! Get out of here you jerk!",

			BURNING = "We grew a fire!",
		},

        FRUITFLY = "Get away from my food!",
        LORDFRUITFLY = "You ain't lording over MY work!",
        FRIENDLYFRUITFLY = "You work for me now!",
        FRUITFLYFRUIT = "Sometimes all it takes is a good bribe.",

        SEEDPOUCH = "It's got a lot of pockets.",

		-- Crow Carnival
		CARNIVAL_HOST = "Put an apple on your head, then we'll play a REAL carnival game.",
		CARNIVAL_CROWKID = "Let's play kick the crow!",
		CARNIVAL_GAMETOKEN = "Let's see if I can't cheat a few games.",
		CARNIVAL_PRIZETICKET =
		{
			GENERIC = "I can't get anything good with this!",
			GENERIC_SMALLSTACK = "Go big or go home! More tickets!",
			GENERIC_LARGESTACK = "This had better be worth it.",
		},

		CARNIVALGAME_FEEDCHICKS_NEST = "What are you hiding?",
		CARNIVALGAME_FEEDCHICKS_STATION =
		{
			GENERIC = "I don't think the old coin on a string trick will work.",
			PLAYING = "Gah! Shut up you dumb birds!",
		},
		CARNIVALGAME_FEEDCHICKS_KIT = "Where will it annoy me the least...",
		CARNIVALGAME_FEEDCHICKS_FOOD = "Hey, I can't eat these!",

		CARNIVALGAME_MEMORY_KIT = "Where will it annoy me the least...",
		CARNIVALGAME_MEMORY_STATION =
		{
			GENERIC = "I don't think the old coin on a string trick will work.",
			PLAYING = "My brain is as sharp as a... uh... sharp thing!",
		},
		CARNIVALGAME_MEMORY_CARD =
		{
			GENERIC = "What are you hiding?",
			PLAYING = "Was it that one? I think it was...",
		},

		CARNIVALGAME_HERDING_KIT = "Where will it annoy me the least...",
		CARNIVALGAME_HERDING_STATION =
		{
			GENERIC = "I don't think the old coin on a string trick will work.",
			PLAYING = "Hey! Listen to me!",
		},
		CARNIVALGAME_HERDING_CHICK = "Do I have to TOSS you in?",

		CARNIVALGAME_SHOOTING_KIT = "Where will it annoy me the least...",
		CARNIVALGAME_SHOOTING_STATION =
		{
			GENERIC = "I don't think the old coin on a string trick will work.",
			PLAYING = "I'm the sharpest shooter you will ever see!",
		},
		CARNIVALGAME_SHOOTING_TARGET =
		{
			GENERIC = "What are you hiding?",
			PLAYING = "You're about to get squashed!",
		},

		CARNIVALGAME_SHOOTING_BUTTON =
		{
			GENERIC = "I don't think the old coin on a string trick will work.",
			PLAYING = "Mash the button!",
		},

		CARNIVALGAME_WHEELSPIN_KIT = "Where will it annoy me the least...",
		CARNIVALGAME_WHEELSPIN_STATION =
		{
			GENERIC = "I don't think the old coin on a string trick will work.",
			PLAYING = "I'm the best at random chance games.",
		},

		CARNIVALGAME_PUCKDROP_KIT = "Where will it annoy me the least...",
		CARNIVALGAME_PUCKDROP_STATION =
		{
			GENERIC = "I don't think the old coin on a string trick will work.",
			PLAYING = "This is just luck! Can I atleast tilt the machine?",
		},

		CARNIVAL_PRIZEBOOTH_KIT = "Where will it annoy me the least...",
		CARNIVAL_PRIZEBOOTH =
		{
			GENERIC = "It's not being guarded very well.",
		},

		CARNIVALCANNON_KIT = "BOOM!",
		CARNIVALCANNON =
		{
			GENERIC = "Let's see how much damage it can cause!",
			COOLDOWN = "Was that it?!",
		},

		CARNIVAL_PLAZA_KIT = "Just another tree...",
		CARNIVAL_PLAZA =
		{
			GENERIC = "A few bells and whistles.",
			LEVEL_2 = "It's got a few baubles now.",
			LEVEL_3 = "Real fancy looking.",
		},

		CARNIVALDECOR_EGGRIDE_KIT = "Where will it annoy me the least...",
		CARNIVALDECOR_EGGRIDE = "Those eggs sure look like they are having fun.",

		CARNIVALDECOR_LAMP_KIT = "Where will it annoy me the least...",
		CARNIVALDECOR_LAMP = "Mundane magic.",
		CARNIVALDECOR_PLANT_KIT = "Where will it annoy me the least...",
		CARNIVALDECOR_PLANT = "Don't expect me to take care of it.",
		CARNIVALDECOR_BANNER_KIT = "Where will it annoy me the least...",
		CARNIVALDECOR_BANNER = "How dumb... and shiny...",

		CARNIVALDECOR_FIGURE =
		{
			RARE = "Seems rare. Worthless, but rare.",
			UNCOMMON = "So... is it worth anything?",
			GENERIC = "This is a scam!",
		},
		CARNIVALDECOR_FIGURE_KIT = "What am I gonna get?",
		CARNIVALDECOR_FIGURE_KIT_SEASON2 = "What am I gonna get?",

        CARNIVAL_BALL = "I'm ballin!!!", --unimplemented
		CARNIVAL_SEEDPACKET = "Fitting, birds are always dropping these things.",
		CARNIVALFOOD_CORNTEA = "I think I'm going to be sick...",

        CARNIVAL_VEST_A = "Ugh... I look like some kind of scout...",
        CARNIVAL_VEST_B = "It's light and feathery",
        CARNIVAL_VEST_C = "It's kind of comfy!",

        -- YOTB
        YOTB_SEWINGMACHINE = "I've always done it by hand.",
        YOTB_SEWINGMACHINE_ITEM = "I've never used one before.",
        YOTB_STAGE = "I should be the one judging!",
        YOTB_POST =  "Atleast they will stay away from me now.",
        YOTB_STAGE_ITEM = "I'll reserve a spot for myself.",
        YOTB_POST_ITEM =  "It's just a stick in the ground.",


        YOTB_PATTERN_FRAGMENT_1 = "Hey, it's incomplete!",
        YOTB_PATTERN_FRAGMENT_2 = "Hey, it's incomplete!",
        YOTB_PATTERN_FRAGMENT_3 = "Hey, it's incomplete!",

        YOTB_BEEFALO_DOLL_WAR = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_DOLL = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_FESTIVE = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_NATURE = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_ROBOT = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_ICE = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_FORMAL = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_VICTORIAN = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },
        YOTB_BEEFALO_DOLL_BEAST = {
            GENERIC = "I'm proud of my knit work!",
            YOTB = "Now I can show off my designs!",
        },

        WAR_BLUEPRINT = "Always ready for a fight!",
        DOLL_BLUEPRINT = "It's going to look like a primped up idiot!",
        FESTIVE_BLUEPRINT = "Looks like the whole carnival!",
        ROBOT_BLUEPRINT = "I've always got the future in mind.",
        NATURE_BLUEPRINT = "It looks overgrown.",
        FORMAL_BLUEPRINT = "It's a great costume, if you want to look like a pompous jerk!",
        VICTORIAN_BLUEPRINT = "I've seen stuff like this in dress shops back home.",
        ICE_BLUEPRINT = "They would only LOOK cold. I think.",
        BEAST_BLUEPRINT = "Fearsome! Think fearsome!",

        BEEF_BELL = "Hey, is this annoying? Is it annoying when I ring it?",
	
		-- YOT Catcoon
		KITCOONDEN = 
		{
			GENERIC = "Seems kinda small.",
            BURNT = "Well, atleast it's still standing.",
			PLAYING_HIDEANDSEEK = "Where'd those little suckers go...",
			PLAYING_HIDEANDSEEK_TIME_ALMOST_UP = "Not much time left!",
		},

		KITCOONDEN_KIT = "I watched my mom do some woodwork, so this should be easy!",

		TICOON = 
		{
			GENERIC = "Yeah, yeah, you're real cute...",
			ABANDONED = "Who needs friends anyways?",
			SUCCESS = "Oh, another one. Great.",
			LOST_TRACK = "Oookay...",
			NEARBY = "Are we there yet?",
			TRACKING = "You better have found something good.",
			TRACKING_NOT_MINE = "I'm not a cat thief.",
			NOTHING_TO_TRACK = "Nothing interesting nearby? Tell me about it.",
			TARGET_TOO_FAR_AWAY = "I think we've gotten off track.",
		},
		
		YOT_CATCOONSHRINE =
        {
            GENERIC = "Hope there's something good.",
            EMPTY = "Want some scraps or something?",
            BURNT = "Oh well.",
        },

		KITCOON_FOREST = "More critters to bother me.",
		KITCOON_SAVANNA = "More critters to bother me.",
		KITCOON_MARSH = "More critters to bother me.",
		KITCOON_DECIDUOUS = "More critters to bother me.",
		KITCOON_GRASS = "More critters to bother me.",
		KITCOON_ROCKY = "More critters to bother me.",
		KITCOON_DESERT = "More critters to bother me.",
		KITCOON_MOON = "More critters to bother me.",
		KITCOON_YOT = "More critters to bother me.",

        -- Moon Storm
        ALTERGUARDIAN_PHASE1 = {
            GENERIC = "Watch where you're going, you big... rock!",
            DEAD = "The rocks been smashed.",
        },
        ALTERGUARDIAN_PHASE2 = {
            GENERIC = "Did I make you mad? Good!",
            DEAD = "Nice try rocky!",
        },
        ALTERGUARDIAN_PHASE2SPIKE = "Hey! Don't block me!",
        ALTERGUARDIAN_PHASE3 = "Third times the charm!",
        ALTERGUARDIAN_PHASE3TRAP = "It's making me light headed...",
        ALTERGUARDIAN_PHASE3DEADORB = "Stay down!",
        ALTERGUARDIAN_PHASE3DEAD = "Huh, I guess it really DID stay down...",

        ALTERGUARDIANHAT = "Is someone talking to me?",
        ALTERGUARDIANHATSHARD = "Oops! I broke it!",

        MOONSTORM_GLASS = {
            GENERIC = "Glass is super heated sand, right? So maybe... ah forget it!",
            INFUSED = "It's packed with extra magic!"
        },

        MOONSTORM_STATIC = "It looks kind of unstable...",
        MOONSTORM_STATIC_ITEM = "I'll try not to drop it!",
        MOONSTORM_SPARK = "Playing with electricity is fun!",

        BIRD_MUTANT = "Gnarly!",
        BIRD_MUTANT_SPITTER = "This guy knows how to hock a loogie!",

        WAGSTAFF_NPC = "Hey! Bug eyes! Are you listening to me?!",
        ALTERGUARDIAN_CONTAINED = "Yeah, just in time...",

        WAGSTAFF_TOOL_1 = "Is it some kind of instrument?",
        WAGSTAFF_TOOL_2 = "It's like a tiny radio!",
        WAGSTAFF_TOOL_3 = "It looks like some kind of self reading book!",
        WAGSTAFF_TOOL_4 = "It looks a bit too delicate for me.",
        WAGSTAFF_TOOL_5 = "Is it... a spoon?",

        MOONSTORM_GOGGLESHAT = "I don't pretend to know how science works.",

        MOON_DEVICE = {
            GENERIC = "So... what now?",
            CONSTRUCTION1 = "I hope I get some kind of reward for all of this.",
            CONSTRUCTION2 = "It REALLY better be worth it!",
        },

		-- Wanda
        POCKETWATCH_HEAL = {
			GENERIC = "I'm sure she won't mind if I play with it.",
			RECHARGING = "I didn't break it, I swear!",
		},

        POCKETWATCH_REVIVE = {
			GENERIC = "I'm sure she won't mind if I play with it.",
			RECHARGING = "I didn't break it, I swear!",
		},

        POCKETWATCH_WARP = {
			GENERIC = "I'm sure she won't mind if I play with it.",
			RECHARGING = "I didn't break it, I swear!",
		},

        POCKETWATCH_RECALL = {
			GENERIC = "I'm sure she won't mind if I play with it.",
			RECHARGING = "I didn't break it, I swear!",
--fallback to speech_wilson.lua 			UNMARKED = "only_used_by_wanda",
--fallback to speech_wilson.lua 			MARKED_SAMESHARD = "only_used_by_wanda",
--fallback to speech_wilson.lua 			MARKED_DIFFERENTSHARD = "only_used_by_wanda",
		},

        POCKETWATCH_PORTAL = {
			GENERIC = "I'm sure she won't mind if I play with it.",
			RECHARGING = "I didn't break it, I swear!",
--fallback to speech_wilson.lua 			UNMARKED = "only_used_by_wanda unmarked",
--fallback to speech_wilson.lua 			MARKED_SAMESHARD = "only_used_by_wanda same shard",
--fallback to speech_wilson.lua 			MARKED_DIFFERENTSHARD = "only_used_by_wanda other shard",
		},

        POCKETWATCH_WEAPON = {
			GENERIC = "How the heck does she use this thing?",
--fallback to speech_wilson.lua 			DEPLETED = "only_used_by_wanda",
		},

        POCKETWATCH_PARTS = "I have no idea what these do.",
        POCKETWATCH_DISMANTLER = "I'll leave it to the clock loving weirdo.",

        POCKETWATCH_PORTAL_ENTRANCE = 
		{
			GENERIC = "I hope it's not cramped...",
			DIFFERENTSHARD = "I hope it's not cramped...",
		},
        POCKETWATCH_PORTAL_EXIT = "Could have been worse...",

        -- Waterlog
        WATERTREE_PILLAR = "How very... large. And imposing.",
        OCEANTREE = "It must love the water.",
        OCEANTREENUT = "It's a nut. You can plant it.",
        WATERTREE_ROOT = "Keep an eye out for those roots!",

        OCEANTREE_PILLAR = "I'd like to keep my distance, I don't trust that thing...",
        
        OCEANVINE = "If one of those things grabs me I'm going to go berserk!",
        FIG = "This is old people food!",
        FIG_COOKED = "It's still for old geezers.",

        SPIDER_WATER = "Glide along, creep.",
        MUTATOR_WATER = "Are these made of mud? What are you, five?",
        OCEANVINE_COCOON = "What a dump.",
        OCEANVINE_COCOON_BURNT = "Oh, it's burnt? I hardly noticed.",

        GRASSGATOR = "Get a hair cut!",

        TREEGROWTHSOLUTION = "Huh, old people food makes trees grow old.",

        FIGATONI = "The fig is hiding.",
        FIGKABAB = "It's figs on a stick, what more do you want?",
        KOALEFIG_TRUNK = "I hope someone cleaned out the trunk before stuffing it.",
        FROGNEWTON = "Anything can be a sandwich if you put your mind to it!",

        -- The Terrorarium
        TERRARIUM = {
            GENERIC = "It's just a tiny tree in a pyramid, who cares?",
            CRIMSON = "That is one cool tree!",
            ENABLED = "And now it's glowing.",
			WAITING_FOR_DARK = "Huh, it's floating. Neat.",
			COOLDOWN = "Back to being a normal, boring little tree.",
			SPAWN_DISABLED = "Anyone home? Hello?",
        },

        -- Wolfgang
        MIGHTY_GYM = 
        {
            GENERIC = "He's probably cheating.",
            BURNT = "I think a stunt backfired.",
        },

        DUMBBELL = "I *could* throw it, but I just don't want to!",
        DUMBBELL_GOLDEN = "I wouldn't want to throw something so expensive looking.",
        DUMBBELL_MARBLE = "I might break it if I were to throw it.",
        DUMBBELL_GEM = "I wouldn't want to waste perfectly good gems by throwing this thing around!",
        POTATOSACK = "One hundred percent sack, zero percent potato.",


        TERRARIUMCHEST = 
		{
			GENERIC = "That looks... new.",
			BURNT = "There goes the mystery.",
			SHIMMER = "It looks so inviting, how could I resist?",
		},

		EYEMASKHAT = "Eye want to take this thing off. Right now.",

        EYEOFTERROR = "And what are YOU looking at?",
        EYEOFTERROR_MINI = "Cry me a river!",
        EYEOFTERROR_MINI_GROUNDED = "Smash it! Quick!",

        FROZENBANANADAIQUIRI = "There's not a whole lot to drink....",
        BUNNYSTEW = "It's not very filling.",
        MILKYWHITES = "Gross. I want to touch it!",

        CRITTER_EYEOFTERROR = "I don't like being watched.",

        SHIELDOFTERROR ="Why shield when I could shove?",
        TWINOFTERROR1 = "Double the trouble!",
        TWINOFTERROR2 = "Double the trouble!",
		
		-- Year of the Catcoon
        CATTOY_MOUSE = "Huh, nice woodwork.",
        KITCOON_NAMETAG = "Can't promise a home, but maybe a name is just as good.",

		KITCOONDECOR1 =
        {
            GENERIC = "You see, you hollow out the center, place a metal ball inside, and it- oh never mind...",
            BURNT = "It... it wasn't a real bird.",
        },
		KITCOONDECOR2 =
        {
            GENERIC = "I never had anything this elaborate.",
            BURNT = "And now it's gone.",
        },

		KITCOONDECOR1_KIT = "Might be fun to set it up.",
		KITCOONDECOR2_KIT = "Might be fun to set it up.",

        -- WX78
        WX78MODULE_MAXHEALTH = "I don't much care for metal work.",
        WX78MODULE_MAXSANITY1 = "I don't much care for metal work.",
        WX78MODULE_MAXSANITY = "I don't much care for metal work.",
        WX78MODULE_MOVESPEED = "I don't much care for metal work.",
        WX78MODULE_MOVESPEED2 = "I don't much care for metal work.",
        WX78MODULE_HEAT = "I don't much care for metal work.",
        WX78MODULE_NIGHTVISION = "I don't much care for metal work.",
        WX78MODULE_COLD = "I don't much care for metal work.",
        WX78MODULE_TASER = "I don't much care for metal work.",
        WX78MODULE_LIGHT = "I don't much care for metal work.",
        WX78MODULE_MAXHUNGER1 = "I don't much care for metal work.",
        WX78MODULE_MAXHUNGER = "I don't much care for metal work.",
        WX78MODULE_MUSIC = "I don't much care for metal work.",
        WX78MODULE_BEE = "I don't much care for metal work.",
        WX78MODULE_MAXHEALTH2 = "I don't much care for metal work.",

        WX78_SCANNER = 
        {
            GENERIC = "Just watch who you're scanning!",
            HUNTING = "Just watch who you're scanning!",
            SCANNING = "Just watch who you're scanning!",
        },

        WX78_SCANNER_ITEM = "Sleeping on the job, huh?",
        WX78_SCANNER_SUCCEEDED = "Are you excited? Worried? I can't really tell.",

        WX78_MODULEREMOVER = "Cool tool.",

        SCANDATA = "So, your job is to make... paper?",

		-- QOL 2022
		JUSTEGGS = "I scrambled them myself!",
		VEGGIEOMLET = "No bacon? Aw...",
		TALLEGGS = "Giant omelette!!",
		BEEFALOFEED = "Those beasts eat twigs, I doubt they will care.",
		BEEFALOTREAT = "Or... I could just feed it more twigs.",

        -- Pirates
        BOAT_ROTATOR = "If I spin in cricles too fast I might get sick.",
        BOAT_ROTATOR_KIT = "Rudder. Rud. Er. Ruddddderrrr.",
        BOAT_BUMPER_KELP = "Bumper boats! Whoo!",
        BOAT_BUMPER_KELP_KIT = "Let's get this set up so we can smash into people!",
        BOAT_BUMPER_SHELL = "Bumper boats! Whoo!",
        BOAT_BUMPER_SHELL_KIT = "Let's get this set up so we can smash into people!",
        BOAT_CANNON = {
            GENERIC = "I wish I could carry this everywhere I go!",
            AMMOLOADED = "Eat cannonball, suckers!",
            NOAMMO = "I need more things to shoot!",
        },
        BOAT_CANNON_KIT = "This is going to be great!",
        CANNONBALL_ROCK_ITEM = "Too big to sling, but maybe...",

        OCEAN_TRAWLER = {
            GENERIC = "Nothing but net.",
            LOWERED = "Best idea ever.",
            CAUGHT = "You're mine now!",
            ESCAPED = "Hey! Get back here you dang fish!",
            FIXED = "I'm a master at repair work!",
        },
        OCEAN_TRAWLER_KIT = "I'll be eating seafood in no time!",

        BOAT_MAGNET =
        {
            GENERIC = "Yup, it's a big magnet.",
            ACTIVATED = "We're attracting something!",
        },
        BOAT_MAGNET_KIT = "You can't just \"invent\" something that already exists and call it your own!",

        BOAT_MAGNET_BEACON =
        {
            GENERIC = "It needs a matching magnet.",
            ACTIVATED = "It's on! But will it attract?",
        },
        DOCK_KIT = "Anything to get away from the land dwellers.",
        DOCK_WOODPOSTS_ITEM = "It only serves to get in the way!",

        MONKEYHUT = 
        {
            GENERIC = "I'd prefer something more open concept.",
            BURNT = "Thats what you get for living in a tree!",
        },
        POWDER_MONKEY = "Quit monkeying around!",
        PRIME_MATE = "If I take you down, does that mean I'm in charge?",
		LIGHTCRAB = "You just make it easy for predators to spot you.",
        CUTLESS = "I can practice my whacking techniques.",
        CURSED_MONKEY_TOKEN = "Only the finest trinkets for me!",
        OAR_MONKEY = "That's a paddlin'!",
        BANANABUSH = "It's a fruit, and fruit grow on bushes too, right?",
        DUG_BANANABUSH = "It's a fruit, and fruit grow on bushes too, right?",
        PALMCONETREE = "Is that a normal tree? I can't tell.",
        PALMCONE_SEED = "Oh great! More trees!",
        PALMCONE_SAPLING = "You just... keep doing what you're doing.",
        PALMCONE_SCALE = "It makes a nice noise when you knock on it.",
        MONKEYTAIL = "The tail part seems kind of useless",
        DUG_MONKEYTAIL = "The tail part seems kind of useless",

        MONKEY_MEDIUMHAT = "I'm the boss around here!",
        MONKEY_SMALLHAT = "Fear me!",
        POLLY_ROGERSHAT = "I don't need no stinking bird following me around!",
        POLLY_ROGERS = "Shoo! Get out of here you pest!",

        MONKEYISLAND_PORTAL = "Oh, another portal? Thats neat.",
        MONKEYISLAND_PORTAL_DEBRIS = "Looks like somethings been smashed without me...",
        MONKEYQUEEN = "I'd make more jokes, but I feel like you wouldn't understand them.",
        MONKEYPILLAR = "Thats a lot of effort just to hang one hammock.",
        PIRATE_FLAG_POLE = "Atleast they are getting their vitamin C.",

        BLACKFLAG = "I should make my own pirate logo!",
        PIRATE_STASH = "I knew there was treasure!",
        STASH_MAP = "Take me to the goods!",


        BANANAJUICE = "My dad always got this at the malt shop... I prefer chocolate.",

        FENCE_ROTATOR = "Duel to the death!",

        CHARLIE_STAGE_POST = "Let me know when a band plays.",
        CHARLIE_LECTURN = "I could write something better!",

        CHARLIE_HECKLER = "Oh shut up you pin-heads! You make me sick!",

        PLAYBILL_THE_DOLL = "Look alive, dummy!",
        STATUEHARP_HEDGESPAWNER = "Those vines seem to love the statue. Or... hate it?",
        HEDGEHOUND = "Grass? Grass!",
        HEDGEHOUND_BUSH = "No thanks, I'd rather not get pricked!",

        MASK_DOLLHAT = "Neat! A stupid mask!",
        MASK_DOLLBROKENHAT = "Neat! A stupid mask!",
        MASK_DOLLREPAIREDHAT = "That's more like it!",
        MASK_BLACKSMITHHAT = "Neat! A stupid mask!",
        MASK_MIRRORHAT = "Neat! A stupid mask!",
        MASK_QUEENHAT = "Neat! A stupid mask!",
        MASK_KINGHAT = "Neat! A stupid mask!",
        MASK_TREEHAT = "Neat! A stupid mask!",
        MASK_FOOLHAT = "This would fit perfectly on everyone else!",

        COSTUME_DOLL_BODY = "Hey look! A worthless costume!",
        COSTUME_QUEEN_BODY = "Hey look! A worthless costume!",
        COSTUME_KING_BODY = "Hey look! A worthless costume!",
        COSTUME_BLACKSMITH_BODY = "Hey look! A worthless costume!",
        COSTUME_MIRROR_BODY = "Hey look! A worthless costume!",
        COSTUME_TREE_BODY = "Hey look! A worthless costume!",
        COSTUME_FOOL_BODY = "No one around here needs help looking like a fool.",

        STAGEUSHER =
        {
            STANDING = "Hey! I saw that!",
            SITTING = "I don't think I should sit there...",
        },
        SEWING_MANNEQUIN = 
        {
            GENERIC = "Don't look at me like that, you dope!",
            BURNT = "That's what happens when you look at me funny!",
        },
		
		MAGICIAN_CHEST = "What's behind the curtain? A better act, hopefully!",
		TOPHAT_MAGICIAN = "Neat trick, how about I you stuff you inside as an encore?",

        -- Year of the Rabbit
        YOTR_FIGHTRING_KIT = "Let's set up the arena.",
        YOTR_FIGHTRING_BELL =
        {
            GENERIC = "Let's get ready to rumble!",
            PLAYING = "Full contact!",
        },

        YOTR_DECOR_1 = {
            GENERAL = "Okay fine, it's a little bit cozy...",
            OUT = "I should get some fuel.",
        },
        YOTR_DECOR_2 = {
            GENERAL = "Okay fine, it's a little bit cozy...",
            OUT = "I should get some fuel.",
        },

        HAREBALL = "He-he, nice one.",
        YOTR_DECOR_1_ITEM = "Oh great, more decorations...",
        YOTR_DECOR_2_ITEM = "Oh great, more decorations...",

		--
		DREADSTONE = "Rock and stone!",
		HORRORFUEL = "It's trying so hard to be scary...",
		DAYWALKER =
		{
			GENERIC = "This is why I never do anything nice!",
			IMPRISONED = "Hmm, maybe I'll do something nice for a change...",
		},
		DAYWALKER_PILLAR =
		{
			GENERIC = "Ooh, fancy.",
			EXPOSED = "He-he-he, I broke it.",
		},
		ARMORDREADSTONE = "It's just a bunch of rocks.",
		DREADSTONEHAT = "I feel like I'm in the stone age...",
    },

    DESCRIBE_GENERIC = "That sure is... something!",
    DESCRIBE_TOODARK = "I can't see in the dark, you dope!",
    DESCRIBE_SMOLDERING = "Where's Willow? The shows about to start.",

    DESCRIBE_PLANTHAPPY = "Of course you're happy, I'm a master at this gardening stuff!",
    DESCRIBE_PLANTVERYSTRESSED = "Guess you're pretty depressed, huh?",
    DESCRIBE_PLANTSTRESSED = "What's eating you?",
    DESCRIBE_PLANTSTRESSORKILLJOYS = "Are some jerks picking on you? Besides me, that is...",
    DESCRIBE_PLANTSTRESSORFAMILY = "Friends are over-rated.",
    DESCRIBE_PLANTSTRESSOROVERCROWDING = "Too crowded huh? I know how that feels...",
    DESCRIBE_PLANTSTRESSORSEASON = "Don't like the weather? Just tough it out!",
    DESCRIBE_PLANTSTRESSORMOISTURE = "Dry as a desert.",
    DESCRIBE_PLANTSTRESSORNUTRIENTS = "Looks like we have a picky eater on our hands!",
    DESCRIBE_PLANTSTRESSORHAPPINESS = "It needs some... persuasion.",

    EAT_FOOD =
    {
        TALLBIRDEGG_CRACKED = "Better to save them from disappointment.",
		WINTERSFEASTFUEL = "S'more for me!",
    },
}

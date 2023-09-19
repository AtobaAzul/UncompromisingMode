local require = GLOBAL.require

GLOBAL.STRINGS.CHARACTERS.WATHOM = require "speech_wathom"

ANNOUNCE = GLOBAL.STRINGS.CHARACTERS.WATHOM
DESCRIBE = GLOBAL.STRINGS.CHARACTERS.WATHOM.DESCRIBE
ACTIONFAIL = GLOBAL.STRINGS.CHARACTERS.WATHOM.ACTIONFAIL

--	[ 		Wathom Descriptions		]   --

ANNOUNCE.DREADEYE_SPOOKED = "It's... awake. Watching us."
ANNOUNCE.ANNOUNCE_HARDCORE_RES = "Never dead, truly."
ANNOUNCE.ANNOUNCE_WINONAGEN =
    "Ancient designs, incompatible. Myself, willing student."
ANNOUNCE.ANNOUNCE_RATRAID = "Vocalizations, rats."
ANNOUNCE.ANNOUNCE_RATRAID_SPAWN = "Rats, engaging!"
ANNOUNCE.ANNOUNCE_RATRAID_OVER = "Provisions, ransacked!"
ANNOUNCE.ANNOUNCE_ACIDRAIN = {
    "Carapace, burning!!", "Weather, poisoned! Toad parasite, presumably.",
    "Rain, bad."
}
ANNOUNCE.ANNOUNCE_TOADSTOOLED = "Infestation, proxied!"
-- FoodBuffs
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LESSERELECTRICATTACK =
    ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICRETALIATION =
    ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_FROZENFURY = "ssSsooo cCccold."
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_VETCURSE = "Mettle tested, nothing new!"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_LESSERELECTRICATTACK =
    ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICRETALIATION =
    ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_DETACH_BUFF_FROZENFURY = "Feeling better now"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_VETCURSE = "Challenge, failure."
ANNOUNCE.ANNOUNCE_RNEFOG = "Whispers, conspiracy. Hidden beneath, warnings."
-- FoodBuffs

-- CaliforniaKing
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_CALIFORNIAKING =
    "Yes, good drink, drinkgoodyes, drgrnn...rgg.."
ANNOUNCE.ANNOUNCE_DETACH_BUFF_CALIFORNIAKING = "Am I dead?"
DESCRIBE.CALIFORNIAKING = "Entire being, begging not."
-- CaliforniaKing

-- Content Creators
DESCRIBE.CCTRINKET_DON = "Detailed history, previous scribe. \"Don.\""
DESCRIBE.CCTRINKET_JAZZY = "Engravings. \"J a z z y\"?"
DESCRIBE.CCTRINKET_FREDDO = "Engravings. \"F r e d d o\"?"
-- Content Creators
DESCRIBE.UNCOMPROMISING_RAT = "Instigator, problems. Rather dead."
DESCRIBE.UNCOMPROMISING_RATHERD = "Trail, rodents. Nearby."
DESCRIBE.UNCOMPROMISING_RATBURROW = "Belongings, stolen."
DESCRIBE.UNCOMPROMISING_WINKYBURROW = "Tunnel, rodent ally."
DESCRIBE.UNCOMPROMISING_WINKYHOMEBURROW = "Territory, sentient rat."

DESCRIBE.WINKY = {
    GENERIC = "%s, sentient rodent. Evolution improbable.",
    ATTACKER = "%s, place forgotten.",
    MURDERER = "%s, plaguebearer. Procedure, eradication.",
    REVIVER = "%s, not natural. Curious, kinship?",
    GHOST = "%s, dead.",
    FIRESTARTER = "Problems, rodent-instigated, increasing constantly."
}
DESCRIBE.WIXIE = {
    GENERIC = "Problems, often cause.",
    ATTACKER = "Pick elsewhere, your fights.",
    MURDERER = "With poor aim, slingshot ineffective!",
    REVIVER = "You are bearable.",
    GHOST = "Pick your fights, %s. Skill, valuable.",
    FIRESTARTER = "Liabilities, mounting."
}
DESCRIBE.WATHOM = {
    GENERIC = "%s, meaning? Maker's replacement?",
    ATTACKER = "%s, self-sabotaging.",
    MURDERER = "Goals, jeapordized. %s, role challenged!",
    REVIVER = "Against us, nothing better.",
    GHOST = "Unsettled. Superiority, proven?",
    FIRESTARTER = "%s, flames. Answers."
}

DESCRIBE.RATPOISONBOTTLE = "Survival, smartest."
DESCRIBE.RATPOISON = "One less problem."

DESCRIBE.MONSTERSMALLMEAT = "Poison, too concentrated."
DESCRIBE.COOKEDMONSTERSMALLMEAT = "Not dying, preferrable."
DESCRIBE.MONSTERSMALLMEAT_DRIED = "Most poisons, drained."

DESCRIBE.UM_MONSTEREGG = "Calcium, haired. How."
DESCRIBE.UM_MONSTEREGG_COOKED = "Indistinguishable, catcoon hairballs."

DESCRIBE.MUSHROOMSPROUT_OVERWORLD = "Pollution, source!"
DESCRIBE.TOADLING = "Diseased. Curious, parasites present?"
DESCRIBE.UNCOMPROMISING_TOAD = "Parasitical influence, growing."

DESCRIBE.GASMASK = "Biological limitations, nullified."
DESCRIBE.MOCK_DRAGONFLY = DESCRIBE.DRAGONFLY
DESCRIBE.MOTHERGOOSE = DESCRIBE.MOOSE
DESCRIBE.SPIDERQUEENCORPSE = "Decompositon halted. Why?"
ANNOUNCE.ANNOUNCE_SNEEZE = "GrrRRAAH-CHOO! "
ANNOUNCE.ANNOUNCE_HAYFEVER = "Rampant, Spring's pollen. Fantastic."
ANNOUNCE.ANNOUNCE_HAYFEVER_OFF = "Sense hinderence, passing. "
ANNOUNCE.ANNOUNCE_FIREFALL = {"Flames, above!", "Alert! Above, watch!"}
ANNOUNCE.ANNOUNCE_ROOTING = "No!"
ANNOUNCE.ANNOUNCE_SNOWSTORM = "Wind, cold-bringing."

ANNOUNCE.SHADOWTALKER = {
    "ABYSS, BECKONING.", "MAKER SCHEMES. EVERYONE SCHEMES.",
    "ANCIENTS FORGOTTEN. TIME WASTED."
}

ANNOUNCE.ANNOUNCE_OVER_EAT = {
    STUFFED = "No more...",
    OVERSTUFFED = "Mh... Mistake..."
}
ANNOUNCE.CURSED_ITEM_EQUIP = "Rrah! Ownership, refused."
DESCRIBE.VETSITEM = "The damned, accepting."
DESCRIBE.SCREECHER_TRINKET = "Thankful, long dead."

DESCRIBE.UM_SAND = "Small traces, magic incubation."
DESCRIBE.UM_SANDHILL = "Concentration, sand."
DESCRIBE.SNOWPILE = "Concentration, obscuration."
DESCRIBE.SNOWGOGGLES = "Hibernation, irrelevant."

DESCRIBE.SNOWMONG = "Frost, transmutated!"
DESCRIBE.SHOCKWORM = "Veins, scales, electricity current!"
DESCRIBE.ZASPBERRY = "Bioelectricity, harnessed."
DESCRIBE.ZASPBERRYPARFAIT = "Fit meal, apex predator."
DESCRIBE.ICEBOOMERANG = "Winter itself, conductive."

DESCRIBE.MINOTAUR_BOULDER = "Alert, above!"
DESCRIBE.MINOTAUR_BOULDER_BIG =
    "Guardian, momentum uncontrollable. Strategy recognized!"
DESCRIBE.BUSHCRAB = "Excellent mimics, ignorant fooled."
DESCRIBE.LAVAE2 = DESCRIBE.LAVAE
DESCRIBE.DISEASECUREBOMB = "Curious. Additionally Alter, rejuvenation magic?"
DESCRIBE.TOADLINGSPAWNER = "Alert."
DESCRIBE.SNOWBALL_THROWABLE = "Don't."
DESCRIBE.VETERANSHRINE = "Heart racing, exciting! Ritual, calling!"
DESCRIBE.WICKER_TENTACLE = "Poor mutation."
DESCRIBE.HONEY_LOG = "Weather, unpleasant."

DESCRIBE.RAT_TAIL =
    "Only skin, bones. Quelled, ally concerns - disease unlikely."
DESCRIBE.PLAGUEMASK = "Status, luxury."
DESCRIBE.SALTPACK = "Frost, industrial counter."
DESCRIBE.SPOREPACK = "Scent ignoring, practicalities beneficial."
DESCRIBE.SNOWBALL_THROWABLE = "Don't."
DESCRIBE.SPIDER_TRAPDOOR = "Trapdoor arachnid. Common, here."
DESCRIBE.TRAPDOOR = "Hunting grounds, several creatures."
DESCRIBE.HOODEDTRAPDOOR = DESCRIBE.TRAPDOOR
DESCRIBE.SHROOM_SKIN_FRAGMENT = "Itself, useless."
DESCRIBE.AIR_CONDITIONER = "Survival, conquered."

DESCRIBE.UM_SCORPION = "Venom, incapacitating."
DESCRIBE.UM_SCORPIONHOLE = "Animal den, seemingly."
DESCRIBE.SCORPIONCARAPACE = "Texture, satisfying. Poisonous, sadly."
DESCRIBE.SCORPIONCARAPACECOOKED = "Poisons, partially subsided."
DESCRIBE.HARDSHELLTACOS = "Texture, satisfying. Crunch, then soft."

DESCRIBE.SKELETONMEAT = "Flesh, human. Edible, however better uses, magic."
DESCRIBE.CHIMP = DESCRIBE.MONKEY
DESCRIBE.SWILSON = "Manifestation, shadow. Temperament, particularly hostile."
DESCRIBE.VAMPIREBAT = "Past adolesence, survived. Surprising."
DESCRIBE.CRITTERLAB_REAL = DESCRIBE.CRITTERLAB
DESCRIBE.CRITTERLAB_REAL_BROKEN = "Repairable, Alter rock?"
DESCRIBE.CHARLIEPHONOGRAPH_100 = DESCRIBE.MAXWELLPHONOGRAPH
DESCRIBE.WALRUS_CAMP_SUMMER = DESCRIBE.WALRUS_CAMP

-- Swampyness
DESCRIBE.RICEPLANT = "Vegetation, marsh water."
DESCRIBE.RICE = "Grains, inedible."
DESCRIBE.RICE_COOKED = "Texture, small rocks."
DESCRIBE.SEAFOODPAELLA = "Illness combatant."

DESCRIBE.STUMPLING = "Treeguard, adolescent."
DESCRIBE.BIRCHLING = DESCRIBE.STUMPLING
DESCRIBE.BUGZAPPER = "Small carapaces, conductive."
DESCRIBE.MOON_TEAR = "Message, Alter itself?"
DESCRIBE.SHADOW_TELEPORTER = "Invitation?"
DESCRIBE.POLLENMITEDEN = "Infestations."
DESCRIBE.POLLENMITES = "Infestation."
DESCRIBE.SHADOW_CROWN = "Trophy from Them."
DESCRIBE.RNEGHOST = DESCRIBE.GHOST
DESCRIBE.LICELOAF = "That is food?"
DESCRIBE.SUNGLASSES = "Why?"
DESCRIBE.TRAPDOORGRASS = DESCRIBE.GRASS
DESCRIBE.LUREPLAGUE_RAT = "Infestation, unknown?"
DESCRIBE.MARSH_GRASS = "Grass. Too thin, too brittle."
DESCRIBE.CURSED_ANTLER = "Winter's King, wrath weaponized."
DESCRIBE.BERNIEBOX = "Box."
DESCRIBE.HOODED_FERN = "Vegetation."
DESCRIBE.HOODEDWIDOW = "Apex Arachnid!"
DESCRIBE.GIANT_TREE = "Curious. Tree species, not indigenous."
DESCRIBE.ANCIENTHOODEDTURF = DESCRIBE.TURF_FOREST
DESCRIBE.HOODEDMOSS = DESCRIBE.TURF_FOREST
DESCRIBE.WIDOWSGRASP = "Victor's prize, hoarder's spoils."
DESCRIBE.WEBBEDCREATURE = "It wouldn't hurt to see what's inside, right?"
ANNOUNCE.WEBBEDCREATURE = "Abnormally thick. Weaver, abnormally large?"
DESCRIBE.SNAPDRAGON_BUDDY = "Seeking food."
DESCRIBE.SNAPDRAGON = "Species, invasive."
DESCRIBE.SNAPPLANT = "Plant, mammal?"
DESCRIBE.WHISPERPOD = "Curious, self-incubating?"
DESCRIBE.WHISPERPOD_NORMAL_GROUND = {
    GENERIC = "Seeds required.",
    GROWING = "Nothing needed, not now."
}
DESCRIBE.FRUITBAT = "Temperament, calm. Assumption, hunter, small game."
DESCRIBE.PITCHERPLANT = "Functionality, uncertain."
DESCRIBE.APHID = "Fauna, unfamiliar."
DESCRIBE.NYMPH = "Reminds of... bee? Curious."
DESCRIBE.GIANT_TREE_INFESTED = "Inner tree, infestation. Craving sap, perhaps."
DESCRIBE.GIANT_BLUEBERRY = "Root severed. Safety assured."
DESCRIBE.PURPLESTEAMEDHAMS = "\"Steamed hams\", never heard of."
DESCRIBE.GREENSTEAMEDHAMS = "\"Steamed hams\", never heard of."
DESCRIBE.BLUEBERRYPANCAKES = "Odd combination, survival-oriented."
DESCRIBE.DEVILSFRUITCAKE = "Liquid nourishment, preserved in sugar."
DESCRIBE.SIMPSALAD = "Just foliage?"
DESCRIBE.BEEFALOWINGS = "Spirit-lifting, beefalo defeated!"
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_KNOCKBACKIMMUNE = "Stopping, nothing!"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_KNOCKBACKIMMUNE = "Stiffness, retreating."
DESCRIBE.WIDOWSHEAD = "Trophy collecting, unusual. Tempting, however."
DESCRIBE.HOODED_MUSHTREE_TALL = DESCRIBE.MUSHTREE_TALL
DESCRIBE.HOODED_MUSHTREE_MEDIUM = DESCRIBE.MUSHTREE_MEDIUM
DESCRIBE.HOODED_MUSHTREE_SMALL = DESCRIBE.MUSHTREE_SMALL
DESCRIBE.WATERMELON_LANTERN = "Why."
DESCRIBE.SNOWCONE = "Just ice."

-- Viperstuff Quotes
DESCRIBE.VIPERWORM = "Whispering, antagonizing!"
DESCRIBE.VIPERFRUIT = "Atmosphere manipulation, focus."
DESCRIBE.VIPERJAM = "Favor, from Them."

DESCRIBE.BLUEBERRYPLANT = {
    READY = "Throbbing, rythmic.",
    FROZE = "Dead, likely.",
    REGROWING = "Constant pumping, roots. Curious. Quickly severed, in-tact fruits?"
}
DESCRIBE.BERNIE_INACTIVE = {
    BROKEN = "Worn, torn, everything here.",
    GENERIC = "Staring. Judging.",
    BROKEN_ASHLEY = "Worn, torn, everything here.",
    ASHLEY = "Staring. Judging."
}

DESCRIBE.BERNIE_ACTIVE = {
    BERNIE_ACTIVE = "Staring, unwavering. Distrustful.",
    ASHLEY = "Staring, unwavering. Distrustful."
}
DESCRIBE.BERNIE_BIG = {GENERIC = "Not me! Not me!", ASHLEY = "Not me! Not me!"}
DESCRIBE.ANTIHISTAMINE = "Properties, illness-alleviating."

DESCRIBE.HEATROCK_LEVEL = {
    TINY = "Inactive.",
    SMALL = "Slightly holding.",
    MED = "Temperature, regulated partially.",
    LARGE = "Temperature, regulated.",
    HUGE = "Temperature, holding strongly."
}

DESCRIBE.DURABILITY_LEVEL = {
    QUARTER = "Tattered, disregarded.",
    HALF = "Desirable, better condition.",
    THREEQUARTER = "Condition, servicable.",
    FULL = "Condition, perfect."
}

ACTIONFAIL.READ = {GENERIC = "Magic, inert."}
ACTIONFAIL.GIVE = {NOTNIGHT = "Presence required, Alter's gaze."}

RECIPE_DESC = GLOBAL.STRINGS.RECIPE_DESC

RECIPE_DESC.RAT_BURROW = "Den, rodents."

-- Xmas Update
DESCRIBE.MAGMAHOUND = "Magma, vitalized!"
DESCRIBE.LIGHTNINGHOUND = "Surroundings ionized!"
DESCRIBE.SPOREHOUND = "Plague-spreader."
DESCRIBE.GLACIALHOUND = "Harrassment, ranged!"
DESCRIBE.RNESKELETON = "Human remains, animate."
DESCRIBE.RAT_WHIP = "Night, walking, stalking."
DESCRIBE.KLAUS_AMULET = "Curse of Klaus."
DESCRIBE.CRABCLAW = "Gem magic, rudimentary."
DESCRIBE.HAT_RATMASK = "Hiding, irrelevant."

DESCRIBE.ORANGE_VOMIT = "Regurgitation, intentional. Why?"
DESCRIBE.GREEN_VOMIT = "Regurgitation, intentional. Why?"
DESCRIBE.RED_VOMIT = "Regurgitation, intentional. Why?"
DESCRIBE.PINK_VOMIT = "Regurgitation, intentional. Why?"
DESCRIBE.YELLOW_VOMIT = "Regurgitation, intentional. Why?"
DESCRIBE.PURPLE_VOMIT = "Regurgitation, intentional. Why?"
DESCRIBE.PALE_VOMIT = "Regurgitation, intentional. Why?"

DESCRIBE.WALRUS_CAMP_EMPTY = DESCRIBE.WALRUS_CAMP.EMPTY
DESCRIBE.PIGKING_PIGGUARD = {
    GUARD = DESCRIBE.PIGMAN.GUARD,
    WEREPIG = DESCRIBE.PIGMAN.WEREPIG
}
DESCRIBE.PIGKING_PIGTORCH = DESCRIBE.PIGTORCH

DESCRIBE.BIGHT = "Maker's meddling, consequences realized."
DESCRIBE.KNOOK = "Maker's meddling, consequences realized."
DESCRIBE.ROSHIP = "Maker's meddling, consequences realized."

DESCRIBE.UM_PAWN = "Maker's work? Curious, unfamiliar."
DESCRIBE.UM_PAWN_NIGHTMARE = "Territorial. Sluggish, reaction speed."

DESCRIBE.CAVE_ENTRANCE_SUNKDECID = DESCRIBE.CAVE_ENTRANCE
DESCRIBE.CAVE_ENTRANCE_OPEN_SUNKDECID = DESCRIBE.CAVE_ENTRANCE_OPEN
DESCRIBE.CAVE_EXIT_SUNKDECID = DESCRIBE.CAVE_EXIT

-- Blowgun stuff
DESCRIBE.UNCOMPROMISING_BLOWGUN = DESCRIBE.BLOWDART_PIPE
DESCRIBE.BLOWGUNAMMO_TOOTH = DESCRIBE.BLOWDART_PIPE
DESCRIBE.BLOWGUNAMMO_FIRE = DESCRIBE.BLOWDART_FIRE
DESCRIBE.BLOWGUNAMMO_SLEEP = DESCRIBE.BLOWDART_SLEEP
DESCRIBE.BLOWGUNAMMO_ELECTRIC = DESCRIBE.BLOWDART_YELLOW

DESCRIBE.ANCIENT_AMULET_RED = "Lifeforce, connected."
DESCRIBE.UM_BEAR_TRAP = "Alert!"
DESCRIBE.UM_BEAR_TRAP_OLD = "Not alone. Hunters, cunning."
DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_TOOTH = "Straightforward, effective."
DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_GOLD = "Straightforward, effective."
DESCRIBE.CORNCAN = "Curious, origin."
DESCRIBE.SKULLCHEST_CHILD = "Curious. Movement, interplanar?"

DESCRIBE.SLOBBERLOBBER = "Scepter, dragon!"
DESCRIBE.GORE_HORN_HAT = "Charge, charge, charge!"
DESCRIBE.BEARGERCLAW = "Decay, never soon."
DESCRIBE.FEATHER_FROCK = "Feather utilization."

DESCRIBE.REDGEM_CRACKED = DESCRIBE.REDGEM .. "\n...Broken."
DESCRIBE.BLUEGEM_CRACKED = DESCRIBE.BLUEGEM .. "\n...Broken."
DESCRIBE.ORANGEGEM_CRACKED = DESCRIBE.ORANGEGEM .. "\n...Broken."
DESCRIBE.GREENGEM_CRACKED = DESCRIBE.GREENGEM .. "\n...Broken."
DESCRIBE.YELLOWGEM_CRACKED = DESCRIBE.YELLOWGEM .. "\n...Broken."
DESCRIBE.PURPLEGEM_CRACKED = DESCRIBE.PURPLEGEM .. "\n...Broken."
DESCRIBE.OPALPRECIOUSGEM_CRACKED = DESCRIBE.OPALPRECIOUSGEM .. "\n...Broken."

DESCRIBE.RED_MUSHED_ROOM = "Byproduct, function."
DESCRIBE.GREEN_MUSHED_ROOM = "Byproduct, function."
DESCRIBE.BLUE_MUSHED_ROOM = "Byproduct, function."

DESCRIBE.HEAT_SCALES_ARMOR = "Concern, liability."

-- StantonStuff
DESCRIBE.SKULLFLASK = "Being, reinforced!"
DESCRIBE.SKULLFLASK_EMPTY = "Pleasure, favorite. Regenerating."
DESCRIBE.STANTON_SHADOW_TONIC = "Scent, toxic."
DESCRIBE.STANTON_SHADOW_TONIC_FANCY = DESCRIBE.STANTON_SHADOW_TONIC
DESCRIBE.STANTON = "Remains, animate. Comradery, seeking?"
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HYPERCOURAGE = "Ha! HA! TODAY, DEATH!"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_HYPERCOURAGE = "Again!"
-- StantonStuff

DESCRIBE.ARMORLAVAE = DESCRIBE.LAVAE

DESCRIBE.THEATERCORN = "Participation exciting, over observing."
DESCRIBE.DEERCLOPS_BARRIER = "Tactics, innovative!"

DESCRIBE.MOONMAW_DRAGONFLY = "Fate, persuing Alter?"
DESCRIBE.MOONMAW_LAVAE = "Be shattered!"
DESCRIBE.SNAPPERTURTLE = "Odd."
DESCRIBE.SNAPPERTURTLEBABY = "Odd."
DESCRIBE.SNAPPERTURTLENEST = "Nesting grounds, animal."
DESCRIBE.GLASS_SCALES = "Illumination, nauseating."
DESCRIBE.MOONGLASS_GEODE = "Object, worth study."
DESCRIBE.ARMOR_GLASSMAIL = "Touch me now!"
DESCRIBE.ARMOR_GLASSMAIL_SHARDS = "Distance kept."
DESCRIBE.MOONMAW_GLASSSHARDS_RING = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
DESCRIBE.MOONMAW_GLASSSHARDS = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
DESCRIBE.MOONMAW_LAVAE_RING = DESCRIBE.MOONMAW_LAVAE

DESCRIBE.MUTATOR_TRAPDOOR = DESCRIBE.MUTATOR_WARRIOR

DESCRIBE.WOODPECKER = "Bird, species uncertain."
DESCRIBE.SNOTROAST = "Survival..."
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LARGEHUNGERSLOW = "Bleh."
ANNOUNCE.ANNOUNCE_DETACH_BUFF_LARGEHUNGERSLOW = ""
DESCRIBE.BOOK_RAIN_UM = "Weather manipulation."
DESCRIBE.FLORAL_BANDAGE = "Flora relationship, mutalistic."
DESCRIBE.DORMANT_RAIN_HORN = "Curious, exotic."
DESCRIBE.RAIN_HORN = "Curious, exotic."
DESCRIBE.DRIFTWOODFISHINGROD = "Saltwater oriented."

ANNOUNCE.ANNOUNCE_NORATBURROWS = "Rodents nearby, eradicated."

ANNOUNCE.ANNOUNCE_RATSNIFFER_ITEMS = {
    LEVEL_1 = "Cacophany, nearby stimuli. Provisions, sort away."
}
ANNOUNCE.ANNOUNCE_RATSNIFFER_FOOD = {LEVEL_1 = "Food, scent attracting."}
ANNOUNCE.ANNOUNCE_RATSNIFFER_BURROWS = {
    LEVEL_1 = "Rodents nearby, reproducing. Nearby den?"
}

DESCRIBE.PIED_RAT = "Magic source, compulsion. Priority!"
DESCRIBE.PIED_PIPER_FLUTE = "Accessory, compulsion."
DESCRIBE.UNCOMPROMISING_PACKRAT = "Belongings, located!"

ANNOUNCE.ANNOUNCE_PORTABLEBOAT_SINK = "Value minimal! Escape!"

ACTIONFAIL.CHARGE_FROM = {
    NOT_ENOUGH_CHARGE = "Power, unsatisfactory.",
    CHARGE_FULL = "Overload, not ideal."
}
ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_INSULATED = "Current successful!"
ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED = "GRAH! Mistake!"

----UNDER THE WEATHER----

DESCRIBE.WINONA_TOOLBOX = "Implements, unusual."
ACTIONFAIL.WINONATOOLBOX = "Untrained."
DESCRIBE.WINONA_CATAPULT_ITEM = "Collapsed, machines."
DESCRIBE.WINONA_SPOTLIGHT_ITEM = "Collapsed, machines."
DESCRIBE.WINONA_BATTERY_LOW_ITEM = "Collapsed, machines."
DESCRIBE.WINONA_BATTERY_HIGH_ITEM = "Collapsed, machines."
DESCRIBE.POWERCELL = "Power source, electrical. Design limiting."
DESCRIBE.WINONA_UPGRADEKIT_ELECTRICAL = "Conversion, power input."
DESCRIBE.MINERHAT_ELECTRICAL = "Tinkered, manipulated."
DESCRIBE.OCEAN_SPEAKER = "Curious, meaning, purpose."

DESCRIBE.OCUPUS_BEAK = "Apex predator of sea? Bah."
DESCRIBE.OCUPUS_TENTACLE = "Not preferred."
DESCRIBE.OCUPUS_TENTACLE_EYE = "Eyes are for losers."
DESCRIBE.OCUPUS_TENTACLE_COOKED = "It is acceptible now, barely."
DESCRIBE.UM_OCUPUS_EYE = "Watching, preying."
DESCRIBE.UM_OCUPUS_EYETACLE = "Destroy sight, release."
DESCRIBE.UM_OCUPUS_TENTACLE = "You're about to see who's in charge around here."
DESCRIBE.UM_OCUPUS_BEAK = "Disrupting thoughts."
DESCRIBE.BEAKBASHER = "Corrects mistakes, continues longer."
DESCRIBE.HOUNDIOUS_OBSERVIOUS = "Mandrake, eyes, early warning, prepare."

DESCRIBE.ARMOR_REED_UM = "Luxury. Physical protection lacking."
DESCRIBE.ARMOR_SHARKSUIT_UM = "Ocean be damned."
DESCRIBE.ROCKJAWLEATHER = "Curious, properties hydrophobic."

-- DESCRIBE.UM_SIREN = "Science says we may be able to \"help\" each other."
-- WHAT THE FUCK VARIANT
-- DESCRIBE.UM_SIREN = "youtube.com/watch?v=O2XY3Y7JIa0" --who added this??????????????
-- what???????

DESCRIBE.EYEOFTERROR_MINI_ALLY = "Interdimensional origin. Unlikely Birthplace."
DESCRIBE.EYEOFTERROR_MINI_GROUNDED_ALLY = DESCRIBE.EYEOFTERROR_MINI_GROUNDED

DESCRIBE.STUFFED_PEEPER_POPPERS = "Eyeballs."
DESCRIBE.UM_DEVILED_EGGS = "Resources, make do."
DESCRIBE.LUSH_ENTRANCE = "Caverns, unexplored? Curious."
DESCRIBE.CRITTER_FIGGY = "Obstructions, minimal. Good."
DESCRIBE.GIANT_TREE_BIRDNEST = "Location, nest."
ACTIONFAIL.UPGRADE.NOT_HARVESTED = "Obstructions. Required, clearing."

DESCRIBE.SLUDGE = "Thick. Hm."
DESCRIBE.SLUDGE_OIL = "Thick. Hm."
DESCRIBE.SLUDGE_SACK = "Unpleasant."
DESCRIBE.CANNONBALL_SLUDGE_ITEM = "Ammunition, makeshift."
DESCRIBE.BOAT_BUMPER_SLUDGE = "Protection, makeshift."
DESCRIBE.BOAT_BUMBER_SLUDGE_KIT = "Protection, makeshift."
DESCRIBE.BOATPATCH_SLUDGE = "Resort, last."
DESCRIBE.UM_COPPER_PIPE = "Experienced stranger."
DESCRIBE.BRINE_BALM = "Painful stimuli, intensified."
DESCRIBE.UNCOMPROMISING_FISHINGNET = "Fishing rod, no, irrelevant."
DESCRIBE.UM_AMBER = "Curious, contents."
DESCRIBE.UM_BEEGUN = "Natural hive, exploited."
DESCRIBE.SUNKENCHEST_ROYAL_RANDOM = "Treasure."
DESCRIBE.SUNKENCHEST_ROYAL_RED = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_BLUE = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_PURPLE = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_GREEN = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_ORANGE = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_YELLOW = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_RAINBOW = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.STEERINGWHEEL_COPPER = "Materials, superior."
DESCRIBE.STEERINGWHEEL_COPPER_ITEM = "Materials, superior."
DESCRIBE.BOAT_BUMPER_COPPER = "Materials, superior."
DESCRIBE.BOAT_BUMPER_COPPER_KIT = "Materials, superior."
DESCRIBE.UM_DREAMCATCHER = "To Them, ritualistic plea."
DESCRIBE.UM_BRINEISHMOSS = ""
DESCRIBE.UM_COALESCED_NIGHTMARE = "Pulsating."
DESCRIBE.SLUDGE_CORK = "Impractical, boats. Other uses?"
DESCRIBE.SLUDGESTACK = "Appearance unique. Investigation, rewarded?"
DESCRIBE.SPECTER_SHIPWRECK = "Ship, wrecked."

DESCRIBE.UNCOMPROMISING_HARPOON = "Get over here."
DESCRIBE.UNCOMPROMISING_HARPOON_HEAVY = "Get over here!"
DESCRIBE.UNCOMPROMISING_HARPOONREEL = "Ocean combat, still undesired."
DESCRIBE.UM_MAGNERANG = "Food chain, intelligence dominated."
DESCRIBE.UM_MAGNERANGREEL = "Return!"
DESCRIBE.LAVASPIT_SLUDGE = "Fragrant, burning."

DESCRIBE.UM_BEEGUARD_SHOOTER = DESCRIBE.BEEGUARD
DESCRIBE.UM_BEEGUARD_SEEKER = DESCRIBE.BEEGUARD
DESCRIBE.UM_BEEGUARD_BLOCKER = "Priority, zero."

DESCRIBE.PORTABLEBOAT_ITEM =
    "Inadequate, weight capacity. Abatement, temporary."
DESCRIBE.MASTUPGRADE_WINDTURBINE_ITEM = "Power generation, kinetic energy."

DESCRIBE.UM_ORNAMENT_OPOSSUM = "Rat-like."
DESCRIBE.UM_ORNAMENT_RAT = "Vermin. Stuffed."

DESCRIBE.TRINKET_WATHOM1 = "Shit."

DESCRIBE.CODEX_MANTRA = DESCRIBE.WAXWELLJOURNAL

-- WIXIE RELATED STRINGS

DESCRIBE.WIXIE_PIANO = "Noisemaker, melodic. Presence, unknown cause."
DESCRIBE.WIXIE_CLOCK = "Simple clock. Ancients, larger one built."
DESCRIBE.WIXIE_WARDROBE = "Curious. Entry point, destination unknown."
DESCRIBE.CHARLES_T_HORSE = "Reclaimed. Darkness within."

DESCRIBE.THE_REAL_CHARLES_T_HORSE = "Plaything. Depiction, creature unknown."
DESCRIBE.SLINGSHOT_MATILDA = "."
DESCRIBE.SLINGSHOT_GNASHER = ""

DESCRIBE.SLINGSHOTAMMO_LAZY = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_SHADOW = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_FIRECRACKERS = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_HONEY = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_RUBBER = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_TREMOR = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_MOONROCK = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_MOONGLASS = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_SALT = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_SLIME = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_GOOP = DESCRIBE.SLINGSHOTAMMO_ROCK

DESCRIBE.SLINGSHOTAMMO_LIMESTONE = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_TAR = DESCRIBE.SLINGSHOTAMMO_ROCK
DESCRIBE.SLINGSHOTAMMO_OBSIDIAN = DESCRIBE.SLINGSHOTAMMO_ROCK

DESCRIBE.BAGOFMARBLES = ""

DESCRIBE.MEATRACK_HAT = {
    GENERIC = DESCRIBE.MEATRACK.GENERIC,

    DRYING = DESCRIBE.MEATRACK.DRYING,
    DRYINGINRAIN = DESCRIBE.MEATRACK.DRYINGINRAIN,

    DRYING_NOTMEAT = DESCRIBE.MEATRACK.DRYING_NOTMEAT,
    DRYINGINRAIN_NOTMEAT = DESCRIBE.MEATRACK.DRYINGINRAIN_NOTMEAT
}
DESCRIBE.FISHMEAT_DRIED = ""
DESCRIBE.SMALLFISHMEAT_DRIED = ""

DESCRIBE.WIXIEGUN = ""

DESCRIBE.MARA_BOSS1 = "RUN."
ANNOUNCE.GAS_DAMAGE = "CAN'T... BREATHE...!"

-- Pyre Nettle stuff
DESCRIBE.UM_PYRE_NETTLES = "Origin, upper depths... Expanding?"
DESCRIBE.UM_SMOLDER_SPORE = "Seeking. Careful."
ANNOUNCE.ANNOUNCE_SMOLDER_SPORE_EATEN = "Decision, BRILLIANT."
ANNOUNCE.ANNOUNCE_SMOLDER_SPORE_INVENTORY_POP = "DANGER, FORGOTTEN."
DESCRIBE.UM_ARMOR_PYRE_NETTLES = "Weakens prey. Weakens predator. Benefit, rapid strikes. Useful..."
DESCRIBE.UM_BLOWDART_PYRE = "Ruthless. Effective. Impressed..."
ANNOUNCE.ANNOUNCE_SMOLDER_SPORE_EATEN = "Decision, brilliant..."
ANNOUNCE.ANNOUNCE_SMOLDER_SPORE_INVENTORY_POP = "DANGER, FORGOTTEN"

-- Under the Weather Part 1
DESCRIBE.ALPHA_LIGHTNINGGOAT = "Familiar aura, guardian."
DESCRIBE.UM_TORNADO = "High winds, senses... confused."
DESCRIBE.UM_WATERFALL = "Above, damage. Cracks in shell."
ANNOUNCE.ANNOUNCE_UM_NO_TORNADO = "High winds, nowhere near."

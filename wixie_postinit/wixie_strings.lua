local require = GLOBAL.require

STRINGS = GLOBAL.STRINGS
STRINGS.CHARACTERS.WIXIE = require "speech_wixie"
ANNOUNCE = STRINGS.CHARACTERS.WIXIE
DESCRIBE = STRINGS.CHARACTERS.WIXIE.DESCRIBE
ACTIONFAIL = STRINGS.CHARACTERS.WIXIE.ACTIONFAIL

STRINGS.NAMES.WIXIE = "Wixie"
STRINGS.CHARACTER_TITLES.wixie = "The Delinquent"
STRINGS.CHARACTER_NAMES.wixie = "Wixie"
STRINGS.CHARACTER_DESCRIPTIONS.wixie =
    "*Good with a slingshot\n*Has a mighty shove\n*Is Claustrophobic"
STRINGS.CHARACTER_QUOTES.wixie = "\"It wasn't me!\""

STRINGS.SKIN_NAMES.wixie_none = "Wixie"

STRINGS.SKIN_QUOTES.wixie_none = "\"It wasn't me!\""
STRINGS.SKIN_DESCRIPTIONS.wixie_none =
    "A troubled youth that gets up to trouble."

if GetModConfigData("wixie_walter") then
    STRINGS.CHARACTER_DESCRIPTIONS.walter =
        "*Not afraid of anything, except getting hurt \n*Is a master of survival tactics \n*Has a four-legged friend \n*Is an expert dog trainer \n*Hates to see innocent animals get hurt"
end

--	[ 		Wixie Descriptions		]	--

ANNOUNCE.EQUIP_CHARLES = {
    "Just like old times!", "Giddy up, Charles!",
    "Let's round up some varmints!", "You're my favorite deputy!",
    "Me and you versus the world, Charles!", "Yee-haw!"
} -- Despite how cruel she can be, shes still a kid at the end of the day :)

ANNOUNCE.SHOVE_TARGET_TOO_FAT = "This guy is too fat to be pushed around!"
ANNOUNCE.UNCOMFORTABLE_HAT = "This hat is making me uncomfortable..."
ANNOUNCE.UNCOMFORTABLE_ARMOR = "This armor is making me uncomfortable..."

ANNOUNCE.DREADEYE_SPOOKED = "Hey! Get back here and let me hit you!"
ANNOUNCE.ANNOUNCE_HARDCORE_RES =
    "Are you reading this? Then let us know! Because it NO?"
ANNOUNCE.ANNOUNCE_WINONAGEN = "Mom told me never to play with electricity!"
ANNOUNCE.ANNOUNCE_RATRAID = "Oh no, I know what THAT sound means..."
ANNOUNCE.ANNOUNCE_RATRAID_SPAWN = "Rats?! Why'd it have to be rats..."
ANNOUNCE.ANNOUNCE_RATRAID_OVER =
    "My things! My beautiful things! Come back here!"
ANNOUNCE.ANNOUNCE_ACIDRAIN = {
    "Ow! Stop the pollution!", "I thought 'water never hurt anyone'!",
    "OUCH! I hope it doesn't burn through my clothes..."
}
ANNOUNCE.ANNOUNCE_TOADSTOOLED = "Great horney toads!"
-- FoodBuffs
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LESSERELECTRICATTACK =
    ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICRETALIATION =
    ANNOUNCE.ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_FROZENFURY = "M-my skin feels icy..."
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_VETCURSE = "I... I'm not afraid!"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_LESSERELECTRICATTACK =
    ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICRETALIATION =
    ANNOUNCE.ANNOUNCE_DETACH_BUFF_ELECTRICATTACK
ANNOUNCE.ANNOUNCE_DETACH_BUFF_FROZENFURY = "I think I've thawed out."
-- FoodBuffs

-- CaliforniaKing
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_CALIFORNIAKING =
    "That hit my stomach like a truck..."
ANNOUNCE.ANNOUNCE_DETACH_BUFF_CALIFORNIAKING = "Now I just have a headache..."
DESCRIBE.CALIFORNIAKING = "I don't think I'm old enough to drink this."
-- CaliforniaKing

ANNOUNCE.ANNOUNCE_RNEFOG = "Whose out there? Show yourself!"
DESCRIBE.UNCOMPROMISING_RAT = "Begone, you mangey thing!"
DESCRIBE.UNCOMPROMISING_RATHERD =
    "Even if we fill it in, they will find another way."
DESCRIBE.UNCOMPROMISING_RATBURROW =
    "Even if we fill it in, they will find another way."
DESCRIBE.UNCOMPROMISING_WINKYBURROW =
    "What treasures lie within? We may never know..."
DESCRIBE.UNCOMPROMISING_WINKYHOMEBURROW =
    "Not sure I want anything from a hole like that."

DESCRIBE.WINKY = {
    GENERIC = "Go bother someone else, pea brain!",
    ATTACKER = "You'd better not have rabies!",
    MURDERER = "Go crawl back in your hole, %s!",
    REVIVER = "Don't beg!",
    GHOST = "I wonder if any rats are haunting my house?",
    FIRESTARTER = "Fire?! Couldn't you just chew on some furniture or something, %s?"
}

DESCRIBE.WATHOM = {
    GENERIC = "Should I speak slowly, %s?",
    ATTACKER = "I think %s has a taste for blood.",
    MURDERER = "%s has gone feral! Run for your lives!",
    REVIVER = "Well, atleast you didn't eat the heart!",
    GHOST = "What a weird... ghost? How can there be a WEIRD ghost?!",
    FIRESTARTER = "Most beasts don't resort to burning stuff."
}

DESCRIBE.RATPOISONBOTTLE = "Troubles a' brewing!"
DESCRIBE.RATPOISON =
    "It seems a cruel, but those jerks need to be taken care of!"

DESCRIBE.MONSTERSMALLMEAT = "It's more monster than meat."
DESCRIBE.COOKEDMONSTERSMALLMEAT =
    "I've smoked out the monster. And most of the meat too..."
DESCRIBE.MONSTERSMALLMEAT_DRIED = "Maybe that helped?"

DESCRIBE.UM_MONSTEREGG = "Just a bad egg, like me!"
DESCRIBE.UM_MONSTEREGG_COOKED = "I hope that never happens to me!"

DESCRIBE.MUSHROOMSPROUT_OVERWORLD = "You can smell it from a mile away!"
DESCRIBE.TOADLING = "I can see the slime dripping off of it. Gross!"

DESCRIBE.GASMASK = "It smells in here! I don't wanna wear it!"
DESCRIBE.MOCK_DRAGONFLY = DESCRIBE.DRAGONFLY
DESCRIBE.MOTHERGOOSE = DESCRIBE.MOOSE
DESCRIBE.SPIDERQUEENCORPSE = "Ah, she caught the rigor mortis."
ANNOUNCE.ANNOUNCE_SNEEZE = "aaaAAAGLSCHOO!!"
ANNOUNCE.ANNOUNCE_HAYFEVER = "Agh, my nose is getting claustrophobic..."
ANNOUNCE.ANNOUNCE_HAYFEVER_OFF =
    "*sniff* *sniff* Aahhh, finally, my allergies are gone!"
ANNOUNCE.ANNOUNCE_SNOWSTORM =
    "Board up the windows, there is definetly a storm coming!"
ANNOUNCE.ANNOUNCE_FIREFALL = {
    "Hey, this shouldn't be a feature!", "Go tell a dev, you jerk!",
    "I thought we removed this!"
}
ANNOUNCE.ANNOUNCE_ROOTING = "Hands off! HANDS OFF!!"
ANNOUNCE.SHADOWTALKER = {
    "MOM WORKS ALL DAY, SHE WHITTLES AWAY", "DADS GONE AWAY, SO WE ALL PRAY",
    "WIXIES ALL ALONE, SULKING IN HER HOME"
}

DESCRIBE.UM_BEAR_TRAP = "Just like grans dentures!"
DESCRIBE.UM_BEAR_TRAP_OLD = "Old and flakey, just like gran."
DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_TOOTH = "Get em, sharky!"
DESCRIBE.UM_BEAR_TRAP_EQUIPPABLE_GOLD =
    "It's shiny bait and a trap, all in one!"
ANNOUNCE.ANNOUNCE_OVER_EAT = {
    STUFFED = "I couldn't help myself, I was hungry!",
    OVERSTUFFED = "I shouldn't have treated my stomach as an extra pocket..."
}
DESCRIBE.SAND = "Pocket sand! Hiya!"
DESCRIBE.SANDHILL = "It gets everywhere."
DESCRIBE.SNOWPILE = "Schools out forever!"
DESCRIBE.SNOWGOGGLES = "Snow in my eyes? Snow-way!"

DESCRIBE.SNOWMONG = "Hurry up and melt, 'Frosty'!"
DESCRIBE.SHOCKWORM = "I wish 'I' had scary looking frills..."
DESCRIBE.ZASPBERRY = "People hate it when I make that noise!"
DESCRIBE.ZASPBERRYPARFAIT = "Everything is better with electricity!"
DESCRIBE.ICEBOOMERANG = "Not as good as my slingshot, but it sure is fun!"
DESCRIBE.MINOTAUR_BOULDER = "How did THIS get here?"
DESCRIBE.MINOTAUR_BOULDER_BIG =
    "Hey, Klei! Why'd you have to go and copy my rework, Huh? HUH?!"
DESCRIBE.SNOWBALL_THROWABLE = "No one can match my aim!"
DESCRIBE.VETERANSHRINE =
    "Hey, you uh, have goop coming out of your eyes. And nose... and mouth..."
DESCRIBE.RAT_TAIL = "Definetly not candy."
DESCRIBE.PLAGUEMASK = "Now I can look like a dumb bird. Yay."
DESCRIBE.SPIDER_TRAPDOOR =
    "You MUST be living under a rock if you're facing ME!"
DESCRIBE.TRAPDOOR = "I bet I could skip this rock if I tried hard enough."
DESCRIBE.HOODEDTRAPDOOR = DESCRIBE.TRAPDOOR
DESCRIBE.WICKER_TENTACLE = "It's some kind of gross severed limb!"
DESCRIBE.HONEY_LOG = "You... TWIG HEAD! THAT WAS MY HONEY!!"

DESCRIBE.BUSHCRAB = "My berries! Give them back!"
DESCRIBE.LAVAE2 = DESCRIBE.LAVAE
DESCRIBE.DISEASECUREBOMB =
    "Why fix what's broke, when you can break it even more?"
DESCRIBE.SHROOM_SKIN_FRAGMENT =
    "I could stitch some of these together, I guess."
DESCRIBE.AIR_CONDITIONER = "It doesn't cool me off... and it smells!"
DESCRIBE.SPOREPACK = "It better not give me a rash."
DESCRIBE.SALTPACK = "Salt your sidewalks, or else!"

DESCRIBE.UM_SCORPION = "What are YOU smiling at?!"
DESCRIBE.SCORPIONCARAPACE = "Is it... edible?"
DESCRIBE.SCORPIONCARAPACECOOKED =
    "Did that improve it? Only one way to find out..."
DESCRIBE.HARDSHELLTACOS = "Ah, street food! How I missed you..."

DESCRIBE.SKELETONMEAT =
    "I've read enough horror stories to know this is a BAD idea."
DESCRIBE.CHIMP = DESCRIBE.MONKEY
DESCRIBE.SWILSON = ""
DESCRIBE.VAMPIREBAT = "I vaaant you to gooo avaaay!"
DESCRIBE.LUREPLAGUE_RAT = "Gah! What the heck is that?!"

-- Swampyness
DESCRIBE.RICEPLANT = "That's boring food!"
DESCRIBE.RICE = "It's... moving?"
DESCRIBE.RICE_COOKED = "Well, it's not moving anymore."
DESCRIBE.SEAFOODPAELLA = "The fish has made the rice less boring!"
DESCRIBE.LICELOAF = "I could build a little house with a couple of these!"
DESCRIBE.SUNGLASSES = "They make me look cool!"

DESCRIBE.CRITTERLAB_REAL = DESCRIBE.CRITTERLAB
DESCRIBE.CRITTERLAB_REAL_BROKEN =
    "It's better off broken, but I COULD repair it with some moon rocks."
DESCRIBE.SLINGSHOTAMMO_FIRECRACKERS = DESCRIBE.FIRECRACKERS
DESCRIBE.WALRUS_CAMP_SUMMER = DESCRIBE.WALRUS_CAMP
DESCRIBE.CHARLIEPHONOGRAPH_100 = DESCRIBE.MAXWELLPHONOGRAPH
DESCRIBE.BUGZAPPER = "You remind me of... me!"
DESCRIBE.STUMPLING = "You're barking up the wrong tree!"
DESCRIBE.BIRCHLING = DESCRIBE.STUMPLING
DESCRIBE.MOON_TEAR = "Quit crying! You're going to stain everything!"
DESCRIBE.SHADOW_TELEPORTER = "Neat gem! It's mine now."
DESCRIBE.POLLENMITEDEN = "Just burn them and get it over with!"
DESCRIBE.POLLENMITES = "Don't touch me!"
DESCRIBE.SHADOW_CROWN = "Fit for a queen, or even better, me!"
DESCRIBE.RNEGHOST = DESCRIBE.GHOST
DESCRIBE.TRAPDOORGRASS = DESCRIBE.GRASS
DESCRIBE.MARSH_GRASS = "You're useless!"
DESCRIBE.CURSED_ANTLER = "A trophy of my conquest!"
DESCRIBE.BERNIEBOX = "The writing is all gibberish!"
DESCRIBE.HOODED_FERN = "That's horse food, not people food!"
DESCRIBE.HOODEDWIDOW = "Nope! Nope! Definetly not!"
DESCRIBE.GIANT_TREE =
    "It's tall. And imposing. And... I don't like looking at it."
DESCRIBE.ANCIENTHOODEDTURF = DESCRIBE.TURF_FOREST
DESCRIBE.HOODEDMOSS = DESCRIBE.TURF_FOREST
DESCRIBE.WIDOWSGRASP = "Just seven more and I could pretend to be a spider!"
DESCRIBE.WEBBEDCREATURE = "Gross, I'd hate to get trapped in there..."
ANNOUNCE.WEBBEDCREATURE = "I could break it if I was trying!"
DESCRIBE.SNAPDRAGON_BUDDY = "Don't start getting friendly!"
DESCRIBE.SNAPDRAGON = "I doubt it has a brain."
DESCRIBE.SNAPPLANT = "Those big plants love it for some dumb reason."
DESCRIBE.WHISPERPOD = "I ain't letting a plant tell me what to do!"
DESCRIBE.WHISPERPOD_NORMAL_GROUND = {
    GENERIC = "What? You want more?",
    GROWING = "Hurry up! Ugh!"
}
DESCRIBE.FRUITBAT = "I'd like to take a bite out of it."
DESCRIBE.PITCHERPLANT = "We want a pitcher, not a belly itcher!"
DESCRIBE.APHID = "Don't go biting holes in my clothes, you dork!"
DESCRIBE.GIANT_TREE_INFESTED =
    "What kind of weirdo would live in a place like that?"
DESCRIBE.GIANT_BLUEBERRY = "That'd make a mess for sure!"
DESCRIBE.STEAMEDHAMS = "At this time of day, in this part of the wilderness?"
DESCRIBE.BLUEBERRYPANCAKES =
    "Mum taught me how to make them! They're my favorite!"
DESCRIBE.SIMPSALAD = "It's... leafy? And... purple?"
DESCRIBE.BEEFALOWINGS = "Perfect for bulking up!"
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_KNOCKBACKIMMUNE = "No one can knock me over!"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_KNOCKBACKIMMUNE =
    "Ah, well... I still can't be pushed around!"
DESCRIBE.WIDOWSHEAD = "It's still fresh. And disgusting."
DESCRIBE.HOODED_MUSHTREE_TALL = DESCRIBE.MUSHTREE_TALL
DESCRIBE.HOODED_MUSHTREE_MEDIUM = DESCRIBE.MUSHTREE_MEDIUM
DESCRIBE.HOODED_MUSHTREE_SMALL = DESCRIBE.MUSHTREE_SMALL
DESCRIBE.WATERMELON_LANTERN = "I've learned to be resourceful."

-- Viperstuff Quotes
DESCRIBE.VIPERWORM = "Quit lurking, creep!"
DESCRIBE.VIPERFRUIT = "It's probably poisonous."
DESCRIBE.VIPERJAM = "But no bread to spread on..."

DESCRIBE.BLUEBERRYPLANT = {
    READY = "Mmmm! Don't mind if I do!",
    FROZE = "Aw man! It's stuck in there!",
    REGROWING = "That was fun!"
}

DESCRIBE.ANTIHISTAMINE = "\"Snot nosed\"?! I'll show them!"
ANNOUNCE.CURSED_ITEM_EQUIP = "ACK! My hand! Who dares?"
DESCRIBE.VETSITEM = "I don't let peer pressure get to me!"
DESCRIBE.SCREECHER_TRINKET = "Mum never carved stuff like this..."
ACTIONFAIL.GIVE = {NOTNIGHT = "Something tells me I need to wait for night."}

DESCRIBE.MAGMAHOUND = "Begone, scabby!"
DESCRIBE.LIGHTNINGHOUND = "Stop shouting, you loudmouth! "
DESCRIBE.SPOREHOUND = "Don't get your filth on me!"
DESCRIBE.GLACIALHOUND = "We've got a spitter!"
DESCRIBE.RNESKELETON = "I'm about to rattle your bones!"
DESCRIBE.RAT_WHIP = "This is gonna sting!"
DESCRIBE.KLAUS_AMULET = "I think... this is useless to me."
DESCRIBE.CRABCLAW = "The more gems you put, the heavier the 'clonk'!"
DESCRIBE.HAT_RATMASK = "Think like a rat, smell like a rat, BE the rat!"

DESCRIBE.ORANGE_VOMIT = "Don't make me touch it!"
DESCRIBE.GREEN_VOMIT = "Don't make me touch it!"
DESCRIBE.RED_VOMIT = "Don't make me touch it!"
DESCRIBE.PINK_VOMIT = "Don't make me touch it!"
DESCRIBE.YELLOW_VOMIT = "Don't make me touch it!"
DESCRIBE.PURPLE_VOMIT = "Don't make me touch it!"
DESCRIBE.PALE_VOMIT = "Don't make me touch it!"

DESCRIBE.WALRUS_CAMP_EMPTY = DESCRIBE.WALRUS_CAMP.EMPTY
DESCRIBE.PIGKING_PIGGUARD = {
    GUARD = DESCRIBE.PIGMAN.GUARD,
    WEREPIG = DESCRIBE.PIGMAN.WEREPIG
}

DESCRIBE.BIGHT = "Gross! It's some weird horse hybrid..."
DESCRIBE.KNOOK = "Hey! Leave that horse alone!"
DESCRIBE.ROSHIP = "Tangled and mangled."

DESCRIBE.UM_PAWN = "I want to knock it over!"
DESCRIBE.UM_PAWN_NIGHTMARE = "It looks... unstable."

DESCRIBE.CAVE_ENTRANCE_SUNKDECID = DESCRIBE.CAVE_ENTRANCE
DESCRIBE.CAVE_ENTRANCE_OPEN_SUNKDECID = DESCRIBE.CAVE_ENTRANCE_OPEN
DESCRIBE.CAVE_EXIT_SUNKDECID = DESCRIBE.CAVE_EXIT

DESCRIBE.PIGKING_PIGTORCH = DESCRIBE.PIGTORCH
-- Blowgun stuff
DESCRIBE.UNCOMPROMISING_BLOWGUN = DESCRIBE.BLOWDART_PIPE
DESCRIBE.BLOWGUNAMMO_TOOTH = DESCRIBE.BLOWDART_PIPE
DESCRIBE.BLOWGUNAMMO_FIRE = DESCRIBE.BLOWDART_FIRE
DESCRIBE.BLOWGUNAMMO_SLEEP = DESCRIBE.BLOWDART_SLEEP
DESCRIBE.BLOWGUNAMMO_ELECTRIC = DESCRIBE.BLOWDART_YELLOW
DESCRIBE.CORNCAN = "Kick the can!"
DESCRIBE.SKULLCHEST_CHILD = "I think there is supposed to be another one."

DESCRIBE.ANCIENT_AMULET_RED = "I'd like to keep my soul to myself."
DESCRIBE.SLOBBERLOBBER = "Hahaha! I love this thing!"
DESCRIBE.GORE_HORN_HAT = "Steer clear, jerk-wads!"
DESCRIBE.BEARGERCLAW = "I'm diggin this!"
DESCRIBE.FEATHER_FROCK = "No way I'm flying in this thing."

DESCRIBE.REDGEM_CRACKED = DESCRIBE.REDGEM ..
                              "\nI didn't mean to- I mean, I didn't break it!"
DESCRIBE.BLUEGEM_CRACKED = DESCRIBE.BLUEGEM ..
                               "\nI didn't mean to- I mean, I didn't break it!"
DESCRIBE.ORANGEGEM_CRACKED = DESCRIBE.ORANGEGEM ..
                                 "\nI didn't mean to- I mean, I didn't break it!"
DESCRIBE.GREENGEM_CRACKED = DESCRIBE.GREENGEM ..
                                "\nI didn't mean to- I mean, I didn't break it!"
DESCRIBE.YELLOWGEM_CRACKED = DESCRIBE.YELLOWGEM ..
                                 "\nI didn't mean to- I mean, I didn't break it!"
DESCRIBE.PURPLEGEM_CRACKED = DESCRIBE.PURPLEGEM ..
                                 "\nI didn't mean to- I mean, I didn't break it!"
DESCRIBE.OPALPRECIOUSGEM_CRACKED = DESCRIBE.OPALPRECIOUSGEM ..
                                       "\nI didn't mean to- I mean, I didn't break it!"

DESCRIBE.RED_MUSHED_ROOM = "I crushed it!"
DESCRIBE.GREEN_MUSHED_ROOM = "I crushed it!"
DESCRIBE.BLUE_MUSHED_ROOM = "I crushed it!"

-- StantonStuff
DESCRIBE.SKULLFLASK = "It's not adult drink, right?"
DESCRIBE.SKULLFLASK_EMPTY = "Blech, how can they drink that stuff?"
DESCRIBE.STANTON_SHADOW_TONIC = "Don't offer that stuff to kids, you creep!"
DESCRIBE.STANTON_SHADOW_TONIC_FANCY = DESCRIBE.STANTON_SHADOW_TONIC
DESCRIBE.STANTON = "No thanks, creep."
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HYPERCOURAGE = "Now I'm extra unafraid!"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_HYPERCOURAGE =
    "Back to normal levels of toughness."
-- StantonStuff

DESCRIBE.ARMORLAVAE = DESCRIBE.LAVAE

DESCRIBE.THEATERCORN = "The butter really drowns out the corn flavor."
DESCRIBE.DEERCLOPS_BARRIER = "Let me out! LET ME OUT!!"

-- Stuff for Canis to check

DESCRIBE.MOONMAW_DRAGONFLY = "It's made of glass, how tough can it possibly be?"
DESCRIBE.MOONMAW_LAVAE = "You're getting shattered for sure!"
DESCRIBE.SNAPPERTURTLE = "You should know; I bite back!"
DESCRIBE.SNAPPERTURTLEBABY = "Cute, but don't try to snap me!"
DESCRIBE.SNAPPERTURTLENEST = "Looks like free breakfast to me!"
DESCRIBE.GLASS_SCALES = "Ooh, shiny blue glass."
DESCRIBE.MOONGLASS_GEODE = "I got a rock..."
DESCRIBE.ARMOR_GLASSMAIL = "I don't need a posse!"
DESCRIBE.ARMOR_GLASSMAIL_SHARDS = "What? Stop talking!"
-- Stuff for Canis to check
DESCRIBE.MOONMAW_GLASSSHARDS_RING = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
DESCRIBE.MOONMAW_GLASSSHARDS = DESCRIBE.ARMOR_GLASSMAIL_SHARDS
DESCRIBE.MOONMAW_LAVAE_RING = DESCRIBE.MOONMAW_LAVAE

DESCRIBE.MUTATOR_TRAPDOOR = DESCRIBE.MUTATOR_WARRIOR

DESCRIBE.WOODPECKER = "How much could he possibly peck?"
DESCRIBE.SNOTROAST = "I think I've seen this at the church potluck before..."
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_LARGEHUNGERSLOW = "No seconds for me, please..."
ANNOUNCE.ANNOUNCE_DETACH_BUFF_LARGEHUNGERSLOW = "I could go for a bite!"
DESCRIBE.BOOK_RAIN_UM = "It's a prequel story."
DESCRIBE.FLORAL_BANDAGE = "I don't want that goop in my wounds..."
DESCRIBE.DORMANT_RAIN_HORN = "I hate the ocean."
DESCRIBE.RAIN_HORN = "I hope it makes a loud, annoying noise."
DESCRIBE.DRIFTWOODFISHINGROD =
    "It comes from the sea, so it will work better. Right?"

ANNOUNCE.ANNOUNCE_RATSNIFFER_ITEMS = {
    LEVEL_1 = "I hate cleaning my room, but I don't want rats, so..."
}
ANNOUNCE.ANNOUNCE_RATSNIFFER_FOOD = {
    LEVEL_1 = "It smells of rotting food around here! Quick, someone else throw it out!"
}
ANNOUNCE.ANNOUNCE_RATSNIFFER_BURROWS = {
    LEVEL_1 = "We need to find where all these rats are coming from!"
}

DESCRIBE.PIED_RAT = "Take a bath, greasy!"
DESCRIBE.PIED_PIPER_FLUTE = "Make sure to wash it first..."
DESCRIBE.UNCOMPROMISING_PACKRAT = "Hey! Give me your stuff!"

ANNOUNCE.ANNOUNCE_PORTABLEBOAT_SINK = "I knew this wasn't going to hold!"

ACTIONFAIL.CHARGE_FROM = {
    NOT_ENOUGH_CHARGE = "Needs some juice.",
    CHARGE_FULL = "Ooh, sparky!"
}
ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_INSULATED = "I'm shock proof!"
ANNOUNCE.ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED = "OW! Stupid electricity..."

----UNDER THE WEATHER----

DESCRIBE.WINONA_TOOLBOX = "It belongs to the lug-head."
ACTIONFAIL.WINONATOOLBOX = "What is she hiding?!"
DESCRIBE.POWERCELL = "It's big, heavy, and dangerous. I like it!"
DESCRIBE.WINONA_UPGRADEKIT_ELECTRICAL =
    "Neat. I don't know what it is, but it's neat!"
DESCRIBE.MINERHAT_ELECTRICAL = "Electricity makes everything better!"
DESCRIBE.OCEAN_SPEAKER =
    "Is it... making noise? I can't tell... my head hurts..."
-- DESCRIBE.UM_SIREN = "Oh yeah!? I can blow bubbles twice as big! Watch!"

-- DESCRIBE.OCUPUS_BEAK = ""
DESCRIBE.OCUPUS_TENTACLE = "Go back to the depths!"
DESCRIBE.OCUPUS_TENTACLE_EYE = "Take a picture, it'll last longer!"
DESCRIBE.OCUPUS_TENTACLE_COOKED = "I hate seafood."

DESCRIBE.ARMOR_REED_UM = "Flimsy, but lightweight!"
DESCRIBE.ARMOR_SHARKSUIT_UM = "It's heavy and it makes me look stupid."
DESCRIBE.ROCKJAWLEATHER = "How does it stay afloat?"

DESCRIBE.EYEOFTERROR_MINI_ALLY = DESCRIBE.EYEOFTERROR_MINI -- TODO!
DESCRIBE.EYEOFTERROR_MINI_GROUNDED_ALLY = DESCRIBE.EYEOFTERROR_MINI_GROUNDED

DESCRIBE.STUFFED_PEEPER_POPPERS = "That's sick!"
DESCRIBE.UM_DEVILED_EGGS = "The power of me compells you!"
DESCRIBE.LUSH_ENTRANCE = "It's overgrown..."
DESCRIBE.CRITTER_FIGGY = "Stop biting me! Go away!"
DESCRIBE.GIANT_TREE_BIRDNEST = "Oops, oh well."
ACTIONFAIL.UPGRADE.NOT_HARVESTED = "Someone should clean this up!"

DESCRIBE.SLUDGE = "It's sticky, and smells like... gross stuff."
DESCRIBE.SLUDGE_OIL = "It's definetly not a drink."
DESCRIBE.SLUDGE_SACK = "It's going to stain my clothes..."
DESCRIBE.CANNONBALL_SLUDGE_ITEM = "Fire! FIRE!!"
DESCRIBE.BOAT_BUMPER_SLUDGE = "Bumper cars! Just like the carnival!"
DESCRIBE.BOAT_BUMBER_SLUDGE_KIT = "I'm great at putting up walls."
DESCRIBE.BOATPATCH_SLUDGE = "Put a cork in it!"
DESCRIBE.UM_COPPER_PIPE = "Bonk!"
DESCRIBE.BRINE_BALM = "I'm great at this!"
DESCRIBE.UNCOMPROMISING_FISHINGNET = "Feed me for a life time!"
DESCRIBE.UM_AMBER = "I saw a candy like this before."
DESCRIBE.UM_BEEGUN = "Bee gone!"
DESCRIBE.BULLETBEE = DESCRIBE.KILLERBEE
DESCRIBE.CHERRYBULLETBEE = DESCRIBE.KILLERBEE
DESCRIBE.SUNKENCHEST_ROYAL_RANDOM = "Treasure, fit for a queen!"
DESCRIBE.SUNKENCHEST_ROYAL_RED = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_BLUE = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_PURPLE = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_GREEN = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_ORANGE = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_YELLOW = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM
DESCRIBE.SUNKENCHEST_ROYAL_RAINBOW = DESCRIBE.SUNKENCHEST_ROYAL_RANDOM

DESCRIBE.STEERINGWHEEL_COPPER = "Catch me now, coppers!"
DESCRIBE.STEERINGWHEEL_COPPER_ITEM = "Now where to put it..."
DESCRIBE.BOAT_BUMPER_COPPER = "I hope it doesn't sink the boat."
DESCRIBE.BOAT_BUMPER_COPPER_KIT = "Bump and bruise!"
DESCRIBE.UM_DREAMCATCHER = "Take my nightmares, go ahead."
DESCRIBE.UM_BRINEISHMOSS = "Missy mossy."
DESCRIBE.UM_COALESCED_NIGHTMARE = "Is that what my nightmares look like?"
DESCRIBE.SLUDGE_CORK = "Put a cork in it!"
DESCRIBE.SLUDGESTACK = "What is that stuff? I don't recognize it..."
DESCRIBE.SPECTER_SHIPWRECK = "I hope it's haunted!"

DESCRIBE.UNCOMPROMISING_HARPOON = "no."
DESCRIBE.UNCOMPROMISING_HARPOON_HEAVY = "no no it no false."
DESCRIBE.UNCOMPROMISING_HARPOONREEL = "nahhhh."
DESCRIBE.UM_MAGNERANG = "Does it have a reverse mode?"
DESCRIBE.UM_MAGNERANGREEL = "I'd hate to be tied down to one spot."
DESCRIBE.SIREN_THRONE = "It's where miss priss likes to sit." -- Dumb kid.
DESCRIBE.LAVASPIT_SLUDGE = "Whole lotta hot goop."

DESCRIBE.UM_BEEGUARD_SHOOTER = DESCRIBE.BEEGUARD
DESCRIBE.UM_BEEGUARD_SEEKER = DESCRIBE.BEEGUARD
DESCRIBE.UM_BEEGUARD_BLOCKER =
    "That's fine, I wasn't planning on getting too close anyway!"

DESCRIBE.WIXIE_PIANO = "I miss my piano lessons..."
DESCRIBE.WIXIE_CLOCK = "Atleast it's ticking won't keep me up at night."
DESCRIBE.WIXIE_WARDROBE = "Well now I know what was making all that noise..."
DESCRIBE.CHARLES_T_HORSE = "Charles...?"
DESCRIBE.THE_REAL_CHARLES_T_HORSE = "Charles!! I thought I'd never find you!"

DESCRIBE.UM_ORNAMENT_OPOSSUM = "I think we have a lot in common!"
DESCRIBE.UM_ORNAMENT_RAT = "Pretty cute, for a pest."

DESCRIBE.TRINKET_WATHOM1 = "Haha, what a dork!"

DESCRIBE.CODEX_MANTRA = DESCRIBE.WAXWELLJOURNAL

DESCRIBE.MARA_BOSS1 = "I'm about to rattle your bones!"

-- Pyre Nettle stuff
DESCRIBE.UM_PYRE_NETTLES = "Arms to yourself, pokey!"
DESCRIBE.UM_SMOLDER_SPORE = "Hey, just the right size!"
ANNOUNCE.ANNOUNCE_SMOLDER_SPORE_EATEN = "Ack! I HATE spicy foods!."
ANNOUNCE.ANNOUNCE_SMOLDER_SPORE_INVENTORY_POP = "Yeah, I'm on fire!! HELP!"
DESCRIBE.UM_ARMOR_PYRE_NETTLES = "I guess it would keep OTHER stuff off me..."
DESCRIBE.UM_BLOWDART_PYRE = "It's not as good as my slingshot, but it'll do the trick."


-- Under the Weather Part 1
DESCRIBE.ALPHA_LIGHTNINGGOAT = "Baa!!! BAAAA!"
DESCRIBE.UM_TORNADO = "Quit yankin' my ribbon!"
DESCRIBE.UM_WATERFALL = "Wish I had my splashin' clothes!"

local general_scripts = require("play_generalscripts")

STRINGS.STAGEACTOR.WIXIE1 = {
    "So how about that so called 'scientist'?",
    "\"All my experiments blew up? That's what I call science!\"",
    "And that mopey crying girl?",
    "\"Oh woe is me! I have a GHOST for a sister! Woe is me!\"",
    "And don't get me STARTED on that obnoxious boyscout...",
    "\"Careful everybody, fire is dangerous! Hey, wanna see my bugs?!\"",
    "Thank you, thank you, I'll be here all eternity.", "Tip your beefalo!"
}

general_scripts.WIXIE1 = {
    cast = {"wixie"},
    lines = {
        {roles = {"wixie"}, duration = 3.0, line = STRINGS.STAGEACTOR.WIXIE1[1]},
        {
            roles = {"wixie"},
            duration = 3.5,
            line = STRINGS.STAGEACTOR.WIXIE1[2],
            anim = "idle_wilson"
        },
        {roles = {"wixie"}, duration = 2.5, line = STRINGS.STAGEACTOR.WIXIE1[3]},
        {
            roles = {"wixie"},
            duration = 4,
            line = STRINGS.STAGEACTOR.WIXIE1[4],
            anim = "idle_wendy"
        },
        {roles = {"wixie"}, duration = 3.0, line = STRINGS.STAGEACTOR.WIXIE1[5]},
        {
            roles = {"wixie"},
            duration = 4.0,
            line = STRINGS.STAGEACTOR.WIXIE1[6],
            anim = "idle_walter"
        },
        {roles = {"wixie"}, duration = 3.0, line = STRINGS.STAGEACTOR.WIXIE1[7]},
        {
            roles = {"wixie"},
            duration = 1.5,
            line = STRINGS.STAGEACTOR.WIXIE1[8],
            anim = "emote_jumpcheer"
        }
    }
}
--[[
	STRINGS.STAGEACTOR.WIXIE2 =
		{
			"There once was a man named Maxwell.",
			"He .",
			"The Mime follows suit, tumbling to the ground.",
			"The Strongmans head makes a hollow *thunk*, and he says;",
			"\"Me no understand this \"slap-stick\" stuff!\"",
			"...",
			"Hello? Is this thing on?",
		}

	general_scripts.WIXIE2 = {
		cast = { "wixie" },
		lines = {
			{roles = {"wixie"},     duration = 5.0, line = STRINGS.STAGEACTOR.WIXIE2[1]},
			{roles = {"wixie"},     duration = 3.5, line = STRINGS.STAGEACTOR.WIXIE2[2]},
			{roles = {"wixie"},     duration = 3.0, line = STRINGS.STAGEACTOR.WIXIE2[3]},
			{roles = {"wixie"},     duration = 3.5, line = STRINGS.STAGEACTOR.WIXIE2[4]},
			{roles = {"wixie"},     duration = 4.0, line = STRINGS.STAGEACTOR.WIXIE2[5]},
			{roles = {"wixie"},     duration = 2.0, line = STRINGS.STAGEACTOR.WIXIE2[6], anim = "emote_impatient"},
			{roles = {"wixie"},     duration = 2.0, line = STRINGS.STAGEACTOR.WIXIE2[7], anim = "emote_impatient"},
		}
	}]]

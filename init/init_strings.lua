STRINGS = GLOBAL.STRINGS
-- [              DSTU Related Overrides                  ]

STRINGS.DSTU = {
    ACID_PREFIX =
    {
        NONE = "",
        GENERIC = "Corroding",
        RABBITHOLE = "",
        CLOTHING = "Eroding",
        FUEL = "Caustic",
        TOOL = "Rusting",
        FOOD = "Sour",
        POUCH = "Deteriorating",
        WETGOOP = "Toxic",
    },

}
STRINGS.SPELLS.SHADOW_MIMIC = "Shadow Mimic"

STRINGS.NAMES.WINKY = "Winky"
STRINGS.CHARACTER_TITLES.winky = "The Vile Vermin"
STRINGS.CHARACTER_NAMES.winky = "Winky"
STRINGS.CHARACTER_DESCRIPTIONS.winky = "*Is a Rat\n*Can dig interconnected burrows\n*'Is weak, but fast'\n*Can eat horrible foods\n*Hates to lose hold of things"
STRINGS.CHARACTER_QUOTES.winky = "\"Squeak!\""

STRINGS.SKIN_NAMES.winky_none = "Winky"

STRINGS.SKIN_QUOTES.winky_none = "\"Squeak!\""
STRINGS.SKIN_DESCRIPTIONS.winky_none = "She's a fan of shiny things."

STRINGS.ACTIONS.CREATE_BURROW = "Make Burrow"
STRINGS.ACTIONS.ACTIVATE.RECRUITRAT = "Recruit A Rat"

STRINGS.ACTIONS.TURNOFF.HARPOON = "Break Reel"
STRINGS.ACTIONS.ACTIVATE.HARPOON = "Reel"
STRINGS.ACTIONS.CASTSPELL.HARPOON = "Throw Magnerang"
STRINGS.ACTIONS.CHARGE_POWERCELL = "Charge Equipment"
STRINGS.ACTIONS.DEPLOY.POWERCELL = "Charge Equipment"
STRINGS.ACTIONS.UPGRADE.SLUDGE_CORK = "Plug"
STRINGS.ACTIONS.USESPELLBOOK = {
    BOOK = "Read",
    TELESTAFF = "Select Focus"
}
STRINGS.ACTIONS.WX_CHARGEFROMPOWERCELL = "Charge"
STRINGS.ACTIONS.CASTSPELL.CHARLES_CHARGE = "Charge!"
STRINGS.ACTIONS.CASTSPELL.SLINGSHOT = "Shoot"
STRINGS.ACTIONS.ACTIVATE.UM_TORNADOTRACKER = "Locate Tornadoes -"


STRINGS.VETS_WIDGET_WANDA = "Veteran's Curse:\n - Age faster when damaged.\n - Hunger drains faster.\n - Sanity from foods is applied *slowly* over time.\n - Gain the ability to wield cursed items, dropped by certain bosses."
STRINGS.VETS_WIDGET = "Veteran's Curse:\n - Receive more damage when attacked.\n - Hunger drains faster.\n - Health and Sanity from foods is applied *slowly* over time.\n - Gain the ability to wield cursed items, dropped by certain bosses."
STRINGS.VETS_CONFIRMED_TITLE = "You Made Your Choice."
STRINGS.VETS_CONFIRMED = "Now you must live with the consequences..."

STRINGS.VETS_TITLE = "The Veterans Curse."
STRINGS.VETS = "You're about to be afflicted with a crippling curse.\nYour body will treat you more harshly,\nhowever fortune favors the bold (or foolish)! \n \nTouch the skull again to seal your fate."

STRINGS.VETS_OK = "Ok"

STRINGS.PACTSWORN_TITLE = "The Shadow Pact"
STRINGS.PACTSWORN_TEXT = "A new path lies before you, if you give up the Codex Umbra. You will lose your spells and take 25% more damage, but you will gain a summonable sword, armor, and true classic shadows.\nThis cannot be undone."

STRINGS.PIG_REMEMBER_THREAT = { "REMEMBER YOU!", "YOU HURT US!", "YOU MEAN!" }
STRINGS.PIG_GUARD_PIGKING_TALK_LOOKATWILSON = { "NO SMASH HOUSES", "US WATCHING YOU", "BE GOOD HERE", "WATCHING YOU" }
STRINGS.PIG_GUARD_PIGKING_TALK_LOOKATWILSON_NIGHT = { "KING SLEEPING, YOU GO NOW", "YOU LEAVE NOW",
    "STAY AND WE GET MEAN", "KING NEED SLEEP, GO AWAY" }
STRINGS.PIG_GUARD_PIGKING_TALK_LOOKATWILSON_EVENING = { "KING BED TIME SOON, YOU GO NOW", "NO DISTURB KING SLEEP",
    "KING NEEDS BEAUTY SLEEP, GO", "NIGHT SOON, YOU LEAVE NOW" }
STRINGS.PIG_GUARD_PIGKING_TALK_LOOKATWILSON_FRIEND = { "KING SAY PROTECT", "PROTECT YOU", "WHERE MONSTERS?", "PROTECT!",
    "PROTECT KING!", "PROTECT FRIEND!" }

-- Hey look! I actually did something! -Canis
STRINGS.CHARACTER_DESCRIPTIONS.willow = STRINGS.CHARACTER_DESCRIPTIONS.willow .. "\n󰀕Can ignite things in the cold"
if GetModConfigData("bernie_buffs") then
    STRINGS.CHARACTER_DESCRIPTIONS.willow = STRINGS.CHARACTER_DESCRIPTIONS.willow .. "\n󰀕Hugging Bernie keeps the shadows at bay"
end
if GetModConfigData("wxless") then
    STRINGS.CHARACTER_DESCRIPTIONS.wx78 = STRINGS.CHARACTER_DESCRIPTIONS.wx78 .. "\n󰀕Circuits drain charge and degrade overtime\n󰀕Motherboard has more space and powers all components until last charge\n󰀕Resting and eating refills internal batteries"
end
if GetModConfigData("wx78") then
    STRINGS.CHARACTER_DESCRIPTIONS.wx78 = STRINGS.CHARACTER_DESCRIPTIONS.wx78 .. "\n󰀕Systems are not repaired via lightning"
end
if GetModConfigData("wickerbottom") then
    STRINGS.CHARACTER_DESCRIPTIONS.wickerbottom = STRINGS.CHARACTER_DESCRIPTIONS.wickerbottom ..
        "\n󰀕Reading requires brainpower"
end
STRINGS.CHARACTER_DESCRIPTIONS.wes = STRINGS.CHARACTER_DESCRIPTIONS.wes .. "\n󰀕Expanded inner dialogue" --"\n󰀕Pengulls are fond of mimes"
STRINGS.CHARACTER_DESCRIPTIONS.waxwell = STRINGS.CHARACTER_DESCRIPTIONS.waxwell .. "\n󰀕Can make a pact to summon his old puppets and shadow equipment at will"
if GetModConfigData("wolfgang") then
    STRINGS.CHARACTER_DESCRIPTIONS.wolfgang = "*Stronger on a full belly\n*Grows mightier when well fed and calm minded\n*Is afraid of monsters and the dark\n*Is quite the showboat"
end
if GetModConfigData("warly_food_taste_") then
    STRINGS.CHARACTER_DESCRIPTIONS.warly = STRINGS.CHARACTER_DESCRIPTIONS.warly ..
        "\n󰀕Absorbs nutrients better, but prefers more variety"
end
if GetModConfigData("warly_butcher_") then
    STRINGS.CHARACTER_DESCRIPTIONS.warly = STRINGS.CHARACTER_DESCRIPTIONS.warly ..
        "\n󰀕Is a certified butcher"
end
if GetModConfigData("winonaworker") then
    STRINGS.CHARACTER_DESCRIPTIONS.winona = STRINGS.CHARACTER_DESCRIPTIONS.winona .. "\n󰀕Works hard until lunch"
end
if GetModConfigData("wortox") then
    STRINGS.CHARACTER_DESCRIPTIONS.wortox = STRINGS.CHARACTER_DESCRIPTIONS.wortox .. "\n󰀕Souls take time to heal and heal less\n󰀕Some weak creatures have no soul"
end
if GetModConfigData("wigfrid") then
    STRINGS.CHARACTER_DESCRIPTIONS.wathgrithr = STRINGS.CHARACTER_DESCRIPTIONS.wathgrithr .. "\n󰀕Combat is less sustaining"
end
if TUNING.DSTU.WORMWOOD_CONFIG_FIRE then
    STRINGS.CHARACTER_DESCRIPTIONS.wormwood = STRINGS.CHARACTER_DESCRIPTIONS.wormwood .. "\n󰀕Is dangerously flammable"
end

--I also did something! I love mod compatibility :) -CarlosBraw
if GLOBAL.KnownModIndex:IsModEnabled("workshop-2010472942") then
    STRINGS.CHARACTER_DESCRIPTIONS.wragonfly = STRINGS.CHARACTER_DESCRIPTIONS.wragonfly .. "\n󰀕Can breath in summer's smog"
    STRINGS.CHARACTER_DESCRIPTIONS.weerclops = STRINGS.CHARACTER_DESCRIPTIONS.weerclops .. "\n󰀕Not slowed down by winter's strong winds\n󰀕Is well accustomed to snow"
end
if GLOBAL.KnownModIndex:IsModEnabled("workshop-1847716441") then
    STRINGS.CHARACTER_DESCRIPTIONS.plaguedoctor = STRINGS.CHARACTER_DESCRIPTIONS.plaguedoctor .. "\n󰀕Mask protects against smog"
end


STRINGS.STANTON_GREET = { "Care to drink with the dead?", "How's about a drink?", "C'mon and drink with me." }
STRINGS.STANTON_GIVE = { "There ya go.", "The finest." }
STRINGS.STANTON_RULES = { "I only drink with one at a time." }
STRINGS.STANTON_GLOAT = { "Ha! I knew you were soft.", "Ha! You lose!" }

STRINGS.STANTON_POET1 = { "When it's six to midnight and the boney hand of death is nigh." }
STRINGS.STANTON_POET2 = { "You better drink your drink and shut your mouth." }
STRINGS.STANTON_POET3 = { "If you draw against his hand, you can never win." }
STRINGS.STANTON_POET4 = { "Go ahead… drink with the living dead." }
STRINGS.STANTON_POET5 = { "Drink with the living dead." }


STRINGS.UI.COOKBOOK.UM_BEEFALOWINGS = "Prevents Knockback"
STRINGS.UI.COOKBOOK.UM_CALIFORNIAKING = "Immunity to Hayfever"
STRINGS.UI.COOKBOOK.UM_LICELOAF = "Moderate Hayfever Relief"
STRINGS.UI.COOKBOOK.UM_SEAFOODPAELLA = "Huge Hayfever Relief"
STRINGS.UI.COOKBOOK.UM_SNOTROAST = "Reduces Hunger Drain"
STRINGS.UI.COOKBOOK.UM_STUFFED_PEEPER_POPPERS = "Spawns Friendly Al-'eyes'"
STRINGS.UI.COOKBOOK.UM_THEATERCORN = "Sanity For Spectacle"
STRINGS.UI.COOKBOOK.UM_VIPERJAM = "Spawns Friendly Vipers"
STRINGS.UI.COOKBOOK.UM_ZASPBERRYPARFAIT = "Shocks Your Attackers"

--TIDDLER FRIENDLY MAN STRINGS BELOW--

STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPEAKER_SPECTER = "This is making me feel under the weather..."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPEAKER_RUSTED = "This is making me feel under the weather..."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPEAKER_BRINE = "This is making me feel under the weather..."

for _, sound in pairs({ "talk_LP", "talk_end" }) do
    RemapSoundEvent("dontstarve/characters/tiddle_stranger/" .. sound, "tiddle_stranger/characters/tiddle_stranger/" ..
        sound)
end

STRINGS.TIDDLESTRANGER_RNE_IGNORED = { "...Guess you ain't interested.", "Nevermind, then.", "..." }
STRINGS.NAMES.TIDDLESTRANGER_RNE = "Kind Stranger"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TIDDLESTRANGER_RNE = "He says a lot of nothing."
STRINGS.CHARACTERS.WX78.DESCRIBE.TIDDLESTRANGER_RNE = "ERROR: UNKNOWN ENTITY"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TIDDLESTRANGER_RNE = "I wonder what lies beneath that mysterious garb."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.TIDDLESTRANGER_RNE = "I don't remember that one."
STRINGS.CHARACTERS.WENDY.DESCRIBE.TIDDLESTRANGER_RNE = "A guardian angel?"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.TIDDLESTRANGER_RNE = "Who the heck are you?"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TIDDLESTRANGER_RNE = "Is creepy strange man."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.TIDDLESTRANGER_RNE = "An eerie prophet!"
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.TIDDLESTRANGER_RNE = "Helpy friend"
STRINGS.CHARACTERS.WURT.DESCRIBE.TIDDLESTRANGER_RNE = "Flort. Stranger danger."
STRINGS.CHARACTERS.WARLY.DESCRIBE.TIDDLESTRANGER_RNE = "Greetings, uh... I didn't get your name?"
STRINGS.CHARACTERS.WORTOX.DESCRIBE.TIDDLESTRANGER_RNE = "Hyuyuyu! A trickster after my own heart!"
STRINGS.CHARACTERS.WINONA.DESCRIBE.TIDDLESTRANGER_RNE = "Those shoulders don't seem practical."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.TIDDLESTRANGER_RNE = "I like your funny words, magic man."

STRINGS.TIDDLESTRANGER_RNE_GREETING = { "Hey there, friend!", "Oh, hello there!", "Hey, friend!" }
STRINGS.TIDDLESTRANGER_RNE_FAREWELL = {
    {
        "I spent a lot of time making these.",
        "Finding all the materials wasn't easy.",
        "...",
        "So don't go losing it.",
    },
    {
        "I'd suggest you keep a high flame going.",
        "There's some dangerous stuff lurking in the dark.",
        "...",
        "Not sure where it all came from, to be honest.",
    },
    {
        "Nights ain't as comfy as they used to be.",
        "Strange occurences, creatures in the dark...",
        "I'd keep my eyes and ears open, and a light by my side if I were you.",
    },
}
STRINGS.TIDDLESTRANGER_RNE_ENDSPEECH = { "Try it on, and find out.",
    "I think it would look nice on you, so just try it on!", "No strings attached, just wear it!" }

STRINGS.TIDDLESTRANGER_RNE_SCENARIO = {
    METEOR = {
        "Stars sure are nice tonight.", "How 'bout a closer look?"
    },
    SPIDERS = {
        "How 'bout a little game?", "I got a nice little prize in it for ya.", "The rules are simple:",
        "You beat my pet, you get the prize!"
    },
    LIGHT = {
        "Allow me to shed some light on the situation!"
    },
}

STRINGS.TIDDLESTRANGER_RNE_SCENARIO_END = {
    METEOR = {
        "Woops! Too close.", "Sorry 'bout that."
    },
    SPIDERS = {
        "Oh. Ya did it.", "Well! Fair's fair.", "Hope ya enjoy it!", "Now I need to find a new pet..."
    },
    LIGHT = {
        "That's the best I got.", "Hope that helped, now."
    },
}

STRINGS.TIDDLESTRANGER_RNE_SPIDERWON = { "Guess ya didn't have it in ya after all.", "Oops. I didn't think ya'd DIE.",
    "Now ain't that a darn shame." }

STRINGS.TIDDLESTRANGER_RNE_DEFAULT = {
    {
        "I've been practicing arts and crafts lately.",
        "I thought I'd make ya something...Nice.",
        "What do they do?",
        "...",
    },
    {
        "You look like you could use a new face!",
        "Lucky for you, I have several!",
        "...Masks, that is.",
        "What's their purpose?",
        "...",
    },
    {
        "Ever wanted to start a collection?",
        "Well I have just the thing!",
        "Hand crafted masks! No curses, I promise.",
        "...",
    },
}

STRINGS.TIDDLESTRANGER_RNE_BANTER = {
    {
        "I should be on that throne right now... oh, the things I'd make."
    },
    {
        "Don't ya have... things you need to do, friend?",
    },
    {
        "I appreciate the company and all, but this is gettin' a bit awkward.",
    },
    {
        "You just gonna stand there all day, friend?",
    },
    {
        "You just gonna stand there all day, friend?",
    },
    {
        "You're still here. Why are you still here?",
    },
    {
        "Wanna hear a joke?",
        "...",
        "Ah...I forgot what it was.",
    },
    {
        "Me? I'm quite old, ya'know.",
        "Not, like, ancient or anything. But... old.",
    },
    {
        "So... ya like jazz?",
        "Been too long since I seen a gig.",
    },
    {
        "I know many things, ya'know. Learned so much.",
        "Understand how this world works...",
        "...but I can't understand why you're still here.",
    },
    {
        "Pst... can I interest you in some forbidden knowledge?",
        "I'm just kiddin' ya. That's MY knowledge.",
    },
}

STRINGS.TIDDLESTRANGER_RNE_ADVICE = {
    BUSY = {
        "Oh. I see you're busy.",
        "I'll just come back later.",
    },
    HARBINGERS = {
        "You're doin' great!",
        "But this sickness ain't about to give up so easily.",
        "Keep an ear out, ya hear me?",
        "Somethin's comin' your way...",
    },
    KILLED = {
        "You did it! You put them pests right in their place!",
        "But they'll be back...",
        "I'm sure you can handle 'em, though.",
        "Anyways, I just came around to congratulate you."
    },
    MEDICINE = {
        "You feeling alright? You don't look so good...",
        "You'd better get that treated!",
        "I heard somethin' about some misty swamp.",
        "Fellas lookin' for a cure I think.",
        "Maybe he could help...",
    },
    REVIVER = {
        "Look at you!",
        "A real asset to the team!",
        "They'd all be dead without you, ya'know.",
        "Keep up the good work!",
        "And don't let no one tell you what's what.",
        "You're better than those slackers."
    },
    MURDERER = {
        "You're rackin' up quite the headcount!",
        "I ain't judgin' none. Honest.",
        "Strong feasting on the weak;",
        "Dog eat dog world;",
        "Survival of the fittest;",
        "All that good stuff."
    },
    CUREFOUND = {
        "I hear ya found the cure!",
        "Ain't that just dandy.",
        "Shame it's in such limited supply, huh?",
        "I hear there's another source...",
    },
}

STRINGS.STALKER_ATRIUM_WATHOM_BATTLECRY = {
    "Don't repeat our history, fool.",
    "You will doom yourself as we did.",
    "Retreat while you're still whole, mimic.",
    "Our mistakes shouldn't be repeated.",
    "Let the dead stay buried.",
    "I pity you, mimic.",
}

STRINGS.ACTIONS.SET_CUSTOM_NAME = "Set Custom Name"

local SkillTreeDefs = GLOBAL.require("prefabs/skilltree_defs")
if SkillTreeDefs.SKILLTREE_DEFS["wilson"] ~= nil then
    SkillTreeDefs.SKILLTREE_DEFS["wilson"].wilson_alchemy_4.desc = "Transform 3 Morsels into a Meat. Transform a Meat into 2 Morsels.\nTransform 3 Monster Morsels into a Monster Meat.\nTransform a Monster Meat into 2 Monster Morsels."
end

if SkillTreeDefs.SKILLTREE_DEFS["willow"] ~= nil then
    SkillTreeDefs.SKILLTREE_DEFS["willow"].willow_attuned_lighter.desc = STRINGS.SKILLTREE.WILLOW.WILLOW_ATTUNED_LIGHTER_DESC .. " Can also absorb Smog."
end
STRINGS.UM_HOUSETAUNTS = {
    PIGMAN = {
        "GET OFF LAWN",
        "LEAVE HOUSE ALONE",
        "NO SMASH HOUSE",
        "DO NOT HIT",
        "NO KILL HOUSE",
        --"BAD MONKEY MAN",
        "NO BREAK THINGS",
        "YOU STOP THAT",
        "STOP RIGHT THERE"
    },
    BUNNYMAN = {
        "INVADER!",
        "CRIMINAL!",
        "SCUM!",
        "AGGRESSOR!",
        "NO!",
        "MINE!",
        "HOUSE!",
        "BEGONE!",
    }
}

STRINGS.UM_LOADINGTIPS = {
    AMALGAMS = "\"Whoever designed these clockwork thingamawatzits should have installed a surge protector!\" -W",
    RNES = "\"I feel like there's something watching us at night...\" - W",
    MOONMAW = "Like a moth to a flame, a Dragonfly once flew too close to the moon. But unlike Icarus, her story doesn't end there...",
    MUTATIONS = "Each Deerclops you find is different than the last.",
    RUINS = "The Shadows are stirring, and long buried clockworks have resurfaced. Keep your wits about you.",
    CONFIGS = "Not a fan of some changes? Need a change of pace? Check out Uncompromising Mode's configuration options! Almost everything is configurable!",
    WIKI = "Lost? Confused? Hungering for knowledge? Visit Uncompromising Mode's Wiki! It's... *mostly* accurate! (Make sure to use Wiki.gg!)",
    RATS_FOODSCORE = "\"Our rations appear to be attracting unwanted attention. I should get rid of our stale food...\" - W",
    RATS_ITEMSCORE = "\"The vermin have noticed the mess around camp, I really should do a bit of Spring cleaning...\" - W",
    RATS_BURROWBONUS = "\"I've spotted a rat den where there wasn't one before, I think they are multiplying, and fast!\" - W",
    SNOWPILES = "\"The snow is accumulating here rather fast. We should dig it soon before it covers everything, or worse...\" - W",
    UNHAPPYTOMATO = "\"My tomato harvest seems to have shortened this fall, I guess they're feeling under the weather.\" - W",
    AURACLOPS = "The ice walls certain Deerclops make can be mined, and some are more brittle than others.",
    RATMASK = "\"To think like a rat, and smell like a rat, I must become a rat. Or at least, blend in really nicely with this Rat Mask.\" - W",
    WIXIE = "\"Winifred? Never heard of her! Now stop asking!\" - W",
    POCKETS = "\"I taught the others to sew some pockets into their clothing. How did these dummies ever get by without me?\" - W",
    CRAFTINGTOOLTIP = "Items with a small \"UM\" icon next to them in the crafting menu have been changed. You can mouse over the icon to get more information about the change.",
    NOCOLLISION = "Most exploitable collisions have been removed. This includes signs, statues, giant crops, shell clusters, and more.",
    MAXHPLOSS = "Freezing, overheating, starving and more can reduce max health.",
    WEATHER = "Keep an eye out on each season. Every season has something new to encounter.",
    MAXHEALTHHEALING = "Warly's Salt Spice can restore lost max health.",
    SLEEPING = "Sleeping has been considerably improved. Stats are gained faster and can lost max can he healed up to a certain threshold.",
    ALPHAGOAT = "\"That's a mean lookin' goat. I bet it'd make some fine dinin'! Ouch ouch ouch! Run! He's angry!\" - W",
    SNOWSTORMS = "\"Board up the windows, there is definetly a storm coming!\" - W",
    OCEAN_STEERING = "Boat rudders help with steering boats, increasing turn speed and allowing the boat to make sharper turns. The Captain's Hat also further increases steering speed.",
    HEAVYFISH = "\"That's a big one! We'll have seafood the entire season with that!\" - W",
    WILTFLY = "Hungry and weak during summer, the Dragonfly takes flight, searching for food. Ash and unprepared survivors are her favorite!",

    --tooltips
    --i'd preffer if we got character quotes for some of these.
    ARMOR_RUINS = "Thulecite Suits provides knockback immunity and reduce sanity lost from auras by 40%",
    SWEATERVEST = "The Dapper Vest reduces sanity lost from auras by 70%",
    COOKIECUTTERCAP = "The Cookie Cutter Cap now reflects 70% of the damage taken back at the attacker.",
    WARDROBE = "The Wardrobe now has 25 slots to store equipments. Keep your tools, weapons, armor, and more there!",
    TELESTAFF = "The Telelocator Staff and Focus have recieved major changes. You can now select one of multiple foci, rename them, teleport items, other players and heavy objects.",
    TOWNPORTAL = "The Lazy Deserter now picks items and harvests anything near it when used. This includes grass tufts, drying racks, bee boxes, and more.",
    PUMPKIN_LANTERN = "Pumpkin lanterns have a positive sanity aura.",
    NIGHTLIGHT = "Night Lights drain sanity from nearby players to automatically fuel themselves as needed.",
    MOONDIAL = "Moondials now work as a water source for watering cans. They can also be upgraded with a Moon Tear to allow mutating things during full moons.",
    ARMOR_DRAGONFLY = "The Scalemail now summons Dimvaes when worn to help you in combat.",
    GLASSCUTTER = "The Glass Cutter now deals extra damage against shadow-aligned enemies, as well as having increased durability against them",
    FEATHERHAT = "The Feather Hat provides safety against territorial Pengulls.",
    PURPLEAMULET = "The Nightmare Amulet provides additional Nightmare Fuel from slain Shadow Creatures when worn.",
    PIGGYPACK = "The Piggypack's reduced movement speed is now based on stored items.",
    PREMIUMWATERINGCAN = "The Waterfowl Can can store and preserve fish in it.",
    TURF_DRAGONFLY = "Scaled Turf prevents snow pile buildup.",
    BLOWDART_YELLOW = "Electric Blowdarts can stun mechanical enemies.",
    DRAGONFLY_CHEST = "The Scaled Chest now has 25 slots total, and may kill the first rat trying to steal from it.",
    BANDAGE = "Honey Poultice restores additional 15 health overtime when used.",
    MULTITOOL = "The Pick/Axe creates shockwaves when used, harvesting nearby rocks/trees.",
    FEATHERPENCIL = "The Feather Pencil can rename Telelocator Foci and Wanda's Backtreck Watches.",
    DREADSTONE_WALL = "Dreadstone Walls have Planar Resistance and slowly repair themselves over time.",
    WALLS = "Walls prevent the buildup and spread of snowpiles in a small radius.",
    FIREDART = "The Fire Darts are EXTRA fiery.",
    BEEMINE = "The Bee Mine has 5 uses and releases faster, more fragile bees.",
    FIRESUPRESSOR = "The Ice Flingomatic's \"Emergency Mode\" reacts faster to nearby fires, and ignores campfires and firepits.",
    CANNONS = "Cannons now have increased firepower and can fire Seedshells.",
    PIRATELEAKS = "Creating any leaks on Moonquay Pirate's boats causes them to retreat. This includes Seedshells!",
    TRIDENT = "The Striding Trident has a more powerful spell, and may multi-hit a target when attacking.",
    FAVORITE_FOOD = "A survivor's favorite food is a great thing to keep in mind when one wishes for some peace of mind.",
    LAZY_DESERTER = "The lazy deserter is now also a lazy collector! Just make sure to mind your sanity.",
    MONSTERMEAT_CROCKPOT = "\"Monster meat is SO horrendous to cook with. But a true chef knows to mix it up with some healthy meat if the situation calls for it.\" - W",
    THERMAL_STONE = "Thermal stones now become much better with proper clothing, and much worse without.",
    LIFE_AMULET = "Ghosts can no longer haunt Life Amulets to revive. Unless those amulets are of the rare and ancient variety.",
    PEARL_SHOP = "Pearl has expanded shop, and has a few more bits and baubles to sell.",

    --character specific
    WARLY_BUTCHER = "\"Warly is a great friend to have. I have been capturing these creatures alive lately. He has a way with a knife that I cannot match.\" - W",
    WINONA_ELECTRICAL = "Winona expanded her electrical arsenal quite a bit! You should see her pack up her gizmos on the go.",
    WINONA_OVERCHARGE = "\"If you ask Winona nicely, she may upgrade your lanterns or mining helmets to the electrical era. Their brightness setting can even go past 100%!\" - W",
    WIXIE_PUZZLE = "\"A mysterious wardrobe appeared, and I can't seem to get it open. Perhaps some outside assistance is required?\" - W",
    WENDY_SISTURN = "\"I have left petals inside of the Sisturn out of respect. Something happened to them. They look ethereal now. I am afraid to ask Wendy about it.\" - W",
    WALTER_WOBY = "\"I thought Woby some new tricks! Look! She can grab what I command her and bark!\" - W",
    WALTER_MEDIC = "\"After everyone got scratched and bruised so many times, Walter really learned a thing or two about first aid!\" - W",
    MAXWELL_TOPHAT = "\"I had left the top hat behind with my old act, but it's still good for a magic trick or two. It really does bring me back.\" - M",
    WICKER_BOOKREPAIR = "\"Wickerbottom has grown quite attached to her books. She keeps them on herself and takes propper care of them.\" - W",
    WILLOW_CUDDLE = "\"The shadows seem to not want to touch Willow when she is cuddling Bernie. Not even the forces of darkness would dare disturb something THAT adorable.\" - W",
    WANDA_SHADOWS = "\"Wanda's time spent messing with time has really made her body more vulnerable to those nightmare monstrosities.\" - W",
}

--SCRAPBOOK

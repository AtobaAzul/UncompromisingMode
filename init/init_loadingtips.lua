function setup_custom_loading_tips()
    local tips = {
        ["AMALGAMS"] = "\"Whoever designed these clockwork thingamawatzits should have installed a surge protector!\" -W",
        ["RNES"] = "\"I feel like there's something watching us at night... Huh?!... What was THAT?! What IS that?!\" - W",
        ["MOONMAW"] = "Like a moth to a flame, a Dragonfly once flew too close to the moon. But unlike Icarus, her story doesn't end there...",
        ["MUTATIONS"] = "Each Deerclops you find is different than the last.",
        ["RUINS"] = "The Shadows are stirring, and long buried clockworks have resurfaced. Keep your wits about you.",
        ["CONFIGS"] = "Not a fan of some changes? Need a change of pace? Check out Uncompromising Mode's configuration options! Almost everything is configurable!",
        ["WIKI"] = "Lost? Confused? Hungering for knowledge? Visit Uncompromising Mode's Wiki! It's... *mostly* accurate! (Make sure to use Wiki.gg!)",
        ["RATS_FOODSCORE"] = "\"Our rations appear to be attracting unwanted attention. I should get rid of our stale food...\" - W",
        ["RATS_ITEMSCORE"] = "\"The vermin have noticed the mess around camp, I really should do a bit of Spring cleaning...\" - W",
        ["RATS_BURROWBONUS"] = "\"I've spotted a rat den where there wasn't one before, I think they are multiplying, and fast!\" - W",
        ["SNOWPILES"] = "\"The snow is accumulating here rather fast. We should dig it soon before it covers everything. Wait, did you SEE that pile move??\" - W",
        ["UNHAPPYTOMATO"] = "\"My tomato harvest seems to have shortened this fall, I guess they're feeling under the weather.\" - W",
        ["AURACLOPS"] = "The ice walls certain Deerclops make can be mined, and some are more brittle than others.",
        ["RATMASK"] = "\"To think like a rat, and smell like a rat, I must become a rat. Or at least, blend in really nicely with this Rat Mask.\" - W",
        ["WIXIE"] = "\"Winifred? Never heard of her! Now stop asking!\" - W",
        ["POCKETS"] = "\"I taught the others to sew some pockets into their clothing. How did these dummies ever get by without me?\" - W",
        ["CRAFTINGTOOLTIP"] = "Items with a small \"UM\" icon next to them in the crafting menu have been changed. You can mouse over the icon to get more information about the change.",
        ["NOCOLLISION"] = "Most exploitable collisions have been removed. This includes signs, statues, giant crops, shell clusters, and more.",
        ["MAXHPLOSS"] = "Freezing, overheating, starving and more can reduce max health.",
        ["WEATHER"] = "Keep an eye out on each season. Every season has something new to encounter.",
        ["MAXHEALTHHEALING"] = "Warly's Salt Spice can restore lost max health.",
        ["SLEEPING"] = "Sleeping has been considerably improved. Stats are gained faster and can health lost max health up to a certain threshold.",
        ["ALPHAGOAT"] = "\"That's a mean lookin' goat. I bet it'd make some fine dinin'! Ouch ouch ouch! Run! He's angry!\" - W",
        ["SNOWSTORMS"] = "\"Board up the windows, there is definetly a storm coming!\" - W",
        ["OCEAN_STEERING"] = "Boat rudders help with steering boats, increasing turn speed and allowing the boat to make sharper turns. The Captain's Hat also further increases steering speed.",
        ["HEAVYFISH"] = "\"That's a big one! We'll have seafood the entire season with that!\" - W",
        ["WILTFLY"] = "Hungry and weak during summer, the Dragonfly takes flight, searching for food. Ash and unprepared survivors are her favorite!",

        --tooltips
        --i'd preffer if we got character quotes for some of these.
        ["ARMOR_RUINS"] = "Thulecite Suits provides knockback immunity and reduce sanity lost from auras by 40%",
        ["SWEATERVEST"] = "The Dapper Vest reduces sanity lost from auras by 70%",
        ["COOKIECUTTERCAP"] = "The Cookie Cutter Cap now reflects 70% of the damage taken back at the attacker.",
        ["WARDROBE"] = "The Wardrobe now has 25 slots to store equipments. Keep your tools, weapons, armor, and more there!",
        ["TELESTAFF"] = "The Telelocator Staff and Focus have recieved major changes. You can now select one of multiple foci, rename them, teleport items, other players and heavy objects.",
        ["TOWNPORTAL"] = "The Lazy Deserter now picks items and harvests anything near it when used. This includes grass tufts, drying racks, bee boxes, and more.",
        ["PUMPKIN_LANTERN"] = "Pumpkin lanterns have a positive sanity aura.",
        ["NIGHTLIGHT"] = "Night Lights drain sanity from nearby players to automatically fuel themselves as needed.",
        ["MOONDIAL"] = "Moondials now work as a water source for watering cans. They can also be upgraded with a Moon Tear to allow mutating things during full moons.",
        ["ARMOR_DRAGONFLY"] = "The Scalemail now summons Dimvaes when worn to help you in combat.",
        ["GLASSCUTTER"] = "The Glass Cutter now deals extra damage against shadow-aligned enemies, as well as having increased durability against them",
        ["FEATHERHAT"] = "The Feather Hat provides safety against territorial Pengulls.",
        ["PURPLEAMULET"] = "The Nightmare Amulet provides additional Nightmare Fuel from slain Shadow Creatures when worn.",
        ["PIGGYPACK"] = "The Piggypack's reduced movement speed is now based on stored items.",
        ["PREMIUMWATERINGCAN"] = "The Waterfowl Can can store and preserve fish in it.",
        ["TURF_DRAGONFLY"] = "Scaled Turf prevents snow pile buildup.",
        ["BLOWDART_YELLOW"] = "Electric Blowdarts can stun mechanical enemies.",
        ["DRAGONFLY_CHEST"] = "The Scaled Chest now has 25 slots total, and may kill the first rat trying to steal from it.",
        ["BANDAGE"] = "Honey Poultice restores additional 15 health overtime when used.",
        ["MULTITOOL"] = "The Pick/Axe creates shockwaves when used, harvesting nearby rocks/trees.",
        ["FEATHERPENCIL"] = "The Feather Pencil can rename Telelocator Foci and Wanda's Backtreck Watches.",
        ["DREADSTONE_WALL"] = "Dreadstone Walls have Planar Resistance and slowly repair themselves over time.",
        ["WALLS"] = "Walls prevent the buildup and spread of snowpiles in a small radius.",
        ["FIREDART"] = "The Fire Darts are EXTRA fiery.",
        ["BEEMINE"] = "The Bee Mine has 5 uses and releases faster, more fragile bees.",
        ["FIRESUPRESSOR"] = "The Ice Flingomatic's \"Emergency Mode\" reacts faster to nearby fires, and ignores campfires and firepits.",
        ["CANNONS"] = "Cannons now have increased firepower and can fire Seedshells.",
        ["PIRATELEAKS"] = "Creating any leaks on Moonquay Pirate's boats causes them to retreat. This includes Seedshells!",
        ["TRIDENT"] = "The Striding Trident has a more powerful spell, and may multi-hit a target when attacking.",
        ["FAVORITE_FOOD"] = "A survivor's favorite food is a great thing to keep in mind when one wishes for some peace of mind.",
        ["LAZY_DESERTER"] = "The lazy deserter is now also a lazy collector! Just make sure to to mind your sanity.",
        ["MONSTERMEAT_CROCKPOT"] = "\"Monster meat is SO horrendous to cook with. But a true chef knows to mix it up with some healthy meat if the situation calls for it.\" - W",
        ["THERMAL_STONE"] = "Thermal stones now become much better with proper clothing, and much worse without.",
        ["LIFE_AMULET"] = "Ghosts can no longer haunt Life Amulets to revive. Unless those amulets are of the rare and ancient variety.",
        ["PEARL_SHOP"] = "Pearl has expanded shop, and has a few more bits and baubles to sell.",

        --character specific
        ["WARLY_BUTCHER"] = "\"Warly is a great friend to have. I have been capturing these creatures alive lately. He has a way with a knife that I cannot match.\" - W",
        ["WINONA_ELECTRICAL"] = "Winona expanded her electrical arsenal quite a bit! You should see her pack up her gizmos on the go. She even made my HAT and lantern batteries included!",
        ["WINONA_OVERCHARGE"] = "\"If you ask Winona nicely, she may upgrade your lanterns or mining helmets to the electrical era. Their brightness setting can even go past 100%!\" - W",
        ["WIXIE_PUZZLE"] = "\"A mysterious wardrobe appeared, and I can't seem to get it open. Perhaps some outside assistance is required?\" - W",
        ["WENDY_SISTURN"] = "\"I have left petals inside of the Sisturn out of respect. Something happened to them. They look ethereal now. I am afraid to ask Wendy about it.\" - W",
        ["WALTER_WOBY"] = "\"I thought Woby some new tricks! Look! She can grab what I command her and bark!\" - W",
        ["WALTER_MEDIC"] = "\"After everyone got scratched and bruised so many times, Walter really learned a thing or two about first aid!\" - W",
        ["MAXWELL_TOPHAT"] = "\"I had left the top hat behind with my old act, but it's still good for a magic trick or two. It really does bring me back.\" - M",
        ["WICKER_BOOKREPAIR"] = "\"Wickerbottom has grown quite attached to her books. She keeps them on herself and keeps repairing them ever since... the bookcase incident happened.\" - W",
        ["WORMWOOD_FLOWER"] = "\"Wormwood's flowers do add a nice scented perfume indeed to an otherwise messy and rotted base. It may even fool the rats... for a while.\" - W",
        ["WILLOW_CUDDLE"] = "\"The shadows seem to not want to touch Willow when she is cuddling Bernie. Not even the forces of darkness would dare disturb something THAT adorable.\" - W",
        ["WANDA_SHADOWS"] = "\"Wanda's time spent messing with time has really made her body more vulnerable to those nightmare monstrosities.\" - W",
    }   


    for k, v in pairs(tips) do
        AddLoadingTip(GLOBAL.STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_UM_" .. k, v)
    end

    local tipcategorystartweights =
    {
        CONTROLS = 0.2,
        SURVIVAL = 0.2,
        LORE = 0.2,
        LOADING_SCREEN = 0.2,
        OTHER = 0.2,
    }

    SetLoadingTipCategoryWeights(GLOBAL.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START, tipcategorystartweights)

    local tipcategoryendweights =
    {
        CONTROLS = 0,
        SURVIVAL = 0,
        LORE = 0,
        LOADING_SCREEN = 0,
        OTHER = 1,
    }
    --UM tips are guaranteed on the second tip during the loading screen.
    SetLoadingTipCategoryWeights(GLOBAL.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END, tipcategoryendweights)

    -- Loading tip icon
    SetLoadingTipCategoryIcon("OTHER", "images/UM_tip_icon.xml", "UM_tip_icon.tex")

    GLOBAL.TheLoadingTips = require("loadingtipsdata")()

    -- Recalculate loading tip & category weights.
    local TheLoadingTips = GLOBAL.TheLoadingTips
    TheLoadingTips.loadingtipweights = TheLoadingTips:CalculateLoadingTipWeights()
    TheLoadingTips.categoryweights = TheLoadingTips:CalculateCategoryWeights()

    GLOBAL.TheLoadingTips:Load()
end

-- We need to call this directly instead of in AddGamePostInit() because the loading screen appears before calling that function.
setup_custom_loading_tips()

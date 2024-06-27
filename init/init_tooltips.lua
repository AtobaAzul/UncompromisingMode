--moved into seperate file, was getting a bit too big.
local STRINGS = GLOBAL.STRINGS

STRINGS.UNCOMP_TOOLTIP = {
    AMULET =
    "- Only revives the player upon death while worn.\n- Increased heal rate at lower health.\n- Never breaks, can be refueled with Nightmare Fuel.",
    ARMORRUINS = "- Prevents knockback effects.\n- Reduces insanity aura effects by 30%.",
    SWEATERVEST = "- Reduces insanity aura effects by 60%.",
    SKELETONHAT = "- Will not spawn the Creeping Fear when worn.",
    ICEPACK = "- Will not burn.",
    COOKIECUTTERHAT = "- Reflects 75% of damage taken back at attacker.",
    HAMBAT = "- Rots faster.\n- Can be eaten by certain mobs.",
    TOWNPORTAL = "- Gathers nearby items when channeling.",
    PUMPKIN_LANTERN = "- Has a positive sanity aura.",
    NIGHTLIGHT = "- Fuels itself at night by taking nearby players sanity.",
    ARMOR_SANITY = "- Reduced sanity drain on damage taken.",
    TOPHAT = "- Reduces sanity loss from various magic items.",
    MOONDIAL = "- Fills watering cans.\n- When socketed with a Moon Tear, mutates offered items under the light of the full \"Moon\".",
    ARMORDRAGONFLY = "- Summons mini Lavae allies when worn.",
    GLASSCUTTER = "- Deals more damage to Shadow Aligned Creatures.",
    FEATHERHAT = "- Provides safety from territorial Pengulls.",
    YELLOWAMULET = "- No longer breaks when empty.",
    ORANGEAMULET = "- No longer breaks when empty.\n- Will pick certain plants too!",
    PURPLEAMULET = "- Grants bonus Nightmare Fuel from slain Shadows.",
    PIGGYBACK = "- No Passive -10% movement speed while worn.\n- Decreases Player speed by 1% per item held.",
    PREMIUMWATERINGCAN = "- Can contain and preserve ocean fish.",
    RAINHAT = "- Slightly increased rain protection.",
    ARMORMARBLE = "- Prevents knockback effects.",
    TURF_DRAGONFLY = "- Prevents snowpile build-up.\n- Speeds up player movement.",
    BLOWDART_YELLOW = "- Stuns certain mechanical enemies.",
    DRAGONFLYCHEST = "- Has even more item slots.\n- May hurt would be thieves.",
    WARDROBE = "- Can store a lot of equipment.",
    WINONA_BATTERY_LOW = "- Can charge electrical equipment.",
    WINONA_BATTERY_HIGH = "- Can charge electrical equipment.",
    WINONA_SPOTLIGHT = "- Significantly increased range.\n- Doubled radius.",
    LIGHTNING_ROD = "- Can charge electrical equipment.",
    BANDAGE = "- Restores a bit of extra health over time.",
    SISTURN = "- Petals inside decay into Mourning Glory.",
    MULTITOOL_AXE_PICKAXE = "- Creates shockwaves when chopping/mining.",
    FEATHERPENCIL = "- Can rename Telelocator Focus' location name and Backtrek Watches.",
    BOAT_ROTATOR_KIT = "- Increases boat steering speed.\n- Helps doing sharp turns.",
    WALL_DREADSTONE_ITEM = "- Slowly repairs itself at the cost of sanity.",
    BLOWDART_FIRE = "- Now with EXTRA fire.\n- If already flaming when shot, the target explodes!",
    BEEMINE = "- Now has 5 uses.\n- Spawns faster, more fragile bees.",
    COMPOSTINGBIN = "- Can hold up to 24 items.",
    FIRESUPRESSOR = "- Reacts faster to nearby fires in Emergency Mode.\n- Ignores campfires and firepits.",
    BOAT_CANNON_KIT = "- Increased firepower.\n- Can fire Seedshells.",
    TRIDENT = "- Altered, more powerful spell.\n- More uses and damage.\n- May multi-hit.",
    COMPASS = "- Now works while on the inventory.\n- Increased durability.",
    BREAK = "BREAK HERE",
    --uncomp content
    RAT_WHIP = "- Stronger when well fed.",
    AIR_CONDITIONER = "- Can crush up Mushrooms for helpful stat clouds.\n- Provides cold in a small radius.\n- Removes smog in a large area.",
    ANCIENT_AMULET_RED =
    "- Drops soul orbs when attacked, which will replenish lost health when picked up.\n- Revives players when haunted.",
    ARMOR_GLASSMAIL = "- Summons spinning Glass Shards when attacking enemies.\n- Loses shards when damage is taken.",
    HONEY_LOG = "- Provides protection from Hayfever. Mostly useful for other allies.",
    SALTPACK = "- Drops piles of salt, preventing buildup of Snow Piles.",
    SPOREPACK = "- Provides lots of storage space.\n- Rots food, but refreshes Spores.",
    UM_BEAR_TRAP_EQUIPPABLE_TOOTH =
    "- Slows down anything it's attached to.\n- Deployable and throwable.\n- Has multiple uses.",
    UM_BEAR_TRAP_EQUIPPABLE_GOLD =
    "- Slows down anything it's attached to.\n- Deployable and throwable.\n- Has even more uses.",
    WATERMELON_LANTERN = "- Has a positive sanity aura.",
    HAT_RATMASK = "- Finds rat burrows\n- Shows sources of unwanted attention.",
    SKULLCHEST_CHILD = "- Shares its contents with other Skull Chests.",
    SNOWGOGGLES = "- Grants protection against Snow Storms / Sand Storms when worn.",
    GASMASK = "- Provides protection against spore clouds.",
    PLAGUEMASK = "- Provides protection against spore clouds.",
    FLORAL_BANDAGE = "- Restores extra health over time.",
    DISEASECUREBOMB = "- Fertilizes plants and get those ready for harvest.",
    SLUDGE_OIL = "- Multi-use fuel for fires and lanterns alike.",
    ARMOR_SHARKSUIT_UM =
    "- High wetness protection. \n- Works as electrical insulation.\n- Wearer will wash ashore with no penalties.",
    HAT_CRAB = "- Repairs & sewing are twice as effective when worn.",
    HAT_CRAB_ICE = "- Absorbs wetness to increase resistance.\n- Prevents the wearer from drying up.",
    KALEIDOSCOPE = "- Hitting enemies allows allies to deal Planar damage against it for a short time",
    ARMOR_CRAB_MAXHP = "- Increases maximum health when worn.",
    ARMOR_CRAB_REGEN = "- Self-healing.",
    UM_ARMOR_PYRE_NETTLES = "- Panics and damages nearby miscreants.\n- Ignores tiny, shadow, or fire-aligned creatures.",
    WINONA_TOOLBOX = "- Portable storage for tools, dismantled structures and related items.", --putting these here for the icon
    WINONA_UPGRADEKIT_ELECTRICAL = "- Upgrades a Miner Hat or Latern to use electricity.\n- Increases max fuel.",
	CODEX_MANTRA = "- Will spawn Classic Shadows when read.\n- Acts as a Prestihatitator (Tier 1 Magic) when dropped.",
	PACT_ARMOR_SANITY = "- Creates temporary Night Armor.\n- Disappears when unequipped.",
	PACT_SWORD_SANITY = "- Creates a temporary Dark Sword.\n- Disappears when unequipped.",
    BRINE_BALM = "- Hurts you a little, heals you, over time, a lot.\n- Restores lost maximum health."
}
local TOOLTIPS = STRINGS.UNCOMP_TOOLTIP

local statues = {
    "HORNUCOPIA",
    "PIPE",
    "ANCHOR",
    "PAWN",
    "ROOK",
    "KNIGHT",
    "BISHOP",
    "MUSE",
    "FORMAL",
    "DEERCLOPS",
    "BEARGER",
    "MOOSEGOOSE",
    "DRAGONFLY",
    "MINOTAUR",
    "TOADSTOOL",
    "BEEQUEEN",
    "KLAUS",
    "ANTLION",
    "STALKER",
    "MALBATROSS",
    "CRABKING",
    "BUTTERFLY",
    "MOON",
    "GUARDIANPHASE3",
    "EYEOFTERROR",
    "TWINSOFTERROR",
    "CLAYHOUND",
    "CLAYWARG",
    "CARRAT",
    "BEEFALO",
    "KITCOON",
    "CATCOON",
    "MANRABBIT",
    "DAYWALKER",
}

for k, v in pairs(statues) do
    TOOLTIPS["CHESSPIECE_" .. v .. "_BUILDER"] = "- No longer has collision."
end

STRINGS.PINETREE_TOOLTIP = {
    WALTERHAT = "- Wearing it makes scrapes and bruises feel less scary!",
    HEALINGSALVE = "- My first aid training helps me get more out of this!",
    TILLWEEDSALVE = "- My first aid training helps me get more out of this!",
    BANDAGE = "- My first aid training helps me get more out of this!",
    FLORAL_BANDAGE = "- My first aid training helps me get more out of this!",
    BEDROLL_STRAW = "- A pine tree pioneer knows how to conserve energy when relaxing!",
    BEDROLL_FURRY = "- A pine tree pioneer knows how to conserve energy when relaxing!",
    TENT = "- A pine tree pioneer knows how to conserve energy when relaxing!",
    SIESTAHUT = "- A pine tree pioneer knows how to conserve energy when relaxing!",
    PORTABLETENT_ITEM = "- A pine tree pioneer knows how to conserve energy when relaxing!",
    MEATRACK_HAT = "- If I go fast enough, it will dry even faster!",
    BRINE_BALM = "- My first aid training helps me get more out of this!",
}

STRINGS.ENGINEERING_TOOLTIP = {
    MINERHAT = " - May be upgraded.\n- Can be overcharged, if upgraded.",
    LANTERN = "- May be upgraded.\n- Can be overcharged, if upgraded.",
    NIGHTSTICK = "- Can be overcharged.",
    BUGZAPPER = "- Can be overcharged.",
    WINONA_TOOLBOX = "", --putting these here for the icon
    WINONA_UPGRADEKIT_ELECTRICAL = ""
}

if TUNING.DSTU.WINONA_PORTABLES then
    STRINGS.ENGINEERING_TOOLTIP.WINONA_CATAPULT = "- Now portable."
    STRINGS.ENGINEERING_TOOLTIP.WINONA_SPOTLIGHT = "- Now portable."
    STRINGS.ENGINEERING_TOOLTIP.WINONA_BATTERY_LOW = "- Now portable."
    STRINGS.ENGINEERING_TOOLTIP.WINONA_BATTERY_HIGH = "- Now portable."
end


if TUNING.DSTU.TELESTAFF_REWORK then
    TOOLTIPS.TELESTAFF = "- Can select its destination.\n- Increased uses."
    TOOLTIPS.TELEBASE = "- No longer requires gems per teleport."
end

if TUNING.DSTU.BEEBOX_NERF then
    TOOLTIPS.BEEBOX = "- Reduced maximum active Bees."
end

if not TUNING.DSTU.ELECTRICALMISHAP then
    TOOLTIPS.NIGHTSTICK =
    "- No longer breaks when empty.\n- Can be fueled by various electrical items, generators, and potatoes."
    TOOLTIPS.BUGZAPPER =
    "- Deals bonus damage, and area damage to Insects.\n- Deals electrical damage.\n- Can be fueled by various electrical items, generators, and potatoes."
else
    TOOLTIPS.NIGHTSTICK =
    "- No longer breaks when empty.\n- Functions as a portable lightning rod.\n- Regains fuel when struck by lightning or when charged at generators."
    TOOLTIPS.BUGZAPPER =
    "- Deals bonus damage, and area damage to Insects.\n- Deals electrical damage.\n - Can be charged at generators."
end

if TUNING.DSTU.SEWING_KIT then
    TOOLTIPS.SEWING_KIT = "- Doubled uses, but repairs less per use."
end

if TUNING.DSTU.FLINGO_SETTING == "Fuelmuncher" then
    TOOLTIPS.FIRESUPPRESSOR = "- Drains fuel on each throw.\n- Increased maximum fuel."
elseif TUNING.DSTU.FLINGO_SETTING == "Waterballs" then
    TOOLTIPS.FIRESUPPRESSOR = "- No longer freezes on hit."
end

if TUNING.DSTU.LONGPIG then
    TOOLTIPS.REVIVER = "- Requires flesh from a dead survivor."
end

if TUNING.DSTU.EYEBRELLAREWORK == false then
    TOOLTIPS.EYEBRELLAHAT = "- Reduced heat protection."
else
    TOOLTIPS.EYEBRELLAHAT = "- Reduced heat protection.\n- Can't be sewn, but may be repaired."
end

if TUNING.DSTU.SNOWSTORMS then
    TOOLTIPS.CAMPFIRE = "- Provides protection from Snow Storms."
    TOOLTIPS.TORCH = "- Provides protection from Snow Storms."
    TOOLTIPS.FIREPIT = "- Provides protection from Snow Storms."
    TOOLTIPS.WALL_HAY_ITEM = "- Provides protection from Snow Storms when built."
    TOOLTIPS.WALL_WOOD_ITEM = "- Provides protection from Snow Storms when built."
    TOOLTIPS.WALL_STONE_ITEM = "- Provides protection from Snow Storms when built."
    TOOLTIPS.WALL_RUINS_ITEM = "- Provides protection from Snow Storms when built."
    TOOLTIPS.WALL_MOONROCK_ITEM = "- Provides protection from Snow Storms when built."
    TOOLTIPS.WALL_DREADSTONE_ITEM = TOOLTIPS.WALL_DREADSTONE_ITEM .. "\n- Provides protection from Snow Storms when built."
    TOOLTIPS.YELLOWSTAFF = "- Dwarf Stars provide protection from Snow Storms."
    TOOLTIPS.MOLEHAT = "- Grants protection against Snow Storms / Sand Storms and Moon Storms when worn."
    TOOLTIPS.DESERTHAT = "- Also works as protection against Snow Storms."
    TOOLTIPS.BEARGERVEST = "- Provides protection from Snow Storms' slowdown."
else
    TOOLTIPS.MOLEHAT = "- Grants protection against Sand Storms and Moon Storms when worn."
end

if TUNING.DSTU.HAYFEVER then
    TOOLTIPS.GASMASK = TOOLTIPS.GASMASK .. "\n- Prevents Hayfever while worn."
    TOOLTIPS.PLAGUEMASK = TOOLTIPS.PLAGUEMASK .. "\n- Prevents Hayfever while worn."
    TOOLTIPS.BEEHAT = "- Stings won't cause allergic reactions."
    TOOLTIPS.MINIFAN = "- Staves off hayfever."
    TOOLTIPS.FEATHERFAN = "- Grants large amounts of Hayfever protection when blown."
    TOOLTIPS.PERDFAN = "- Grants large amounts of Hayfever protection when blown."
end

if TUNING.DSTU.SMOG then
    TOOLTIPS.GASMASK = TOOLTIPS.GASMASK .. "\n- Protects against smog while worn."
    TOOLTIPS.PLAGUEMASK = TOOLTIPS.PLAGUEMASK .. "\n- Protects against smog while worn"
    if TOOLTIPS.MINIFAN ~= nil then
        TOOLTIPS.MINIFAN = string.gsub(TOOLTIPS.MINIFAN, ".", "") .. " and helps against smog."
    else
        TOOLTIPS.MINIFAN = "- Helps against smog."
    end

    if TOOLTIPS.FEATHERFAN ~= nil then
        TOOLTIPS.FEATHERFAN = TOOLTIPS.FEATHERFAN .. "\n- Blows away smog."
    else
        TOOLTIPS.FEATHERFAN = "- Blows away smog."
    end

    if TOOLTIPS.PERDFAN ~= nil then
        TOOLTIPS.PERDFAN = TOOLTIPS.PERDFAN .. "\n- Blows away smog."
    else
        TOOLTIPS.PERDFAN = "- Blows away smog."
    end
end

if TUNING.DSTU.HEATWAVES then
    TOOLTIPS.WINTEROMETER = "- Can predict heatwaves before they occur."
end

if TUNING.DSTU.STORMS then
    TOOLTIPS.RAINOMETER = "- Can track a Tornado's location."
end

if TUNING.DSTU.GOTOBED ~= false then
    TOOLTIPS.BEDROLL_STRAW = "- May restore maximum health."

    TOOLTIPS.BEDROLL_FURRY = "- A bit more efficient.\n- May restore maximum health."

    TOOLTIPS.TENT = "- May restore maximum health."

    TOOLTIPS.PORTABLETENT_ITEM = "- May restore maximum health."

    TOOLTIPS.SIESTAHUT = "- A bit less efficient.\n- May restore maximum health."
end

if TUNING.DSTU.SLEEPINGBUFF > 1 then
    if TUNING.DSTU.GOTOBED then
        TOOLTIPS.BEDROLL_STRAW = TOOLTIPS.BEDROLL_STRAW .. "\n- Faster healing rate."

        TOOLTIPS.BEDROLL_FURRY = TOOLTIPS.BEDROLL_FURRY .. "\n- Faster healing rate."

        TOOLTIPS.TENT = TOOLTIPS.TENT .. "\n- Faster healing rate."

        TOOLTIPS.SIESTAHUT = TOOLTIPS.SIESTAHUT .. "\n- Faster healing rate."

        TOOLTIPS.PORTABLETENT_ITEM = TOOLTIPS.PORTABLETENT_ITEM .. "\n- Faster healing rate."
    else
        TOOLTIPS.BEDROLL_STRAW = "- Faster healing rate."

        TOOLTIPS.BEDROLL_FURRY = "- Faster healing rate."

        TOOLTIPS.TENT = "- Faster healing rate."

        TOOLTIPS.SIESTAHUT = "- Faster healing rate."

        TOOLTIPS.PORTABLETENT_ITEM = "- Faster healing rate."
    end
end

if TUNING.DSTU.POCKET_POWERTRIP ~= 0 then
    TOOLTIPS.TRUNKVEST_SUMMER = "- Now has pockets!\n- Slightly increased rain protection."
    TOOLTIPS.TRUNKVEST_WINTER = "- Now has pockets!"
    TOOLTIPS.REFLECTIVEVEST = "- Now has pockets!"
    TOOLTIPS.RAINCOAT = "- Now has pockets!"
    TOOLTIPS.HAWAIIANSHIRT = "- Increased durability.\n- Now has pockets!"
    TOOLTIPS.ARMOR_SNAKESKIN = "- Now has pockets!"
    TOOLTIPS.ARMOR_WINDBREAKER = "- Now has pockets!"
end

if TUNING.DSTU.CANEDURABILITY then
    TOOLTIPS.CANE = "- Has durability, only drains when walking."
end

if TUNING.DSTU.WANDA_NERF then
    TOOLTIPS.POCKETWATCH_REVIVE = "- Increased cooldown.\n- Gives health penalty."
end

if TUNING.DSTU.INSUL_THERMALSTONE then
    TOOLTIPS.HEATROCK = "- Reduced inherent insulation.\n- Inherits part of players insulation."
end

if TUNING.DSTU.WICKERNERF_TENTACLES then
    TOOLTIPS.BOOK_TENTACLES =
    "- Summons Sickly Tentacles\n- Sickly Tentacles die over time, drop no loot but don't attack players."
end

if TUNING.DSTU.WOODIE_WET_GOOSE then
    TOOLTIPS.WEREITEM_GOOSE = "- Walking on water makes you wet."
end

if TUNING.DSTU.WINONA_GEN then
    TOOLTIPS.WINONA_BATTERY_HIGH = TOOLTIPS.WINONA_BATTERY_HIGH .. "\n- Access limited to Winona."
    TOOLTIPS.WINONA_BATTERY_LOW = TOOLTIPS.WINONA_BATTERY_LOW .. "\n- Access limited to Winona."
end

if TUNING.DSTU.WICKERNERF_MOONBOOK then
    TOOLTIPS.BOOK_MOON = "- Now mutates everything around on use."
end

if TUNING.DSTU.WICKERNERF_BEEBOOK then
    TOOLTIPS.BOOK_BEES = "- Now adds Honey to 10 nearby Bee Boxes.\n- Doesn't work during Dusk, Night and/or Winter."
end

if TUNING.DSTU.WATHGRITHR_ARSENAL then
    TOOLTIPS.SPEAR_WATHGRITHR_LIGHTNING = "- The lightning charge attack will consume additional durability per mob hit up to a limit.\n - The Charged Elding Spear can be recharged with lightning."
    TOOLTIPS.WATHGRITHR_SHIELD = "- Blocking attacks will consume durability by 60% of the damage taken.\n - Each additional perk reduces it by 20%."
end

if TUNING.DSTU.DISABLE_MEGAFLARE then
    TOOLTIPS.MEGAFLARE = "- No longer summons Deerclops."
end

if TUNING.DSTU.STORMS then
    TOOLTIPS.BOOK_RAIN = "- Can briefly redirect Giant Tornadoes when in its range."
    TOOLTIPS.STAFF_TORNADO = "- Can briefly redirect Giant Tornadoes."
end

if TUNING.DSTU.WXLESS then
    local CircuitDefs = {
        HEAT = "- Now provides heat when working or attacking.\n- No longer changes max and min temperature.\n- Provides insulation.\n- Increases work efficiency the hotter you are.",
        MOVESPEED = "- Increases run speed over time the longer you run.",
        MOVESPEED2 = "- Increases run speed over time the longer you run.\n- When fast enough, you begin a charge, hitting creatures in your way.",
        BEE = "- Now regenerates 1 health every 5 seconds.",
        LIGHT = "- Increased light radius.",
        MUSIC = "- Provides more sanity.\n- Attracts birds.",
        MAXHEALTH = "- Provides a bit of static damage reduction.\n- Now increases health by 40.",
        MAXHEALTH2 = "- Provides static damage reduction.\n- Now increases health by 100.",
        MAXSANITY = "- Provides a bit more sanity over time.\n- Reduces insanity aura effects.",
        MAXSANITY1 = "- Provides a bit of sanity over time.\n- Slighly reduces insanity aura effects.",
        TASER = "- Getting hit stuns the attacker.\n- Gives you charge when you attack enough times.",
        COLD = "- Periodically produces ice.\n- No longer changes max and min temperature.\n- Decreases food spoilage rate.\n- Decreased drying threshold\n- Chills you significantly, if idle.",
        MAXHUNGER = "- Slows down charge drain\n- Reduces negative food effects, up until reversing them entirely.", --WHOEVER AT KLEI WHO DECIDED THEY'D MAKE THE MAXHUNGER1 THE WEAK VERSION AND MAXHUNGER THE STRONG VERSION SHOULD HAVE THEIR FINGERS BOILED.
        MAXHUNGER1 = "- Slightly slows down hunger drain.",
    }
    for k, v in pairs(CircuitDefs) do
        TOOLTIPS["WX78MODULE_" .. k] = v
    end
end

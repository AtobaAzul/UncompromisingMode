local STRINGS = GLOBAL.STRINGS
--moved into seperate file, was getting a bit too big.

STRINGS.UNCOMP_TOOLTIP = {
	AMULET = "- Only revives the player upon death while worn.\n- Increased heal rate at lower health.\n- Never breaks, can be refueled with Nightmare Fuel.",
	ARMORRUINS = "- Prevents knockback effects.\n- Reduces insanity aura effects by 40%.",
	SWEATERVEST = "- Reduces insanity aura effects by 70%.",
	SKELETONHAT = "- Will not spawn the Creeping Fear when worn.",
	ICEPACK = "- Will not burn.",
	COOKIECUTTERHAT = "- Reflects 75% of damage taken back at attacker.",
	HAMBAT = "- Rots faster.\n- Can be eaten by certain mobs.",
	TOWNPORTAL = "- Gathers nearby items when channeling.",
	PUMPKIN_LANTERN = "- Has a positive sanity aura.",
	NIGHTLIGHT = "- Fuels itself at night by taking nearby players sanity.",
	ARMOR_SANITY = "- Reduced sanity drain on damage taken.",
	TOPHAT = "- Reduces sanity loss from various magic items.",
	MOONDIAL = "- Can become a source of water when a certain item is placed inside...",
	ARMORDRAGONFLY = "- Summons mini Lavae allies when worn.",
	GLASSCUTTER = "- Deals slightly more damage to Shadows.",
	FEATHERHAT = "- Provides safety from territorial Pengulls.",
	YELLOWAMULET = "- No longer breaks when empty.",
	ORANGEAMULET = "- No longer breaks when empty.\n- Will pick certain plants too!",
	PURPLEAMULET = "- Grants bonus Nightmare Fuel from slain Shadows.",
	PIGGYBACK = "- No Passive -10% movement speed while worn.\n- Decreases Player speed by 1% per item held.",
	PREMIUMWATERINGCAN = "- Can contain and preserve ocean fish.",
	RAINHAT = "- Slightly increased rain protection.",
	ARMORMARBLE = "- Prevents knockback effects.",
	TURF_DRAGONFLY = "- Prevents snowpile build-up.",
	BLOWDART_YELLOW = "- Stuns certain mechanical enemies.",
	DRAGONFLYCHEST = "- Has even more item slots.\n- May hurt would be thieves.",
	WARDROBE = "- Can store a lot of equipment.",
	WINONA_BATTERY_LOW = "- Can charge electrical equipment.",
	WINONA_BATTERY_HIGH = "- Can charge electrical equipment.",
	LIGHTNING_ROD = "- Can charge electrical equipment.",
	LIGHTER = "- Lasts forever in the hands of a pyromaniac.",
	BANDAGE = "- Restores a bit of extra health over time.",
	SISTURN = "- Petals inside decay into Mourning Glory.\n- Masks foul smells.",
	POTTEDFERN = "- Masks foul smells.",
	SUCCULENT_POTTED = "- Masks foul smells.",
	ENDTABLE = "- Masks foul smells when decorated.",
	MULTITOOL_AXE_PICKAXE = "- Creates shockwaves when chopping/mining.",
	FEATHERPENCIL = "- Can rename Telelocator Focus' location name and Backtrek Watches.",

	--uncomp content
	RAT_WHIP = "- Stronger when well fed.",
	AIR_CONDITIONER = "- Can crush up Mushrooms for helpful stat clouds.",
	ANCIENT_AMULET_RED = "- Drops soul orbs when attacked, which will replenish lost health when picked up.\n- Revives players when haunted.",
	ARMOR_GLASSMAIL = "- Summons spinning Glass Shards when attacking enemies.\n- Loses shards when damage is taken.",
	HONEY_LOG = "- Provides protection from Hayfever. Mostly useful for other allies.",
	SALTPACK = "- Drops piles of salt, preventing buildup of Snow Piles.",
	SPOREPACK = "- Provides lots of storage space.\n- Rots food, but refreshes Spores.",
	UM_BEAR_TRAP_EQUIPPABLE_TOOTH = "- Slows down anything it's attached to. Deployable and throwable.",
	UM_BEAR_TRAP_EQUIPPABLE_GOLD = "- Slows down anything it's attached to. Deployable and throwable.",
	WATERMELON_LANTERN = "- Has a positive sanity aura.",
	HAT_RATMASK = "- Finds rat burrows\n- Shows sources of unwanted attention.",
	SKULLCHEST_CHILD = "- Shares its contents with other Skull Chests.",
	SNOWGOGGLES = "- Grants protection against Snow Storms / Sand Storms when worn.",
	GASMASK = "- Provides protection against spore clouds.",
	PLAGUEMASK = "- Provides protection against spore clouds.",
	FLORAL_BANDAGE = "- Restores extra health over time.",
	DISEASECUREBOMB = "- Restores sickly plants.",
	SLUDGE_OIL = "- Multi-use fuel for fires and lanterns alike.",

	CRAB_HAT = "- Repairs & sewing are twice as effective when worn.",
	CRAB_HAT_ICE = "- Resistance scales with wetness.\n- Prevents the wearer from drying up.",
	ARMOR_CRAB_MAXHP = "- Increases maximum health when worn.",
	ARMOR_CRAB_REGEN = "- Self-healing."
}

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
	BUGZAPPER = "- Can be overcharged."
}

if GetModConfigData("winona_portables") then
	STRINGS.ENGINEERING_TOOLTIP.WINONA_CATAPULT = "- Now portable."
	STRINGS.ENGINEERING_TOOLTIP.WINONA_SPOTLIGHT = "- Now portable."
	STRINGS.ENGINEERING_TOOLTIP.WINONA_BATTERY_LOW = "- Now portable."
	STRINGS.ENGINEERING_TOOLTIP.WINONA_BATTERY_HIGH = "- Now portable."
end

local TOOLTIP = STRINGS.UNCOMP_TOOLTIP

if GetModConfigData("telestaff_rework") then
	TOOLTIP.TELESTAFF = "- Can select its destination.\n- Increased uses."
	TOOLTIP.TELEBASE = "- No longer requires gems per teleport."
end

if GetModConfigData("beebox_nerf") then
	TOOLTIP.BEEBOX = "- Reduced yield per stage.\n- Reduced maximum active bees."
end

if not TUNING.DSTU.ELECTRICALMISHAP then
	TOOLTIP.NIGHTSTICK =
	"- No longer breaks when empty.\n- Can be fueled by various electrical items, generators, and potatoes."
	TOOLTIP.BUGZAPPER =
	"- Deals bonus damage, and area damage to Insects.\n- Deals electrical damage.\n- Can be fueled by various electrical items, generators, and potatoes."
else
	TOOLTIP.NIGHTSTICK =
	"- No longer breaks when empty.\n- Functions as a portable lightning rod.\n- Regains fuel when struck by lightning or when charged at generators."
	TOOLTIP.BUGZAPPER =
	"- Deals bonus damage, and area damage to Insects.\n- Deals electrical damage.\n - Can be charged at generators."
end

if TUNING.DSTU.SEWING_KIT then
	TOOLTIP.SEWING_KIT = "- Doubled uses, but repairs less per use."
end

if TUNING.DSTU.FLINGO_SETTING == "Fuelmuncher" then
	TOOLTIP.FIRESUPPRESSOR = "- Drains fuel on each throw.\n- Increased maximum fuel."
elseif TUNING.DSTU.FLINGO_SETTING == "Waterballs" then
	TOOLTIP.FIRESUPPRESSOR = "- No longer freezes on hit."
end

if TUNING.DSTU.LONGPIG then
	TOOLTIP.REVIVER = "- Requires flesh from a dead survivor."
end

if TUNING.DSTU.EYEBRELLAREWORK == false then
	TOOLTIP.EYEBRELLAHAT = "- Reduced heat protection."
else
	TOOLTIP.EYEBRELLAHAT = "- Reduced heat protection.\n- Can't be sewn, but may be repaired."
end

if TUNING.DSTU.SNOWSTORMS then
	TOOLTIP.CAMPFIRE = "- Provides protection from Snow Storms."
	TOOLTIP.TORCH = "- Provides protection from Snow Storms."
	TOOLTIP.FIREPIT = "- Provides protection from Snow Storms."
	TOOLTIP.WALL_HAY_ITEM = "- Provides protection from Snow Storms."
	TOOLTIP.WALL_WOOD_ITEM = "- Provides protection from Snow Storms."
	TOOLTIP.WALL_STONE_ITEM = "- Provides protection from Snow Storms."
	TOOLTIP.WALL_RUINS_ITEM = "- Provides protection from Snow Storms."
	TOOLTIP.WALL_MOONROCK_ITEM = "- Provides protection from Snow Storms."
	TOOLTIP.YELLOWSTAFF = "- Dwarf Stars provide protection from Snow Storms."
	TOOLTIP.MOLEHAT = "- Grants protection against Snow Storms / Sand Storms when worn."
	TOOLTIP.DESERTHAT = "- Also works as protection against Snow Storms."
else
	TOOLTIP.MOLEHAT = "- Grants protection against Sand Storms when worn."
end

if TUNING.DSTU.HAYFEVER then
	TOOLTIP.GASMASK = TOOLTIP.GASMASK .. "\n- Prevents Hayfever while worn."
	TOOLTIP.PLAGUEMASK = TOOLTIP.PLAGUEMASK .. "\n- Prevents Hayfever while worn."
	TOOLTIP.BEEHAT = "- Stings won't cause allergic reactions."
	TOOLTIP.MINIFAN = "- Staves off hayfever."
	TOOLTIP.FEATHERFAN = "- Grants large amounts of Hayfever protection when blown."
	TOOLTIP.PERDFAN = "- Grants large amounts of Hayfever protection when blown."
end

if TUNING.DSTU.GOTOBED ~= false then
	TOOLTIP.BEDROLL_STRAW = "- May restore maximum health."

	TOOLTIP.BEDROLL_FURRY = "- May restore maximum health."

	TOOLTIP.TENT = "- May restore maximum health."

	TOOLTIP.PORTABLETENT_ITEM = "- May restore maximum health."

	TOOLTIP.SIESTAHUT = "- A bit less efficient.\n- May restore maximum health."
else
	TOOLTIP.SIESTAHUT = "- A bit less efficient."
end

if TUNING.DSTU.SLEEPINGBUFF > 1 then
	if TUNING.DSTU.GOTOBED then
		TOOLTIP.BEDROLL_STRAW = TOOLTIP.BEDROLL_STRAW .. "\n- Faster healing rate."

		TOOLTIP.BEDROLL_FURRY = TOOLTIP.BEDROLL_FURRY .. "\n- Faster healing rate."

		TOOLTIP.TENT = TOOLTIP.TENT .. "\n- Faster healing rate."

		TOOLTIP.SIESTAHUT = TOOLTIP.SIESTAHUT .. "\n- Faster healing rate."

		TOOLTIP.PORTABLETENT_ITEM = TOOLTIP.PORTABLETENT_ITEM .. "\n- Faster healing rate."
	else
		TOOLTIP.BEDROLL_STRAW = "- Faster healing rate."

		TOOLTIP.BEDROLL_FURRY = "- Faster healing rate."

		TOOLTIP.TENT = "- Faster healing rate."

		TOOLTIP.SIESTAHUT = "- Faster healing rate."

		TOOLTIP.PORTABLETENT_ITEM = "- Faster healing rate."
	end
end

if TUNING.DSTU.POCKET_POWERTRIP ~= 0 then
	TOOLTIP.TRUNKVEST_SUMMER = "- Now has pockets!\n- Slightly increased rain protection."
	TOOLTIP.TRUNKVEST_WINTER = "- Now has pockets!"
	TOOLTIP.REFLECTIVEVEST = "- Now has pockets!"
end

if GetModConfigData("canedurability") then
	TOOLTIP.CANE = "- Has durability, only drains when walking."
end

if TUNING.DSTU.WANDA_NERF then
	TOOLTIP.POCKETWATCH_REVIVE = "- Increased cooldown.\n- Gives health penalty."
end

if TUNING.DSTU.INSUL_THERMALSTONE then
	TOOLTIP.HEATROCK = "- Reduced inherent insulation.\n- Inherits part of players insulation."
end

if TUNING.DSTU.WICKERNERF_TENTACLES then
	TOOLTIP.BOOK_TENTACLES =
	"- Summons Sickly Tentacles\n- Sickly Tentacles die over time, drop no loot but don't attack players."
end

if GetModConfigData("woodie") then
	TOOLTIP.WEREITEM_GOOSE = "- Walking on water makes you wet."
end

if TUNING.DSTU.WINONA_GEN then
	TOOLTIP.WINONA_BATTERY_HIGH = TOOLTIP.WINONA_BATTERY_HIGH .. "\n- Access limited to Winona."
	TOOLTIP.WINONA_BATTERY_LOW = TOOLTIP.WINONA_BATTERY_LOW .. "\n- Access limited to Winona."
end

if GetModConfigData("lunar grimoire") then
	TOOLTIP.BOOK_MOON = "- Now mutates everything around on use."
end

if GetModConfigData("apicultural notes") then
    TOOLTIP.BOOK_BEES = "- Now fills up to 10 nearby Bee Boxes."
end

if GetModConfigData("disable_megaflare") then
	TOOLTIP.MEGAFLARE = "- No longer summons Deerclops."
end
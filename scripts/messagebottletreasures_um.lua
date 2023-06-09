--yes, this *is* essentially a copy-paste of the original messagebottletreasures.
--"why?" you may ask - originally, you had to replace the whole file - which isn't exactly compatible
--with other mods and may break in the future. No, I can't use table.insert. I've tried. treasure_templates
--is a "mod-hostile table". It only gets returned once *before* mods load. Any changes wouldn't work for
--treasures, despite existing in the table (checked with prints).

local treasure_templates =
{
	--	TREASUREPREFAB1 = -- Prefab to spawn at point
	--	{
	--		treasure_type_weight = 1, -- Relative container prefab appearance rate
	--
	--		presets = -- OPTIONAL! If there are no presets the treasureprefab will simply spawn as is
	--		{
	--			PRESET1 = -- Preset names have no functionality other than making it easier to keep track of which one is which
	--			{
	--				preset_weight = 1, -- Relative preset appearance rate
	--
	--				guaranteed_loot =
	--				{
	--					-- Container is guaranteed to contain this many of these prefabs
	--					ITEMPREFAB1 = {5, 8},
	--					ITEMPREFAB2 = 7,
	--					ITEMPREFAB3 = 9,
	--				},
	--				randomly_selected_loot =
	--				{
	--					-- One entry from each of these tables is randomly chosen based on weight and added to the container
	--					{
	--						ITEMPREFAB4 = 10,
	--						ITEMPREFAB5 = 5,
	--						ITEMPREFAB6 = 1,
	--					},
	--					... {}, ...
	--				},
	--			},
	--			... PRESET2, PRESET3 ...
	--		}
	--	},
	--	... TREASUREPREFAB2, TREASUREPREFAB3 ...

	sunkenchest =
	{
		treasure_type_weight = 1,

		presets =
		{
			---------------------------------------------------------------------------

			splunker = --tweaked
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					gears = { 2, 4 }, --more gears?
					thulecite = { 4, 8 },
					thulecite_pieces = { 8, 12, 16 },
					lantern = 1,
				},
				randomly_selected_loot =
				{
					{ yellowstaff = 0.33,  greenstaff = 0.33,  orangestaff = 0.33, }, --staffs and amulets instead of raw gems, lowered chance.
					{ yellowamulet = 0.33, greenamulet = 0.33, orangeamulet = 0.33, },
					{ ruinshat = 0.33,     armorruins = 0.33,  ruins_bat = 0.33 }, --chance for both thule suit and crown.

				},
			},

			-------- Modded presets.

			inventor =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					trident = 1,
					papyrus = { 3, 5 },
					charcoal = { 4, 7 },
					goldenpickaxe = 1,
					blueprint = { 1, 2, 3 },
				},
				randomly_selected_loot =
				{
					{ stinger = 0.5, nitre = 0.5 },
					{ stinger = 0.5, nitre = 0.5 },
					{ stinger = 0.5, nitre = 0.5 },
					{ stinger = 0.5, nitre = 0.5 },

				},

			},
			------------------
			scientist =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					molehat = 1,
					nightstick = 1,
					transistor = { 1, 2 },
					goldenpickaxe = 1,
				},
				randomly_selected_loot =
				{
					{ gunpowder = 0.30, slurtleslime = 0.50, wormlight = 0.20 },
				},

			},
			------------------
			farmer =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					treegrowthsolution = { 3, 5 },
					fig = { 5, 10 },
					gnarwail_horn = 1,
					glommerfuel = { 5, 7, 10 },
					dug_berrybush = { 0, 5 },
					dug_berrybush2 = { 0, 5 },

				},
				randomly_selected_loot =
				{
					{ gnarwail_horn = 0.5,        malbatross_beak = 0.25 },
					{ nutrientsgoggleshat = 0.10, plantregistryhat = 0.90 },
				},
			},

			------------------
			cave_hunter =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					multitool_axe_pickaxe = 1,
					slurper_pelt = { 3, 6 },
					silk = { 6, 8, 10 },
					mole = { 2, 3 },
					goldnugget = { 4, 7, 10 },
				},
				randomly_selected_loot =
				{
					{ tentaclespike = 0.5, batbat = 0.5 },
					{ wormlight = 0.2,     wormlight_lesser = .6, minerhat = 0.2, },
				},
			},
			------------------
			resource_stash =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					cutgrass = { 20, 30, 40 },
					twigs = { 20, 30, 40 },
					silk = { 6, 8, 10 },
					rocks = { 10, 15, 20, 25, 30 },
					goldnugget = { 4, 7, 10 },
				},
				randomly_selected_loot =
				{

				},
			},
			------------------
			kings_stash =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					greengem = { 1, 2, 3 },
					yellowgem = { 1, 2, 3 },
					purplegem = { 1, 2, 3 },
					orangegem = { 1, 2, 3 },
					bluegem = { 1, 2, 3 },
					redgem = { 1, 2, 3 },
				},
				randomly_selected_loot =
				{
					{ opalpreciousgem = 0.25 },
				},
			},
			whaler =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					sludge = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
					um_magnerang = 1,
					sludge_cork = { 1, 2 },
					boneshard = { 4, 7, 10 },
				},
				randomly_selected_loot =
				{
					{ gnarwail_horn = 0.5, rockjawleather = 0.5 },
					{ gnarwail_horn = 0.5, rockjawleather = 0.5 },
				},
			},

		}
	},
	sunkenchest_royal_random =
	{
		treasure_type_weight = 0.5,

		presets =
		{
			traveler =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					cane = 1,
					gnarwail_horn = 1,
					papyrus = { 4, 8 },
					featherpencil = { 2, 4 },
				},
				randomly_selected_loot =
				{
					{ compass = 0.25, goggleshat = 0.75 },
				},
			},
			----------------
			cave_hunter =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					multitool_axe_pickaxe = 1,
					slurper_pelt = { 3, 6 },
					silk = { 6, 8, 10 },
				},
				randomly_selected_loot =
				{
					{ tentaclespike = 0.5, batbat = 0.5 },
					{ wormlight = 0.2,     wormlight_lesser = .6, minerhat = 0.2, },
				},
			},
			------------------
			scientist =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					molehat = 1,
					nightstick = 1,
					transistor = { 1, 2 },
				},
				randomly_selected_loot =
				{
					{ wormlight = 0.20 },
				},

			},
			-------------
			inventor =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					staff_tornado = 1,
					papyrus = { 3, 5 },
					blueprint = { 1, 2, 3 },
				},
				randomly_selected_loot =
				{

				},

			},
			---------------
			kings_stash =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					greengem = { 1, 2 },
					yellowgem = { 1, 2 },
					purplegem = { 1, 2 },
					orangegem = { 1, 2 },
					bluegem = { 1, 2 },
					redgem = { 1, 2 },
				},
				randomly_selected_loot =
				{
					{ opalpreciousgem = 0.25 },
				},
			},
			theukon1 =
			{
				preset_weight = 1,
				guaranteed_loot =
				{
					moonglass = { 10, 15 },
					messagebottleempty = { 5, 10 },
					messagebottle = 2,
					alterguardianhatshard = { 3, 4 },
				},
				randomly_selected_loot =
				{
					{ opalstaff = 0.2,     yellowstaff = 0.2,   greenstaff = 0.2,   orangestaff = 0.2,  telestaff = 0.2 },
					{ yellowamulet = 0.25, orangeamulet = 0.25, greenamulet = 0.25, purpleamulet = 0.25 },
					{ trinket_26 = 0.1 },
				},
			},
			uncompromsing =
			{
				preset_weight = 1,
				guaranteed_loot =
				{
				},
				randomly_selected_loot =
				{
					{ nightstick = 0.5,      bugzapper = 0.5 },
					{ ancient_amulet_red = 1 },
					{ plaguemask = 0.33,     widowshead = 0.33,       sunglasses = 0.33 },
					{ viperjam = 0.33,       beefalowings = 0.33,     zaspberryparfait = 0.33 },
					{ glass_scales = 0.33,   pied_piper_flute = 0.33, widowsgrasp = 0.33 },
					{
						hat_bagmask = 0.41,
						hat_blackcatmask = 0.41,
						hat_clownmask = 0.41,
						hat_orangecatmask = 0.41,
						hat_devilmask = 0.41,
						hat_fiendmask = 0.41,
						hat_ghostmask = 0.41,
						hat_oozemask = 0.41,
						hat_globmask = 0.41,
						hat_hockeymask = 0.41,
						hat_joyousmask = 0.41,
						hat_mermmask = 0.41,
						hat_phantommask = 0.41,
						hat_pigmask = 0.41,
						hat_pumpgoremask = 0.41,
						hat_wathommask = 0.41,
						hat_redskullmask = 0.41,
						hat_skullmask = 0.41,
						hat_spectremask = 0.41,
						hat_ratmask = 0.41,
						hat_whitecatmask = 0.41,
						hat_technomask = 0.41,
						hat_mandrakemask = 0.41,
						hat_opossummask = 0.41
					},
				},
			}
		}
	},

	sunkenchest_royal_red =
	{
		treasure_type_weight = 0,

		presets =
		{
			red =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					armor_crab_maxhp_blueprint = 1,
					ancient_amulet_red = 1,
					sludge = { 4, 8 },
					redgem = { 1, 2 },
					nitre = { 1, 2, 3, 4 },
				},
			},
		}
	},
	sunkenchest_royal_blue =
	{
		treasure_type_weight = 0,

		presets =
		{
			blue =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					crab_hat_ice_blueprint = 1,
					blueamulet = 1,
					ice = { 4, 8 },
					bluegem = { 1, 2 },
				},
			},
		}
	},
	sunkenchest_royal_purple =
	{
		treasure_type_weight = 0,

		presets =
		{
			purple =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					trident_blueprint = 1,
					kelp = 2,
					gnarwail_horn = { 1, 2 },
					purplegem = { 1, 2 },
				},
			},
		}
	},
	sunkenchest_royal_orange =
	{
		treasure_type_weight = 0,

		presets =
		{
			orange =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					crab_hat_blueprint = 1,
					rocks = 4,
					cutstone = { 1, 2 },
					orangegem = { 1, 2 },
				},
			},
		}
	},
	sunkenchest_royal_yellow =
	{
		treasure_type_weight = 0,

		presets =
		{
			yellow =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					staff_starfall_blueprint = 1,
					goldnugget = 4,
					feather_canary = { 1, 2 },
					yellowgem = { 1, 2 },
				},
			},
		}
	},
	sunkenchest_royal_green =
	{
		treasure_type_weight = 0,

		presets =
		{
			green =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					armor_crab_regen_blueprint = 1,
					cutreeds = 4,
					rocks = { 1, 2, 3 },
					greengem = { 1, 2 },
				},
			},
		}
	},
	sunkenchest_royal_rainbow =
	{
		treasure_type_weight = 0,

		presets =
		{
			rainbow =
			{
				preset_weight = 1,

				guaranteed_loot =
				{
					moon_beacon_kit = 1,
					moonrocknugget = { 1, 2, 3, 4 },
					moonglass = { 0, 1, 2, 3, 4, 5 },
					moonstorm_spark = { 1, 2, 3 }, -- Teehee :)
					moonglass_charged = { 1, 2, 3, 4, 5 },
				},
			},
		}
	},
}



local trinkets =
{
	"trinket_3",
	"trinket_4",
	"trinket_5",
	"trinket_6",
	"trinket_7",
	"trinket_8",
	"trinket_9",
	"trinket_17",
	"trinket_22",
	"trinket_27",
}

local TRINKET_CHANCE = 0.02

local weighted_treasure_prefabs = {}
local weighted_treasure_contents = {}
for prefabname, data in pairs(treasure_templates) do
	weighted_treasure_prefabs[prefabname] = data.treasure_type_weight

	if data.presets ~= nil then -- If nil the prefab being spawned is not a container
		weighted_treasure_contents[prefabname] = {}
		for _, loottable in pairs(data.presets) do
			weighted_treasure_contents[prefabname][loottable] = loottable.preset_weight
		end
	end
end

local function GenerateTreasure(pt, overrideprefab, spawn_as_empty, postfn)
	local prefab = overrideprefab or weighted_random_choice(weighted_treasure_prefabs)

	local treasure = SpawnPrefab(prefab)
	if treasure ~= nil then
		local x, y, z = pt.x, pt.y, pt.z
		treasure.Transform:SetPosition(x, y, z)

		-- If overrideprefab is supplied but it has no entry in the 'treasure_templates' loot
		-- table in this file the prefab instance will be empty regardless of spawn_as_empty.

		if not spawn_as_empty and (treasure.components.container ~= nil or treasure.components.inventory ~= nil) and
			weighted_treasure_contents[prefab] ~= nil and type(weighted_treasure_contents) == "table" and
			next(weighted_treasure_contents[prefab]) ~= nil then
			local lootpreset = weighted_random_choice(weighted_treasure_contents[prefab])
			local prefabstospawn = {}

			if lootpreset.guaranteed_loot ~= nil then
				for itemprefab, count in pairs(lootpreset.guaranteed_loot) do
					local total = type(count) ~= "table" and count or math.random(count[1], count[2])
					for i = 1, total do
						table.insert(prefabstospawn, itemprefab)
					end
				end
			end

			if lootpreset.randomly_selected_loot ~= nil then
				for i, one_of in ipairs(lootpreset.randomly_selected_loot) do
					table.insert(prefabstospawn, weighted_random_choice(one_of))
				end
			end


			local item = nil
			for i, itemprefab in ipairs(prefabstospawn) do
				item = SpawnPrefab(itemprefab)
				item.Transform:SetPosition(x, y, z)
				if treasure.components.container ~= nil then
					treasure.components.container:GiveItem(item)
				else
					treasure.components.inventory:GiveItem(item)
				end
			end

			if math.random() < TRINKET_CHANCE then
				if treasure.components.container ~= nil then
					if not treasure.components.container:IsFull() then
						treasure.components.container:GiveItem(SpawnPrefab(trinkets[math.random(#trinkets)]))
					end
				elseif treasure.components.inventory ~= nil then
					if not treasure.components.inventory:IsFull() then
						treasure.components.inventory:GiveItem(SpawnPrefab(trinkets[math.random(#trinkets)]))
					end
				end
			end
		end

		if postfn ~= nil then
			postfn(treasure)
		end
	end

	return treasure
end

local function GetPrefabs()
	local prefabscontain = {}
	for treasureprefab, weighted_lists in pairs(weighted_treasure_contents) do
		prefabscontain[treasureprefab] = true -- Chests, etc

		if weighted_lists ~= nil and type(weighted_lists) == "table" and next(weighted_lists) ~= nil then
			for weighted_list, _ --[[weight]] in pairs(weighted_lists) do
				if weighted_list.guaranteed_loot ~= nil then
					for itemprefab, _ --[[count]] in pairs(weighted_list.guaranteed_loot) do
						prefabscontain[itemprefab] = true
					end
				end

				if weighted_list.randomly_selected_loot ~= nil then
					for i, v in ipairs(weighted_list.randomly_selected_loot) do
						for itemprefab, _ --[[weight]] in pairs(v) do
							prefabscontain[itemprefab] = true
						end
					end
				end
			end
		end
	end

	local prefablist = {}
	for prefab, _ in pairs(prefabscontain) do
		table.insert(prefablist, prefab)
	end

	for i, trinketprefab in ipairs(trinkets) do
		table.insert(prefablist, trinketprefab)
	end

	return prefablist
end

return { GenerateTreasure = GenerateTreasure, GetPrefabs = GetPrefabs, treasure_templates = treasure_templates }

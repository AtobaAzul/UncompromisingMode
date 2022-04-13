--couldn't figure out a way to do this without overriding, sorry. -Atobá
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
		saltminer =
		{
			preset_weight = 1,

			guaranteed_loot =
			{
				cookiecuttershell = {4, 6},
				boatpatch = {2, 4},
				saltrock = {5, 8},
				goldenpickaxe = 1,
			},
			randomly_selected_loot =
			{
				{ bluegem = 1, redgem = 1 },
			},
		},
		---------------------------------------------------------------------------
		traveler =
		{
			preset_weight = 1,

			guaranteed_loot =
			{
				cane = 1,
				heatrock = 1,
				gnarwail_horn = 1,
				papyrus = {4, 8},
				featherpencil = {2, 4},
				spoiled_fish = {3, 5},
			},
			randomly_selected_loot =
			{
				{ compass = .25, goggleshat = .75 },
			},
		},
		---------------------------------------------------------------------------
		fisher =
		{
			preset_weight = 1,

			guaranteed_loot =
			{
				boatpatch = {4, 8},
				malbatross_feather = {4, 10},
				oceanfishingrod = 1,
				oceanfishingbobber_robin_winter = {2, 5},
				oceanfishinglure_spoon_green = {1, 4},
				oceanfishinglure_hermit_heavy = {0, 2},
			},
			randomly_selected_loot =
			{
				{ boat_item = 1, anchor_item = 1, mast_item = 1, steeringwheel_item = 1, fish_box_blueprint = 1 },
			},
		},
		---------------------------------------------------------------------------
		miner =
		{
			preset_weight = 1,

			guaranteed_loot =
			{
				cutstone = {3, 6},
				goldnugget = {3, 6},
				moonglass = {3, 6},
				moonrocknugget = {3, 6},
				goldenpickaxe = 1,
			},
			randomly_selected_loot =
			{
				{ purplegem = 0.5, greengem = 0.1, yellowgem = 0.2, orangegem = 0.2, },
			},

		},
		---------------------------------------------------------------------------

			splunker =  --tweaked
			   {
				   preset_weight = 1,

				   guaranteed_loot =
				   {
					   gears = {2, 4}, --more gears?
					   thulecite = {4, 8},
					   thulecite_pieces = {8, 12, 16},
					   lantern = 1,
				   },
				   randomly_selected_loot =
				   {

					   {yellowstaff = 0.33, greenstaff = 0.33, orangestaff = 0.33,}, --staffs and amulets instead of raw gems, lowered chance.
					   {yellowamulet = 0.33, greenamulet = 0.33, orangeamulet = 0.33, },
					   {ruinshat = 0.33, armorruins = 0.33, ruins_bat = 0.33}, --chance for both thule suit and crown.

				   },
			   },

			   -------- Modded presets.

			 inventor =
			   {
				   preset_weight = 1,

				   guaranteed_loot =
				   {
					   trident = 1,
					   papyrus = {3, 5},
					   charcoal = {4, 7},
					   goldenpickaxe = 1,
					   blueprint = {1, 2, 3},
				   },
				   randomly_selected_loot =
				   {
					   {stinger = 0.5, nitre = 0.5 },
					   {stinger = 0.5, nitre = 0.5 },
					   {stinger = 0.5, nitre = 0.5 },
						{stinger = 0.5, nitre = 0.5 },

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
					   transistor = {1, 2},
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
					   treegrowthsolution = {3, 5},
					   fig = {5, 10},
					   gnarwail_horn = 1,
					   glommerfuel = {5, 7, 10},
					   dug_berrybush = {0, 5},
					   dug_berrybush2 = {0, 5},

				   },
				   randomly_selected_loot =
				   {
					   { gnarwail_horn = 0.5, malbatross_beak = 0.25},
					   {nutrientsgoggleshat = 0.10, plantregistryhat = 0.90},
				   },
			   },

				------------------
			   cave_hunter =
			   {
				   preset_weight = 1,

				   guaranteed_loot =
				   {
					   multitool_axe_pickaxe = 1,
					   slurper_pelt = {3, 6},
					   silk = {6, 8, 10},
					   mole = {2,3},
					   goldnugget = {4,7,10},
				   },
				   randomly_selected_loot =
				   {
					   { tentaclespike = 0.5, batbat = 0.5  },
					   { wormlight = 0.2, wormlight_lesser = .6, minerhat = 0.2,  },
				   },
			   },
		   ------------------
			resource_stash =
			   {
				   preset_weight = 1,

				   guaranteed_loot =
				   {
					   cutgrass = {20, 30,  40},
					   twigs = {20, 30,  40},
					   silk = {6, 8, 10},
					   rocks = {10, 15, 20, 25, 30},
					   goldnugget = {4,7,10},
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
					   greengem = {1, 2, 3},
					   yellowgem = {1, 2, 3},
					   purplegem = {1, 2, 3},
					   orangegem = {1, 2, 3},
					   bluegem = {1, 2, 3},
					   redgem = {1, 2, 3},
				   },
				   randomly_selected_loot =
				   {
					   {opalpreciousgem = 0.25},
				   },
			   }

		}
	},
royal_sunkenchest =
{
	treasure_type_weight = 0,

	presets =
	{
		traveler =
		{
			preset_weight = 1,

			guaranteed_loot =
			{
				cane = 1,
				heatrock = 1,
				gnarwail_horn = 1,
				papyrus = {4, 8},
				featherpencil = {2, 4},
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
				slurper_pelt = {3, 6},
				silk = {6, 8, 10},
			},
			randomly_selected_loot =
			{
				{ tentaclespike = 0.5, batbat = 0.5  },
				{ wormlight = 0.2, wormlight_lesser = .6, minerhat = 0.2,  },
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
				transistor = {1, 2},
				goldenpickaxe = 1,
			},
			randomly_selected_loot =
			{
				{slurtleslime = 0.50, wormlight = 0.20 },
			},

		},
		-------------
		inventor =
		{
			preset_weight = 1,

			guaranteed_loot =
			{
				staff_tornado = 1,
				papyrus = {3, 5},
				charcoal = {4, 7},
				goldenpickaxe = 1,
				blueprint = {1, 2, 3},
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
				greengem = {1, 2, 3},
				yellowgem = {1, 2, 3},
				purplegem = {1, 2, 3},
				orangegem = {1, 2, 3},
				bluegem = {1, 2, 3},
				redgem = {1, 2, 3},
			},
			randomly_selected_loot =
			{
				{opalpreciousgem = 0.25},
			},
		},
		theukon1 =
		{
		preset_weight = 1,
		guaranteed_loot =
		{
			moonglass = {15, 20},
			messagebottleempty = {10, 15},
			messagebottle = 2,  --These should always have messages from Pearl in them instead of maps, to show that CK knew she was looking for him, and actively chose power over her.
			alterguardianhatshard = {3,4},
		},
		randomly_selected_loot =
		{
		  {opalstaff = 0.8, yellowstaff = 0.2},
		  {greenstaff = 0.33, orangestaff = 0.33, telestaff = 0.33},
		  {yellowamulet = 0.33, orangeamulet = 0.33, greenamulet = 0.33, purpleamulet = 0.33},
		  {trinket_26 = 0.1},
		},
		}
		--[[
		god_slayer =
        {
            preset_weight = 1,
            guaranteed_loot =
            {
                glasscutter = {1, 2, 3},
                ruinshat = {1, 2, 3},
              },
              randomly_selected_loot =
              {
                {nightstick = 0.33, batbat = 0.33, ruins_bat = 0.33, ancient_amulet_red = 0.33},
                {viperjam = 0.33, beefalowings = 0.33, zaspberryparfeit = 0.33},
                {glass_scales = 0.20, widowshead = 0.20, piedpiperpipe = 0.20, minotaurhorn = 0.20, shieldofterror = 0.20}   --covers some blind spots in Klaus' loot. Also some UM items. Also I have no idea the prefab name for the Pied Piper Pipe
              },
            } When the time is right.
		}]]
	},

}
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

		if not spawn_as_empty and (treasure.components.container ~= nil or treasure.components.inventory ~= nil) and weighted_treasure_contents[prefab] ~= nil and type(weighted_treasure_contents) == "table" and next(weighted_treasure_contents[prefab]) ~= nil then
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
					print("loot inserted into container!")
				else
					treasure.components.inventory:GiveItem(item)
					print("loot inserted into inventory!!")
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
			for weighted_list, _--[[weight]] in pairs(weighted_lists) do
				if weighted_list.guaranteed_loot ~= nil then
					for itemprefab, _--[[count]] in pairs(weighted_list.guaranteed_loot) do
						prefabscontain[itemprefab] = true
					end
				end

				if weighted_list.randomly_selected_loot ~= nil then
					for i, v in ipairs(weighted_list.randomly_selected_loot) do
						for itemprefab, _--[[weight]] in pairs(v) do
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

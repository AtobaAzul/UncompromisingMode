local RECIPE_ICE_LIMIT = TUNING.DSTU.CROCKPOT_RECIPE_ICE_LIMIT
local RECIPE_TWIG_LIMIT = TUNING.DSTU.CROCKPOT_RECIPE_TWIG_LIMIT
local RECIPE_ICE_PLUS_TWIG_LIMIT = TUNING.DSTU.CROCKPOT_RECIPE_ICE_PLUS_TWIG_LIMIT
local easing = require("easing")

local function LimitIceTestFn(tags, ice_limit)
	if tags ~= nil and tags.frozen ~= nil and TUNING.DSTU.GENERALCROCKBLOCKER then
		return (not tags.frozen or (tags.frozen + (tags.foliage ~= nil and tags.foliage or 0) <= ice_limit))
	end
	return true
end

local function LimitTwigTestFn(tags, twig_limit)
	if tags ~= nil and tags.inedible ~= nil then
		return not tags.inedible or (tags.inedible + (tags.foliage ~= nil and tags.foliage or 0) <= twig_limit)
	end
	return true
end

local function LimitIcePlusTwigTestFn(tags, ice_plus_twig_limit)
	if tags ~= nil and tags.frozen ~= nil and tags.inedible ~= nil then
		return (tags.frozen + tags.inedible + (tags.foliage ~= nil and tags.foliage or 0)) <= ice_plus_twig_limit
	end
	return true
end

local function UncompromisingFillerCustomTestFn(tags, ice_limit, twig_limit, ice_plus_twig_limit)
	return LimitIceTestFn(tags, ice_limit) and LimitTwigTestFn(tags, twig_limit) and
		LimitIcePlusTwigTestFn(tags, ice_plus_twig_limit)
end

local function UncompromisingFillers(tags)
	return (
		UncompromisingFillerCustomTestFn(tags, RECIPE_ICE_LIMIT, RECIPE_TWIG_LIMIT, RECIPE_ICE_PLUS_TWIG_LIMIT) and
		TUNING.DSTU.GENERALCROCKBLOCKER) or TUNING.DSTU.GENERALCROCKBLOCKER == false
end

local um_preparedfoods =
{
	beefalowings =
	{
		test = function(cooker, names, tags)
			return tags.veggie and names.horn and
				(
					(names.batwing and names.batwing > 1) or (names.batwing_cooked and names.batwing_cooked > 1) or
					(names.batwing and names.batwing_cooked))
		end,
		hunger = 62.5,
		health = 30,
		sanity = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = 5 * TUNING.PERISH_TWO_DAY,
		priority = 20,
		weight = 30,
		cooktime = 2.4,
		floater = { "med", nil, 0.6 },
		tags = { "honeyed" },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_BEEFALOWINGS,
		oneatenfn = function(inst, eater)
			if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
				not (eater.components.health ~= nil and eater.components.health:IsDead()) and
				not eater:HasTag("playerghost") then
				eater.components.debuffable:AddDebuff("buff_knockbackimmune", "buff_knockbackimmune")
			end
		end,
		card_def = { ingredients = { { "carrot", 1 }, { "horn", 1 }, { "batwing", 1 } } },
	},

	blueberrypancakes =
	{
		test = function(cooker, names, tags)
			return names.giant_blueberry and names.giant_blueberry >= 2 and tags.egg and
				tags.egg > 1
		end,
		hunger = 75,
		health = 5,
		sanity = 20,
		priority = 20,
		weight = 30,
		cooktime = 1.8,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		floater = { "med", 0.05, 0.65 },
		card_def = { ingredients = { { "giant_blueberry", 2 }, { "bird_egg", 2 } } },
	},

	californiaking =
	{
		test = function(cooker, names, tags)
			return (names.barnacle or names.barnacle_cooked) and
				(names.wobster_sheller_land) and (names.pepper or names.pepper_cooked) and tags.frozen
		end,
		hunger = 62.5,
		health = 3,
		sanity = -15,
		priority = 30,
		weight = 30,
		cooktime = 2,
		foodtype = FOODTYPE.MEAT,
		perishtime = 5 * TUNING.PERISH_TWO_DAY,
		floater = { "med", nil, 0.8 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_CALIFORNIAKING,
		oneatenfn = function(inst, eater)
			if eater.components.hayfever and eater.components.hayfever.enabled then
				eater.components.hayfever:SetNextSneezeTime(1920) --Should be four days			
			end

			if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
				not (eater.components.health ~= nil and eater.components.health:IsDead()) and
				not eater:HasTag("playerghost") then
				eater.components.debuffable:AddDebuff("buff_californiaking", "buff_californiaking")
			end
		end,
		card_def = { ingredients = { { "barnacle", 1 }, { "wobster_sheller_land", 1 }, { "pepper", 1 }, { "ice", 1 } } },
	},

	--[[carapacecooler =
	{
		test = function(cooker, names, tags)
			return not tags.monster and not tags.inedible and UncompromisingFillers(tags)
				and names.iceboomerang and tags.sweetener
		end,
		hunger = 37.5,
		health = 40,
		sanity = 15,
		priority = 30,
		weight = 1,
		cooktime = 0.5,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = 2*TUNING.PERISH_TWO_DAY,
		floater = {"small", nil, 0.6},
		card_def = {ingredients = {{"iceboomerang", 1}, {"honey", 1}}},
	},]]

	devilsfruitcake =
	{
		test = function(cooker, names, tags)
			return (names.pomegranate or names.pomegranate) and not tags.meat and tags.egg and tags.egg >= 2 and UncompromisingFillers(tags)
		end,
		hunger = 62.5,
		health = 60,
		sanity = -0.6,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		priority = 1,
		weight = 1,
		cooktime = 2,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		floater = { "med", 0.05, 0.65 },
		card_def = { ingredients = { { "pomegranate", 1 }, { "bird_egg", 2 } } },
	},

	hardshelltacos =
	{
		test = function(cooker, names, tags) return names.scorpioncarapace and names.scorpioncarapace > 1 and tags.veggie end,
		hunger = 37.5,
		health = 20,
		sanity = 5,
		priority = 52,
		weight = 1,
		cooktime = 1,
		foodtype = FOODTYPE.MEAT,
		perishtime = 7.5 * TUNING.PERISH_TWO_DAY,
		floater = { "med", 0.05, 0.65 },
		card_def = { ingredients = { { "scorpioncarapace", 1 }, { "carrot", 1 } } },
	},

	liceloaf =
	{
		test = function(cooker, names, tags)
			return (tags.rice and tags.rice >= 2) and UncompromisingFillers(tags) and
				not (tags.insectoid and tags.insectoid >= 1) and not tags.inedible
		end,
		hunger = 62.5,
		health = 0,
		sanity = 0,
		priority = 30,
		weight = 1,
		cooktime = 1.2,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = 15 * TUNING.PERISH_TWO_DAY,
		priority = 20,
		floater = { "med", 0.05, 0.65 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_LICELOAF,
		oneatenfn = function(inst, eater)
			if eater.components.hayfever and eater.components.hayfever.enabled then
				eater.components.hayfever:SetNextSneezeTime(1440)
			end
		end,
	},

	seafoodpaella =
	{
		test = function(cooker, names, tags)
			return UncompromisingFillers(tags) and tags.rice and tags.veggie and
				tags.veggie >= 2 and (names.wobster_sheller_land or tags.fish and tags.fish >= 2)
		end,
		hunger = 75,
		health = 20,
		sanity = 60,
		priority = 30,
		weight = 1,
		cooktime = 1,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		floater = { "med", 0.05, 0.65 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_SEAFOODPAELLA,
		oneatenfn = function(inst, eater)
			if eater.components.hayfever and eater.components.hayfever.enabled then
				eater.components.hayfever:SetNextSneezeTime(1440)
			end
		end,
		card_def = { ingredients = { { "wobster_sheller_land", 1 }, { "rice", 1 }, { "carrot", 1 } } },
	},

	simpsalad =
	{
		test = function(cooker, names, tags)
			return tags.foliage and tags.foliage > 1 and
				not (tags.frozen and tags.frozen >= 1 and tags.sweetener and tags.sweetener >= 1)
		end,
		hunger = 4.9,
		health = 1,
		sanity = 1,
		priority = 53,
		weight = 20,
		cooktime = 0.4,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = 2 * TUNING.PERISH_TWO_DAY,
		floater = { "med", 0.05, 0.65 },
	},

	snotroast =
	{
		test = function(cooker, names, tags)
			return (names.trunk_summer or names.trunk_winter or names.trunk_cooked) and
				(names.carrot or names.carrot_cooked) and (names.potato or names.potato_cooked) and
				(names.onion or names.onion_cooked)
		end,
		hunger = 150,
		health = 3,
		sanity = 5,
		priority = 30,
		weight = 1,
		cooktime = 1.8,
		foodtype = FOODTYPE.MEAT,
		perishtime = 5 * TUNING.PERISH_TWO_DAY,
		floater = { "med", nil, 0.65 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_SNOTROAST,
		oneatenfn = function(inst, eater)
			if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
				not (eater.components.health ~= nil and eater.components.health:IsDead()) and
				not eater:HasTag("playerghost") then
				eater.components.debuffable:AddDebuff("buff_largehungerslow", "buff_largehungerslow")
			end
		end,
		card_def = { ingredients = { { "onion", 1 }, { "potato", 1 }, { "carrot", 1 }, { "trunk_summer", 1 } } },
	},

	snowcone =
	{
		test = function(cooker, names, tags) return TUNING.DSTU.ICECROCKBLOCKER == true and ((names.ice and names.ice > 1) or (names.ice and names.twigs)) end,
		hunger = 9.375,
		health = 3,
		sanity = 5,
		priority = 0.5,
		weight = 0.5,
		cooktime = 0.5,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = 2 * TUNING.PERISH_TWO_DAY,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_BRIEF,
		floater = { nil, 0.1, 0.6 },
	},

	stuffed_peeper_poppers =
	{
		test = function(cooker, names, tags)
			return (names.milkywhites) and (tags.monster and tags.monster >= 2) and
				(names.durian or names.durian_cooked) and not tags.inedible
		end,
		hunger = 37.5,
		health = -3,
		sanity = -15,
		priority = 52,
		weight = 1,
		cooktime = 1.8,
		foodtype = FOODTYPE.MEAT,
		perishtime = 4 * TUNING.PERISH_TWO_DAY,
		floater = { "med", nil, 0.65 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_STUFFED_PEEPER_POPPERS,
		oneatenfn = function(inst, eater)
			local function SpawnEyes(inst, eater)
				local x, y, z = inst.Transform:GetWorldPosition()
				local pt = inst:GetPosition()
				local speed = easing.linear(3, 7, 3, 10)
				pt.x = pt.x + math.random(-3, 3)
				pt.z = pt.z + math.random(-3, 3)

				local projectile = SpawnPrefab("eyeofterror_mini_projectile_ally")
				projectile.Transform:SetPosition(x, y, z)
				projectile:AddTag("canthit")
				projectile:AddTag("friendly")
				projectile.components.complexprojectile:SetHorizontalSpeed(speed + math.random(4, 9))

				if TheWorld.Map:IsAboveGroundAtPoint(pt.x, 0, pt.z) or TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z) ~= nil then
					inst.count = 0
					projectile.player = eater
					projectile.components.complexprojectile:Launch(pt, inst, inst)
				else
					if inst.count < 10 then
						inst.count = inst.count + 1
						inst:DoTaskInTime(0, SpawnEyes(inst, eater))
					end

					projectile:Remove()
				end
			end

			inst.count = 0

			if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and not (eater.components.health ~= nil and eater.components.health:IsDead()) and not eater:HasTag("playerghost") then
				for k = 1, 2 do
					inst:DoTaskInTime(0, SpawnEyes(inst, eater))
				end
			end
		end,
		card_def = { ingredients = { { "milkywhites", 1 }, { "durian", 2 } } },
	},

	theatercorn =
	{
		test = function(cooker, names, tags)
			return (
				(names.corn_cooked and names.corn_cooked >= 2) or (names.corn and names.corn >= 2) or
				(names.corn and names.corn_cooked)) and (names.butter)
		end,
		stacksize = 3,
		hunger = 37.5,
		health = 20,
		priority = 30,
		weight = 1,
		cooktime = 1.8,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = 10 * TUNING.PERISH_TWO_DAY,
		floater = { "med", nil, 0.65 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_THEATERCORN,
		oneatenfn = function(inst, eater)
			if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
				not (eater.components.health ~= nil and eater.components.health:IsDead()) and
				not eater:HasTag("playerghost") then
				local x, y, z = eater.Transform:GetWorldPosition()
				local combatents = TheSim:FindEntities(x, y, z, 20, { "_combat" })
				local count = 0
				for i, v in ipairs(combatents) do
					if v.components.combat ~= nil and v.components.combat.target ~= nil then
						count = count + 1
						if v:HasTag("epic") then
							count = count + 5
						end
					end
				end

				if count > 0 and count <= 5 then
					eater.tempamusetier = 1
				end

				if count > 5 and count <= 10 then
					eater.tempamusetier = 2
				end

				if count > 10 and count <= 15 then
					eater.tempamusetier = 3
				end

				if count > 15 then
					eater.tempamusetier = 4
				end

				eater.components.debuffable:AddDebuff("buff_amusementcorn", "buff_amusementcorn")
				eater:DoTaskInTime(1, function(eater)
					if eater.tempamusetier ~= nil then
						eater.tempamusetier = nil
					end
				end)
			end
		end,
		card_def = { ingredients = { { "corn", 2 }, { "butter", 1 } } },
	},

	um_deviled_eggs =
	{
		--test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and tags.egg and not tags.meat end,
		test = function(cooker, names, tags) return tags.monster and tags.egg and not tags.meat and tags.monster > tags.egg end,
		
		hunger = 18.75,
		health = -15,
		sanity = -20,
		priority = 52,
		weight = 1,
		cooktime = .5,
		foodtype = FOODTYPE.MEAT,
		secondaryfoodtype = FOODTYPE.MONSTER,
		perishtime = TUNING.PERISH_FAST,
		floater = { nil, 0.1, 0.6 },
	},

	purplesteamedhams =
	{
		test = function(cooker, names, tags)
			return (names.foliage or names.forgetmelots) and tags.veggie and
				tags.veggie >= 1.5 and (names.meat or names.cookedmeat) and
				not (tags.monster or tags.inedible or names.smallmeat or names.cookedsmallmeat)
		end,
		hunger = 37.5,
		health = 40,
		sanity = 15,
		priority = 30,
		weight = 30,
		cooktime = 1,
		foodtype = FOODTYPE.MEAT,
		perishtime = 3 * TUNING.PERISH_TWO_DAY,
		floater = { nil, 0.1, 0.6 },
	},

	greensteamedhams =
	{
		test = function(cooker, names, tags)
			return names.greenfoliage and tags.veggie and tags.veggie >= 1.5 and
				(names.meat or names.cookedmeat) and
				not (tags.monster or tags.inedible or names.smallmeat or names.cookedsmallmeat)
		end,
		hunger = 37.5,
		health = 40,
		sanity = 15,
		priority = 30,
		weight = 30,
		cooktime = 1,
		foodtype = FOODTYPE.MEAT,
		perishtime = 3 * TUNING.PERISH_TWO_DAY,
		floater = { nil, 0.1, 0.6 },
		card_def = { ingredients = { { "greenfoliage", 1 }, { "carrot", 2 }, { "meat", 1 } } },
	},

	viperjam =
	{
		test = function(cooker, names, tags)
			return not tags.monster and not tags.inedible and UncompromisingFillers(tags)
				and names.viperfruit and names.giant_blueberry
		end,
		hunger = 37.5,
		health = 40,
		sanity = 15,
		priority = 30,
		weight = 1,
		cooktime = 1.8,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = 10 * TUNING.PERISH_TWO_DAY,
		floater = { nil, 0.1, 0.6 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_VIPERJAM,
		oneatenfn = function(inst, eater)
			local function SpawnVipers(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				local projectile = SpawnPrefab("viperprojectile")
				projectile.Transform:SetPosition(x, y, z)
				local pt = inst:GetPosition()
				pt.x = pt.x + math.random(-3, 3)
				pt.z = pt.z + math.random(-3, 3)
				local speed = easing.linear(3, 7, 3, 10)
				projectile:AddTag("canthit")
				projectile:AddTag("friendly")
				--projectile.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS/2
				projectile.components.complexprojectile:SetHorizontalSpeed(speed + math.random(4, 9))
				if TheWorld.Map:IsAboveGroundAtPoint(pt.x, 0, pt.z) or TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z) ~= nil then
					inst.count = 0
					projectile.components.complexprojectile:Launch(pt, inst, inst)
				else
					if inst.count < 10 then
						inst.count = inst.count + 1
						inst:DoTaskInTime(0, SpawnVipers(inst))
					end
					projectile:Remove()
				end
			end

			inst.count = 0
			if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
				not (eater.components.health ~= nil and eater.components.health:IsDead()) and
				not eater:HasTag("playerghost") then
				for k = 1, 6 do
					inst:DoTaskInTime(0, SpawnVipers(inst))
				end
			end
		end,
		card_def = { ingredients = { { "viperfruit", 1 }, { "giant_blueberry", 1 } } },
	},

	zaspberryparfait =
	{
		test = function(cooker, names, tags)
			return not tags.monster and not tags.inedible and UncompromisingFillers(tags)
				and names.zaspberry and tags.sweetener and tags.dairy
		end,
		hunger = 37.5,
		health = 40,
		sanity = 15,
		priority = 30,
		weight = 1,
		cooktime = 1.8,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = 2 * TUNING.PERISH_TWO_DAY,
		floater = { nil, 0.1, 0.6 },
		oneat_desc = STRINGS.UI.COOKBOOK.UM_ZASPBERRYPARFAIT,
		oneatenfn = function(inst, eater)
			if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
				not (eater.components.health ~= nil and eater.components.health:IsDead()) and
				not eater:HasTag("playerghost") then
				eater.components.debuffable:AddDebuff("buff_electricretaliation", "buff_electricretaliation")
			end
		end,
		card_def = { ingredients = { { "zaspberry", 1 }, { "honey", 1 }, { "electricmilk", 1 } } },
	},
}

for k, v in pairs(um_preparedfoods) do
	v.name = k
	v.weight = v.weight or 1
	v.priority = v.priority or 0
	v.build = k
	v.bank = k
	v.atlasname = "images/inventoryimages/" .. k .. ".xml"
	v.cooktime = k.cooktime
	v.overridebuild = k
	--v.cookbook_tex = "cookbook_"..k..".tex"
	--v.cookbook_category = "cookpot"
end

return um_preparedfoods

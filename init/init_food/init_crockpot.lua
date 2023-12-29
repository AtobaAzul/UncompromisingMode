-----------------------------------------------------------------
-- Crockpot food changes
-- Relevant: cooking.lua, preparedfods.lua, foods (variable)
-----------------------------------------------------------------
local require = GLOBAL.require
local cooking = require "cooking"
local recipes = cooking.recipes.cookpot
local warly_recipes = cooking.recipes.portablecookpot


-----------------------------------------------------------------
-- Recipe attribute changes
-- Note: Cooktime is not seconds, but TUNING.BASE_COOK_TIME
--       TUNING.BASE_COOK_TIME = 1/3rd * nighttime (20 seconds)
--       and night time is seg_time * night_segs = 30 * 2 = 60s
-----------------------------------------------------------------
--recipes.bonestew.cooktime = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_STEW_COOKTIME / GLOBAL.TUNING.BASE_COOK_TIME


-----------------------------------------------------------------
-- Filler changes - Limit twigs and/or Ice to all recipes
-----------------------------------------------------------------
local TUNING = GLOBAL.TUNING
local RECIPE_ICE_LIMIT = GLOBAL.TUNING.DSTU.CROCKPOT_RECIPE_ICE_LIMIT
local RECIPE_TWIG_LIMIT = GLOBAL.TUNING.DSTU.CROCKPOT_RECIPE_TWIG_LIMIT
local RECIPE_ICE_PLUS_TWIG_LIMIT = GLOBAL.TUNING.DSTU.CROCKPOT_RECIPE_ICE_PLUS_TWIG_LIMIT

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

-------------------------------------------------------------------------------
-- Monster meat is a supporting meat and must be paired with normal meat
-- Relevant: AddIngredientValues
-------------------------------------------------------------------------------
--TODO: Fix smart crocpot mods from this, if possible (currently not showing predicted recipes correctly)
AddIngredientValues({ "butterflywings" }, { decoration = 2, insectoid = 0.5 })
AddIngredientValues({ "acorn" }, { seed = 1 })
--Substract the meat value from the monster value, since it dillutes it

local meat_reduction_factor = GLOBAL.TUNING.DSTU.MONSTER_MEAT_MEAT_REDUCTION_PER_MEAT;
local function MonsterMeatSupport(tags)
    return (
        (
        tags ~= nil and not tags.monster or tags.monster < 2 or
        (tags.meat and (tags.monster - tags.meat * meat_reduction_factor) < 2)) and TUNING.DSTU.CROCKPOTMONSTMEAT
        ) or TUNING.DSTU.CROCKPOTMONSTMEAT == false
end

if TUNING.DSTU.CROCKPOTMONSTMEAT then
    AddIngredientValues({ "monstermeat" },
        { meat = 1, monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE --[[ + meat_reduction_factor]] }, true
        , true)                                                                       --2.5 monster total, Will be calculated with -1 meat
    AddIngredientValues({ "monstermeat_cooked" }, {
        meat = 1,
        monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE
    }, true, true)                                                                    --2 monster total, Will be calculated with -1 meat
    AddIngredientValues({ "monstermeat_dried" },
    { meat = 1, monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_DRIED_MONSTER_VALUE }
    , true, true)                                                                     --1 monster total, Will be calculated with -1 meat
    AddIngredientValues({ "monstersmallmeat" }, {
        meat = 0.5,
        monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE
    }, true, true)                                                                    --2 monster total, Will be calculated with -1 meat

    RegisterInventoryItemAtlas("images/inventoryimages/monstersmallmeat.xml", "monstersmallmeat.tex")
    AddIngredientValues({ "cookedmonstersmallmeat" },
        { meat = 0.5, monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE }, true, true) --2.5 monster total, Will be calculated with -1 meat
    RegisterInventoryItemAtlas("images/inventoryimages/cookedmonstersmallmeat.xml", "cookedmonstersmallmeat.tex")
    AddIngredientValues({ "monstersmallmeat_dried" },
        { meat = 0.5, monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_DRIED_MONSTER_VALUE }, true, true) --2 monster total, Will be calculated with -1 meat
    RegisterInventoryItemAtlas("images/inventoryimages/monstersmallmeat_dried.xml", "monstersmallmeat_dried.tex")

    AddIngredientValues({ "um_monsteregg" }, { egg = 1, monster = GLOBAL.TUNING.DSTU.MONSTER_EGGS }, true)
    RegisterInventoryItemAtlas("images/inventoryimages/um_monsteregg.xml", "um_monsteregg.tex")
    AddIngredientValues({ "um_monsteregg_cooked" }, { egg = 1, monster = GLOBAL.TUNING.DSTU.MONSTER_EGGS }, true)
    RegisterInventoryItemAtlas("images/inventoryimages/um_monsteregg_cooked.xml", "um_monsteregg_cooked.tex")

    AddIngredientValues({ "scorpioncarapace" },
        { meat = 0.5, monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE, insectoid = 0.5 }, true, true)
    AddIngredientValues({ "scorpioncarapacecooked" },
        { meat = 0.5, monster = GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE, insectoid = 0.5 }, true, true)
else
    AddIngredientValues({ "monstersmallmeat" }, { meat = 0.5, monster = 1 }, true, true)       --2 monster total, Will be calculated with -1 meat
    AddIngredientValues({ "cookedmonstersmallmeat" }, { meat = 0.5, monster = 1 }, true, true) --2.5 monster total, Will be calculated with -1 meat
    AddIngredientValues({ "monstersmallmeat_dried" }, { meat = 0.5, monster = 1 }, true, true) --2 monster total, Will be calculated with -1 meat

    AddIngredientValues({ "um_monsteregg" }, { egg = 1, monster = GLOBAL.TUNING.DSTU.MONSTER_EGGS }, true)
    RegisterInventoryItemAtlas("images/inventoryimages/um_monsteregg.xml", "um_monsteregg.tex")
    AddIngredientValues({ "um_monsteregg_cooked" }, { egg = 1, monster = GLOBAL.TUNING.DSTU.MONSTER_EGGS }, true)
    RegisterInventoryItemAtlas("images/inventoryimages/um_monsteregg_cooked.xml", "um_monsteregg_cooked.tex")

    AddIngredientValues({ "scorpioncarapace" }, { meat = 0.5, monster = 1, insectoid = 0.5 }, true, true)
    RegisterInventoryItemAtlas("images/inventoryimages/scorpioncarapace.xml", "scorpioncarapace.tex")
    AddIngredientValues({ "scorpioncarapacecooked" }, { meat = 0.5, monster = 1, insectoid = 0.5 }, true, true)
    RegisterInventoryItemAtlas("images/inventoryimages/scorpioncarapacecooked.xml", "scorpioncarapacecooked.tex")
end

AddIngredientValues({ "forgetmelots" }, { decoration = 1, foliage = 1 })
AddIngredientValues({ "aphid" }, { insectoid = 0.5, meat = 0.5, monster = 0.5 })
AddIngredientValues({ "rabbit" }, { meat = 0.5 })

recipes.koalefig_trunk.test = function(cooker, names, tags)
    return (names.trunk_summer or names.trunk_cooked or names.trunk_winter) and (names.fig or names.fig_cooked or names.aphid) and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.trunk_summer or names.trunk_cooked or names.trunk_winter) and (names.fig or names.fig_cooked) end,

recipes.figkabab.test = function(cooker, names, tags)
	return (names.fig or names.fig_cooked or names.aphid) and names.twigs and tags.meat and tags.meat >= 1 and
		(not tags.monster or tags.monster <= 1) and not tags.frozen and not tags.foliage and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.fig or names.fig_cooked) and names.twigs and tags.meat and tags.meat >= 1 and (not tags.monster or tags.monster <= 1) end,

recipes.figatoni.test = function(cooker, names, tags)
    return ((names.fig or names.fig_cooked) and
        tags.veggie and tags.veggie >= 2 and not tags.meat)
        or ((names.aphid) and tags.veggie and tags.veggie >= 2 and tags.meat and tags.meat <= 0.5 and not (tags.insectoid and tags.insectoid >= 1))
end
-- Original:	test = function(cooker, names, tags) return (names.fig or names.fig_cooked) and tags.veggie and tags.veggie >= 2  and not tags.meat end,

recipes.frognewton.test = function(cooker, names, tags)
    return (names.fig or names.fig_cooked or names.aphid) and (names.froglegs or names.froglegs_cooked) and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.fig or names.fig_cooked) and (names.froglegs or names.froglegs_cooked) end,

recipes.frognewton.priority = 20

--teehee :)

-----------------------------------------------------------------
-- Recipe changes (mostly added above filler changes)
-- But made to be easily customised below for future changes
-----------------------------------------------------------------

if TUNING.DSTU.CROCKPOTMONSTMEAT then
    recipes.monsterlasagna.test = function(cooker, names, tags)
        return tags.monster and (tags.meat and tags.monster > tags.meat or tags.monster >= 3) and 
				not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT)
    end
	-- Original:           test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and not tags.inedible end,
	recipes.monsterlasagna.priority = 51
end

-- Meats

recipes.lobsterbisque.test = function(cooker, names, tags)
    return names.wobster_sheller_land and tags.frozen and
        UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return names.wobster_sheller_land and tags.frozen end,

recipes.lobsterdinner.test = function(cooker, names, tags)
    return names.wobster_sheller_land and names.butter and (tags.meat == 1.0) and (tags.fish == 1.0) and 
		not tags.frozen and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test =  function(cooker, names, tags) return names.wobster_sheller_land and names.butter and (tags.meat == 1.0) and (tags.fish == 1.0) and not tags.frozen end

recipes.barnaclepita.test = function(cooker, names, tags)
    return (names.barnacle or names.barnacle_cooked) and tags.veggie and tags.veggie >= 0.5 and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and tags.veggie and tags.veggie >= 0.5 end

recipes.leafloaf.test = function(cooker, names, tags)
    return ((names.plantmeat or 0) + (names.plantmeat_cooked or 0) >= 2) and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return ((names.plantmeat or 0) + (names.plantmeat_cooked or 0) >= 2 ) end

recipes.barnaclestuffedfishhead.test = function(cooker, names, tags)
    return (names.barnacle or names.barnacle_cooked) and tags.fish and tags.fish >= 1.25 and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and tags.fish and tags.fish >= 1.25 end,

recipes.pepperpopper.test = function(cooker, names, tags)
    return (names.pepper or names.pepper_cooked) and tags.meat and tags.meat <= 1.5 and 
		not tags.inedible and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.pepper or names.pepper_cooked) and tags.meat and tags.meat <= 1.5 and not tags.inedible end,

recipes.unagi.test = function(cooker, names, tags)
	return (names.cutlichen or names.kelp or names.kelp_cooked or names.kelp_dried) and (names.eel or names.eel_cooked or names.pondeel) and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.cutlichen or names.kelp or names.kelp_cooked or names.kelp_dried) and (names.eel or names.eel_cooked or names.pondeel) end,

recipes.unagi.priority = 52

recipes.ceviche.test = function(cooker, names, tags)
	return tags.fish and tags.fish >= 2 and tags.frozen and
		not tags.inedible and not tags.egg and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.frozen and not tags.inedible and not tags.egg end,

recipes.guacamole.test = function(cooker, names, tags)
    return names.mole and (names.rock_avocado_fruit_ripe or names.cactus_meat) and 
		not tags.fruit and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return names.mole and (names.rock_avocado_fruit_ripe or names.cactus_meat) and not tags.fruit end,

recipes.fishtacos.test = function(cooker, names, tags)
    return tags.fish and (names.corn or names.corn_cooked) and
        UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.fish and (names.corn or names.corn_cooked) end,

recipes.fishsticks.test = function(cooker, names, tags)
    return tags.fish and names.twigs and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1) and not tags.monster
end
-- Original:	test = function(cooker, names, tags) return tags.fish and names.twigs and (tags.inedible and tags.inedible <= 1) end,

recipes.perogies.test = function(cooker, names, tags)
    return tags.egg and tags.meat and (tags.veggie and tags.veggie >= TUNING.DSTU.PIEROGI) and
		not tags.inedible and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.egg and tags.meat and tags.veggie and not tags.inedible end,

recipes.kabobs.test = function(cooker, names, tags)
    return tags.meat and names.twigs and 
		(not tags.monster or tags.monster <= 3.5) and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.meat and names.twigs and (not tags.monster or tags.monster <= 1) and (tags.inedible and tags.inedible <= 1) end,

recipes.honeynuggets.test = function(cooker, names, tags)
    return names.honey and tags.meat and tags.meat <= 1.5 and
        not tags.inedible and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat <= 1.5 and not tags.inedible end,

recipes.frogglebunwich.test = function(cooker, names, tags)
    return (names.froglegs or names.froglegs_cooked) and tags.veggie and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.froglegs or names.froglegs_cooked) and tags.veggie end,

recipes.frogglebunwich.priority = 6 --Kabobs is 5... putting this just above kabobs

recipes.meatballs.test = function(cooker, names, tags)
    return tags.meat and
		not tags.inedible and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.meat and not tags.inedible end,

recipes.bunnystew.test = function(cooker, names, tags)
    return (names.rabbit) and (tags.frozen and tags.frozen == 2) and 
		(not tags.inedible) and (not tags.foliage)
end
-- Original: test = function(cooker, names, tags) return (tags.meat and tags.meat < 1) and (tags.frozen and tags.frozen >= 2) and (not tags.inedible) end

-- Veggies and Fruits

recipes.salsa.test = function(cooker, names, tags)
    return (names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) and
		not tags.meat and not tags.inedible and not tags.egg and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) and not tags.meat and not tags.inedible and not tags.egg end,

recipes.bananapop.test = function(cooker, names, tags)
	return (names.cave_banana or names.cave_banana_cooked) and tags.frozen and names.twigs and
		not tags.meat and not tags.fish and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and LimitTwigTestFn(tags, RECIPE_TWIG_LIMIT)
end
-- Original:	test = function(cooker, names, tags) return (names.cave_banana or names.cave_banana_cooked) and tags.frozen and names.twigs and not tags.meat and not tags.fish end,

recipes.watermelonicle.test = function(cooker, names, tags)
	return names.watermelon and tags.frozen and names.twigs and
		not tags.meat and not tags.veggie and not tags.egg and not tags.foliage
end
-- Original:	test = function(cooker, names, tags) return names.watermelon and tags.frozen and names.twigs and not tags.meat and not tags.veggie and not tags.egg end,

recipes.icecream.test = function(cooker, names, tags)
	return tags.frozen and tags.dairy and tags.sweetener and
		not tags.meat and not tags.veggie and not tags.inedible and not tags.egg and UncompromisingFillers(tags) 
end
-- Original:	test = function(cooker, names, tags) return tags.frozen and tags.dairy and tags.sweetener and not tags.meat and not tags.veggie and not tags.inedible and not tags.egg end,

recipes.potatotornado.test = function(cooker, names, tags)
	return (names.potato or names.potato_cooked) and names.twigs and names.twigs <=2 and
		(not tags.monster or tags.monster <= 1) and not tags.meat and not (tags.insectoid and tags.insectoid >= 1) and not tags.frozen and not tags.foliage
end
-- Original:	test = function(cooker, names, tags) return (names.potato or names.potato_cooked) and names.twigs and (not tags.monster or tags.monster <= 1) and not tags.meat and (tags.inedible and tags.inedible <= 2) end,

recipes.powcake.test = function(cooker, names, tags)
    return names.twigs and names.honey and (names.corn or names.corn_cooked) and
		not tags.frozen and not tags.foliage
end
-- Original:	test = function(cooker, names, tags) return names.twigs and names.honey and (names.corn or names.corn_cooked) end,

recipes.mandrakesoup.test = function(cooker, names, tags) 
	return names.mandrake and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1) 
end
-- Original:	test = function(cooker, names, tags) return names.mandrake end,

recipes.dragonpie.test = function(cooker, names, tags)
    return (names.dragonfruit or names.dragonfruit_cooked) and
        not tags.meat and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and not tags.meat end,

recipes.butterflymuffin.test = function(cooker, names, tags)
    return (names.butterflywings or names.moonbutterflywings)
        and not tags.meat and tags.veggie and UncompromisingFillers(tags)
end
-- Original:	test = function(cooker, names, tags) return (names.butterflywings or names.moonbutterflywings) and not tags.meat and tags.veggie end,

recipes.stuffedeggplant.test = function(cooker, names, tags)
    return (names.eggplant or names.eggplant_cooked) and
        tags.veggie and tags.veggie > 1 and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.eggplant or names.eggplant_cooked) and tags.veggie and tags.veggie > 1 end,

recipes.ratatouille.test = function(cooker, names, tags)
    return not tags.meat and tags.veggie and not tags.inedible and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1) 
end
-- Original:	test = function(cooker, names, tags) return not tags.meat and tags.veggie and not tags.inedible end,

recipes.jammypreserves.test = function(cooker, names, tags)
    return tags.fruit and not tags.meat and not tags.veggie and not tags.inedible and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.fruit and not tags.meat and not tags.veggie and not tags.inedible end,

recipes.frozenbananadaiquiri.test = function(cooker, names, tags)
	return (names.cave_banana or names.cave_banana_cooked) and (tags.frozen and tags.frozen >= 1) and
		not tags.meat and not tags.fish and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end		
-- Original:	test = function(cooker, names, tags) return (names.cave_banana or names.cave_banana_cooked) and (tags.frozen and tags.frozen >= 1) and not tags.meat and not tags.fish end,

recipes.bananajuice.test = function(cooker, names, tags)
	return ((names.cave_banana or 0) + (names.cave_banana_cooked or 0) >= 2) and
		not tags.meat and not tags.fish and not tags.monster and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return ((names.cave_banana or 0) + (names.cave_banana_cooked or 0) >= 2) and not tags.meat and not tags.fish and not tags.monster end,

-- Others

recipes.jellybean.test = function(cooker, names, tags)
    return names.royal_jelly and not tags.inedible and not tags.monster and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return names.royal_jelly and not tags.inedible and not tags.monster end,

recipes.taffy.test = function(cooker, names, tags)
    return tags.sweetener and tags.sweetener >= 3 and
		not tags.meat and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.sweetener and tags.sweetener >= 3 and not tags.meat end,

recipes.sweettea.test = function(cooker, names, tags)
	return names.forgetmelots and tags.foliage and tags.foliage <= 1 and tags.sweetener and tags.frozen and tags.frozen <= 1 and
		not tags.monster and not tags.veggie and not tags.meat and not tags.fish and not tags.egg and not tags.fat and not tags.dairy and not tags.inedible
end
-- Original:		test = function(cooker, names, tags) return names.forgetmelots and tags.sweetener and tags.frozen and not tags.monster and not tags.veggie and not tags.meat and not tags.fish and not tags.egg and not tags.fat and not tags.dairy and not tags.inedible end,

recipes.justeggs.test = function(cooker, names, tags)
	return tags.egg and tags.egg >= 3 and
		UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.egg and tags.egg >= 3 end,

recipes.talleggs.test = function(cooker, names, tags)
    return names.tallbirdegg and tags.veggie and tags.veggie >= 3
end
-- Original:	test = function(cooker, names, tags) return names.tallbirdegg and tags.veggie and tags.veggie >= 1 end,

recipes.veggieomlet.test = function(cooker, names, tags)
	return tags.egg and tags.egg >= 1 and tags.veggie and tags.veggie >= 1 and
		not tags.meat and not tags.dairy and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end		
-- Original:	test = function(cooker, names, tags) return tags.egg and tags.egg >= 1 and tags.veggie and tags.veggie >= 1 and not tags.meat and not tags.dairy end,

-- WARLY recipes

warly_recipes.dragonchilisalad.test = function(cooker, names, tags)
    return (
        names.dragonfruit or names.dragonfruit_cooked) and (names.pepper or names.pepper_cooked) and not tags.meat and
        not tags.inedible and not tags.egg and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and (names.pepper or names.pepper_cooked) and not tags.meat and not tags.inedible and not tags.egg end,

warly_recipes.bonesoup.test = function(cooker, names, tags)
    return names.boneshard and names.boneshard == 2 and
        (names.onion or names.onion_cooked) and (tags.inedible and tags.inedible < 3) and (not tags.frozen) and (not tags.foliage)
end
-- Original:	test = function(cooker, names, tags) return names.boneshard and names.boneshard == 2 and (names.onion or names.onion_cooked) and (tags.inedible and tags.inedible < 3) end,

warly_recipes.monstertartare.test = function(cooker, names, tags)
    return tags.monster and tags.monster >= 4 and
        not tags.inedible and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and not tags.inedible end,

warly_recipes.monstertartare.priority = 52

warly_recipes.voltgoatjelly.test = function(cooker, names, tags)
    return (names.lightninggoathorn) and
        (tags.sweetener and tags.sweetener >= 2) and not tags.meat and UncompromisingFillers(tags)
end
-- Original:	test = function(cooker, names, tags) return (names.lightninggoathorn) and (tags.sweetener and tags.sweetener >= 2) and not tags.meat end,

warly_recipes.glowberrymousse.test = function(cooker, names, tags)
    return (
        names.wormlight or (names.wormlight_lesser and names.wormlight_lesser >= 2)) and (tags.fruit and tags.fruit >= 2) and
        not tags.meat and not tags.inedible and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
end
-- Original:	test = function(cooker, names, tags) return (names.wormlight or (names.wormlight_lesser and names.wormlight_lesser >= 2)) and (tags.fruit and tags.fruit >= 2) and not tags.meat and not tags.inedible end,

--warly_recipes.zaspberryparfait.test = function(cooker, names, tags) return not tags.monster and not tags.inedible and UncompromisingFillers(tags) and names.zaspberry and tags.dairy and tags.sweetener end

local ingredients = cooking.ingredients
--[[InsertIngredientValues function by Serpens https://forums.kleientertainment.com/forums/topic/69732-dont-use-addingredientvalues-in-mods/]]
--NOTE: If the thing already had a tag with the same name, you will still overwrite the old value, unless keepoldvalues is true. E.g if fish already had a tag seafood with value 0.5 and now you use this function with value 1, the result will be 1.
function InsertIngredientValues(names, tags, cancook, candry, keepoldvalues) -- if cancook or candry is true, the cooked/dried variant of the thing will also get the tags and the tags precook/dried.
    for _, name in pairs(names) do
        if ingredients[name] == nil then                                     -- if it is not cookable already, it will be nil. Following code is just a copy of the normal AddIngredientValues function
            ingredients[name] = { tags = {} }

            if cancook then
                ingredients[name .. "_cooked"] = { tags = {} }
            end

            if candry then
                ingredients[name .. "_dried"] = { tags = {} }
            end

            for tagname, tagval in pairs(tags) do
                ingredients[name].tags[tagname] = tagval

                if cancook then
                    ingredients[name .. "_cooked"].tags.precook = 1
                    ingredients[name .. "_cooked"].tags[tagname] = tagval
                end
                if candry then
                    ingredients[name .. "_dried"].tags.dried = 1
                    ingredients[name .. "_dried"].tags[tagname] = tagval
                end
            end
        else                                                                        -- but if there are already some tags, don't delete previous tags, just add the new ones.
            for tagname, tagval in pairs(tags) do
                if ingredients[name].tags[tagname] == nil or not keepoldvalues then -- only overwrite old value, if there is no old value, or if keepoldvalues is not true (will be not true by default)
                    ingredients[name].tags[tagname] = tagval                        -- this will overwrite the old value, if there was one
                end

                if cancook then
                    if ingredients[name .. "_cooked"] == nil then
                        ingredients[name .. "_cooked"] = { tags = {} }
                    end
                    if ingredients[name .. "_cooked"].tags.precook == nil or not keepoldvalues then
                        ingredients[name .. "_cooked"].tags.precook = 1
                    end
                    if ingredients[name .. "_cooked"].tags[tagname] == nil or not keepoldvalues then
                        ingredients[name .. "_cooked"].tags[tagname] = tagval
                    end
                end
                if candry then
                    if ingredients[name .. "_dried"] == nil then
                        ingredients[name .. "_dried"] = { tags = {} }
                    end
                    if ingredients[name .. "_dried"].tags.dried == nil or not keepoldvalues then
                        ingredients[name .. "_dried"].tags.dried = 1
                    end
                    if ingredients[name .. "_dried"].tags[tagname] == nil or not keepoldvalues then
                        ingredients[name .. "_dried"].tags[tagname] = tagval
                    end
                end
            end
        end
    end
end

InsertIngredientValues({ "zaspberry" }, { fruit = 1 }, true, false, false)
RegisterInventoryItemAtlas("images/inventoryimages/zaspberry.xml", "zaspberry.tex")
InsertIngredientValues({ "viperfruit" }, { fruit = 1 }, true, false, false)
RegisterInventoryItemAtlas("images/inventoryimages/viperfruit.xml", "viperfruit.tex")
InsertIngredientValues({ "giant_blueberry" }, { fruit = 1 }, true, false, false)
RegisterInventoryItemAtlas("images/inventoryimages/giant_blueberry.xml", "giant_blueberry.tex")
InsertIngredientValues({ "iceboomerang" }, { ice = 1 }, true, false, false)
RegisterInventoryItemAtlas("images/inventoryimages/iceboomerang.xml", "iceboomerang.tex")
InsertIngredientValues({ "rice" }, { veggie = 1, rice = 1 }, true, false, false)
RegisterInventoryItemAtlas("images/inventoryimages/rice.xml", "rice.tex")
InsertIngredientValues({ "rice_cooked" }, { veggie = 1 }, true, false, false)
RegisterInventoryItemAtlas("images/inventoryimages/rice_cooked.xml", "rice_cooked.tex")
if TUNING.DSTU.NEWRECIPES then
	InsertIngredientValues({ "firenettles" }, { foliage = 1 }, true, false, false)
    InsertIngredientValues({ "foliage" }, { foliage = 1 }, true, false, false)
    InsertIngredientValues({ "greenfoliage" }, { foliage = 1 }, true, false, false)
end
RegisterInventoryItemAtlas("images/inventoryimages/greenfoliage.xml", "greenfoliage.tex")
InsertIngredientValues({ "horn" }, { meat = 1 }, true, false, false)
InsertIngredientValues({ "trunk_summer" }, { meat = 2 }, true, false, false)
InsertIngredientValues({ "trunk_winter" }, { meat = 2 }, true, false, false)
InsertIngredientValues({ "trunk_cooked" }, { meat = 2 }, true, false, false)

InsertIngredientValues({ "fishmeat_dried" }, { meat = 1, fish = 1 }, true)
RegisterInventoryItemAtlas("images/inventoryimages/fishmeat_dried.xml", "fishmeat_dried.tex")
InsertIngredientValues({ "smallfishmeat_dried" }, { meat = .5, fish = .5 }, true)
RegisterInventoryItemAtlas("images/inventoryimages/smallfishmeat_dried.xml", "smallfishmeat_dried.tex")

if TUNING.DSTU.NEWRECIPES then
	local cookpots = {
		"cookpot", 
		"portablecookpot", 
		"archive_cookpot"
	}
		
	local spicers = {
		"portablespicer"
	}

	local um_preparedfoods = require("um_preparedfoods")
	local um_spicedfoods = require("um_spicedfoods")
	local recipe_cards = require("cooking").recipe_cards

	for i, v in pairs(cookpots) do
		for n, b in pairs(um_preparedfoods) do 
			if TUNING.DSTU.NEWRECIPES then
				AddCookerRecipe(v, b) 
		
				if b.card_def then 
					table.insert(recipe_cards, {recipe_name = b.name, cooker_name = "cookpot"}) 
				end 
			end
				
			RegisterInventoryItemAtlas(b.atlasname, b.name..".tex")
		end
	end

	for i, v in pairs(spicers) do
		for n, b in pairs(um_spicedfoods) do 
			AddCookerRecipe(v, b) 
		end
	end
end
	
--sailing rebalance related food changes.

if GetModConfigData("sr_foodrebalance") then
	recipes.barnaclesushi.test = function(cooker, names, tags)
		return (names.barnacle or names.barnacle_cooked) and (names.kelp or names.kelp_cooked) and
			UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1)
	end
	-- Original:	test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and (names.kelp or names.kelp_cooked) and tags.egg and tags.egg >= 1
    recipes.surfnturf.test = function(cooker, names, tags)
        return tags.meat and tags.meat >= 2.5 and tags.fish and tags.fish >= 2.0 and not tags.frozen
    end
	-- Original:	test = function(cooker, names, tags) return tags.meat and tags.meat >= 2.5 and tags.fish and tags.fish >= 1.5 and not tags.frozen end,
    recipes.seafoodgumbo.test = function(cooker, names, tags)
		return tags.fish and tags.fish >= 3 and tags.meat >= 3
	end
	-- Original:	test = function(cooker, names, tags) return tags.fish and tags.fish > 2 end,
    recipes.seafoodgumbo.priority = 31
end


AddPrefabPostInitAny(function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    if inst:HasTag("preparedfood") and inst.components ~= nil and inst.components.edible ~= nil then
        inst.components.edible.temperaturedelta = inst.components.edible.temperaturedelta*2--i stg if some mod sets these to nil
        inst.components.edible.temperatureduration = inst.components.edible.temperatureduration*2
    end
end)

if TUNING.DSTU.GOODIESNERF then
AddPrefabPostInit("shroomcake", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("shroomcake_spice_salt", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("shroomcake_spice_chili", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("shroomcake_spice_sugar", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("shroomcake_spice_garlic", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("icecream", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("icecream_spice_chili", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("icecream_spice_salt", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("icecream_spice_sugar", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("icecream_spice_garlic", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("taffy", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("taffy_spice_chili", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("taffy_spice_salt", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("taffy_spice_sugar", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("taffy_spice_garlic", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.GENERIC
end)

AddPrefabPostInit("frozenbananadaiquiri", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("frozenbananadaiquiri_spice_chili", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("frozenbananadaiquiri_spice_salt", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("frozenbananadaiquiri_spice_sugar", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)

AddPrefabPostInit("frozenbananadaiquiri_spice_garlic", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
end)
end

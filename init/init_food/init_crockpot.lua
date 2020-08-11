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
recipes.perogies.perishtime = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_PEROGI_PERISH -- Changed to 10 days, down from 20
recipes.baconeggs.perishtime = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BACONEGG_PERISH
recipes.baconeggs.priority = 9 --No more casino 50/50 baconeggs / monsterlasagna

-----------------------------------------------------------------
-- Filler changes - Limit twigs and/or Ice to all recipes
-----------------------------------------------------------------

local RECIPE_ICE_LIMIT = GLOBAL.TUNING.DSTU.CROCKPOT_RECIPE_ICE_LIMIT
local RECIPE_TWIG_LIMIT = GLOBAL.TUNING.DSTU.CROCKPOT_RECIPE_TWIG_LIMIT
local RECIPE_ICE_PLUS_TWIG_LIMIT = GLOBAL.TUNING.DSTU.CROCKPOT_RECIPE_ICE_PLUS_TWIG_LIMIT

local function LimitIceTestFn(tags, ice_limit)
    if tags~=nil and tags.frozen ~= nil then
        return not tags.frozen or (tags.frozen <= ice_limit)
    end
    return true
end

local function LimitTwigTestFn(tags, twig_limit)
    if tags~=nil and tags.inedible ~= nil then 
        return not tags.inedible or (tags.inedible <= twig_limit)
    end
    return true
end

local function LimitIcePlusTwigTestFn(tags, ice_plus_twig_limit)
    if tags~=nil and tags.frozen ~= nil and tags.inedible ~= nil then
        return (tags.frozen + tags.inedible) <= ice_plus_twig_limit
    end
    return true
end

local function UncompromisingFillerCustomTestFn(tags, ice_limit, twig_limit, ice_plus_twig_limit)
    return LimitIceTestFn(tags,ice_limit) and LimitTwigTestFn(tags,twig_limit) and LimitIcePlusTwigTestFn(tags,ice_plus_twig_limit)
end

local function UncompromisingFillers(tags)
    return UncompromisingFillerCustomTestFn(tags, RECIPE_ICE_LIMIT, RECIPE_TWIG_LIMIT, RECIPE_ICE_PLUS_TWIG_LIMIT)
end


-------------------------------------------------------------------------------
-- Monster meat is a supporting meat and must be paired with normal meat
-- Relevant: AddIngredientValues
-------------------------------------------------------------------------------
--TODO: Fix smart crocpot mods from this, if possible (currently not showing predicted recipes correctly)
local meat_reduction_factor = GLOBAL.TUNING.DSTU.MONSTER_MEAT_MEAT_REDUCTION_PER_MEAT;
AddIngredientValues({"monstermeat"}, {meat=1, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_RAW_MONSTER_VALUE + meat_reduction_factor}, true, true) --2.5 monster total, Will be calculated with -1 meat
AddIngredientValues({"monstermeat_cooked"}, {meat=1, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE + meat_reduction_factor}, true, true) --2 monster total, Will be calculated with -1 meat
AddIngredientValues({"monstermeat_dried"}, {meat=1, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_DRIED_MONSTER_VALUE + meat_reduction_factor}, true, true) --1 monster total, Will be calculated with -1 meat
AddIngredientValues({"monstersmallmeat"}, {meat=0.5, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_RAW_MONSTER_VALUE + meat_reduction_factor}, true, true) --2 monster total, Will be calculated with -1 meat
AddIngredientValues({"cookedmonstersmallmeat"}, {meat=0.5, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE + meat_reduction_factor}, true, true) --2.5 monster total, Will be calculated with -1 meat
AddIngredientValues({"monstersmallmeat_dried"}, {meat=0.5, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_DRIED_MONSTER_VALUE + meat_reduction_factor}, true, true) --2 monster total, Will be calculated with -1 meat
AddIngredientValues({"scorpioncarapace"}, {meat=1, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_RAW_MONSTER_VALUE + meat_reduction_factor, insectoid=0.5}, true, true)
AddIngredientValues({"scorpioncarapacecooked"}, {meat=1, meat=1, monster=GLOBAL.TUNING.DSTU.MONSTER_MEAT_COOKED_MONSTER_VALUE + meat_reduction_factor, insectoid=0.5}, true, true)
AddIngredientValues({"butterflywings"}, {decoration=2, insectoid=0.5})

--Substract the meat value from the monster value, since it dillutes it
local function MonsterMeatSupport(tags)
    return tags~=nil and not tags.monster or tags.monster < 2 or (tags.meat and (tags.monster - tags.meat*meat_reduction_factor) < 2)
end

local function MonsterMeat(tags)
    return tags~=nil and tags.monster and tags.monster >=2 and (tags.meat and (tags.monster - tags.meat*meat_reduction_factor) >= 2)
end

--not tags.inedible and not (tags.insectoid and tags.insectoid >= 1)

-----------------------------------------------------------------
-- Recipe changes (mostly added above filler changes)
-- But made to be easily customised below for future changes
-----------------------------------------------------------------

recipes.monsterlasagna.test = function(cooker, names, tags) return not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeat(tags) end 
-- Original:           test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and not tags.inedible end,    

recipes.butterflymuffin.test = function(cooker, names, tags) return (names.butterflywings or names.moonbutterflywings) and not tags.meat and tags.veggie and UncompromisingFillers(tags) end 
-- Original: 		    test = function(cooker, names, tags) return (names.butterflywings or names.moonbutterflywings) and not tags.meat and tags.veggie end,

recipes.frogglebunwich.test = function(cooker, names, tags) return (names.froglegs or names.froglegs_cooked) and tags.veggie and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end
-- Original:           test = function(cooker, names, tags) return (names.froglegs or names.froglegs_cooked) and tags.veggie end,

recipes.taffy.test = function(cooker, names, tags) return tags.sweetener and tags.sweetener >= 3 and not tags.meat and UncompromisingFillers(tags) end
-- Original:  test = function(cooker, names, tags) return tags.sweetener and tags.sweetener >= 3 and not tags.meat end,

recipes.pumpkincookie.test = function(cooker, names, tags) return (names.pumpkin or names.pumpkin_cooked) and tags.sweetener and tags.sweetener >= 2 and UncompromisingFillers(tags) end
-- Original:          test = function(cooker, names, tags) return (names.pumpkin or names.pumpkin_cooked) and tags.sweetener and tags.sweetener >= 2 end,

recipes.stuffedeggplant.test = function(cooker, names, tags) return (names.eggplant or names.eggplant_cooked) and tags.veggie and tags.veggie > 1 and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:            test = function(cooker, names, tags) return (names.eggplant or names.eggplant_cooked) and tags.veggie and tags.veggie > 1 end,

recipes.fishsticks.test = function(cooker, names, tags) return tags.fish and names.twigs and (tags.inedible and tags.inedible <= 1) and UncompromisingFillers(tags) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end 
-- Original:       test = function(cooker, names, tags) return tags.fish and names.twigs and (tags.inedible and tags.inedible <= 1) end,

recipes.honeynuggets.test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat <= 1.5 and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end 
-- Original:         test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat <= 1.5 and not tags.inedible end,

recipes.honeyham.test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat > 1.5 and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end 
-- Original:     test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat > 1.5 and not tags.inedible end,

recipes.dragonpie.test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and not tags.meat and UncompromisingFillers(tags) end 
-- Original:      test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and not tags.meat end,

recipes.kabobs.test = function(cooker, names, tags) return tags.meat and names.twigs and (tags.inedible and tags.inedible <= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end 
-- Original:   test = function(cooker, names, tags) return tags.meat and names.twigs and (not tags.monster or tags.monster <= 1) and (tags.inedible and tags.inedible <= 1) end,

recipes.mandrakesoup.test = function(cooker, names, tags) return names.mandrake and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:         test = function(cooker, names, tags) return names.mandrake end,

recipes.baconeggs.test = function(cooker, names, tags) return tags.egg and tags.egg > 1 and tags.meat and tags.meat > 1 and not tags.veggie and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:      test = function(cooker, names, tags) return tags.egg and tags.egg > 1 and tags.meat and tags.meat > 1 and not tags.veggie end,

recipes.meatballs.test = function(cooker, names, tags) return tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end 
-- Original:      test = function(cooker, names, tags) return tags.meat and not tags.inedible end,

recipes.bonestew.test = function(cooker, names, tags) return tags.meat and tags.meat >= 3 and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end 
-- Original:     test = function(cooker, names, tags) return tags.meat and tags.meat >= 3 and not tags.inedible end,

recipes.perogies.test = function(cooker, names, tags) return tags.egg and tags.meat and tags.veggie and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end 
-- Original:     test = function(cooker, names, tags) return tags.egg and tags.meat and tags.veggie and not tags.inedible end,

recipes.turkeydinner.test = function(cooker, names, tags) return names.drumstick and names.drumstick > 1 and tags.meat and tags.meat > 1 and (tags.veggie or tags.fruit) and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:         test = function(cooker, names, tags) return names.drumstick and names.drumstick > 1 and tags.meat and tags.meat > 1 and (tags.veggie or tags.fruit) end,

recipes.ratatouille.test = function(cooker, names, tags) return not tags.meat and tags.veggie and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:        test = function(cooker, names, tags) return not tags.meat and tags.veggie and not tags.inedible end,

recipes.jammypreserves.test = function(cooker, names, tags) return tags.fruit and not tags.meat and not tags.veggie and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end
-- Original:           test = function(cooker, names, tags) return tags.fruit and not tags.meat and not tags.veggie and not tags.inedible end,

recipes.fruitmedley.test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 3 and not tags.meat and not tags.veggie and UncompromisingFillers(tags) end 
-- Original:        test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 3 and not tags.meat and not tags.veggie end,

recipes.fishtacos.test = function(cooker, names, tags) return tags.fish and (names.corn or names.corn_cooked) and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:      test = function(cooker, names, tags) return tags.fish and (names.corn or names.corn_cooked) end,

recipes.waffles.test = function(cooker, names, tags) return names.butter and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.egg and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:    test = function(cooker, names, tags) return names.butter and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.egg end,

recipes.powcake.test = function(cooker, names, tags) return names.twigs and names.honey and (names.corn or names.corn_cooked) and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:    test = function(cooker, names, tags) return names.twigs and names.honey and (names.corn or names.corn_cooked) end,

--recipes.unagi.test = function(cooker, names, tags) return names.cutlichen and (names.eel or names.eel_cooked) and UncompromisingFillers(tags and MonsterMeatSupport(tags)) end 
-- Original:  test = function(cooker, names, tags) return names.cutlichen and (names.eel or names.eel_cooked) end,

--recipes.wetgoop.test = function(cooker, names, tags) return true end 
-- Original:    test = function(cooker, names, tags) return true end,

recipes.flowersalad.test = function(cooker, names, tags) return names.cactus_flower and tags.veggie and tags.veggie >= 2 and not tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and not tags.egg and not tags.sweetener and not tags.fruit and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:        test = function(cooker, names, tags) return names.cactus_flower and tags.veggie and tags.veggie >= 2 and not tags.meat and not tags.inedible and not tags.egg and not tags.sweetener and not tags.fruit end,

--recipes.icecream.test = function(cooker, names, tags) return tags.frozen and tags.dairy and tags.sweetener and not tags.meat and not tags.veggie and not tags.inedible and not tags.egg and UncompromisingFillers(tags) end 
-- Original:     test = function(cooker, names, tags) return tags.frozen and tags.dairy and tags.sweetener and not tags.meat and not tags.veggie and not tags.inedible and not tags.egg end,

--recipes.watermelonicle.test = function(cooker, names, tags) return names.watermelon and tags.frozen and names.twigs and not tags.meat and not tags.veggie and not tags.egg and UncompromisingFillers(tags) end 
-- Original:           test = function(cooker, names, tags) return names.watermelon and tags.frozen and names.twigs and not tags.meat and not tags.veggie and not tags.egg end,

recipes.trailmix.test = function(cooker, names, tags) return names.acorn_cooked and tags.seed and tags.seed >= 1 and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.fruit and tags.fruit >= 1 and not tags.meat and not tags.veggie and not tags.egg and not tags.dairy and UncompromisingFillers(tags) end 
-- Original:     test = function(cooker, names, tags) return names.acorn_cooked and tags.seed and tags.seed >= 1 and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.fruit and tags.fruit >= 1 and not tags.meat and not tags.veggie and not tags.egg and not tags.dairy end,

recipes.hotchili.test = function(cooker, names, tags) return tags.meat and tags.veggie and tags.meat >= 1.5 and tags.veggie >= 1.5 and UncompromisingFillers(tags) and MonsterMeatSupport(tags)end 
-- Original:     test = function(cooker, names, tags) return tags.meat and tags.veggie and tags.meat >= 1.5 and tags.veggie >= 1.5 end,

recipes.guacamole.test = function(cooker, names, tags) return names.mole and (names.rock_avocado_fruit_ripe or names.cactus_meat) and not tags.fruit and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end 
-- Original:      test = function(cooker, names, tags) return names.mole and (names.rock_avocado_fruit_ripe or names.cactus_meat) and not tags.fruit end,

recipes.jellybean.test = function(cooker, names, tags) return names.royal_jelly and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and not tags.monster and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:      test = function(cooker, names, tags) return names.royal_jelly and not tags.inedible and not tags.monster end,

recipes.potatotornado.test = function(cooker, names, tags) return (names.potato or names.potato_cooked) and names.twigs and (not tags.monster or tags.monster <= 1) and not tags.meat and (tags.inedible and tags.inedible <= 2) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:          test = function(cooker, names, tags) return (names.potato or names.potato_cooked) and names.twigs and (not tags.monster or tags.monster <= 1) and not tags.meat and (tags.inedible and tags.inedible <= 2) end,

recipes.mashedpotatoes.test = function(cooker, names, tags) return ((names.potato and names.potato > 1) or (names.potato_cooked and names.potato_cooked > 1) or (names.potato and names.potato_cooked)) and (names.garlic or names.garlic_cooked) and not tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end
-- Original:           test = function(cooker, names, tags) return ((names.potato and names.potato > 1) or (names.potato_cooked and names.potato_cooked > 1) or (names.potato and names.potato_cooked)) and (names.garlic or names.garlic_cooked) and not tags.meat and not tags.inedible end,

recipes.asparagussoup.test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked) and tags.veggie and tags.veggie > 2 and not tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:          test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked) and tags.veggie and tags.veggie > 2 and not tags.meat and not tags.inedible end,

recipes.vegstinger.test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked or names.tomato or names.tomato_cooked) and tags.veggie and tags.veggie > 2 and tags.frozen and not tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and not tags.egg and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:       test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked or names.tomato or names.tomato_cooked) and tags.veggie and tags.veggie > 2 and tags.frozen and not tags.meat and not tags.inedible and not tags.egg end,

--recipes.bananapop.test = function(cooker, names, tags) return (names.cave_banana or names.cave_banana_cooked) and tags.frozen and names.twigs and not tags.meat and not tags.fish and (tags.inedible and tags.inedible <= 2) and UncompromisingFillers(tags) end
-- Original:      test = function(cooker, names, tags) return (names.cave_banana or names.cave_banana_cooked) and tags.frozen and names.twigs and not tags.meat and not tags.fish and (tags.inedible and tags.inedible <= 2) end,

recipes.ceviche.test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.frozen and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and not tags.egg and MonsterMeatSupport(tags) end 
-- Original:    test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.frozen and not tags.inedible and not tags.egg end,

recipes.salsa.test = function(cooker, names, tags) return (names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) and not tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and not tags.egg and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:  test = function(cooker, names, tags) return (names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) and not tags.meat and not tags.inedible and not tags.egg end,

recipes.pepperpopper.test = function(cooker, names, tags) return (names.pepper or names.pepper_cooked) and tags.meat and tags.meat <= 1.5 and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags)end 
-- Original:         test = function(cooker, names, tags) return (names.pepper or names.pepper_cooked) and tags.meat and tags.meat <= 1.5 and not tags.inedible end,

recipes.californiaroll.test = function(cooker, names, tags) return ((names.kelp or 0) + (names.kelp_cooked or 0) + (names.kelp_dried or 0)) == 2 and (tags.fish and tags.fish >= 1) and MonsterMeatSupport(tags) end
-- Original:         test = function(cooker, names, tags) return ((names.kelp or 0) + (names.kelp_cooked or 0) + (names.kelp_dried or 0)) == 2 and (tags.fish and tags.fish >= 1) end,

recipes.seafoodgumbo.test = function(cooker, names, tags) return tags.fish and tags.fish > 2 and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end
-- Original:         test = function(cooker, names, tags) return tags.fish and tags.fish > 2 end

recipes.surfnturf.test = function(cooker, names, tags) return tags.meat and tags.meat >= 2.5 and tags.fish and tags.fish >= 1.5 and not tags.frozen and MonsterMeatSupport(tags) end--and MonsterMeatSupport(tags) end
-- Original:         test = function(cooker, names, tags) return tags.meat and tags.meat >= 2.5 and tags.fish and tags.fish >= 1.5 and not tags.frozen end

recipes.lobsterbisque.test = function(cooker, names, tags) return names.wobster_sheller_land and tags.frozen and UncompromisingFillers(tags) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags) end
-- Original:         test = function(cooker, names, tags) return tags.meat and tags.meat >= 2.5 and tags.fish and tags.fish >= 1.5 and not tags.frozen end

recipes.lobsterdinner.test = function(cooker, names, tags) return names.wobster_sheller_land and names.butter and (tags.meat == 1.0) and (tags.fish == 1.0) and not tags.frozen and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end
-- Original:         test =  function(cooker, names, tags) return names.wobster_sheller_land and names.butter and (tags.meat == 1.0) and (tags.fish == 1.0) and not tags.frozen end

recipes.leafloaf.test = function(cooker, names, tags) return ((names.plantmeat or 0) + (names.plantmeat_cooked or 0) >= 2 ) and UncompromisingFillers(tags) end
-- Original:     test = function(cooker, names, tags) return ((names.plantmeat or 0) + (names.plantmeat_cooked or 0) >= 2 ) end

recipes.barnaclestuffedfishhead.test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and tags.fish and tags.fish >= 1.25 and UncompromisingFillers(tags) end
-- Original:					test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and tags.fish and tags.fish >= 1.25 end

recipes.barnaclepita.test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and tags.veggie and tags.veggie >= 0.5 and UncompromisingFillers(tags) end
-- Original: 		 test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and tags.veggie and tags.veggie >= 0.5 end


-- WARLY recipes

warly_recipes.monstertartare.test = function(cooker, names, tags) return tags.monster and tags.monster >= 4 and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end
-- Original:                 test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and not tags.inedible end,

warly_recipes.nightmarepie.test = function(cooker, names, tags) return names.nightmarefuel and names.nightmarefuel == 2 and (names.potato or names.potato_cooked) and (names.onion or names.onion_cooked) end
-- Original:               test = function(cooker, names, tags) return names.nightmarefuel and names.nightmarefuel == 2 and (names.potato or names.potato_cooked) and (names.onion or names.onion_cooked) end,

warly_recipes.voltgoatjelly.test = function(cooker, names, tags) return (names.lightninggoathorn) and (tags.sweetener and tags.sweetener >= 2) and not tags.meat and UncompromisingFillers(tags) end
-- Original:                test = function(cooker, names, tags) return (names.lightninggoathorn) and (tags.sweetener and tags.sweetener >= 2) and not tags.meat end,
    
warly_recipes.glowberrymousse.test = function(cooker, names, tags) return (names.wormlight or (names.wormlight_lesser and names.wormlight_lesser >= 2)) and (tags.fruit and tags.fruit >= 2) and not tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end
-- Original:                  test = function(cooker, names, tags) return (names.wormlight or (names.wormlight_lesser and names.wormlight_lesser >= 2)) and (tags.fruit and tags.fruit >= 2) and not tags.meat and not tags.inedible end,
    
warly_recipes.frogfishbowl.test = function(cooker, names, tags) return ((names.froglegs and names.froglegs >= 2) or (names.froglegs_cooked and names.froglegs_cooked >= 2 ) or (names.froglegs and names.froglegs_cooked)) and tags.fish and tags.fish >= 1 and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end
-- Original:               test = function(cooker, names, tags) return ((names.froglegs and names.froglegs >= 2) or (names.froglegs_cooked and names.froglegs_cooked >= 2 ) or (names.froglegs and names.froglegs_cooked)) and tags.fish and tags.fish >= 1 and not tags.inedible end,

warly_recipes.dragonchilisalad.test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and (names.pepper or names.pepper_cooked) and not tags.meat and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and not tags.egg and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end
-- Original:                   test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and (names.pepper or names.pepper_cooked) and not tags.meat and not tags.inedible and not tags.egg end,

warly_recipes.gazpacho.test = function(cooker, names, tags) return ((names.asparagus and names.asparagus >= 2) or (names.asparagus_cooked and names.asparagus_cooked >= 2) or (names.asparagus and names.asparagus_cooked)) and (tags.frozen and tags.frozen >= 2) end
-- Original:    	   test = function(cooker, names, tags) return ((names.asparagus and names.asparagus >= 2) or (names.asparagus_cooked and names.asparagus_cooked >= 2) or (names.asparagus and names.asparagus_cooked)) and (tags.frozen and tags.frozen >= 2) end,

warly_recipes.freshfruitcrepes.test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 1.5 and names.butter and names.honey and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end
-- Original:                   test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 1.5 and names.butter and names.honey end,

warly_recipes.bonesoup.test = function(cooker, names, tags) return names.boneshard and names.boneshard == 2 and (names.onion or names.onion_cooked) and (tags.inedible and tags.inedible < 3) and UncompromisingFillers(tags) and MonsterMeatSupport(tags) end
-- Original:     test = function(cooker, names, tags) return names.boneshard and names.boneshard == 2 and (names.onion or names.onion_cooked) and (tags.inedible and tags.inedible < 3) end,

warly_recipes.moqueca.test = function(cooker, names, tags) return tags.fish and (names.onion or names.onion_cooked) and (names.tomato or names.tomato_cooked) and not tags.inedible and not (tags.insectoid and tags.insectoid >= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) and MonsterMeatSupport(tags)end
-- Original:    test = function(cooker, names, tags) return tags.fish and (names.onion or names.onion_cooked) and (names.tomato or names.tomato_cooked) and not tags.inedible end,
--warly_recipes.zaspberryparfait.test = function(cooker, names, tags) return not tags.monster and not tags.inedible and UncompromisingFillers(tags) and names.zaspberry and tags.dairy and tags.sweetener end
local ingredients = cooking.ingredients
--[[InsertIngredientValues function by Serpens https://forums.kleientertainment.com/forums/topic/69732-dont-use-addingredientvalues-in-mods/]]

--NOTE: If the thing already had a tag with the same name, you will still overwrite the old value, unless keepoldvalues is true. E.g if fish already had a tag seafood with value 0.5 and now you use this function with value 1, the result will be 1.
function InsertIngredientValues(names, tags, cancook, candry, keepoldvalues) -- if cancook or candry is true, the cooked/dried variant of the thing will also get the tags and the tags precook/dried.
	for _,name in pairs(names) do
        if ingredients[name] == nil then -- if it is not cookable already, it will be nil. Following code is just a copy of the normal AddIngredientValues function
            ingredients[name] = { tags= {}}

            if cancook then
                ingredients[name.."_cooked"] = {tags={}}
            end

            if candry then
                ingredients[name.."_dried"] = {tags={}}
            end

            for tagname,tagval in pairs(tags) do
                ingredients[name].tags[tagname] = tagval
                --print(name,tagname,tagval,ingtable[name].tags[tagname])

                if cancook then
                    ingredients[name.."_cooked"].tags.precook = 1
                    ingredients[name.."_cooked"].tags[tagname] = tagval
                end
                if candry then
                    ingredients[name.."_dried"].tags.dried = 1
                    ingredients[name.."_dried"].tags[tagname] = tagval
                end
            end
        else    -- but if there are already some tags, don't delete previous tags, just add the new ones. 
            for tagname,tagval in pairs(tags) do
                if ingredients[name].tags[tagname]==nil or not keepoldvalues then -- only overwrite old value, if there is no old value, or if keepoldvalues is not true (will be not true by default)
                    ingredients[name].tags[tagname] = tagval -- this will overwrite the old value, if there was one
                end
                --print(name,tagname,tagval,ingtable[name].tags[tagname])

                if cancook then
                    if ingredients[name.."_cooked"] == nil then
                        ingredients[name.."_cooked"] = {tags={}}
                    end
                    if ingredients[name.."_cooked"].tags.precook==nil or not keepoldvalues then
                        ingredients[name.."_cooked"].tags.precook = 1
                    end
                    if ingredients[name.."_cooked"].tags[tagname]==nil or not keepoldvalues then
                        ingredients[name.."_cooked"].tags[tagname] = tagval
                    end
                end
                if candry then
                    if ingredients[name.."_dried"] == nil then
                        ingredients[name.."_dried"] = {tags={}}
                    end
                    if ingredients[name.."_dried"].tags.dried==nil or not keepoldvalues then
                        ingredients[name.."_dried"].tags.dried = 1
                    end
                    if ingredients[name.."_dried"].tags[tagname]==nil or not keepoldvalues then    
                        ingredients[name.."_dried"].tags[tagname] = tagval
                    end
                end
            end
        end
	end
end

InsertIngredientValues({"zaspberry"},{fruit=1},true,false,false)
InsertIngredientValues({"iceboomerang"},{ice=1},true,false,false)
InsertIngredientValues({"rice"},{veggie=1,rice=1},true,false,false)
InsertIngredientValues({"rice_cooked"},{veggie=1,rice=1},true,false,false)
local zaspberryparfait =
{
    name = "zaspberryparfait",
    test = function(cooker, names, tags) return not tags.monster and not tags.inedible and UncompromisingFillers(tags) and names.zaspberry and tags.sweetener and tags.dairy end,

    priority = 30,
    weight = 1,
    perishtime = nil,
    cooktime = 0.5,
}
AddCookerRecipe("portablecookpot", zaspberryparfait)
local carapacecooler =
{
    name = "carapacecooler",
    test = function(cooker, names, tags) return not tags.monster and not tags.inedible and UncompromisingFillers(tags) and names.iceboomerang and tags.sweetener end,

    priority = 30,
    weight = 1,
    perishtime = nil,
    cooktime = 0.5,
}
--AddCookerRecipe("portablecookpot", carapacecooler)
local seafoodpaella =
{
    name = "seafoodpaella",
    test = function(cooker, names, tags) return not tags.monster and not tags.inedible and UncompromisingFillers(tags) and tags.rice and tags.veggie >= 2 and names.wobster_sheller_land end,

    priority = 30,
    weight = 1,
    perishtime = nil,
    cooktime = 0.5,
}
AddCookerRecipe("cookpot", seafoodpaella)
AddCookerRecipe("portablecookpot", seafoodpaella)
local liceloaf =
{
    name = "liceloaf",
    test = function(cooker, names, tags) return (tags.rice and tags.rice >= 2) and UncompromisingFillers(tags) and not (tags.insectoid and tags.insectoid >= 1) and not tags.inedible end,

    priority = 30,
    weight = 1,
    perishtime = nil,
    cooktime = 0.5,
}
AddCookerRecipe("cookpot", liceloaf)
AddCookerRecipe("portablecookpot", liceloaf)
local hardshelltacos =
{
    name = "hardshelltacos",
    test = function(cooker, names, tags) return names.scorpioncarapace and names.scorpioncarapace > 1 and tags.veggie end,

    priority = 30,
    weight = 1,
    perishtime = nil,
    cooktime = 0.5,
}
AddCookerRecipe("cookpot", hardshelltacos)
AddCookerRecipe("portablecookpot", hardshelltacos)
local californiaking =
{
    name = "californiaking",
    test = function(cooker, names, tags) return (names.barnacle or names.barnacle_cooked) and (names.wobster_sheller_land) and (names.pepper or names.pepper_cooked) and tags.frozen end,

    priority = 30,
    weight = 30,
    perishtime = nil,
    cooktime = 0.5,
}
AddCookerRecipe("cookpot", californiaking)
AddCookerRecipe("portablecookpot", californiaking)
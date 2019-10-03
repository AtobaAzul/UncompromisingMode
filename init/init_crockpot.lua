-----------------------------------------------------------------
-- Crockpot food changes
-- Relevant: cooking.lua, preparedfods.lua, foods (variable)
-----------------------------------------------------------------
local require = GLOBAL.require
local cooking = require "cooking"
local recipes = cooking.recipes.cookpot


-----------------------------------------------------------------
-- Recipe cooktime changes
-----------------------------------------------------------------
--recipes.bonestew.cooktime = 60 -- Up from 15s (TODO: PENDING VOTES)


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

-----------------------------------------------------------------
-- Recipe changes (mostly added above filler changes)
-- But made to be easily customised below for future changes
-----------------------------------------------------------------

recipes.butterflymuffin.test = function(cooker, names, tags) return (names.butterflywings or names.moonbutterflywings) and not tags.meat and tags.veggie and UncompromisingFillers(tags) end 
-- Original: 		    test = function(cooker, names, tags) return (names.butterflywings or names.moonbutterflywings) and not tags.meat and tags.veggie end,

recipes.frogglebunwich.test = function(cooker, names, tags) return (names.froglegs or names.froglegs_cooked) and tags.veggie and UncompromisingFillers(tags) end
-- Original:           test = function(cooker, names, tags) return (names.froglegs or names.froglegs_cooked) and tags.veggie end,

recipes.taffy.test = function(cooker, names, tags) return tags.sweetener and tags.sweetener >= 3 and not tags.meat and UncompromisingFillers(tags) end
-- Original:  test = function(cooker, names, tags) return tags.sweetener and tags.sweetener >= 3 and not tags.meat end,

recipes.pumpkincookie.test = function(cooker, names, tags) return (names.pumpkin or names.pumpkin_cooked) and tags.sweetener and tags.sweetener >= 2 and UncompromisingFillers(tags) end
-- Original:          test = function(cooker, names, tags) return (names.pumpkin or names.pumpkin_cooked) and tags.sweetener and tags.sweetener >= 2 end,

recipes.stuffedeggplant.test = function(cooker, names, tags) return (names.eggplant or names.eggplant_cooked) and tags.veggie and tags.veggie > 1 and UncompromisingFillers(tags) end 
-- Original:            test = function(cooker, names, tags) return (names.eggplant or names.eggplant_cooked) and tags.veggie and tags.veggie > 1 end,

recipes.fishsticks.test = function(cooker, names, tags) return tags.fish and names.twigs and (tags.inedible and tags.inedible <= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:       test = function(cooker, names, tags) return tags.fish and names.twigs and (tags.inedible and tags.inedible <= 1) end,

recipes.honeynuggets.test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat <= 1.5 and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:         test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat <= 1.5 and not tags.inedible end,

recipes.honeyham.test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat > 1.5 and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:     test = function(cooker, names, tags) return names.honey and tags.meat and tags.meat > 1.5 and not tags.inedible end,

recipes.dragonpie.test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and not tags.meat and UncompromisingFillers(tags) end 
-- Original:      test = function(cooker, names, tags) return (names.dragonfruit or names.dragonfruit_cooked) and not tags.meat end,

recipes.kabobs.test = function(cooker, names, tags) return tags.meat and names.twigs and (not tags.monster or tags.monster <= 1) and (tags.inedible and tags.inedible <= 1) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:   test = function(cooker, names, tags) return tags.meat and names.twigs and (not tags.monster or tags.monster <= 1) and (tags.inedible and tags.inedible <= 1) end,

recipes.mandrakesoup.test = function(cooker, names, tags) return names.mandrake and UncompromisingFillers(tags) end 
-- Original:         test = function(cooker, names, tags) return names.mandrake end,

recipes.baconeggs.test = function(cooker, names, tags) return tags.egg and tags.egg > 1 and tags.meat and tags.meat > 1 and not tags.veggie and UncompromisingFillers(tags) end 
-- Original:      test = function(cooker, names, tags) return tags.egg and tags.egg > 1 and tags.meat and tags.meat > 1 and not tags.veggie end,

recipes.meatballs.test = function(cooker, names, tags) return tags.meat and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:      test = function(cooker, names, tags) return tags.meat and not tags.inedible end,

recipes.bonestew.test = function(cooker, names, tags) return tags.meat and tags.meat >= 3 and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:     test = function(cooker, names, tags) return tags.meat and tags.meat >= 3 and not tags.inedible end,

recipes.perogies.test = function(cooker, names, tags) return tags.egg and tags.meat and tags.veggie and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:     test = function(cooker, names, tags) return tags.egg and tags.meat and tags.veggie and not tags.inedible end,

recipes.turkeydinner.test = function(cooker, names, tags) return names.drumstick and names.drumstick > 1 and tags.meat and tags.meat > 1 and (tags.veggie or tags.fruit) and UncompromisingFillers(tags) end 
-- Original:         test = function(cooker, names, tags) return names.drumstick and names.drumstick > 1 and tags.meat and tags.meat > 1 and (tags.veggie or tags.fruit) end,

recipes.ratatouille.test = function(cooker, names, tags) return not tags.meat and tags.veggie and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:        test = function(cooker, names, tags) return not tags.meat and tags.veggie and not tags.inedible end,

recipes.jammypreserves.test = function(cooker, names, tags) return tags.fruit and not tags.meat and not tags.veggie and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end
-- Original:           test = function(cooker, names, tags) return tags.fruit and not tags.meat and not tags.veggie and not tags.inedible end,

recipes.fruitmedley.test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 3 and not tags.meat and not tags.veggie and UncompromisingFillers(tags) end 
-- Original:        test = function(cooker, names, tags) return tags.fruit and tags.fruit >= 3 and not tags.meat and not tags.veggie end,

recipes.fishtacos.test = function(cooker, names, tags) return tags.fish and (names.corn or names.corn_cooked) and UncompromisingFillers(tags) end 
-- Original:      test = function(cooker, names, tags) return tags.fish and (names.corn or names.corn_cooked) end,

recipes.waffles.test = function(cooker, names, tags) return names.butter and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.egg and UncompromisingFillers(tags) end 
-- Original:    test = function(cooker, names, tags) return names.butter and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.egg end,

recipes.monsterlasagna.test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:           test = function(cooker, names, tags) return tags.monster and tags.monster >= 2 and not tags.inedible end,

recipes.powcake.test = function(cooker, names, tags) return names.twigs and names.honey and (names.corn or names.corn_cooked) and UncompromisingFillers(tags) end 
-- Original:    test = function(cooker, names, tags) return names.twigs and names.honey and (names.corn or names.corn_cooked) end,

recipes.unagi.test = function(cooker, names, tags) return names.cutlichen and (names.eel or names.eel_cooked) and UncompromisingFillers(tags) end 
-- Original:  test = function(cooker, names, tags) return names.cutlichen and (names.eel or names.eel_cooked) end,

--recipes.wetgoop.test = function(cooker, names, tags) return true end 
-- Original:    test = function(cooker, names, tags) return true end,

recipes.flowersalad.test = function(cooker, names, tags) return names.cactus_flower and tags.veggie and tags.veggie >= 2 and not tags.meat and not tags.inedible and not tags.egg and not tags.sweetener and not tags.fruit and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:        test = function(cooker, names, tags) return names.cactus_flower and tags.veggie and tags.veggie >= 2 and not tags.meat and not tags.inedible and not tags.egg and not tags.sweetener and not tags.fruit end,

--recipes.icecream.test = function(cooker, names, tags) return tags.frozen and tags.dairy and tags.sweetener and not tags.meat and not tags.veggie and not tags.inedible and not tags.egg and UncompromisingFillers(tags) end 
-- Original:     test = function(cooker, names, tags) return tags.frozen and tags.dairy and tags.sweetener and not tags.meat and not tags.veggie and not tags.inedible and not tags.egg end,

--recipes.watermelonicle.test = function(cooker, names, tags) return names.watermelon and tags.frozen and names.twigs and not tags.meat and not tags.veggie and not tags.egg and UncompromisingFillers(tags) end 
-- Original:           test = function(cooker, names, tags) return names.watermelon and tags.frozen and names.twigs and not tags.meat and not tags.veggie and not tags.egg end,

recipes.trailmix.test = function(cooker, names, tags) return names.acorn_cooked and tags.seed and tags.seed >= 1 and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.fruit and tags.fruit >= 1 and not tags.meat and not tags.veggie and not tags.egg and not tags.dairy and UncompromisingFillers(tags) end 
-- Original:     test = function(cooker, names, tags) return names.acorn_cooked and tags.seed and tags.seed >= 1 and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.fruit and tags.fruit >= 1 and not tags.meat and not tags.veggie and not tags.egg and not tags.dairy end,

recipes.hotchili.test = function(cooker, names, tags) return tags.meat and tags.veggie and tags.meat >= 1.5 and tags.veggie >= 1.5 and UncompromisingFillers(tags) end 
-- Original:     test = function(cooker, names, tags) return tags.meat and tags.veggie and tags.meat >= 1.5 and tags.veggie >= 1.5 end,

recipes.guacamole.test = function(cooker, names, tags) return names.mole and (names.rock_avocado_fruit_ripe or names.cactus_meat) and not tags.fruit and UncompromisingFillers(tags) end 
-- Original:      test = function(cooker, names, tags) return names.mole and (names.rock_avocado_fruit_ripe or names.cactus_meat) and not tags.fruit end,

recipes.jellybean.test = function(cooker, names, tags) return names.royal_jelly and not tags.inedible and not tags.monster and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:      test = function(cooker, names, tags) return names.royal_jelly and not tags.inedible and not tags.monster end,

recipes.potatotornado.test = function(cooker, names, tags) return (names.potato or names.potato_cooked) and names.twigs and (not tags.monster or tags.monster <= 1) and not tags.meat and (tags.inedible and tags.inedible <= 2) and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:          test = function(cooker, names, tags) return (names.potato or names.potato_cooked) and names.twigs and (not tags.monster or tags.monster <= 1) and not tags.meat and (tags.inedible and tags.inedible <= 2) end,

recipes.mashedpotatoes.test = function(cooker, names, tags) return ((names.potato and names.potato > 1) or (names.potato_cooked and names.potato_cooked > 1) or (names.potato and names.potato_cooked)) and (names.garlic or names.garlic_cooked) and not tags.meat and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end
-- Original:           test = function(cooker, names, tags) return ((names.potato and names.potato > 1) or (names.potato_cooked and names.potato_cooked > 1) or (names.potato and names.potato_cooked)) and (names.garlic or names.garlic_cooked) and not tags.meat and not tags.inedible end,

recipes.asparagussoup.test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked) and tags.veggie and tags.veggie > 2 and not tags.meat and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:          test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked) and tags.veggie and tags.veggie > 2 and not tags.meat and not tags.inedible end,

recipes.vegstinger.test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked or names.tomato or names.tomato_cooked) and tags.veggie and tags.veggie > 2 and tags.frozen and not tags.meat and not tags.inedible and not tags.egg and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:       test = function(cooker, names, tags) return (names.asparagus or names.asparagus_cooked or names.tomato or names.tomato_cooked) and tags.veggie and tags.veggie > 2 and tags.frozen and not tags.meat and not tags.inedible and not tags.egg end,

--recipes.bananapop.test = function(cooker, names, tags) return (names.cave_banana or names.cave_banana_cooked) and tags.frozen and names.twigs and not tags.meat and not tags.fish and (tags.inedible and tags.inedible <= 2) and UncompromisingFillers(tags) end
-- Original:      test = function(cooker, names, tags) return (names.cave_banana or names.cave_banana_cooked) and tags.frozen and names.twigs and not tags.meat and not tags.fish and (tags.inedible and tags.inedible <= 2) end,

--recipes.ceviche.test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.frozen and not tags.inedible and not tags.egg and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:    test = function(cooker, names, tags) return tags.fish and tags.fish >= 2 and tags.frozen and not tags.inedible and not tags.egg end,

recipes.salsa.test = function(cooker, names, tags) return (names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) and not tags.meat and not tags.inedible and not tags.egg and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:  test = function(cooker, names, tags) return (names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) and not tags.meat and not tags.inedible and not tags.egg end,

recipes.pepperpopper.test = function(cooker, names, tags) return (names.pepper or names.pepper_cooked) and tags.meat and tags.meat <= 1.5 and not tags.inedible and LimitIceTestFn(tags, RECIPE_ICE_LIMIT) end 
-- Original:         test = function(cooker, names, tags) return (names.pepper or names.pepper_cooked) and tags.meat and tags.meat <= 1.5 and not tags.inedible end,

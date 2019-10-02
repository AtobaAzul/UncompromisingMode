--	[ 			Required stuff			]	--
-- The global objects needed for recipe changes
-- Find the default recipes in recipes.lua
	TECH = GLOBAL.TECH
	Recipe = GLOBAL.Recipe
	RECIPETABS = GLOBAL.RECIPETABS
	Ingredient = GLOBAL.Ingredient
	AllRecipes = GLOBAL.AllRecipes
	STRINGS = GLOBAL.STRINGS
	TECH = GLOBAL.TECH
	CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

--	[ 				Recipes				]	--
	
--	Tool
	
--	Light

--	Survival

--	Food

--	Science

--	Fight

--	Structures
	
--	Refine
	
--	Magic
	
--	Dress
	
--	Ancient
	
--	Celestial

-- Wicker Books

-- Leafy meat cost for applied horticulture
if GetModConfigData("harder_recipes") then
	-- Also use fertilizer instead of poop
	Recipe("book_gardening", {Ingredient("papyrus", 2), Ingredient("plantmeat", 1), Ingredient("fertilizer", 1)}, CUSTOM_RECIPETABS.BOOKS, TECH.SCIENCE_ONE, nil, nil, nil, nil, "bookbuilder")
else
	-- Use poop as normal
	Recipe("book_gardening", {Ingredient("papyrus", 2), Ingredient("plantmeat", 1), Ingredient("poop", 1)}, CUSTOM_RECIPETABS.BOOKS, TECH.SCIENCE_ONE, nil, nil, nil, nil, "bookbuilder")
end

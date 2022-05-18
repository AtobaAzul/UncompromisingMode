--Update this list when adding files
local component_post = {
    --example:
    --"container",
	"groundpounder",
	"propagator",
	--"moisture",
	"weapon",
	--"hunter",
	"kramped",
	"explosiveresist",
	"crop",
	"wildfires",
	--"beargerspawner",
	"workable",
	"sleepingbaguser",
	"hounded",
	"sleeper",
	"fueled",
	"perishable",
	--"carnivalevent",
	"lootdropper",
	"ambientsound",
	"foodaffinity",
	"eater",
	"edible",
	"inventory" -- This is an attempt at manually fixing an issue when people are checked for insulation. -scrimbles
}

local prefab_post = {
	"wardrobe",
	"beequeen",
	"pocketwatch_weapon",
	"shieldofcthulu",
	"clockworks",
	"flingobalance",
	"chester",
	"mushlight",
	"butterfly",
    --"toadstool_cap", Moved to init_uncompromising_mod.lua
    "amulet",
	"beequeen",
	"cave_entrance_open",
	"catcoon",
	"icehound",
	"firehound",
	--"forest",
	"world",
	"antlion",
	"minifan",
	"spider",
	"hound",
	"ash",
	"bunnyman",
	"walls",
	"infestables",
	"foodbuffs",
	"mutatedhound",
	--"ground_chunks_breaking",
	"skeleton",
	--"shadowcreature",
	"berrybush",
	--"papyrus",
	"sporecloud",
	"featherhat",
	--"malbatross",
	"mushrooms",
	"rock_ice",
	"toadstool",
	"oasislake",
	--"shadowcreature",
	"lureplant",
	"spiderden",
	"stafflights",
	"armor_ruins",
	"sweatervest",
	"fans",
	"skeletonhat",
	--"rock_avocado_fruit_sprout_sapling",
	"icepack",
	"heatrock",
	"dragonfly_spawner",
	"rneghostfire",
	"monkey",
	"batcave",
	"rain",
	"molehat",
	"klaus",
	"mosquito",
	"armor_bramble",
	"cookiecutterhat",
	--"woby",
	"cave_network",
	"glasscutter",
	"critterlab",
	"wobster",
	"hambat",
	"townportal",
	"trinkets", --This is for the grave mound cc trinkets
	"moonbase",
	"koalas",
	"pumpkin_lantern",
	"piggyback",
	"nightlight",
	"armor_sanity",
	"tophat",
	"tophatreduction",
	"crabking",
	"ruinsstatues", 
	"moondial",
	--"deciduoustrees",
	"pktrades",
	"pigking",
	"marblebean",
	"reviver",
	"krampus_sack",
	--"bundle",
	"eyebrella",
	"birds",
	"tonichandlers",
	"houndwarning",
	--"carnival_host",
	"spider_whistle",
	"spider_healer",
	"siestahut",
	"bees",
	"farmplants",
	"rainhat",
	"darts",
	"terrarium",
	"bandage",
	"grassgekko",
	"minotaur_drops",
	"frog",
}

local stategraph_post = {
    --example:
    --"wilson",
	"wilson",
	"wilson_client",
	"spider",
	"frog",
	--"wobysmall",
	--"shadowcreature",
	"stalker_minion",
	"krampus",
	--"merm",
	"carnival_host",
	"catcoon",
}

local class_post = {
    --example:
    --"components/inventoryitem_replica",
    --"screens/playerhud",
	"widgets/itemtile",
	--"widgets/hoverer",
	"widgets/moisturemeter",
	"widgets/controls",
	"widgets/craftslot",
}

local brain_post = {
    --example:
    --"hound",
	"frog",
	"nofirepanic",
	"chester",
	"mossling",
	"perd",
	"catcoon",
	"deer",
}

if GetModConfigData("hangyperds") then
	table.insert(stategraph_post,"perd")
	table.insert(brain_post,"perdhungry")
	table.insert(prefab_post,"perd")
end

if GetModConfigData("harder_deerclops") then
	table.insert(stategraph_post,"deerclops")
	table.insert(prefab_post,"deerclops")
end

if GetModConfigData("harder_moose") then
	table.insert(stategraph_post,"moose")
	table.insert(prefab_post,"moose")
	table.insert(brain_post,"moose")
end

if GetModConfigData("harder_bearger") then
	table.insert(stategraph_post,"bearger")
	table.insert(prefab_post,"bearger")
	table.insert(brain_post,"bearger")
end

if GetModConfigData("harder_leifs") then
	table.insert(stategraph_post,"Leif")
	table.insert(prefab_post,"leif")
	table.insert(prefab_post,"leif_sparse")
	table.insert(brain_post, "leif")
end

if GetModConfigData("rework_minotaur_") then
	table.insert(stategraph_post,"minotaur")
	table.insert(prefab_post,"minotaur")
	table.insert(prefab_post,"pillar_ruins")
end

if GetModConfigData("harder_dragonfly") then 
	table.insert(prefab_post,"dragonfly")
end
if GetModConfigData("harder_lavae") then
	table.insert(prefab_post,"lavae")
end

if GetModConfigData("hardbatilisks") then
	table.insert(prefab_post,"bat")
end

if GetModConfigData("pinelings") then
	table.insert(prefab_post,"evergreen_stump")
end

if GetModConfigData("canedurability") then
	table.insert(prefab_post,"cane")
end

if GetModConfigData("angrypenguins") then
	table.insert(prefab_post,"penguin")
	table.insert(prefab_post,"penguin_ice") --I think that should go too?  idk right here
end

if GetModConfigData("harder_pigs") then
	table.insert(prefab_post,"pigman")
	table.insert(brain_post,"pig")
	table.insert(brain_post,"werepig")
	table.insert(stategraph_post,"pigbunny")
end

if GetModConfigData("harder_walrus") then
	table.insert(prefab_post,"walrus")
	table.insert(stategraph_post,"walrus")
end
if GetModConfigData("harder_beefalo") then
	table.insert(stategraph_post,"Beefalo")
end

if GetModConfigData("harder_spiderqueen") then
	table.insert(prefab_post,"spiderqueen")
	table.insert(stategraph_post,"spiderqueen")
end

if GetModConfigData("pocket_powertrip") == 1 or 2 then
	table.insert(prefab_post,"pocket_powertrip")
end

if GetModConfigData("harder_koalefants") then
	table.insert(stategraph_post,"koalefant")
end

if GetModConfigData("reworked_eyes") then
	table.insert(prefab_post,"eyeofterror")
	table.insert(stategraph_post,"eyeofterror")
end

if GetModConfigData("scalemailbuff") then
	table.insert(prefab_post,"armor_dragonfly")
end

if GetModConfigData("um_music") and not TUNING.DSTU.ISLAND_ADVENTURES then
	table.insert(component_post,"dynamicmusic")
end

if GetModConfigData("winter_burning") and not TUNING.DSTU.ISLAND_ADVENTURES then
	table.insert(component_post,"burnable")
end

if GetModConfigData("cooldown_orangestaff") then
	table.insert(prefab_post, "orangestaff")
end

if GetModConfigData("amalgams") then
	table.insert(prefab_post,"chessjunk")
end

if GetModConfigData("moon_transformations") then
	table.insert(prefab_post,"flower")
end

if GetModConfigData("electricalmishap_") ~= 0 then
	table.insert(prefab_post,"nightstick")
end

modimport("postinit/sim")
modimport("postinit/any")
modimport("postinit/player")

for _,v in pairs(component_post) do
    modimport("postinit/components/"..v)
end

for _,v in pairs(prefab_post) do
    modimport("postinit/prefabs/"..v)
end

for _,v in pairs(stategraph_post) do
    modimport("postinit/stategraphs/SG"..v)
end

for _,v in pairs(brain_post) do
    modimport("postinit/brains/"..v.."brain")
end

for _,v in pairs(class_post) do
    --These contain a path already, e.g. v= "widgets/inventorybar"
    modimport("postinit/".. v)
end

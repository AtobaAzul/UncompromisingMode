--Update this list when adding files
local component_post = {
    --example:
    --"container",
	"groundpounder",
	"propagator",
	"burnable",
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
	"dynamicmusic",
	"sleeper",
	"fueled",
	"perishable",
	--"carnivalevent",
	"lootdropper",
}

local prefab_post = {
	"flingobalance",
	"chester",
	"mushlight",
	"flower",
	"butterfly",
    --"toadstool_cap", Moved to init_uncompromising_mod.lua
    "amulet",
    "trap_teeth",
	"beequeen",
	"spiderqueen",
	"cave_entrance_open",
	"catcoon",
	"icehound",
	"firehound",
	"walrus",
	--"forest",
	"world",
	"antlion",
	"minifan",
	"spider",
	"spiderqueen",
	"hound",
	"penguin",
	"ash",
	"pigman",
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
	"books",
	"armor_ruins",
	"sweatervest",
	"penguin_ice",
	"fans",
	"skeletonhat",
	--"rock_avocado_fruit_sprout_sapling",
	"icepack",
	"heatrock",
	"dragonfly_spawner",
	"rneghostfire",
	"frog", -- also toad
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
	"nightstick",
	"critterlab",
	"wobster",
	"hambat",
	"townportal",
	"trinkets", --This is for the grave mound cc trinkets
	"moonbase",
	"koalas",
	"pocket_powertrip",
	"pumpkin_lantern",
	"piggyback",
	"nightlight",
	"armor_sanity",
	"tophat",
	"tophatreduction",
	"crabking",
	"ruinsstatues", 
	"chessjunk",
	"moondial",
	--"deciduoustrees",
	"pktrades",
	"pigking",
	"marblebean",
	"reviver",
	"krampus_sack",
	"armor_dragonfly",
	--"bundle",
	"eyebrella",
	"birds",
	"seedpouch",
	"tonichandlers",
	"houndwarning",
	--"carnival_host",
}

local stategraph_post = {
    --example:
    --"wilson",
	"wilson",
	"spider",
	"frog",
	"walrus",
	--"wobysmall",
	"pigbunny",
	--"shadowcreature",
	"Beefalo",
	"stalker_minion",
	"koalefant",
	"krampus",
	"spiderqueen",
	"merm",
	"carnival_host",
}

local class_post = {
    --example:
    --"components/inventoryitem_replica",
    --"screens/playerhud",
	"widgets/itemtile",
	--"widgets/hoverer",
	"widgets/moisturemeter",
	"widgets/controls",
}

local brain_post = {
    --example:
    --"hound",
	"pig",
	"werepig",
	"frog",
	"nofirepanic",
	"chester",
	"mossling",
}

if GetModConfigData("hangyperds") == true then
table.insert(stategraph_post,"perd")
table.insert(brain_post,"perd")
table.insert(prefab_post,"perd")
end

if GetModConfigData("harder_deerclops") == true then
table.insert(stategraph_post,"deerclops")
table.insert(prefab_post,"deerclops")
end

if GetModConfigData("harder_moose") == true then
table.insert(stategraph_post,"moose")
table.insert(prefab_post,"moose")
table.insert(brain_post,"moose")
end

if GetModConfigData("harder_bearger") == true then
table.insert(stategraph_post,"bearger")
table.insert(prefab_post,"bearger")
table.insert(brain_post,"bearger")
end

if GetModConfigData("harder_leifs") == true then
table.insert(stategraph_post,"Leif")
table.insert(prefab_post,"leif")
table.insert(prefab_post,"leif_sparse")
end

if GetModConfigData("rework_minotaur") == true then
table.insert(stategraph_post,"minotaur")
table.insert(prefab_post,"minotaur")
table.insert(prefab_post,"pillar_ruins")
end

if GetModConfigData("harder_dragonfly") == true then 
table.insert(prefab_post,"dragonfly")
end
if GetModConfigData("harder_lavae") == true then
table.insert(prefab_post,"lavae")
end

if GetModConfigData("hardbatilisks") == true then
table.insert(prefab_post,"bat")
end

if GetModConfigData("pinelings") == true then
table.insert(prefab_post,"evergreen_stump")
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
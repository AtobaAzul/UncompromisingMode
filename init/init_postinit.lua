--Update this list when adding files
local component_post = {
    --example:
    --"container",
	"groundpounder",
	"propagator",
	"burnable",
	"moisture",
	--"hunter",
}

local prefab_post = {
    "toadstool_cap",
    "yellowamulet",
    "trap_teeth",
    --"cave",
	"beequeen",
	"dragonfly",
	"deerclops",
	"spiderqueen",
	"bearger",
	"cave_entrance_open",
	"catcoon",
	"icehound",
	"firehound",
	"walrus",
	--"forest",
	"leif",
	"leif_sparse",
	"world",
	"antlion",
	"minifan",
	"spider",
	"spiderqueen",
	"hound",
	"penguin",
	"ash",
	"pigman",
	"moose",
	"walls",
	"infestables",
	"foodbuffs",
	"mutatedhound",
	"pillar_ruins",
	"minotaur",
	"ground_chunks_breaking",
	"skeleton",
	--"shadowcreature",
	"berrybush",
	--"papyrus",
	"sporecloud",
	"bat",
	"featherhat",
	"lavae",
	--"amulet",
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
	"firesuppressor",
	"dragonfly_spawner",
	"mist",
	"rneghostfire",
	"frog", -- also toad
	"monkey",
}

local stategraph_post = {
    --example:
    --"wilson",
	"deerclops",
	"wilson",
	"Leif",
	"minotaur",
	"spider",
	"frog",
	--"shadowcreature",
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
	"werepig",
	"walrus",
	"frog",
}

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

local DRAGONFLYBAIT = 
{
    "treasurechest",
    "icebox",
	"saltbox",
	"fish_box",
	"mushroom_light",
	"mushroom_light2",
	"lightning_rod",
	"researchlab",
	"researchlab2",
	"researchlab3",
	"researchlab4",
	"madscience_lab",
	"seafaring_prototyper",
	"slow_farmplot",
	"fast_farmplot",
	"table_winters_feast",
	"beebox",
	"birdcage",
	"tacklestation",
	"wardrobe",
	"meatrack",
	"mushroomfarm",
	"mushroomlight1",
	"mushroomlight2",
	"cookpot",
	"portablecookpot",
	"portablespicer",
	"portableblender",
	"cartographydesk",
	"sculptingtable",
	"tent",
	"siestahut",
	"air_conditioner",
	"boat",
	"mast",
	"mast_malbatross",
}

local function AddDragonflyBait(inst)
	
			inst:AddTag("dragonflybait_lowprio")
		
end

local function AddContainers(prefab)
    AddPrefabPostInit(prefab, function (inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
	
		AddDragonflyBait(inst)
		
    end)
end

for k, v in pairs(DRAGONFLYBAIT) do
	AddContainers(v)
end


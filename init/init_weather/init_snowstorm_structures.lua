
local CONTAINERS = 
{
    "treasurechest",
    "icebox",
	"dragonflychest",
	"saltbox",
	"fish_box",
	"firepit",
	"campfire",
	"coldfire",
	"coldfirepit",
	"nightlight",
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
	"mast",
	"mast_malbatross",
	"steeringwheel",
	"anchor",
	"table_winters_feast",
	"wintersfeastoven",
	"beebox",
	"birdcage",
	"tacklestation",
	"townportal",
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
	"firesuppressor",
	"lightninrod",
	"sculptingtable",
	"tent",
	"siestahut",
}

local function CheckForSnow(inst)
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 1, { "snowpile" })
	
	if #ents > 0 then
		--if inst.components.container ~= nil then
			--inst:RemoveComponent("container")
			
			inst:AddTag("INLIMBO")
		--end
	else
		--if inst.components.container == nil then
			--inst:AddComponent("container")
		--end
		
		inst:RemoveTag("INLIMBO")
	end
		
	inst:DoTaskInTime(2, CheckForSnow)
end

local function AddContainers(prefab)
    AddPrefabPostInit(prefab, function (inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
	
		inst:DoTaskInTime(2, CheckForSnow)
		
    end)
end

for k, v in pairs(CONTAINERS) do
	AddContainers(v)
end


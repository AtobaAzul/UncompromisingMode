
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

local function RemoveSnowedTag(inst)
	if inst:HasTag("snowpiledin") then
		inst:RemoveTag("snowpiledin")
	end
	
	inst.removetagtask = nil
end

local function CheckForSnow(inst)
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim ~= nil and TheSim:FindEntities(x, y, z, 1, { "snowpile_basic" })
	
	if #ents > 0 then
		--if inst.components.container ~= nil then
			--inst:RemoveComponent("container")
					
			local x1, y1, z1 = inst.Transform:GetWorldPosition()
			local ents2 = TheSim:FindEntities(x1, y1, z1, 1, { "snowpile" })
			
			if #ents2 > 0 then
				inst:AddTag("INLIMBO")
			end
			
			inst:AddTag("snowpiledin")
			
			if inst.removetagtask == nil then
				inst.removetagtask = inst:DoTaskInTime(400, RemoveSnowedTag)
			end
		--end
	else
		--if inst.components.container == nil then
			--inst:AddComponent("container")
		--end
		
		inst:RemoveTag("INLIMBO")
	end
	
	
	inst.checktask = nil
	
	if GLOBAL.TheWorld.state.iswinter then
		if inst.checktask == nil then
			inst.checktask = inst:DoTaskInTime(2, CheckForSnow)
		end
	else
		inst:RemoveTag("snowpiledin")
		inst:RemoveTag("INLIMBO")
		if inst.removetagtask ~= nil then
			inst.removetagtask = nil
		end
	end
	
end

local function AddContainers(prefab)
    AddPrefabPostInit(prefab, function (inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
	
		inst.removetagtask = nil
		inst.checktask = nil
	
		inst:WatchWorldState("season", CheckForSnow)
		
    end)
end

for k, v in pairs(CONTAINERS) do
	AddContainers(v)
end


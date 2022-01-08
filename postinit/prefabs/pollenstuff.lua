local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

--Plants are categorically seperated into different groups having tags indicate their group.
--The groups change pollencount by different amounts.
local lowfever = 
{
	"grass",
	"sapling",
	"berrybush",
	"berrybush2",
	"reeds",
	"marsh_bush",
	"riceplant",
	"red_mushroom",
	"green_mushroom",
	"blue_mushroom",
	"bullkelp_plant",
	"sapling_moon",
	"rock_avocado_bush",
	"fruitdragon",
	"cave_fern",
	"flower_cave",
	"trapdoorgrass",
	"hooded_fern",
	"blueberryplant",
	"fruitbat",
	"carrot_planted",
}

local mediumfever = --Slightly larger radius, significantly more intensity 
{
	"berrybush_juicy",
	"flower",
	"butterfly",
	"flower_evil",
	"flower_rose",
	"evergreen",
	--"evergreen_sparse", --Sparse trees have no cones... they can't produce pollen.
	"leif",
	--"leif_sparse", --Sparse leifs also do not have cones.
	"deciduoustree",
	"twiggytree",
	"cave_banana_tree",
	"moon_tree",
	"moonbutterfly",
	"mushtree_medium",
	"mushtree_short",
	"mushtree_tall",
	"mushtree_moon",
	"mushgnome",
	"marsh_tree",
	"hooded_mushtree_medium",
	"hooded_mushtree_short",
	"hooded_mushtree_tall",
	"oceantree",
	"grassgator",
	"waterplant_baby",
	
	-- Farm Plants
	"farm_plant_carrot",
	"farm_plant_corn",
	"farm_plant_potato",
	"farm_plant_tomato",
	"farm_plant_asparagus",
	"farm_plant_eggplant",
	"farm_plant_pumpkin",
	"farm_plant_watermelon",
	"farm_plant_dragonfruit",
	"farm_plant_durian",
	"farm_plant_garlic",
	"farm_plant_onion",
	"farm_plant_pepper",
	"farm_plant_pomegranate",
}

local highfever = -- Similar intensity to mediumfever, large radius
{
	"oceantree_pillar",
	"watertree_pillar",
	"waterplant",
	"giant_tree",
	"giant_tree_infested",
	"mandrake_active",
	"mandrake_planted",
}

--Function that checks to see if it's spring and changes the build if it should.
--If it's not spring, it will change the build back.
local function SpringCheck(inst,isspring) --"isspring" can only be called from the event listener, the other areas do not have access to this value. Saving it for an fx for anim call when the world becomes spring.
	if TheWorld.state.isspring and inst.LushBuild then
		inst.AnimState:SetBuild(inst.LushBuild)
	elseif inst.OldBuild then
		inst.AnimState:SetBuild(inst.OldBuild)
	end
end

--Initializes inst.LushBuild and inst.OldBuild, which sets up certain plants for swapping builds when the season changes.
local function LushBuildInit(inst)
	if inst.prefab == "grass" then
		inst.LushBuild = "lush_grass"
		inst.OldBuild = "grass1"
	end
	if inst.prefab == "trapdoorgrass" then
		inst.LushBuild = "lush_trapdoorgrass"
		inst.OldBuild = "trapdoorgrass"
	end
	SpringCheck(inst)
end

local function SummonPollen(inst,range) --Makes the plant generate pollen if it's in lush season.
	local x,y,z = inst.Transform:GetWorldPosition()
	x = x + math.random(-range,range)
	z = z + math.random(-range,range)
	y = y + math.random(0, math.sqrt(range))
	local pollen = SpawnPrefab("uncompromising_pollen_fx")
	pollen.Transform:SetPosition(x,y,z)
end

local function PollenTask(inst) --Decides if a plant should release pollen, consider doing a search for number of pollen nearby
	if ((inst:HasTag("pollenlow") and math.random() > 0.6) or (inst:HasTag("pollenmed") and math.random() > 0.25) or (inst:HasTag("pollenhigh"))) and TheWorld.state.isspring then
		if inst:HasTag("pollenlow") then
			SummonPollen(inst,4)
		end
		if inst:HasTag("pollenmed") then
			SummonPollen(inst,5)
		end
		if inst:HasTag("pollenhigh") then
			SummonPollen(inst,10)
		end		
	end
end

local function PollenInit(inst) --inserts pollen generation into onwake for each of the plants, to prevent lag
	if inst.OnEntityWake ~= nil then
		inst._OnEntityWake = inst.OnEntityWake
	end
	local function OnEntityWakeNew(inst)
		inst.PollenTask = inst:DoPeriodicTask(2+math.random(2,5), PollenTask)
		--[[if inst._OnEntityWake ~= nil then
			inst._OnEntityWake(inst)
		end]]
	end
	inst.OnEntityWake = OnEntityWakeNew
	
	
	if inst.OnEntitySleep ~= nil then
		inst._OnEntitySleep = inst.OnEntitySleep
	end
	local function OnEntitySleepNew(inst)
		inst.PollenTask = nil
		--[[if inst._OnEntitySleep ~= nil then
			inst._OnEntitySleep(inst)
		end]]
	end
	inst.OnEntitySleep = OnEntitySleepNew
end


--Loops items in lowfever category, gives them their tags and makes them watch for build swaps.
for i, v in ipairs(lowfever) do
	env.AddPrefabPostInit(v, function(inst)	
		inst:AddTag("UM_pollen")
		inst:AddTag("pollenlow")
		local _OnLoad = inst.OnLoad
		local function NewOnLoad(inst,data)
			LushBuildInit(inst)
			if _OnLoad then
				_OnLoad(inst,data)
			end
		end
	
		inst.OnLoad = NewOnLoad
		PollenInit(inst)
		LushBuildInit(inst)
		inst:WatchWorldState("isspring", SpringCheck)
	end)
end

--Loops items in mediumfever category, gives them their tags and makes them watch for build swaps.
for i, v in ipairs(mediumfever) do
	env.AddPrefabPostInit(v, function(inst)	
		inst:AddTag("UM_pollen")
		inst:AddTag("pollenmed")
		local _OnLoad = inst.OnLoad
		local function NewOnLoad(inst,data)
			LushBuildInit(inst)
			if _OnLoad then
				_OnLoad(inst,data)
			end
		end
	
		inst.OnLoad = NewOnLoad
		PollenInit(inst)
		LushBuildInit(inst)
		inst:WatchWorldState("isspring", SpringCheck)
	end)
end

for i, v in ipairs(highfever) do
	env.AddPrefabPostInit(v, function(inst)	
		inst:AddTag("UM_pollen")
		inst:AddTag("pollenhigh")
		local _OnLoad = inst.OnLoad
		local function NewOnLoad(inst,data)
			LushBuildInit(inst)
			if _OnLoad then
				_OnLoad(inst,data)
			end
		end
	
		inst.OnLoad = NewOnLoad
		PollenInit(inst)
		LushBuildInit(inst)
		inst:WatchWorldState("isspring", SpringCheck)
	end)
end
GLOBAL.require("map/terrain")

------Turf Using Tile Adder From ADM's Turf Mod
modimport("tile_adder.lua")
local GROUND_OCEAN_COLOR = -- Color for the main island ground tiles 
{ 
    primary_color =         {  0,   0,   0,  25 }, 
    secondary_color =       { 0,  20,  33,  0 }, 
    secondary_color_dusk =  { 0,  20,  33,  80 }, 
    minimap_color =         { 46,  32,  18,  64 },
}



AddTile(
	"HOODEDFOREST",
	102,
	"hoodedmoss",
	{
		noise_texture = "levels/textures/noise_hoodedmoss.tex",
		runsound = "dontstarve/movement/walk_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
		colors = GROUND_OCEAN_COLOR,
	},
	{noise_texture = "levels/textures/mini_noise_hoodedmoss.tex"}
)
AddTile(
	"ANCIENTHOODEDFOREST",
	110,
	"ancienthoodedturf",
	{
		noise_texture = "levels/textures/noise_jungle.tex",
		runsound = "dontstarve/movement/walk_grass",
		walksound = "dontstarve/movement/walk_grass",
		snowsound = "dontstarve/movement/run_snow",
		mudsound = "dontstarve/movement/run_mud",
		colors = GROUND_OCEAN_COLOR,
	},
	{noise_texture = "levels/textures/mini_noise_jungle.tex"}
)

	local worldtiledefs = require 'worldtiledefs'
	
	local MOD_TURF_PROPERTIES =
	{
		[GROUND.HOODEDFOREST] = 	{name = "hoodedmoss", 	anim = "hoodedmoss", 	bank_build = "hfturf"},
		[GROUND.ANCIENTHOODEDFOREST] = {name = "ancienthoodedturf", 	anim = "ancienthoodedturf", 	bank_build = "hfturf"},
	}
	
	for k, v in pairs(MOD_TURF_PROPERTIES) do
		worldtiledefs.turf[k] = MOD_TURF_PROPERTIES[k]
	end
	
	ChangeTileTypeRenderOrder(GLOBAL.GROUND.HOODEDFOREST, GLOBAL.GROUND.DIRT)
	ChangeTileTypeRenderOrder(GLOBAL.GROUND.ANCIENTHOODEDFOREST, GLOBAL.GROUND.DIRT)
	
------


-- <<Cave Update WIP: Toggle at your own risk you buffoons! (That means you atoba, don't leak it please eh?)>>
-- I became a dev :sunglasses: - Atobá

--Ruins Split, using this for ratacombs too.
--[[AddLevelPreInitAny(function(level)
    if level.location == "cave" then
        level.overrides.keep_disconnected_tiles = true
		level.overrides.no_joining_islands = true
    end
end)]]

--[[
AddTaskPreInit("LichenLand",function(task) --This is the new "starting task" for the island (at least trying to make it that)
task.region_id = "RuinsIsland"
task.locks = {}
end)


local ruins_tasks = {
        "Residential",
        "Military",
        "Sacred",
        "TheLabyrinth",
        "SacredAltar",
        "AtriumMaze",
        "MoreAltars",
        "CaveJungle",
        "SacredDanger",
        "MilitaryPits",
        "MuddySacred",
		"Residential2",
		"Residential3",
}
for k, v in pairs(ruins_tasks) do
AddTaskPreInit(v,function(task)
task.region_id = "RuinsIsland"
end)
end

AddTaskPreInit("Residential2",function(task)
task.entrance_room = "BGSinkhole"
task.room_choices = {["BGSinkhole"] = 1}
end)
AddTaskPreInit("Residential3",function(task)
task.entrance_room = "BGSinkhole"
task.room_choices = {["BGSinkhole"] = 1}
end)

--Ruins Split
]]

if GetModConfigData("caved") == false then

    AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end

tasksetdata.set_pieces["ToadstoolArena"] = { 1, tasks={"Guarded Squeltch","Merms ahoy","Sane-Blocked Swamp","Squeltch","Swamp start","Tentacle-Blocked Spider Swamp",}}

end)

end

if GetModConfigData("trapdoorspiders") == true then
AddRoomPreInit("BGSavanna", function(room)					--This effects the outer areas of the Triple Mac and The Major Beefalo Plains
room.contents.countprefabs=
									{
										trapdoorspawner = function() return math.random(4,5) end,}
end)
AddRoomPreInit("Plain", function(room)						--This effects areas in the Major Beefalo Plains and the Grasslands next to the portal
room.contents.countprefabs=
									{
										trapdoorspawner = function() return math.random(2,4) end,} --returned number for whole area should be multiplied between 2-4 due to multiple rooms
end)
end

-----------Ghost Walrus
if GetModConfigData("ghostwalrus") ~= "disabled" then
	AddRoomPreInit("WalrusHut_Plains", function(room)					
	room.contents.countprefabs=
										{
											um_bear_trap_old = function() return math.random(6,8) end,
											ghost_walrus = function() return math.random(2,4) end,
											walrus_camp = 1,
											}
	end)

	AddRoomPreInit("WalrusHut_Grassy", function(room)					
	room.contents.countprefabs=
										{
											um_bear_trap_old = function() return math.random(6,8) end,
											ghost_walrus = function() return math.random(2,4) end,
											walrus_camp = 1,
											}
	end)

	AddRoomPreInit("WalrusHut_Rocky", function(room)					
	room.contents.countprefabs=
										{
											um_bear_trap_old = function() return math.random(6,8) end,
											ghost_walrus = function() return math.random(2,4) end,
											walrus_camp = 1,
											}
	end)
end
-----------Marsh Grass
AddRoomPreInit("BGMarsh", function(room)					
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(2,6) end,
										marshmist = function() return math.random(4,6) end,
										}
end)

AddRoomPreInit("Marsh", function(room)						
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(2,6) end,
										marshmist = function() return math.random(4,6) end,
										} 
end)

AddRoomPreInit("SpiderMarsh", function(room)				
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(4,8) end,
										marshmist = function() return math.random(4,6) end,
										}
end)

AddRoomPreInit("SlightlyMermySwamp", function(room)					
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(4,8) end,
										marshmist = function() return math.random(4,6) end,
										} 
end)

--Waffle's Specific Task Remover Code
AddTaskSetPreInitAny(function(tasksetdata)
  for _, task in pairs(tasksetdata.tasks) do
    if task == "ToadStoolTask1" then
      table.remove(tasksetdata.tasks, _)
    end
  end
end)

--Waffle's Specific Task Remover Code
AddTaskSetPreInitAny(function(tasksetdata)
  for _, task in pairs(tasksetdata.tasks) do
    if task == "ToadStoolTask2" then
      table.remove(tasksetdata.tasks, _)
    end
  end
end)

--Waffle's Specific Task Remover Code
AddTaskSetPreInitAny(function(tasksetdata)
  for _, task in pairs(tasksetdata.tasks) do
    if task == "ToadStoolTask3" then
      table.remove(tasksetdata.tasks, _)
    end
  end
end)
--Waffle's Specific Task Remover Code

AddRoomPreInit("RedMushPillars", function(room)			--red	
room.contents.countstaticlayouts = {
            ["ToadstoolArena"] = 1,
        }
end)
AddRoomPreInit("GreenMushNoise", function(room)		    --green		
room.contents.countstaticlayouts = {
            ["ToadstoolArena"] = 1,
        }
end)
AddRoomPreInit("DropperDesolation", function(room)	    --blue			
room.contents.countstaticlayouts = {
            ["ToadstoolArena"] = 1,
        }
end)

AddRoomPreInit("DeepDeciduous", function(room)
	room.contents.countprefabs.backupcatcoonden = 1
end)

-----KoreanWaffle's Spawner Limiter Tag Adding Code
--Add new map tags to storygen
local MapTags = {"scorpions", "hoodedcanopy","rattygas","ratkey1"}
AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    for k, v in pairs(MapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
    end
end)

--All the desert rooms. I excluded "DragonflyArena", "LightningBluffAntlion", and "LightningBluffOasis"
local deserts = { "BGBadlands", "Badlands", "HoundyBadlands", "BuzzardyBadlands", 
    "BGLightningBluff", "LightningBluffLightning" }

--Add "scorpions" room tag to all desert rooms
for k, v in pairs(deserts) do
    AddRoomPreInit(v, function(room)
        if not room.tags then
            room.tags = {"scorpions"}
        elseif room.tags then
            table.insert(room.tags, "scorpions")
        end
    end)
end


-----KoreanWaffle's Spawner Limiter Tag Adding Code
GLOBAL.require("map/rooms/forest/extraswamp")
if GetModConfigData("vetcurse") == "default" then
	AddTaskPreInit("Make a pick",function(task)
		GLOBAL.require("map/rooms/forest/challengespawner")
		task.room_choices["veteranshrine"] = 1
	end)
end


---- KoreanWaffle's LOCK/KEY initialization code  --Inactive atm 
local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS
local LOCKS_KEYS = GLOBAL.LOCKS_KEYS
--keys
local keycount = 0
for k, v in pairs(KEYS) do
    keycount = keycount + 1
end
KEYS["RICE"] = keycount + 1
KEYS["HF"] = keycount + 1

--locks
local lockcount = 0
for k, v in pairs(LOCKS) do
    lockcount = lockcount + 1
end
LOCKS["RICE"] = lockcount + 1
LOCKS["HF"] = lockcount + 1

--link keys to locks
LOCKS_KEYS[LOCKS.RICE] = {KEYS.RICE}
LOCKS_KEYS[LOCKS.HF] = {KEYS.HF}

if GetModConfigData("rice") then
	AddTaskPreInit("Squeltch",function(task)
		task.room_choices["ricepatch"] = 1 --Comment to test task based rice worldgen
		task.room_choices["densericepatch"] = 1      --Comment to test task based rice worldgen
	end)
end
if GetModConfigData("hoodedforest") then
GLOBAL.require("map/tasks/gianttrees")
end
--[[GLOBAL.require("map/tasks/ratacombs")
GLOBAL.require("map/rooms/caves/ratacombsrooms")
GLOBAL.require("map/rooms/forest/ratking")

if GetModConfigData("caved") == false then

    AddTaskSetPreInitAny(function(tasksetdata)
		if tasksetdata.location ~= "forest" then
			return
		end
		AddTaskPreInit("Dig that rock",function(task)
			task.room_choices["RatKingdom"] = 1
		end)
	end)
else
	AddTaskPreInit("Dig that rock",function(task)
		task.room_choices["RattySinkhole"] = 1
	end)
end]]

if GetModConfigData("hoodedforest") then
	AddTaskPreInit("Forest hunters",function(task) --Leave Forest Hunters in incase someone adds something to its setpieces.
		task.room_choices={
			["Forest"] = 1,
			["Clearing"] = 1,
	}
	end)
end
local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")

AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end
	if GetModConfigData("hoodedforest") then
		table.insert(tasksetdata.tasks,"GiantTrees")
	end
	if GetModConfigData("rice") then
	table.insert(tasksetdata.required_prefabs,"riceplantspawnerlarge")
	table.insert(tasksetdata.required_prefabs,"riceplantspawner")
	end
end)

	Layouts["hooded_town"] = StaticLayout.Get("map/static_layouts/hooded_town")
	Layouts["rose_garden"] = StaticLayout.Get("map/static_layouts/rose_garden")
	Layouts["hf_holidays"] = StaticLayout.Get("map/static_layouts/hf_holidays")

if GetModConfigData("hoodedforest") then
	AddRoomPreInit("HoodedTown", function(room)
		if not room.contents.countstaticlayouts then
			room.contents.countstaticlayouts = {}
		end
		room.contents.countstaticlayouts["hooded_town"] = 1
	end)

	AddRoomPreInit("RoseGarden", function(room)
		if not room.contents.countstaticlayouts then
			room.contents.countstaticlayouts = {}
		end
		room.contents.countstaticlayouts["rose_garden"] = 1
	end)

	AddRoomPreInit("HFHolidays", function(room)
		if not room.contents.countstaticlayouts then
			room.contents.countstaticlayouts = {}
		end
		room.contents.countstaticlayouts["hf_holidays"] = 1
	end)
end

if GetModConfigData("rice") then
AddLevelPreInitAny(function(level)
    if level.location == "forest" then
        level.overrides.keep_disconnected_tiles = true
    end
end)
	for i = 1,4 do
	Layouts["ricepatchsmall"..i] = StaticLayout.Get("map/static_layouts/ricepatchsmall"..i)
	end
	for i = 1,1 do
	Layouts["ricepatchlarge"..i] = StaticLayout.Get("map/static_layouts/ricepatchlarge"..i)
	end

	AddRoomPreInit("ricepatch", function(room)
		if not room.contents.countstaticlayouts then
			room.contents.countstaticlayouts = {}
		end
		local roomchoice = math.random(1,4)
		local roomchoice2 = roomchoice
		while roomchoice2 == roomchoice do
			roomchoice2 = math.random(1,4)
		end
		room.contents.countstaticlayouts["ricepatchsmall"..roomchoice] = 1
		if math.random() > 0.5 then
		room.contents.countstaticlayouts["ricepatchsmall"..roomchoice2] = 1
		end
	end)

	AddRoomPreInit("densericepatch", function(room)
		if not room.contents.countstaticlayouts then
			room.contents.countstaticlayouts = {}
		end
		room.contents.countstaticlayouts["ricepatchlarge1"] = 1
	end)
end
AddLevel(GLOBAL.LEVELTYPE.SURVIVAL, {
	id = "UNCOMPROMISING",
	name = GLOBAL.STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS.UNCOMPROMISING,
	desc = GLOBAL.STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC.UNCOMPROMISING,
	location = "forest",
	version = 4,
	overrides = {

		antliontribute = "more", --unnecessary
	},
})

local pawnrooms =
{
	"RuinedCity",
	"Vacant",
	"Barracks",
	"LabyrinthEntrance",
}

local damagedpawnrooms =
{
	"Labyrinth",
	"AtriumMazeEntrance",
}

for i, room in ipairs(pawnrooms) do
	AddRoomPreInit(room, function(room)
		if room.contents == nil then
			room.contents = {}
		end
		if room.contents.distributeprefabs == nil then
			room.contents.distributeprefabs = {}
		end
		room.contents.distributeprefabs.pawn_hopper = 0.20
	end)
end

for i, room in ipairs(damagedpawnrooms) do
	AddRoomPreInit(room, function(room)
		if room.contents == nil then
			room.contents = {}
		end
		if room.contents.distributeprefabs == nil then
			room.contents.distributeprefabs = {}
		end
		room.contents.distributeprefabs.pawn_hopper_nightmare = 0.20
	end)
end

if GetModConfigData("depthseels")then
	AddRoomPreInit("WetWilds", function(room)
			room.contents.countprefabs=
			{
				shockworm = function() return math.random(1,2) end
			}
	end)
end
if GetModConfigData("depthsvipers")then
	AddRoomPreInit("ThuleciteDebris", function(room)
		room.contents.countprefabs = 
		{
			viperworm =  function() return math.random(1,2) end
		}
	end)
end
modimport("init/init_food/init_food_worldgen")

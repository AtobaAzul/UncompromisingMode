GLOBAL.require("map/terrain")
if GetModConfigData("caveless") == false then

    AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end

tasksetdata.set_pieces["ToadstoolArena"] = { 1, tasks={"Guarded Squeltch","Merms ahoy","Sane-Blocked Swamp","Squeltch","Swamp start","Tentacle-Blocked Spider Swamp",}}

end)

end
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
-----------Marsh Grass
AddRoomPreInit("BGMarsh", function(room)					--This effects the outer areas of the Triple Mac and The Major Beefalo Plains
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(2,6) end,}
end)
AddRoomPreInit("Marsh", function(room)						--This effects areas in the Major Beefalo Plains and the Grasslands next to the portal
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(2,6) end,} --returned number for whole area should be multiplied between 2-4 due to multiple rooms
end)

AddRoomPreInit("SpiderMarsh", function(room)					--This effects the outer areas of the Triple Mac and The Major Beefalo Plains
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(4,8) end,}
end)
AddRoomPreInit("SlightlyMermySwamp", function(room)						--This effects areas in the Major Beefalo Plains and the Grasslands next to the portal
room.contents.countprefabs=
									{
										marsh_grass = function() return math.random(4,8) end,} --returned number for whole area should be multiplied between 2-4 due to multiple rooms
end)

-----KoreanWaffle's Spawner Limiter Tag Adding Code
--Add new map tags to storygen
local MapTags = {"scorpions"}

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
GLOBAL.require("map/rooms/forest/challengespawner")
GLOBAL.require("map/rooms/forest/extraswamp")
AddTaskPreInit("Make a pick",function(task)

task.room_choices["veteranshrine"] = 1

end)
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

--locks
local lockcount = 0
for k, v in pairs(LOCKS) do
    lockcount = lockcount + 1
end
LOCKS["RICE"] = lockcount + 1

--link keys to locks
LOCKS_KEYS[LOCKS.RICE] = {KEYS.RICE}

AddTaskPreInit("Squeltch",function(task)
task.room_choices["ricepatch"] = 1      --Comment to test task based rice worldgen

--table.insert(task.keys_given,KEYS.RICE)   Uncomment to test task based rice worldgen
end)
GLOBAL.require("map/tasks/newswamp")
AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end

--table.insert(tasksetdata.tasks,"RiceSqueltch")   Uncomment to test task based rice worldgen
end)
--GLOBAL.require("map/static_layouts/licepatch")
--[[local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")

Layouts["licepatch"] = StaticLayout.Get("map/static_layouts/licepatch")
AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end
tasksetdata.set_pieces["licepatch"] = {count = 1, tasks = {"Squeltch"}}
end)]]
--[[
("BarePlain", function(room)						If you want it to effect the desert area, uncomment this
room.contents.countprefabs=
									{
										trapdoor = function() return math.random(2,4) end,} --returned number for whole area should be multiplied between 2-4 due to multiple rooms
end)
--]]
--[[
	if GLOBAL.terrain.rooms.LightningBluffAntlion then
		GLOBAL.terrain.rooms.LightningBluffAntlion.contents.distributeprefabs.sandhill = 0.4
	end
	
	if GLOBAL.terrain.rooms.LightningBluffOasis then
	GLOBAL.terrain.rooms.LightningBluffOasis.contents.distributeprefabs.sandhill = 0.6
	end

	if GLOBAL.terrain.rooms.LightningBluffLightning then
		GLOBAL.terrain.rooms.LightningBluffLightning.contents.distributeprefabs.sandhill = 0.4
	end
	
	if GLOBAL.terrain.rooms.BGLightningBluff then
		GLOBAL.terrain.rooms.BGLightningBluff.contents.distributeprefabs.sandhill = 0.4
	end


	GLOBAL.terrain.filter.sandhill = {GLOBAL.GROUND.WOODFLOOR, GLOBAL.GROUND.CARPET, GLOBAL.GROUND.CHECKER, GLOBAL.GROUND.ROAD}
--]]

modimport("init/init_food/init_food_worldgen")

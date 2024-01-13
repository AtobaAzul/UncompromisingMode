GLOBAL.require("map/terrain")

------Turf Using Tile Adder From ADM's Turf Mod

local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
local STRINGS = GLOBAL.STRINGS

------
local GROUND_OCEAN_COLOR = {
    -- Color for the main island ground tiles
    primary_color = { 0, 0, 0, 25 },
    secondary_color = { 0, 20, 33, 0 },
    secondary_color_dusk = { 0, 20, 33, 80 },
    minimap_color = { 46, 32, 18, 64 }
}


AddTile("HOODEDFOREST", -- tile_name 1
    "LAND",             -- tile_range 2
    {
        -- tile_data 3
        ground_name = "hoodedmoss",
        old_static_id = 102
    }, {
        -- ground_tile_def 4
        name = "hoodedmoss.tex",
        atlas = "hoodedmoss.xml",
        noise_texture = "noise_hoodedmoss.tex",
        runsound = "dontstarve/movement/walk_grass",
        walksound = "dontstarve/movement/walk_grass",
        snowsound = "dontstarve/movement/run_snow",
        mudsound = "dontstarve/movement/run_mud",
        colors = GROUND_OCEAN_COLOR
    }, {
        -- minimap_tile_def 5
        name = "hoodedmoss.tex",
        atlas = "hoodedmoss.xml",
        noise_texture = "mini_noise_hoodedmoss.tex"
    }, {
        -- turf_def 6
        name = "hoodedmoss",
        anim = "hoodedmoss",
        bank_build = "hfturf"
    })

AddTile("ANCIENTHOODEDFOREST", "LAND", { ground_name = "ancienthoodedturf", old_static_id = 110 }, { name = "ancienthoodedturf.tex", atlas = "ancienthoodedturf.xml", noise_texture = "noise_jungle.tex", runsound = "dontstarve/movement/walk_grass", walksound = "dontstarve/movement/walk_grass", snowsound = "dontstarve/movement/run_snow", mudsound = "dontstarve/movement/run_mud", colors = GROUND_OCEAN_COLOR },
    { name = "ancienthoodedturf.tex", atlas = "ancienthoodedturf.xml", noise_texture = "mini_noise_jungle.tex" }, { name = "ancienthoodedturf", anim = "ancienthoodedturf", bank_build = "hfturf" })

AddTile("UM_FLOODWATER", "LAND", { ground_name = "um_floodwater", old_static_id = 112 }, { name = "um_floodwater", noise_texture = "noise_um_floodwater", runsound = "dontstarve/movement/run_marsh", walksound = "dontstarve/movement/walk_marsh", snowsound = "dontstarve/movement/run_marsh", mudsound = "dontstarve/movement/run_marsh", colors = GROUND_OCEAN_COLOR, cannotbedug = true }, { name = "map_edge", noise_texture = "mini_noise_um_floodwater" },
    { name = "ancienthoodedturf", anim = "ancienthoodedturf", bank_build = "hfturf" })

--[[
AddTile(
    "MAGMA_ROCK", --tile_name 1
    "LAND", --tile_range 2
    { --tile_data 3
        ground_name = "magma_rock",
    },
    { --ground_tile_def 4
        name = "rocky.tex",
        atlas = "rocky.xml",
        noise_texture = "ground_lava_rock.tex",
        runsound = "dontstarve/movement/run_rock",
        walksound = "dontstarve/movement/walk_rock",
        snowsound = "dontstarve/movement/run_ice",
        mudsound = "dontstarve/movement/run_mud",
        colors = GROUND_OCEAN_COLOR
    },
    { --minimap_tile_def 5
        name = "map_edge.tex",
        atlas = "ancienthoodedturf.xml",
        noise_texture = "mini_ground_lava_rock.tex"
    },
    { --turf_def 6
        name = "magma_rock",
        anim = "magma_rock",
        bank_build = "turf_archives"
    }
)


AddTile(
    "MAGMA_ASH", --tile_name 1
    "LAND", --tile_range 2
    { --tile_data 3
        ground_name = "magma_ash",
    },
    { --ground_tile_def 4
        name = "rocky.tex",
        atlas = "rocky.xml",
        noise_texture = "ground_ash.tex",
        runsound = "dontstarve/movement/run_rock",
        walksound = "dontstarve/movement/walk_rock",
        snowsound = "dontstarve/movement/run_ice",
        mudsound = "dontstarve/movement/run_mud",
        colors = GROUND_OCEAN_COLOR
    },
    { --minimap_tile_def 5
        name = "map_edge.tex",
        atlas = "ancienthoodedturf.xml",
        noise_texture = "mini_ash.tex"
    },
    { --turf_def 6
        name = "magma_ash",
        anim = "magma_ash",
        bank_build = "turf_archives"
    }
)

ChangeTileRenderOrder(GLOBAL.WORLD_TILES.MAGMA_ROCK, GLOBAL.WORLD_TILES.DIRT)
ChangeTileRenderOrder(GLOBAL.WORLD_TILES.MAGMA_ASH, GLOBAL.WORLD_TILES.DIRT)]]
ChangeTileRenderOrder(GLOBAL.WORLD_TILES.HOODEDFOREST, GLOBAL.WORLD_TILES.DIRT)
ChangeTileRenderOrder(GLOBAL.WORLD_TILES.ANCIENTHOODEDFOREST, GLOBAL.WORLD_TILES.DIRT)

ChangeMiniMapTileRenderOrder(GLOBAL.WORLD_TILES.HOODEDFOREST, GLOBAL.WORLD_TILES.DIRT)
ChangeMiniMapTileRenderOrder(GLOBAL.WORLD_TILES.ANCIENTHOODEDFOREST, GLOBAL.WORLD_TILES.DIRT)

--[[local batplaces ={
	"batplaces",
	"BattyCave",
	"FernyBatCave",
	"BGBatCave",
	"BGBatCaveRoom",
	"PitRoom",
}

for i,v in ipairs(batplaces) do
	AddRoomPreInit(v,
	function(room) --This effects the outer areas of the Triple Mac and The Major Beefalo Plains
		room.value = WORLD_TILES.MAGMA_ASH
		if not room.contents.distributeprefabs then
			room.contents.distributeprefabs = {}
			room.contents.distributepercent = .13
		end
		room.contents.distributeprefabs.umss_general = 0.3


		if not room.contents.prefabdata then
			room.contents.prefabdata = {}
		end
		room.contents.prefabdata.umss_general = function() return {table = "MAGMASPLOTCH"..math.random(1,4)} end
	end)
end]]
--[[
GLOBAL.require("map/rooms/caves/moltenregions")

AddTaskPreInit("BigBatCave",
	function(task) --Leave Forest Hunters in incase someone adds something to its setpieces.
    task.room_choices={
        ["MoltenBatCave"] = 3,
        ["MoltenBattyCave"] = 1,
        ["MoltenFernyBatCave"] = 2,
        ["PitRoom"] = 4,
    }
    task.background_room="BGMoltenBatCaveRoom"
    task.room_bg=WORLD_TILES.MAGMA_ASH
end)]]
if GetModConfigData("worldgenmastertoggle") then
    -- <<Cave Update WIP: Toggle at your own risk you buffoons! (That means you atoba, don't leak it please eh?)>>
    -- I became a dev :sunglasses: - Atobá

    -- Ruins Split, using this for ratacombs too.
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
    AddTaskSetPreInitAny(function(tasksetdata)
        if tasksetdata.location ~= "forest" then
            return
        end

        if (tasksetdata.name == STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.SHIPWRECKED) then
            if GetModConfigData("hoodedforest") then
                table.insert(tasksetdata.tasks, "GiantTrees_IA")
            end
            return
        end

        if GetModConfigData("hoodedforest") then
            table.insert(tasksetdata.tasks, "GiantTrees")
        end

        if GetModConfigData("rice") then
            table.insert(tasksetdata.required_prefabs, "riceplantspawnerlarge")
            table.insert(tasksetdata.required_prefabs, "riceplantspawner")
        end

        if GetModConfigData("wixie_walter") then
            table.insert(tasksetdata.required_prefabs, "wixie_wardrobe") -- Make sure wixie appears.
            table.insert(tasksetdata.required_prefabs, "wixie_clock")
            table.insert(tasksetdata.required_prefabs, "wixie_piano")
            table.insert(tasksetdata.required_prefabs, "charles_t_horse")
        end
    end)

    --if GetModConfigData("caved") == false then
        --AddTaskSetPreInitAny(function(tasksetdata)
            --if tasksetdata.location ~= "forest" then
                --return
            --end
            --if (tasksetdata.name == STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.SHIPWRECKED) then
                --tasksetdata.set_pieces["ToadstoolArena"] = { 1, tasks = { "ThemeMarshCity" } }
                --return
            --end

            --tasksetdata.set_pieces["ToadstoolArena"] = { 1, tasks = { "Guarded Squeltch", "Merms ahoy", "Sane-Blocked Swamp", "Squeltch", "Swamp start", "Tentacle-Blocked Spider Swamp" } }
        --end)
    --end

    Layouts["basefrag_smellykitchen"] = StaticLayout.Get("map/static_layouts/umss_basefrag_smellykitchen")
    Layouts["basefrag_rattystorage"] = StaticLayout.Get("map/static_layouts/umss_basefrag_rattystorage")
    Layouts["moonfrag"] = StaticLayout.Get("map/static_layouts/umss_moonfrag")
    Layouts["utw_biomespawner"] = StaticLayout.Get("map/static_layouts/utw_biomespawner")
    Layouts["impactfuldiscovery"] = StaticLayout.Get("map/static_layouts/umss_impactfuldiscovery")
    Layouts["boon_moonoil"] = StaticLayout.Get("map/static_layouts/umss_moonoil")
    Layouts["umss_biometable"] = StaticLayout.Get("map/static_layouts/umss_biometable")

    AddTaskSetPreInitAny(function(tasksetdata)
        if tasksetdata.location ~= "forest" or (tasksetdata.name == STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.VOLCANO or tasksetdata.name == STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.SHIPWRECKED) then
            return
        end

        tasksetdata.set_pieces["umss_biometable"] = {
            count = math.random(3, 5),
            tasks = {
                "Make a pick",
                -- "Dig that rock",
                "Great Plains",
                "Squeltch",
                "Beeeees!",
                "Speak to the king",
                "Forest hunters",
                "For a nice walk",
                "Badlands",
                "Lightning Bluff",
                "Befriend the pigs",
                "Kill the spiders",
                "Killer bees!",
                "Make a Beehat",
                "The hunters",
                "Magic meadow",
                "Frogs and bugs",
                "Mole Colony Deciduous",
                "Mole Colony Rocks",
                "MooseBreedingTask",
                "Speak to the king classic",
                "GiantTrees"
            }
        }

        if tasksetdata.ocean_prefill_setpieces ~= nil then
            tasksetdata.ocean_prefill_setpieces["utw_biomespawner"] = { count = math.random(6, 9) }
        end -- nice
    end)

    if GetModConfigData("trapdoorspiders") then
        AddRoomPreInit("BGSavanna", function(room) -- This effects the outer areas of the Triple Mac and The Major Beefalo Plains
            room.contents.countprefabs = { trapdoorspawner = function() return math.random(4, 5) end }
        end)
        AddRoomPreInit("Plain", function(room)                                                       -- This effects areas in the Major Beefalo Plains and the Grasslands next to the portal
            room.contents.countprefabs = { trapdoorspawner = function() return math.random(2, 4) end } -- returned number for whole area should be multiplied between 2-4 due to multiple rooms
        end)
    end

    AddRoomPreInit("BGLightningBluff", function(room) -- Oasis Desert Has Scorpion Organizers which determine how their burrowing should change.....
        room.contents.countprefabs = { um_scorpionhole = math.random(0, 1) }
    end)

    AddTaskPreInit("Lightning Bluff", function(task)
        GLOBAL.require("map/rooms/forest/UM_LightningBluff")
        task.room_choices["LightningBluff_Scorpion"] = function() return math.random(3, 4) end
    end)

    -----------Ghost Walrus
    if GetModConfigData("ghostwalrus") ~= "disabled" then
        AddRoomPreInit("WalrusHut_Plains", function(room) room.contents.countprefabs = { um_bear_trap_old = function() return math.random(6, 8) end, ghost_walrus = function() return math.random(2, 4) end, walrus_camp = 1 } end)

        AddRoomPreInit("WalrusHut_Grassy", function(room) room.contents.countprefabs = { um_bear_trap_old = function() return math.random(6, 8) end, ghost_walrus = function() return math.random(2, 4) end, walrus_camp = 1 } end)

        AddRoomPreInit("WalrusHut_Rocky", function(room) room.contents.countprefabs = { um_bear_trap_old = function() return math.random(6, 8) end, ghost_walrus = function() return math.random(2, 4) end, walrus_camp = 1 } end)
    end
    -----------Marsh Grass
    AddRoomPreInit("BGMarsh", function(room) room.contents.countprefabs = { marsh_grass = function() return math.random(2, 6) end, marshmist = function() return math.random(4, 6) end } end)

    AddRoomPreInit("Marsh", function(room) room.contents.countprefabs = { marsh_grass = function() return math.random(2, 6) end, marshmist = function() return math.random(4, 6) end } end)

    AddRoomPreInit("SpiderMarsh", function(room) room.contents.countprefabs = { marsh_grass = function() return math.random(4, 8) end, marshmist = function() return math.random(4, 6) end } end)

    AddRoomPreInit("SlightlyMermySwamp", function(room) room.contents.countprefabs = { marsh_grass = function() return math.random(4, 8) end, marshmist = function() return math.random(4, 6) end } end)

    -- Waffle's Specific Task Remover Code
    AddTaskSetPreInitAny(function(tasksetdata)
        for _, task in pairs(tasksetdata.tasks) do
            if task == "ToadStoolTask1" then
                table.remove(tasksetdata.tasks, _)
            end
        end
    end)

    AddTaskSetPreInitAny(function(tasksetdata)
        for _, task in pairs(tasksetdata.tasks) do
            if task == "ToadStoolTask2" then
                table.remove(tasksetdata.tasks, _)
            end
        end
    end)

    AddTaskSetPreInitAny(function(tasksetdata)
        for _, task in pairs(tasksetdata.tasks) do
            if task == "ToadStoolTask3" then
                table.remove(tasksetdata.tasks, _)
            end
        end
    end)
    -- Waffle's Specific Task Remover Code

    AddRoomPreInit("RedMushPillars", function(room) -- red
        room.contents.countstaticlayouts = { ["ToadstoolArena"] = 1 }
    end)

    AddRoomPreInit("GreenMushNoise", function(room) -- green
        room.contents.countstaticlayouts = { ["ToadstoolArena"] = 1 }
    end)
    AddRoomPreInit("DropperDesolation", function(room) -- blue
        room.contents.countstaticlayouts = { ["ToadstoolArena"] = 1 }
    end)

    AddRoomPreInit("DeepDeciduous", function(room) room.contents.countprefabs.backupcatcoonden = 1 end)

    -----KoreanWaffle's Spawner Limiter Tag Adding Code
    -- Add new map tags to storygen
    local MapTags = { "scorpions", "hoodedcanopy", "rattygas", "ratkey1", "mosaic" }
    AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
        for k, v in pairs(MapTags) do
            self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
        end
    end)

    -- All the desert rooms. I excluded "DragonflyArena", "LightningBluffAntlion", and "LightningBluffOasis"
    local deserts = { "BGBadlands", "Badlands", "HoundyBadlands", "BuzzardyBadlands", "BGLightningBluff", "LightningBluffLightning" }

    -- Add "scorpions" room tag to all desert rooms
    for k, v in pairs(deserts) do
        AddRoomPreInit(v, function(room)
            if not room.tags then
                room.tags = { "scorpions" }
            elseif room.tags then
                table.insert(room.tags, "scorpions")
            end
        end)
    end

    local meteorIsh = { "BGNoise", "Rocky", "CritterDen", "Graveyard" }

    -- Add "mosaic" room tag to all mosaic rooms
    for k, v in pairs(meteorIsh) do
        AddRoomPreInit(v, function(room)
            if not room.tags then
                room.tags = { "mosaic" }
            elseif room.tags then
                table.insert(room.tags, "mosaic")
            end
        end)
    end

    -----KoreanWaffle's Spawner Limiter Tag Adding Code
    GLOBAL.require("map/rooms/forest/extraswamp")
    if GetModConfigData("vetcurse") == "default" then
        AddTaskPreInit("Make a pick", function(task)
            GLOBAL.require("map/rooms/forest/challengespawner")
            task.room_choices["veteranshrine"] = 1
        end)
    end
    ---- KoreanWaffle's LOCK/KEY initialization code  --Inactive atm
    local LOCKS = GLOBAL.LOCKS
    local KEYS = GLOBAL.KEYS
    local LOCKS_KEYS = GLOBAL.LOCKS_KEYS
    -- keys
    local keycount = 0
    for k, v in pairs(KEYS) do
        keycount = keycount + 1
    end
    KEYS["RICE"] = keycount + 1
    KEYS["HF"] = keycount + 1

    -- locks
    local lockcount = 0
    for k, v in pairs(LOCKS) do
        lockcount = lockcount + 1
    end
    LOCKS["RICE"] = lockcount + 1
    LOCKS["HF"] = lockcount + 1

    -- link keys to locks
    LOCKS_KEYS[LOCKS.RICE] = { KEYS.RICE }
    LOCKS_KEYS[LOCKS.HF] = { KEYS.HF }

    if GetModConfigData("rice") then
        AddTaskPreInit("Squeltch", function(task)
            task.room_choices["ricepatch"] = 1      -- Comment to test task based rice worldgen
            task.room_choices["densericepatch"] = 1 -- Comment to test task based rice worldgen
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
            if tasksetdata.location ~= "forest" or (tasksetdata.name == STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.VOLCANO or tasksetdata.name == STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.SHIPWRECKED) then
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
        AddTaskPreInit("Forest hunters", function(task) -- Leave Forest Hunters in incase someone adds something to its setpieces.
            task.room_choices = { ["Forest"] = 1, ["Clearing"] = 1 }
        end)
    end

    --[[
        AddTaskSetPreInitAny(function(tasksetdata)
            if tasksetdata.location ~= "cave" then
                return
            end
            table.insert(tasksetdata.tasks,"Ratty_Entrance")
            table.insert(tasksetdata.tasks,"Ratty_Link")
            table.insert(tasksetdata.tasks,"Ratty_Maze")
            table.insert(tasksetdata.tasks,"Ratty_Maze")
            table.insert(tasksetdata.tasks,"Ratty_Maze2")
            table.insert(tasksetdata.tasks,"Ratty_Maze3")

            if tasksetdata.required_prefabs ~= nil then
                table.insert(tasksetdata.required_prefabs,"ratking")
                table.insert(tasksetdata.required_prefabs,"ratacombslock")
            else
                tasksetdata.required_prefabs = {"ratking","ratacombslock"}
            end
        end)]]
    Layouts["hooded_town"] = StaticLayout.Get("map/static_layouts/hooded_town")
    Layouts["rose_garden"] = StaticLayout.Get("map/static_layouts/rose_garden")
    Layouts["hf_holidays"] = StaticLayout.Get("map/static_layouts/hf_holidays")

    Layouts["RatLockBlocker1"] = { type = GLOBAL.LAYOUT.CIRCLE_EDGE, start_mask = GLOBAL.PLACE_MASK.NORMAL, fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED, layout_position = GLOBAL.LAYOUT_POSITION.CENTER, ground_types = { GLOBAL.WORLD_TILES.ROCKY }, defs = { rocks = { "ratacombslock_rock_spawner" } }, count = { rocks = 1 }, scale = 0.1 }

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
        for i = 1, 4 do
            Layouts["ricepatchsmall" .. i] = StaticLayout.Get("map/static_layouts/ricepatchsmall" .. i)
        end
        for i = 1, 1 do
            Layouts["ricepatchlarge" .. i] = StaticLayout.Get("map/static_layouts/ricepatchlarge" .. i)
        end

        AddRoomPreInit("ricepatch", function(room)
            if not room.contents.countstaticlayouts then
                room.contents.countstaticlayouts = {}
            end
            local roomchoice = math.random(1, 4)
            local roomchoice2 = roomchoice
            while roomchoice2 == roomchoice do
                roomchoice2 = math.random(1, 4)
            end
            room.contents.countstaticlayouts["ricepatchsmall" .. roomchoice] = 1
            if math.random() > 0.5 then
                room.contents.countstaticlayouts["ricepatchsmall" .. roomchoice2] = 1
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
            antliontribute = "more" -- unnecessary
        }
    })

    local pawnrooms = { "RuinedCity", "Vacant", "Barracks", "LabyrinthEntrance" }

    local damagedpawnrooms = { "Labyrinth", "AtriumMazeEntrance" }

    for i, room in ipairs(pawnrooms) do
        AddRoomPreInit(room, function(room)
            if room.contents == nil then
                room.contents = {}
            end
            if room.contents.distributeprefabs == nil then
                room.contents.distributeprefabs = {}
            end
            room.contents.distributeprefabs.pawn_hopper = 0.133
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
            room.contents.distributeprefabs.pawn_hopper_nightmare = 0.2
        end)
    end

    if GetModConfigData("depthseels") then
        AddRoomPreInit("WetWilds", function(room) room.contents.countprefabs = { shockworm_spawner = function() return math.random(2, 4) end } end)
    end

    if GetModConfigData("depthsvipers") then
        AddRoomPreInit("ThuleciteDebris", function(room) room.contents.countprefabs = { viperworm_spawner = function() return math.random(2, 4) end } end)
    end

    --[[AddRoomPreInit("CritterDen", function(room)
        if not room.contents.countstaticlayouts then
            room.contents.countstaticlayouts = {}
        end
        room.contents.countstaticlayouts["impactfuldiscovery"] = 1
    end)]]
    AddRoomPreInit("OceanCoastal", function(room) room.contents.countprefabs = { ums_biometable = 1 } end)

    -- WIXIE PUZZLE SETS

    --[[Layouts["wixie_puzzle"] = StaticLayout.Get("map/static_layouts/wixie_puzzle")

	AddRoomPreInit("DeepDeciduous", function(room)
        room.contents.countstaticlayouts =
        {
            ["wixie_puzzle"] = 1
        }
    end)]]
    AddTaskPreInit("Make a pick", function(task)
        if GetModConfigData("vetcurse") then
            GLOBAL.require("map/rooms/forest/challengespawner")
        end

        if GetModConfigData("wixie_walter") then
            task.room_choices["wixie_puzzlearea"] = 1
        end
    end)

    local IA_SPAWN_TASKS = { "HomeIslandVerySmall", "HomeIslandSmall", "HomeIslandSmallBoon", "HomeIslandSingleTree", "HomeIslandMed", "HomeIslandLarge", "HomeIslandLargeBoon" }
    for k, v in ipairs(IA_SPAWN_TASKS) do
        AddTaskPreInit(v, function(task)
            GLOBAL.require("map/rooms/forest/challengespawner")
            if GetModConfigData("wixie_walter") then
                task.room_choices["wixie_puzzlearea_ia"] = 1
            end
            if GetModConfigData("vetcurse") then
                task.room_choices["veteranshrine_ia"] = 1
            end
        end)
    end

    -- WIXIE PUZZLE SETS

    modimport("init/init_food/init_food_worldgen")

    AddRoomPreInit("OceanSwell", function(room) room.contents.countprefabs = { siren_teaser_picker = 1, ums_biometable = 1 } end)
    AddRoomPreInit("OceanRough", function(room) room.contents.countprefabs = { siren_teaser_picker = 2 } end)

    --IA compat for tornadoes.
    AddRoomPreInit("OceanMedium", function(room) room.contents.countprefabs = { siren_teaser_picker = 3 } end)

    local ocean_deep =
    {
        "OceanSwell",
        "OceanRough",
        "OceanHazardous"
    }

    for k, v in ipairs(ocean_deep) do
        AddRoomPreInit(v, function(room)
            if room.contents.distributeprefabs == nil then
                room.contents.distributeprefabs = {}
            end
            room.contents.distributeprefabs.oceanfishableflotsam_water = 0.15
        end)
    end
end

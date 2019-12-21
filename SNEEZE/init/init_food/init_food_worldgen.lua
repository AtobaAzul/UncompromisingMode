if GetModConfigData("gamemode") == GAMEMODE_UNCOMPROMISING or
	(GetModConfigData("gamemode") == GAMEMODE_CUSTOM_SETTINGS and GetModConfigData("rare_food")) then
    -----------------------------------------------------------------
    -- Carrots, mushroos and berry bushs are rare now
    -- Relevant: regrowthmanager.lua, map\rooms
    -- red_mushroom 
    -- blue_mushroom
    -- green_mushroom 
    -- berrybush
    -- berrybush_juicy 
    -- carrot_planted 
    -----------------------------------------------------------------
    modimport("init/init_tuning")
    local CHANGED_ROOMS = 
    {
        "BGGrass",
        "START",
        --mostly carrots
        "RabbitArea",
        "RabbitTown",
        "RabbitSinkhole",
        --generic
        "MooseGooseBreedingGrounds",
        "MagicalDeciduous",
        "DeciduousClearing",
        "BGDeciduous",
        "DeepDeciduous",
        "SpiderIncursion",
        "DropperDesolation",
        "RuinedCityEntrance",
        "BeeQueenBee",
        --blue mush
        "BlueMushForest",
        "BlueMushMeadow",
        "BlueSpiderForest",
        "BGBlueMush",
        "BGBlueMushRoom",
        --fungus noise
        "FungusNoiseForest",
        "FungusNoiseMeadow",
        --green mush
        "GreenMushMeadow",
        "GreenMushNoise",
        "GreenMushForest",
        "GreenMushPonds",
        "GreenMushSinkhole",
        "GreenMushRabbits",
        "BGGreenMush",
        "BGGreenMushRoom",
        --red mush
        "RedMushForest",
        "RedSpiderForest",
        "RedMushPillars",
        "BGRedMush",
        "BGRedMushRoom",
    }

    local function ChangeSpawnRates(room)
        if room ~= nil and room.contents.distributeprefabs ~= nil and (not room.uncompromisingly_changed) then
            if room.contents.distributeprefabs.carrot_planted ~= nil then 
                room.contents.distributeprefabs.carrot_planted = room.contents.distributeprefabs.carrot_planted * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  
            end
            if room.contents.distributeprefabs.berrybush ~= nil then 
                room.contents.distributeprefabs.berrybush = room.contents.distributeprefabs.berrybush * GLOBAL.TUNING.DSTU.FOOD_BERRY_NORMAL_APPEARANCE_PERCENT  
            end
            if room.contents.distributeprefabs.berrybush_juicy ~= nil then 
                room.contents.distributeprefabs.berrybush_juicy = room.contents.distributeprefabs.berrybush_juicy * GLOBAL.TUNING.DSTU.FOOD_BERRY_JUICY_APPEARANCE_PERCENT  
            end
            if room.contents.distributeprefabs.green_mushroom ~= nil then 
                room.contents.distributeprefabs.green_mushroom = room.contents.distributeprefabs.green_mushroom * GLOBAL.TUNING.DSTU.FOOD_MUSHROOM_GREEN_APPEARANCE_PERCENT  
            end
            if room.contents.distributeprefabs.blue_mushroom ~= nil then 
                room.contents.distributeprefabs.blue_mushroom = room.contents.distributeprefabs.blue_mushroom * GLOBAL.TUNING.DSTU.FOOD_MUSHROOM_BLUE_APPEARANCE_PERCENT  
            end
            if room.contents.distributeprefabs.red_mushroom ~= nil then 
                room.contents.distributeprefabs.red_mushroom = room.contents.distributeprefabs.red_mushroom * GLOBAL.TUNING.DSTU.FOOD_MUSHROOM_RED_APPEARANCE_PERCENT  
            end 
            room.uncompromisingly_changed = true
        end
    end

    for k, v in pairs(CHANGED_ROOMS) do
        AddRoomPreInit(v, function(room)
            ChangeSpawnRates(room)
        end)
    end
end
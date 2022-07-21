require("map/rooms/forest/extraswamp")

AddTask("RiceSqueltch", {
    locks = {LOCKS.TIER3},
    keys_given = {},
    -- region_id = "ricearea",
    level_set_piece_blocker = true,
    room_choices = {
        -- ["Marsh"] = function() return 5+math.random(SIZE_VARIATION) end, 
        -- ["Forest"] = function() return math.random(SIZE_VARIATION) end, 
        -- ["DeepForest"] = function() return 1+math.random(SIZE_VARIATION) end,
        ["sparsericepatch"] = 1
    },
    room_bg = WORLD_TILES.MARSH,
    background_room = "sparsericepatch",
    colour = {
        r = .05,
        g = .05,
        b = .05,
        a = 1
    }
})

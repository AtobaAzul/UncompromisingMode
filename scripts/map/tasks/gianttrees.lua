require("map/rooms/forest/gianttreesrooms")

AddTask("GiantTrees", {
    locks = {LOCKS.ADVANCED_COMBAT, LOCKS.MONSTERS_DEFEATED, LOCKS.TIER5},
    keys_given = {KEYS.HF},
    -- region_id = "hoodedforest",
    level_set_piece_blocker = true,
    room_choices = {
        ["GiantTrees"] = 1,
        ["RoseGarden"] = 1,
        ["AphidLand"] = 1,
        -- ["RoadGiantTrees"] = 1,
        ["WalrusGiantTrees"] = 1,
        ["MoonBaseGiantTrees"] = 1,
        ["ShroomInfestedGiantTrees"] = 1,
        ["SnapDragons"] = 1,
        ["SpideryGiantTrees"] = 1,
        ["HoodedTown"] = 1,
        ["HFHolidays"] = 1
    },
    room_bg = WORLD_TILES.HOODEDFOREST,
    background_room = "BGGiantTrees",
    colour = {
        r = .1,
        g = .1,
        b = .1,
        a = 1
    }
})

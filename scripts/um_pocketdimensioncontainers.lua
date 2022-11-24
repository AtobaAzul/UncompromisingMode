local POCKETDIMENSIONCONTAINER_DEFS = require("prefabs/pocketdimensioncontainer_defs").POCKETDIMENSIONCONTAINER_DEFS

local UM_POCKETDIMS = {
    { --this def works
        name = "skull",
        prefab = "skullchest",
        ui = "anim/ui_portal_shadow_3x4.zip",
        widgetname = "skullchest",
    },
    { --but this one doesn't??
        name = "winky",
        prefab = "uncompromising_winkyburrow_master",
        ui = "anim/ui_portal_shadow_3x4.zip",
        widgetname = "winkyburrow",
    },
}

for k,v in pairs(UM_POCKETDIMS) do
    table.insert(POCKETDIMENSIONCONTAINER_DEFS, v)
end
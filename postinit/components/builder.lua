local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local TechTree = require("techtree")


local PROTOTYPER_TAGS = { "prototyper" }

env.AddComponentPostInit("builder", function(self)
    table.remove(self.exclude_tags, 7)
end)

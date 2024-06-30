local env = env
GLOBAL.setfenv(1, GLOBAL)

local fn = require("generatorcharging")


env.AddPrefabPostInit("nightstick", fn)
env.AddPrefabPostInit("bugzapper", fn)
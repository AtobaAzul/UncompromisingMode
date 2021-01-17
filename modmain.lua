local require = GLOBAL.require

PrefabFiles = require("uncompromising_prefabs")

--Start the game mode
modimport("init/init_gamemodes/init_uncompromising_mode")

GLOBAL.FUELTYPE.BATTERYPOWER = "BATTERYPOWER"
GLOBAL.FUELTYPE.SWEATERPOWER = "SWEATERPOWER"

local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local MOD_FERTILIZER_DEFS = {}
FERTILIZER_DEFS.purple_vomit = {nutrients = TUNING.DSTU.PURPLE_VOMIT_NUTRIENTS}
FERTILIZER_DEFS.orange_vomit = {nutrients = TUNING.DSTU.ORANGE_VOMIT_NUTRIENTS}
FERTILIZER_DEFS.yellow_vomit = {nutrients = TUNING.DSTU.YELLOW_VOMIT_NUTRIENTS}
FERTILIZER_DEFS.red_vomit = {nutrients = TUNING.DSTU.RED_VOMIT_NUTRIENTS}
FERTILIZER_DEFS.green_vomit = {nutrients = TUNING.DSTU.GREEN_VOMIT_NUTRIENTS}
FERTILIZER_DEFS.pink_vomit = {nutrients = TUNING.DSTU.PINK_VOMIT_NUTRIENTS}
FERTILIZER_DEFS.pale_vomit = {nutrients = TUNING.DSTU.PALE_VOMIT_NUTRIENTS}

for k, v in pairs(MOD_FERTILIZER_DEFS) do
    FERTILIZER_DEFS[k] = v
end

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Stop", function(...)
	print("RPC Hayfever_Stop")
	GLOBAL.TheWorld:PushEvent("beequeenkilled")
end)

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Start", function(...)
	print("RPC Hayfever_Start")
	GLOBAL.TheWorld:PushEvent("beequeenrespawned")
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsDeath", function(...)
	print("RPC DeerclopsDeath")
	GLOBAL.TheWorld:PushEvent("hasslerkilled")
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsRemoved", function(...)
	print("RPC DeerclopsRemoved")
	GLOBAL.TheWorld:PushEvent("hasslerremoved")
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsStored", function(...)
	print("RPC DeerclopsStored")
	GLOBAL.TheWorld:PushEvent("storehassler")
end)
--[[
AddShardModRPCHandler("UncompromisingSurvival", "AcidMushroomsUpdate", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("acidmushroomsdirty", {shard_id = shard_id, uuid = data.uuid, targets = data.targets})
end)

AddShardModRPCHandler("UncompromisingSurvival", "AcidMushroomsTargetFinished", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("master_acidmushroomsfinished", data)
end)]]
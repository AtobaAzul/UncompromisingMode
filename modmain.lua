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

local function Effects_Stop()
print("Effects_Stop")
GLOBAL.TheWorld.components.hayfever_tracker:QueenTrue()
	GLOBAL.TheWorld:PushEvent("beequeenkilled")
end

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Stop", function()

GLOBAL.TheWorld.components.hayfever_tracker:QueenFalse()
	GLOBAL.TheWorld:PushEvent("beequeenrespawned")
end)

local function SendQueenDieRPC()
print("SendQueenDieRPC")
	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "Hayfever_Stop"))
end

GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_V, SendQueenDieRPC)

local function Effects_Start()
print("Effects_Start")

GLOBAL.TheWorld.components.hayfever_tracker:QueenFalse()
	GLOBAL.TheWorld:PushEvent("beequeenrespawned")
end

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Start", function()
GLOBAL.TheWorld.components.hayfever_tracker:QueenFalse()
	GLOBAL.TheWorld:PushEvent("beequeenrespawned")

end)

local function SendQueenRespawnedRPC()
print("SendQueenRespawnedRPC")
	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "Hayfever_Start"))
end

GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_B, SendQueenRespawnedRPC)
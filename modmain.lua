local require = GLOBAL.require

PrefabFiles = require("uncompromising_prefabs")
PreloadAssets = {
	Asset( "IMAGE", "images/UM_tip_icon.tex" ),
	Asset( "ATLAS", "images/UM_tip_icon.xml" ),
}
ReloadPreloadAssets()
--Start the game mode
modimport("init/init_gamemodes/init_uncompromising_mode")

GLOBAL.FUELTYPE.BATTERYPOWER = "BATTERYPOWER"
GLOBAL.FUELTYPE.SALT = "SALT"
GLOBAL.FUELTYPE.EYE = "EYE"

AddModCharacter("winky")

RemapSoundEvent( "dontstarve/together_FE/DST_theme_portaled", "UMMusic/music/uncomp_char_select" )

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Stop", function(...)
	--print("RPC Hayfever_Stop")
	GLOBAL.TheWorld:PushEvent("beequeenkilled")
end)

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Start", function(...)
	--print("RPC Hayfever_Start")
	GLOBAL.TheWorld:PushEvent("beequeenrespawned")
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsDeath", function(...)
	if not GLOBAL.TheWorld.ismastershard then
	print("RPC DeerclopsDeath")
		GLOBAL.TheWorld:PushEvent("hasslerkilled")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsRemoved", function(...)
	if not GLOBAL.TheWorld.ismastershard then
	print("RPC DeerclopsRemoved")
		GLOBAL.TheWorld:PushEvent("hasslerremoved")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsStored", function(...)
	if not GLOBAL.TheWorld.ismastershard then
	print("RPC DeerclopsStored")
		GLOBAL.TheWorld:PushEvent("storehassler")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsDeath_caves", function(...)
	if GLOBAL.TheWorld.ismastershard then
	print("RPC DeerclopsDeath")
		GLOBAL.TheWorld:PushEvent("hasslerkilled_secondary")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsRemoved_caves", function(...)
	if GLOBAL.TheWorld.ismastershard then
	print("RPC DeerclopsRemoved")
		GLOBAL.TheWorld:PushEvent("hasslerremoved")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsStored_caves", function(...)
	if GLOBAL.TheWorld.ismastershard then
	print("RPC DeerclopsStored")
		GLOBAL.TheWorld:PushEvent("storehassler")
	end
end)
--[[
AddShardModRPCHandler("UncompromisingSurvival", "AcidMushroomsUpdate", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("acidmushroomsdirty", {shard_id = shard_id, uuid = data.uuid, targets = data.targets})
end)

AddShardModRPCHandler("UncompromisingSurvival", "AcidMushroomsTargetFinished", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("master_acidmushroomsfinished", data)
end)]]

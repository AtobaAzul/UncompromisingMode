local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    
    inst:AddComponent("cavedeerclopsspawner")
	--[[
    if GetModConfigData("gamemode") == GAMEMODE_UNCOMPROMISING or
	(GetModConfigData("gamemode") == GAMEMODE_CUSTOM_SETTINGS and GetModConfigData("harder_weather") == true) then
	inst:AddComponent("hayfever_tracker")
	end--]]
	
		--inst:AddComponent("leechspawner") can reenable this once leeches are finished
	
local newwormspawn =
{
    base_prefab = "worm",
    winter_prefab = "shockworm",
    summer_prefab = "shockworm",

    attack_levels =
    {
        intro   = { warnduration = function() return 120 end, numspawns = function() return 1 end },
        light   = { warnduration = function() return 60 end, numspawns = function() return 1 + math.random(0,1) end },
        med     = { warnduration = function() return 45 end, numspawns = function() return 1 + math.random(0,1) end },
        heavy   = { warnduration = function() return 30 end, numspawns = function() return 2 + math.random(0,1) end },
        crazy   = { warnduration = function() return 30 end, numspawns = function() return 3 + math.random(0,2) end },
    },

    attack_delays =
    {
        rare        = function() return TUNING.TOTAL_DAY_TIME * 10, math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
        occasional  = function() return TUNING.TOTAL_DAY_TIME * 8, math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
        frequent    = function() return TUNING.TOTAL_DAY_TIME * 6, math.random() * TUNING.TOTAL_DAY_TIME * 5 end,
    },

    warning_speech = "ANNOUNCE_WORMS",

    --Key = time, Value = sound prefab
    warning_sound_thresholds =
    {
        { time = 30, sound = "LVL4_WORM" },
        { time = 60, sound = "LVL3_WORM" },
        { time = 90, sound = "LVL2_WORM" },
        { time = 500, sound = "LVL1_WORM" },
    },
}
inst.components.hounded:SetSpawnData(newwormspawn)
end)
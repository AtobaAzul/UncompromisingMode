local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
local SetSoundAlias = GLOBAL.require("tools/soundmanager")

--We can hack our way through the hounded component and create our own variables so we don't have to touch any of the private data --KoreanWaffles
AddComponentPostInit("dynamicmusic", function(self, inst)

local _iscave = inst:HasTag("cave")
local _isenabled = true
local _busytask = nil
local _dangertask = nil
local _triggeredlevel = nil
local _isday = nil
local _isbusydirty = nil
local _isbusyruins = nil
local _busytheme = nil
local _extendtime = nil
local _soundemitter = nil
local _activatedplayer = nil

	local HFMusic = {
    	--busy
    	["dontstarve/music/music_work"] = "UCSounds/music/creepyforest",
    	["dontstarve/music/music_work_winter"] = "UCSounds/music/creepyforest",
    	["dontstarve_DLC001/music/music_work_spring"] = "UCSounds/music/creepyforest",
    	["dontstarve_DLC001/music/music_work_summer"] = "UCSounds/music/creepyforest",
    	--combat
    	--[[["dontstarve/music/music_danger"] = "ia/music/music_danger_season_1",
    	["dontstarve/music/music_danger_winter"] = "ia/music/music_danger_season_2",
    	["dontstarve_DLC001/music/music_danger_spring"] = "ia/music/music_danger_season_3",
    	["dontstarve_DLC001/music/music_danger_summer"] = "ia/music/music_danger_season_4",
    	--epic
    	["dontstarve/music/music_epicfight"] = "ia/music/music_epicfight_season_1",
    	["dontstarve/music/music_epicfight_winter"] = "ia/music/music_epicfight_season_2",
    	["dontstarve_DLC001/music/music_epicfight_spring"] = "ia/music/music_epicfight_season_3",
    	["dontstarve_DLC001/music/music_epicfight_summer"] = "ia/music/music_epicfight_season_4",
    	--stinger
    	["dontstarve/music/music_dawn_stinger"] = "ia/music/music_dawn_stinger",
    	["dontstarve/music/music_dusk_stinger"] = "ia/music/music_dusk_stinger",]]
    }
	
	
	local DefaultMusic = {
    	--busy
    	["dontstarve/music/music_work"] = "dontstarve/music/music_work",
    	["dontstarve/music/music_work_winter"] = "dontstarve/music/music_work_winter",
    	["dontstarve_DLC001/music/music_work_spring"] = "dontstarve_DLC001/music/music_work_spring",
    	["dontstarve_DLC001/music/music_work_summer"] = "dontstarve_DLC001/music/music_work_summer",
    	--combat
    	--[[["dontstarve/music/music_danger"] = "ia/music/music_danger_season_1",
    	["dontstarve/music/music_danger_winter"] = "ia/music/music_danger_season_2",
    	["dontstarve_DLC001/music/music_danger_spring"] = "ia/music/music_danger_season_3",
    	["dontstarve_DLC001/music/music_danger_summer"] = "ia/music/music_danger_season_4",
    	--epic
    	["dontstarve/music/music_epicfight"] = "ia/music/music_epicfight_season_1",
    	["dontstarve/music/music_epicfight_winter"] = "ia/music/music_epicfight_season_2",
    	["dontstarve_DLC001/music/music_epicfight_spring"] = "ia/music/music_epicfight_season_3",
    	["dontstarve_DLC001/music/music_epicfight_summer"] = "ia/music/music_epicfight_season_4",
    	--stinger
    	["dontstarve/music/music_dawn_stinger"] = "ia/music/music_dawn_stinger",
    	["dontstarve/music/music_dusk_stinger"] = "ia/music/music_dusk_stinger",]]
    }

	local function IsInHF(player)
		return player.components.areaaware ~= nil
			and player.components.areaaware:CurrentlyInTag("hoodedcanopy")
	end

	local function SwapHFMusic(player)
		print("swap")
		if IsInHF(player) then
			for k, v in pairs(HFMusic) do
				print("ISHF")
				SetSoundAlias(k,v)
			end
		else
    		for k, v in pairs(DefaultMusic) do
				print("ISVN")
    			SetSoundAlias(k,v)
    		end
		end
	end
			

	local function StartPlayerListeners_HF(player)
			print("Activate")
		if player ~= nil then
			print("Activatep")
			inst:ListenForEvent("changearea", SwapHFMusic, player)
		end
	end

local function StartSoundEmitter()
    if _soundemitter == nil then
        _soundemitter = TheFocalPoint.SoundEmitter
        _extendtime = 0
        _isbusydirty = true
        if not _iscave then
            _isday = inst.state.isday
            inst:WatchWorldState("phase", OnPhase)
            inst:WatchWorldState("season", OnSeason)
        end
    end
end

local function StopSoundEmitter()
    if _soundemitter ~= nil then
        StopDanger()
        StopBusy()
        _soundemitter:KillSound("busy")
        inst:StopWatchingWorldState("phase", OnPhase)
        inst:StopWatchingWorldState("season", OnSeason)
        _isday = nil
        _isbusydirty = nil
        _extendtime = nil
        _soundemitter = nil
    end
end

	local function StopPlayerListeners_HF(player)
			print("Deactivate")
		if player ~= nil then
			print("Deactivatep")
			inst:RemoveEventCallback("changearea", SwapHFMusic, player)
		end
	end
	
	
	local function OnPlayerActivated_HF(inst, player)
		if _activatedplayer == player then
			return
		elseif _activatedplayer ~= nil and _activatedplayer.entity:IsValid() then
			StopPlayerListeners_HF(_activatedplayer)
		end
		_activatedplayer = player
		StartPlayerListeners_HF(player)
	end

	local function OnPlayerDeactivated_HF(inst, player)
		StopPlayerListeners_HF(player)
	end

	inst:ListenForEvent("playeractivated", OnPlayerActivated_HF, player)
	inst:ListenForEvent("playerdeactivated", OnPlayerDeactivated_HF, player)

end)
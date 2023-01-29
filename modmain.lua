local require = GLOBAL.require

require "um_pocketdimensioncontainers"

PrefabFiles = require("uncompromising_prefabs")
PreloadAssets = {
	Asset("IMAGE", "images/UM_tip_icon.tex"),
	Asset("ATLAS", "images/UM_tip_icon.xml"),
}
ReloadPreloadAssets()
--Start the game mode
SignFiles = require("uncompromising_writeables")

--PUTTING THIS HERE SO IT LOADS BEFORE ALL POSTINITS, INITS, ETC
AddPrefabPostInit("world", function(inst)
    if not inst.ismastersim then
        return
    end

    local count_skull, count_winky, items_skull, items_winky = 0, 0
    inst:DoTaskInTime(0, function()

        --count all skullchests and winky burrows
        for k, v in pairs(GLOBAL.Ents) do
            if v.prefab == "skullchest" then
                count_skull = count_skull + 1
            elseif v.prefab == "uncompromising_winkyburrow_master" then
                count_winky = count_winky + 1
            end
        end

        --resolve any excess skullchests
        if count_skull > 1 then
            for k, v in pairs(GLOBAL.Ents) do
                if count_skull == 1 then
                    break
                end
                if v.prefab == "skullchest" then
                    items_skull = v.components.container:RemoveAllItems()
                    if items_skull ~= nil then
                        local skullchest = GLOBAL.TheSim:FindFirstEntityWithTag("skullchest")
                        local x, y, z = 0, 0, 0
                        if skullchest ~= nil then
                            x, y, z = skullchest.Transform:GetWorldPosition()
                        end
                        for _, item in pairs(items_skull) do
                            item.Transform:SetPosition(x, y, z)
                        end
                    end
                    v:DoTaskInTime(1, v.Remove)
                    count_skull = count_skull - 1
                end
            end
        end

        if count_winky > 1 then
            for k, v in pairs(GLOBAL.Ents) do
                if count_winky == 1 then
                    break
                end
                if v.prefab == "skullchest" then
                    items_winky = v.components.container:RemoveAllItems()
                    if count_winky ~= nil then
                        local winky_burrow = GLOBAL.TheSim:FindFirstEntityWithTag("winky_burrow")
                        local x, y, z = 0, 0, 0
                        if winky_burrow ~= nil then
                            x, y, z = winky_burrow.Transform:GetWorldPosition()
                        end
                        for _, item in pairs(items_winky) do
                            item.Transform:SetPosition(x, y, z)
                        end
                    end
                    v:DoTaskInTime(1, v.Remove)
                    count_winky = count_winky - 1
                end
            end
        end

        if count_skull == 0 then
            GLOBAL.SpawnPrefab("skullchest") --Add a skullchest entity if there's none
            for k, v in pairs(GLOBAL.Ents) do
                if v.prefab == "skullchest_child" then
                    v:OnLoadPostPass(v) --reattach for any pre-existing ones
                end
            end
        end
        if count_winky == 0 then
            GLOBAL.SpawnPrefab("uncompromising_winkyburrow_master") --Add a uncompromising_winkyburrow_master entity if there's none
            for k, v in pairs(GLOBAL.Ents) do
                if v.prefab == "uncompromising_winkyburrow" or v.prefab == "uncompromising_winkyhomeburrow" then
                    v:OnLoadPostPass(v) --reattach for any pre-existing ones
                end
            end
        end
    end)

    if inst:HasTag("forest") then
        inst:AddComponent("acidmushrooms")
    end
end)


modimport("init/init_gamemodes/init_uncompromising_mode")
modimport("init/init_wathom")

if GetModConfigData("funny rat") then
	AddModCharacter("winky", "FEMALE")

	GLOBAL.TUNING.WINKY_HEALTH = 175
	GLOBAL.TUNING.WINKY_HUNGER = 150
	GLOBAL.TUNING.WINKY_SANITY = 125
	GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.winky = "Stinky"
end

GLOBAL.FUELTYPE.BATTERYPOWER = "BATTERYPOWER"
GLOBAL.FUELTYPE.SALT = "SALT"
GLOBAL.FUELTYPE.EYE = "EYE"
GLOBAL.FUELTYPE.SLUDGE = "SLUDGE"
GLOBAL.UPGRADETYPES.ELECTRICAL = "ELECTRICAL"
GLOBAL.UPGRADETYPES.SLUDGE_CORK = "SLUDGE_CORK"
GLOBAL.MATERIALS.SLUDGE = "sludge"
GLOBAL.MATERIALS.COPPER = "copper"

RemapSoundEvent("dontstarve/together_FE/DST_theme_portaled", "UMMusic/music/uncomp_char_select")
RemapSoundEvent("dontstarve/music/music_FE", "UMMusic/music/uncomp_main_menu")

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Stop", function()
	--print("RPC Hayfever_Stop")
	GLOBAL.TheWorld:PushEvent("beequeenkilled")
end)

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Start", function(...)
	--print("RPC Hayfever_Start")
	GLOBAL.TheWorld:PushEvent("beequeenrespawned")
end)

local function WathomMusicToggle(level)
	if level ~= nil then
		GLOBAL.TheWorld:PushEvent("enabledynamicmusic", false)
		GLOBAL.TheWorld.wathom_enabledynamicmusic = false
		if not GLOBAL.TheFocalPoint.SoundEmitter:PlayingSound("wathommusic") then
			GLOBAL.TheFocalPoint.SoundEmitter:PlaySound("UMMusic/music/" .. level, "wathommusic")
		end
	else
		if not GLOBAL.TheWorld.wathom_enabledynamicmusic then --just so other things that killed the music don't get messed up.
			GLOBAL.TheWorld:PushEvent("enabledynamicmusic", true)
			GLOBAL.TheWorld.wathom_enabledynamicmusic = true
		end
		GLOBAL.TheFocalPoint.SoundEmitter:KillSound("wathommusic")
	end
end

--wathomcustomvoice/wathomvoiceevent
local function DoAdrenalineUpStinger(sound)
	if type(sound) == "string" then
		GLOBAL.TheFrontEnd:GetSound():PlaySound("wathomcustomvoice/wathomvoiceevent/" .. sound)
	else
		GLOBAL.TheFrontEnd:GetSound():PlaySound("dontstarve_DLC001/characters/wathgrithr/inspiration_down")
	end
end

local function GetTargetFocus(player, telebase, telestaff)
	telestaff.target_focus = telebase
end

AddModRPCHandler("UncompromisingSurvival", "GetTargetFocus", GetTargetFocus)

AddModRPCHandler("UncompromisingSurvival", "PianoPuzzleComplete", function()
	GLOBAL.TheWorld:PushEvent("pianopuzzlecomplete")
end)

AddClientModRPCHandler("UncompromisingSurvival", "WathomMusicToggle", WathomMusicToggle)
AddClientModRPCHandler("UncompromisingSurvival", "WathomAdrenalineStinger", DoAdrenalineUpStinger)

local function ToggleLagCompOn(self)
    if --[[not GLOBAL.IsDefaultScreen() or]] GLOBAL.ThePlayer == nil or GLOBAL.ThePlayer.hadcompenabled ~= nil then
		return
    end
	
	if GLOBAL.Profile:GetMovementPredictionEnabled() then
		GLOBAL.ThePlayer:EnableMovementPrediction(false)
		GLOBAL.Profile:SetMovementPredictionEnabled(false)
		
		--GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("The shadows have turned lag compensation off, it will be restored on nights end.")
		--GLOBAL.TheNet:Announce("The shadows have turned lag compensation off, it will be restored on nights end.")
			
		if GLOBAL.ThePlayer.components.playercontroller:CanLocomote() then
			GLOBAL.ThePlayer.components.playercontroller.locomotor:Stop()
		else
			GLOBAL.ThePlayer.components.playercontroller:RemoteStopWalking()
		end
	
		GLOBAL.ThePlayer.hadcompenabled = true
	end
end

AddClientModRPCHandler("UncompromisingSurvival", "ToggleLagCompOn", ToggleLagCompOn)

local function ToggleLagCompOff(self)
    if --[[not GLOBAL.IsDefaultScreen() or]] GLOBAL.ThePlayer == nil or GLOBAL.ThePlayer.hadcompenabled == nil then
		return
    end
	
	if GLOBAL.ThePlayer.hadcompenabled then
		if not GLOBAL.Profile:GetMovementPredictionEnabled() then
			GLOBAL.ThePlayer:EnableMovementPrediction(true)
			GLOBAL.Profile:SetMovementPredictionEnabled(true)
			
			--GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("The shadows are gone, and lag compensation returns.")
			--GLOBAL.TheNet:Announce("The shadows are gone, and lag compensation returns.")
			
			if GLOBAL.ThePlayer.components.playercontroller:CanLocomote() then
				GLOBAL.ThePlayer.components.playercontroller.locomotor:Stop()
			else
				GLOBAL.ThePlayer.components.playercontroller:RemoteStopWalking()
			end
		
			GLOBAL.ThePlayer.hadcompenabled = nil
		end
	end
end

AddClientModRPCHandler("UncompromisingSurvival", "ToggleLagCompOff", ToggleLagCompOff)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsDeath", function(...)
	if not GLOBAL.TheWorld.ismastershard then
		--print("RPC DeerclopsDeath")
		GLOBAL.TheWorld:PushEvent("hasslerkilled")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsRemoved", function(...)
	if not GLOBAL.TheWorld.ismastershard then
		--print("RPC DeerclopsRemoved")
		GLOBAL.TheWorld:PushEvent("hasslerremoved")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsStored", function(...)
	if not GLOBAL.TheWorld.ismastershard then
		--print("RPC DeerclopsStored")
		GLOBAL.TheWorld:PushEvent("storehassler")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsDeath_caves", function(...)
	if GLOBAL.TheWorld.ismastershard then
		--print("RPC DeerclopsDeath")
		GLOBAL.TheWorld:PushEvent("hasslerkilled_secondary")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsRemoved_caves", function(...)
	if GLOBAL.TheWorld.ismastershard then
		--print("RPC DeerclopsRemoved")
		GLOBAL.TheWorld:PushEvent("hasslerremoved")
	end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsStored_caves", function(...)
	if GLOBAL.TheWorld.ismastershard then
		--print("RPC DeerclopsStored")
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

GLOBAL.plaguemask_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name, "plaguemask") end
GLOBAL.plaguemask_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "plaguemask") end

GLOBAL.feather_frock_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name, "feather_frock") end
GLOBAL.feather_frock_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "feather_frock") end

GLOBAL.cursed_antler_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name, "cursed_antler") end
GLOBAL.cursed_antler_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "cursed_antler") end

GLOBAL.ancient_amulet_red_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name,
	"ancient_amulet_red") end
GLOBAL.ancient_amulet_red_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "ancient_amulet_red") end

GLOBAL.TUNING.DSTU.MODROOT = MODROOT

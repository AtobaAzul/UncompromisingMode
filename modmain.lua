local require = GLOBAL.require

require "um_pocketdimensioncontainers"

PrefabFiles = require("uncompromising_prefabs")
PreloadAssets = {Asset("IMAGE", "images/UM_tip_icon.tex"), Asset("ATLAS", "images/UM_tip_icon.xml")}
ReloadPreloadAssets()
-- Start the game mode
SignFiles = require("uncompromising_writeables")

modimport("init/init_gamemodes/init_uncompromising_mode")
modimport("init/init_descriptions/announcestrings.lua")
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

if GetModConfigData("um_music", true) then
    RemapSoundEvent("dontstarve/together_FE/DST_theme_portaled", "UMMusic/music/uncomp_char_select")
    RemapSoundEvent("dontstarve/music/music_FE", "UMMusic/music/uncomp_main_menu")
end
AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Stop", function() GLOBAL.TheWorld:PushEvent("beequeenkilled") end)

AddShardModRPCHandler("UncompromisingSurvival", "Hayfever_Start", function(...) GLOBAL.TheWorld:PushEvent("beequeenrespawned") end)

local function WathomMusicToggle(level)
    if level ~= nil and GetModConfigData("um_music", true) then
        GLOBAL.TheWorld:PushEvent("enabledynamicmusic", false)
        GLOBAL.TheWorld.wathom_enabledynamicmusic = false
        if not GLOBAL.TheFocalPoint.SoundEmitter:PlayingSound("wathommusic") then
            GLOBAL.TheFocalPoint.SoundEmitter:PlaySound("UMMusic/music/" .. level, "wathommusic")
        end
    else
        if not GLOBAL.TheWorld.wathom_enabledynamicmusic then -- just so other things that killed the music don't get messed up.
            GLOBAL.TheWorld:PushEvent("enabledynamicmusic", true)
            GLOBAL.TheWorld.wathom_enabledynamicmusic = true
        end
        GLOBAL.TheFocalPoint.SoundEmitter:KillSound("wathommusic")
    end
end

-- wathomcustomvoice/wathomvoiceevent
local function DoAdrenalineUpStinger(sound)
    if type(sound) == "string" then
        GLOBAL.TheFrontEnd:GetSound():PlaySound("wathomcustomvoice/wathomvoiceevent/" .. sound)
    else
        GLOBAL.TheFrontEnd:GetSound():PlaySound("dontstarve_DLC001/characters/wathgrithr/inspiration_down")
    end
end

local function GetTargetFocus(player, telebase, telestaff) telestaff.target_focus = telebase end

AddModRPCHandler("UncompromisingSurvival", "GetTargetFocus", GetTargetFocus)

local function GetAllActiveTelebases()
    local valid_telebases = {}
    for k, telebase in pairs(Ents) do
        if telebase.prefab == "telebase" then
            if telebase.canteleto(telebase) then
                table.insert(valid_telebases, telebase)
            end
        end
    end
    return valid_telebases
end

local function UpdateAllFocuses(player)
    for k, v in ipairs(GetAllActiveTelebases()) do
        v.update_location(v)
    end
end

AddClientModRPCHandler("UncompromisingSurvival", "UpdateAllFocuses", UpdateAllFocuses)

local function PianoPuzzleComplete1()
    local piano = TheSim:FindFirstEntityWithTag("wixie_piano")
    piano:PushEvent("pianopuzzlecomplete_1")
end

local function PianoPuzzleComplete2()
    local piano = TheSim:FindFirstEntityWithTag("wixie_piano")
    piano:PushEvent("pianopuzzlecomplete_2")
end

local function PianoPuzzleComplete3()
    local piano = TheSim:FindFirstEntityWithTag("wixie_piano")
    piano:PushEvent("pianopuzzlecomplete_3")
end

AddModRPCHandler("UncompromisingSurvival", "PianoPuzzleComplete1", PianoPuzzleComplete1)
AddModRPCHandler("UncompromisingSurvival", "PianoPuzzleComplete2", PianoPuzzleComplete2)
AddModRPCHandler("UncompromisingSurvival", "PianoPuzzleComplete3", PianoPuzzleComplete3)

AddClientModRPCHandler("UncompromisingSurvival", "WathomMusicToggle", WathomMusicToggle)
AddClientModRPCHandler("UncompromisingSurvival", "WathomAdrenalineStinger", DoAdrenalineUpStinger)

local function ToggleLagCompOn(self)
    if --[[not GLOBAL.IsDefaultScreen() or]] GLOBAL.ThePlayer == nil or GLOBAL.ThePlayer.hadcompenabled ~= nil then
        return
    end

    if GLOBAL.Profile:GetMovementPredictionEnabled() then
        GLOBAL.ThePlayer:EnableMovementPrediction(false)
        GLOBAL.Profile:SetMovementPredictionEnabled(false)

        -- GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("The shadows have turned lag compensation off, it will be restored on nights end.")
        -- GLOBAL.TheNet:Announce("The shadows have turned lag compensation off, it will be restored on nights end.")

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

            -- GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("The shadows are gone, and lag compensation returns.")
            -- GLOBAL.TheNet:Announce("The shadows are gone, and lag compensation returns.")

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
        GLOBAL.TheWorld:PushEvent("hasslerkilled")
    end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsRemoved", function(...)
    if not GLOBAL.TheWorld.ismastershard then
        GLOBAL.TheWorld:PushEvent("hasslerremoved")
    end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsStored", function(...)
    if not GLOBAL.TheWorld.ismastershard then
        GLOBAL.TheWorld:PushEvent("storehassler")
    end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsDeath_caves", function(...)
    if GLOBAL.TheWorld.ismastershard then
        GLOBAL.TheWorld:PushEvent("hasslerkilled_secondary")
    end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsRemoved_caves", function(...)
    if GLOBAL.TheWorld.ismastershard then
        GLOBAL.TheWorld:PushEvent("hasslerremoved")
    end
end)

AddShardModRPCHandler("UncompromisingSurvival", "DeerclopsStored_caves", function(...)
    if GLOBAL.TheWorld.ismastershard then
        GLOBAL.TheWorld:PushEvent("storehassler")
    end
end)

AddShardModRPCHandler("UncompromisingSurvival", "CaveTornado", function(def, x, z, wise, dest_can_move)
    if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld:HasTag("cave") then
        GLOBAL.TheWorld:PushEvent("spawncavetornado", { xdata = x, zdata = z, wisedata = wise, dest_can_movedata = dest_can_move })
    end
end)

AddShardModRPCHandler("UncompromisingSurvival", "ToggleCaveHeatWave", function(sender_list, toggle)
    if toggle then
        GLOBAL.TheWorld:AddTag("heatwavestart")
        GLOBAL.TheWorld.net:AddTag("heatwavestartnet")
		GLOBAL.TheWorld:PushEvent("heatwavestart")
    else
        GLOBAL.TheWorld:RemoveTag("heatwavestart")
        GLOBAL.TheWorld.net:RemoveTag("heatwavestartnet")
		GLOBAL.TheWorld:PushEvent("heatwaveend")
    end
end)

-- WIXIE RELATED RPC'S

local function HandlerFunction(player, mouseposx, mouseposy, mouseposz)
    if GLOBAL.TheWorld.ismastersim then
        if mouseposx ~= nil then
            player.wixiepointx = mouseposx
        end

        if mouseposy ~= nil then
            player.wixiepointy = mouseposy
        end

        if mouseposz ~= nil then
            player.wixiepointz = mouseposz
        end
    else
        local wixieposition = GLOBAL.TheInput:GetWorldPosition()

        player.wixiepointx = wixieposition.x
        player.wixiepointy = wixieposition.y
        player.wixiepointz = wixieposition.z
    end
end

AddModRPCHandler("WixieTheDelinquent", "GetTheInput", HandlerFunction)

local function ClaustrophobiaPanic(player, inst)
    if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("wixiepanic") then
        inst.sg:GoToState("claustrophobic")
    end
end

AddModRPCHandler("WixieTheDelinquent", "ClaustrophobiaPanic", ClaustrophobiaPanic)

local function ClaustrophobiaEquipMult(claustrophobiamodifier)
    if GLOBAL.ThePlayer ~= nil then
        GLOBAL.ThePlayer.claustrophobiamodifier = claustrophobiamodifier
    end
end

AddClientModRPCHandler("WixieTheDelinquent", "ClaustrophobiaEquipMult", ClaustrophobiaEquipMult)

local function ClaustrophobiaHidden(claustrophobiahidden)
    if GLOBAL.ThePlayer ~= nil then
        GLOBAL.ThePlayer.claustrophobiahidden = claustrophobiahidden
    end
end

AddClientModRPCHandler("WixieTheDelinquent", "ClaustrophobiaHidden", ClaustrophobiaHidden)

if GetModConfigData("wixie_walter") then
    AddModCharacter("wixie", "FEMALE")

    GLOBAL.TUNING.WIXIE_HEALTH = 130
    GLOBAL.TUNING.WIXIE_HUNGER = 150
    GLOBAL.TUNING.WIXIE_SANITY = 200
    GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.wixie = "Grim"

    for k, v in pairs(GLOBAL.CLOTHING) do
        if v and v.symbol_overrides_by_character and v.symbol_overrides_by_character.walter then
            GLOBAL.CLOTHING[k].symbol_overrides_by_character.wixie = v.symbol_overrides_by_character.walter
        end
    end
end

--[[
AddShardModRPCHandler("UncompromisingSurvival", "AcidMushroomsUpdate", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("acidmushroomsdirty", {shard_id = shard_id, uuid = data.uuid, targets = data.targets})
end)

AddShardModRPCHandler("UncompromisingSurvival", "AcidMushroomsTargetFinished", function(shard_id, data)
    GLOBAL.TheWorld:PushEvent("master_acidmushroomsfinished", data)
end)]]
-- since ChangeImageName just does that, we need to assign the new atlas as well. I don't want to pack 2 images in the same atlas (mostly because idk how)

GLOBAL.plaguemask_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name, "hat_plaguemask") end

GLOBAL.plaguemask_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "hat_plaguemask") end

GLOBAL.feather_frock_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name, "featherfrock_ground") end

GLOBAL.feather_frock_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "featherfrock_ground") end

GLOBAL.cursed_antler_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name, "cursed_antler") end

GLOBAL.cursed_antler_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "cursed_antler") end

GLOBAL.ancient_amulet_red_init_fn = function(inst, build_name) GLOBAL.basic_init_fn(inst, build_name, "amulet_red_ground") end

GLOBAL.ancient_amulet_red_clear_fn = function(inst) GLOBAL.basic_clear_fn(inst, "amulet_red_ground") end

GLOBAL.TUNING.DSTU.MODROOT = MODROOT
modimport("init/init_insightcompat")
modimport("init/init_statusannouncements")


-- Temporary
AddUserCommand("mayonaise_update", {
    prettyname = nil,
    desc = nil,
    permission = GLOBAL.COMMAND_PERMISSION.USER,
    slash = true,
    usermenu = false,
    servermenu = true,
    menusort = 1,
    params = {},
    vote = false,
    serverfn = function(params, caller)
        if caller.userid == "KU_OYtV7iUY" or caller.userid == "KU_XZAhdglb" then
            local trinket = GLOBAL.SpawnPrefab("cctrinket_names")
            caller.components.inventory:GiveItem(trinket)
        end
    end
})


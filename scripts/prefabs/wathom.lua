local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("ANIM", "anim/wathom.zip"),
    Asset("ANIM", "anim/wathom_shadow.zip"),
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("SOUNDPACKAGE", "sound/wathomcustomvoice.fev"),
    Asset("SOUND", "sound/wathomcustomvoice.fsb")
}

-- Your character's stats
TUNING.WATHOM_HEALTH = 225
TUNING.WATHOM_HUNGER = 120
TUNING.WATHOM_SANITY = 120

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.WATHOM
end
local prefabs = FlattenTree(start_inv, true)

local function TurnOffShadowForm(inst)
    if inst.AnimState:GetBuild() == "wathom_shadow" then
        inst.AnimState:SetBuild("wathom")
    else
        inst.AnimState:SetBuild("wathom_triumphant")
    end
    inst:RemoveEventCallback("animqueueover", TurnOffShadowForm)
end

local function ToggleUndeathState(inst, toggle)
    if inst.components.timer ~= nil and inst.components.timer:TimerExists("shadowwathomcooldown") then
        return
    end

    if toggle then
        if not inst:HasTag("playerghost") then
            if inst.AnimState:GetBuild() == "wathom" then
                inst.AnimState:SetBuild("wathom_shadow")
            else
                inst.AnimState:SetBuild("wathom_shadow_triumphant")
            end
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("shadow_shield1").Transform:SetPosition(x, y, z)
        --inst.components.talker:Say("DEATH, REFUSED!", nil, true)
        inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/shadowbark")

        if inst.components.health ~= nil and not inst.components.health:IsDead() then
            inst.sg:GoToState("wathombark_shadow")
            inst.components.health.invincible = true

            inst:DoTaskInTime(1, function() inst.components.health.invincible = false end)
        end
        inst.components.adrenaline:SetPercent(1)
        inst.helpimleaking = inst:DoPeriodicTask(0.125, function(inst)
            if inst:HasTag("amped") then
                local x, y, z = inst.Transform:GetWorldPosition()
                local xoffset = math.random(-10, 10) / 10
                local zoffset = math.random(-10, 10) / 10
                --SpawnPrefab("minotaur_blood"..math.random(3)).Transform:SetPosition(x + xoffset, y, z + zoffset)
                SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + xoffset, y, z + zoffset)
            end
        end)
    else
        if inst.helpimleaking ~= nil then
            inst.helpimleaking:Cancel()
            inst.helpimleaking = nil
        end

        --if not inst:HasTag("playerghost") then
        inst:ListenForEvent("animqueueover", TurnOffShadowForm)
        --end
    end
end

local function UnAmp(inst)
    inst:RemoveTag("amped") -- Party's over.
    inst.components.combat.attackrange = 2
    inst.AmpDamageTakenModifier = TUNING.DSTU.WATHOM_AMPED_VULNERABILITY
    if inst.adrenalinehpregen ~= nil then
        inst.adrenalinehpregen:Cancel()
        inst.adrenalinehpregen = nil
    end

    inst.components.adrenaline:SetAmped(false)
    if inst.helpimleaking ~= nil then
        inst.helpimleaking:Cancel()
        inst.helpimleaking = nil
    end
    if inst:HasTag("deathamp") then
        inst:RemoveTag("deathamp")

        local bed = inst.components.sleepingbaguser ~= nil and inst.components.sleepingbaguser.bed or nil

        if bed ~= nil and bed.components.sleepingbag ~= nil then
            bed.components.sleepingbag:DoWakeUp()
        end

        if inst.components.health and not inst.components.health:IsDead() then
            inst.components.health:DoDelta(-225, nil, "deathamp")
        end
    end
end

local function Amp(inst)
    inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/ampedbark")
    inst.components.combat.attackrange = 7 -- These values are for when Wathom's at 100 Adrenaline, so he should be Amping Up right now.
    inst.AmpDamageTakenModifier = TUNING.DSTU.WATHOM_AMPED_VULNERABILITY
    inst:AddTag("amped")
    inst.components.adrenaline:SetAmped(true)
    --inst.components.talker:Say("AMPED UP!", nil, true)

    inst.helpimleaking = inst:DoPeriodicTask(0.33, function(inst)
        if inst:HasTag("amped") then
            local x, y, z = inst.Transform:GetWorldPosition()
            local xoffset = math.random(-10, 10) / 10
            local zoffset = math.random(-10, 10) / 10
            --SpawnPrefab("minotaur_blood"..math.random(3)).Transform:SetPosition(x + xoffset, y, z + zoffset)
            SpawnPrefab("cane_ancient_fx").Transform:SetPosition(x + xoffset, y, z + zoffset)
        end
    end)

    --[[inst.adrenalinehpregen = inst:DoPeriodicTask(1, function(inst)
		if inst.components.health ~= nil and not inst.components.health:IsDead() then
			inst.components.health:DoDelta(1.5)
		end
	end)]]
    if inst.components.health ~= nil and not inst.components.health:IsDead() then
        --inst.sg:GoToState("wathombark")
        inst.components.health.invincible = true
        inst:DoTaskInTime(1, function() inst.components.health.invincible = false end)
    end
end

-- When the character is revived from human
local function onbecamehuman(inst)
    -- Set speed when not a ghost (optional)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "wathom_speed_mod", 1)
    UnAmp(inst)
    --inst.AnimState:SetBuild("wathom")
    inst.components.adrenaline:SetPercent(0.25)
end

local function onbecameghost(inst)
    -- Remove speed modifier when becoming a ghost
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "wathom_speed_mod")
    UnAmp(inst)
    inst.components.adrenaline:SetPercent(0.25)
end

-------------------------------------------


local function AmpTimer(inst)
    if inst.components.grogginess ~= nil and
        (inst.components.adrenaline:GetPercent() < 0.25 and not inst:HasTag("amped") and not inst:HasTag("deathamp")) then
        inst.components.grogginess.grog_amount = 0.5
    end

    -- Draining adrenaline when not in combat.
    if (inst:HasTag("amped") or inst:HasTag("deathamp")) then
        if inst.adrenalpause then
            inst.components.adrenaline:DoDelta(-1)
        else
            inst.components.adrenaline:DoDelta(-4)
        end
    elseif inst.components.adrenaline:GetPercent() >= 0.25 then
        if not inst.adrenalpause then
            inst.components.adrenaline:DoDelta(-1)
        end
    end

    if inst.components.adrenaline:GetPercent() < 0.25 and not (inst:HasTag("amped") or inst:HasTag("deathamped")) then
        inst.components.adrenaline:DoDelta(1) -- Slowly regaining to normal levels.
    end

    local AmpLevel = inst.components.adrenaline:GetPercent()
    local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    --range updates

    if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
        inst.components.combat.attackrange = 2
        return
    end

    if (inst:HasTag("amped") or inst:HasTag("deathamp")) then
        if item ~= nil then
            inst.components.combat.attackrange = 7
        else
            inst.components.combat.attackrange = 2
        end
    elseif AmpLevel < 0.25 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 2
        else
            inst.components.combat.attackrange = 2
        end
    elseif AmpLevel < 0.5 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 4
        else
            inst.components.combat.attackrange = 2
        end
    elseif AmpLevel < 0.75 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 6
        else
            inst.components.combat.attackrange = 2
        end
    elseif AmpLevel < 1 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 7
        else
            inst.components.combat.attackrange = 2
        end
    end
end

local function OnAttackOther(inst, data)
    if data and data.target and not data.projectile and inst.components.adrenaline:GetPercent() >= 0.25 and
        ((data.target.components.combat and data.target.components.combat.defaultdamage > 0) or
            (
                data.target.prefab == "dummytarget" or data.target.prefab == "antlion" or data.target.prefab == "stalker_atrium" or
                data.target.prefab == "stalker")) then
        inst.adrenalpause = true
        if inst.adrenalresume then
            inst.adrenalresume:Cancel()
            inst.adrenalresume = nil
        end
        inst.adrenalresume = inst:DoTaskInTime(10, function(inst) inst.adrenalpause = false end)
        if not (inst:HasTag("amped") or inst:HasTag("deathamp")) then
            if inst.components.adrenaline:GetPercent() >= 0.25 and inst.components.adrenaline:GetPercent() < 0.5 then
                inst.components.adrenaline:DoDelta(5)
            elseif inst.components.adrenaline:GetPercent() >= 0.50 and inst.components.adrenaline:GetPercent() < 0.75 then
                inst.components.adrenaline:DoDelta(4)
            else
                inst.components.adrenaline:DoDelta(3)
            end
        end
    end
end

local function OnHealthDelta(inst, data)
    if data.amount < 0 and not inst:HasTag("amped") and inst.components.adrenaline:GetPercent() >= 0.25 and
        data.cause ~= "deathamp" and inst.components.health ~= nil and not inst.components.health:IsDead() then
        inst.components.adrenaline:DoDelta(math.floor(data.amount * -0.25)) -- This gives Wathom adrenaline when attacked!
    end
end

---------------------------------------------

local function GetPointSpecialActions(inst, pos, useitem, right)
    if right and useitem == nil then
        local rider = inst.replica.rider
        if rider ~= nil and not rider:IsRiding() or rider == nil then
            return { ACTIONS.WATHOMBARK }
        end
    end
    return {}
end

local function OnSetOwner(inst)
    if inst.components.playeractionpicker ~= nil then
        inst.components.playeractionpicker.pointspecialactionsfn = GetPointSpecialActions
    end
end

local WATHOM_COLOURCUBES =
{
    day = resolvefilepath("images/colour_cubes/bat_vision_on_cc.tex"),
    dusk = resolvefilepath("images/colour_cubes/bat_vision_on_cc.tex"),
    night = resolvefilepath("images/colour_cubes/bat_vision_on_cc.tex"),
    full_moon = "images/colour_cubes/fungus_cc.tex",
}

local function GetMusicValues(inst)
    if inst:HasTag("amped") then
        return "wathom_amped"
    else
        return nil --this should turn off the music.
    end
end

local function WathomEnterLight(inst)
end

local function WathomEnterDark(inst)
end

local function CheckLight(inst)
	if inst:IsInLight() then
		if inst.updatewathomvisiontask == nil then
			inst.updatewathomvisiontask = inst:DoTaskInTime(1, function()
				inst.components.playervision:SetCustomCCTable(nil)
				inst.components.playervision:ForceNightVision(false)
				inst:RemoveTag("WathomInDark")
				
				if inst.updatewathomvisiontask ~= nil then
					inst.updatewathomvisiontask:Cancel()
				end
			end)
		end
	else	
		if inst.updatewathomvisiontask ~= nil then
			inst.updatewathomvisiontask:Cancel()
		end
				
		inst.updatewathomvisiontask = nil
		inst.components.playervision:SetCustomCCTable(WATHOM_COLOURCUBES)
		inst.components.playervision:ForceNightVision(true)
		inst:AddTag("WathomInDark")
	end
end

-- When loading or spawning the character
local function onload(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)
	
    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
	
    if data then
        if data.amped then
            inst:AddTag("amped")
            SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomMusicToggle"), inst.userid,
                GetMusicValues(inst))
        end
		
        if data.deathamped then
            inst:AddTag("deathamp")
            SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomMusicToggle"), inst.userid,
                GetMusicValues(inst))
        end
    end
end

local function UpdateAdrenaline(inst, data)
    SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomMusicToggle"), inst.userid, GetMusicValues(inst))
    local AmpLevel = inst.components.adrenaline:GetPercent()
    local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

    --seperate 'if's so all sounds can play at once,in theory. (And I don't have to worry about elseif order...)
    if data.oldpercent < 0.75 and data.newpercent >= 0.75 then
        SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomAdrenalineStinger"), inst.userid,
            "wathom_ampstage_04")
    end
    if data.oldpercent < 0.5 and data.newpercent >= 0.5 then
        SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomAdrenalineStinger"), inst.userid,
            "wathom_ampstage_02")
    end

    if data.oldpercent >= 0.5 and data.newpercent < 0.5 then
        SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomAdrenalineStinger"), inst.userid,
            "wathom_breathe")
    end
    if data.oldpercent >= 0.25 and data.newpercent < 0.25 and not inst:HasTag("amped") then
        SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomAdrenalineStinger"), inst.userid,
            "wathom_breathe")
    end
    if data.oldpercent >= 0 and data.newpercent == 0 and inst:HasTag("amped") then
        SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomAdrenalineStinger"), inst.userid,
            "wathom_breathe")
    end

    if (AmpLevel >= 0.75 or inst:HasTag("amped")) and
        (inst.components.rider ~= nil and not inst.components.rider:IsRiding() or inst.components.rider == nil) then --Handle VVathom Running
        inst:AddTag("wathomrun")
    elseif inst:HasTag("wathomrun") and not (AmpLevel >= 0.75 or inst:HasTag("amped")) or inst.components.rider ~= nil and inst.components.rider:IsRiding() then
        inst:RemoveTag("wathomrun")
    end

    if AmpLevel == 0 and inst:HasTag("amped") then
        UnAmp(inst)
    elseif AmpLevel < 0.25 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 2
        else
            inst.components.combat.attackrange = 2
        end
        inst.AmpDamageTakenModifier = 3
    elseif AmpLevel < 0.5 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 4
        else
            inst.components.combat.attackrange = 2
        end
        inst.AmpDamageTakenModifier = 1
    elseif AmpLevel >= 1 and not inst:HasTag("amped") then
        Amp(inst)
        inst.AmpDamageTakenModifier = TUNING.DSTU.WATHOM_AMPED_VULNERABILITY
    elseif AmpLevel >= 0.75 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 6
        else
            inst.components.combat.attackrange = 2
        end
        inst.components.health:SetAbsorptionAmount(-0.50)
        inst.AmpDamageTakenModifier = 2
    elseif AmpLevel >= 0.5 and not inst:HasTag("amped") then
        if item ~= nil then
            inst.components.combat.attackrange = 5
        else
            inst.components.combat.attackrange = 2
        end
        inst.AmpDamageTakenModifier = 1.5
    end

    if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
        inst.components.combat.attackrange = 2
    end
end

local function CustomCombatDamage(inst, target, weapon, multiplier, mount)
    --sometimes I hate short-circuit evals...
    if mount == nil then
        return (target.components.hauntable and target.components.hauntable.panic and inst:HasTag("amped")) and (1.5 * 4) or
            (target.components.hauntable and target.components.hauntable.panic) and (1.5 * 2) or
            inst:HasTag("amped") and 4 or 2
            or 1
    end
end

local function OnAttacked(inst, data)
    inst.adrenalpause = true
    if inst.adrenalresume then
        inst.adrenalresume:Cancel()
        inst.adrenalresume = nil
    end
    inst.adrenalresume = inst:DoTaskInTime(10, function(inst) inst.adrenalpause = false end)
    if not TUNING.DSTU.WATHOM_ARMOR_DAMAGE then
        if data.damageresolved ~= nil then
            inst.components.health:DoDelta(-((data.damageresolved * inst.AmpDamageTakenModifier) - data.damageresolved),
                nil,
                data.attacker)
        end
    end
    --	if data.attacker:HasTag("brightmare") then
    --		inst.components.adrenaline:DoDelta(-10)
    --		inst.components.health:DoDelta(-10, nil, data.attacker)
    --	end
end

local function UpdateMusic(inst)
    SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "WathomMusicToggle"), inst.userid, GetMusicValues(inst))
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
    -- Minimap icon
    inst.MiniMapEntity:SetIcon("wathom.tex")

    inst:AddTag("wathom") -- Tells the game to switch the character's attacks to leaping, as well as switch some insanity sources around to give sanity instead.
    inst:AddTag("monster")
    inst:AddTag("playermonster")
    inst:AddTag("nightvision")

    inst.OnLoad = onload
    inst.OnNewSpawn = onload

	inst:DoPeriodicTask(.3, CheckLight)
	inst:ListenForEvent("enterdark", WathomEnterDark)
	inst:ListenForEvent("enterlight", WathomEnterLight)

    --t'was revealed to me in a dream, and I'm not even kidding.
    inst:ListenForEvent("wathommusic_start", UpdateMusic)
    inst:ListenForEvent("wathommusic_end", UpdateMusic)
    inst:ListenForEvent("ms_playerreroll", UpdateMusic)
    inst:ListenForEvent("player_despawn", UpdateMusic)
    inst:ListenForEvent("setowner", OnSetOwner)
    inst:ListenForEvent("ondeath", function(inst)
        if inst:HasTag("amped") then
            inst:RemoveTag("amped")
        end

        UpdateMusic(inst)
    end)
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
    --	inst.components.sanity:EnableLunacy(true, "wathomlunacy")

    -- -- 	If at high lunacy, become a target for Gestalts and Greater Gestalts.
    --	if inst.components.sanity:GetPercent() > 0.84 then
    --		inst:AddTag("gestalt_possessable")
    --	else
    --		inst:RemoveTag("gestalt_possessable")
    --end

    inst.adrenalinecheck = 0 -- I have no idea what this does. It's left over from SCP-049.

    -- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

    -- choose which sounds this character will play
    inst.soundsname = "wathomvoiceevent"
    inst.talker_path_override = "wathomcustomvoice/"

    -- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"

    -- Carnivore
    if inst.components.eater ~= nil then
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES })
    end

    inst.components.eater:SetCanEatRawMeat(true) -- Comment out when we want to invert insanity.

    inst.components.foodaffinity:AddPrefabAffinity("hardshelltacos", 20)

    -- Stats
    inst.components.health:SetMaxHealth(TUNING.WATHOM_HEALTH)
    inst.components.hunger:SetMax(TUNING.WATHOM_HUNGER)
    inst.components.sanity:SetMax(TUNING.WATHOM_SANITY)

    --	inst.components.sanity.neg_aura_absorb = TUNING.ARMOR_HIVEHAT_SANITY_ABSORPTION -- Reverses insanity auras and reduces by 50%

    -- Damage multiplier (In reality, Wathom won't deal double damage. The time it takes for him to attack is about twice as long as other characters.
    --inst.components.combat.damagemultiplier = 2
    inst.components.combat.customdamagemultfn = CustomCombatDamage

    -- Hunger rate (optional)
    inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

    -- Idle animation
    inst.customidleanim = "spooked"

    -- grogginess stuff

    local function DefaultKnockoutTest(inst)
        local self = inst.components.grogginess
        return self.grog_amount >= self:GetResistance()
            and not (inst.components.health ~= nil and inst.components.health.takingfiredamage)
            and not (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
    end

    inst.components.grogginess.knockouttestfn = function(inst)
        if inst:HasTag("amped") then
            return false
        else
            return DefaultKnockoutTest(inst)
        end
    end

	inst:DoPeriodicTask(.3, CheckLight)
	inst:ListenForEvent("enterdark", WathomEnterDark)
	inst:ListenForEvent("enterlight", WathomEnterLight)

    -- stuff relating to Wathom's adrenaline timer. This can most likely be optimized.
    inst:DoPeriodicTask(1.5, function() AmpTimer(inst) end)

    inst:ListenForEvent("healthdelta", OnHealthDelta)
    inst:ListenForEvent("onattackother", OnAttackOther)
    inst:ListenForEvent("attacked", OnAttacked)
    if TheWorld.ismastersim then
        inst:ListenForEvent("adrenalinedelta", UpdateAdrenaline)
    end
    inst:ListenForEvent("wathommusic_start", UpdateMusic)
    inst:ListenForEvent("wathommusic_end", UpdateMusic)
    inst:ListenForEvent("ms_playerreroll", UpdateMusic)
    inst:ListenForEvent("player_despawn", UpdateMusic)

    inst:ListenForEvent("ondeath", function(inst)
        if inst:HasTag("amped") then
            inst:RemoveTag("amped")
            UpdateMusic(inst)
        end
    end)
    -- Wathom's immunity to night drain during the night and sanity (lunacy) gain during the day.
    --	inst.components.sanity.night_drain_mult = 0
    inst.components.sanity.light_drain_immune = true

    --	inst:WatchWorldState("isday", function()
    --		inst:DoTaskInTime(TheWorld.state.isday and 0 or 1, function(inst)
    --			if not TheWorld:HasTag("cave") then
    --				if TheWorld.state.isnight or TheWorld.state.isdusk then
    --					inst.components.sanity.dapperness = 0
    --				elseif TheWorld.state.isday then
    --					inst.components.sanity.dapperness = 10 / 60
    --				end
    --			end
    --		end)
    --	end)


    -- Night Vision enabler
    --	inst.components.playervision:ForceNightVision(true) -- Should only force this if it's night or in caves.

    -- Doubles Wathom's attack range so he can jump at things from further away.
    -- inst.components.combat.attackrange = 4

    local _onsave = inst.OnSave

    local function onsave(inst, data)
        if inst:HasTag("amped") then
            data.amped = true
        end
        if inst:HasTag("deathamp") then
            data.deathamped = true
        end
        if _onsave ~= nil then
            return _onsave(inst, data)
        end
    end

    inst.OnLoad = onload
    inst.OnSave = onsave

    inst.OnNewSpawn = onload
    inst.ToggleUndeathState = ToggleUndeathState
end

return MakePlayerCharacter("wathom", prefabs, assets, common_postinit, master_postinit, prefabs)

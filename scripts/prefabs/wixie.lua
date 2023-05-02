local MakePlayerCharacter = require("prefabs/player_common")
local SourceModifierList = require("util/sourcemodifierlist")


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wixie.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

		-- Don't forget to include your character's custom assets!
        Asset( "ANIM", "anim/wixie.zip" ),
		Asset( "ANIM", "anim/ghost_wixie_build.zip" ),
}

local prefabs =
{
    "slingshot",
}

local function OnKilledOther(inst, data)
    if data ~= nil and data.victim ~= nil and data.victim.prefab ~= nil then
        local naughtiness = NAUGHTY_VALUE[data.victim.prefab]
        if naughtiness ~= nil then
			local naughty_val = FunctionOrValue(naughtiness, inst, data)
			local naughtyresolve = naughty_val * (data.stackmult or 1)
			inst.components.sanity:DoDelta(naughtyresolve)
        end
    end
end

local function GetClaustrophobia(inst)
    if inst.claustrophobia ~= nil then
        return inst.claustrophobia
    else
        return 0
    end
end

local function CanGainClaustrophobia(inst)
	local isghost = (inst.player_classified ~= nil and inst.player_classified.isghostmode:value()) or
                    (inst.player_classified == nil and inst:HasTag("playerghost"))

	if isghost ~= nil and isghost then
        return false
    elseif inst.components.health ~= nil and inst.components.health:IsDead() or inst.replica ~= nil and inst.replica.health ~= nil and inst.replica.health:IsDead() then
        return false
    else
        return true
    end
end


local function OnCooldown(inst)
    inst._claustrophobiacdtask = nil
end

local function updateclaustrophobia(inst)
	inst.claustrophobiarate = inst.claustrophobiahidden and 0.005 or 0
	local objectmodifier = 0
	
	if not TheWorld.ismastersim or not TheNet:IsDedicated() then
		if inst._claustrophobiacdtask == nil then
			local x, y, z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 5, { "_health", "_combat" }, { "noclaustrophobia", "structure", "wall", "fx", "NOCLICK", "INLIMBO", "invisible", "player", "playerghost", "ghost", "shadow", "shadowcreature", "shadowminion", "stalkerminion", "shadowchesspiece", "boatbumper", "spore", "pigelite", "oceanfishable", "trap" } )
			local treesandwalls = TheSim:FindEntities(x, y, z, 5, nil, { "stump", "INLIMBO" }, { "tree", "wall" })
			
			if treesandwalls ~= nil then
				for i, v in ipairs(treesandwalls) do
					if objectmodifier < 0.25 then
						objectmodifier = objectmodifier + 0.03
					else
						objectmodifier = 0.25
					end
				end
			end
				
			if inst:CanGainClaustrophobia() and not inst.wixiepanic and ents ~= nil and #ents >= 1 or inst.claustrophobiarate > 0 or inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
				if ents ~= nil and #ents >= 1 then
					for i, v in ipairs(ents) do
						if inst:GetClaustrophobia() < 1 then
							if v:HasTag("smallcreature") and v:HasTag("insect") or v:HasTag("rabbit") or v:HasTag("bird") or v:HasTag("companion") then
								inst.claustrophobiarate = inst.claustrophobiarate + 0.0005
							elseif v:HasTag("smallcreature") then
								inst.claustrophobiarate = inst.claustrophobiarate + 0.0008
							elseif v:HasTag("epic") then
								if v.prefab == "klaus" then
									inst.claustrophobiarate = inst.claustrophobiarate + 0.008
								else
									inst.claustrophobiarate = inst.claustrophobiarate + 0.006
								end
							else
								inst.claustrophobiarate = inst.claustrophobiarate + 0.0025
							end
						end
					end
				end
				
				if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
					inst.claustrophobiarate = inst.claustrophobiarate + 0.0005
				end
				
				if inst.claustrophobiarate > 0.008 then
					inst.claustrophobiarate = 0.008
				end
				
				inst.claustrophobia = inst.claustrophobia + inst.claustrophobiarate
							
				if inst:GetClaustrophobia() >= 1 then
					inst.claustrophobia = 1
								
					if not inst.wixiepanic and inst:CanGainClaustrophobia() then
						inst.wixiepanic = true
						SendModRPCToServer(GetModRPC("WixieTheDelinquent", "ClaustrophobiaPanic"), inst)
					end
				end
			else
				if inst.wixiepanic then
					inst.claustrophobia = inst.claustrophobia - 0.0075
				end
				
				local minimum_claustrophobia = inst.claustrophobiamodifier + objectmodifier
				
				if not inst.wixiepanic and inst:GetClaustrophobia() <= minimum_claustrophobia then
						if inst:GetClaustrophobia() > minimum_claustrophobia then
							inst.claustrophobia = minimum_claustrophobia
						else
							inst.claustrophobia = inst.claustrophobia + 0.002
						end
					if inst:GetClaustrophobia() > minimum_claustrophobia then
						inst.claustrophobia = minimum_claustrophobia
					end
				else
					inst.claustrophobia = inst.claustrophobia - 0.001
				end
				
				if inst:GetClaustrophobia() <= 0 then
					inst.claustrophobia = 0
					
					if inst.wixiepanic then
						inst.wixiepanic = false
						
						inst._claustrophobiacdtask = inst:DoTaskInTime(10, OnCooldown)
					end
				end
			end
		end
	end
end

local function EquipedCount(inst, data)
	local headequipped = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
	local bodyequipped = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil

	inst.headmodifier = headequipped ~= nil and headequipped.components.armor ~= nil and not headequipped:HasTag("grass") and not headequipped:HasTag("shadow_item") and 0.2 or 0
	inst.bodymodifier = bodyequipped ~= nil and bodyequipped.components.armor ~= nil and not bodyequipped:HasTag("grass") and not bodyequipped:HasTag("shadow_item") and 0.2 or 0

	inst.claustrophobiamodifier = inst.headmodifier + inst.bodymodifier
	
	if inst.headmodifier > 0 then
		inst.components.talker:Say(GetString(inst, "UNCOMFORTABLE_HAT"))
	end
	
	if inst.bodymodifier > 0 then
		inst.components.talker:Say(GetString(inst, "UNCOMFORTABLE_ARMOR"))
	end
	
	SendModRPCToClient(GetClientModRPC("WixieTheDelinquent", "ClaustrophobiaEquipMult"), inst.userid, inst.claustrophobiamodifier)
end

local function OnNewState(inst, data)
	if inst.sg:HasStateTag("hiding") then
		inst.claustrophobiahidden = true
			
		SendModRPCToClient(GetClientModRPC("WixieTheDelinquent", "ClaustrophobiaHidden"), inst.userid, inst.claustrophobiahidden)
	elseif inst.claustrophobiahidden then
		inst.claustrophobiahidden = false
		
		SendModRPCToClient(GetClientModRPC("WixieTheDelinquent", "ClaustrophobiaHidden"), inst.userid, inst.claustrophobiahidden)
	end
end

local function OnInit(inst)
	if inst.wixietask == nil then
		inst.wixietask = inst:DoPeriodicTask(FRAMES, updateclaustrophobia)
		print("register claustrophobia 'meter'")
	end
end

local MAPREVEAL_SCALE = 450
local MAPREVEAL_STEPS = 10

local function OnNewSpawn(inst)

	inst:DoTaskInTime(0, function()
		local spawn = TheSim:FindFirstEntityWithTag("wixie_wardrobe")
		if spawn ~= nil then
			local x, y, z = spawn.Transform:GetWorldPosition()
			inst.Transform:SetPosition(x + 1, y, z + 1)
			spawn:PushEvent("wixie_wardrobe_shutter")
			
			if inst.DynamicShadow ~= nil then
				inst.DynamicShadow:Enable(false)
			end
		
			for i = 1, 4 do
				inst:DoTaskInTime(i, function()
					spawn:PushEvent("wixie_wardrobe_shutter")
				end)
			end
			
			inst:DoTaskInTime(5, function()
				spawn:PushEvent("wixie_wardrobe_shake")
				inst:SetCameraZoomed(false)
									
				inst:DoTaskInTime(20 * FRAMES, function()
					inst.sg:GoToState("idle")
									
					inst:Show()
										
					if inst.DynamicShadow ~= nil then
						inst.DynamicShadow:Enable(true)
					end
			
					inst:PushEvent("knockback", {knocker = spawn, radius = 15, strengthmult = 1})
										
					inst:DoTaskInTime(2, function()
						inst.components.talker:Say(GetString(inst, "WIXIE_SPAWN"))
					end)
				end)
			end)
		end
	end)
	
	TheWorld:PushEvent("ms_newplayerspawned", inst)
end

local function common_postinit(inst)
    inst.avatar_tex   = "avatar_wixie.tex"
    inst.avatar_atlas = "images/avatars/avatar_wixie.xml"

    inst.avatar_ghost_tex   = "avatar_ghost_wixie.tex"
    inst.avatar_ghost_atlas = "images/avatars/avatar_ghost_wixie.xml"
	
    inst:AddTag("pebblemaker")
    inst:AddTag("slingshot_sharpshooter")
    inst:AddTag("troublemaker")

    inst.customidleanim = "idle_wixie"
	inst.claustrophobia = 0
	inst.claustrophobiamodifier = 0
	inst.wixiepanic = false
	inst.claustrophobiahidden = false
	
    inst.GetClaustrophobia = GetClaustrophobia
    inst.CanGainClaustrophobia = CanGainClaustrophobia
	
	
	if not TheWorld.ismastersim or not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, OnInit)
	end
	
	if TheWorld.ismastersim	then
		inst:ListenForEvent("equip", EquipedCount)
		inst:ListenForEvent("unequip", EquipedCount)
		inst:ListenForEvent("newstate", OnNewState)
	end
end

local function master_postinit(inst)
    inst.starting_inventory = {"slingshot", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock"}
	
    inst.MiniMapEntity:SetIcon("wixie.tex")
	--inst:AddComponent("claustrophobia")
	
    inst.components.health:SetMaxHealth(TUNING.WALTER_HEALTH)
    inst.components.hunger:SetMax(TUNING.WILSON_HUNGER)
    inst.components.sanity:SetMax(TUNING.WALTER_SANITY)

    inst.components.foodaffinity:AddPrefabAffinity("blueberrypancakes", 1.2)
	
	--inst:ListenForEvent("killed", OnKilledOther)
	
	inst.soundsname = "wixie"
	
	inst.OnNewSpawn = OnNewSpawn
end

STRINGS.CHARACTERS.WIXIE= require "speech_wixie"

return MakePlayerCharacter("wixie", prefabs, assets, common_postinit, master_postinit)
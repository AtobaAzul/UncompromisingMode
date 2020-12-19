local BigPopupDialogScreen = require "screens/bigpopupdialog"

local assets =
{
    Asset("ANIM", "anim/veteranshrine.zip"),      
}

local prefabs =
{
}


--[[
local function makeactive(inst)
    inst.AnimState:PlayAnimation("off", true)
    inst.components.activatable.inactive = false
end

local function makeused(inst)
    inst.AnimState:PlayAnimation("flow_loop", true)
end
]]

local function GetVerb()
    return "TOUCH"
end

local function ToggleCurse(inst, doer)
	if doer.components.debuffable ~= nil then
		if not doer.vetcurse == true then
			doer.SoundEmitter:PlaySound("dontstarve/sanity/creature2/taunt")
			inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_maxwelllaugh", "teleportato_laugh")
			doer.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
			doer:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_VETCURSE", 1 })
			local x, y, z = inst.Transform:GetWorldPosition()
			local fx = SpawnPrefab("statue_transition_2")
			if fx ~= nil then
				fx.Transform:SetPosition(x, y, z)
				fx.Transform:SetScale(1.2,1.2,1.2)
			end
			fx = SpawnPrefab("statue_transition")
			if fx ~= nil then
				fx.Transform:SetPosition(x, y, z)
				fx.Transform:SetScale(1.2,1.2,1.2)
			end
		end
	end
	inst.components.activatable.inactive = true
end

local function OnDoneTalking(inst)
    if inst.talktask ~= nil then
        inst.talktask:Cancel()
        inst.talktask = nil
    end
    inst.SoundEmitter:KillSound("talk")
end

local function StartRagtime(inst)
	if inst.ragtime_playing == nil then
		inst.ragtime_playing = true
		inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/ragtime", "ragtime")
	else
		inst.SoundEmitter:SetVolume("ragtime", 1)
	end
end

local function ShutUpRagtime(inst)
	inst.SoundEmitter:SetVolume("ragtime", 0)
end

local function OnTalk(inst)
    OnDoneTalking(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/talk_LP", "talk")
    inst.talktask = inst:DoTaskInTime(2 + math.random() * .5, OnDoneTalking)
end

local function onnear(inst, target)
	if target ~= nil then
		if target:HasTag("vetcurse") then
			inst.components.talker:Say(GetString(inst.target, "VETERANCURSED"))
		else
			inst.components.talker:Say(GetString(inst.target, "VETERANCURSETAUNT"))
		end
	end
	
	inst:DoTaskInTime(0, StartRagtime)
end

local function onfar(inst, target)
	inst:DoTaskInTime(0, ShutUpRagtime)
end

local function ToggleCursee(inst, doer)
	if doer == ThePlayer then
		if doer:HasTag("vetcurse") then
			local function acceptance()
				TheFrontEnd:PopScreen()
				inst.components.activatable.inactive = true
			end
			local title = "You Made Your Choice."
			local bodytext = "Now you must live with the consequences."
			local yes_box = { text = "Ok", cb = acceptance }

			local bpds = BigPopupDialogScreen(title, bodytext, { yes_box })
			bpds.title:SetPosition(0, 85, 0)
			bpds.text:SetPosition(0, -15, 0)

			TheFrontEnd:PushScreen(bpds)
		else
			local function start_curse()
				TheFrontEnd:PopScreen()
				inst.components.activatable.inactive = true
				doer.sg:GoToState("curse_controlled")
				ToggleCurse(inst, doer)
			end

			local function reject_curse()
				TheFrontEnd:PopScreen()
				inst.components.activatable.inactive = true
			end

			local title = "The Veterans Curse."
			local bodytext = "- Receive more damage when attacked.\n - Hunger drains faster.\n - Gain the ability to wield cursed items, dropped by cerain bosses.\n - There is no way to lift this curse."
			local yes_box = { text = "Yes", cb = start_curse }
			local no_box = { text = "No", cb = reject_curse }

			local bpds = BigPopupDialogScreen(title, bodytext, { yes_box, no_box })
			bpds.title:SetPosition(0, 85, 0)
			bpds.text:SetPosition(0, -15, 0)

			TheFrontEnd:PushScreen(bpds)
		end
	end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("veteranshrine_map.tex")

    anim:SetBuild("veteranshrine")    
    anim:SetBank("veteranshrine")
    anim:PlayAnimation("idle", true)
	
    inst.GetActivateVerb = GetVerb
	
    MakeObstaclePhysics(inst, 1.8)
	
	inst.entity:SetPristine()
	
	inst:AddComponent("talker")        
    inst.components.talker.colour = Vector3(252/255, 226/255, 219/255)
    inst.components.talker.offset = Vector3(0, -500, 0)
    inst.components.talker:MakeChatter()
    inst.components.talker.lineduration = TUNING.HERMITCRAB.SPEAKTIME * 2 -0.5
    if LOC.GetTextScale() == 1 then
		inst.components.talker.fontsize = 30
    end
    inst.components.talker.font = TALKINGFONT_HERMIT
    inst:AddComponent("npc_talker")

    if not TheWorld.ismastersim then
        return inst
    end
	
	
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = ToggleCursee
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true
	
    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
	
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 10)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    --inst.deactivate = deactivate

    --inst.OnSave = onsave 
    --inst.OnLoad = onload
	
    inst:ListenForEvent("ontalk", OnTalk)
    inst:ListenForEvent("donetalking", OnDoneTalking)

    return inst
end

return Prefab("veteranshrine", fn, assets, prefabs)



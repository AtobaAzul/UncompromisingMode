require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/nightmare_torch.zip"),
}

local prefabs =
{
    "collapse_small",
    "nightlight_flame",
}

local function Disappear(inst)
    if inst.lighttask ~= nil then
        inst.lighttask:Cancel()
        inst.lighttask = nil
    end
	
    inst:Remove()
end

local function OnInit(inst)
    if inst.LightWatcher:IsInLight() then
        inst:Remove()
    else
        inst.entity:Show()
    end
end
--[[
STRINGS.CHARACTERS.SHADOWTALKER.SHADOWTALKER = {
        "MY EXPERIMENTS ARE ALL FAILURES",
        "THE THRONE WAS NO ESCAPE",
        "THERE HAS TO BE A SCIENTIFIC SOLUTION HERE",
    }
]]
local function SetPlayer(inst)
	if inst.speech ~= nil and math.random() >= 0.5 then
		if inst.speech:HasTag("bearded") and not inst.speech:HasTag("spiderwhisperer") and not inst.speech:HasTag("polite") then
			local speechchance = math.random()
			if speechchance >= 0.66 then
				inst.components.talker:Say("MY EXPERIMENTS ARE ALL FAILURES")
			elseif speechchance < 0.66 and speechchance >= 0.33 then
				inst.components.talker:Say("THE THRONE WAS NO ESCAPE")
			elseif speechchance < 0.33 then
				inst.components.talker:Say("THERE HAS TO BE A SCIENTIFIC SOLUTION HERE")
			end
		else
			inst.components.talker:Say(GetString(inst.speech, "SHADOWTALKER"))
		end
		inst:DoTaskInTime(8, SetPlayer)
	else
		--inst.components.npc_talker:Say(GetString(inst, "TAUNT_PLAYER_GENERIC"))
		--inst.components.talker:Say(GetString(TheWorld, "TAUNT_PLAYER_GENERIC"))
		--inst.components.talker:Say(STRINGS.TAUNT_PLAYER_GENERIC[math.random(3)])
		--if math.random() <= 0.01 then
			--inst.components.talker:Say("zarklord is epic")
		--else
			inst.components.talker:Say(GetString(inst, "SHADOWTALKER"))
		--end
		inst:DoTaskInTime(8, SetPlayer)
		--print(STRINGS.SHADOWTALKER_TAUNT_PLAYER_GENERIC)
	end
end

local function fn()
    local inst = CreateEntity()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("shadowtalker")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    inst.LightWatcher:SetLightThresh(.2)
    inst.LightWatcher:SetDarkThresh(.19)
    inst:ListenForEvent("enterlight", Disappear)
	
    inst.entity:SetPristine()
	
	inst:AddComponent("talker")        
    inst.components.talker.colour = Vector3(252/255, 226/255, 219/255)
    inst.components.talker.offset = Vector3(0, -500, 0)
    inst.components.talker:MakeChatter()
    inst.components.talker.lineduration = TUNING.HERMITCRAB.SPEAKTIME * 1.15 -0.5  -- it's minus one here to create a buffer between text.

    --inst.components.talker.symbol = inst
    if LOC.GetTextScale() == 1 then
        --Note(Peter): if statement is hack/guess to make the talker not resize for users that are likely to be speaking using the fallback font.
        --Doesn't work for users across multiple languages or if they speak in english despite having a UI set to something else, but it's more likely to be correct, and is safer than modifying the talker
        inst.components.talker.fontsize = 30
    end
    inst.components.talker.font = TALKINGFONT_HERMIT

    inst:AddComponent("npc_talker")

    inst.animname = tostring(math.random(3))
    inst.AnimState:SetBank("eyes_darkness")
    inst.AnimState:SetBuild("eyes_darkness")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:PlayAnimation("appear_"..inst.animname)
    inst.AnimState:PushAnimation("idle_"..inst.animname, true)
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:Hide()

	inst:DoTaskInTime(0, OnInit)

    inst:ListenForEvent("enterlight", Disappear)
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 8)
    inst.components.playerprox:SetOnPlayerNear(Disappear)
	
	inst:DoTaskInTime(0, SetPlayer)
	
    inst.persists = false
	
    return inst
end

return Prefab("shadowtalker", fn, assets, prefabs)
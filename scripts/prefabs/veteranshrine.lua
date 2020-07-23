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

    anim:SetBuild("veteranshrine")    
    anim:SetBank("veteranshrine")
    anim:PlayAnimation("idle", true)
    inst.GetActivateVerb = GetVerb
    MakeObstaclePhysics(inst, 2)
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
    inst.components.activatable.OnActivate = ToggleCurse
    inst.components.activatable.inactive = true
    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
	
	--[[
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetDist(6, 40)
]]
    --inst.deactivate = deactivate

    --inst.OnSave = onsave 
    --inst.OnLoad = onload
	
    inst:ListenForEvent("ontalk", OnTalk)
    inst:ListenForEvent("donetalking", OnDoneTalking)

    return inst
end

return Prefab("veteranshrine", fn, assets, prefabs)



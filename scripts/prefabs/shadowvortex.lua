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

local function Beat(inst)
    inst.SoundEmitter:PlaySound("dontstarve/sanity/shadow_heart")
end

local function Vac(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local theta = inst.Transform:GetRotation()
	local TheAngle = 360 * DEGREES
	
	local ents = TheSim:FindEntities(x, y, z, 10 * inst.Transform:GetScale(), { "player" })
	
	for i, v in ipairs(ents) do
		local px, py, pz = v.Transform:GetWorldPosition()
			
		local rad = math.rad(v:GetAngleToPoint(x, y, z))
		local velx = math.cos(rad) --* 4.5
		local velz = -math.sin(rad) --* 4.5
		
		local dx, dy, dz = px + ((FRAMES * 1.5) * velx * inst.Transform:GetScale()), 0, pz + ((FRAMES * 1.5) * velz * inst.Transform:GetScale())
			
		if dx ~= nil then
			--print(displacement)
			--v.Transform:SetPosition(displacement.x, py, displacement.z)
			v.Transform:SetPosition(dx, dy, dz)
			--v.Transform:SetPosition(telex, py, telez)
			--v.Transform:SetPosition(targetpos.x, py, targetpos.z)
		end
	end
end

local function Disappear_mini(inst)
	inst.components.sizetweener:StartTween(0.05, 0.2, inst.Remove)
end

local function shrink_mini(inst)
	--inst.sg:GoToState("run")
	inst.components.sizetweener:StartTween(0.1, 3, Disappear_mini)
end

local function shrinktask_mini(inst)
	inst:DoTaskInTime(8, shrink_mini)
end
		
local function grow_mini(inst, time, startsize, endsize)
	inst.Transform:SetScale(0.1, 0.1, 0.1)
	inst.components.sizetweener:StartTween(1.5, 8, shrinktask_mini)
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
	
    inst.AnimState:SetBank("shadowvortex")
    inst.AnimState:SetBuild("shadowvortex")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst.LightWatcher:SetLightThresh(.2)
    inst.LightWatcher:SetDarkThresh(.19)
	--inst:ListenForEvent("enterlight", Disappear)
	
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("sizetweener")
	
	inst.grow_mini = grow_mini
	inst:grow_mini()
	--inst.entity:Hide()

	--inst:DoTaskInTime(0, OnInit)

    --inst:ListenForEvent("enterlight", Disappear)
	
	inst:DoPeriodicTask(FRAMES, Vac)
	inst:DoPeriodicTask(1.5, Beat)
	
    inst.persists = false
	
    return inst
end

return Prefab("shadowvortex", fn, assets, prefabs)
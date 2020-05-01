local assets =
{
	Asset("ANIM", "anim/shadow_eye.zip")
}


local AURA_EXCLUDE_TAGS = { "noauradamage", "INLIMBO", "notarget", "noattack" }

local NOTAGS = { "playerghost", "INLIMBO" }

local function TryFear(v)
	if v.components.health ~= nil and v.components.sanity and v.components.sanity:IsInsane() then
		v.components.health:DoDelta(-1)
	end
			
	if v.components.sanity and not v.components.sanity:IsInsane() then
		v.components.sanity:DoDelta(-1)
	end
end

local function DoAreaFear(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, inst.components.aura.radius, nil, NOTAGS, { "_health" })
	
	if not inst.AnimState:IsCurrentAnimation("spawn") then
		for i, v in ipairs(ents) do
			TryFear(v)
		end
	end
end

local function changeidle(inst)
	if inst.AnimState:IsCurrentAnimation("unburrow") and not inst.AnimState:IsCurrentAnimation("despawn") then
		inst.AnimState:PushAnimation("idle_out",true)
		if inst.idletask ~= nil then
			inst.idletask:Cancel()
			inst.idletask = nil
		end
	elseif inst.AnimState:IsCurrentAnimation("burrow") and not inst.AnimState:IsCurrentAnimation("despawn") then
		inst.AnimState:PushAnimation("idle",true)
		if inst.idletask ~= nil then
			inst.idletask:Cancel()
			inst.idletask = nil
		end
	elseif inst.AnimState:IsCurrentAnimation("despawn") then
		inst:Remove()
	end
end

local function onnear(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 10, nil, NOTAGS, { "player" })
	
	if ents ~= nil and not inst.AnimState:IsCurrentAnimation("idle_out") and not inst.AnimState:IsCurrentAnimation("despawn") then
		inst.AnimState:PushAnimation("unburrow")
		if inst.idletask ~= nil then
			inst.idletask:Cancel()
			inst.idletask = nil
		end
		
		inst.idletask = inst:DoPeriodicTask(FRAMES, changeidle)
	end
end

local function onfar(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents2 = TheSim:FindEntities(x, y, z, 10, nil, NOTAGS, { "player" })

	if ents2 ~= nil and not inst.AnimState:IsCurrentAnimation("idle") and not inst.AnimState:IsCurrentAnimation("despawn") then
		inst.AnimState:PushAnimation("burrow")
		if inst.idletask ~= nil then
			inst.idletask:Cancel()
			inst.idletask = nil
		end
		
		inst.idletask = inst:DoPeriodicTask(FRAMES, changeidle)
	end
end

local function CancelCreepingSound(inst)
	inst.SoundEmitter:KillSound("creeping")
end

local function snowpilefn(Sim)
	-- print ('sandhillfn')
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    local s  = 1.65
    inst.Transform:SetScale(s, s, s)

	inst.idletask = nil
			
	anim:SetBuild("shadow_eye")
	anim:SetBank("shadow_eye")
	anim:PlayAnimation("spawn")
	
	inst.AnimState:SetMultColour(0, 0, 0, 0.5)
	
	inst:AddTag("shadow_eye")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowhand_creep", "creeping")
	inst:DoTaskInTime(2, CancelCreepingSound)
	--[[
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 15, nil, nil, { "shadow_eye" })
	if ents ~= nil then
		inst:DoTaskInTime(0, inst:Remove())
	end--]]
	
	inst:AddComponent("aura")
    inst.components.aura.radius = 10
    inst.components.aura.tickperiod = TUNING.TOADSTOOL_SPORECLOUD_TICK * 2
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)
    inst._coldtask = inst:DoPeriodicTask(inst.components.aura.tickperiod / 2, DoAreaFear, inst.components.aura.tickperiod / 2)

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 11) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)

	inst:ListenForEvent("animover", changeidle)
	
	inst:DoTaskInTime(10, function(inst)
		if inst.idletask ~= nil then
			inst.idletask:Cancel()
		end
		
		inst.AnimState:PushAnimation("despawn")
		
	end)
	
    inst.persists = false
	
	return inst
end

return Prefab("mini_dreadeye", snowpilefn, assets, prefabs)

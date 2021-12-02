local assets =
{
	--Asset("ANIM", "anim/shroom_skin_fragment.zip"),
}

local function SpawnBurst(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local ents = TheSim:FindEntities(x, y, z, 30, { "player" })

	inst.x1 = x + (#ents > 0 and math.random(-30, 30) or math.random(-80, 80))
	inst.z1 = z + (#ents > 0 and math.random(-30, 30) or math.random(-80, 80))

	if inst.x1 ~= nil and inst.z1 ~= nil then
		SpawnPrefab("rneearthquake_burst").Transform:SetPosition(inst.x1, 0, inst.z1)
	end
end

local function Fx1(inst)
	if inst.quaking then
		ShakeAllCameras(CAMERASHAKE.FULL, 5, 0.05, 0.2, inst, 80)
		
		if inst.bursttask == nil then
			inst.bursttask = inst:DoPeriodicTask(0.2, SpawnBurst)
		end
	else
		ShakeAllCameras(CAMERASHAKE.FULL, .2, 0.1, 0.1, inst, 50)
	end
end

local function startquaking(inst)
	inst.quaking = true
    inst.SoundEmitter:SetParameter("earthquake", "intensity", 1)
end

local function winddown(inst)
    inst.SoundEmitter:SetParameter("earthquake", "intensity", 0.5)
end

local function OnIsDay(inst)
	if TheWorld.state.isday then
		inst:Remove()
	end
end

local function fn()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst:AddTag("fx")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.x1 = nil
	inst.x1 = nil
	inst.bursttask = nil
	
    inst.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "earthquake")
    inst.SoundEmitter:SetParameter("earthquake", "intensity", .1)
	
	inst:DoPeriodicTask(0.5, Fx1)
	inst:DoTaskInTime(15, startquaking)
	inst:DoTaskInTime(100, winddown)
	inst:DoTaskInTime(120, inst.Remove)
    inst:WatchWorldState("isday", OnIsDay)
    OnIsDay(inst, TheWorld.state.isday)
	
	inst.quaking = false
    inst.persists = false

	return inst
end

local AREAATTACK_EXCLUDETAGS = { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }
local function Fx2(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local pt = inst:GetPosition()
	local boat = TheWorld.Map:GetPlatformAtPoint(x, z)
	
	ShakeAllCameras(CAMERASHAKE.FULL, 5, 0.05, 0.2, inst, 10)

	if inst:IsOnOcean() then
		SpawnPrefab("antlion_sinkhole_ripple").Transform:SetPosition(inst.Transform:GetWorldPosition())
	else
		SpawnPrefab("groundpound_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		SpawnPrefab("slide_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	
	local chance = math.random()
		
	if chance > 0.66 then
		if boat then
			boat:PushEvent("spawnnewboatleak", {pt = pt, leak_size = "small_leak", playsoundfx = true})
		elseif inst:IsOnOcean() then
			SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition())
		else
			SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		
		inst.components.combat:SetDefaultDamage(5)
		inst.components.combat:DoAreaAttack(inst, 2, nil, nil, nil, AREAATTACK_EXCLUDETAGS)
	elseif chance <= 0.66 and chance > 0.33 then
		if boat then
			boat:PushEvent("spawnnewboatleak", {pt = pt, leak_size = "med_leak", playsoundfx = true})
		elseif inst:IsOnOcean() then
			SpawnPrefab("splash_green_large").Transform:SetPosition(inst.Transform:GetWorldPosition())
		else
			SpawnPrefab("round_puff_fx_lg").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		
		inst.components.combat:SetDefaultDamage(10)
		inst.components.combat:DoAreaAttack(inst, 3.5, nil, nil, nil, AREAATTACK_EXCLUDETAGS)
	end
	
	inst:Remove()
end

local function Init(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local boat = TheWorld.Map:GetPlatformAtPoint(x, z)
	if boat then
		SpawnPrefab("antlion_sinkhole_ripple").Transform:SetPosition(inst.Transform:GetWorldPosition())
	elseif inst:IsOnOcean() then
		SpawnPrefab("ocean_splash_ripple2").Transform:SetPosition(inst.Transform:GetWorldPosition())
	else
		SpawnPrefab("sinkhole_warn_fx_1").Transform:SetPosition(inst.Transform:GetWorldPosition())
		SpawnPrefab("sinkhole_warn_fx_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
		SpawnPrefab("sinkhole_warn_fx_3").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local function burstfn()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst:AddTag("fx")
	inst:AddTag("notarget")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(5)
	
	inst:DoTaskInTime(0, Init)
	inst:DoPeriodicTask(math.random() + 0.5, Fx2)
    inst.persists = false

	return inst
end

return Prefab("rneearthquake", fn, assets, prefabs),
		Prefab("rneearthquake_burst", burstfn, assets, prefabs)
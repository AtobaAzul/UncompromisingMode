local assets =
{
    Asset("ANIM", "anim/shroom_skin_fragment.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("deer_ice_burst")
    inst.AnimState:SetBuild("deer_ice_burst")
    inst.AnimState:PlayAnimation("loop")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_shoot", nil, .2)
	--inst.SoundEmitter:SetParameter("airconditionerpuff", "intensity", 0.1)
	inst:ListenForEvent("animover", inst.Remove)

    return inst
end

require "stategraphs/SGleechswarm"
local brain = require "brains/pollenmitesbrain"

local assets=
{
	Asset("ANIM", "anim/gnat.zip"),
}
	
local prefabs =
{

}

local function TimeToDie(inst)
	inst.Light:Enable(false)
	
	if inst.bitetask ~= nil then
		inst.bitetask:Cancel()
		inst.bitetask = nil
	end
	
	inst.components.health:Kill()
end

local function RemoveSmokeTag(inst)
	inst:RemoveTag("ac_smoke_host")
	
	if inst.ac_smoketask ~= nil then
		inst.ac_smoketask:Cancel()
		inst.ac_smoketask = nil
	end
end

local function bite(inst)
	if inst.host ~= nil and inst.host:IsValid() and not inst.host:HasTag("playerghost") and inst:GetDistanceSqToInst(inst.host) <= 10 then
		inst.host:AddTag("ac_smoke_host")
		
		if inst.host.ac_smoketask ~= nil then
			inst.host.ac_smoketask:Cancel()
			inst.host.ac_smoketask = nil
		end
		
		inst.host.ac_smoketask = inst.host:DoTaskInTime(2, RemoveSmokeTag)
		
		inst.host.components.health:DoDelta(inst.blue / 2)
		inst.host.components.sanity:DoDelta(inst.green / 2)
			
		if inst.host.components.hayfever ~= nil and inst.host.components.hayfever.nextsneeze < 240 then
			inst.host.components.hayfever:SetNextSneezeTime(inst.host.components.hayfever.nextsneeze + inst.red)
		end
    
        inst.host.components.health:DeltaPenalty(-inst.red*0.01)
	else
		TimeToDie(inst)
	end
end

local function OnNear(inst, target)
	if target ~= nil and target:IsValid() and not target:HasTag("ac_smoke_host") then
		inst.Physics:Stop()
		inst.host = target
		inst:RemoveComponent("playerprox")
		inst.entity:SetParent(target.entity)
		inst.Transform:SetPosition(0, 0, 0)	
		inst.components.timer:SetTimeLeft("die", 31.1)
		inst.brain:Stop()
		bite(inst)
		inst.bitetask = inst:DoPeriodicTask(1, bite)
	end
end

local function ResetTimer(inst)
	inst.components.timer:SetTimeLeft("die", 31.1)
end

local function fn2()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    MakeFlyingCharacterPhysics(inst, 1, .5)
	inst.Transform:SetFourFaced()
	RemovePhysicsColliders(inst)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
	
	inst.Light:SetColour(50, 50, 50)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetRadius(1)
	inst.Light:Enable(true)
	
	inst.AnimState:SetBuild("air_conditioner_cloud")
	inst.AnimState:SetBank("gnat")
	inst.AnimState:PlayAnimation("idle_loop")
	inst:AddTag("soulless")
    inst:AddTag("noember")

	inst:AddTag("fx")
	inst:AddTag("notarget")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.red = 0
	inst.blue = 0
	inst.green = 0
	
	inst:AddComponent("locomotor")
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 12 
 
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(1.5, 2)
	inst.components.playerprox:SetOnPlayerNear(OnNear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(500)
	
	inst:AddComponent("timer")
	
	inst:SetStateGraph("SGleechswarm")
	inst:SetBrain(brain)
	
	inst.components.timer:StartTimer("die", 30)
	inst:ListenForEvent("oninfest", ResetTimer)

	inst:ListenForEvent("timerdone", TimeToDie)
	
    inst.persists = false

	return inst
end

return Prefab( "air_conditioner_smoke", fn, assets, prefabs),
	Prefab("air_conditioner_cloud", fn2, assets)

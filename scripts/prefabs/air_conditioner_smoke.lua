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

local function keeptargetfn(inst, target)
   return target:HasTag("player")
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
end

local function NormalRetarget(inst)
    local targetDist = 4
    local notags = {"FX", "NOCLICK", "INLIMBO", "playerghost"}
	return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy)
			and guy.components.combat
			and guy.components.health
			and not guy.components.health:IsDead() and not guy:HasTag("infested") then
                return guy:HasTag("player")
            end
    end, nil, notags)
end

local function bite(inst)
	--[[if inst.components.infester.target:HasTag("playerghost") then
		inst.components.infester.Uninfest()
	else]]
	if inst.components.infester.target:HasTag("playerghost") then
		inst.components.health:Kill()
	end
	
	if inst.components.infester.target then
		inst.components.infester.target.components.health:DoDelta(inst.blue / 2)
		inst.components.infester.target.components.sanity:DoDelta(inst.green / 2)
		
		if inst.components.infester.target.components.hayfever ~= nil and inst.components.infester.target.components.hayfever.nextsneeze < 240 then
			inst.components.infester.target.components.hayfever:SetNextSneezeTime(inst.components.infester.target.components.hayfever.nextsneeze + inst.red)
		end
	end
end

local function findlight(inst)
    local targetDist = 15
    local notags = {"FX", "NOCLICK","INLIMBO"}
	local light = FindEntity(inst, targetDist, 
        function(guy) 
            if guy.Light and guy.Light:IsEnabled() then
                return true
            end
    end, nil, notags)

    return light
end

local function stopinfesttest(inst)
	if  TheWorld.state.isdusk or TheWorld.state.isnight then
		local target = findlight(inst)
		if target and inst:GetDistanceSqToInst(target) > 5*5 then
			return target
		end
	end
end

local function ResetTimer(inst)
	inst.components.timer:SetTimeLeft("die", 31.1)
end

local function TimeToDie(inst)
	inst.components.health:Kill()
end

local function fn2()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    MakeFlyingCharacterPhysics(inst, 1, .5)
	inst.Transform:SetFourFaced()
	RemovePhysicsColliders(inst)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
	
	inst.AnimState:SetBuild("air_conditioner_cloud")
	inst.AnimState:SetBank("gnat")
	inst.AnimState:PlayAnimation("idle_loop")
	inst:AddTag("soulless")
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
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "fx_puff"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)

    --inst.components.combat:SetDefaultDamage(1)
    --inst.components.combat:SetAttackPeriod(5)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)    
 
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(500)

	inst:AddComponent("infester")
	inst.components.infester.basetime = 1
	inst.components.infester.randtime = 0
	inst.components.infester.bitefn = bite
	inst.components.infester.stopinfesttestfn = stopinfesttest
	
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

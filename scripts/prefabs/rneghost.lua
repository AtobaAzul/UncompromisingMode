local assets =
{
    Asset("ANIM", "anim/player_ghost_withhat.zip"),
    Asset("ANIM", "anim/ghost_build.zip"),
    Asset("SOUND", "sound/ghost.fsb"),
}

local prefabs =
{
}

local brain = require "brains/rneghostbrain"

local function AbleToAcceptTest(inst, item)
    return false, item.prefab == "reviver" and "GHOSTHEART" or nil
end

local function OnDeath(inst)
    inst.components.aura:Enable(false)
end

local function AuraTest(inst, target)
    if inst.components.combat:TargetIs(target) or (target.components.combat.target ~= nil and target.components.combat:TargetIs(inst)) then
        return true
    end

    return not target:HasTag("ghostlyfriend") and not target:HasTag("abigail")
end

local function OnAttacked(inst, data)
--    print("onattack", data.attacker, data.damage, data.damageresolved)

    if data.attacker == nil then
        inst.components.combat:SetTarget(nil)
    elseif not data.attacker:HasTag("noauradamage") then
       inst.components.combat:SetTarget(data.attacker) 
    end
end

local function KeepTargetFn(inst, target)
    if target and inst:GetDistanceSqToInst(target) < TUNING.GHOST_FOLLOW_DSQ then
        return true
    end

    inst.brain.followtarget = nil

    return false
end

local function DismissOtherGhosts(inst)
local m,n,o = inst.Transform:GetWorldPosition()
local ghosts = TheSim:FindEntities(m,n,o, 100, {"ghost"})
	for i, v in ipairs(ghosts) do
	inst.sg:GoToState("dissipate")
	end
inst.sg:GoToState("dissipate")
end

local function TakeAllFire(inst)
local m,n,o = inst.Transform:GetWorldPosition()
DismissOtherGhosts(inst)
if not TheWorld.state.isday then
local firestuffs = TheSim:FindEntities(m,n,o, 100, {"campfire"})
	for i, v in ipairs(firestuffs) do
	if v.components.fueled ~= nil then
	v.components.fueled:MakeEmpty()
	v.components.fueled.accepting = false
	v:DoTaskInTime(120,function(v) v.components.fueled.accepting = true end)
								
	end
	end
local lightstuffs = TheSim:FindEntities(m,n,o, 100, {"lighttarget1"})
	for i, v in ipairs(lightstuffs) do
	if v.components.fueled ~= nil then
	v.components.fueled:MakeEmpty()
	v.components.fueled.accepting = false
	v:DoTaskInTime(120,function(v) v.components.fueled.accepting = true end)
									
	end
	end
local stafflights = TheSim:FindEntities(m,n,o, 100, {"lightarget2"}) --Ghosts seem to refuse to take this
	for i, v in ipairs(stafflights) do
    v:Remove()					
	end
local plights = TheSim:FindEntities(m,n,o, 100, {"plight"})
	for i, v in ipairs(plights) do 
    v.AnimState:PlayAnimation("rotten")
    v.components.health:Kill()
	end
local mlight1 = TheSim:FindEntities(m,n,o, 100, {"mlight1"})
	for i, v in ipairs(mlight1) do 
        if v.components.container ~= nil then
            v.components.container:DropEverything()
            v.components.container:Close()
			v:RemoveComponent("container")
			v:DoTaskInTime("120",function(v) 
			v:AddComponent("container")	
			v.components.container:WidgetSetup("mushroom_light")
			end)
        end
	end
local mlight2 = TheSim:FindEntities(m,n,o, 100, {"mlight2"})
	for i, v in ipairs(mlight2) do 
        if v.components.container ~= nil then
            v.components.container:DropEverything()
            v.components.container:Close()
			v:RemoveComponent("container")
			v:DoTaskInTime("120",function(v) 
			v:AddComponent("container")	
			v.components.container:WidgetSetup("mushroom_light2")
			end)
        end
	end
local scalelight = TheSim:FindEntities(m,n,o, 100, {"dlight"})
	for i, v in ipairs(scalelight) do
	print("foundscaled")
		v.Light:Enable(false)
		v:DoTaskInTime("120",function(v)
		v.Light:Enable(true)
		end)
		if v.components.heater ~= nil then
			v:RemoveComponent("heater")
			v:DoTaskInTime("120",function(v)
			v:AddComponent("heater")
			v.components.heater.heat = 115
			end)
		end
	end
end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeGhostPhysics(inst, .5, .5)

    inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
    inst.AnimState:SetLightOverride(TUNING.GHOST_LIGHT_OVERRIDE)

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(.5)
    inst.Light:SetFalloff(.6)
    inst.Light:Enable(true)
    inst.Light:SetColour(180/255, 195/255, 225/255)

    inst.AnimState:SetBank("ghost")
    inst.AnimState:SetBuild("ghost_build")
    inst.AnimState:PlayAnimation("idle", true)
    --inst.AnimState:SetMultColour(1,1,1,.6)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("ghost")
    inst:AddTag("noauradamage")

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetBrain(brain)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.GHOST_SPEED
    inst.components.locomotor.runspeed = TUNING.GHOST_SPEED
    inst.components.locomotor.directdrive = true

    inst:SetStateGraph("SGghost")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.GHOST_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat.defaultdamage = TUNING.GHOST_DAMAGE
    inst.components.combat.playerdamagepercent = TUNING.GHOST_DMG_PLAYER_PERCENT
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("aura")
    inst.components.aura.radius = TUNING.GHOST_RADIUS
    inst.components.aura.tickperiod = TUNING.GHOST_DMG_PERIOD
    inst.components.aura.auratestfn = AuraTest

    --Added so you can attempt to give hearts to trigger flavour text when the action fails
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)
    inst:ListenForEvent("death", OnDeath)
    inst:ListenForEvent("attacked", OnAttacked)
	inst:DoTaskInTime(20,TakeAllFire)
    ------------------

    return inst
end

return Prefab("rneghost", fn, assets, prefabs)

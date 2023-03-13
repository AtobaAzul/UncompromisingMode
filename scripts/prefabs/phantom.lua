local assets =
{
    Asset("ANIM", "anim/phantom.zip"),
}

local prefabs =
{
}

SetSharedLootTable( 'phantom',
{
    {'um_spectoplasm',  1.00},
	{'um_spectoplasm',  0.50},
})

local brain = require "brains/phantombrain"

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

local function OnNewTarget(inst,data)
TheNet:SystemMessage("Got a new target")
	if data and data.target and not inst.circling == true then
		TheNet:SystemMessage("I just set inst.circling to true.")
		inst.circling = true
		inst.components.circler:SetCircleTarget(data.target)
		inst.components.circler:Start()
	end
end

local function ReflectionMode(inst)
	inst.AnimState:SetScale(1, -1)
	inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
	inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)
	inst.AnimState:SetMultColour(1, 1, 1, 0.2)
	inst:AddTag("notarget")
end

local function RealMode(inst)
	inst.AnimState:SetScale(1, 1)
    inst.AnimState:SetSortOrder(0)
    inst.AnimState:SetLayer(LAYER_WORLD)
	inst.AnimState:SetMultColour(1, 1, 1, 1)
	inst:RemoveTag("notarget")
end

local function RedoPoint(inst)
	if inst.point then
		TheNet:Announce("point was not nill")
		inst.point = nil
	else
		TheNet:Announce("point was nil")
		inst.point = FindSwimmableOffset(inst:GetPosition(), math.random() * PI * 2, 5)
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
	inst.Transform:SetFourFaced()
    inst.AnimState:SetBank("phantom")
    inst.AnimState:SetBuild("phantom")
    inst.AnimState:PlayAnimation("idle", true)
    --inst.AnimState:SetMultColour(1,1,1,.6)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("ghost")
    inst:AddTag("flying")
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
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 3
	    
	inst:AddComponent("circler")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("teamattacker") --Doesn't work without a home!
	inst.components.teamattacker.team_type = "phantom"
	
    inst:SetStateGraph("SGphantom")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.GHOST_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat.defaultdamage = TUNING.GHOST_DAMAGE
    inst.components.combat.playerdamagepercent = TUNING.GHOST_DMG_PLAYER_PERCENT
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)


    --Added so you can attempt to give hearts to trigger flavour text when the action fails
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)

    inst:ListenForEvent("death", OnDeath)
    inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("newcombattarget", OnNewTarget)
    ------------------
	inst.ReflectionMode = ReflectionMode
	inst.RealMode = RealMode
	inst:DoPeriodicTask(10,RedoPoint)
	
	
	inst:DoPeriodicTask(4,function(inst)
		if inst:HasTag("notarget") then
			inst.sg:GoToState("surface")
		else
			inst.sg:GoToState("dive")
		end
	end)
	
    return inst
end

local function fnplasm()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nightmarefuel")
    inst.AnimState:SetBuild("nightmarefuel")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetMultColour(1, 1, 1, 0.5)
    inst.AnimState:UsePointFiltering(true)

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inventoryitem")
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('phantom')
    return inst
end

return Prefab("phantom", fn, assets),
Prefab("um_spectoplasm",fnplasm)

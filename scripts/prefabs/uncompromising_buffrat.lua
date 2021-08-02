local brain = require("brains/swilsonbrain")

local assets =
{
    Asset("ANIM", "anim/lavaarena_beetletaur.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_basic.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_actions.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_block.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_fx.zip"),
    Asset("ANIM", "anim/lavaarena_beetletaur_break.zip"),
	Asset("ANIM", "anim/uncompromising_buffrat.zip"),
    Asset("ANIM", "anim/healing_flower.zip"),
    Asset("ANIM", "anim/fossilized.zip"),
}

SetSharedLootTable('uncompromising_buffrat',
{
    {'chester',     1.0},
	{'glommer',     1.0},
})

local SHARE_TARGET_DIST = 30

local function NormalRetarget(inst)
    local targetDist = 30
    if inst.components.knownlocations:GetLocation("investigate") then
        targetDist = 32
    end
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy) then
                return guy:HasTag("character") or guy:HasTag("pig")
            end
    end)
end

local function keeptargetfn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
	if data ~= nil and data.damage ~= nil then
		inst.damage = data.damage + inst.damage
		if inst.damage > 100 and inst.mode ~= "offense" and not inst.sg:HasStateTag("jumping") then
			inst.mode = "offense"
			inst.sg:GoToState("offense_pre")
		end
	end
end

local function UpdateMode(inst)
	if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
		if inst:GetDistanceSqToInst(inst.components.combat.target) > 60 and inst.mode ~= "defence" then
			inst.mode = "defence"
			inst.sg:GoToState("defence_pre")
		end
	else
		inst.mode = "offense"
		inst.sg:GoToState("offense_pre")
	end
	inst.damage = 0
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, .5 )
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    inst.Transform:SetFourFaced()

	MakeCharacterPhysics(inst, 10, .5)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	inst:AddTag("ratraid")
    inst.AnimState:SetBank("beetletaur")
    inst.AnimState:SetBuild("uncompromising_buffrat")
    inst.AnimState:PlayAnimation("idle_loop",true)

	
    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 6

    inst:SetStateGraph("SGuncompromising_buffrat")
	
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('uncompromising_buffrat')
	

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(2000)
	inst.components.health:SetAbsorptionAmount(0)
    ------------------
	inst:SetBrain(brain)
	
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)    
    inst.components.combat:SetDefaultDamage(34)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetHurtSound("dontstarve/sanity/creature1/death")
    inst.components.combat:SetRange(4, 4)
    ------------------
    
    ------------------
    
    inst:AddComponent("knownlocations")
    ------------------
    --inst.Transform:SetScale(0.75,0.75,0.75)
    
    ------------------
    inst.punchcount = 0
	inst.damage = 0
	inst.mode = "offense"
	inst:DoPeriodicTask(2,UpdateMode)
    inst:AddComponent("inspectable")
    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("uncompromising_buffrat", fn, assets)
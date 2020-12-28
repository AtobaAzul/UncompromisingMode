
local brain = require "brains/bightbrain"
local assets =
{

}
    
    
local prefabs =
{

}

SetSharedLootTable('bight',
{
    {'nightmarefuel',     1.0},
	{'nightmarefuel',     1.0},
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
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("swilson") and not dude.components.health:IsDead() end, 5)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    

    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetSixFaced()
    inst.AnimState:SetBank("bight")
    inst.AnimState:SetBuild("bight")
    inst.AnimState:PlayAnimation("idle_loop",true)
	MakeCharacterPhysics(inst, 10, .5)
	--MakePoisonableCharacter(inst)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 6

    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('bight')
    
    ---------------------            
    --MakeMediumBurnableCharacter(inst, "torso")
    --MakeMediumFreezableCharacter(inst, "torso")    
    --inst.components.burnable.flammability = 0.33
    ---------------------       
    
	
	inst:AddTag("monster")
    inst:AddTag("hostile")   
    inst:AddTag("swilson") 
	inst:AddTag("nightmarecreature")
	inst:AddTag("shadow")
	inst:AddTag("notraptrigger")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1000)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)    
    inst.components.combat:SetDefaultDamage(37)
    inst.components.combat:SetAttackPeriod(4)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetHurtSound("dontstarve/sanity/creature1/death")
    inst.components.combat:SetRange(2, 2)
    ------------------
    
    ------------------
    
    inst:AddComponent("knownlocations")
    ------------------
    
    
    ------------------
    
    inst:AddComponent("inspectable")

    ------------------
    
    inst:SetStateGraph("SGbight")
    inst:SetBrain(brain)
	inst.sg:GoToState("waken")
    return inst
end

return Prefab("bight", fn, assets, prefabs)
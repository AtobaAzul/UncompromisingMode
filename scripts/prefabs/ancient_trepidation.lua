require "stategraphs/SGancient_trepidation"

local brain = require "brains/nightmarecreaturebrain"
local assets =
{
}
    
 

SetSharedLootTable( 'ancient_trepidation',
{
    {'nightmarefuel',  1.00},
})


local SHARE_TARGET_DIST = 30

local function NormalRetarget(inst)
    local targetDist = 6
    if inst.components.knownlocations:GetLocation("investigate") then
        targetDist = 8
    end
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy) then
                return guy:HasTag("character") or guy:HasTag("pig")
            end
    end)
end

local function FindWarriorTargets(guy)
	return (guy:HasTag("character") or guy:HasTag("pig"))
               and inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy)
end

local function keeptargetfn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
          and not (inst.components.follower and inst.components.follower.leader == target)
end


local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

    local sounds =
    {
        attack = "dontstarve/sanity/creature2/attack",
        attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
        death = "dontstarve/sanity/creature2/die",
        idle = "dontstarve/sanity/creature2/idle",
        taunt = "dontstarve/sanity/creature2/taunt",
        appear = "dontstarve/sanity/creature2/appear",
        disappear = "dontstarve/sanity/creature2/dissappear",
    }

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(2, 2, 2)
        MakeCharacterPhysics(inst, 10, 1.5)
        RemovePhysicsColliders(inst)
        inst.Physics:SetCollisionGroup(COLLISION.SANITY)
        inst.Physics:CollidesWith(COLLISION.SANITY)   

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.AnimState:SetBank("ancient_trepidation")
    inst.AnimState:SetBuild("ancient_trepidation")
    inst.AnimState:PlayAnimation("give_life",true)
    
	inst.AnimState:SetMultColour(0, 0, 0, 0.8)
    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3/1.2
    inst.components.locomotor.runspeed = 5/1.2

    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('ancient_trepidation')
    
	
	inst:AddTag("monster")
    inst:AddTag("hostile") 
	inst:AddTag("shadowcreature")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(3000)
    ------------------
	inst:AddComponent("shadowsubmissive")
    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)    
    inst.components.combat:SetDefaultDamage(75)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    --inst.components.combat:SetHurtSound("dontstarve/creatures/spider/hit_response")
    inst.components.combat:SetRange(3, 3)
    ------------------
    
    ------------------
    inst.sounds = sounds   
    inst:AddComponent("knownlocations")
    ------------------
    
    ------------------
    
    
    ------------------
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
    
    inst:SetStateGraph("SGancient_trepidation")
    inst:SetBrain(brain)  
    inst:ListenForEvent("attacked", OnAttacked)
	inst.sg:GoToState("spawn")

    return inst
end

return Prefab( "ancient_trepidation", fn, assets, prefabs)
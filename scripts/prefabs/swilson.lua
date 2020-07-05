require "stategraphs/SGscorpion"

local brain = require "brains/swilsonbrain"
local assets =
{

}
    
    
local prefabs =
{

}

SetSharedLootTable('swilson',
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
local function Normalize(inst)
inst.components.combat:SetRange(2, 2)
inst.rush = false
end
local function Rush(inst)
if inst.components.combat ~= nil then
inst.components.combat:SetRange(0.5, 3)
inst.rush = true
end
inst:DoTaskInTime(3, Normalize)
inst:DoTaskInTime(7,Rush)
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

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()

	--shadow:SetSize(1, 0.75)
	inst.Transform:SetFourFaced()

	MakeCharacterPhysics(inst, 10, .5)
	--MakePoisonableCharacter(inst)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.AnimState:SetBank("swilson")
    inst.AnimState:SetBuild("swilson")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetMultColour(0, 0, 0, 0.6)
    
    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 2

    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('swilson')
    
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
    inst.components.health:SetMaxHealth(300)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)    
    inst.components.combat:SetDefaultDamage(37)
    inst.components.combat:SetAttackPeriod(1)
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
	SpawnPrefab("maxwell_smoke")
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
    
    inst:SetStateGraph("SGswilson")
    inst:SetBrain(brain) 
	inst.rush = false
	inst:DoTaskInTime(7,Rush)
	--[[inst:WatchWorldState("isday", function(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("statue_transition_2")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(1.2,1.2,1.2)
    end
	fx = SpawnPrefab("statue_transition")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(1.2,1.2,1.2)
    end
	inst:Remove()
	end)]]
    return inst
end

return Prefab( "swilson", fn, assets, prefabs)
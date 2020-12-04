require "stategraphs/SGancient_trepidation"

local brain = require "brains/trepidationbrain"
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
local function ResetAbilityCooldown(inst, ability)
    local id = ability.."_cd"
    local remaining = TUNING["STALKER_"..string.upper(id)] - (inst.components.timer:GetTimeElapsed(id) or TUNING.STALKER_ABILITY_RETRY_CD)
    inst.components.timer:StopTimer(id)
    if remaining > 0 then
        inst.components.timer:StartTimer(id, remaining)
    end
end	
local CHANNELER_SPAWN_RADIUS = 8.7
local CHANNELER_SPAWN_PERIOD = 1
local function DoSpawnChanneler(inst)
    if inst.components.health:IsDead() then
        inst.channelertask = nil
        inst.channelerparams = nil
        return
    end

    local x = inst.channelerparams.x + CHANNELER_SPAWN_RADIUS * math.cos(inst.channelerparams.angle)
    local z = inst.channelerparams.z + CHANNELER_SPAWN_RADIUS * math.sin(inst.channelerparams.angle)
    if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) then
        local channeler = SpawnPrefab("shadowchanneler")
        channeler.Transform:SetPosition(x, 0, z)
        channeler:ForceFacePoint(Vector3(inst.channelerparams.x, 0, inst.channelerparams.z))
        inst.components.commander:AddSoldier(channeler)
    end

    if inst.channelerparams.count > 1 then
        inst.channelerparams.angle = inst.channelerparams.angle + inst.channelerparams.delta
        inst.channelerparams.count = inst.channelerparams.count - 1
        inst.channelertask = inst:DoTaskInTime(CHANNELER_SPAWN_PERIOD, DoSpawnChanneler)
    else
        inst.channelertask = nil
        inst.channelerparams = nil
    end
end
local function SpawnChannelers(inst)
    ResetAbilityCooldown(inst, "channelers")

    local count = TUNING.STALKER_CHANNELERS_COUNT
    if count <= 0 or inst.channelertask ~= nil then
        return
    end

    local x, y, z = (inst.components.entitytracker:GetEntity("stargate") or inst).Transform:GetWorldPosition()
    inst.channelerparams =
    {
        x = x,
        z = z,
        angle = math.random() * 2 * PI,
        delta = -2 * PI / count,
        count = count,
    }
    DoSpawnChanneler(inst)
end
local function DespawnChannelers(inst)
    if inst.channelertask ~= nil then
        inst.channelertask:Cancel()
        inst.channelertask = nil
        inst.channelerparams = nil
    end
    for i, v in ipairs(inst.components.commander:GetAllSoldiers()) do
        if not v.components.health:IsDead() then
            v.components.health:Kill()
        end
    end
end
local function nodmgshielded(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return inst.hasshield and amount <= 0 and not ignore_absorb
end
local function OnSoldiersChanged(inst)
    if inst.hasshield ~= (inst.components.commander:GetNumSoldiers() > 0) then
        inst.hasshield = not inst.hasshield
        if not inst.hasshield then
            inst.components.timer:StopTimer("channelers_cd")
			inst.sg:GoToState("taunt")
            inst.components.timer:StartTimer("channelers_cd", TUNING.STALKER_CHANNELERS_CD)
        end
    end
end
local function StartAbility(inst, ability)
    inst.components.timer:StartTimer(ability.."_cd", TUNING.STALKER_ABILITY_RETRY_CD)
end
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
	inst.components.health.redirect = nodmgshielded
	inst.hasshield = false
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
	inst:AddComponent("commander")
	inst:AddComponent("timer")
	inst:AddComponent("entitytracker")
    inst:AddComponent("epicscare")
    inst.components.epicscare:SetRange(TUNING.STALKER_EPICSCARE_RANGE)
    ------------------
    
    inst.SpawnChannelers = SpawnChannelers
    inst.DespawnChannelers = DespawnChannelers
	inst.StartAbility = StartAbility    
    ------------------
    inst:ListenForEvent("soldierschanged", OnSoldiersChanged)    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL

    inst.components.timer:StartTimer("channelers_cd", TUNING.STALKER_FIRST_CHANNELERS_CD)    
    inst:SetStateGraph("SGancient_trepidation")
    inst:SetBrain(brain)  
    inst:ListenForEvent("attacked", OnAttacked)
	inst.sg:GoToState("spawn")

    return inst
end

return Prefab( "ancient_trepidation", fn, assets, prefabs)
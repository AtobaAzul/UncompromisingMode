local brain = require("brains/stumplingbrain")
local easing = require("easing")

local sounds =
{
    attack = "hookline/creatures/squid/attack",
    bite = "hookline/creatures/squid/gobble",
    taunt = "hookline/creatures/squid/taunt",
    death = "hookline/creatures/squid/death",
    sleep = "hookline/creatures/squid/sleep",
    hurt = "hookline/creatures/squid/hit",
    gobble = "hookline/creatures/squid/gobble",
    spit = "hookline/creatures/squid/spit",
    swim = "turnoftides/common/together/water/swim/medium",
}

SetSharedLootTable('stumpling',
{
    {'log', 1.0},
    {'twigs', 1.0},
    {'twigs', .5},
    {'pinecone', .25},
})

SetSharedLootTable('birchling',
{
    {'log', 1.0},
    {'twigs', 1.0},
    {'twigs', .5},
    {'acorn', .25},
})

local SHARE_TARGET_DIST = 30

local RETARGET_MUST_TAGS = { "character" }
local RETARGET_CANT_TAGS = { "stumpling", "monster", "leif" }
local function retargetfn(inst)
    return not (inst.sg:HasStateTag("hidden"))
        and FindEntity(
                inst,
                15,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
				RETARGET_MUST_TAGS,
                RETARGET_CANT_TAGS
            )
        or nil
end

local function KeepTarget(inst, target)
    return inst:IsNear(target, TUNING.SQUID_TARGET_KEEP)
end

local function IsEligible(player)
	--local area = player.components.areaaware
	return TheWorld.Map:IsVisualGroundAtPoint(player.Transform:GetWorldPosition())
			--and area:GetCurrentArea() ~= nil 
			--and not area:CurrentlyInTag("nohasslers")
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("stumpling"))
                and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil) and IsEligible(data.attacker)
        end, 5)
end

local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("stumpling"))
                and data.target ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end



local function OnEntitySleep(inst)
end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)

end

local function fnmain(TYPE)

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetSixFaced()

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("stumpling")
	inst:AddTag("plant")

    inst.AnimState:SetBank("birchling")
    inst.AnimState:SetBuild(TYPE)
    inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = sounds

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.SQUID_RUNSPEED
    inst.components.locomotor.walkspeed = TUNING.SQUID_WALKSPEED

    inst:SetStateGraph("SGstumpling")

	inst:AddComponent("embarker")
	inst.components.embarker.embark_speed = inst.components.locomotor.runspeed

    inst.components.locomotor:SetAllowPlatformHopping(true)

	


    inst:SetBrain(brain)

    inst:AddComponent("follower")
    inst:AddComponent("entitytracker")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SQUID_HEALTH)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.SQUID_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SQUID_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetRange(TUNING.SQUID_TARGET_RANGE, TUNING.SQUID_ATTACK_RANGE)
    inst.components.combat:EnableAreaDamage(true)
    inst.components.combat:SetAreaDamage(TUNING.SQUID_ATTACK_RANGE, 1, function(ent, inst) 
        if not (ent:HasTag("stumpling") or ent:HasTag("leif")) then
            return true
        else  
            if ent:IsValid() then   
                ent.SoundEmitter:PlaySound("hookline/creatures/squid/slap")         
                local x,y,z = ent.Transform:GetWorldPosition()
                local angle = inst:GetAngleToPoint(x,y,z) 
                ent.Transform:SetRotation(angle)
                ent.sg:GoToState("fling")
            end
        end
    end)

    inst.components.combat.battlecryenabled = false

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable(TYPE)

    inst:AddComponent("inspectable")
	
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    --inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    --inst.components.sleeper:SetSleepTest(function(inst) return false end)
    --inst.components.sleeper:SetWakeTest(function(inst) return true end)
	
    inst:AddComponent("knownlocations")
    
    inst:AddComponent("timer")



    MakeHauntablePanic(inst)
    MakeMediumFreezableCharacter(inst, "squid_body")
    MakeMediumBurnableCharacter(inst, "squid_body")

    inst.OnEntitySleep = OnEntitySleep

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)

  

    return inst
end

local function fnstumpling()
	return fnmain("stumpling")
end

local function fnbirchling()
	return fnmain("birchling")
end

return Prefab("stumpling", fnstumpling),
Prefab("birchling",fnbirchling)

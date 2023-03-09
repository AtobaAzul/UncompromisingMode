require "stategraphs/SGscorpion"

local brain = require "brains/spiderbrain"
local assets =
{
    Asset("ANIM", "anim/scorpion_basic.zip"),
    Asset("ANIM", "anim/scorpion_build.zip"),
}

SetSharedLootTable('scorpion',
    {
        { 'scorpioncarapace', 1.00 },
        { 'stinger', 0.3 },
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

local function keeptargetfn(inst, target)
    return target
        and target.components.combat
        and target.components.health
        and not target.components.health:IsDead()
        and not (inst.components.follower and inst.components.follower.leader == target)
end

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

--[[
local function DoReturn(inst)
	if inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home.components.childspawner then
		inst.components.homeseeker.home.components.childspawner:GoHome(inst)
	end
end

local function StartDay(inst)
	if inst:IsAsleep() then
		DoReturn(inst)	
	end
end


local function OnEntitySleep(inst)
	if GetClock():IsDay() then
		DoReturn(inst)
	end
end
]]


local function OnAttacked(inst, data)
    if data and data.attacker then
        inst.components.combat:SetTarget(data.attacker)
        inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
            function(dude) return dude:HasTag("scorpion") and not dude.components.health:IsDead() end, 1)
    end
end

local function OnHitOther(inst, data)
    local other = data.target
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if inst:HasTag("sleepattack") then
                local grogginess = other.components.grogginess
                if other._scorpion_debuff_immunitytask == nil and 
					grogginess ~= nil and not other.sg:HasStateTag("waking") and
                    not (other.components.rider and other.components.rider:IsRiding()) then
                    grogginess:AddGrogginess(TUNING.GESTALT.ATTACK_DAMAGE_GROGGINESS,
                        TUNING.GESTALT.ATTACK_DAMAGE_KO_TIME)
						
					if other._scorpion_debuff_immunity ~= nil then
						other._scorpion_debuff_immunitytask:Cancel()
					end
					
					other._scorpion_debuff_immunitytask = other:DoTaskInTime(2, function(i) 
						i._scorpion_debuff_immunitytask = nil 
					end)
					
                    if grogginess.knockoutduration == 0 then
                        print("getting attacked!")
                        --inst.sg.statemem.target.components.combat:GetAttacked(inst, 0)
                    else
                        -- TODO: turn on special hud overlay while asleep in enlightened dream land
                    end
                else
					if other._scorpion_debuff_immunity ~= nil then
						other._scorpion_debuff_immunitytask:Cancel()
					end
					
					other._scorpion_debuff_immunitytask = other:DoTaskInTime(2, function(i) 
						i._scorpion_debuff_immunitytask = nil 
					end)

                    print("getting attacked!")
                    --inst.sg.statemem.target.components.combat:GetAttacked(inst, 20)
                end
            end

        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1.5, .5)
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 10, .5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetBank("scorpion")
    inst.AnimState:SetBuild("scorpion_build")
    inst.AnimState:PlayAnimation("idle", true)

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 5


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('scorpion')

    ---------------------
    MakeMediumBurnableCharacter(inst, "scorpion_body")
    MakeMediumFreezableCharacter(inst, "scorpion_body")
    inst.components.burnable.flammability = 0.33
    ---------------------


    inst:AddTag("monster")
    inst:AddTag("animal")
    inst:AddTag("insect")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("scorpion")
    inst:AddTag("canbetrapped")

    inst:AddComponent("follower")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "scorpion_body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetHurtSound("dontstarve/creatures/spider/hit_response")
    inst.components.combat:SetRange(3, 3)
    ------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    ------------------

    inst:AddComponent("knownlocations")
    ------------------

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    ------------------

    inst:AddComponent("inspectable")

    ------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL

    inst:SetStateGraph("SGscorpion")
    inst:SetBrain(brain)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onhitother", OnHitOther)

    if not TUNING.DSTU.DESERTSCORPIONS then
        inst:Remove()
    end

    return inst
end

return Prefab("um_scorpion", fn, assets)

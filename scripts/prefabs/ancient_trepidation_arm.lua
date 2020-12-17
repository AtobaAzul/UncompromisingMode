

local RETARGET_MUST_TAGS = { "_combat", "_health", "player" }
local RETARGET_CANT_TAGS = { "prey" }
local function retargetfn(inst)
    return FindEntity(
        inst,
        TUNING.TENTACLE_ATTACK_DIST,
        function(guy) 
            return guy.prefab ~= inst.prefab
                and guy.entity:IsVisible()
                and not guy.components.health:IsDead()
                and (guy.components.combat.target == inst or
                    guy:HasTag("character") or
                    guy:HasTag("monster") or
                    guy:HasTag("animal"))
        end,
        RETARGET_MUST_TAGS,
        RETARGET_CANT_TAGS)
end

local function shouldKeepTarget(inst, target)
    return target ~= nil
        and target:IsValid()
        and target.entity:IsVisible()
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and target:IsNear(inst, TUNING.TENTACLE_STOPATTACK_DIST)
end

local function OnAttacked(inst, data)
    if data.attacker == nil then
        return
    end

    local current_target = inst.components.combat.target

    if current_target == nil then
        --Don't want to handle initiating attacks here;
        --We only want to handle switching targets.
        return
    elseif current_target == data.attacker then
        --Already targeting our attacker, just update the time
        inst._last_attacker = current_target
        inst._last_attacked_time = GetTime()
        return
    end

    local time = GetTime()
    if inst._last_attacker == current_target and
        inst._last_attacked_time + TUNING.TENTACLE_ATTACK_AGGRO_TIMEOUT >= time then
        --Our target attacked us recently, stay on it!
        return
    end

    --Switch to new target
    inst.components.combat:SetTarget(data.attacker)
    inst._last_attacker = data.attacker
    inst._last_attacked_time = time
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddPhysics()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.Transform:SetScale(2, 2, 2)
    inst.Physics:SetCylinder(0.25, 2)

    inst.AnimState:SetBank("ancient_trepidation_arm")
    inst.AnimState:SetBuild("ancient_trepidation_arm")
    inst.AnimState:PlayAnimation("emerge")
    inst.Transform:SetFourFaced()
    --inst:AddTag("monster")    
    inst:AddTag("hostile")
	inst:AddTag("shadow")
	--inst:AddTag("shadowcreature")	
    inst.entity:SetPristine()
	inst.AnimState:SetMultColour(0, 0, 0, 0.8)
    if not TheWorld.ismastersim then
        return inst
    end

    inst._last_attacker = nil
    inst._last_attacked_time = nil

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)

    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.TENTACLE_ATTACK_DIST)
    inst.components.combat:SetDefaultDamage(TUNING.TENTACLE_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.TENTACLE_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(GetRandomWithVariance(2, 0.5), retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)



    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED


    inst:SetStateGraph("SGtrepidation_arm")

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("ancient_trepidation_arm", fn)
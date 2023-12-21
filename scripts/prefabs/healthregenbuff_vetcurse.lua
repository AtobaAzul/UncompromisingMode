local function OnTick(inst, target, data)
    local duration, maxhp_percent
    if data ~= nil then
        duration = data.duration or 1
        maxhp_percent = type(data.maxhp_percent) == "number" and data.maxhp_percent or 0
    end
    --[[local warlybuff = target:HasTag("warlybuffed") and 2 or 1
	duration = duration / warlybuff]]
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        if data ~= nil and data.negative_value ~= nil and data.negative_value then
            if maxhp_percent ~= nil then
                target.components.health:DeltaPenalty(maxhp_percent)
            end
            target.components.health:DoDelta(data ~= nil and -duration or -1, nil, inst.prefab)
        else
            if maxhp_percent ~= nil then
                target.components.health:DeltaPenalty(-maxhp_percent)
            end
            target.components.health:DoDelta(data ~= nil and duration or 1, nil, inst.prefab)
        end
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target, followsymbol, followoffset, data)
    local duration = data ~= nil and data.duration and (data.duration / 2) or 1
    local dohealmaxhealth = data ~= nil and data.max_hp
    if dohealmaxhealth then
        local health = (duration * 2) * 10
        local totalhealth = target.components.health.maxhealth
        data.maxhp_percent = (health / totalhealth) * 0.1
    end
    local warlybuff = (target:HasTag("warlybuffed") and (target:HasTag("vetcurse") and 1.8 or 2)) or target:HasTag("vetcurse") and 0.8 or 1

    duration = duration / warlybuff

    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(data ~= nil and duration or 1, OnTick, nil, target, data)

    local newduration = ((duration * 10) + 0.01)
    inst.components.timer:StartTimer("regenover", newduration or 1)

    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target, followsymbol, followoffset, data)
    local duration = data ~= nil and data.duration and (data.duration / 2) or 1

    --local warlybuff = target:HasTag("warlybuffed") and 2 or target:HasTag("vetcurse") and 0.5 or 1
    local warlybuff = (target:HasTag("warlybuffed") and (target:HasTag("vetcurse") and 1.8 or 2)) or target:HasTag("vetcurse") and 0.8 or 1

    duration = duration / warlybuff


    local time_remaining = inst.components.timer:GetTimeLeft("regenover")
    if time_remaining ~= nil then
        local oldduration = (duration * 10)
        local newduration = time_remaining + oldduration

        if newduration < oldduration * 4 or data ~= nil and data.negative_value ~= nil and data.negative_value then
            local finalduration = time_remaining + oldduration
            inst.components.timer:SetTimeLeft("regenover", finalduration)
        else
            inst.components.timer:SetTimeLeft("regenover", oldduration * 4)
        end
    else
        inst.components.timer:StartTimer("regenover", duration * 10)
    end
end

local function fn_health()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = false

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

local function OnTick2(inst, target, data)
    local duration = data ~= nil and data.duration or 1

    --local warlybuff = target:HasTag("warlybuffed") and 2 or target:HasTag("vetcurse") and 0.5 or 1
    --local warlybuff = (target:HasTag("warlybuffed") and (target:HasTag("vetcurse") and 1.8) or 2) or target:HasTag("vetcurse") and 0.8 or 1
    --duration = duration / warlybuff

    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        target.components.sanity ~= nil and
        not target:HasTag("playerghost") then
        target.components.sanity:DoDelta(data ~= nil and duration or 1, nil, inst.prefab)
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached2(inst, target, followsymbol, followoffset, data)
    local duration = data ~= nil and data.duration and (data.duration / 2) or 1

    --local warlybuff = target:HasTag("warlybuffed") and 2 or target:HasTag("vetcurse") and 0.5 or 1
    local warlybuff = (target:HasTag("warlybuffed") and (target:HasTag("vetcurse") and 1.8 or 2)) or target:HasTag("vetcurse") and 0.8 or 1

    duration = duration / warlybuff

    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(data ~= nil and duration or 1, OnTick2, nil, target, data)

    local newduration = ((duration * 10) + 0.01)
    inst.components.timer:StartTimer("regenover", newduration or 1)

    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone2(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended2(inst, target, followsymbol, followoffset, data)
    local duration = data ~= nil and data.duration and (data.duration / 2) or 1

    --local warlybuff = target:HasTag("warlybuffed") and 2 or target:HasTag("vetcurse") and 0.5 or 1
    local warlybuff = (target:HasTag("warlybuffed") and (target:HasTag("vetcurse") and 1.8 or 2)) or target:HasTag("vetcurse") and 0.8 or 1
    duration = duration / warlybuff


    local time_remaining = inst.components.timer:GetTimeLeft("regenover")
    if time_remaining ~= nil then
        local oldduration = (duration * 10)
        local newduration = time_remaining + oldduration

        if newduration < oldduration * 4 then
            local finalduration = time_remaining + oldduration
            inst.components.timer:SetTimeLeft("regenover", finalduration)
        else
            inst.components.timer:SetTimeLeft("regenover", oldduration * 4)
        end
    else
        inst.components.timer:StartTimer("regenover", duration * 10)
    end
end

local function fn_sanity()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached2)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended2)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone2)

    return inst
end

local function OnTick3(inst, target, data)
    local intensity = data ~= nil and data.intensity or -1

    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        target.components.UM_hayfever ~= nil and target.components.UM_hayfever.enabled and
        not target:HasTag("playerghost") then
        target.components.UM_hayfever:DoDelta(intensity)
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached3(inst, target, followsymbol, followoffset, data)
    local duration = data ~= nil and data.duration or 1


    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(1, OnTick3, nil, target, data)

    inst.components.timer:StartTimer("regenover", duration or 1)

    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end


local function OnTimerDone3(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended3(inst, target, followsymbol, followoffset, data)
    local duration = data ~= nil and data.duration or 1

    local time_remaining = inst.components.timer:GetTimeLeft("regenover")
    if time_remaining ~= nil then
        local oldduration = duration
        local newduration = time_remaining + oldduration

        if newduration < oldduration * 4 then
            local finalduration = time_remaining + oldduration
            inst.components.timer:SetTimeLeft("regenover", finalduration)
        else
            inst.components.timer:SetTimeLeft("regenover", oldduration * 4)
        end
    else
        inst.components.timer:StartTimer("regenover", duration)
    end
end

local function fn_hayfever()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached3)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended3)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone3)

    return inst
end

return Prefab("healthregenbuff_vetcurse", fn_health),
    Prefab("healthregenbuff_vetcurse_walter_curse", fn_health),
    Prefab("sanityregenbuff_vetcurse", fn_sanity),
    Prefab("hayfeverbuff", fn_hayfever)

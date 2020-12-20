local function OnTick(inst, target, data)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target.components.health:DoDelta(data ~= nil and data.duration or 1, nil, inst.prefab)
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target, followsymbol, followoffset, data)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(data ~= nil and data.duration or 1, OnTick, nil, target, data)
	inst.components.timer:StartTimer("regenover", data ~= nil and ((data.duration * 10) + 0.1) or 1)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target, data)
	local duration = data ~= nil and data.duration or 1

    local time_remaining = inst.components.timer:GetTimeLeft("regenover")
	if time_remaining ~= nil then
		if (duration * 10) > time_remaining then
			inst.components.timer:SetTimeLeft("regenover", duration * 10)
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

local function OnTick2(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
		target.components.sanity ~= nil and
        not target:HasTag("playerghost") then
        target.components.sanity:DoDelta(data ~= nil and data.duration or 1, nil, inst.prefab)
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached2(inst, target, followsymbol, followoffset, data)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(data ~= nil and data.duration or 1, OnTick, nil, target, data)
	inst.components.timer:StartTimer("regenover", data ~= nil and ((data.duration * 10) + 0.1) or 1)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone2(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended2(inst, target, data)
	local duration = data ~= nil and data.duration or 1

    local time_remaining = inst.components.timer:GetTimeLeft("regenover")
	if time_remaining ~= nil then
		if (duration * 10) > time_remaining then
			inst.components.timer:SetTimeLeft("regenover", duration * 10)
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
    inst.components.debuff.keepondespawn = false

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone2)

    return inst
end

return Prefab("healthregenbuff_vetcurse", fn_health),
		Prefab("sanityregenbuff_vetcurse", fn_sanity)
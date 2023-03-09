local function OnTick(inst, target, data)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target.components.health:DoDelta(target:HasTag("player") and 1 or 2, nil, inst.prefab)
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target, followsymbol, followoffset, data)
	local duration = data ~= nil and data.duration and data.duration + 0.1 or 1
    inst.components.timer:StartTimer("walterbonus_timer", duration)

    inst.task = inst:DoPeriodicTask(1, OnTick, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "walterbonus_timer" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target, followsymbol, followoffset, data)
	local duration = data ~= nil and data.duration and data.duration + 0.1 or 1
	
    local time_remaining = inst.components.timer:GetTimeLeft("walterbonus_timer")
	if time_remaining ~= nil then
		local newduration = time_remaining + data.duration
		inst.components.timer:SetTimeLeft("walterbonus_timer", newduration)
	else
		inst.components.timer:StopTimer("walterbonus_timer")
		inst.components.timer:StartTimer("walterbonus_timer", data.duration)
	end
	
	if inst.task ~= nil then
		inst.task:Cancel()
	end
	
	inst.task = nil
    inst.task = inst:DoPeriodicTask(1, OnTick, nil, target)
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

return Prefab("walterbonus_buff", fn_health)
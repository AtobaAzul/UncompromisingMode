local function OnTick(inst, target)
    if target.components.health ~= nil
        and not target.components.health:IsDead()
		and target.components.sanity ~= nil
        and not target:HasTag("playerghost") then
        target.components.health:DoDelta(1, nil, "tillweedsalve")
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(1, OnTick, nil, target)
	local heal = 5
	if target.configheal ~= nil then
		heal = target.configheal
		target.configheal = nil
	end
	inst.components.timer:StartTimer("regenover", heal)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
	local heal = 5
	if target.configheal ~= nil then
		heal = target.configheal
		target.configheal = nil
	end
    inst.components.timer:StartTimer("regenover", heal)
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(1, OnTick, nil, target)
end


local function buff_fn()
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
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end


return Prefab("confighealbuff", buff_fn)

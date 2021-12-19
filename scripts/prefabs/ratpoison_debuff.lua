local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		
		local damage = -2
		
		if target:HasTag("raidrat") then
			damage = -5
		end
		
        target.components.health:DoDelta(damage, nil, "ratpoison")
		
		SpawnPrefab("crab_king_bubble"..math.random(3)).Transform:SetPosition(target.Transform:GetWorldPosition())
	else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
	target:AddTag("ratpoisoned")

    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(1, OnTick, nil, target)
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
    inst.components.timer:StartTimer("regenover", 180)
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(2, OnTick, nil, target)
end

local function fn()
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
    inst.components.timer:StartTimer("regenover", 180)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("ratpoison_debuff", fn)

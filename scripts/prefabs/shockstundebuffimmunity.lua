local function OhCrap(inst, target)
    if target.components.health ~= nil and not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		local x,y,z = target.Transform:GetWorldPosition()
		SpawnPrefab("sparks").Transform:SetPosition(x,y,z)
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
	target:AddTag("electricstunimmune")
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(math.random(1.5,2), OhCrap, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
	local x,y,z = target.Transform:GetWorldPosition()
	SpawnPrefab("sparks").Transform:SetPosition(x,y,z)
end

local function OnRemoved(inst,target)
target:RemoveTag("electricstunimmune")
end

local function OnTimerDone(inst, data)
    if data.name == "immunityover" then
        inst.components.debuff:Stop()
		inst.task:Cancel()
    end
end

local function OnExtended(inst, target)
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(0.2, OhCrap, nil, target)
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
    inst.components.debuff:SetDetachedFn(OnRemoved)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("immunityover", math.random(10,12))
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("shockstundebuffimmunity", fn)

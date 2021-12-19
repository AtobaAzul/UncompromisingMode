local function OhCrap(inst, target)
    if target.components.health ~= nil and not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
		SpawnPrefab("electricchargedfx"):SetTarget(target)
        target.components.health:DoDelta(-2, nil, "Electricity")
		if target.brain ~= nil then
            target.brain:Stop()
        end
		if target.sg and target.sg:GoToState("hit") ~= nil then
		target.sg:GoToState("hit")
		end
		if target.components.combat ~= nil then
		target.components.combat.laststartattacktime = target.components.combat.laststartattacktime + 0.2 --This apparently resets the targets attack timer making it a true "stun"
		end
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(0.2, OhCrap, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
	
	SpawnPrefab("electricchargedfx"):SetTarget(target)
end

local function OnRemoved(inst,target)
if target.brain ~= nil and not target.components.health:IsDead() then
   target.brain:Start()
end
end
local function OnTimerDone(inst, data)
    if data.name == "stunover" then
        inst.components.debuff:Stop()
		inst.task:Cancel()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("stunover")
    inst.components.timer:StartTimer("stunover", 1.2)
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
    inst.components.timer:StartTimer("stunover", 1.2)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("shockstundebuff", fn)

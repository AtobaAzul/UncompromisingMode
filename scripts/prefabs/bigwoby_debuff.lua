local function OnAttached(inst, target, followsymbol, followoffset, data)
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, inst.prefab, 0.75)
	end
    inst.components.timer:StartTimer("wobyscare", 20)
end

local function OnTimerDone(inst, data)
    if data.name == "wobyscare" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target, followsymbol, followoffset, data)
    inst.components.timer:StopTimer("wobyscare")
    inst.components.timer:StartTimer("wobyscare", 20)
end

local function OnDetach(inst, target)
	if target.components.locomotor ~= nil then
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, inst.prefab)
	end
	
	inst:Remove()
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
    inst.components.debuff:SetDetachedFn(OnDetach)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true
	

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("bigwoby_debuff", fn)

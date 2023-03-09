local function OnTick(inst, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
		SpawnPrefab("disease_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
		
		if not target:HasTag("epic") and target.components.combat:HasTarget() then
			target:PushEvent("attacked", { attacker = nil, damage = 0, weapon = inst })
		end
	else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target, followsymbol, followoffset, data)
    inst.components.timer:StartTimer("stinkyover", 4)

    inst.task = inst:DoPeriodicTask(1.9, OnTick, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "stinkyover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target, followsymbol, followoffset, data)
    inst.components.timer:StopTimer("stinkyover")
    inst.components.timer:StartTimer("stinkyover", 4)
	
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(1.9, OnTick, nil, target)
	end
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
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("wixie_stinkdebuff", fn)

local function ToggleSpawnFactor(inst)
	inst.spawnfactor = false
	inst:RemoveEventCallback("animover", ToggleSpawnFactor)
end

local function OnAttached(inst, target, followsymbol, followoffset, data)
	inst.SoundEmitter:PlaySound("dontstarve/sanity/creature1/taunt")

	inst.spawnfactor = true
	
	inst.AnimState:PlayAnimation("spawn")
	inst:ListenForEvent("animover", ToggleSpawnFactor)
	
	local duration = data ~= nil and 15 * data.powerlevel or 15
    inst.components.timer:StartTimer("buffover", duration)


    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 2, 0)
	
	if target.components.combat ~= nil and 
	target.components.combat.hiteffectsymbol ~= nil and
	target.components.combat.hiteffectsymbol ~= "marker" then
		inst.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
	end
	
	inst:ListenForEvent("wixiebite", function(target, data)
		if not inst.spawnfactor then
			inst.AnimState:PlayAnimation("bite")
			inst.AnimState:PushAnimation("idle", true)
			inst.SoundEmitter:PlaySound("dontstarve/sanity/creature1/attack_grunt")
		end
	end, target)
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
		inst.spawnfactor = true
		inst.AnimState:PlayAnimation("despawn")
		inst.SoundEmitter:PlaySound("dontstarve/sanity/creature1/death")
		
		inst:ListenForEvent("animover", function()
			inst.components.debuff:Stop()
		end)
    end
end

local function OnExtended(inst, target, followsymbol, followoffset, data)
	local duration = data ~= nil and 15 * data.powerlevel or 15

    inst.components.timer:StopTimer("buffover")
    inst.components.timer:StartTimer("buffover", duration)
end

local function fn()
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
	
    inst.AnimState:SetBank("curse_muncher")
    inst.AnimState:SetBuild("curse_muncher")
    inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetScale(0.5, 0.5, 0.5)
	inst.AnimState:SetMultColour(1, 1, 1, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.persists = false
    inst.spawnfactor = false

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("wixiecurse_debuff", fn)

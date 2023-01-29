-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------
local function electric_attach(inst, target)
    if target.components.electricattacks == nil then
        target:AddComponent("electricattacks")
    end
    target.components.electricattacks:AddSource(inst)
    if inst._onattackother == nil then
        inst._onattackother = function(attacker, data)
            if data.weapon ~= nil then
                if data.projectile == nil then
                    --in combat, this is when we're just launching a projectile, so don't do FX yet
                    if data.weapon.components.projectile ~= nil then
                        return
                    elseif data.weapon.components.complexprojectile ~= nil then
                        return
                    elseif data.weapon.components.weapon:CanRangedAttack() then
                        return
                    end
                end
                if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
                    --weapon already has electric stimuli, so probably does its own FX
                    return
                end
            end
            if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
                SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
            end
        end
        inst:ListenForEvent("onattackother", inst._onattackother, target)
    end
    SpawnPrefab("electricchargedfx"):SetTarget(target)
end

local function electric_extend(inst, target)
    SpawnPrefab("electricchargedfx"):SetTarget(target)
end

local function electric_detach(inst, target)
    if target.components.electricattacks ~= nil then
        target.components.electricattacks:RemoveSource(inst)
    end
    if inst._onattackother ~= nil then
        inst:RemoveEventCallback("onattackother", inst._onattackother, target)
        inst._onattackother = nil
    end
end

local function OnCooldown(target)
    target._cdtask = nil
end

local function Retaliate(target, data)
    if target._cdtask == nil and data ~= nil and not data.redirected then
        --V2C: tiny CD to limit chain reactions
        target._cdtask = target:DoTaskInTime(.3, OnCooldown)

        SpawnPrefab("shockotherfx"):SetFXOwner(target)

        if target.SoundEmitter ~= nil then
            target.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
        end
    end
end
local function attachretaliationdamage(inst, target) 
    target:ListenForEvent("attacked", Retaliate, target)
	SpawnPrefab("electricchargedfx"):SetTarget(target)
end

local function removeretaliationdamageretaliationdamage(inst, target)
    target:RemoveEventCallback("attacked", Retaliate, target)
end

local function OnHitOtherFreeze(inst, data)
    local other = data.target
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if other.components.freezable ~= nil then
                other.components.freezable:AddColdness(1)
            end
        end
        if other.components.freezable ~= nil then
            other.components.freezable:SpawnShatterFX()
        end
    end
end
local function attachfrozenness(inst, target)
target:ListenForEvent("onhitother", OnHitOtherFreeze, target)
end
local function removefrozenness(inst, target)
target:RemoveEventCallback("onhitother", OnHitOtherFreeze, target)
end

local function californiaking_attach(inst, target)
target:DoTaskInTime(4, function(target)
if not target:HasTag("californiaking") then
target:AddTag("californiaking")
end
end)
end

local function californiaking_extend(inst, target)
    --SpawnPrefab("electricchargedfx"):SetTarget(target)
end

local function californiaking_detach(inst, target)
if target:HasTag("californiaking") then
target:RemoveTag("californiaking")
end
end

local function kbimmune_attach(inst, target)
target:DoTaskInTime(4, function(target)
if not target:HasTag("foodknockbackimmune") then
target:AddTag("foodknockbackimmune")
end
end)
end

local function kbimmune_extend(inst, target)
    --SpawnPrefab("electricchargedfx"):SetTarget(target)
end

local function kbimmune_detach(inst, target)
if target:HasTag("foodknockbackimmune") then
target:RemoveTag("foodknockbackimmune")
end
end

local function largehungerslow_attach(inst, target)
target.components.hunger.burnratemodifiers:SetModifier(inst, .5)
end

local function largehungerslow_extend(inst, target)
target.components.hunger.burnratemodifiers:RemoveModifier(inst)
target.components.hunger.burnratemodifiers:SetModifier(inst, .5)
end

local function largehungerslow_detach(inst, target)
target.components.hunger.burnratemodifiers:RemoveModifier(inst)
end

local function stantonslumber_attach(inst, target)
local stanton = FindEntity(target,20,nil,{"stanton"})
if stanton ~= nil then
	if stanton.contestent == target then
		if target.stantonslumberstack == nil then
			target.stantonslumberstack = 0
		else
			if target.components.debuffable ~= nil and target.components.debuffable:HasDebuff("buff_sleepresistance") then
				target.stantonslumberstack = target.stantonslumberstack + 0.05
			else
				target.stantonslumberstack = target.stantonslumberstack + 0.1
			end
		end
		if math.random() < target.stantonslumberstack then
			if target.components.grogginess ~= nil then
				target.components.grogginess:AddGrogginess(34, 5)
				local stanton = FindEntity(target,10,nil,{"stanton"})
				if stanton ~= nil then
					stanton:AddTag("won")
				end
			target:DoTaskInTime(4,function(target) 
				target.components.grogginess:SubtractGrogginess(-30)
				target.components.grogginess:ComeTo()	
			end)
			end
		else
			if target.components.grogginess ~= nil and target.components.grogginess.grog_amount == 0 then
				target.components.grogginess:AddGrogginess(1, 1)
			end
		end
	else
		stanton.TellThemRules(stanton)
		if target.components.health ~= nil then
			target.components.health:DoDelta(-20)
		end
	end
else
	local stanton = TheSim:FindFirstEntityWithTag("stanton")
	if stanton ~= nil then
		stanton.TellThemRules(stanton)
	end
	target.components.health:DoDelta(-20)
end
end

local function stantonslumber_detach(inst, target)
target.stantonslumberstack = nil
end

local function hypercourage_attach(inst,target)
target.components.sanity.neg_aura_modifiers:SetModifier(inst, 0)
end

local function hypercourage_extend(inst,target)

end

local function hypercourage_detach(inst,target)
target.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
end


local function OnTickAmuse(inst, target)
    if target.components.sanity ~= nil and
        not target:HasTag("playerghost") then
		local amount = 0
		if inst.tier ~= nil then
			amount = inst.tier
		end
        target.components.sanity:DoDelta(amount, nil, "amusementcorn")
    end
end

local function OnAmuseAttach(inst, target)
if target.tempamusetier ~= nil then
	inst.tier = target.tempamusetier+1
end
inst.task = inst:DoPeriodicTask(1, OnTickAmuse, nil, target)
end

local function OnAmuseDone(inst, data)
if inst.tier ~= nil then
    inst.tier = nil
end
	inst.task:Cancel()
end

local function OnAmuseExtended(inst, target)
if inst.tier ~= nil then
    inst.tier = nil
end
	inst.task:Cancel()
	if target.tempamusetier ~= nil then
		inst.tier = target.tempamusetier+1
	end
    inst.task = inst:DoPeriodicTask(1, OnTickAmuse, nil, target)
end
-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, nospeech)
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)
		if not nospeech then
        target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
		end
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end

    local function OnExtended(inst, target)
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", duration)
		if not nospeech then
        target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
		end
        if onextendedfn ~= nil then
            onextendedfn(inst, target)
        end
    end

    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end
		if not nospeech then
        target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority })
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
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab("buff_"..name, fn, nil)
end

return MakeBuff("electricretaliation", attachretaliationdamage, electric_extend, removeretaliationdamageretaliationdamage, TUNING.BUFF_ELECTRICATTACK_DURATION, 2, { "electrichitsparks", "electricchargedfx" }),
MakeBuff("frozenfury", attachfrozenness, nil, removefrozenness, TUNING.BUFF_ELECTRICATTACK_DURATION, 2),
MakeBuff("lesserelectricattack", electric_attach, electric_extend, electric_detach, 30, 2, { "electrichitsparks", "electricchargedfx" }),
MakeBuff("knockbackimmune", kbimmune_attach, kbimmune_extend, kbimmune_detach, TUNING.BUFF_ATTACK_DURATION, 2),
MakeBuff("californiaking", californiaking_attach, californiaking_extend, californiaking_detach, TUNING.BUFF_ATTACK_DURATION*8, 2),
MakeBuff("largehungerslow", largehungerslow_attach, largehungerslow_extend, largehungerslow_detach, TUNING.BUFF_ATTACK_DURATION*8, 2),
MakeBuff("stantonslumber", stantonslumber_attach, stantonslumber_attach, stantonslumber_detach, TUNING.BUFF_ATTACK_DURATION, 2,true),
MakeBuff("hypercourage", hypercourage_attach, hypercourage_extend, hypercourage_detach, 30, 2,true),
MakeBuff("amusementcorn", OnAmuseAttach, OnAmuseExtended, OnAmuseDone, 15, 2,true)
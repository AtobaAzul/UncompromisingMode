local assets =
{
    Asset("ANIM", "anim/ruins_bat.zip"),
    Asset("ANIM", "anim/swap_ruins_bat.zip"),
}

local prefabs =
{
    "shadowtentacle",
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_ruins_bat", inst.GUID, "swap_ruins_bat")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_ruins_bat", "swap_ruins_bat")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function onattack(inst, owner, target)

	local opalgem = #inst.components.container:FindItems( function(item) return item.prefab == "opalpreciousgem" end )
	
	local redgem = #inst.components.container:FindItems( function(item) return item.prefab == "redgem" end )
	
	if redgem > 0 and owner.components.health ~= nil and owner.components.health:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.health:DoDelta(redgem / 5 + opalgem / 2, false, "crabclaw")
    end
	
	local yellowgem = #inst.components.container:FindItems( function(item) return item.prefab == "yellowgem" end )
	
	if yellowgem > 0 and owner.components.sanity ~= nil and owner.components.sanity:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.sanity:DoDelta(yellowgem / 5 + opalgem / 2, false, "crabclaw")
    end
	
	local bluegem = #inst.components.container:FindItems( function(item) return item.prefab == "bluegem" end )
	
	if bluegem > 0 and target:IsValid() and target.components.combat ~= nil and target.components.freezable ~= nil and not target.components.health:IsDead() and not target.components.freezable:IsFrozen() then
		target.components.freezable:AddColdness((bluegem / 10) + (opalgem / 5))
	end
	
	local greengem = #inst.components.container:FindItems( function(item) return item.prefab == "greengem" end )
	
	if greengem > 0 and inst.components.finiteuses and inst.components.finiteuses:GetPercent() < 1 then
		inst.components.finiteuses:SetUses(inst.components.finiteuses:GetUses() + 0.1 + (greengem / 10) + (opalgem / 5))
	end
	
	local purplegem = #inst.components.container:FindItems( function(item) return item.prefab == "purplegem" end )
	
	if purplegem > 0 and math.random() < ((purplegem / 10) + (opalgem / 5)) then
        local pt
        if target ~= nil and target:IsValid() then
            pt = target:GetPosition()
        else
            pt = owner:GetPosition()
            target = nil
        end
        local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3, false, true, NoHoles)
        if offset ~= nil then
            inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
            inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
            local tentacle = SpawnPrefab("shadowtentacle")
            if tentacle ~= nil then
                tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                tentacle.components.combat:SetTarget(target)
            end
        end
    end
	
	local orangegem = #inst.components.container:FindItems( function(item) return item.prefab == "orangegem" end )
	
	if orangegem > 0 and target ~= nil and target:IsValid() and target.components.locomotor ~= nil then
	
		local debuffkey = inst.prefab
	
		if target._crabclaw_speedmulttask ~= nil then
			target._crabclaw_speedmulttask:Cancel()
		end
		target._crabclaw_speedmulttask = target:DoTaskInTime(5, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._crabclaw_speedmulttask = nil end)

		local slowamount = 0.9 - ((orangegem / 10) + (opalgem / 5))
		
		target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, slowamount or 0.9)
	end
	
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ruins_bat")
    inst.AnimState:SetBuild("swap_ruins_bat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50)
    inst.components.weapon:SetOnAttack(onattack)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.RUINS_BAT_USES)
    inst.components.finiteuses:SetUses(TUNING.RUINS_BAT_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("crabclaw")
	inst.components.container.canbeopened = true
    --inst:ListenForEvent("itemget", OnAmmoLoaded)
    --inst:ListenForEvent("itemlose", OnAmmoUnloaded)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.1

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("crabclaw", fn, assets, prefabs)

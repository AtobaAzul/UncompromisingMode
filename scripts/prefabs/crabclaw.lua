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
	if inst.shinefx_slot1 ~= nil then
		inst.shinefx_slot1:Remove()
	end
	
	if inst.shinefx_slot2 ~= nil then
		inst.shinefx_slot2:Remove()
	end
	
	if inst.shinefx_slot3 ~= nil then
		inst.shinefx_slot3:Remove()
	end
	
	if inst.shinefx_slot4 ~= nil then
		inst.shinefx_slot4:Remove()
	end

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
        owner.components.health:DoDelta((redgem + opalgem) / 5, false, "crabclaw")
    end
	
	local yellowgem = #inst.components.container:FindItems( function(item) return item.prefab == "yellowgem" end )
	
	if yellowgem > 0 and owner.components.sanity ~= nil and owner.components.sanity:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.sanity:DoDelta((yellowgem + opalgem) / 5, false, "crabclaw")
    end
	
	local bluegem = #inst.components.container:FindItems( function(item) return item.prefab == "bluegem" end )
	
	if bluegem > 0 and target:IsValid() and target.components.combat ~= nil and target.components.freezable ~= nil and not target.components.health:IsDead() and not target.components.freezable:IsFrozen() then
		target.components.freezable:AddColdness((bluegem + opalgem) / 10)
	end
	
	local greengem = #inst.components.container:FindItems( function(item) return item.prefab == "greengem" end )
	
	if greengem > 0 and inst.components.finiteuses and inst.components.finiteuses:GetPercent() < 1 then
		inst.components.finiteuses:SetUses(inst.components.finiteuses:GetUses() + 0.1 + (greengem + opalgem) / 10)
	end
	
	local purplegem = #inst.components.container:FindItems( function(item) return item.prefab == "purplegem" end )
	
	if purplegem > 0 and math.random() < ((purplegem + opalgem) / 10) then
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

		local slowamount = 0.9 - ((orangegem + opalgem) / 10)
		
		target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, slowamount or 0.9)
	end
	
end

local function onremovebody1(body)
    body._lantern._body = nil
end

local function onremovebody2(body)
    body._lantern._body = nil
end

local function onremovebody3(body)
    body._lantern._body = nil
end

local function onremovebody4(body)
    body._lantern._body = nil
end

local function ItemGet(inst)
	local owner = inst.components.inventoryitem.owner
	local item1 = inst.components.container.slots[1]
	local item2 = inst.components.container.slots[2]
	local item3 = inst.components.container.slots[3]
	local item4 = inst.components.container.slots[4]

	if item1 ~= nil and owner ~= nil then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot1 = SpawnPrefab("crabclaw_gempiece")
		inst.shinefx_slot1._lantern = inst
		inst:ListenForEvent("onremove", onremovebody1, inst.shinefx_slot1)
		inst.shinefx_slot1.entity:SetParent(owner.entity)
		inst.shinefx_slot1.entity:AddFollower()
		inst.shinefx_slot1.Follower:FollowSymbol(owner.GUID, "swap_object", 50, -100, 0)
		inst.shinefx_slot1.Transform:SetScale(0.2,0.2,0.2)
		
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 50, -100, 0)
		inst.shinefx2.Transform:SetScale(0.2,0.2,0.2)
	end
	
	if item2 ~= nil and owner ~= nil then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot2 = SpawnPrefab("crabclaw_gempiece")
		inst.shinefx_slot2._lantern = inst
		inst:ListenForEvent("onremove", onremovebody2, inst.shinefx_slot2)
		inst.shinefx_slot2.entity:SetParent(owner.entity)
		inst.shinefx_slot2.entity:AddFollower()
		inst.shinefx_slot2.Follower:FollowSymbol(owner.GUID, "swap_object", 100, -100, 0)
		inst.shinefx_slot2.Transform:SetScale(0.2,0.2,0.2)
		
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 100, -100, 0)
		inst.shinefx2.Transform:SetScale(0.2,0.2,0.2)
	end
	
	if item3 ~= nil and owner ~= nil then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot3 = SpawnPrefab("crabclaw_gempiece")
		inst.shinefx_slot3._lantern = inst
		inst:ListenForEvent("onremove", onremovebody3, inst.shinefx_slot3)
		inst.shinefx_slot3.entity:SetParent(owner.entity)
		inst.shinefx_slot3.entity:AddFollower()
		inst.shinefx_slot3.Follower:FollowSymbol(owner.GUID, "swap_object", 100, -50, 0)
		inst.shinefx_slot3.Transform:SetScale(0.2,0.2,0.2)
		
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 100, -50, 0)
		inst.shinefx2.Transform:SetScale(0.2,0.2,0.2)
	end
	
	if item4 ~= nil and owner ~= nil then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot4 = SpawnPrefab("crabclaw_gempiece")
		inst.shinefx_slot4._lantern = inst
		inst:ListenForEvent("onremove", onremovebody4, inst.shinefx_slot4)
		inst.shinefx_slot4.entity:SetParent(owner.entity)
		inst.shinefx_slot4.entity:AddFollower()
		inst.shinefx_slot4.Follower:FollowSymbol(owner.GUID, "swap_object", 50, -50, 0)
		inst.shinefx_slot4.Transform:SetScale(0.2,0.2,0.2)
		
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 50, -50, 0)
		inst.shinefx2.Transform:SetScale(0.2,0.2,0.2)
	end
	
end

local function ItemLose(inst)
	local owner = inst.components.inventoryitem.owner
	local item1 = inst.components.container.slots[1]
	local item2 = inst.components.container.slots[2]
	local item3 = inst.components.container.slots[3]
	local item4 = inst.components.container.slots[4]

	if item1 == nil and inst.shinefx_slot1 ~= nil then
		print("1")
		inst.shinefx_slot1:Remove()
	end
	
	if item2 == nil and inst.shinefx_slot2 ~= nil then
		print("2")
		inst.shinefx_slot2:Remove()
	end
	
	if item3 == nil and inst.shinefx_slot3 ~= nil then
		print("3")
		inst.shinefx_slot3:Remove()
	end
	
	if item4 == nil and inst.shinefx_slot4 ~= nil then
		print("4")
		inst.shinefx_slot4:Remove()
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
    inst:ListenForEvent("itemget", ItemGet)
    inst:ListenForEvent("itemlose", ItemLose)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.1

    MakeHauntableLaunch(inst)

    return inst
end

local function lanternbodyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("redlantern")
    inst.AnimState:SetBuild("redlantern")
    inst.AnimState:PlayAnimation("idle_body_loop", true)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst.persists = false

    return inst
end

return Prefab("crabclaw", fn, assets, prefabs),
    Prefab("crabclaw_gempiece", lanternbodyfn)

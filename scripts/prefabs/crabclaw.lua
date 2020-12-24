local assets =
{
    Asset("ANIM", "anim/cursedcrabclaw.zip"),
    Asset("ANIM", "anim/swap_crabclaw.zip"),
}

local gemassets =
{
    Asset("ANIM", "anim/gems.zip"),
}

local prefabs =
{
    "shadowtentacle",
}

local function onremovebody1(body)
    body.gem._body = nil
end

local function onremovebody2(body)
    body.gem._body = nil
end

local function onremovebody3(body)
    body.gem._body = nil
end

local function onremovebody4(body)
    body.gem._body = nil
end

local function AddGem(inst)
print("Add gem")
	local owner = inst.components.inventoryitem.owner
	local item1 = inst.components.container.slots[1]
	local item2 = inst.components.container.slots[2]
	local item3 = inst.components.container.slots[3]
	local item4 = inst.components.container.slots[4]

	if item1 ~= nil and owner ~= nil and not inst.slot1_inserted then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot1 = SpawnPrefab(item1.prefab.."_crabclaw")
		inst.shinefx_slot1.gem = inst
		--inst:ListenForEvent("onremove", onremovebody1, inst.shinefx_slot1)
		inst.shinefx_slot1.entity:SetParent(owner.entity)
		inst.shinefx_slot1.entity:AddFollower()
		inst.shinefx_slot1.Follower:FollowSymbol(owner.GUID, "swap_object", 48, -203, 0.1)
		inst.shinefx_slot1.Transform:SetScale(0.25,0.25,0.25)
		
		inst.slot1_inserted = true
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 48, -203, 0)
		inst.shinefx2.Transform:SetScale(0.25,0.25,0.25)
	end
	
	if item2 ~= nil and owner ~= nil and not inst.slot2_inserted then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot2 = SpawnPrefab(item2.prefab.."_crabclaw")
		inst.shinefx_slot2.gem = inst
		--inst:ListenForEvent("onremove", onremovebody2, inst.shinefx_slot2)
		inst.shinefx_slot2.entity:SetParent(owner.entity)
		inst.shinefx_slot2.entity:AddFollower()
		inst.shinefx_slot2.Follower:FollowSymbol(owner.GUID, "swap_object", 63, -150, 0.1)
		inst.shinefx_slot2.Transform:SetScale(0.25,0.25,0.25)
		
		inst.slot2_inserted = true
		
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 63, -150, 0)
		inst.shinefx2.Transform:SetScale(0.25,0.25,0.25)
	end
	
	if item3 ~= nil and owner ~= nil and not inst.slot3_inserted then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot3 = SpawnPrefab(item3.prefab.."_crabclaw")
		inst.shinefx_slot3.gem = inst
		--inst:ListenForEvent("onremove", onremovebody3, inst.shinefx_slot3)
		inst.shinefx_slot3.entity:SetParent(owner.entity)
		inst.shinefx_slot3.entity:AddFollower()
		inst.shinefx_slot3.Follower:FollowSymbol(owner.GUID, "swap_object", 48, -102, 0.1)
		inst.shinefx_slot3.Transform:SetScale(0.25,0.25,0.25)
		
		inst.slot3_inserted = true
		
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 48, -102, 0)
		inst.shinefx2.Transform:SetScale(0.25,0.25,0.25)
	end
	
	if item4 ~= nil and owner ~= nil and not inst.slot4_inserted then
		inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
		inst.shinefx_slot4 = SpawnPrefab(item4.prefab.."_crabclaw")
		inst.shinefx_slot4.gem = inst
		--inst:ListenForEvent("onremove", onremovebody4, inst.shinefx_slot4)
		inst.shinefx_slot4.entity:SetParent(owner.entity)
		inst.shinefx_slot4.entity:AddFollower()
		inst.shinefx_slot4.Follower:FollowSymbol(owner.GUID, "swap_object", 23, -61, 0.1)
		inst.shinefx_slot4.Transform:SetScale(0.25,0.25,0.25)
		
		inst.slot4_inserted = true
		
		
		inst.shinefx2 = SpawnPrefab("crab_king_shine")
		inst.shinefx2.entity:SetParent(owner.entity)
		inst.shinefx2.entity:AddFollower()
		inst.shinefx2.Follower:FollowSymbol(owner.GUID, "swap_object", 23, -61, 0)
		inst.shinefx2.Transform:SetScale(0.25,0.25,0.25)
	end
end

local function RemoveGem(inst)
print("Remove gem")
	local owner = inst.components.inventoryitem.owner
	local item1 = inst.components.container.slots[1]
	local item2 = inst.components.container.slots[2]
	local item3 = inst.components.container.slots[3]
	local item4 = inst.components.container.slots[4]

	if item1 == nil and inst.shinefx_slot1 ~= nil and inst.slot1_inserted then
		print("1")
		inst.shinefx_slot1:Remove()

		inst.slot1_inserted = false
	end
	
	if item2 == nil and inst.shinefx_slot2 ~= nil and inst.slot2_inserted then
		print("2")
		inst.shinefx_slot2:Remove()
		inst.slot2_inserted = false
	end
	
	if item3 == nil and inst.shinefx_slot3 ~= nil and inst.slot3_inserted then
		print("3")
		inst.shinefx_slot3:Remove()
		inst.slot3_inserted = false
	end
	
	if item4 == nil and inst.shinefx_slot4 ~= nil and inst.slot4_inserted then
		print("4")
		inst.shinefx_slot4:Remove()
		inst.slot4_inserted = false
	end
end

local function UnequipRemoveGem(inst)
print("U Remove gem")

	if inst.shinefx_slot1 ~= nil and inst.slot1_inserted then
		print("1")
		inst.shinefx_slot1:Remove()

		inst.slot1_inserted = false
	end
	
	if inst.shinefx_slot2 ~= nil and inst.slot2_inserted then
		print("2")
		inst.shinefx_slot2:Remove()
		inst.slot2_inserted = false
	end
	
	if inst.shinefx_slot3 ~= nil and inst.slot3_inserted then
		print("3")
		inst.shinefx_slot3:Remove()
		inst.slot3_inserted = false
	end
	
	if inst.shinefx_slot4 ~= nil and inst.slot4_inserted then
		print("4")
		inst.shinefx_slot4:Remove()
		inst.slot4_inserted = false
	end
end

local function onequip(inst, owner)
	
	AddGem(inst)

    owner.AnimState:OverrideSymbol("swap_object", "swap_crabclaw", "swap_crabclaw")
	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
	
	UnequipRemoveGem(inst)
	
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

local function ItemGet(inst)
	AddGem(inst)
end

local function ItemLose(inst)
	RemoveGem(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cursedcrabclaw")
    inst.AnimState:SetBuild("cursedcrabclaw")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.slot1_inserted = false
	inst.slot2_inserted = false
	inst.slot3_inserted = false
	inst.slot4_inserted = false

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
    inst.components.inventoryitem:SetSinks(false)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/crabclaw.xml"
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("crabclaw")
	inst.components.container.canbeopened = true
    inst:ListenForEvent("itemget", ItemGet)
    inst:ListenForEvent("itemlose", ItemLose)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end


local function buildgem(colour)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		inst.AnimState:SetBank("gems")
		inst.AnimState:SetBuild("gems_crabclaw")
			
		if colour == "opalprecious" then
			inst.AnimState:PlayAnimation("opalgem_idle", true)
		else
			inst.AnimState:PlayAnimation(colour.."gem_idle", true)
		end

		inst:AddTag("INLIMBO")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

		inst.persists = false

		return inst
	end
    return Prefab(colour.."gem_crabclaw", fn, gemassets)
end

return Prefab("crabclaw", fn, assets, prefabs),
	buildgem("purple"),
    buildgem("blue"),
    buildgem("red"),
    buildgem("orange"),
    buildgem("yellow"),
    buildgem("green"),
    buildgem("opalprecious")

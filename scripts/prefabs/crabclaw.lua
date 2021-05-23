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



local function DamageCalculation(inst, isattack)

	local opalgem = #inst.components.container:FindItems( function(item) return item.prefab == "opalpreciousgem_cracked" end )
	
	local redgem = #inst.components.container:FindItems( function(item) return item.prefab == "redgem_cracked" end )
	
	local yellowgem = #inst.components.container:FindItems( function(item) return item.prefab == "yellowgem_cracked" end )
	
	local bluegem = #inst.components.container:FindItems( function(item) return item.prefab == "bluegem_cracked" end )
	
	local greengem = #inst.components.container:FindItems( function(item) return item.prefab == "greengem_cracked" end )
	
	local purplegem = #inst.components.container:FindItems( function(item) return item.prefab == "purplegem_cracked" end )
	
	local orangegem = #inst.components.container:FindItems( function(item) return item.prefab == "orangegem_cracked" end )
	
    local dmg = 30 + (10 * opalgem) + (5 * (redgem + bluegem + greengem + orangegem + purplegem))
		
	inst.components.weapon:SetDamage(dmg)
	
	if isattack then
		local item1 = inst.components.container.slots[1]
		local item2 = inst.components.container.slots[2]
		local item3 = inst.components.container.slots[3]
		local item4 = inst.components.container.slots[4]
		
		if item1 ~= nil and item1.components.finiteuses then
			item1.components.finiteuses:Use(1)
		end
		
		if item2 ~= nil and item2.components.finiteuses then
			item2.components.finiteuses:Use(1)
		end
		
		if item3 ~= nil and item3.components.finiteuses then
			item3.components.finiteuses:Use(1)
		end
		
		if item4 ~= nil and item4.components.finiteuses then
			item4.components.finiteuses:Use(1)
		end
	end
	
end

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
	local owner = inst.components.inventoryitem.owner
	local item1 = inst.components.container.slots[1]
	local item2 = inst.components.container.slots[2]
	local item3 = inst.components.container.slots[3]
	local item4 = inst.components.container.slots[4]

	if item1 ~= nil and owner ~= nil and not inst.slot1_inserted then
		if not item1.components.finiteuses then
			item1:AddComponent("perishable")
			item1.components.perishable.onperishreplacement = item1.prefab.."_cracked"
			item1.components.perishable:Perish()
		else
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
	end
	
	if item2 ~= nil and owner ~= nil and not inst.slot2_inserted then
		if not item2.components.finiteuses then
			item2:AddComponent("perishable")
			item2.components.perishable.onperishreplacement = item2.prefab.."_cracked"
			item2.components.perishable:Perish()
		else
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
	end
	
	if item3 ~= nil and owner ~= nil and not inst.slot3_inserted then
		if not item3.components.finiteuses then
			item3:AddComponent("perishable")
			item3.components.perishable.onperishreplacement = item3.prefab.."_cracked"
			item3.components.perishable:Perish()
		else
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
	end
	
	if item4 ~= nil and owner ~= nil and not inst.slot4_inserted then
	
		if not item4.components.finiteuses then
			item4:AddComponent("perishable")
			item4.components.perishable.onperishreplacement = item4.prefab.."_cracked"
			item4.components.perishable:Perish()
		else
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
	
	DamageCalculation(inst)
end

local function RemoveGem(inst)
	local owner = inst.components.inventoryitem.owner
	local item1 = inst.components.container.slots[1]
	local item2 = inst.components.container.slots[2]
	local item3 = inst.components.container.slots[3]
	local item4 = inst.components.container.slots[4]

	if item1 == nil and inst.shinefx_slot1 ~= nil and inst.slot1_inserted then
		inst.shinefx_slot1:Remove()

		inst.slot1_inserted = false
	end
	
	if item2 == nil and inst.shinefx_slot2 ~= nil and inst.slot2_inserted then
		inst.shinefx_slot2:Remove()
		inst.slot2_inserted = false
	end
	
	if item3 == nil and inst.shinefx_slot3 ~= nil and inst.slot3_inserted then
		inst.shinefx_slot3:Remove()
		inst.slot3_inserted = false
	end
	
	if item4 == nil and inst.shinefx_slot4 ~= nil and inst.slot4_inserted then
		inst.shinefx_slot4:Remove()
		inst.slot4_inserted = false
	end
	
	DamageCalculation(inst)
end

local function UnequipRemoveGem(inst)

	if inst.shinefx_slot1 ~= nil and inst.slot1_inserted then
		inst.shinefx_slot1:Remove()

		inst.slot1_inserted = false
	end
	
	if inst.shinefx_slot2 ~= nil and inst.slot2_inserted then
		inst.shinefx_slot2:Remove()
		inst.slot2_inserted = false
	end
	
	if inst.shinefx_slot3 ~= nil and inst.slot3_inserted then
		inst.shinefx_slot3:Remove()
		inst.slot3_inserted = false
	end
	
	if inst.shinefx_slot4 ~= nil and inst.slot4_inserted then
		inst.shinefx_slot4:Remove()
		inst.slot4_inserted = false
	end
end

local function onequip(inst, owner)

	if not owner:HasTag("vetcurse") then
		--owner.components.inventory:Unequip(EQUIPSLOTS.HANDS, true)
		inst:DoTaskInTime(0, function(inst, owner)
			local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
			local tool = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if tool ~= nil and owner ~= nil then
				owner.components.inventory:Unequip(EQUIPSLOTS.HANDS)
				owner.components.inventory:DropItem(tool)
				owner.components.inventory:GiveItem(inst)
				owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")
				
				owner.components.combat:GetAttacked(inst, 0.1, nil)
			end
		end)
	else
		AddGem(inst)

		owner.AnimState:OverrideSymbol("swap_object", "swap_crabclaw", "swap_crabclaw")
		
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")

		if inst.components.container ~= nil then
			inst.components.container:Open(owner)
		end
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

	local opalgem = #inst.components.container:FindItems( function(item) return item.prefab == "opalpreciousgem_cracked" end )
	
	local redgem = #inst.components.container:FindItems( function(item) return item.prefab == "redgem_cracked" end )
	
	if redgem > 0 and owner.components.health ~= nil and owner.components.health:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.health:DoDelta((redgem + opalgem) / 5, false, "crabclaw")
    end
	
	local yellowgem = #inst.components.container:FindItems( function(item) return item.prefab == "yellowgem_cracked" end )
	
	if yellowgem > 0 and owner.components.sanity ~= nil and owner.components.sanity:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.sanity:DoDelta((yellowgem + opalgem) / 5, false, "crabclaw")
    end
	
	local bluegem = #inst.components.container:FindItems( function(item) return item.prefab == "bluegem_cracked" end )
	
	if bluegem > 0 and target:IsValid() and target.components.combat ~= nil and target.components.freezable ~= nil and not target.components.health:IsDead() and not target.components.freezable:IsFrozen() then
		target.components.freezable:AddColdness((bluegem + opalgem) / 10)
	end
	
	local purplegem = #inst.components.container:FindItems( function(item) return item.prefab == "purplegem_cracked" end )
	
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
	
	local orangegem = #inst.components.container:FindItems( function(item) return item.prefab == "orangegem_cracked" end )
	
	if orangegem > 0 and target ~= nil and target:IsValid() and target.components.locomotor ~= nil then
	
		local debuffkey = inst.prefab
	
		if target._crabclaw_speedmulttask ~= nil then
			target._crabclaw_speedmulttask:Cancel()
		end
		target._crabclaw_speedmulttask = target:DoTaskInTime(5, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._crabclaw_speedmulttask = nil end)

		local slowamount = 0.9 - ((orangegem + opalgem) / 10)
		
		target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, slowamount or 0.9)
	end
	
	local greengem = #inst.components.container:FindItems( function(item) return item.prefab == "greengem_cracked" end )
	
	if greengem > 0 then
		local durabilitychance = ((greengem + opalgem) / 5)
		if math.random() > durabilitychance then
			DamageCalculation(inst, true)
		else
			DamageCalculation(inst)
		end
		return
	end
	
	DamageCalculation(inst, true)
end

local function ItemGet(inst)
	AddGem(inst)
end

local function ItemLose(inst)
	RemoveGem(inst)
end

local function OnOpen(inst)
	inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("blunt")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst.AnimState:SetBank("cursedcrabclaw")
    inst.AnimState:SetBuild("cursedcrabclaw")
    inst.AnimState:PlayAnimation("idle")
	
    MakeInventoryFloatable(inst, "med", 0.05)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.slot1_inserted = false
	inst.slot2_inserted = false
	inst.slot3_inserted = false
	inst.slot4_inserted = false

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(40)
    inst.components.weapon:SetOnAttack(onattack)

    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(false)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/crabclaw.xml"
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("crabclaw")
	inst.components.container.canbeopened = true
    inst.components.container.onopenfn = OnOpen
	
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
    return Prefab(colour.."gem_cracked_crabclaw", fn, gemassets)
end

local FLOATER_PROPERTIES =
{
    ["purple"]  = {0.10, 0.80},
    ["blue"]    = {0.10, 0.80},
    ["red"]     = {0.10, 0.80},
    ["orange"]  = {0.10, 0.82},
    ["yellow"]  = {0.10, 0.85},
    ["green"]   = {0.05, 0.75},
    ["opal"]    = {0.10, 0.87},
}

local function buildgem_cracked(colour, precious)
	
	local function Shatter(inst)
        local fx = SpawnPrefab("winona_battery_high_shatterfx")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
		inst:DoTaskInTime(0.5, inst.Remove)
	end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("gems")
        inst.AnimState:SetBuild("gems")
        inst.AnimState:PlayAnimation(colour.."gem_idle", true)

        inst:AddTag("molebait")
        inst:AddTag("quakedebris")
        inst:AddTag("gem")
        inst.colour = colour

        local fp = FLOATER_PROPERTIES[colour]
        MakeInventoryFloatable(inst, "small", fp[1], fp[2])

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
		
        inst:AddComponent("tradable")
        inst.components.edible.hungervalue = 2.5

		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(80)
		inst.components.finiteuses:SetUses(80)
		inst.components.finiteuses:SetOnFinished(Shatter)

        inst:AddComponent("bait")

        inst:AddComponent("inspectable")
		
		local image = (precious and "opalprecious" or colour)

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..image.."gem_cracked.xml"

        MakeHauntableLaunchAndSmash(inst)

        return inst
    end
    return Prefab(colour..(precious and "preciousgem_cracked" or "gem_cracked"), fn, assets)
end

return Prefab("crabclaw", fn, assets, prefabs),
	buildgem("purple"),
    buildgem("blue"),
    buildgem("red"),
    buildgem("orange"),
    buildgem("yellow"),
    buildgem("green"),
    buildgem("opalprecious"),
	buildgem_cracked("purple"),
    buildgem_cracked("blue"),
    buildgem_cracked("red"),
    buildgem_cracked("orange"),
    buildgem_cracked("yellow"),
    buildgem_cracked("green"),
    buildgem_cracked("opal", true)

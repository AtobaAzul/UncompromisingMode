local assets =
{
    Asset("ANIM", "anim/amulets.zip"),
    Asset("ANIM", "anim/torso_amulets.zip"),
}

local function DoubleSlap(owner)
	local target = owner.components.combat ~= nil and owner.components.combat.target
	local equip = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	--owner.components.combat:SetTarget(target)
	
	if not owner.components.rider:IsRiding() and equip ~= nil and equip.components.weapon ~= nil and not (equip.components.projectile ~= nil or equip:HasTag("rangedweapon")) and target ~= nil then
		local damage = equip.components.weapon ~= nil and equip.components.weapon:GetDamage(owner, target)
		local damagemult = owner.components.combat.damagemultiplier ~= nil and owner.components.combat.damagemultiplier or 1
		local damagemultex = owner.components.combat.externaldamagemultipliers ~= nil and owner.components.combat.externaldamagemultipliers:Get() or 1
		local range = owner.components.combat:GetAttackRange() or 0
		--owner.components.combat:StartAttack()
        owner.components.locomotor:StopMoving()
		owner.sg:GoToState("force_klaus_attack")
		
		local damagecalc = ((damage / 2) * damagemult) * damagemultex

		--[[
		target:DoTaskInTime(0.3, function(target, owner, equip) 
		
			local dist = target ~= nil and distsq(target:GetPosition(), owner:GetPosition()) <= owner.components.combat:CalcAttackRangeSq(target) or false
		
			if target ~= nil and owner.sg:HasStateTag("attack") and dist then
				
				local equip = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equip ~= nil then
					equip.components.weapon:OnAttack_NoDurabilityLoss(owner, target)
				end
				
				target.components.combat:GetAttacked(owner, damagecalc, equip) 
			end
		end, owner)]]
	end
end

local function onequip_blue(inst, owner)
	if not owner:HasTag("vetcurse") then
		inst:DoTaskInTime(0, function(inst, owner)
			local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
			local tool = owner ~= nil and (owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or owner.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK))
			if tool ~= nil and owner ~= nil then
				if EQUIPSLOTS["NECK"] ~= nil then
					owner.components.inventory:Unequip(EQUIPSLOTS.NECK)
				else
					owner.components.inventory:Unequip(EQUIPSLOTS.BODY)
				end
				owner.components.inventory:DropItem(tool)
				owner.components.inventory:GiveItem(inst)
				owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")
				
				if owner.sg ~= nil then
					owner.sg:GoToState("hit")
				end
			end
		end)
	else
		owner.AnimState:OverrideSymbol("swap_body", "torso_amulets_klaus", "redamulet")
		owner:ListenForEvent("onattackother", DoubleSlap)
	end
end

local function onunequip_blue(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    owner:RemoveEventCallback("onattackother", DoubleSlap)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amulet_klaus")
    inst.AnimState:SetBuild("amulet_klaus")
    inst.AnimState:PlayAnimation("klausamulet")
	
    inst.foleysound = "dontstarve/movement/foley/jewlery"

    MakeInventoryFloatable(inst, "med", nil, 0.6)

	inst:AddTag("vetcurse_item")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    if EQUIPSLOTS["NECK"] ~= nil then
        inst.components.equippable.equipslot = EQUIPSLOTS.NECK
    else
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/klaus_amulet.xml"
	
    inst.components.equippable:SetOnEquip(onequip_blue)
    inst.components.equippable:SetOnUnequip(onunequip_blue)

    return inst
end

return Prefab("klaus_amulet", fn, assets)

local assets =
{
    Asset("ANIM", "anim/amulets.zip"),
    Asset("ANIM", "anim/torso_amulets.zip"),
}

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function fuelme(inst)
	if inst.components.fueled:GetPercent() < 1 then
		if inst.pausedfuel then
			inst.components.fueled:DoDelta(1)
		end
		if inst.components.fueled:GetPercent() >= 1 then
			if inst.fueltask ~= nil then
				inst.fueltask:Cancel()
				inst.fueltask = nil
			end
		end
	else
		if inst.fueltask ~= nil then
			inst.fueltask:Cancel()
			inst.fueltask = nil
		end
	end
end

local function DoubleSlap(owner)
	local target = owner.components.combat ~= nil and owner.components.combat.target
	local equip = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	--owner.components.combat:SetTarget(target)
	
	if not owner.components.rider:IsRiding() and equip ~= nil and equip.components.weapon ~= nil and not (equip.components.projectile ~= nil or equip:HasTag("rangedweapon")) and target ~= nil and not equip.pausedfuel then
		local damage = equip.components.weapon ~= nil and equip.components.weapon:GetDamage(owner, target)
		local damagemult = owner.components.combat.damagemultiplier ~= nil and owner.components.combat.damagemultiplier or 1
		local damagemultex = owner.components.combat.externaldamagemultipliers ~= nil and owner.components.combat.externaldamagemultipliers:Get() or 1
		local range = owner.components.combat:GetAttackRange() or 0
		--owner.components.combat:StartAttack()
        owner.components.locomotor:StopMoving()
		owner.sg:GoToState("force_klaus_attack")
		
		local damagecalc = ((damage / 2) * damagemult) * damagemultex

		
		target:DoTaskInTime(0.3, function(target, owner, equip) 
			if target ~= nil and owner.sg:HasStateTag("attack") and owner:IsNear(target, (range + 0.5)) then
				
				local equip = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equip ~= nil then
					equip.components.weapon:OnAttack(owner, target)
				end
				
				target.components.combat:GetAttacked(owner, damagecalc, equip) 
			end
		end, owner)
	end
end

local function Attacked(owner, data, inst)
	if inst._cdtask == nil then
        inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)
		
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/lock_break")
		
		if inst.components.fueled:GetPercent() > 0 then
			inst.components.fueled:DoDelta(-20)
		end
	end
	
	if inst.fueltask == nil then
		inst.fueltask = inst:DoPeriodicTask(1, fuelme)
	end
end

local function onequip_blue(inst, owner)
	if not owner:HasTag("vetcurse") then
		inst:DoTaskInTime(0, function(inst, owner)
			local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
			local tool = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			if tool ~= nil and owner ~= nil then
				owner.components.inventory:Unequip(EQUIPSLOTS.BODY)
				owner.components.inventory:DropItem(tool)
				owner.components.inventory:GiveItem(inst)
				owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")
				
				owner.components.combat:GetAttacked(inst, 0.1, nil)
			end
		end)
	else
		owner.AnimState:OverrideSymbol("swap_body", "torso_amulets_klaus", "redamulet")
		owner:ListenForEvent("onattackother", DoubleSlap)
		inst:ListenForEvent("attacked", inst._attacked, owner)

		if inst.fueltask == nil then
			inst.fueltask = inst:DoPeriodicTask(1, fuelme)
		end
	end
end

local function onunequip_blue(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    owner:RemoveEventCallback("onattackother", DoubleSlap)
	inst:RemoveEventCallback("attacked", inst._attacked, owner)
	
	if inst.fueltask == nil then
		inst.fueltask = inst:DoPeriodicTask(1, fuelme)
	end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/breath_out")
    end
	
	if inst.fueltask == nil then
		inst.fueltask = inst:DoPeriodicTask(1, fuelme)
	end
end

local function unpausefueled(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/breath_in")
	
	inst.pausedfuel = true
	if inst.fuelmetask == nil then
		inst.fuelmetask = inst:DoPeriodicTask(1, fuelme)
	end
end

local function PauseFueled(inst)
	inst.pausedfuel = false

	if inst.unpausefueledtask ~= nil then
		inst.unpausefueledtask:Cancel()
		inst.unpausefueledtask = nil
	end
	inst.unpausefueledtask = inst:DoTaskInTime(10, unpausefueled)
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

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.pausedfuel = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	
    inst:AddComponent("fueled")
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(100)
    inst.components.fueled:SetDepletedFn(PauseFueled)
	inst.components.fueled.accepting = false

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/klaus_amulet.xml"
	
    inst.components.equippable:SetOnEquip(onequip_blue)
    inst.components.equippable:SetOnUnequip(onunequip_blue)
	
	if inst.fueltask == nil then
		inst.fueltask = inst:DoPeriodicTask(1, fuelme)
	end
	
    inst._attacked = function(owner, data) Attacked(owner, data, inst) end

    return inst
end

return Prefab("klaus_amulet", fn, assets)

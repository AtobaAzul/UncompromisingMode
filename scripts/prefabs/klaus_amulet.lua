local assets =
{
    Asset("ANIM", "anim/amulets.zip"),
    Asset("ANIM", "anim/torso_amulets.zip"),
}

local function ResetSpeed(inst)
    inst.components.equippable.walkspeedmult = TUNING.PIGGYBACK_SPEED_MULT
end

local function DoubleSlap(inst)
    inst.components.equippable.walkspeedmult = 2
	
	if inst.task ~= nil then
		inst.task:Cancel()
		inst.task = nil
	end
	
	inst.task = inst:DoTaskInTime(3, ResetSpeed)
end

local function onequip_blue(inst, owner)
	if not owner:HasTag("vetcurse") then
		inst:DoTaskInTime(0, function(inst, owner)
			local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
			owner.components.inventory:Unequip(EQUIPSLOTS.BODY, false)
			owner.components.inventory:DropItem(inst)
			owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")
			
			if inst.Physics ~= nil then
				local x, y, z = inst.Transform:GetWorldPosition()
				inst.Physics:Teleport(x, .3, z)

				local angle = (math.random() * 20 - 10) * DEGREES
				angle = angle + math.random() * 2 * PI
				local speed = inst and 2 + math.random() or 3 + math.random() * 2
				inst.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
			end
			
			owner.components.combat:GetAttacked(inst, 0.1, nil)
		end)
	else
		owner.AnimState:OverrideSymbol("swap_body", "torso_amulets_klaus", "redamulet")
		--[[inst:ListenForEvent("attacked", function(inst)
			inst.components.equippable.walkspeedmult = 2
			
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
			end
			
			inst.task = inst:DoTaskInTime(3, ResetSpeed)
		end, owner)]]
	end
end

local function onunequip_blue(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
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

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.walkspeedmult = TUNING.PIGGYBACK_SPEED_MULT

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/klaus_amulet.xml"
	
    inst.components.equippable:SetOnEquip(onequip_blue)
    inst.components.equippable:SetOnUnequip(onunequip_blue)

    return inst
end

return Prefab("klaus_amulet", fn, assets)

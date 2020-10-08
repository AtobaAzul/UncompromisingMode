local assets =
{
    Asset("ANIM", "anim/cursed_antler.zip"),
    Asset("ANIM", "anim/swap_cursed_antler.zip"),
}

local function charged(inst)
	local fx = SpawnPrefab("dr_warm_loop_1")
	
	local owner = inst.components.inventoryitem.owner
	
	if inst.components.equippable:IsEquipped() and owner ~= nil then
		fx.entity:SetParent(owner.entity)
		fx.entity:AddFollower()
		fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -275, 0)
		fx.Transform:SetScale(1.33, 1.33, 1.33)
	else
		fx.entity:SetParent(inst.entity)
        fx.Transform:SetPosition(0, 2.35, 0)
		fx.Transform:SetScale(1.33, 1.33, 1.33)
	end
end

local function fuelme(inst)
	if inst.components.fueled:GetPercent() < 1 then
		inst.components.fueled:DoDelta(10)
		if inst.components.fueled:GetPercent() >= 1 then
			inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/charge")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl", nil, .4)

			charged(inst)
			
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
			end
		end
	else
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
	end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	inst.components.weapon:SetDamage(28)
	
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.5, fuelme)
	end
end

local function onequip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_cursed_antler", "swap_cursed_antler")

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	if not owner:HasTag("vetcurse") then
		inst.components.weapon:SetDamage(0)
    end
	
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.5, fuelme)
	end
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() and inst.components.fueled:GetPercent() >= 1 then
        local x, y, z = target.Transform:GetWorldPosition()
		local impactfx1 = SpawnPrefab("icespike_fx_1")
		local impactfx2 = SpawnPrefab("icespike_fx_2")
		local impactfx3 = SpawnPrefab("icespike_fx_3")
		local impactfx4 = SpawnPrefab("icespike_fx_4")
		impactfx1.Transform:SetPosition(x + math.random(-0.6, 0.6), 0, z + math.random(-0.6, 0.6))
		impactfx2.Transform:SetPosition(x + math.random(-0.6, 0.6), 0, z + math.random(-0.6, 0.6))
		impactfx3.Transform:SetPosition(x + math.random(-0.6, 0.6), 0, z + math.random(-0.6, 0.6))
		impactfx4.Transform:SetPosition(x + math.random(-0.6, 0.6), 0, z + math.random(-0.6, 0.6))

		if target.components.freezable ~= nil and not target.components.health:IsDead() then
			target.components.freezable:AddColdness(1)
            target.components.freezable:SpawnShatterFX()
        end
		
		if not target.components.health:IsDead() then
			target.components.health:DoDelta(-50)
		end
		--[[
		if attacker.components.freezable ~= nil then
			attacker.components.freezable:AddColdness(2)
		end
		]]
    end
	
	inst.components.fueled:MakeEmpty()
	
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.5, fuelme)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cursed_antler")
    inst.AnimState:SetBuild("cursed_antler")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(28)
    inst.components.weapon:SetOnAttack(onattack)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cursed_antler.xml"

    inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("freezable")
	inst.components.freezable:SetShatterFXLevel(0)
	
    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(100)
	inst.components.fueled.accepting = false
	
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.5, fuelme)
	end
	
    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    inst._onownerequip = function(owner, data)
		if not owner:HasTag("vetcursed") then
			owner.components.inventory:DropItem(inst)
		end
    end

    return inst
end

return Prefab("cursed_antler", fn, assets)

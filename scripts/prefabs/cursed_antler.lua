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
	inst.components.weapon:SetDamage(34)
	
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.5, fuelme)
	end
end

local function onequip(inst, owner)
	if not owner:HasTag("vetcurse") then
		--owner.components.inventory:Unequip(EQUIPSLOTS.HANDS, true)
		inst:DoTaskInTime(0, function(inst, owner)
			local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
			owner.components.inventory:Unequip(EQUIPSLOTS.HANDS, false)
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
		owner.AnimState:OverrideSymbol("swap_object", "swap_cursed_antler", "swap_cursed_antler")

		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
    end
	
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.5, fuelme)
	end
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() and attacker:HasTag("vetcurse") and inst.components.fueled:GetPercent() >= 1 then
        local x, y, z = target.Transform:GetWorldPosition()
		local impactfx1 = SpawnPrefab("icespike_fx_1")
		local impactfx2 = SpawnPrefab("icespike_fx_2")
		local impactfx3 = SpawnPrefab("icespike_fx_3")
		local impactfx4 = SpawnPrefab("icespike_fx_4")
		impactfx1.Transform:SetPosition(x + math.random(-1.5, 1.5), 0, z + math.random(-1.5, 1.5))
		impactfx2.Transform:SetPosition(x + math.random(-1.5, 1.5), 0, z + math.random(-1.5, 1.5))
		impactfx3.Transform:SetPosition(x + math.random(-1.5, 1.5), 0, z + math.random(-1.5, 1.5))
		impactfx4.Transform:SetPosition(x + math.random(-1.5, 1.5), 0, z + math.random(-1.5, 1.5))

		if target.components.freezable ~= nil and not target.components.health:IsDead() then
			target.components.freezable:AddColdness(1)
            target.components.freezable:SpawnShatterFX()
        end
		
		if not target.components.health:IsDead() then
			target.components.health:DoDelta(-60)
		end
		
		local ents = TheSim:FindEntities(x, y, z, 2, nil, { "INLIMBO", "player", "abigail" })

		for i, v in ipairs(ents) do
			if v ~= inst and v:IsValid() and not v:IsInLimbo() then
				if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
					v.components.combat:GetAttacked(inst, 34, nil)
						
					if v.components.freezable ~= nil and not v.components.health:IsDead() then
						v.components.freezable:AddColdness(1)
						v.components.freezable:SpawnShatterFX()
					end
				end
			end
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
    inst.components.weapon:SetDamage(34)
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

    return inst
end

return Prefab("cursed_antler", fn, assets)

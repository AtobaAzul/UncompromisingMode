local assets =
{
    Asset("ANIM", "anim/whip.zip"),
    Asset("ANIM", "anim/swap_whip.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_rat_whip", "swap_whip")
    owner.AnimState:OverrideSymbol("whipline", "swap_rat_whip", "whipline")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() then
        local chance = TUNING.WHIP_SUPERCRACK_CREATURE_CHANCE

        local snap = SpawnPrefab("impact")

        local x, y, z = inst.Transform:GetWorldPosition()
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        local angle = -math.atan2(z1 - z, x1 - x)
        snap.Transform:SetPosition(x1, y1, z1)
        snap.Transform:SetRotation(angle * RADIANS)

        --impact sounds normally play through comabt component on the target
        --whip has additional impact sounds logic, which we'll just add here
		
		if attacker ~= nil and attacker.components.hunger ~= nil then
			local value = attacker.components.hunger:GetPercent()
			local hunger = 4
			
			if value < 0.25 then
				value = 0.25
			end
			
			local scalingvalue = hunger * value
			
			local damage = -8.5 * scalingvalue
			
            if target.SoundEmitter ~= nil then
				target.SoundEmitter:PlaySound("dontstarve/common/whip_small")
            end
			
			if target ~= nil and target.components.health ~= nil then
				target.components.health:DoDelta(damage, false, attacker)
			end
			
			if attacker.components.hunger ~= nil and attacker.components.hunger:GetPercent() > 0 then
				attacker.components.hunger:DoDelta(-scalingvalue)
			end
			local uses1 = 1
			local uses2 = 1
			if attacker ~= nil and attacker:IsValid() and attacker.components.efficientuser ~= nil then
				uses1 = 1 * (attacker.components.efficientuser:GetMultiplier(ACTIONS.ATTACK) or 1) * value
			end
			
			uses2 = 1 * value
			
			local uses = uses1 + uses2
			
			print("=======================")
			print("Value = "..value)
			print("Hunger = "..hunger)
			print("Scalingvalue = "..scalingvalue)
			print("Damage = "..damage)
			print("Base Damage Uses = "..uses1)
			print("Bonus Damage Uses = "..uses2)
			print("Final Uses = "..uses)
			print("=======================")
			
			inst.components.fueled:DoDelta(-uses)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("whip")
    inst.AnimState:SetBuild("rat_whip")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("whip")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", nil, 0.9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetRange(TUNING.WHIP_RANGE)
    inst.components.weapon:SetOnAttack(onattack)
	
    --[[inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.WHIP_USES)
    inst.components.finiteuses:SetUses(TUNING.WHIP_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)]]
	
    inst:AddComponent("fueled")
    --inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(300)
    inst.components.fueled:SetDepletedFn(inst.Remove)
	inst.components.fueled.accepting = false
    --inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rat_whip.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("rat_whip", fn, assets)

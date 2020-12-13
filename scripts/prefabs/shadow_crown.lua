local assets =
{
	Asset("ANIM", "anim/hat_snowgoggles.zip"),
	Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
	Asset("IMAGE", "images/inventoryimages/gasmask.tex"),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_nightarmour") 
end

	local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_shadowcrown", "swap_hat")

        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
		
		inst:ListenForEvent("blocked", OnBlocked, owner)
    end

	local function onunequip(inst, owner)

        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end
		
		inst:RemoveEventCallback("blocked", OnBlocked, owner)
    end
	
	
local function OnTakeDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local health = owner.components.health
        if health and not owner.components.health:IsDead() then
            local unsaneness = damage_amount * 1.2

			if owner.components.combat ~= nil then
				local x, y, z = owner.Transform:GetWorldPosition()
				local despawnfx = SpawnPrefab("shadow_despawn")
				despawnfx.Transform:SetPosition(x, y, z)
			end
            health:DoDelta(-unsaneness, false, "darkness")
        end
    end
end

	local function fn()
		local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("ruinshat")
        inst.AnimState:SetBuild("hat_shadowcrown")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")
		
		inst:AddTag("sanity")
		inst:AddTag("shadow")

		MakeInventoryFloatable(inst, "small", 0.2, 0.80)

        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/shadow_crown.xml"

        inst:AddComponent("inspectable")

		inst:AddComponent("armor")
		inst.components.armor:InitCondition(TUNING.ARMOR_SANITY, 1)
		inst.components.armor.ontakedamage = OnTakeDamage
		
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
		inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
		inst.components.equippable.is_magic_dapperness = true
		inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

        MakeHauntableLaunch(inst)
		--------------------------------------------------------------

        return inst
    end


return Prefab( "shadow_crown", fn, assets)
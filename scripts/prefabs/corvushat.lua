local assets =
{
	Asset("ANIM", "anim/hat_corvus.zip"),
}

	local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_corvus", "swap_hat")

        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
			owner.AnimState:Hide("HEAD")
		
		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
		end
		

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
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

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end

	local function fn()
		local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("corvushat")
        inst.AnimState:SetBuild("hat_corvus")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()
		
        inst.components.floater:SetSize("med")
        inst.components.floater:SetVerticalOffset(0.1)
        inst.components.floater:SetScale(0.63)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/snowgoggles.xml"

        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED

        MakeHauntableLaunch(inst)
		--------------------------------------------------------------
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.TOPHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(--[[generic_perish]]inst.Remove)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        return inst
    end


return Prefab( "corvushat", fn, assets)
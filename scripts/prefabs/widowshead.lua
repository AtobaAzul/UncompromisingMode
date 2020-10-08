local assets =
{
	Asset("ANIM", "anim/hat_snowgoggles.zip"),
	Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
	Asset("IMAGE", "images/inventoryimages/gasmask.tex"),
}

	local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_widowshead", "swap_hat")

        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
		
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
		
    end
	
	

	local function fn()
		local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("catcoonhat")
        inst.AnimState:SetBuild("hat_widowshead")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")
		inst:AddTag("nightvision")

		MakeInventoryFloatable(inst, "small", 0.2, 0.80)

        inst.entity:SetPristine()
		
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/widowshead.xml"

        inst:AddComponent("inspectable")


		
        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
		inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL/10

        MakeHauntableLaunch(inst)
		--------------------------------------------------------------

        return inst
    end


return Prefab( "widowshead", fn, assets)
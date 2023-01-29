local assets=
{
    Asset("ANIM", "anim/hat_sunglasses.zip"),
	Asset("ATLAS", "images/inventoryimages/sunglasses.xml"),
	Asset("IMAGE", "images/inventoryimages/sunglasses.tex"),
}



local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_sunglasses", "swap_hat")	
	
		owner.AnimState:Show("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")
		owner.AnimState:Show("HAIRFRONT")
	owner:AddTag("goggles")
	inst.components.fueled:StartConsuming()
	
	
end
 
local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:ClearOverrideSymbol("face")
    owner.AnimState:Hide("HAT")
	
	owner:RemoveTag("goggles")
	
	inst.components.fueled:StopConsuming()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("gogglesnormalhat")
    inst.AnimState:SetBuild("hat_sunglasses")
    inst.AnimState:PlayAnimation("anim")  

	inst:AddTag("hats")
    inst:AddTag("goggles")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sunglasses.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE

    inst:AddComponent("insulator")
    inst.components.insulator:SetSummer()
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.UMBRELLA_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
	
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
	MakeHauntableLaunch(inst)
    return inst
end
 
return Prefab("sunglasses", fn, assets)
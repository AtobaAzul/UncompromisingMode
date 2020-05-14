local assets=
{
    Asset("ANIM", "anim/hat_gasmask.zip"),
	Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
	Asset("IMAGE", "images/inventoryimages/gasmask.tex"),
}



local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_gasmask", "swap_hat")	
	
		owner.AnimState:Show("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")
		owner.AnimState:Show("HAIRFRONT")
	owner:AddTag("goggles")
	--owner:AddTag("toadstool")
	if not owner:HasTag("scp049") then
	owner:AddTag("has_gasmask")
	end
	inst.components.fueled:StartConsuming()
	
	
end
 
local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:ClearOverrideSymbol("face")
    owner.AnimState:Hide("HAT")
	
	owner:RemoveTag("goggles")
	--owner:RemoveTag("toadstool")
	if not owner:HasTag("scp049") then
	owner:RemoveTag("has_gasmask")
	end
	
	inst.components.fueled:StopConsuming()
end



--[[
local function gasmask()
		local inst = simple()
		inst:AddTag("gasmask")
		inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
		inst.components.equippable.poisongasblocker = true

		inst.components.equippable:SetOnEquip( opentop_onequip )

		inst:AddComponent("fueled")
		inst.components.fueled.fueltype = "USAGE"
		inst.components.fueled:InitializeFuelLevel(TUNING.GASMASK_PERISHTIME)
		inst.components.fueled:SetDepletedFn(generic_perish)
		inst.opentop = true
		return inst
	end
	--]]


local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("gasmaskhat")
    inst.AnimState:SetBuild("hat_gasmask")
    inst.AnimState:PlayAnimation("anim")  

	inst:AddTag("hats")
	inst:AddTag("has_gasmask")
    inst:AddTag("goggles")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/gasmask.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL / 2

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.UMBRELLA_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
	inst.opentop = true
     
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL / 2)
	
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
	MakeHauntableLaunch(inst)
    return inst
end
 
return Prefab("gasmask", fn, assets)
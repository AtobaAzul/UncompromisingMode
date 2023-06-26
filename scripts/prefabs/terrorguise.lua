local assets =
{
	Asset("ANIM", "anim/hat_shadowcrown.zip"),
	Asset("ATLAS", "images/inventoryimages/shadow_crown.xml"),
	Asset("IMAGE", "images/inventoryimages/shadow_crown.tex"),
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
	owner:AddTag("reallyfrickinscary")
	inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner)

	owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:Hide("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	owner:RemoveTag("reallyfrickinscary")
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
		
	end
	
	inst:RemoveEventCallback("blocked", OnBlocked, owner)
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
	inst:AddTag("shadow_item")

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
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.THURIBLE_SHADOW_LEVEL)

	MakeHauntableLaunch(inst)
	--------------------------------------------------------------

	return inst
end


return Prefab("terrorguise", fn, assets)
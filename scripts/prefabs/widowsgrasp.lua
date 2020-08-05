local assets =
{
    Asset("ANIM", "anim/bugzapper.zip"),
    Asset("ANIM", "anim/swap_bugzapper.zip"),
    Asset("SOUND", "sound/wilson.fsb"),
    Asset("INV_IMAGE", "lantern_lit"),
}


local function onequip(inst, owner)
    
    owner.AnimState:OverrideSymbol("swap_object", "swap_bugzapper", "swap_bugzapper")
	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner:AddTag("widowsgrasp")
	
end

local function onunequip(inst, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner:RemoveTag("widowsgrasp")

end


--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bugzapper")
    inst.AnimState:SetBuild("bugzapper")
    inst.AnimState:PlayAnimation("idle_off")


    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	--[[
	inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil]]
	
	inst:AddComponent("weapon")
    inst:AddTag("weapon")
    inst.components.weapon:SetDamage(150)
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bugzapper.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst:AddComponent("equippable")

    MakeHauntableLaunch(inst)

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)




    return inst
end

return Prefab("widowsgrasp", fn, assets)

local assets =
{
    Asset("ANIM", "anim/hat_widowshead.zip"),
    Asset("ATLAS", "images/inventoryimages/widowshead.xml"),
    Asset("IMAGE", "images/inventoryimages/widowshead.tex"),
}
local BEAVERVISION_COLOURCUBES =
{
    day = "images/colour_cubes/beaver_vision_cc.tex",
    dusk = "images/colour_cubes/beaver_vision_cc.tex",
    night = "images/colour_cubes/beaver_vision_cc.tex",
    full_moon = "images/colour_cubes/beaver_vision_cc.tex",
}
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_widowshead", "swap_hat")

    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
    --[[if owner.components.playervision ~= nil then   --Colorcubes don't listen....
		owner.components.playervision:SetCustomCCTable(BEAVERVISION_COLOURCUBES)
        owner.components.playervision:ForceNightVision(true)
		end]]
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
    --[[if owner.components.playervision ~= nil then
		owner.components.playervision:SetCustomCCTable(nil)
		owner.components.playervision:ForceNightVision(false)
		end]]
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
    inst:AddTag("donotautopick")

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
    inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL / 2

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((7.5 * TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunch(inst)
    --------------------------------------------------------------

    return inst
end


return Prefab("widowshead", fn, assets)

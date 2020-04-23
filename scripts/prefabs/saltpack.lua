local assets =
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_krampus_sack.zip"),
    Asset("ANIM", "anim/ui_krampusbag_2x5.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_saltpack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_saltpack", "swap_body")
	if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end

end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
	if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function Outoffuel(inst)
	if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
	inst:AddTag("empty")
	inst:RemoveTag("goggles")
	inst:RemoveTag("blizzardsuppresser")
end

local function OnAddFuel(inst)
if inst:HasTag("empty") then
	inst:RemoveTag("empty")
end
if not inst:HasTag("goggles") then
	inst:AddTag("goggles")
end
if not inst:HasTag("blizzardsuppresser") then
	inst:AddTag("blizzardsuppresser")
end
inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_saltpack")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("backpack")
	inst:AddTag("blizzardsuppresser")
	inst:AddTag("goggles")
	
    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst, "med", 0.1, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = true

	inst:AddComponent("fueled")
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
	inst.components.fueled:InitializeFuelLevel(TUNING.YELLOWAMULET_FUEL)
	inst.components.fueled:SetDepletedFn(Outoffuel)
	inst.components.fueled:SetTakeFuelFn(OnAddFuel)
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)


    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("saltpack", fn, assets)

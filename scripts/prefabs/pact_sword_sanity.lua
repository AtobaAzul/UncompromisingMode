local assets =
{
    Asset("ANIM", "anim/nightmaresword.zip"),
    Asset("ANIM", "anim/swap_nightmaresword.zip"),
}

local function onequip(inst, owner)
	inst:AddTag("pact_bound")
	owner.AnimState:OverrideSymbol("swap_object", "swap_nightmaresword", "swap_nightmaresword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	local fx = SpawnPrefab("um_shadow_attune_fx")
	fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
	fx.AnimState:PlayAnimation("attune_out")
	fx.SoundEmitter:PlaySound("dontstarve/sanity/creature2/die")
	
	inst:DoTaskInTime(0, inst.Remove)
	--inst:Remove()
end

local function CheckIfUnequipped(inst)
	if not inst.components.equippable:IsEquipped() then
		inst:Remove()
	end
end

local function CalcDappernessNightSword(inst, owner)
	if owner:HasTag("Funny_Words_Magic_Man") then
		return TUNING.CRAZINESS_MED * .8 -- This ends up blah blah blah shut up bro ur weird
	else
		return TUNING.CRAZINESS_MED
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nightmaresword")
    inst.AnimState:SetBuild("nightmaresword")
    inst.AnimState:PlayAnimation("idle")
    --inst.AnimState:SetMultColour(1, 1, 1, .6)

    inst:AddTag("shadow_item")
    inst:AddTag("shadow")
    inst:AddTag("sharp")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

	--shadowlevel (from shadowlevel component) added to pristine state for optimization
	inst:AddTag("shadowlevel")

    local swap_data = {sym_build = "swap_nightmaresword", bank = "nightmaresword"}
    MakeInventoryFloatable(inst, "med", 0.05, {1.0, 0.4, 1.0}, true, -17.5, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.NIGHTSWORD_USES)
    inst.components.finiteuses:SetUses(TUNING.NIGHTSWORD_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:ChangeImageName("nightsword")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
	inst.components.equippable.dapperfn = CalcDappernessNightSword
    inst.components.equippable.is_magic_dapperness = true

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.NIGHTSWORD_SHADOW_LEVEL)
	
	inst:DoTaskInTime(0, CheckIfUnequipped)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("pact_sword_sanity", fn, assets)

local assets =
{
    Asset("ANIM", "anim/nightstick.zip"),
    Asset("ANIM", "anim/swap_nightstick.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "nightstickfire",
    "electrichitsparks",
}

local function onpocket(inst)
    inst.components.burnable:Extinguish()
end

local function onremovefire(fire)
    fire.nightstick.fire = nil
end

local function onequip(inst, owner)
    inst.components.burnable:Ignite()
    owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/morningstar", "torch")
    --inst.SoundEmitter:SetParameter("torch", "intensity", 1)

    if inst.fire == nil then
        inst.fire = SpawnPrefab("nightstickfire")
        inst.fire.nightstick = inst
        inst:ListenForEvent("onremove", onremovefire, inst.fire)
    end
    inst.fire.entity:SetParent(owner.entity)
end

local function onunequip(inst, owner)
    if inst.fire ~= nil then
        inst.fire:Remove()
    end

    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst.SoundEmitter:KillSound("torch")
end

local function OnRemoveEntity(inst)
    if inst.fire ~= nil then
        inst.fire:Remove()
    end
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() then
        SpawnPrefab("electrichitsparks"):AlignToTarget(target, attacker, true)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("nightstick")
    inst.AnimState:SetBuild("nightstick")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)

    inst:AddTag("wildfireprotected")
    inst:AddTag("donotautopick")
    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.4, 1.1}, true, -19, {sym_build = "swap_nightstick"})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(100000000)
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetElectric()

    inst:AddComponent("inventoryitem")
    -----------------------------------

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnPocket(onpocket)
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    -----------------------------------

    inst:AddComponent("inspectable")

    -----------------------------------

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil

    MakeHauntableLaunch(inst)

    inst.OnRemoveEntity = OnRemoveEntity

    return inst
end

return Prefab("deathstick", fn, assets, prefabs)

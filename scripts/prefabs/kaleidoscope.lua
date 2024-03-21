local assets =
{
    Asset("ANIM", "anim/whip.zip"),
    Asset("ANIM", "anim/swap_whip.zip"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_whip", inst.GUID, "swap_whip")
        owner.AnimState:OverrideItemSkinSymbol("whipline", skin_build, "whipline", inst.GUID, "swap_whip")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_whip", "swap_whip")
        owner.AnimState:OverrideSymbol("whipline", "swap_whip", "whipline")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function Shuffle(t)
    local s = {}
    for i = 1, #t do s[i] = t[i] end
    for i = #t, 2, -1 do
        local j = math.random(i)
        s[i], s[j] = s[j], s[i]
    end
    return s
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() then
        target:AddTag("take_extra_spdamage")

        target.planar_target = inst:DoTaskInTime(1.5, function(inst)
            inst:RemoveTag("take_extra_spdamage")
        end)

        local x, y, z = inst.Transform:GetWorldPosition()
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        local fx = SpawnPrefab(inst.attackfx[math.random(#inst.attackfx)])

        fx.Transform:SetPosition(x1, y1, z1)

        inst.attackfx = Shuffle(inst.attackfx)

        if target.SoundEmitter ~= nil then
            target.SoundEmitter:PlaySound(inst.skin_sound_small or "dontstarve/common/whip_small", nil, 0.33)
            target.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/trinket_1", nil, 0.75)
        end

    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("whip")
    inst.AnimState:SetBuild("whip")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("whip")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", nil, 0.9)

    inst.entity:SetPristine()

    inst.attackfx = {
        "ghostlyelixir_attack_dripfx",
        "ghostlyelixir_retaliation_dripfx",
        "ghostlyelixir_shield_dripfx",
        "ghostlyelixir_slowregen_dripfx",
        "ghostlyelixir_speed_dripfx",
    }

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetRange(TUNING.WHIP_RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.WHIP_USES*2)
    inst.components.finiteuses:SetUses(TUNING.WHIP_USES*2)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("kaleidoscope", fn, assets)

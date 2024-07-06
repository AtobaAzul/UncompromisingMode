local prefabs = {
    "impact",
    "um_smolder_spore_pop",
    "umdebuff_pyre_toxin"
}


local DebuffDuration = 6 -- Length of Pyre Toxin on struck target; 6 is the debuff's default.
local DebuffDurationBonus = 10


local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blowdart", "swap_blowdart")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end


-- What happens TO the target hit.
local function OnAttack(inst, attacker, target)
    if target:IsValid()
        and not target:HasTag("INLIMBO")
        and not target:HasTag("noattack")
    then
        if attacker:HasTag("pyromaniac") then
            target.components.health:DoDelta(-25) -- Willow does some flat bonus damage to the target.
        end

        target:AddDebuff("umdebuff_pyre_toxin_dart", "umdebuff_pyre_toxin", DebuffDuration)

        if attacker:HasTag("pyromaniac") then
            target:DoTaskInTime(FRAMES * 1, function()
                target:AddDebuff("umdebuff_pyre_toxin_dart_bonus", "umdebuff_pyre_toxin", DebuffDurationBonus) -- Willow applies the debuff a second time to the target.
            end)
        end

        if target.SoundEmitter ~= nil then
            target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_sleep")
        end
    end
end


-- What the dart object does when it hits a target.
local function OnHit(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx ~= nil and target.components.combat then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        if attacker ~= nil and attacker:IsValid() then
            impactfx:FacePoint(attacker.Transform:GetWorldPosition())
        end
    end

    if target ~= nil then
        SpawnPrefab("um_smolder_spore_pop").Transform:SetPosition(target.Transform:GetWorldPosition())

        -- Instantly damages anything within a radius.
        local x, y, z = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 3, nil, { "SmolderSporeAvoid", "BUSYSMOLDERSPORE", "INLIMBO", "invisible", "noattack" })
        if #ents > 0 then
            for i, v in pairs(ents) do
                if v.components.combat ~= nil then
                    v.components.combat:GetAttacked(inst, 50, inst, "fire")
                    if attacker:HasTag("pyromaniac") then
                        v.components.combat:GetAttacked(inst, 25, inst, "fire")
                    end

                    v.components.combat:SetTarget(attacker)
                end
            end
        end
    end

    inst:Remove()
end

local function OnThrown(inst)
    inst.AnimState:PlayAnimation("dart_pyre")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function OnThrownListened(inst, data)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.components.inventoryitem.pushlandedevents = false
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_blowdart_pyre")
    inst.AnimState:SetBuild("um_blowdart_pyre")
    inst.AnimState:PlayAnimation("idle_pyre")

    MakeInventoryFloatable(inst, "small", 0.05, { 0.75, 0.5, 0.75 })
    local swap_data = { sym_build = "swap_blowdart", bank = "um_blowdart_pyre", anim = "idle_pyre" }
    inst.components.floater:SetBankSwapOnFloat(true, -4, swap_data)

    inst:AddTag("blowdart")
    inst:AddTag("sharp")
    inst:AddTag("donotautopick")
    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(25)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnAttack(OnAttack)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst:ListenForEvent("onthrown", OnThrownListened)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    return inst
end


return Prefab("um_blowdart_pyre", fn, nil, prefabs)

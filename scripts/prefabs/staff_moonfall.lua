-- TODO: Damage and uses tuning
local assets = { Asset("ANIM", "anim/staffs.zip"), Asset("ANIM", "anim/swap_staffs.zip"),
    Asset("ANIM", "anim/lavaarena_hit_sparks_fx.zip"), Asset("ANIM", "anim/crab_king_shine.zip"),
    Asset("ANIM", "anim/explode.zip") }
local function OnAttack(inst, attacker, target, skipsanity)
    if not target:IsValid() then
        -- target killed or removed in combat damage phase
        return
    end

    local drain = attacker:HasTag("Funny_Words_Magic_Man") and 0.5 or 1

    if not skipsanity and attacker ~= nil then
        if attacker.components.staffsanity then
            attacker.components.staffsanity:DoCastingDelta(-TUNING.SANITY_SUPERTINY * drain)
        elseif attacker.components.sanity ~= nil then
            attacker.components.sanity:DoDelta(-TUNING.SANITY_SUPERTINY * drain)
        end
    end

    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target == nil or not target:IsValid() then
        return -- target removed/died.
    end

    if inst.beam ~= nil then
        if inst.beam ~= nil and inst.beam.KillFX ~= nil then
            inst.beam:KillFX()
        end
        if inst.beam.back ~= nil and inst.beam.back.KillFX ~= nil then
            inst.beam.back:KillFX()
        end
    end

    inst.beam = SpawnPrefab("positronbeam_front")
    local x, y, z = target.Transform:GetWorldPosition()

    if x == nil or y == nil or z == nil then
        beam:Remove() -- wierd edge case with things that immediatly remove themselves on death.
        return
    end
    local bx, by, bz = x + math.random(-2, 2), y, z + math.random(-2, 2)
    inst.beam.Transform:SetPosition(bx, by, bz)
    inst.beam.attacker = attacker
    inst.beam.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/beam", "beam")
    local wep = inst
    inst.beam.intensity = 0
    inst.beam:DoPeriodicTask(0.5, function(inst)
        local ents = TheSim:FindEntities(bx, by, bz, 4, { "_combat", "_health" }, { "INLIMBO", "dead", "player", "companion", "abigail", "playerghost" })
        if #ents ~= 0 then
            inst.intensity = inst.intensity + 0.33
        else
            inst:KillFX()
            if inst.back ~= nil then
                inst.back:KillFX()
            end
        end

        inst.AnimState:SetAddColour(0, 0, inst.intensity, 1)
        inst.SoundEmitter:SetParameter("beam", "intensity", inst.intensity)

        if inst.intensity > 3 then
            if inst.back == nil then
                inst.back = SpawnPrefab("positronbeam_back")
            end
            inst.back.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
        if inst.intensity >= 8 then
            inst:KillFX()
            if inst.back ~= nil then
                inst.back:KillFX()
            end
        end

        for k, v in pairs(ents) do
            if k > 5 then break end

            if v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
                v.components.combat:GetAttacked(inst.attacker, 10 * (0.25 + inst.intensity), nil, nil, { planar = 10 * (0.5 + inst.intensity) })
                local _x, _y, _z = v.Transform:GetWorldPosition()
                for i = 1, math.random(5) do
                    local fx2 = SpawnPrefab("warg_mutated_breath_fx")
                    fx2.Transform:SetPosition(_x + math.random(-10, 10) / 10, _y, _z + math.random(-10, 10) / 10)
                    fx2:RestartFX((math.max(0.25, inst.intensity)) * 0.33)
                    fx2:DoTaskInTime(math.random() * 2 + 1 + (i * 0.25), fx2.KillFX)
                end
            end
        end

        local fx = SpawnPrefab("warg_mutated_ember_fx")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:RestartFX(math.max(0.25, inst.intensity))
        fx:DoTaskInTime(math.random() * 2 + 1, fx.KillFX)
    end)

    if inst.components.finitesuses ~= nil then -- who knows, someone might make a mod to remove it
        inst.components.finitesuses:Use()
    end

    target.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function OnAttacked(inst)
    local staff = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if staff.beam ~= nil then
        if staff.beam ~= nil and staff.beam.KillFX ~= nil then
            staff.beam:KillFX()
        end
        if staff.beam.back ~= nil and staff.beam.back.KillFX ~= nil then
            staff.beam.back:KillFX()
        end
    end

end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_staff_starfall", "staff_starfall")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:SetSymbolHue("swap_object", 0.5)
    owner.AnimState:SetSymbolSaturation("swap_object", 5)

    owner:ListenForEvent("attacked", OnAttacked)
end

local function OnUnequip(inst, owner)
    owner:RemoveEventCallback("attacked", OnAttacked)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:SetSymbolHue("swap_object", 1)
    owner.AnimState:SetSymbolSaturation("swap_object", 1)

    owner.AnimState:Show("ARM_normal")

    if inst.beam ~= nil then
        if inst.beam ~= nil and inst.beam.KillFX ~= nil then
            inst.beam:KillFX()
        end
        if inst.beam.back ~= nil and inst.beam.back.KillFX ~= nil then
            inst.beam.back:KillFX()
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("starfall_staff")
    inst.AnimState:SetBuild("starfall_staff")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetHue(0.5)

    local floater_swap_data = {
        sym_build = "starfall_staff",
        sym_name = "starfall_staff",
        bank = "starfall_staff",
        anim = "idle"
    }

    MakeInventoryFloatable(inst, "med", 0.1, { 0.9, 0.4, 0.9 }, true, -13, floater_swap_data)

    inst.entity:SetPristine()

    inst:AddTag("weapon")
    inst:AddTag("rangedweapon")

    if not TheWorld.ismastersim then
        return inst
    end
    inst._points = {}

    -------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnAttack(OnAttack)
    -- inst.components.weapon:SetProjectile("starfall_staff_projectile")
    inst.components.floater:SetScale({ 0.8, 0.4, 0.8 })

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(15)
    inst.components.finiteuses:SetUses(15)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    return inst
end

return Prefab("staff_moonfall", fn, assets)

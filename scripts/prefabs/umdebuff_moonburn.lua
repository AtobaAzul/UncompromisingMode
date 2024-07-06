local prefabs = {
    "umdebuff_moonburn_fx"
}


-- Default duration is pretty short. This can be changed by whatever inflicts the debuff, by passing data after the debuff name and prefab.
local DebuffDuration = 2
local DebuffDamageMult = 1


local function debuff_OnDetached(inst, target)
    if inst.fx ~= nil then
        if inst.fx:IsValid() then
            --	inst.fx:Remove()
            ErodeAway(inst.fx, 60 * FRAMES)
        end
    end

    inst:DoTaskInTime(0, function()
        inst:Remove()
    end)
end


local function SpawnStrayFX(inst)
    local strayspawn = SpawnPrefab("umdebuff_moonburn_fx_stray")

    strayspawn.Transform:SetPosition(inst.fx.Transform:GetWorldPosition())

    local scale = inst.fx.Transform:GetScale()
    local scalemult = math.random(7, 12) * 0.1
    local scalevar = scale * scalemult

    strayspawn.Transform:SetScale(scalevar, scalevar, scalevar)
end

local function DamageTarget(inst, target)
    if target.components.health.currenthealth > 5 then
        --	target.components.combat:GetAttacked(inst, 3, nil, nil, {planar = 5}) -- Planar based on vanilla's fused_shadeling_bomb.lua, line 103.
        -- Not using that because we don't want this to hitstun, but it's a useful reference.

        local percenthealth = 0 - ((target.components.health.currenthealth * 0.05) * DebuffDamageMult)

        if target:HasTag("epic") then
            percenthealth = 0 - ((target.components.health.currenthealth * 0.02) * DebuffDamageMult) -- Lower percent against bosses, so it isn't game-breaking.
        end

        if not (target.components.inventory ~= nil and target.components.inventory:EquipHasSpDefenseForType("planar")) then -- Check for planar armor.
            target.components.health:DoDelta(percenthealth, false, "umdebuff_moonburn")
        end
        target.components.health:DoDelta(percenthealth, false, "umdebuff_moonburn")

        -- Raise Sanity/Enlightenment.
        if target.components.sanity ~= nil then
            target.components.sanity:DoDelta(2)
        end

        if inst.fx ~= nil then
            -- Make some noise.
            inst.fx.SoundEmitter:KillSound("moonburn_tick")
            inst.fx.SoundEmitter:PlaySound("dontstarve/common/fireOut", "moonburn_tick") -- TODO: Should make a better sound for this. MutExt soundbank.
            inst.fx.SoundEmitter:SetVolume("moonburn_tick", 0.7)

            -- Stray particles for dramatic effect.
            SpawnStrayFX(inst)
        end
    end
end

local function debuff_OnAttached(inst, target, followsymbol, followoffset, data, data2)
    if target ~= nil
        and (target.components.temperature ~= nil or target.components.health ~= nil)
        and not target:HasTag("MoonburnImmune")
        and not target:HasTag("plantkin") -- Wormwood immune because moon baby??
        and not target:HasTag("shadowcreature") -- Doesn't feel right visually.
        and not target:HasTag("brightmare")
        and not target:HasTag("brightmareboss")
        and not target:HasTag("butterfly")
        and not (target:HasTag("bee") and not target:HasTag("monster"))
        and not target:HasTag("wall")
        and not target:HasTag("structure")
    then
        -- Basic debuff stuff.
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0)
        if data ~= nil then
            DebuffDuration = data
        end
        if data2 ~= nil then
            DebuffDamageMult = data2
        end
        inst.components.timer:StartTimer("moonburnduration", DebuffDuration)
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        -- Player negatives here.
        if target:HasTag("player")
            and not target:HasTag("playerghost")
        then
            -- Periodic effect.
            if target.components.health ~= nil and not target.components.health:IsDead() then
                inst:DoPeriodicTask(0.3, DamageTarget, 0, target)
            end
        end

        -- Mob negatives here.
        if not target:HasTag("player") then
            -- Periodic effect.
            if target.components.health ~= nil and not target.components.health:IsDead() then
                inst:DoPeriodicTask(0.3, DamageTarget, 0, target)
            end
        end

        -- Haunt the victim.
        if target.components.hauntable == nil then
            target:AddComponent("hauntable")
            target.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
        end
        if target.components.hauntable ~= nil then
            inst:PushEvent("haunt", { target = target })
            target.components.hauntable:DoHaunt(inst)
        end

        -- Begin the visual effects.
        if inst.fx == nil or not inst.fx:IsValid() then
            inst.fx = SpawnPrefab("umdebuff_moonburn_fx")
        end
        if target.components.combat ~= nil then
            inst.fx.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        else
            inst.fx.entity:SetParent(target.entity)
        end
        if target:HasTag("smallcreature") then
            inst.fx.Transform:SetScale(1.5, 1.5, 1.5)
        elseif target:HasTag("epic") then
            inst.fx.Transform:SetScale(6, 6, 6)
        end
        if not (target.components.inventory ~= nil and target.components.inventory:EquipHasSpDefenseForType("planar")) then -- Check for planar armor.
            inst.fx.AnimState:SetMultColour(1, 1, 1, 0.6)                                                             -- FX are less visible if partially blocked by wearing planar armor.
        end
    else
        inst:Remove()
    end
end

local function debuff_OnExtended(inst, target, followsymbol, followoffset, data, data2)
    -- This sets the incomming debuff's duration.
    if data ~= nil then
        DebuffDuration = data
    end

    -- Check how long we have left on our already-existing debuff, if there is one.
    local time_remaining = inst.components.timer:GetTimeLeft("moonburnduration")

    if time_remaining ~= nil then
        if DebuffDuration > time_remaining then
            inst.components.timer:SetTimeLeft("moonburnduration", DebuffDuration)
        end
    else
        inst.components.timer:StartTimer("moonburnduration", DebuffDuration)
    end
end

local function OnTimerDone(inst, data)
    if data.name == "moonburnduration" then
        inst.components.debuff:Stop()
    end
end


local function fn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:Remove()

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    inst.entity:Hide()

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(debuff_OnAttached)
    inst.components.debuff:SetDetachedFn(debuff_OnDetached)
    inst.components.debuff:SetExtendedFn(debuff_OnExtended)
    inst.components.debuff.keepondespawn = false

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end



local function fx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("umdebuff_moonburn_fx")
    inst.AnimState:SetBuild("umdebuff_moonburn_fx")
    inst.Transform:SetScale(3, 3, 3)
    inst.AnimState:SetMultColour(1, 1, 1, 0.95)
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end



local function fx_stray_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("umdebuff_moonburn_fx")
    inst.AnimState:SetBuild("umdebuff_moonburn_fx")
    inst.Transform:SetScale(1.5, 1.5, 1.5)
    inst.AnimState:SetMultColour(1, 1, 1, 0.85)
    inst.AnimState:PlayAnimation("stray", false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", function()
        inst:Remove()
    end)

    inst.persists = false

    return inst
end



local function testingstick_SpellFn(inst, target, position)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner == nil or not owner:IsValid() then
        return
    end

    if owner.components.health ~= nil and not owner.components.health:IsDead() then
        owner:AddDebuff("umdebuff_moonburn", "umdebuff_moonburn", DebuffDuration, DebuffDamageMult)
    end
end

local function testingstick_OnAttack(inst, attacker, target)
    if target == nil or not target:IsValid() then
        return
    end

    if target.components.health ~= nil and not target.components.health:IsDead() then
        target:AddDebuff("umdebuff_moonburn", "umdebuff_moonburn", DebuffDuration, DebuffDamageMult)
    end
end

local function testingstick_OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_um_staff_meteor", "swap_um_staff_meteor")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function testingstick_OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function testingstick_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_staff_meteor")
    inst.AnimState:SetBuild("um_staff_meteor")
    inst.AnimState:PlayAnimation("idle")

    local floater_swap_data = {
        sym_build = "um_staff_meteor",
        sym_name = "um_staff_meteor",
        bank = "um_staff_meteor",
        anim = "idle"
    }

    MakeInventoryFloatable(inst, "med", 0.05, { 1.1, 0.4, 1.1 }, true, -19, floater_swap_data)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("rangedweapon")

    inst:AddTag("quickcast")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnAttack(testingstick_OnAttack)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "um_staff_meteor"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/um_staff_meteor.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(testingstick_OnEquip)
    inst.components.equippable:SetOnUnequip(testingstick_OnUnequip)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(testingstick_SpellFn)
    inst.components.spellcaster.quickcast = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("umdebuff_moonburn", fn, nil, prefabs),
    Prefab("umdebuff_moonburn_fx", fx_fn),
    Prefab("umdebuff_moonburn_fx_stray", fx_stray_fn),
    Prefab("umdebuff_moonburn_testingstick", testingstick_fn)




--     where               w ass  will be                                                                                iar
-- f orm?  mov em ent? ? what ii s s s shedd ing skinformstheworldunravelsthevineerofperceptionmouthesexisttoblindeyestolie
--  joi n  b r   ecome onewithmanyinfiniteanddivine voices  voces   yours                                     etray
--       us   eAK              the  wa tcher     forgotten knowledge
--                                                  bidden             o urs

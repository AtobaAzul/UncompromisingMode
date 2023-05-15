-- TODO: Damage and uses tuning
local assets = {Asset("ANIM", "anim/staffs.zip"), Asset("ANIM", "anim/swap_staffs.zip"), Asset("ANIM", "anim/lavaarena_hit_sparks_fx.zip"), Asset("ANIM", "anim/crab_king_shine.zip"), Asset("ANIM", "anim/explode.zip")}
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

    for i = 1, math.random(3, 5) do
        inst:DoTaskInTime(i == 1 and 0 or math.random() * 0.5, function()
            if target == nil or not target:IsValid() then
                return -- target removed/died.
            end
            local proj = SpawnPrefab("staff_starfall_projectile")
            local x, y, z = target.Transform:GetWorldPosition()
            if x == nil or y == nil or z == nil then
                proj:Remove() -- wierd edge case with things that immediatly remove themselves on death.
                return
            end
            proj.Transform:SetPosition(x + math.random(-4, 4), y + math.random(10, 15), z + math.random(-4, 4))
            proj.attacker = attacker
            if inst.components.finitesuses ~= nil then -- who knows, someone might make a mod to remove it
                inst.components.finitesuses:Use()
            end
            target.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
        end)
    end
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_yellowstaff")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hits_sparks")
    inst.AnimState:SetBuild("lavaarena_hit_sparks_fx")
    inst.AnimState:PlayAnimation("hit_3")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetFinalOffset(1)

    local floater_swap_data = {sym_build = "swap_staffs", sym_name = "swap_yellowstaff", bank = "staffs", anim = "yellowstaff"}

    MakeInventoryFloatable(inst, "med", 0.1, {0.9, 0.4, 0.9}, true, -13, floater_swap_data)

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
    -- inst.components.weapon:SetProjectile("staff_starfall_projectile")
    inst.components.floater:SetScale({0.8, 0.4, 0.8})

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    return inst
end

local function OnCollide(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local targets = TheSim:FindEntities(x, y, z, 4, {"_combat"}, {"dead", "INLIMBO", "companion", "abigail", "player", "playerghost"})

    for k, target in ipairs(targets) do
        if target:HasTag("shadowcreature") or target.sg == nil or target.wixieammo_hitstuncd == nil and not (target.sg:HasStateTag("busy") or target.sg:HasStateTag("caninterrupt")) or target.sg:HasStateTag("frozen") then

            target.wixieammo_hitstuncd = target:DoTaskInTime(8, function()
                if target.wixieammo_hitstuncd ~= nil then
                    target.wixieammo_hitstuncd:Cancel()
                end

                target.wixieammo_hitstuncd = nil
            end)
            target.components.combat:GetAttacked(inst.attacker, 27.21, inst.attacker)
        else
            if target.components.combat ~= nil then
                target.components.combat:GetAttacked(inst.attacker, 0, inst.attacker)
                target.components.combat:SetTarget(inst.attacker)
            end

            if target.components.health ~= nil then
                target.components.health:DoDelta(-27.21, false, inst.attacker, false, inst.attacker, false)
            end
        end

        if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
            target.components.sleeper:WakeUp()
        end

        if target.components.combat ~= nil then
            target.components.combat.temp_disable_aggro = false
            target.components.combat:RemoveShouldAvoidAggro(inst.attacker)
        end

        if inst.attacker.components.combat ~= nil then
            inst.attacker.components.combat:SetTarget(target)
        end
    end

    if not TheWorld.Map:IsOceanAtPoint(x, 0, z) then -- man I really overdid this didn't I
        local fx = SpawnPrefab("staff_starfall_explode")
        fx.Transform:SetPosition(x, y, z)
        fx.SoundEmitter:PlaySound("dontstarve/common/lava_arena/spell/elemental/attack")

        local fx2 = SpawnPrefab("staff_starfall_scorch")
        fx2.Transform:SetPosition(x, y, z)

        local fx3 = SpawnPrefab("slow_steam_fx" .. math.random(5))
        fx3.Transform:SetPosition(x, y, z)
    else
        local fx = SpawnPrefab("crab_king_waterspout")
        fx.Transform:SetPosition(x, y, z)

        local fx2 = SpawnPrefab("crab_king_bubble" .. math.random(3))
        fx2.Transform:SetPosition(x, y, z)
        local fx3 = SpawnPrefab("slow_steam_fx"..math.random(5))
        fx3.Transform:SetPosition(x, y, z)
    end

    inst:Remove()
end

local function onupdate_reverse(inst, dt)
    inst.Light:SetIntensity(inst.i)
    inst.i = inst.i + dt * 2

    if inst.i <= 0 then
        if inst.killfx then
            inst:Remove()
        else
            inst.task:Cancel()
            inst.task = nil
        end
    end
end

local function fn_proj()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()

    inst.AnimState:SetBank("crab_king_shine")
    inst.AnimState:SetBuild("crab_king_shine")
    inst.AnimState:PlayAnimation("shine", true)
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)

    inst.entity:AddLight()
    inst.Light:SetIntensity(.2)
    inst.Light:SetRadius(4)
    inst.Light:SetFalloff(2)
    inst.Light:SetColour(1, 1, 0)

    inst.Transform:SetScale(0.75, 0.75, 0.75)

    inst.hue = math.random()

    if TheWorld.state.isfullmoon or TheWorld.state.isalterawake then
        inst:DoPeriodicTask(0.25, function(inst)
            inst.hue = inst.hue - 0.01
            if inst.hue == 0 then
                inst.hue = 1
            end
            inst.AnimState:SetHue(inst.hue)
        end)
    else
        inst.AnimState:SetAddColour(0.5, 0, 0, 0)
    end

    inst.entity:AddPhysics()
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetRestitution(0)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:SetSphere(2)
    inst.Physics:SetMotorVel(math.random(-50, 50) / 10, -50, math.random(-50, 50) / 10)

    local dt = 1 / 20
    inst.i = .1
    inst.sound = inst.SoundEmitter ~= nil
    inst.task = inst:DoPeriodicTask(dt, onupdate_reverse, nil, dt)

    inst.SoundEmitter:PlaySound("rifts/lunarthrall_bomb/throw", "toss")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoPeriodicTask(FRAMES, function(inst)
        local fx = SpawnPrefab("staff_starfall_trail")
        local x, y, z = inst.Transform:GetWorldPosition()
        fx.Transform:SetPosition(x, y, z)
        if y <= 0.05 then
            OnCollide(inst)
        end
    end)

    return inst
end

local function onupdate(inst, dt)
    inst.Light:SetIntensity(inst.i)
    inst.i = inst.i - dt * 2
    if inst.i <= 0 then
        if inst.killfx then
            inst:Remove()
        else
            inst.task:Cancel()
            inst.task = nil
        end
    end
end

local function fn_fx1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("explode")
    inst.AnimState:SetBuild("explode")
    inst.AnimState:PlayAnimation("small_firecrackers")
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(1)

    -- inst.Transform:SetScale(0.5, 0.5, 0.5)

    inst.entity:AddLight()
    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(6)
    inst.Light:SetFalloff(2)
    inst.Light:SetColour(1, 1, 0)

    inst.hue = 0

    if TheWorld.state.isfullmoon or TheWorld.state.isalterawake then
        inst:DoPeriodicTask(0.25, function(inst)
            inst.hue = inst.hue - 0.01
            if inst.hue == 0 then
                inst.hue = 1
            end
            inst.AnimState:SetHue(inst.hue)
        end)
    else
        inst.AnimState:SetAddColour(0.5, 0, 0, 0)
    end

    local dt = 1 / 20
    inst.i = .9
    inst.sound = inst.SoundEmitter ~= nil
    inst.task = inst:DoPeriodicTask(dt, onupdate, nil, dt)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fn_fx2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("hits_sparks")
    inst.AnimState:SetBuild("lavaarena_hit_sparks_fx")
    inst.AnimState:PlayAnimation("hit_3")
    inst.AnimState:Hide("glow")

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetScale(math.random() >= 0.5 and -.7 or .7, .7)

    inst.hue = 0

    if TheWorld.state.isfullmoon or TheWorld.state.isalterawake then
        inst:DoPeriodicTask(0.25, function(inst)
            inst.hue = inst.hue - 0.01
            if inst.hue == 0 then
                inst.hue = 1
            end
            inst.AnimState:SetHue(inst.hue)
        end)
    else
        inst.AnimState:SetAddColour(0.5, 0, 0, 0)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local SCORCH_YELLOW_FRAMES = 20
local SCORCH_DELAY_FRAMES = 40
local SCORCH_FADE_FRAMES = 15

local function Scorch_OnFadeDirty(inst)
    -- V2C: hack alert: using SetHightlightColour to achieve something like OverrideAddColour
    --     (that function does not exist), because we know this FX can never be highlighted!
    if inst._fade:value() > SCORCH_FADE_FRAMES + SCORCH_DELAY_FRAMES then
        local k = (inst._fade:value() - SCORCH_FADE_FRAMES - SCORCH_DELAY_FRAMES) / SCORCH_YELLOW_FRAMES
        inst.AnimState:OverrideMultColour(1, 1, 1, 1)
        inst.AnimState:SetHighlightColour(k, k, 0, 0)
        inst.AnimState:SetLightOverride(k)

    elseif inst._fade:value() >= SCORCH_FADE_FRAMES then
        inst.AnimState:OverrideMultColour(1, 1, 1, 1)
        inst.AnimState:SetHighlightColour()
    else
        local k = inst._fade:value() / SCORCH_FADE_FRAMES
        k = k * k
        inst.AnimState:OverrideMultColour(1, 1, 1, k)
        inst.AnimState:SetHighlightColour()
    end
end

local function Scorch_OnUpdateFade(inst)
    if inst._fade:value() > 1 then
        inst._fade:set_local(inst._fade:value() - 1)
        Scorch_OnFadeDirty(inst)
    elseif TheWorld.ismastersim then
        inst:Remove()
    elseif inst._fade:value() > 0 then
        inst._fade:set_local(0)
        inst.AnimState:OverrideMultColour(1, 1, 1, 0)
    end
end

local function fn_fx3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("burntground")
    inst.AnimState:SetBank("burntground")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst._fade = net_byte(inst.GUID, "deerclops_laserscorch._fade", "fadedirty")
    inst._fade:set(SCORCH_YELLOW_FRAMES + SCORCH_DELAY_FRAMES + SCORCH_FADE_FRAMES)

    inst:DoPeriodicTask(0, Scorch_OnUpdateFade)
    Scorch_OnFadeDirty(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", Scorch_OnFadeDirty)

        return inst
    end

    inst.Transform:SetRotation(math.random() * 360)
    inst.persists = false

    return inst
end

return Prefab("staff_starfall", fn, assets), Prefab("staff_starfall_projectile", fn_proj), Prefab("staff_starfall_explode", fn_fx1), Prefab("staff_starfall_trail", fn_fx2), Prefab("staff_starfall_scorch", fn_fx3)

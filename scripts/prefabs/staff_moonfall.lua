-- TODO: Damage and uses tuning
local assets = { Asset("ANIM", "anim/staffs.zip"), Asset("ANIM", "anim/swap_staffs.zip"),
    Asset("ANIM", "anim/lavaarena_hit_sparks_fx.zip"), Asset("ANIM", "anim/crab_king_shine.zip"),
    Asset("ANIM", "anim/explode.zip"), Asset("ANIM", "anim/lavaarena_player_teleport.zip") }


--keeping this code here if we want the death laser for something else later!!
--[[
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
            return
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
            return
        end

        for k, v in pairs(ents) do
            if k > 5 then break end

            if v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then
                v.components.combat:GetAttacked(inst.attacker, 2.5 * (0.25 + inst.intensity), nil, nil, { planar = 5 * (0.5 + inst.intensity) })
                if v.components.health ~= nil and not v.components.health:IsDead() then
                    v:AddDebuff("umdebuff_moonburn", "umdebuff_moonburn", 3, 0.00005)
                end
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
]]


-------------------------------------------------------------------------

local TARGET_ONEOF_TAGS = {}
local TARGET_NO_TAGS = { "INLIMBO", "player", "companion", "abigail", "wall", "dead", "bird", "notarget", "noattack", "invisible" }
local ABSORB_RANGE = 16


local function DoAttack(inst, owner)
    local x, y, z = owner.Transform:GetWorldPosition()
    local entities = TheSim:FindEntities(x, 0, z, ABSORB_RANGE, { "_combat", "_health" }, TARGET_NO_TAGS, nil)

    if #entities > 0 then
        for i = 1, 5 do
            local ent = entities[math.random(#entities)]
            if ent ~= nil and ent:IsValid() and not ent:IsInLimbo() and ent.components.combat ~= nil and ent.components.combat:CanBeAttacked(owner) then
                inst:DoTaskInTime(FRAMES * i * 5, function(inst)
                    if not ent.components.health:IsDead() then
                        local pt = inst:GetPosition()
                        local x, y, z = pt.x + math.random(-3, 3), pt.y, pt.z + math.random(-3, 3)

                        inst.fire_fx = SpawnPrefab("moonfall_flame")
                        inst.fire_fx.Transform:SetPosition(pt.x, pt.y, pt.z)
                        inst.fire_fx.entity:AddFollower()
                        inst.fire_fx.Follower:FollowSymbol(owner.GUID, "swap_object", 10, -180, 0)
                        inst.fire_fx.AnimState:SetFinalOffset(1)

                        inst.SoundEmitter:PlaySound("rifts/lunarthrall_bomb/throw")

                        SpawnPrefab("moonfall_proj_scorch").Transform:SetPosition(x, y, z) --not saving these as variables for memory optimization
                        SpawnPrefab("crab_king_shine").Transform:SetPosition(x, y, z)

                        local projectile = SpawnPrefab("moonfall_proj")
                        projectile.components.projectile.speed = 10
                        projectile.components.projectile:Throw(inst, ent, owner)
                        projectile.components.projectile.homing = false
                        projectile:DoTaskInTime(0.5, function(projectile)
                            projectile.components.projectile.speed = 40
                            local x, y, z = projectile.Transform:GetWorldPosition()
                            projectile.components.projectile:Throw(inst, ent, owner) --need to update speed!!
                            projectile.Transform:SetPosition(x, y, z)                --fix pos after throw
                            projectile.components.projectile.homing = true
                        end)
                        projectile.Transform:SetPosition(x, y, z)
                        projectile.Transform:SetRotation(math.random(360))
                    end
                end)
            end
        end
    end
end

local function OnStartChanneling(inst, user)
    if inst.attack_task then
        inst.attack_task:Cancel()
    end
    inst.attack_task = inst:DoPeriodicTask(1.5, DoAttack, nil, user)

    inst.components.burnable:Ignite()

    user.SoundEmitter:PlaySound("meta3/willow_lighter/lighter_absorb_LP", "channel_loop")
end

local function OnStopChanneling(inst, user)
    user.SoundEmitter:KillSound("channel_loop")
    user.SoundEmitter:PlaySound("meta3/willow_lighter/extinguisher_deactivate")

    inst.components.burnable:Extinguish()

    if inst.attack_task then
        inst.attack_task:Cancel()
        inst.attack_task = nil
    end
end

--------------------------------------------------------------------------

local function onequip(inst, owner)
    inst:AddComponent("channelcastable")
    inst.components.channelcastable:SetOnStartChannelingFn(OnStartChanneling)
    inst.components.channelcastable:SetOnStopChannelingFn(OnStopChanneling)

    owner.AnimState:OverrideSymbol("swap_object", "swap_staff_starfall", "staff_starfall")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:SetSymbolHue("swap_object", 0.5)
    owner.AnimState:SetSymbolSaturation("swap_object", 5)
end

local function onunequip(inst, owner)
    inst:DoTaskInTime(0, function(inst)
        inst:RemoveComponent("channelcastable")
    end)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:SetSymbolHue("swap_object", 1)
    owner.AnimState:SetSymbolSaturation("swap_object", 1)
    owner.AnimState:Show("ARM_normal")
end
local function onequiptomodel(inst, owner, from_ground)
    if inst.fires ~= nil then
        for i, fx in ipairs(inst.fires) do
            fx:Remove()
        end
        inst.fires = nil
    end

    inst.components.burnable:Extinguish()
end

local function onpocket(inst, owner)
    inst.components.burnable:Extinguish()
end

local function onattack(weapon, attacker, target)
    --target may be killed or removed in combat damage phase
end

local function onupdatefueledraining(inst)
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
    inst.components.fueled.rate =
        owner ~= nil and
        (owner.components.sheltered ~= nil and owner.components.sheltered.sheltered or owner.components.rainimmunity ~= nil) and
        1 or 1 + TUNING.LIGHTER_RAIN_RATE * TheWorld.state.precipitationrate
end

local function onisraining(inst, israining)
    if inst.components.fueled ~= nil then
        if israining then
            inst.components.fueled:SetUpdateFn(onupdatefueledraining)
            onupdatefueledraining(inst)
        else
            inst.components.fueled:SetUpdateFn()
            inst.components.fueled.rate = 1
        end
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        --when we burn out
        if inst.components.burnable ~= nil then
            inst.components.burnable:Extinguish()
        end
        local equippable = inst.components.equippable
        if equippable ~= nil and equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                    announce = "ANNOUNCE_TORCH_OUT",
                }
                inst:Remove()
                owner:PushEvent("itemranout", data)
                return
            end
        end
        inst:Remove()
    end
end

local function OnRemoveEntity(inst)

end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("meta3/willow_lighter/ember_absorb")
end

local tail_length = 5
local tail_speeds = {
    ["tail_5_2"] = .15,
    ["tail_5_3"] = .15,
    ["tail_5_4"] = .2,
    ["tail_5_5"] = .8,
    ["tail_5_6"] = 1,
    ["tail_5_7"] = 1
}
local thin_tail_speeds = { ["tail_5_8"] = 1, ["tail_5_9"] = .5 }

local function CreateTail(is_thin, color)
    local inst = CreateEntity()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.entity:SetCanSleep(false)
    inst.persists = false
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(color.r, color.g, color.b)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetRadius(1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(.1)

    inst.AnimState:SetBank("lavaarena_blowdart_attacks")
    inst.AnimState:SetBuild("lavaarena_blowdart_attacks")
    inst.AnimState:PlayAnimation(weighted_random_choice(thin_tail_speeds))
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetAddColour(color.r, color.g, color.b, 1)
    inst.AnimState:SetMultColour(color.r, color.g, color.b, 1)
    inst.AnimState:SetHue(color.h)

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function CreateThinTail(inst, color)
    local fade_value = not inst.entity:IsVisible() and 0 or inst._fade ~= nil and (tail_length - inst._fade:value() + 1) / tail_length or 1
    if fade_value > 0 then
        local tail_inst = CreateTail(inst.thin_tail_count > 0, color)
        tail_inst.Transform:SetPosition(inst.Transform:GetWorldPosition())
        tail_inst.Transform:SetRotation(inst.Transform:GetRotation())

        if fade_value < 1 then
            tail_inst.AnimState:SetTime(fade_value * tail_inst.AnimState:GetCurrentAnimationLength())
        end
        if inst.thin_tail_count > 0 then
            inst.thin_tail_count = inst.thin_tail_count - 1
        end
    end
end

local function fn_proj()
    local inst = CreateEntity()
    local r, g, b, h = math.random(), math.random(), math.random(), math.random()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Light:SetFalloff(1)
    inst.Light:SetColour(r, g, b)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetRadius(1)

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("lavaarena_blowdart_attacks")
    inst.AnimState:SetBuild("lavaarena_blowdart_attacks")
    inst.AnimState:PlayAnimation("attack_3", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(.1)

    inst:AddTag("projectile")

    inst.color = { r = r, g = g, b = b, h = h }
    inst.AnimState:SetAddColour(r, g, b, 1)
    inst.AnimState:SetMultColour(r, g, b, 1)
    inst.AnimState:SetHue(h)

    if not TheNet:IsDedicated() then
        inst.thin_tail_count = math.random(8, 16)
        inst:DoPeriodicTask(0, CreateThinTail, nil, { r = r, g = g, b = b, h = h })
    end

    inst._fade = net_tinybyte(inst.GUID, "blowdart_lava2_projectile_explosive._fade")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(30)
    inst.components.projectile:SetRange(20)
    inst.components.projectile:SetOnHitFn(
        function(inst, owner, target)
            local impactfx = SpawnPrefab("hitsparks_piercing_fx")
            impactfx:Setup(owner, target, inst, nil, false, 0.75)

            inst:Remove()
        end
    )

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.LIGHTER_DAMAGE * 1.5)
    inst.components.weapon:SetOnAttack(onattack)

    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetLaunchOffset(Vector3(-2, 1, 0))

    return inst
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

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("rangedweapon")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.LIGHTER_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)

    -----------------------------------
    inst:AddComponent("inventoryitem")
    -----------------------------------

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnPocket(onpocket)
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    -----------------------------------


    inst:AddComponent("inspectable")

    -----------------------------------

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil

    inst:AddComponent("fueled")
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(TUNING.LIGHTER_FUEL)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = false
    inst.components.fueled:SetTakeFuelFn(ontakefuel)


    inst:WatchWorldState("israining", onisraining)
    onisraining(inst, TheWorld.state.israining)

    MakeHauntableLaunch(inst)

    inst.OnRemoveEntity = OnRemoveEntity

    return inst
end

local SCORCH_COLOR_FRAMES = 20
local SCORCH_DELAY_FRAMES = 40
local SCORCH_FADE_FRAMES = 15

local function Scorch_OnFadeDirty(inst)
    -- V2C: hack alert: using SetHightlightColour to achieve something like OverrideAddColour
    --     (that function does not exist), because we know this FX can never be highlighted!
    if inst._fade:value() > SCORCH_FADE_FRAMES + SCORCH_DELAY_FRAMES then
        local k = (inst._fade:value() - SCORCH_FADE_FRAMES - SCORCH_DELAY_FRAMES) / SCORCH_COLOR_FRAMES
        inst.AnimState:OverrideMultColour(1, 1, 1, 1)
        inst.AnimState:SetHighlightColour(k, k, k, 0)
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

local function fn_scorch()
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
    inst._fade:set(SCORCH_COLOR_FRAMES + SCORCH_DELAY_FRAMES + SCORCH_FADE_FRAMES)

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

local function fn_flame()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("lavaarena_player_teleport")
    inst.AnimState:SetBank("lavaarena_player_teleport")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetAddColour(math.random(), math.random(), math.random(), 1)
    inst.AnimState:SetMultColour(math.random(), math.random(), math.random(), 1)
    inst.AnimState:SetHue(math.random())
    inst.AnimState:SetDeltaTimeMultiplier(2)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(.1)

    inst.Transform:SetScale(0.25, 0.25, 0.25)

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("staff_moonfall", fn, assets), Prefab("moonfall_proj", fn_proj, assets, prefabs), Prefab("moonfall_proj_scorch", fn_scorch), Prefab("moonfall_flame", fn_flame, assets)

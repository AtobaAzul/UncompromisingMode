--------------------------------------------------------------------------

local brain = require("brains/beeguardbrain")

--------------------------------------------------------------------------

local normalsounds =
{
    attack = "dontstarve/bee/killerbee_attack",
    --attack = "dontstarve/creatures/together/bee_queen/beeguard/attack",
    buzz = "dontstarve/bee/bee_fly_LP",
    hit = "dontstarve/creatures/together/bee_queen/beeguard/hurt",
    death = "dontstarve/creatures/together/bee_queen/beeguard/death",
}

local poofysounds =
{
    attack = "dontstarve/bee/killerbee_attack",
    --attack = "dontstarve/creatures/together/bee_queen/beeguard/attack",
    buzz = "dontstarve/bee/killerbee_fly_LP",
    hit = "dontstarve/creatures/together/bee_queen/beeguard/hurt",
    death = "dontstarve/creatures/together/bee_queen/beeguard/death",
}

local function EnableBuzz(inst, enable)
    if enable then
        if not inst.buzzing then
            inst.buzzing = true
            if not inst:IsAsleep() then
                inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
            end
        end
    elseif inst.buzzing then
        inst.buzzing = false
        inst.SoundEmitter:KillSound("buzz")
    end
end

local function OnEntityWake(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
        inst._sleeptask = nil
    end

    if inst.buzzing then
        inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
    end
end

local function OnEntitySleep(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
    end
    inst._sleeptask = not inst.components.health:IsDead() and inst:DoTaskInTime(10, inst.Remove) or nil

    inst.SoundEmitter:KillSound("buzz")
end

--------------------------------------------------------------------------


local function RetargetFn(inst)
    local targetDist = 5
    return FindEntity(inst, targetDist,
        function(guy)
            if inst.components.combat:CanTarget(guy) then
                return not (guy:HasTag("bee") or guy:HasTag("beehive"))
            end
        end)
end

local function GetQueen(inst)
    return inst.components.entitytracker:GetEntity("queen") or inst._friendref or nil
end

local function KeepTargetFn(inst, target)
    return (inst.components.combat:CanTarget(target) and
        inst:IsNear(target, 5))
end

local function bonus_damage_via_allergy(inst, target, damage, weapon)
    return (target:HasTag("allergictobees") and TUNING.BEE_ALLERGY_EXTRADAMAGE) or 0
end

local function CanShareTarget(dude)
    return dude:HasTag("bee") and not (dude:IsInLimbo() or dude.components.health:IsDead() or dude:HasTag("epic"))
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 20, CanShareTarget, 6)
end

local function OnAttackOther(inst, data)
    if data.target ~= nil and data.target.components.inventory ~= nil then
        for k, eslot in pairs(EQUIPSLOTS) do
            local equip = data.target.components.inventory:GetEquippedItem(eslot)
            if equip ~= nil and equip.components.armor ~= nil and equip.components.armor.tags ~= nil then
                for i, tag in ipairs(equip.components.armor.tags) do
                    if tag == "bee" then
                        inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.OFTEN)
                        return
                    end
                end
            end
        end
    end
    inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.ALWAYS)
end

--------------------------------------------------------------------------

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

--------------------------------------------------------------------------
local function SlovvDeath(inst) --Slovv death, they just fall dovvn...
    if inst.components.health and not inst.components.health:IsDead() then
        local x, y, z = inst.Transform:GetWorldPosition()
        inst:RemoveComponent("linearcircler")
        inst.Transform:SetPosition(x, y, z)
        inst.components.health:Kill()
        inst:DoTaskInTime(0, function(inst)
            inst.AnimState:PlayAnimation("sleep_pre", false)
        end)
    end
end

local function Honey(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab(inst.queen ~= nil and inst.queen.prefab == "cherry_beequeen" and "cherry_honey_trail" or
        "honey_trail")
    if fx.prefab == "cherry_honey_trail" then
        fx.slowness = inst.queen ~= nil and fx.slowness ~= nil and fx.slowness + inst.queen.flowerbuffs.honeyslowness or
            fx.slowness
    end
    fx.Transform:SetPosition(x, 0, z)
    fx:SetVariation(math.random(1, 7), GetRandomMinMax(1, 1.3), math.random(45, 60))
end

local function MortarAttack(inst)
    if not inst.sg:HasStateTag("mortar") then
        local target = FindEntity(inst, 40 ^ 2, nil, { "player" }, { "playerghost", "bee", "smallcreature", "structure" })
        if not target then
            target = FindEntity(inst, 40 ^ 2, nil, { "_combat" }, { "playerghost", "bee", "smallcreature", "structure" })
        end
        if target then
            inst.stabtarget = target
            if inst.components.linearcircler then
                inst:RemoveComponent("linearcircler")
            end
            inst.sg:GoToState("flyup")
        else
            inst:DoTaskInTime(math.random(1, 3), MortarAttack)
        end
    end
end

local function Shoot(inst)
    if not inst.target then
        local queen = inst.components.entitytracker:GetEntity("queen")
        if not inst.circle and queen and queen.prioritytarget and queen.prioritytarget.components.health and
            not queen.prioritytarget.components.health:IsDead() then
            inst.target = queen.prioritytarget
        end
    end
    if inst.target then
        inst.AnimState:Hide("stinger")
        local x, y, z = inst.Transform:GetWorldPosition()
        local stingerattack = SpawnPrefab("um_beestinger_projectile")
        stingerattack.Transform:SetPosition(x, y, z)
        stingerattack.anim = inst.anim
        if not inst.pos2 then
            stingerattack.components.projectile:Throw(inst, inst.target, inst)
        else
            local target = SpawnPrefab("um_beeguard_shooter_target")
            target.Transform:SetPosition(inst.pos2.x, inst.pos2.y, inst.pos2.z)
            stingerattack.components.projectile:Throw(inst, target, inst)
            target:DoTaskInTime(0, function(target) target:Remove() end)
        end

        if inst.components.health and not inst.components.health:IsDead() then
            inst.components.health:Kill()
        end
        if inst.components.linearcircler then
            local x, y, z = inst.Transform:GetWorldPosition()
            inst:RemoveComponent("linearcircler")
            inst.Transform:SetPosition(x, y, z)
        end
    elseif inst.components.linearcircler then
        if inst.components.health and not inst.components.health:IsDead() then
            local x, y, z = inst.Transform:GetWorldPosition()
            inst:RemoveComponent("linearcircler")
            inst.Transform:SetPosition(x, y, z)
            inst.components.health:Kill()
            inst:DoTaskInTime(0, function(inst)
                inst.AnimState:PlayAnimation("sleep_pre", false)
            end)
        end
    end
end

local function CircleFormation(inst)
    if inst.target then
        inst.circle = true
        inst.components.linearcircler:SetCircleTarget(inst.target)
        inst.components.linearcircler.grounded = true
        inst.components.linearcircler:Start()
        inst.components.linearcircler.randAng = inst.count * 0.125
        inst.components.linearcircler.clockwise = false
        inst.components.linearcircler.distance_limit = 3
        inst.components.linearcircler.distance = 8
        inst.components.linearcircler.setspeed = 0
        inst.components.linearcircler.freeface = true
        inst.components.timer:StartTimer("natural_death", inst.time)
    elseif inst.components.linearcircler then
        if inst.components.health and not inst.components.health:IsDead() then
            local x, y, z = inst.Transform:GetWorldPosition()
            inst:RemoveComponent("linearcircler")
            inst.Transform:SetPosition(x, y, z)
            inst.components.health:Kill()
            inst:DoTaskInTime(0, function(inst)
                inst.AnimState:PlayAnimation("sleep_pre", false)
            end)
        end
    end
end

local function fnmain(bee, build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()
    inst.Transform:SetScale(1.4, 1.4, 1.4)

    inst.DynamicShadow:SetSize(1.2, .75)

    MakeFlyingCharacterPhysics(inst, 0.5, .75)

    inst.AnimState:SetBank("bee_guard")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("insect")
    inst:AddTag("bee")
    inst:AddTag("monster")
    --inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("soulless") --Overload for vvortox..

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot("stinger", 0.01)

    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.walkspeed = TUNING.BEEGUARD_SPEED
    inst.components.locomotor.pathcaps = { allowocean = true }

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BEEGUARD_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.BEEGUARD_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.BEEGUARD_ATTACK_PERIOD)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(1.5 * TUNING.BEEGUARD_ATTACK_RANGE)
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat.hiteffectsymbol = "mane"
    inst.components.combat.bonusdamagefn = bonus_damage_via_allergy

    inst:AddComponent("entitytracker")
    inst:AddComponent("knownlocations")

    MakeSmallBurnableCharacter(inst, "mane")
    MakeSmallFreezableCharacter(inst, "mane")
    inst.components.freezable:SetResistance(40)
    inst.components.freezable.diminishingreturns = true

    inst:SetStateGraph("SGbeeguard")
    inst:SetBrain(brain)

    MakeHauntablePanic(inst)

    inst.hit_recovery = 1

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)

    inst:AddComponent("timer")

    inst.buzzing = true
    inst.sounds = normalsounds
    inst.GetQueen = GetQueen
    inst.EnableBuzz = EnableBuzz
    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
    inst:AddTag("companion")

    if bee == "blocker" then
        inst.components.health:SetMaxHealth(15 * TUNING.BEEGUARD_HEALTH)
        inst.Transform:SetScale(1.6, 1.6, 1.6)

        inst:ListenForEvent("timerdone", SlovvDeath)
    end
    if bee == "seeker" then
        inst.components.health:SetMaxHealth(0.5 * TUNING.BEEGUARD_HEALTH)
        inst.Transform:SetScale(1.2, 1.2, 1.2)
        inst.MortarAttack = MortarAttack
        inst:DoTaskInTime(math.random(1, 3), MortarAttack)
        inst.dohoney = Honey

    end
    if bee == "shooter" then
        inst.components.health:SetMaxHealth(0.5 * TUNING.BEEGUARD_HEALTH)
        inst.Transform:SetScale(1.2, 1.2, 1.2)
        inst.Shoot = Shoot
        inst.CircleFormation = CircleFormation
        inst:ListenForEvent("timerdone", function(inst)
            inst.sg:GoToState("shoot_pre")
        end)
    end
    inst:AddComponent("linearcircler")
    inst.persists = false
    inst:DoTaskInTime(0, function(inst) inst.sg:GoToState("spawnin") end)

    return inst
end

local function fnblocker()
    return fnmain("blocker", "hivehead_bee_guard")
end

local function fnseeker()
    return fnmain("seeker", "fatbee_guard_build")
end

local function fnshooter()
    return fnmain("shooter", "bulletbee_guard")
end

local function fntarget()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("combat")
    return inst
end

local function honeyexplosion()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("treegrowthsolution")
    inst.AnimState:SetBuild("um_goo_honey")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.Transform:SetScale(1.5, 1.5, 1.5)
    inst.AnimState:PlayAnimation("use", false)
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
    inst.persists = false

    return inst
end

return Prefab("um_beeguard_blocker", fnblocker),
    Prefab("um_beeguard_seeker", fnseeker),
    Prefab("um_beeguard_shooter", fnshooter),
    Prefab("honeyexplosion", honeyexplosion),
    Prefab("um_beeguard_shooter_target", fntarget)

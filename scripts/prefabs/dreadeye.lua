local prefabs =
{
    "nightmarefuel",
}

local assets =
{
    Asset("ANIM", "anim/dreadeye.zip"), -----------------------------------------
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature2/die",
    idle = "dontstarve/sanity/creature2/idle",
    taunt = "dontstarve/sanity/creature2/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}

local brain = require("brains/shadowcreaturebrain") -----------------------------------------

--local original_tile_type = TheWorld.Map:GetTileAtPoint(pt:Get())
--local function dreadeyetimer(inst)
--inst.disguise_cd = inst.disguise_cd - 1
--end

local function retargetfn(inst)
    local maxrangesq = TUNING.SHADOWCREATURE_TARGET_DIST * TUNING.SHADOWCREATURE_TARGET_DIST
    local rangesq, rangesq1, rangesq2 = maxrangesq, math.huge, math.huge
    local target1, target2 = nil, nil
    for i, v in ipairs(AllPlayers) do
        if v.components.sanity:IsInsane() and not v:HasTag("playerghost") then
            local distsq = v:GetDistanceSqToInst(inst)
            if distsq < rangesq then
                if inst.components.shadowsubmissive:TargetHasDominance(v) then
                    if distsq < rangesq1 and inst.components.combat:CanTarget(v) then
                        target1 = v
                        rangesq1 = distsq
                        rangesq = math.max(rangesq1, rangesq2)
                    end
                elseif distsq < rangesq2 and inst.components.combat:CanTarget(v) then
                    target2 = v
                    rangesq2 = distsq
                    rangesq = math.max(rangesq1, rangesq2)
                end
            end
        end
    end

    if target1 ~= nil and rangesq1 <= math.max(rangesq2, maxrangesq * .25) then
        --Targets with shadow dominance have higher priority within half targeting range
        --Force target switch if current target does not have shadow dominance
        return target1, not inst.components.shadowsubmissive:TargetHasDominance(inst.components.combat.target)
    end
    return target2
end

local function NotifyBrainOfTarget(inst, target)
    if inst.brain ~= nil and inst.brain.SetTarget ~= nil then
        inst.brain:SetTarget(target)
    end
end

local function onkilledbyother(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
        attacker.components.sanity:DoDelta(20)
    end
end

local function CalcSanityAura(inst, observer)
    return inst.components.combat:HasTarget()
        and observer.components.sanity:IsCrazy()
        and -TUNING.SANITYAURA_LARGE
        or 0
end

local function ShareTargetFn(dude)
    return dude:HasTag("shadowcreature") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 1)
end

local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

local function OnDeath(inst, data)
    if data ~= nil and data.afflicter ~= nil and data.afflicter:HasTag("crazy") then
        --max one nightmarefuel if killed by a crazy NPC (e.g. Bernie)
        inst.components.lootdropper:SetLoot({ "nightmarefuel" })
        inst.components.lootdropper:SetChanceLootTable(nil)
    end
end

local function OnSave(inst, data)
    data.atkcount = inst.atkcount or nil
end

local function OnPreLoad(inst, data)
    if data ~= nil then
        if data.atkcount then
            inst.atkcount = data.atkcount
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 6, 1)
    RemovePhysicsColliders(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --inst.Physics:CollidesWith(COLLISION.WORLD)

    --inst.Transform:SetScale(1.12, 1.12, 1.12)
    --inst.Transform:SetFourFaced()

    inst:AddTag("shadowcreature")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")
    inst:AddTag("notraptrigger")

    inst.AnimState:SetBank("dreadeye")
    inst.AnimState:SetBuild("dreadeye")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    --inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst:AddComponent("transparentonsanity_dreadeye")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.atkcount = 3
    --inst.disguise_form = nil
    --inst.disguise_cd = -1

    inst:AddComponent("uncompromising_shadowfollower")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.DSTU.DREADEYE_SPEED
    --inst.components.locomotor.pathcaps = { allowocean = true }
    inst.sounds = sounds
    inst:SetStateGraph("SGdreadeye")

    inst:SetBrain(brain)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health.nofadeout = true

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.DSTU.DREADEYE_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.DSTU.DREADEYE_RANGE_1, TUNING.DSTU.DREADEYE_RANGE_2)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat:SetRetargetFunction(3, retargetfn)

    inst.components.health:SetMaxHealth(TUNING.DSTU.DREADEYE_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.DSTU.DREADEYE_DAMAGE)

    inst:AddComponent("shadowsubmissive")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "nightmarefuel" })

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
    inst:ListenForEvent("death", OnDeath)

    --inst.OnSave = OnSave
    --inst.OnPreLoad = OnPreLoad

    --inst:DoPeriodicTask(FRAMES, function() dreadeyetimer(inst) end)

    inst.persists = false

    return inst
end


return Prefab("dreadeye", fn, assets)
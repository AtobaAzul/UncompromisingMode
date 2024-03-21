local assets =
{
    Asset("ANIM", "anim/slingshot.zip"),
    Asset("ANIM", "anim/swap_slingshot.zip"),
}

local prefabs =
{
    "slingshotammo_rock_proj",
}

local PROJECTILE_DELAY = 2 * FRAMES

local function OnEquip(inst, owner)
    if not (owner:HasTag("vetcurse") or owner:HasTag("royaljellymaker")) then
        inst:DoTaskInTime(0, function(inst, owner)
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
            local tool = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if tool ~= nil and owner ~= nil then
                owner.components.inventory:Unequip(EQUIPSLOTS.HANDS)
                owner.components.inventory:DropItem(tool)
                owner.components.inventory:GiveItem(inst)
                owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")

                if owner.sg ~= nil then
                    owner.sg:GoToState("hit")
                end
            end
        end)
    else
        owner.AnimState:OverrideSymbol("swap_object", inst.swap, inst.swap)
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        if inst.components.container ~= nil then
            inst.components.container:Open(owner)
        end
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function OnProjectileLaunched(inst, attacker, target)
    if inst.components.container ~= nil then
        local ammo_stack = inst.components.container:GetItemInSlot(1)
        local item = inst.components.container:RemoveItem(ammo_stack, false)
        if item ~= nil then
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")

            item:Remove()
        end
    end
end

local function OnAmmoLoaded(inst, data)
    if data ~= nil and data.item ~= nil then
        if data.item.components.perishable ~= nil then
            data.item.components.perishable:StopPerishing()
        end
    end

    if inst.components.weapon ~= nil then
        if data ~= nil and data.item ~= nil then
			local beecheck = inst.beetype

            if data.item.prefab ~= beecheck then
                local stacksize = data.item.components.stackable:StackSize()

                data.item:Remove()

                for i = 1, stacksize do
                    local bulletbee = SpawnPrefab(beecheck)
                    inst.components.container:GiveItem(bulletbee)
                end
            end

            inst.components.weapon:SetProjectile("um_" .. beecheck .. "_proj")
        end
    end
end

local function OnAmmoUnloaded(inst, data)
    if data ~= nil and data.prev_item ~= nil then
        if data.prev_item.components.perishable ~= nil then
            data.prev_item.components.perishable:StartPerishing()
        end
    end

    if inst.components.weapon ~= nil then
        inst.components.weapon:SetProjectile(nil)
    end
end

local floater_swap_data = { sym_build = "swap_um_beegun" }

local function ReticuleTargetFn(inst)
    return Vector3(inst.entity:LocalToWorldSpace(6.5, 0, 0))
end

local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end

local function collectbees(inst, target, pos)
    local owner = inst.components.inventoryitem.owner
    local ownerpos = owner ~= nil and owner:GetPosition()
    local currentstacks = 0
    local currentitem = inst.components.container:GetItemInSlot(1)

    if currentitem ~= nil then
        currentstacks = currentitem.components.stackable:StackSize()
    end

    if owner ~= nil then
        if pos ~= nil then
            local findbees = TheSim:FindEntities(pos.x, 0, pos.z, 8, { "bee" })
            if findbees ~= nil then
                for i, v in pairs(findbees) do
                    if i + currentstacks > 20 then
                        break
                    end

                    if v ~= nil and not v:IsInLimbo() and v:IsValid() and v.components.inventoryitem and
                        not v.components.health:IsDead() then
                        if inst.components.container ~= nil then
                            local beeball = SpawnPrefab("um_" .. v.prefab .. "_ball")
                            beeball.Transform:SetPosition(v.Transform:GetWorldPosition())
                            beeball.components.complexprojectile:Launch(ownerpos, owner, owner)
                            beeball.beegun = inst

                            v:Remove()
                            --inst.components.container:GiveItem(v)
                        end
                    end
                end
            end
        elseif target ~= nil then
            local x, y, z = target.Transform:GetWorldPosition()

            local findbees = TheSim:FindEntities(x, 0, z, 8, { "bee" })
            if findbees ~= nil then
                for i, v in pairs(findbees) do
                    if i + currentstacks > 20 then
                        break
                    end

                    if v ~= nil and not v:IsInLimbo() and v:IsValid() and v.components.inventoryitem and
                        not v.components.health:IsDead() then
                        if inst.components.container ~= nil then
                            local beeball = SpawnPrefab("um_" .. v.prefab .. "_ball")
                            beeball.Transform:SetPosition(v.Transform:GetWorldPosition())
                            beeball.components.complexprojectile:Launch(ownerpos, owner, owner)
                            beeball.beegun = inst

                            v:Remove()
                            --inst.components.container:GiveItem(v)
                        end
                    end
                end
            end
        end
    end
end

local function can_cast_fn(doer, target, pos)
    if doer:HasTag("vetcurse") then
        return true
    else
        return false
    end
end

local function onattack(inst, attacker, target)
	if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() and attacker:HasTag("vetcurse") then
		if target.components.health ~= nil and not target.components.health:IsDead() and target.components.combat ~= nil then
			target.components.combat:GetAttacked(attacker, 10, nil)
		end
	end
end

local function fn(anim, name, swap, beetype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_beegun")
    inst.AnimState:SetBuild("um_beegun")
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("rangedweapon")
    inst:AddTag("beegun")
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("vetcurse_item")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --inst.projectiledelay = PROJECTILE_DELAY

    MakeInventoryFloatable(inst, "med", 0.075, { 0.5, 0.4, 0.5 }, true, -7, floater_swap_data)

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true
    inst.components.reticule.mouseenabled = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("um_beegun")
        end
        return inst
    end

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.AMULET_SHADOW_LEVEL)

    inst.beetype = beetype
	inst.swap = swap

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
	inst.components.weapon:SetOnAttack(onattack)
    inst.components.weapon:SetRange(TUNING.SLINGSHOT_DISTANCE, TUNING.SLINGSHOT_DISTANCE_MAX)
    inst.components.weapon:SetOnProjectileLaunched(OnProjectileLaunched)
    inst.components.weapon:SetProjectile(nil)
    inst.components.weapon:SetProjectileOffset(1)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("um_beegun")
    inst.components.container.canbeopened = false
    inst:ListenForEvent("itemget", OnAmmoLoaded)
    inst:ListenForEvent("itemlose", OnAmmoUnloaded)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(collectbees)
    inst.components.spellcaster:SetCanCastFn(can_cast_fn)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.canuseonpoint = true

    --MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    --MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

local function um_gun()
    local inst = fn("idle", "um_beegun", "swap_um_beegun", "bulletbee")

    return inst
end

local function cherry_gun()
    local inst = fn("cherryidle", "um_beegun_cherry", "swap_um_beegun_cherry", "cherrybulletbee")

    return inst
end

local function onhit(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx ~= nil and target.components.combat then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        if attacker ~= nil and attacker:IsValid() then
            impactfx:FacePoint(attacker.Transform:GetWorldPosition())
        end
    end


    local bee = SpawnPrefab(inst.beetype)
    bee.Transform:SetPosition(inst.Transform:GetWorldPosition())

    if target ~= nil then
        bee.components.combat:SuggestTarget(target)
    end

    inst:Remove()
end

local function pipethrown(inst)
    inst.SoundEmitter:PlaySound(inst.sound)
    inst.AnimState:PlayAnimation(inst.anim)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function bullet(beetype, anim, ischerry)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_beegun_dart")
    inst.AnimState:SetBuild("um_beegun_dart")
    inst.AnimState:PlayAnimation(anim)
    inst.Transform:SetScale(1.2, 1.2, 1.2)
    inst.Transform:SetFourFaced()

    --inst:AddTag("blowdart")
    inst:AddTag("sharp")

    --inst:AddTag("weapon")

    inst:AddTag("projectile")
    inst:AddTag("vetcurse_item")

    RemovePhysicsColliders(inst)

    --MakeInventoryFloatable(inst, "small", 0.05, {0.75, 0.5, 0.75})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.beetype = beetype
    inst.sound = "dontstarve/bee/killerbee_attack"
    inst.anim = anim

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(10)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetOnHitFn(onhit)
    inst.components.projectile:SetOnThrownFn(pipethrown)
    inst.components.projectile:SetLaunchOffset(Vector3(.5, .5, 0))
    --inst.components.projectile:SetLaunchOffset(Vector3(.5, 1.5, 0))
    inst.components.projectile:SetHitDist(math.sqrt(5))
    -------

    --inst:AddComponent("inspectable")

    --inst:AddComponent("inventoryitem")

    return inst
end

local function bulletproj()
    local inst = bullet("bulletbee", "beedart_green", false)

    return inst
end

local function cherryproj()
    local inst = bullet("cherrybulletbee", "beedart_cherry", true)

    return inst
end

local function OnHitBall(inst, attacker, target)
    if inst.beegun ~= nil and inst.beegun:IsValid() then
        local owner = inst.beegun.components.inventoryitem.owner
        local bulletbee = SpawnPrefab(inst.beegun.beetype)

        inst.beegun.components.container:GiveItem(bulletbee)

        local beefx = SpawnPrefab("bee_poof_small")

        if owner ~= nil then
            beefx.entity:SetParent(owner.entity)
            beefx.entity:AddFollower()
            beefx.Follower:FollowSymbol(owner.GUID, "swap_object", 30, 0, 0.1)
        else
            beefx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end


    else
        SpawnPrefab(inst.beetype).Transform:SetPosition(inst.Transform:GetWorldPosition())
    end

    inst:Remove()
end

local function onthrown_ball(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:PlayAnimation(inst.anim .. "spin_loop", true)
    inst.SoundEmitter:PlaySound(inst.sound)

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()

    inst.Physics:SetCapsule(0.02, 0.02)

    inst.Physics:SetCollisionCallback(nil)
end

local function commonball(anim, beetype, sound, ischerry)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("um_beegun_ball")
    inst.AnimState:SetBuild("um_beegun_ball")
    inst.AnimState:PlayAnimation(anim .. "spin_loop")
    inst.Transform:SetFourFaced()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.beetype = beetype
    inst.sound = sound
    inst.anim = anim
    inst.ischerry = ischerry

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(25)
    inst.components.complexprojectile:SetGravity(-30)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown_ball)
    inst.components.complexprojectile:SetOnHit(OnHitBall)
    inst.components.complexprojectile.usehigharc = true

    inst.persists = false

    inst:AddComponent("locomotor")

    inst:DoTaskInTime(5, inst.Remove)

    return inst
end

local function yellowball()
    local inst = commonball("yellow", "bee", "dontstarve/bee/bee_attack", false)

    return inst
end

local function redball()
    local inst = commonball("red", "killerbee", "dontstarve/bee/killerbee_attack", false)

    return inst
end

local function greenball()
    local inst = commonball("bullet", "bulletbee", "dontstarve/bee/killerbee_attack", false)

    return inst
end

local function cherryball()
    local inst = commonball("cherry", "cherrybulletbee", "dontstarve/bee/killerbee_attack", true)

    return inst
end

local beecommon = require "brains/beecommon"

local workersounds =
{
    takeoff = "dontstarve/bee/killerbee_takeoff",
    attack = "dontstarve/bee/killerbee_attack",
    buzz = "dontstarve/bee/killerbee_fly_LP",
    hit = "dontstarve/bee/killerbee_hurt",
    death = "dontstarve/bee/killerbee_death",
}

local function OnWorked(inst, worker)
    inst.components.health:Kill()
end

local function bonus_damage_via_allergy(inst, target, damage, weapon)
    return (target:HasTag("allergictobees") and TUNING.BEE_ALLERGY_EXTRADAMAGE) or 0
end

local function OnDropped(inst)
    if inst.buzzing and not (inst:IsAsleep() or inst.SoundEmitter:PlayingSound("buzz")) then
        inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
    end
    inst.sg:GoToState("catchbreath")
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.brain ~= nil then
        inst.brain:Start()
    end
    if inst.sg ~= nil then
        inst.sg:Start()
    end
    if inst.components.stackable ~= nil and inst.components.stackable:IsStack() then
        local x, y, z = inst.Transform:GetWorldPosition()
        while inst.components.stackable:IsStack() do
            local item = inst.components.stackable:Get()
            if item ~= nil then
                if item.components.inventoryitem ~= nil then
                    item.components.inventoryitem:OnDropped()
                end
                item.Physics:Teleport(x, y, z)
            end
        end
    end
end

local function OnPickedUp(inst)
    inst.SoundEmitter:KillSound("buzz")
    inst.SoundEmitter:KillAllSounds()

    inst.sg:GoToState("idle")
end

local function EnableBuzz(inst, enable)
    if enable then
        if not inst.buzzing then
            inst.buzzing = true
            if not (inst.components.inventoryitem:IsHeld() or inst:IsAsleep() or inst.SoundEmitter:PlayingSound("buzz")) then
                inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
            end
        end
    elseif inst.buzzing then
        inst.buzzing = false
        inst.SoundEmitter:KillSound("buzz")
    end
end

local function OnWake(inst)
    if inst.buzzing and not (inst.components.inventoryitem:IsHeld() or inst.SoundEmitter:PlayingSound("buzz")) then
        inst.SoundEmitter:PlaySound(inst.sounds.buzz, "buzz")
    end
end

local function OnSleep(inst)
    inst.SoundEmitter:KillSound("buzz")
end

local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_CANT_TAGS = { "insect", "INLIMBO", "player", "abigail", "companion" }
local RETARGET_ONEOF_TAGS = { "character", "animal", "monster" }
local function BeeRetarget(inst)
    return FindEntity(inst, SpringCombatMod(8),
        function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        RETARGET_MUST_TAGS,
        RETARGET_CANT_TAGS,
        RETARGET_ONEOF_TAGS)
end

local workerbrain = require("brains/bulletbeebrain")

local function NoTargetWillKillMe(inst)
    if inst.components.combat.laststartattacktime ~= nil and inst.components.combat.laststartattacktime > 15 and
        not inst.components.inventoryitem:IsHeld() and not inst.components.combat:HasTarget() then
        inst.components.combat:GetAttacked(nil, 1)
    end
end

local function SpawnFx(inst, target)
    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("cherry_beepoison_fx")
    local theta = math.random() * 2 * PI
    local pt = inst:GetPosition()
    local radius = math.random(-1, 1)
    local rdm = 0.75 + math.random()
    local offset = FindWalkableOffset(pt, theta, radius, 12, false)
    if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.z = pt.z + offset.z
    end
    fx.Transform:SetScale(rdm, rdm, rdm)
    fx.Transform:SetPosition(pt.x, math.random() + 1, pt.z)
    if target ~= nil and target.sg ~= nil and not target.sg:HasStateTag("invisible") then
        inst:DoTaskInTime(math.random() * 2, SpawnFx, target)
    end
end

local function CherryPoison(inst, other)
    if other ~= nil and other.components.health ~= nil and not other:HasTag("insect") then
        if other.fake_poison_stacks == nil then
            other.fake_poison_stacks = 0
        end
        other.fake_poison_stacks = other.fake_poison_stacks + 1

        if other.fake_cherry_poison_task == nil then
            other.fake_cherry_poison_task = other:DoPeriodicTask(1, function(inst)
                if inst.components.health ~= nil then
                    inst.components.health:DoDelta(-other.fake_poison_stacks)
                    SpawnFx(inst)
                end
            end)
        end

        if other.fake_cherry_poison_end_task ~= nil then
            other.fake_cherry_poison_end_task:Cancel()
            other.fake_cherry_poison_end_task = nil
        end

        other.fake_cherry_poison_end_task = other:DoTaskInTime(10, function(inst)
            if inst.fake_cherry_poison_task ~= nil then
                inst.fake_cherry_poison_task:Cancel()
                inst.fake_cherry_poison_task = nil
            end
        end)
    end
end

local function bulletfn(ischerry)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeFlyingCharacterPhysics(inst, 1, .5)

    inst.DynamicShadow:SetSize(.8, .5)
    inst.Transform:SetFourFaced()

    inst:AddTag("bee")
    inst:AddTag("bulletbee")
    inst:AddTag("insect")
    inst:AddTag("smallcreature")
    inst:AddTag("cattoyairborne")
    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("scarytoprey")
    inst:AddTag("noauradamage")
    inst:AddTag("soulless")
    inst:AddTag("noember")

    inst.AnimState:SetBank("bee")
	
    if ischerry then
        inst.AnimState:SetBuild("cherrybee_build")
    else
        inst.AnimState:SetBuild("bulletbee_build")
    end
	
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetRayTestOnBB(true)

    inst.Transform:SetScale(.9, .9, .9)

    MakeInventoryFloatable(inst)

    MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 12
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbee")

    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
	
    if ischerry then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/cherrybulletbee.xml"
	else
		inst.components.inventoryitem.atlasname = "images/inventoryimages/bulletbee.xml"
	end
	
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem.pushlandedevents = false

    ------------------
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    MakeSmallBurnableCharacter(inst, "body", Vector3(0, -1, 1))
    MakeTinyFreezableCharacter(inst, "body", Vector3(0, -1, 1))

    ------------------

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(10)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.BEE_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.BEE_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.BEE_ATTACK_RANGE)
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.RARELY)
    inst.components.combat.bonusdamagefn = bonus_damage_via_allergy
    inst.components.combat:SetRetargetFunction(2, BeeRetarget)

    if ischerry then
        inst.components.combat.onhitotherfn = CherryPoison
	else
		inst.components.combat:SetAttackPeriod(TUNING.BEE_ATTACK_PERIOD / 2)
    end

    ------------------

    inst:AddComponent("sleeper")
    ------------------

    inst:AddComponent("knownlocations")

    ------------------

    inst:AddComponent("inspectable")

    ------------------

    inst:AddComponent("tradable")

    inst:ListenForEvent("attacked", beecommon.OnAttacked)
    inst:ListenForEvent("worked", beecommon.OnWorked)

    MakeFeedableSmallLivestock(inst, 30, OnPickedUp, OnDropped)

    inst.sounds = workersounds
    inst:SetBrain(workerbrain)

    inst:DoPeriodicTask(1, NoTargetWillKillMe)

    inst.buzzing = true
    inst.EnableBuzz = EnableBuzz
    inst.OnEntityWake = OnWake
    inst.OnEntitySleep = OnSleep
    MakeHauntablePanic(inst)

    return inst
end

local function bulletbee()
    local inst = bulletfn(false)
	
    return inst
end

local function cherrybee()
    local inst = bulletfn(true)

    return inst
end

return Prefab("um_beegun", um_gun, assets, prefabs),
    Prefab("um_beegun_cherry", cherry_gun, assets, prefabs),
    Prefab("um_bulletbee_proj", bulletproj, assets, prefabs),
    Prefab("um_cherrybulletbee_proj", cherryproj, assets, prefabs),
    Prefab("um_bee_ball", yellowball, assets, prefabs),
    Prefab("um_killerbee_ball", redball, assets, prefabs),
    Prefab("um_bulletbee_ball", greenball, assets, prefabs),
    Prefab("um_cherry_bee_ball", cherryball, assets, prefabs),
    Prefab("um_cherrybulletbee_ball", cherryball, assets, prefabs),
    Prefab("bulletbee", bulletbee),
    Prefab("cherrybulletbee", cherrybee)

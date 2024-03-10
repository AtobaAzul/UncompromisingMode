local assets = { Asset("ANIM", "anim/wixieammo.zip") }

local assets_firecrackers = { Asset("ANIM", "anim/firecrackers.zip") }

local prefabs_firecrackers = { "explode_firecrackers" }

local AURA_EXCLUDE_TAGS = { "noclaustrophobia", "rabbit", "playerghost", "abigail", "companion", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible" }

if not TheNet:GetPVPEnabled() then
    table.insert(AURA_EXCLUDE_TAGS, "player")
end

-- temp aggro system for the slingshots
local function no_aggro(attacker, target)
    local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
    return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4 and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function DealDamage(inst, attacker, target, salty)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
        inst.finaldamage = (inst.damage * (1 + (inst.powerlevel / 2))) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1)

        if salty ~= nil and salty and target.components.health ~= nil then
            inst.finaldamage = inst.finaldamage / target.components.health:GetPercent()

            if target:HasTag("snowish") then
                inst.finaldamage = inst.finaldamage * 2
            end
        end

        if no_aggro(attacker, target) then
            target.components.combat:SetShouldAvoidAggro(attacker)
        end
		
        local weapon = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

        if target:HasTag("shadowcreature") or target.sg == nil or target.wixieammo_hitstuncd == nil and not (target.sg:HasStateTag("busy") or target.sg:HasStateTag("caninterrupt")) or target.sg:HasStateTag("frozen") then
            target.wixieammo_hitstuncd = target:DoTaskInTime(8, function()
                if target.wixieammo_hitstuncd ~= nil then
                    target.wixieammo_hitstuncd:Cancel()
                end

                target.wixieammo_hitstuncd = nil
            end)
			
			target.components.combat:GetAttacked(weapon ~= nil and attacker or inst, inst.finaldamage, weapon)
        else
			target.components.combat:GetAttacked(weapon ~= nil and attacker or inst, 0, weapon)

            target.components.health:DoDelta(-inst.finaldamage, false, attacker, false, attacker, false)
        end

        if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
            target.components.sleeper:WakeUp()
        end

        if target.components.combat ~= nil then
            target.components.combat.temp_disable_aggro = false
            target.components.combat:RemoveShouldAvoidAggro(attacker)
        end

        if attacker.components.combat ~= nil then
            attacker.components.combat:SetTarget(target)
        end
					
		if target.components.health ~= nil and target.components.health:IsDead() then
			attacker:PushEvent("killed", { victim = target, attacker = attacker })
		end
    end
end

local function ImpactFx(inst, attacker, target, cocobonk)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil and target.components.combat.hiteffectsymbol ~= nil and inst.impactfx ~= nil then
        local impactfx = SpawnPrefab(inst.impactfx)
        impactfx.Transform:SetPosition(target.Transform:GetWorldPosition())
    end
end

local function OnHit(inst, attacker, target)
    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    inst:Remove()
end

local function SpawnFirecrackers(inst, pt, starting_angle, attacker, powerlevel)
    local fireworks = SpawnPrefab("firecrackers_slingshot")
    if fireworks ~= nil then
        fireworks.Transform:SetPosition(pt.x, 0, pt.z)
        fireworks.components.burnable:Ignite()
        fireworks.attacker = attacker
        fireworks.powerlevel = powerlevel
        -- fireworks:TheAttacker(attacker)
    end
end

local function OnHit_Limestone(inst, attacker, target)
    if target:HasDebuff("wixiecurse_debuff") then
        inst.powerlevel = inst.powerlevel + 1
        target:PushEvent("wixiebite")
    end

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    local x, y, z = inst.Transform:GetWorldPosition()
    local tx, ty, tz = target.Transform:GetWorldPosition()

    local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))

    for i = 1, 50 do
        target:DoTaskInTime((i - 1) / 50, function(target)
            if target ~= nil and inst ~= nil then
                -- local x, y, z = inst.Transform:GetWorldPosition()
                -- local tx, ty, tz = target.Transform:GetWorldPosition()
                local tx2, ty2, tz2 = target.Transform:GetWorldPosition()

                -- local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
                local velx = math.cos(rad)  -- * 4.5
                local velz = -math.sin(rad) -- * 4.5

                local giantreduction = target:HasTag("epic") and 6 or target:HasTag("smallcreature") and 2 or 3

                local dx, dy, dz = tx2 + (((inst.powerlevel) / (i + 1.5)) * velx) / giantreduction, ty2, tz2 + (((inst.powerlevel) / (i + 1.5)) * velz) / giantreduction
                local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
                local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
                local ocean = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
                if not (target.sg ~= nil and (target.sg:HasStateTag("swimming") or target.sg:HasStateTag("invisible"))) then
                    if target ~= nil and target.components.locomotor ~= nil and dx ~= nil and (ground or boat or ocean and target.components.locomotor:CanPathfindOnWater() or target.components.tiletracker ~= nil and not target:HasTag("whale")) then
                        --[[if ocean and target.components.amphibiouscreature and not target.components.amphibiouscreature.in_water then
								target.components.amphibiouscreature:OnEnterOcean()
							end]]
                        target.Transform:SetPosition(dx, dy, dz)
                    end
                end
            end
        end)
    end

    inst:Remove()
end

local MAX_HONEY_VARIATIONS = 7
local MAX_RECENT_HONEY = 4
local HONEY_PERIOD = .2
local HONEY_LEVELS = { { min_scale = .5, max_scale = .8, threshold = 8, duration = 1.2 }, { min_scale = .5, max_scale = 1.1, threshold = 2, duration = 2 }, { min_scale = 1, max_scale = 1.3, threshold = 1, duration = 4 } }

local function PickHoney(inst)
    local rand = table.remove(inst.availabletarslow, math.random(#inst.availabletarslow))
    table.insert(inst.usedtarslow, rand)
    if #inst.usedtarslow > MAX_RECENT_HONEY then
        table.insert(inst.availabletarslow, table.remove(inst.usedtarslow, 1))
    end
    return rand
end

local function DoHoneyTrail(inst)
    local level = HONEY_LEVELS[(inst.sg ~= nil and not inst.sg:HasStateTag("moving") and 1) or (inst.components.locomotor ~= nil and inst.components.locomotor.walkspeed <= TUNING.BEEQUEEN_SPEED and 2) or 3]

    inst.tarslowcount = inst.tarslowcount + 1

    if inst.tarslowthreshold > level.threshold then
        inst.tarslowthreshold = level.threshold
    end

    if inst.tarslowcount >= inst.tarslowthreshold then
        local hx, hy, hz = inst.Transform:GetWorldPosition()
        inst.tarslowcount = 0
        if inst.tarslowthreshold < level.threshold then
            inst.tarslowthreshold = math.ceil((inst.tarslowthreshold + level.threshold) * .5)
        end

        local fx = nil
        if TheWorld.Map:IsPassableAtPoint(hx, hy, hz) then
            fx = SpawnPrefab("wixietar_trail")
            fx:SetVariation(PickHoney(inst), GetRandomMinMax(level.min_scale, level.max_scale), level.duration + math.random() * .5)
        else
            fx = SpawnPrefab("splash_sink")
        end
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end

    inst.tarslowcancelcount = inst.tarslowcancelcount + 1

    local x, y, z = inst.Transform:GetWorldPosition()

    if x ~= nil and (inst:HasTag("obsidianburning") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())) then
        for k, v in ipairs(TheSim:FindEntities(x, y, z, 10, { "tartrail" })) do
            if v.components.burnable ~= nil then
                v.components.burnable:Ignite()
            end
        end
    end

    if inst.tarslowcancelcount >= inst.tarslowmax then
        if inst.tarslowtask ~= nil then
            inst.tarslowtask:Cancel()
            inst.tarslowtask = nil
        end
    end
end

local function OnHit_Tar(inst, attacker, target)
    if target:HasDebuff("wixiecurse_debuff") then
        inst.powerlevel = inst.powerlevel + 1
        target:PushEvent("wixiebite")
    end

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    target.tarslowcancelcount = 0
    target.tarslowmax = 50 * inst.powerlevel
    target.tarslowthreshold = HONEY_LEVELS[1].threshold
    target.availabletarslow = {}
    target.usedtarslow = {}
    for i = 1, MAX_HONEY_VARIATIONS do
        table.insert(target.availabletarslow, i)
    end
    target.tarslowcount = math.ceil(target.tarslowthreshold * .5)

    if target.tarslowtask ~= nil then
        target.tarslowtask:Cancel()
        target.tarslowtask = nil
    end

    if target.honeyslowtask ~= nil then
        target.honeyslowtask:Cancel()
        target.honeyslowtask = nil
    end

    if target.sg ~= nil or target.components.locomotor ~= nil then
        target.tarslowtask = target:DoPeriodicTask(HONEY_PERIOD, DoHoneyTrail)
    end

    inst:Remove()
end

local OBSIDIAN_AURA_EXCLUDE_TAGS = { "noclaustrophobia", "player", "playerghost", "companion", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "flying", "dragonfly", "lavae", "invisible" }

local function DoAreaBurn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 5, nil, OBSIDIAN_AURA_EXCLUDE_TAGS)
    for i, v in ipairs(ents) do
        if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
            if inst.components.propagator ~= nil and v.components.combat ~= nil and v.components.health ~= nil and not v.components.health:IsDead() and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
                if v.components.sleeper ~= nil and v.components.sleeper:IsAsleep() then
                    v.components.sleeper:WakeUp()
                end

                v.components.health:DoDelta(-8, inst.attacker)
                SpawnPrefab("halloween_firepuff_1").Transform:SetPosition(v.Transform:GetWorldPosition())

                -- v:PushEvent("onignite")
					
				if v.components.health ~= nil and v.components.health:IsDead() and inst.attacker ~= nil then
					inst.attacker:PushEvent("killed", { victim = v, attacker = inst.attacker })
				end
            end

            v:PushEvent("onignite")

            inst:AddTag("obsidianburning")
        end
    end

    SpawnPrefab("halloween_firepuff_1").Transform:SetPosition(x, y, z)
end

local function CancelAreaBurn(inst)
    if inst.obsidianammotask ~= nil then
        inst.obsidianammotask:Cancel()
        inst.obsidianammotask = nil
        inst:RemoveTag("obsidianburning")
    end

    if inst.obsidianammocanceltask ~= nil then
        inst.obsidianammocanceltask:Cancel()
        inst.obsidianammocanceltask = nil
        inst:RemoveTag("obsidianburning")
    end
end

local function OnHit_Obsidian(inst, attacker, target)
    if target:HasDebuff("wixiecurse_debuff") then
        inst.powerlevel = inst.powerlevel + 1
        target:PushEvent("wixiebite")
    end

    inst.attacker = attacker

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    if target.obsidianammotask ~= nil then
        target.obsidianammotask:Cancel()
        target.obsidianammotask = nil
    end

    if target.obsidianammocanceltask ~= nil then
        target.obsidianammocanceltask:Cancel()
        target.obsidianammocanceltask = nil
    end

    if target.sg ~= nil or target.components.locomotor ~= nil then
        target.obsidianammotask = target:DoPeriodicTask(.5, DoAreaBurn)
        target.obsidianammocanceltask = target:DoTaskInTime(10 * inst.powerlevel, CancelAreaBurn)
    end

    inst:Remove()
end

local function OnHit_Coconut(inst, attacker, target)
    if target:HasDebuff("wixiecurse_debuff") then
        inst.powerlevel = inst.powerlevel + 1
        target:PushEvent("wixiebite")
    end

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    inst.components.lootdropper:SpawnLootPrefab("coconut_halved")
    inst.components.lootdropper:SpawnLootPrefab("coconut_halved")

    inst:Remove()
end

local function FindNearestInsanityTarget(inst)
	if inst.components.combat ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local combat_target = TheSim:FindEntities(x, y, z, 20, { "_combat" }, { "INLIMBO" })
		
		for i, v in ipairs(combat_targets) do
			if v.components.combat ~= nil then
				inst.components.combat:SuggestTarget(v)
				break
			end
		end
	end
end

local function CancelInsanityTarget(inst)
    if inst.insanityammotask ~= nil then
        inst.insanityammotask:Cancel()
        inst.insanityammotask = nil
    end

    if inst.insanityammocanceltask ~= nil then
        inst.insanityammocanceltask:Cancel()
        inst.insanityammocanceltask = nil
    end
end

local function OnHit_Insanity(inst, attacker, target)
    if target:HasDebuff("wixiecurse_debuff") then
        inst.powerlevel = inst.powerlevel + 1
        target:PushEvent("wixiebite")
    end

    inst.attacker = attacker

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    if target.insanityammotask ~= nil then
        target.insanityammotask:Cancel()
        target.insanityammotask = nil
    end

    if target.insanityammocanceltask ~= nil then
        target.insanityammocanceltask:Cancel()
        target.insanityammocanceltask = nil
    end

    if target.sg ~= nil or target.components.locomotor ~= nil then
        target.insanityammotask = target:DoPeriodicTask(1, FindNearestInsanityTarget)
        target.insanityammocanceltask = target:DoTaskInTime(10 * inst.powerlevel, CancelInsanityTarget)
    end

    inst:Remove()
end

local function OnHit_LunarVine(inst, attacker, target)
    if target:HasDebuff("wixiecurse_debuff") then
        inst.powerlevel = inst.powerlevel + 1
        target:PushEvent("wixiebite")
    end

    inst.attacker = attacker

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

	if target ~= nil then
		local x, y, z = target.Transform:GetWorldPosition()
		local reel = SpawnPrefab("uncompromising_axereel")
		reel.Transform:SetPosition(x, y, z)
		reel.target = target
	end

    inst:Remove()
end

local function OnHit_Flare(inst, attacker, target)
    if target:HasDebuff("wixiecurse_debuff") then
        inst.powerlevel = inst.powerlevel + 1
        target:PushEvent("wixiebite")
    end

    inst.attacker = attacker

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)
	
	if target.components.burnable ~= nil then
		target.components.burnable:Ignite()
	end
	
	local x, y, z = target.Transform:GetWorldPosition()
	
    local flare = SpawnPrefab("slingshotammo_flare_projectile")
    flare.Transform:SetPosition(x, y, z)
	flare.igniteradius = inst.powerlevel + 1
    Launch2(flare, target, 2, 1, 2, .45)

    inst:Remove()
end

local function oncollide(inst, other)
    local attacker = inst.components.projectile.owner
    if other ~= nil and attacker ~= nil and other:IsValid() and other.components.combat ~= nil and not other:HasTag("projectile") and not other:HasTag("playerghost") and not other:HasTag("player") then
        if attacker ~= nil and attacker:IsValid() and other ~= attacker then
            inst.OnHit(inst, attacker, other)
            inst:Remove()
        end
    end
end

local function CollisionCheck(inst)
    if inst.OnHit ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local attacker = inst.components.projectile.owner or nil

        for i, v in ipairs(TheSim:FindEntities(x, y, z, 3, { "_combat" }, AURA_EXCLUDE_TAGS)) do
            if v:GetPhysicsRadius(0) > 1.5 and v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
                if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
                    if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
                        inst.OnHit(inst, attacker, v)
                        inst:Remove()
                        return
                    end
                end
            end
        end

        for i, v in ipairs(TheSim:FindEntities(x, y, z, 2, { "_combat" }, AURA_EXCLUDE_TAGS)) do
            if v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
                if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
                    if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
                        inst.OnHit(inst, attacker, v)
                        inst:Remove()
                        return
                    end
                end
            end
        end
    end
end

local function secondaryproj_fn(symbol)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    -- inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    -- inst.Physics:CollidesWith(COLLISION.GIANTS)
    -- inst.Physics:CollidesWith(COLLISION.FLYERS)
    inst.Physics:SetCapsule(0.85, 0.85)

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo_IA")
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", symbol)

    -- projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")
    inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    if inst.powerlevel == nil then
        inst.powerlevel = 1
    end

    inst:AddComponent("locomotor")

    inst:AddComponent("weapon")
    inst:AddComponent("projectile")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnPreHitFn(nil)
    inst.components.projectile:SetOnHitFn(nil)
    inst.components.projectile:SetOnMissFn(nil)
    inst.components.projectile:SetLaunchOffset(Vector3(1, 0.5, 0))

    inst:DoPeriodicTask(FRAMES, CollisionCheck)

    inst:DoTaskInTime(2 - (inst.powerlevel * inst.powerlevel), inst.Remove)

    return inst
end

local function limestoneproj_fn()
    local inst = secondaryproj_fn("marble")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Limestone)

    inst.impactfx = "slingshotammo_limestone_impact"

    inst.damage = 34 * 1.25

    inst.OnHit = OnHit_Limestone

    return inst
end

local function tarproj_fn()
    local inst = secondaryproj_fn("poop")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Tar)

    inst.impactfx = "slingshotammo_tar_impact"

    inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_SLOW

    inst.OnHit = OnHit_Tar

    return inst
end

local function obsidianproj_fn()
    local inst = secondaryproj_fn("thulecite")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Obsidian)

    inst.impactfx = "slingshotammo_obsidian_impact"

    inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD

    inst.OnHit = OnHit_Obsidian

    return inst
end

local function insanityproj_fn()
    local inst = secondaryproj_fn("thulecite")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Insanity)

    inst.impactfx = "slingshotammo_obsidian_impact"

    inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD

    inst.OnHit = OnHit_Insanity

    return inst
end

local function lunarvineproj_fn()
    local inst = secondaryproj_fn("thulecite")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_LunarVine)

    inst.impactfx = "slingshotammo_obsidian_impact"

    inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD

    inst.OnHit = OnHit_LunarVine

    return inst
end

local function flareproj_fn()
    local inst = secondaryproj_fn("trinket_1")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Flare)

    inst.impactfx = "halloween_firepuff_"..math.random(3)

    inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_MARBLE

    inst.OnHit = OnHit_Flare

    return inst
end

local function fireemberproj_fn()
    local inst = secondaryproj_fn("gold")

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.Physics:ClearCollisionMask()

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(nil)

    inst.impactfx = "sand_puff"

    inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD

    inst:DoPeriodicTask(FRAMES, Emburn)

    inst.OnHit = nil

    return inst
end

local function coconutproj_fn()
    local inst = secondaryproj_fn("gold")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Coconut)

    inst.impactfx = "slingshotammo_coconut_impact"

    inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD

    inst.OnHit = OnHit_Coconut

    return inst
end

local function fncommon(symbol, inv)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo_IA")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", symbol)

    inst:AddTag("molebait")
    inst:AddTag("slingshotammo")
    inst:AddTag("reloaditem_ammo")

    if not TUNING.DSTU.WIXIE then
        inst:DoTaskInTime(0, inst.Remove)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("reloaditem")

    inst:AddComponent("tradable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 0

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. inv .. ".xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("bait")
    MakeHauntableLaunch(inst)

    return inst
end

local function limestone_fn()
    local inst = fncommon("marble", "slingshotammo_limestone")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function tar_fn()
    local inst = fncommon("poop", "slingshotammo_tar")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function obsidian_fn()
    local inst = fncommon("thulecite", "slingshotammo_obsidian")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function insanity_fn()
    local inst = fncommon("thulecite", "slingshotammo_obsidian")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function lunarvine_fn()
    local inst = fncommon("thulecite", "slingshotammo_obsidian")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function flare_fn()
    local inst = fncommon("trinket_1", "slingshotammo_flare")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function impactlimestonefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo_IA")
    inst.AnimState:PlayAnimation("used")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
    inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", "marble")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/rock")

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end

local function impacttarfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo_IA")
    inst.AnimState:PlayAnimation("used")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
    inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", "poop")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/poop")

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end

local function impactobsidianfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo_IA")
    inst.AnimState:PlayAnimation("used")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
    inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", "thulecite")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/thulecite")

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end

local function impactcoconutfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo_IA")
    inst.AnimState:PlayAnimation("used")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)
    inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", "gold")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("wixie/characters/wixie/coconut_bonk")

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end

local cant_tags = { "noclaustrophobia", "wall", "invisible", "player", "companion", "INLIMBO" }

local function doflareprojectilehit(inst, other)
    local x, y, z = inst.Transform:GetWorldPosition()
	local burnables = TheSim:FindEntities(x, y, z, inst.igniteradius ~= nil and inst.igniteradius or 1, nil, cant_tags)
	local exscale = inst.igniteradius / 2
	
    local explosive = SpawnPrefab("explode_small")
    explosive.Transform:SetPosition(x, y, z)
    explosive.Transform:SetScale(exscale, exscale, exscale)
	
	for i, v in ipairs(burnables) do
		if v.components.fueled == nil and
		v.components.burnable ~= nil and
		not v:HasTag("burnt") then	
			if not v.components.burnable:IsBurning() then
				v.components.burnable:Ignite()
				
				if v.components.combat ~= nil and v.components.health ~= nil and not v.components.health:IsDead() then
					v.components.combat:GetAttacked(inst.attacker ~= nil and inst.attacker or inst, 15, inst)
				end
			else
				if v.components.combat ~= nil and v.components.health ~= nil and not v.components.health:IsDead() then
					v.components.combat:GetAttacked(inst.attacker ~= nil and inst.attacker or inst, 30, inst)
				end
			end
		end
	end

    inst:Remove()
end

local function TestFlareProjectileLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y <= inst:GetPhysicsRadius() + 0.05 then
		doflareprojectilehit(inst)
	end
end

local function onflarecollide(inst, other)
    -- If there is a physics collision, try to do some damage to that thing.
    -- This is so you can't hide forever behind walls etc.

	if other ~= nil and other:IsValid() and other:HasTag("_combat") then
		doflareprojectilehit(inst, other)
	end
end

local function flareprojectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(10)
	inst.Physics:SetFriction(.1)
	inst.Physics:SetDamping(0)
	inst.Physics:SetRestitution(.5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetSphere(0.25)

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo")
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", "trinket_1")

    inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.igniteradius = nil

	--inst.Physics:SetCollisionCallback(onflarecollide)

    inst.persists = false

    inst:AddComponent("locomotor")

	inst:DoPeriodicTask(0, TestFlareProjectileLand)

    return inst
end

return Prefab("slingshotammo_limestone", limestone_fn, assets, prefabs),
    Prefab("slingshotammo_limestone_proj_secondary", limestoneproj_fn, assets, prefabs),
    Prefab("slingshotammo_limestone_impact", impactlimestonefn, assets, prefabs),
    Prefab("slingshotammo_tar", tar_fn, assets, prefabs),
    Prefab("slingshotammo_tar_proj_secondary", tarproj_fn, assets, prefabs),
    Prefab("slingshotammo_tar_impact", impacttarfn, assets, prefabs),
    Prefab("slingshotammo_obsidian", obsidian_fn, assets, prefabs),
    Prefab("slingshotammo_obsidian_proj_secondary", obsidianproj_fn, assets, prefabs),
    Prefab("slingshotammo_obsidian_impact", impactobsidianfn, assets, prefabs),
    Prefab("coconut_proj_secondary", coconutproj_fn, assets, prefabs),
    Prefab("slingshotammo_coconut_impact", impactcoconutfn, assets, prefabs),
    Prefab("slingshotammo_insanity", insanity_fn, assets, prefabs),
    Prefab("slingshotammo_insanity_proj_secondary", insanityproj_fn, assets, prefabs),
    Prefab("slingshotammo_lunarvine", lunarvine_fn, assets, prefabs),
    Prefab("slingshotammo_lunarvine_proj_secondary", lunarvineproj_fn, assets, prefabs),
    Prefab("slingshotammo_flare", flare_fn, assets, prefabs),
    Prefab("slingshotammo_flare_proj_secondary", flareproj_fn, assets, prefabs),
    Prefab("slingshotammo_flare_projectile", flareprojectilefn, assets, prefabs)
local cannonball_assets = {
    Asset("ANIM", "anim/cannonball_sludge.zip"),
}

-- TODO: Move these to tuning.lua!
local CANNONBALL_RADIUS = TUNING.CANNONBALL_RADIUS
local CANNONBALL_DAMAGE = TUNING.CANNONBALL_DAMAGE
local CANNONBALL_SPLASH_RADIUS = TUNING.CANNONBALL_SPLASH_RADIUS
local CANNONBALL_SPLASH_DAMAGE_PERCENT = TUNING.CANNONBALL_SPLASH_DAMAGE_PERCENT
local CANNONBALL_PASS_THROUGH_TIME_BUFFER = TUNING.CANNONBALL_PASS_THROUGH_TIME_BUFFER -- to prevent the cannonball from hitting the same target multiple times as it passes through

local MUST_ONE_OF_TAGS = { "_combat", "_health", "blocker" }
local AREAATTACK_EXCLUDETAGS = { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }

local INITIAL_LAUNCH_HEIGHT = 0.1
local SPEED_XZ = 4
local SPEED_Y = 16
local ANGLE_VARIANCE = 20

local function launch_away(inst, position, use_variant_angle)
    if inst.Physics == nil then return end

    -- Launch outwards from impact point. Calculate angle from position, with some variance
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)
    inst.Physics:SetFriction(0.2)

    local px, py, pz = position:Get()
    local random = use_variant_angle and math.random() * ANGLE_VARIANCE * -ANGLE_VARIANCE / 2 or 0
    local angle = ((180 - inst:GetAngleToPoint(px, py, pz)) + random) * DEGREES
    local sina, cosa = math.sin(angle), math.cos(angle)
    inst.Physics:SetVel(SPEED_XZ * cosa, SPEED_Y, SPEED_XZ * sina)

    -- Add a drop shadow component to the item as it flies through the air, then remove it when it lands
    if inst.components.inventoryitem then
        if not TheNet:IsDedicated() then
            inst:AddComponent("groundshadowhandler")
            inst.components.groundshadowhandler:SetSize(1, 0.5)
            inst.components.inventoryitem:SetLanded(false, true)
            inst:ListenForEvent("on_landed", function(inst)
                if inst:IsOnOcean() then
                    SpawnPrefab("wave_splash").Transform:SetPosition(
                        inst.Transform:GetWorldPosition())
                end
                inst:RemoveComponent("groundshadowhandler")
            end)
        end
    end
end

local function DoBubbleFX(inst)
    for i = 1, math.random(2, 4) do
        local x, y, z = inst.Transform:GetWorldPosition()
        if x == nil or y == nil or z == nil then
            break
        end
        local fx = SpawnPrefab("crab_king_bubble" .. math.random(3))
        local x1, y1, z1 = x + math.random(-5, 5), 0, z + math.random(-5, 5)
        if TheWorld.Map:IsOceanAtPoint(x1, y1, z1) and TheWorld.Map:GetPlatformAtPoint(x1, z1) == nil then
            fx.Transform:SetPosition(x1, y1, z1)
        end
    end
end

local function OnHit(inst, attacker, target)

    -- Do splash damage upon hitting the ground
    inst.components.combat:DoAreaAttack(inst, CANNONBALL_SPLASH_RADIUS, nil, nil, nil, AREAATTACK_EXCLUDETAGS)

    -- One last check to see if the projectile landed on a boat
    if target == nil then
        local hitpos = inst:GetPosition()
        target = TheWorld.Map:GetPlatformAtPoint(hitpos.x, hitpos.z)
    end

    -- Hit a boat? Cause a leak!
    if target ~= nil and target:HasTag("boat") then
        target.components.health:DoDelta(-TUNING.CANNONBALL_DAMAGE * 0.75)
    end

    -- Look for stuff on the ocean/ground and launch them
    local x, y, z = inst.Transform:GetWorldPosition()
    local position = inst:GetPosition()
    local affected_entities = TheSim:FindEntities(x, 0, z, CANNONBALL_SPLASH_RADIUS, nil, nil, nil,
        AREAATTACK_EXCLUDETAGS) -- Set y to zero to look for objects floating on the ocean
    for i, affected_entity in ipairs(affected_entities) do
        if affected_entity.components.burnable ~= nil and inst:HasTag("sludge_cannonball") then
            affected_entity.components.burnable:Ignite()
        end

        -- Look for fish in the splash radius, kill and spawn their loot if hit
        if affected_entity.components.oceanfishable ~= nil then
            if affected_entity.fish_def and affected_entity.fish_def.loot then
                local loot_table = affected_entity.fish_def.loot
                for i, product in ipairs(loot_table) do
                    local loot = SpawnPrefab(product)
                    if loot ~= nil then
                        local ae_x, ae_y, ae_z =
                        affected_entity.Transform:GetWorldPosition()
                        loot.Transform:SetPosition(ae_x, ae_y, ae_z)
                        launch_away(loot, position, true)
                    end
                end
                affected_entity:Remove()
            end
            -- Spawn kelp roots along with kelp is a bullkelp plant is hit
        elseif affected_entity.prefab == "bullkelp_plant" then
            local ae_x, ae_y, ae_z =
            affected_entity.Transform:GetWorldPosition()

            if affected_entity.components.pickable and
                affected_entity.components.pickable:CanBePicked() then
                local product = affected_entity.components.pickable.product
                local loot = SpawnPrefab(product)

                if loot ~= nil then
                    loot.Transform:SetPosition(ae_x, ae_y, ae_z)
                    if loot.components.inventoryitem ~= nil then
                        loot.components.inventoryitem:InheritMoisture(
                            TheWorld.state.wetness, TheWorld.state.iswet)
                    end
                    if loot.components.stackable ~= nil and
                        affected_entity.components.pickable.numtoharvest > 1 then
                        loot.components.stackable:SetStackSize(
                            affected_entity.components.pickable.numtoharvest)
                    end
                    launch_away(loot, position)
                end
            end

            local uprooted_kelp_plant = SpawnPrefab("bullkelp_root")
            if uprooted_kelp_plant ~= nil then
                uprooted_kelp_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
                launch_away(uprooted_kelp_plant, position + Vector3(0.5 * math.random(), 0, 0.5 * math.random()))
            end

            affected_entity:Remove()
            -- Generic pickup item
        elseif affected_entity.components.inventoryitem ~= nil then
            launch_away(affected_entity, position)
        elseif affected_entity.waveactive then
            affected_entity:DoSplash()
        end
    end

    -- Landed on the ocean
    if inst:IsOnOcean() then
        SpawnPrefab("crab_king_waterspout").Transform:SetPosition(inst.Transform:GetWorldPosition())
        if inst:HasTag("sludge_cannonball") then --BOIL SOME WATER
            DoBubbleFX(inst)
            inst:DoTaskInTime(FRAMES*math.random(10), DoBubbleFX, nil, inst)
            inst:DoTaskInTime(FRAMES*math.random(10), DoBubbleFX, nil, inst)
            inst:DoTaskInTime(FRAMES*math.random(10), DoBubbleFX, nil, inst)
            inst:RemoveFromScene()
            inst:DoTaskInTime(FRAMES*11, inst.Remove)
        end
        -- Landed on ground
    else
        local lava = SpawnPrefab("lavaspit_sludge")
        lava.Transform:SetPosition(inst.Transform:GetWorldPosition())

        local fx = SpawnPrefab("halloween_firepuff_1")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx.Transform:SetScale(3, 3, 3)
        inst:Remove()
    end
end

local function OnUpdateProjectile(inst)
    --if inst.components.burnable ~= nil and not inst.components.burnable:IsBurning() then
    --    inst.components.burnable:Ignite()
    --end

    -- Look to hit targets while the cannonball is flying through the air
    local x, y, z = inst.Transform:GetWorldPosition()
    local targets = TheSim:FindEntities(x, 0, z, CANNONBALL_RADIUS, nil, nil, MUST_ONE_OF_TAGS) -- Set y to zero to look for objects on the ground
    for i, target in ipairs(targets) do

        -- Ignore hitting bumpers while flying through the air
        if target ~= nil and target ~= inst.components.complexprojectile.attacker and not target:HasTag("boatbumper") then
            
            -- Playful bit of arson
            if target ~= nil and target:IsValid() and target.components.burnable ~= nil and inst:HasTag("sludge_cannonball") then
                target.components.burnable:Ignite()
            end
			
			-- Remove and do splash damage if it hits a wall, fixed from klei's funny bugs
            if target:HasTag("wall") and target.components.health then
                if not target.components.health:IsDead() then
                    inst.components.combat:DoAreaAttack(inst, CANNONBALL_SPLASH_RADIUS, nil, nil, nil,
                        AREAATTACK_EXCLUDETAGS)
                    SpawnPrefab("halloween_firepuff_1").Transform:SetPosition(inst.Transform:GetWorldPosition())
                    inst:Remove()
                    return
                end
                -- Chop/knock down workable objects
            elseif target.components.workable then
                target.components.workable:Destroy(inst)
            end

            -- Do damage to entities with health
            if target.components.combat and
                GetTime() - target.components.combat.lastwasattackedtime > CANNONBALL_PASS_THROUGH_TIME_BUFFER then
                target.components.combat:GetAttacked(inst, CANNONBALL_DAMAGE * 0.25, nil)
            end
        end
    end
end

local function common_fn(bank, build, anim, tag, isinventoryitem)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    if isinventoryitem then
        MakeInventoryPhysics(inst)
    else
        inst.entity:AddPhysics()
        inst.Physics:SetMass(1)
        inst.Physics:SetFriction(0)
        inst.Physics:SetDamping(0)
        inst.Physics:SetRestitution(0)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
        inst.Physics:SetSphere(CANNONBALL_RADIUS)
        --inst.Physics:SetCollides(false) -- The cannonball hitting targets will be handled in OnUpdateProjectile() with FindEntities()

        if not TheNet:IsDedicated() then
            inst:AddComponent("groundshadowhandler")
            inst.components.groundshadowhandler:SetSize(1, 0.5)
        end
    end

    if tag ~= nil then inst:AddTag(tag) end

    -- projectile (from complexprojectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:SetMultColour(1, 1, 0, 1)

    if type(anim) ~= "table" then
        inst.AnimState:PlayAnimation(anim, true)
    elseif #anim == 1 then
        inst.AnimState:PlayAnimation(anim[1], true)
    else
        for i, a in ipairs(anim) do
            if i == 1 then
                inst.AnimState:PlayAnimation(a, false)
            elseif i ~= #anim then
                inst.AnimState:PushAnimation(a, false)
            else
                inst.AnimState:PushAnimation(a, true)
            end
        end
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(CANNONBALL_DAMAGE * 0.75)
    inst.components.combat:SetAreaDamage(CANNONBALL_SPLASH_RADIUS, CANNONBALL_SPLASH_DAMAGE_PERCENT)

    return inst
end

local function cannonball_fn()
    local inst = common_fn("cannonball_sludge", "cannonball_sludge", "spin_loop", "NOCLICK")

    inst:AddTag("sludge_cannonball")

    if not TheWorld.ismastersim then return inst end

    inst.persists = false

    inst.components.complexprojectile:SetHorizontalSpeed(TUNING.CANNONBALLS.ROCK.SPEED)
    inst.components.complexprojectile:SetGravity(TUNING.CANNONBALLS.ROCK.GRAVITY)
    inst.components.complexprojectile:SetOnHit(OnHit)
    inst.components.complexprojectile:SetOnUpdate(OnUpdateProjectile)

    return inst
end

local function cannonball_item_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cannonball_sludge")
    inst.AnimState:SetBuild("cannonball_sludge")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:AddTag("boatcannon_ammo")

    inst.projectileprefab = "cannonball_sludge"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cannonball_sludge_item.xml"

    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    return inst
end

return Prefab("cannonball_sludge", cannonball_fn, cannonball_assets),
    Prefab("cannonball_sludge_item", cannonball_item_fn, cannonball_assets)

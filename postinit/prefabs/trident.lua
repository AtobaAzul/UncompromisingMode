local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


--Not sure how I'd do this without replacing the function, I need to add a cause to the "spawnnewboatleak" event.

local PLANT_TAGS = { "tendable_farmplant" }
local MUST_HAVE_SPELL_TAGS = nil
local CANT_HAVE_SPELL_TAGS = { "INLIMBO", "outofreach", "DECOR", "player", "playerghost", "companion", "abigail", "spelled"}
local MUST_HAVE_ONE_OF_SPELL_TAGS = nil
local FX_RADIUS = TUNING.TRIDENT.SPELL.RADIUS * 0.65
local COST_PER_EXPLOSION = TUNING.TRIDENT.USES / TUNING.TRIDENT.SPELL.USE_COUNT

local function DoLineAttack(inst, target, position)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner == nil then
        return
    end

    for _ = 1, 3 do
        local tar_x, tar_y, tar_z

        if target then
            tar_x, tar_y, tar_z = target.Transform:GetWorldPosition()
        else
            tar_x, tar_y, tar_z = position:Get()
        end

        if position == nil and target ~= nil then
            position = target:GetPosition() --launch_away @ line 47 in prefabs/trident.lua would crash.
        end

        local variance_x, variance_z = math.random(-6, 6), math.random(-6, 6)

        if variance_x > 0 then --wonder if there's anything I could do to make this better
            variance_x = math.clamp(variance_x, 4, 6)
        else
            variance_x = math.clamp(variance_x, -4, -6)
        end

        if variance_z > 0 then
            variance_z = math.clamp(variance_z, 4, 6)
        else
            variance_z = math.clamp(variance_z, -4, -6)
        end

        local start_x, start_y, start_z

        start_x, start_y, start_z = tar_x + variance_x, tar_y, tar_z + variance_z

        local deg = math.atan2(start_z - tar_z, tar_x - start_x) / DEGREES

        local rad = math.rad(deg)

        local velx = math.cos(rad) * 1.5
        local velz = -math.sin(rad) * 1.5
        local dist = distsq(start_x, start_z, tar_x, tar_z)

        dist = math.sqrt(dist)
        dist = dist + 8

        for i = 1, math.clamp(dist, 0, 16) do
            inst:DoTaskInTime(FRAMES * i, function()
                local dx, dy, dz = start_x + (i * velx), 0, start_z + (i * velz)

                local affected_entities = TheSim:FindEntities(dx, dy, dz, TUNING.TRIDENT.SPELL.RADIUS,
                    MUST_HAVE_SPELL_TAGS,
                    CANT_HAVE_SPELL_TAGS, MUST_HAVE_ONE_OF_SPELL_TAGS)
                for _, v in ipairs(affected_entities) do
                    if v.prefab ~= "boat" or TheNet:GetPVPEnabled() then
                        inst:DoWaterExplosionEffect(v, owner, position)
                    end
                end

                if TheWorld.Map:IsOceanTileAtPoint(dx, dy, dz) and not TheWorld.Map:IsVisualGroundAtPoint(dx, dy, dz) then
                    local platform_at_point = TheWorld.Map:GetPlatformAtPoint(dx, dz)
                    if platform_at_point ~= nil then
                        platform_at_point.SoundEmitter:PlaySoundWithParams("turnoftides/common/together/boat/damage",
                            { intensity = .3 })
                    else
                        local fx = SpawnPrefab("crab_king_waterspout")
                        fx.Transform:SetPosition(dx + math.random(-1, 1), dy, dz + math.random(-1, 1))
                    end
                end
            end)
        end
    end

    local x, y, z = owner.Transform:GetWorldPosition()

    for _, v in pairs(TheSim:FindEntities(x, y, z, TUNING.TRIDENT_FARM_PLANT_INTERACT_RANGE, PLANT_TAGS)) do
        if v.components.farmplanttendable ~= nil then
            v.components.farmplanttendable:TendTo(owner)
        end
    end

    inst.components.finiteuses:Use(COST_PER_EXPLOSION)
end

local function OnAttack(inst, attacker, target)
    inst.charge = inst.charge + 1

    if inst.charge > 3 then
        target.components.combat:GetAttacked(attacker, 27.21)
        local x, y, z = target.Transform:GetWorldPosition()

        local fx = TheWorld.Map:IsOceanTileAtPoint(x, y, z) and not TheWorld.Map:IsVisualGroundAtPoint(x, y, z) and
            TheWorld.Map:GetPlatformAtPoint(x, z) == nil and SpawnPrefab("crab_king_waterspout") or
            SpawnPrefab("trident_ground_fx")
        local y_offset = fx.prefab == "trident_ground_fx" and 8 or 0
        local x_offset, z_offset = math.random(-2, 2), math.random(-2, 2)
        fx.Transform:SetPosition(x + x_offset, y + y_offset, z + z_offset)

        local ring = SpawnPrefab("groundpoundring_fx")
        ring.Transform:SetPosition(x + x_offset, y, z + z_offset)
        ring.Transform:SetScale(0.33, 0.33, 0.33)
        inst.charge = inst.charge - math.random(inst.charge)
    end
end

env.AddPrefabPostInit("trident", function(inst)
    inst:AddTag("castontargets")

    if not TheWorld.ismastersim then
        return
    end

    inst.charge = 0

    if inst.components.spellcaster ~= nil then
        inst.components.spellcaster:SetSpellFn(DoLineAttack)
    end

    inst.components.weapon:SetOnAttack(OnAttack)

    local _DoWaterExplosionEffect = inst.DoWaterExplosionEffect

    inst.DoWaterExplosionEffect = function(inst, affected_entity, owner, position)
        if affected_entity.components.complexprojectile ~= nil then
            return
        else
            affected_entity:AddTag("spelled")
            affected_entity:DoTaskInTime(1, function(inst) inst:RemoveTag("spelled") end)
            _DoWaterExplosionEffect(inst, affected_entity, owner, position)
        end
    end
end)

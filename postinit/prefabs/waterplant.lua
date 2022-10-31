local env = env
GLOBAL.setfenv(1, GLOBAL)

--PROJECTILES-------------------
--------------------------------
local BOMB_MUSTHAVE_TAGS = { "_combat" }

local function do_bomb(inst, thrower, target, no_hit_tags, damage, break_boats)
    local bx, by, bz = inst.Transform:GetWorldPosition()

    -- Find anything nearby that we might want to interact with
    local entities = TheSim:FindEntities(bx, by, bz, TUNING.WATERPLANT.ATTACK_AOE * 1.5, BOMB_MUSTHAVE_TAGS, no_hit_tags)

    -- If we have a thrower with a combat component, we need to do some manipulation to become a proper combat target.
    if thrower ~= nil and thrower.components.combat ~= nil and thrower:IsValid() then
        thrower.components.combat.ignorehitrange = true
    else
        thrower = nil
    end

    local hit_a_target = false
    for i, v in ipairs(entities) do
        if v:IsValid() and v.entity:IsVisible() and inst.components.combat:CanTarget(v) then
            hit_a_target = true

            if thrower ~= nil and v.components.combat.target == nil then
                v.components.combat:GetAttacked(thrower, damage, inst)
            else
                inst.components.combat:DoAttack(v)
            end

            if not v.components.health:IsDead() and v:HasTag("stunnedbybomb") then
                v:PushEvent("stunbomb")
            end
        end
    end

    if thrower ~= nil then
        thrower.components.combat.ignorehitrange = false
    end

    -- If we DIDN'T hit a target, but DID land on a boat, put a leak in the boat!
    if break_boats and not hit_a_target then
        local platform = TheWorld.Map:GetPlatformAtPoint(bx, bz)
        if platform ~= nil then
            local dsq_to_boat = platform:GetDistanceSqToPoint(bx, by, bz)
            if dsq_to_boat < TUNING.GOOD_LEAKSPAWN_PLATFORM_RADIUS then
                platform:PushEvent("spawnnewboatleak", {pt = Vector3(bx, by, bz), leak_size = "small_leak", playsoundfx = true, cause = "waterplant_bomb"})
            end
        end
    end
end

	
local NO_TAGS_WATERPLANT = { "waterplant", "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion" }
local function onhit(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()

    if not TheWorld.Map:IsPassableAtPoint(x, y, z) then
        SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
    end

    SpawnPrefab("waterplant_burr_burst").Transform:SetPosition(x, y, z)

    do_bomb(inst, attacker, target, NO_TAGS_WATERPLANT, TUNING.WATERPLANT.DAMAGE, false)

    inst:Remove()
end



env.AddPrefabPostInit("waterplant_projectile", function(inst)
	if inst.components.complexprojectile ~= nil then
		inst.components.complexprojectile:SetOnHit(onhit)
    end
end)

local NO_TAGS_PLAYER =  { "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion", "player" }
local NO_TAGS_PVP =     { "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion" }
local function on_inventory_hit(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()

    if not TheWorld.Map:IsPassableAtPoint(x, y, z) then
        SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
    end

    SpawnPrefab("waterplant_burr_burst").Transform:SetPosition(x, y, z)

    if TheNet:GetPVPEnabled() then
        do_bomb(inst, attacker, target, NO_TAGS_PVP, TUNING.WATERPLANT.ITEM_DAMAGE, true)--leaks regardless of PvP.
    else
        do_bomb(inst, attacker, target, NO_TAGS_PLAYER, TUNING.WATERPLANT.ITEM_DAMAGE, true)
    end

    inst:Remove()
end

env.AddPrefabPostInit("waterplant_bomb", function(inst)
    if not TheWorld.ismastersim then 
        return
    end
if inst.components.complexprojectile ~= nil then
    inst.components.complexprojectile:SetOnHit(on_inventory_hit)

    inst.components.complexprojectile:SetHorizontalSpeed(20)--just makes it simpler when interacting with cannons.

    inst.components.complexprojectile:SetGravity(-40)
    end
    inst.entity:AddTag("boatcannon_ammo")
	--what the hell is the inst.entity anyways?!

	inst.projectileprefab = "waterplant_bomb"
end)

--SPAWNER-------------------
----------------------------



env.AddPrefabPostInit("waterplant_spawner_rough", function(inst)
    local _OnSave = inst.OnSave
    local _OnLoad = inst.OnLoad

    local function OnSave(inst, data)
        if data ~= nil then
            if inst.spawned_sludge then
                data.spawned_sludge = inst.spawned_sludge
            end
            if _OnSave ~= nil then
                return _OnSave(inst, data)
            end
        end
    end

    local function OnLoad(inst, data)
        if data ~= nil then
            if data.spawned_sludge then
                inst.spawned_sludge = data.spawned_sludge
            end
            if _OnLoad ~= nil then
                return _OnLoad(inst, data)
            end
        end
    end

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:DoTaskInTime(0, function(inst)
        if not inst.spawned_sludge then
            local x, y, z = inst.Transform:GetWorldPosition()
            for i = 1, math.random(5, 8) do
                local sx, sy, sz = x + GetRandomWithVariance(-15, 15), y, z + GetRandomWithVariance(-15, 15)
                if TheWorld.Map:IsOceanAtPoint(sx, sy, sz, false) then
                    local stack = SpawnPrefab("sludgestack")
                    stack.Transform:SetPosition(sx, sy, sz)
                end
            end
            inst.spawned_sludge = true
        end
    end)
end)



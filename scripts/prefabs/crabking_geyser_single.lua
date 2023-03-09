--because klei apparently didn't make one!!!!

local geyserprefabs =
{
    "crab_king_bubble1",
    "crab_king_bubble2",
    "crab_king_bubble3",
    "crab_king_waterspout",
}

local REPAIRED_PATCH_TAGS = { "boat_repaired_patch" }

local function dogeyserburbletask(inst)
    if inst.burbletask then
        inst.burbletask:Cancel()
        inst.burbletask = nil
    end
    local totalcasttime = TUNING.CRABKING_CAST_TIME -
        (inst.crab and inst.crab:IsValid() and math.floor(inst.crab.countgems(inst.crab).yellow / 2 or 0))
    local time = Remap(inst.components.age:GetAge(), 0, totalcasttime, 0.2, 0.01)
    inst.burbletask = inst:DoTaskInTime(time + 1, function() inst.burble(inst) end) -- 0.01+ math.random()*0.1
end

local function burble(inst)
    local MAXRADIUS = 1
    local x, y, z = inst.Transform:GetWorldPosition()
    local theta = math.random() * 2 * PI
    local radius = math.pow(math.random(), 0.8) * MAXRADIUS
    local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
    local prefab = "crab_king_bubble" .. math.random(1, 3)

    if TheWorld.Map:IsOceanAtPoint(x + offset.x, 0, z + offset.z) then
        local fx = SpawnPrefab(prefab)
        fx.Transform:SetPosition(x + offset.x, y + offset.y, z + offset.z)
    else
        local boat = TheWorld.Map:GetPlatformAtPoint(x + offset.x, z + offset.z)
        if boat then
            ShakeAllCameras(CAMERASHAKE.VERTICAL, 0.1, 0.01, 0.3, boat, boat:GetPhysicsRadius(4))
        end
    end

    dogeyserburbletask(inst)
end

local function endgeyser(inst)
    inst:DoTaskInTime(2.4, function()
        if inst.burbletask then
            inst.burbletask:Cancel()
            inst.burbletask = nil
        end
    end)

    inst:DoTaskInTime( --[[(math.random() * 0.4)+]] (inst.chain_time * 0.025), function()
        local MAXRADIUS = 1.25
        local x, y, z = inst.Transform:GetWorldPosition()
        local theta = math.random() * 2 * PI
        local radius = math.pow(math.random(), 0.8) * MAXRADIUS
        local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
        local prefab = "crab_king_waterspout"
        if TheWorld.Map:IsOceanAtPoint(x + offset.x, 0, z + offset.z) then
            local fx = SpawnPrefab(prefab)
            fx.Transform:SetPosition(x + offset.x, y + offset.y, z + offset.z)

            local INITIAL_LAUNCH_HEIGHT = 0.1
            local SPEED = 8
            local CANT_HAVE_TAGS = { "INLIMBO", "outofreach", "DECOR" }
            local function launch_away(inst, position)
                local ix, iy, iz = inst.Transform:GetWorldPosition()
                inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)

                local px, py, pz = position:Get()
                local angle = (180 - inst:GetAngleToPoint(px, py, pz)) * DEGREES
                local sina, cosa = math.sin(angle), math.cos(angle)
                inst.Physics:SetVel(SPEED * cosa, 4 + SPEED, SPEED * sina)
            end
            local affected_entities = TheSim:FindEntities(x + offset.x, y + offset.y, z + offset.z, 2, nil,
                CANT_HAVE_TAGS)
            for _, v in ipairs(affected_entities) do
                if v.components.oceanfishable ~= nil then
                    -- Launch fishable things because why not.

                    local projectile = v.components.oceanfishable:MakeProjectile()
                    if projectile.components.weighable ~= nil then
                        projectile.components.weighable.prefab_override_owner = inst.fisher_prefab
                    end
                    local position = Vector3(x + offset.x, y + offset.y, z + offset.z)
                    if projectile.components.complexprojectile then
                        projectile.components.complexprojectile:SetHorizontalSpeed(16)
                        projectile.components.complexprojectile:SetGravity( -30)
                        projectile.components.complexprojectile:SetLaunchOffset(Vector3(0, 0.5, 0))
                        projectile.components.complexprojectile:SetTargetOffset(Vector3(0, 0.5, 0))

                        local v_position = v:GetPosition()
                        local launch_position = v_position + (v_position - position):Normalize() * SPEED
                        projectile.components.complexprojectile:Launch(launch_position, projectile)
                    else
                        launch_away(projectile, position)
                    end
                end
                if v.components.health ~= nil and v.components.combat ~= nil and not v:HasTag("boat") and v.prefab ~= "crabking_claw" and v.prefab ~= "crabking" then
                    v.components.combat:GetAttacked(inst.crab, 34 + inst.crab.countgems(inst.crab).purple * 2)
                end
            end
        else
            local boat = TheWorld.Map:GetPlatformAtPoint(x + offset.x, z + offset.z)
            if boat then
                local pt = Vector3(x + offset.x, 0, z + offset.z)
                boat.components.health:DoDelta( -2 - math.floor(inst.crab.countgems(inst.crab).purple*0.5))
                boat.SoundEmitter:PlaySoundWithParams("turnoftides/common/together/boat/damage",
                { intensity = .6 })

                -- look for patches
                --[[local nearpatch = TheSim:FindEntities(pt.x, 0, pt.z, 2, REPAIRED_PATCH_TAGS)
                for i, patch in pairs(nearpatch) do
                    pt = Vector3(patch.Transform:GetWorldPosition())
                    patch:Remove()
                    break
                end]]
                --boat:PushEvent("spawnnewboatleak", { pt = pt, leak_size = "small_leak", playsoundfx = true })
            end
        end
    end)

    inst:DoTaskInTime(5, function() inst:Remove() end)
end

local function geyserfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
    inst:AddTag("fx")
    inst:AddTag("crabking_spellgenerator")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("age")

    inst.persists = false

    inst.burble = burble
    inst.dogeyserburbletask = dogeyserburbletask

    inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/bubble_LP", "burble")
    inst.SoundEmitter:SetParameter("burble", "intensity", 0)
    inst.burblestarttime = GetTime()
    inst.burbleintensity = inst:DoPeriodicTask(1, function()
        local totalcasttime = TUNING.CRABKING_CAST_TIME -
            ((inst.crab and inst.crab:IsValid()) and math.floor(inst.crab.countgems(inst.crab).yellow / 2) or 0)
        local intensity = math.min(1, (GetTime() - inst.burblestarttime) / totalcasttime)

        inst.SoundEmitter:SetParameter("burble", "intensity", intensity)
    end)
    inst:ListenForEvent("onremove", function()
        if inst.burbletask then
            inst.burbletask:Cancel()
            inst.burbletask = nil
        end
        if inst.burbleintensity then
            inst.burbleintensity:Cancel()
            inst.burbleintensity = nil
        end
        inst.SoundEmitter:KillSound("burble")
    end)

    inst:ListenForEvent("endspell", function()
        endgeyser(inst)
    end)

    inst:DoTaskInTime(TUNING.CRABKING_CAST_TIME + 2, function()
        inst:Remove()
    end)



    return inst
end

return Prefab("crabking_geyser_single", geyserfn, nil, geyserprefabs)

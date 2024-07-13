local ANIM_SMOKE_TEXTURE = resolvefilepath("fx/smog4.tex")
local SMOKE_SHADER = "shaders/vfx_particle.ksh"

local COLOUR_ENVELOPE_NAME_SMOKE = "smog_cloud_colourenvelope_smoke"
local SCALE_ENVELOPE_NAME_SMOKE = "smog_cloud_scaleenvelope_smoke"


local SMOKE_SIZE = 1.25
local SMOKE_MAX_LIFETIME = 10
local MIASMA_SPACING_RADIUS = SQRT2 * TUNING.MIASMA_SPACING * TILE_SCALE / 2
local MIASMA_PARTICLE_RADIUS = MIASMA_SPACING_RADIUS / 2

--No physics padding for smog cloud to take effect
local SMOG_SPACING_RADIUS = SQRT2 * (TUNING.MIASMA_SPACING) * TILE_SCALE
local SMOG_PARTICLE_RADIUS = MIASMA_PARTICLE_RADIUS * 1.25


-- Small overlap is good to make sure players are always in a fog when all squares are in one.
local SMOG_RADIUS = math.ceil(SMOG_SPACING_RADIUS) - math.random()
local SMOKE_RADIUS = SMOG_RADIUS - 0.75 * 1.3 -- 1.3 is scale factor for texture size and is constant to the smoke "cloud.


local _OldHeading = nil
local _OldHeading_cos = nil
local _OldHeading_sin = nil
local _SmogCloudEntities = nil
local function OnRemove_Client(inst)
    if _SmogCloudEntities ~= nil then
        _SmogCloudEntities[inst] = nil
    end
end

local _OldHeading = nil
local _OldHeading_cos = nil
local _OldHeading_sin = nil
local function OnCameraUpdate_Client(dt)
    local heading = TheCamera:GetHeading()
    if heading ~= _OldHeading then
        _OldHeading = heading
        _OldHeading_cos = math.cos(_OldHeading * DEGREES)
        _OldHeading_sin = math.sin(_OldHeading * DEGREES)
        local ox, oz = _OldHeading_cos * SMOG_PARTICLE_RADIUS, _OldHeading_sin * SMOG_PARTICLE_RADIUS
        for smogcloud, _ in pairs(_SmogCloudEntities) do
            smogcloud._front_cloud_fx.Transform:SetPosition(ox, 1, oz)
            smogcloud._back_cloud_fx.Transform:SetPosition(-ox, 1, -oz)
        end
    end
end

local function OnCameraUpdate_Targeted_Client(smogcloud)
    local heading = TheCamera:GetHeading()
    if heading ~= _OldHeading then
        _OldHeading = heading
        _OldHeading_cos = math.cos(_OldHeading * DEGREES)
        _OldHeading_sin = math.sin(_OldHeading * DEGREES)
    end
    local ox, oz = _OldHeading_cos * SMOG_PARTICLE_RADIUS, _OldHeading_sin * SMOG_PARTICLE_RADIUS
    smogcloud._front_cloud_fx.Transform:SetPosition(ox, 1, oz)
    smogcloud._back_cloud_fx.Transform:SetPosition(-ox, 1, -oz)
end

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end


local function InitEnvelope()
    -- SMOKE
    EnvelopeManager:AddColourEnvelope(
        COLOUR_ENVELOPE_NAME_SMOKE,
        {
            { 0,  IntColour(255, 255, 255, 20) },
            { .3, IntColour(255, 255, 255, 20) },
            { .7, IntColour(255, 255, 255, 20) },
            { 1,  IntColour(255, 255, 255, 20) },
        }
    )

    local smoke_max_scale = SMOKE_SIZE
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME_SMOKE,
        {
            { 0, { smoke_max_scale, smoke_max_scale } },
            { 1, { smoke_max_scale * 0.8, smoke_max_scale * 0.8 } },
        }
    )


    InitEnvelope = nil
    IntColour = nil
end

local RADIUS_SQ_DENY = 4 * 4
local RADIUS_SQ_ALLOW = PLAYER_CAMERA_SEE_DISTANCE_SQ


local function emit_smoke_fn(effect, smoke_circle_emitter, px, pz, ex, ez, isdiminishing, isfront, _world, _sim)
    local ox, oz = smoke_circle_emitter() -- Offset.
    if isfront then                       -- Flip circle coordinates to make it a semicircle.
        if ox < 0 then
            ox = -ox
        end
        ox = ox - SMOG_PARTICLE_RADIUS
    else
        if ox > 0 then
            ox = -ox
        end
        ox = ox + SMOG_PARTICLE_RADIUS
    end
    if _OldHeading then -- Rotate to face heading.
        -- Keep this in one line to reduce local variable requirements where ox and oz rely on the old values to work.
        ox, oz = ox * _OldHeading_cos - oz * _OldHeading_sin, ox * _OldHeading_sin + oz * _OldHeading_cos
    end
    ex, ez = ex + oz, ez + oz       -- World position of particle.

    local dx, dz = px - ex, pz - ez -- Delta from player to particle.
    local dsq = dx * dx + dz * dz
    if dsq > RADIUS_SQ_ALLOW then
        -- Hide ones too far from the player.
        return
    end


    local vx, vy, vz = -.025, 0.01 * UnitRand(), .001 * UnitRand()
    local lifetime = SMOKE_MAX_LIFETIME -- Do not vary VFX will make it pop on the engine side and we do not want any pops.
    local oy = 0.5 * (1 + math.random())

    local uv_offset = 0 --math.random(0, 1) * 0.5

    effect:AddRotatingParticleUV(
        0,
        lifetime,         -- lifetime
        ox, oy, oz,       -- position
        vx, vy, vz,       -- velocity
        0,                --math.random() * 360, -- angle
        UnitRand() * 0.1, -- angle velocity
        uv_offset, 0      -- UV
    )
end


local function SetupParticles(inst)
    if InitEnvelope ~= nil then
        InitEnvelope()
    end

    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(1)

    -- SMOKE
    effect:SetRenderResources(0, ANIM_SMOKE_TEXTURE, SMOKE_SHADER)
    effect:SetMaxNumParticles(0, 100)
    effect:SetRotationStatus(0, true)
    effect:SetMaxLifetime(0, SMOKE_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME_SMOKE)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME_SMOKE)
    effect:SetUVFrameSize(0, 1, 1)
    effect:SetBlendMode(0, BLENDMODE.Premultiplied)
    effect:SetSortOrder(0, 3)
    effect:SetSortOffset(5, 1)
    effect:SetRadius(0, SMOKE_RADIUS) --only needed on a single emitter
    effect:SetDragCoefficient(0, 0)

    -----------------------------------------------------
    -- Local cache for when FX are emitted.
    local _world = TheWorld
    local _sim = TheSim

    local smoke_circle_emitter = CreateCircleEmitter(SMOKE_RADIUS)

    local particles_per_tick = 4 * TheSim:GetTickTime() -- Half intensity with particle placement folding.
    local num_to_emit = 0
    EmitterManager:AddEmitter(inst, nil, function()
        local _player = ThePlayer
        if _player then
            local parent = inst.entity:GetParent()
            if parent and (parent.IsCloudEnabled == nil or parent:IsCloudEnabled()) then
                local px, _, pz = _player.Transform:GetWorldPosition()
                local ex, _, ez = parent.Transform:GetWorldPosition()
                local isdiminishing = parent._diminishing:value()
                local isfront = inst._frontsemicircle

                num_to_emit = num_to_emit + particles_per_tick
                while num_to_emit > 1 do
                    emit_smoke_fn(effect, smoke_circle_emitter, px, pz, ex, ez, isdiminishing, isfront, _world, _sim)
                    num_to_emit = num_to_emit - 1
                end
            end
        end
    end)
end


local function fn_fx()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    SetupParticles(inst)

    return inst
end

local function AttachParticles(inst)
    local front = SpawnPrefab("smog_fx")
    front.entity:SetParent(inst.entity)
    front.Transform:SetPosition(SMOG_PARTICLE_RADIUS, 0.1, 0)
    front._frontsemicircle = true

    local back = SpawnPrefab("smog_fx")
    back.entity:SetParent(inst.entity)
    back.Transform:SetPosition(-SMOG_PARTICLE_RADIUS, 0.1, 0)

    inst._front_cloud_fx = front
    inst._back_cloud_fx = back
end


local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("smog")

    inst._diminishing = net_bool(inst.GUID, "smog_cloud._diminishing", "diminishingdirty")

    --run this clientside only.
    if not TheNet:IsDedicated() then
        AttachParticles(inst)
        if _SmogCloudEntities == nil then
            -- Initialize.
            _SmogCloudEntities = {}
            if TheCamera then
                TheCamera:AddListener("SmogClouds", OnCameraUpdate_Client)
            end
        end


        if TheCamera then
            OnCameraUpdate_Targeted_Client(inst)
        end

        inst:ListenForEvent("onremove", OnRemove_Client)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(0, function(inst)
        if c_countprefabs("smog", true) > 150 then --200 means 400 emitters, leave some wiggle room for more non-smog emitters.
            local smog = TheSim:FindFirstEntityWithTag("smog")
            if smog ~= nil then
                smog:Remove()
            end
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        if #TheSim:FindEntities(x, y, z, 4, { "smog" }) > 1 then
            inst:Remove()
        end

        if #TheSim:FindEntities(x, y, z, 16, { "smog" }) > 16 then
            inst:Remove()
        end

        if #TheSim:FindEntities(x, y, z, 32, { "smog" }) > 32 then
            inst:Remove()
        end
    end)

    inst:DoTaskInTime(math.random(60, 120), function(inst)
        inst:Remove()
    end)

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)

    if TheWorld.components.worldwind ~= nil then
        inst:DoPeriodicTask(FRAMES, function(inst)
            if TheWorld.components.worldwind ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                local ang = TheWorld.components.worldwind:GetWindAngle()
                local rad = math.rad(ang)
                --inst.Transform:SetRotation(TheWorld.components.worldwind:GetWindAngle())
                local velx = math.cos(rad)  --* 4.5
                local velz = -math.sin(rad) --* 4.5

                local dx, dy, dz = x + (((FRAMES) * velx)), y,
                    z + (((FRAMES) * velz))
                inst.Transform:SetPosition(dx, dy, dz)
            end
        end)
    end

    inst:DoPeriodicTask(5 + math.random(5), function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 8, nil, { "INLIMBO", "playerghost", "has_gasmask", "pyromaniac", "smogimmune", "minifansuppressor", "scp049", "wragonfly" }, { "player", "insect" })
        for k, v in ipairs(ents) do
            if v.components.health ~= nil and math.random() > 0.25 then
                if v.components.oldager ~= nil or v.components.health.penalty >= TUNING.MAXIMUM_HEALTH_PENALTY-.05 or not TUNING.HEALTH_PENALTY_ENABLED then
                    v.components.health:DoDelta(-1, false, "smog")
                elseif v:HasTag("player") then
                    v.components.health:DeltaPenalty(0.025)
                end

                if v.components.talker ~= nil and v:HasTag("player") then
                    v.components.talker:Say(GetString(v, "GAS_DAMAGE"))
                end

                if v:HasTag("insect") then
                    v.components.health:DoDelta(-1, false, "smog")
                    if v.components.hauntable ~= nil and v.components.hauntable.panicable then
                        v.components.hauntable:Panic(5 + math.random(5))
                    end
                end
            end
        end
    end)

    --inst:AddComponent("areaaware")

    return inst
end

return Prefab("smog", fn), Prefab("smog_fx", fn_fx)

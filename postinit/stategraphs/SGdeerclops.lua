local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddStategraphPostInit("deerclops", function(inst)
    local SHAKE_DIST = 40

    local AREAATTACK_MUST_TAGS = { "_combat" }
    local AREA_EXCLUDE_TAGS = { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" }

    local function SetLightValue(inst, val)
        if inst.Light ~= nil then
            inst.Light:SetIntensity(.6 * val * val)
            inst.Light:SetRadius(8 * val)
            inst.Light:SetFalloff(3 * val)
        end
    end

    local function SetLightValueAndOverride(inst, val, override)
        if inst.Light ~= nil then
            inst.Light:SetIntensity(.6 * val * val)
            inst.Light:SetRadius(8 * val)
            inst.Light:SetFalloff(3 * val)
            inst.AnimState:SetLightOverride(override)
        end
    end

    local function SetLightColour(inst, val)
        if inst.Light ~= nil then
            inst.Light:SetColour(0, 0, val)
        end
    end

    local function DoSpawnIceSpike(inst, x, z)
        SpawnPrefab("icespike_fx_" .. tostring(math.random(1, 4))).Transform:SetPosition(x, 0, z)
    end

    local function SpawnIceFx(inst, target)
        if target == nil or not target:IsValid() then
            return
        end
        local numFX = math.random(15, 20)
        local x, y, z = inst.Transform:GetWorldPosition()
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        local dx, dz = x1 - x, z1 - z
        local dist = dx * dx + dz * dz
        if dist > 0 then
            dist = math.sqrt(dist)
            dx, dz = dx / dist, dz / dist
        end
        for i = 1, numFX do
            local offset = GetRandomMinMax(dist * .25, dist)
            inst:DoTaskInTime(math.random() * .25, DoSpawnIceSpike, x + dx * offset + GetRandomWithVariance(0, 3),
                z + dz * offset + GetRandomWithVariance(0, 3))
        end
    end

    local function SpawnAttackAuras(inst)
        for sweep = -30, 30, 15 do
            local x, y, z = inst.Transform:GetWorldPosition()
            local angle = (inst.Transform:GetRotation() + 90 + sweep) * DEGREES
            local dist = 10
            local ground = TheWorld.Map
            local aura, x1, z1
            x1 = x + dist * math.sin(angle)
            z1 = z + dist * math.cos(angle)
            if ground:IsPassableAtPoint(x1, 0, z1) then
                aura = SpawnPrefab("deer_ice_circle")
                aura.Transform:SetPosition(x1, 0, z1)
                aura:DoTaskInTime(6, function(aura) aura:TriggerFX() end)
                aura:DoTaskInTime(9, aura.KillFX)
            end
        end
    end

    local function SpawnLaser_Blue(inst)
        local numsteps = 10
        local x, y, z = inst.Transform:GetWorldPosition()
        local angle = (inst.Transform:GetRotation() + 90) * DEGREES
        local step = .75
        local offset = 2 - step --should still hit players right up against us
        local ground = TheWorld.Map
        local targets, skiptoss = {}, {}
        local i = -1
        local noground = false
        local fx, dist, delay, x1, z1
        while i < numsteps do
            i = i + 1
            dist = i * step + offset
            delay = math.max(0, i - 1)
            x1 = x + dist * math.sin(angle)
            z1 = z + dist * math.cos(angle)
            if not ground:IsPassableAtPoint(x1, 0, z1) then
                if i <= 0 then
                    return
                end
                noground = true
            end

            fx = SpawnPrefab(i > 0 and "deerclops_laser_blue" or "deerclops_laserempty")

            if inst.components.health:GetPercent() <= 0.5 then
                fx = SpawnPrefab(i > 0 and "deerclops_laser_blue" or "deerclops_laserempty_blue")
            end

            fx.caster = inst
            fx.Transform:SetPosition(x1, 0, z1)
            fx:Trigger(delay * FRAMES, targets, skiptoss)
            if i == 0 then
                ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .6, fx, 30)
            end
            if noground then
                break
            end
        end

        if i < numsteps then
            dist = (i + .5) * step + offset
            x1 = x + dist * math.sin(angle)
            z1 = z + dist * math.cos(angle)
        end

        fx = SpawnPrefab("deerclops_laser_blue")

        if inst.components.health:GetPercent() <= 0.5 then
            fx = SpawnPrefab(i > 0 and "deerclops_laser_blue" or "deerclops_laserempty_blue")
        end

        fx.Transform:SetPosition(x1, 0, z1)
        fx:Trigger((delay + 1) * FRAMES, targets, skiptoss)

        fx = SpawnPrefab("deerclops_laser_blue")

        if inst.components.health:GetPercent() <= 0.5 then
            fx = SpawnPrefab(i > 0 and "deerclops_laser_blue" or "deerclops_laserempty_blue")
        end

        fx.Transform:SetPosition(x1, 0, z1)
        fx:Trigger((delay + 2) * FRAMES, targets, skiptoss)
    end

    local BASE_NUM_ANGULAR_STEPS = 75
    local SWEEP_ANGULAR_LENGTH = 360
    local MIN_SWEEP_DISTANCE = 1
    local function SpawnSweep(inst, target_pos, BASE_SWEEP_DISTANCE)
        local gx, gy, gz = inst.Transform:GetWorldPosition()

        local angle = nil
        local dist = nil
        local angle_step_dir = 1
        local x_dir = 1

        if target_pos == nil then
            angle = DEGREES * (inst.Transform:GetRotation() + (SWEEP_ANGULAR_LENGTH)) + 90 * DEGREES
            dist = BASE_SWEEP_DISTANCE
            x_dir = -1
            angle_step_dir = -1
        else
            angle = math.atan2(gz - target_pos.z, gx - target_pos.x) - (SWEEP_ANGULAR_LENGTH * DEGREES)
            dist = math.max(math.sqrt(inst:GetDistanceSqToPoint(target_pos:Get())), MIN_SWEEP_DISTANCE)
        end

        local num_angle_steps = BASE_NUM_ANGULAR_STEPS + RoundBiasedDown((math.abs(dist) - BASE_SWEEP_DISTANCE))
        local angle_step = (SWEEP_ANGULAR_LENGTH / num_angle_steps) * DEGREES

        local targets, skiptoss = {}, {}

        local fx = nil
        local delay = nil
        local x1, z1 = nil, nil

        local i = -1
        while i < num_angle_steps do
            i = i + 1
            delay = math.max(0, i - 1)

            x1 = gx - (x_dir * dist * math.cos(angle))
            z1 = gz - dist * math.sin(angle)
            angle = angle + (angle_step_dir * angle_step)

            fx = SpawnPrefab(i > 0 and "deerclops_laser_blue" or "deerclops_laserempty_blue")
            if BASE_SWEEP_DISTANCE == 10 then
                fx.deerclops = inst
            else
                fx.ice = false
            end
            fx.ice = false
            fx.caster = inst
            fx.Transform:SetPosition(x1, 0, z1)
            fx:Trigger(delay * FRAMES, targets, skiptoss)
            if i == 0 then
                ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .6, target_pos or fx, 30)
            end
        end

        fx = SpawnPrefab(i > 0 and "deerclops_laser_blue" or "deerclops_laserempty_blue")
        fx.ice = false
        if BASE_SWEEP_DISTANCE == 10 then
            fx.deerclops = inst
        else
            fx.ice = false
        end
        fx.Transform:SetPosition(x1, 0, z1)

        fx:Trigger(math.max(1, i) * FRAMES, targets, skiptoss)


        if inst.components.health:GetPercent() <= 0.5 then
            fx = SpawnPrefab(i > 0 and "deerclops_laser_blue" or "deerclops_laserempty_blue")
            if BASE_SWEEP_DISTANCE == 10 then
                fx.deerclops = inst
            else
                fx.ice = false
            end
        end
        fx.Transform:SetPosition(x1, 0, z1)
        fx:Trigger(math.max(2, i + 1) * FRAMES, targets, skiptoss)
    end

    local function EnableEightFaced(inst)
        if not inst.sg.mem.eightfaced then
            inst.sg.mem.eightfaced = true
            inst.Transform:SetEightFaced()
        end
    end

    local function DisableEightFaced(inst)
        if inst.sg.mem.eightfaced then
            inst.sg.mem.eightfaced = false
            inst.Transform:SetFourFaced()
        end
    end

    local function EnrageAttackBank(inst, data)
        if inst.components.health ~= nil and not inst.components.health:IsDead() then
            if (inst.components.timer ~= nil and not inst.components.timer:TimerExists("laserbeam_cd")) then
                inst.sg:GoToState("laserbeam_blue", inst.components.combat.target)
            else
                inst.sg:GoToState("attack")
            end
        end
    end

    local function CanSpawnSpikeAt(pos, size)
        local radius = 1.1
        for i, v in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, radius + 1.5, nil, { "antlion_sinkhole" }, { "groundspike" })) do
            if v.Physics == nil then
                return false
            end
            local spacing = radius + v:GetPhysicsRadius(0)
            if v:GetDistanceSqToPoint(pos) < spacing * spacing then
                return false
            end
        end
        return true
    end

    local function SpawnBlock(inst, x, z, cracked)
        local blockade = SpawnPrefab("deerclops_barrier")
        if cracked then
            blockade:AddTag("cracked")
            blockade.AnimState:PlayAnimation("form_cracked")
            blockade.AnimState:PushAnimation("full_cracked")
            blockade.components.workable:SetWorkLeft(2)
        else
            blockade.AnimState:PlayAnimation("form")
            blockade.AnimState:PushAnimation("full")
        end
        blockade.Transform:SetPosition(x, 0, z)
        blockade:DoTaskInTime(17, function(blockade)
            if blockade.components.workable ~= nil and blockade.components.workable.workleft > 0 then
                blockade:RemoveIt(blockade)
            end
        end)
    end
    local function SpawnBlocks(inst, pos, count)
        if count > 0 then
            local dtheta = PI * 2 / count
            local thetaoffset = math.random() * PI * 2
            inst.blockrun = 0
            inst.crackblocks = 0
            for theta = math.random() * dtheta, PI * 2, dtheta do
                inst.blockrun = inst.blockrun + 1
                local offset = FindWalkableOffset(pos, theta + thetaoffset, 8 + math.random(), 3, false, true,
                    function(pt)
                        return CanSpawnSpikeAt(pt, "block")
                    end)
                if offset ~= nil then
                    local blockcrack = false
                    if inst.blockrun > 5 and inst.crackblocks <= 2 then
                        if math.random() > 0.75 then
                            blockcrack = true
                        else
                            blockcrack = false
                        end
                    else
                        blockcrack = true
                    end
                    if inst.blockrun > 10 and inst.crackblocks <= 4 then
                        if math.random() > 0.75 then
                            blockcrack = true
                        else
                            blockcrack = false
                        end
                    else
                        blockcrack = true
                    end
                    if theta < dtheta then
                        SpawnBlock(inst, pos.x + offset.x, pos.z + offset.z, blockcrack)
                    else
                        inst:DoTaskInTime(math.random() * .5, SpawnBlock, pos.x + offset.x, pos.z + offset.z, blockcrack)
                    end
                end
            end
        end
    end
    local function FreezeEverything(inst)
        if inst.components.combat.target ~= nil then
            local target = inst.components.combat.target
            inst:ForceFacePoint(target.Transform:GetWorldPosition())
            local aura = SpawnPrefab("deer_ice_circle")
            local x, y, z = inst.Transform:GetWorldPosition()
            local theta = inst.Transform:GetRotation() * DEGREES
            x = x + 2 * math.cos(theta)
            z = z - 2 * math.sin(theta)
            aura.Transform:SetPosition(x, y, z)
            aura:DoTaskInTime(6, function(aura) aura:TriggerFX() end)
            aura:DoTaskInTime(9, aura.KillFX)

            local side = math.random( -1, 1)
            side = 0
            for i = 1, 2 do
                if i == 2 then

                else
                    for n = 1, 5 do
                        local aura = SpawnPrefab("deer_ice_circle")
                        local x, y, z = inst.Transform:GetWorldPosition()
                        local theta = inst.Transform:GetRotation() * DEGREES
                        theta = theta + (n - 2) / 1.1 + side
                        x = x + 5 * i * math.cos(theta)
                        z = z - 5 * i * math.sin(theta)
                        aura.Transform:SetPosition(x, y, z)
                        aura:DoTaskInTime(6, function(aura) aura:TriggerFX() end)
                        aura:DoTaskInTime(9, aura.KillFX)
                    end
                end
            end
        end
    end

    local function StrongAttackBank(inst, data)
        if inst.components.health ~= nil and not inst.components.health:IsDead()
            and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("hit")) then
            if inst.components.timer ~= nil and not inst.components.timer:TimerExists("uppercuttime") then
                if inst.components.health:GetPercent() >= 0.5 then
                    inst.sg:GoToState("uppercut")
                else
                    inst.sg:GoToState("uppercutcombo")
                end
            else
                inst.sg:GoToState("attack")
            end
        end
    end

    local function IceAttackBank(inst, data)
        if inst.components.health ~= nil and not inst.components.health:IsDead() and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("hit")) then
            if inst.components.timer ~= nil and not inst.components.timer:TimerExists("auratime") then
                inst.sg:GoToState("aurafreeze_pre")
                inst:DoTaskInTime(7, function(inst) inst.sg:GoToState("aurafreeze_pst") end)
            else
                inst.sg:GoToState("aurattack")
            end
        end
    end

    local events =
    {
        EventHandler("doattack", function(inst, data)
            if inst.upgrade == "enrage_mutation" then
                print("enragebank")
                EnrageAttackBank(inst, data)
            end
            if inst.upgrade == "strength_mutation" then
                StrongAttackBank(inst, data)
            end
            if inst.upgrade == "ice_mutation" then
                IceAttackBank(inst, data)
            end
        end),
        EventHandler("attacked", function(inst, data)
            if inst.components.health ~= nil and
                not inst.components.health:IsDead() and
                ((not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) or inst.sg:HasStateTag("aurafreeze")) then
                if inst.sg:HasStateTag("aurafreeze") then
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr")
                    inst.sg:GoToState("aurafreeze_hit")
                else
                    inst.sg:GoToState("hit")
                end
            end
        end),
    }

    local states = {

        State {
            name = "laserbeam_blue",
            tags = { "busy" },

            onenter = function(inst, target)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("atk2")
                EnableEightFaced(inst)
                if target ~= nil and target:IsValid() then
                    if inst.components.combat:TargetIs(target) then
                        inst.components.combat:StartAttack()
                    end
                    inst:ForceFacePoint(target.Transform:GetWorldPosition())
                    inst.sg.statemem.target = target
                end
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/charge")
                inst.components.timer:StopTimer("laserbeam_cd")
                inst.components.timer:StartTimer("laserbeam_cd", TUNING.DEERCLOPS_ATTACK_PERIOD * (math.random(0.8, 1.7)))
            end,

            onupdate = function(inst)
                if inst.sg.statemem.target ~= nil then
                    if inst.sg.statemem.target:IsValid() then
                        local x, y, z = inst.Transform:GetWorldPosition()
                        local x1, y1, z1 = inst.sg.statemem.target.Transform:GetWorldPosition()
                        local dx, dz = x1 - x, z1 - z
                        if dx * dx + dz * dz < 256 and math.abs(anglediff(inst.Transform:GetRotation(), math.atan2( -dz, dx) / DEGREES)) < 45 then
                            inst:ForceFacePoint(x1, y1, z1)
                            return
                        end
                    end
                    inst.sg.statemem.target = nil
                end
                if inst.sg.statemem.lightval ~= nil then
                    inst.sg.statemem.lightval = inst.sg.statemem.lightval * .99
                    SetLightValueAndOverride(inst, inst.sg.statemem.lightval, (inst.sg.statemem.lightval - 1) * 3)
                end
            end,

            timeline =
            {
                TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack", nil) end),
                TimeEvent(4 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step",
                        nil, .7) end),
                TimeEvent(6 * FRAMES, function(inst)
                    ShakeAllCameras(CAMERASHAKE.VERTICAL, .2, .02, .5, inst, SHAKE_DIST)
                    SetLightValue(inst, .97)
                end),
                TimeEvent(7 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1, .2) end),
                TimeEvent(8 * FRAMES, function(inst) SetLightValueAndOverride(inst, .99, .15) end),
                TimeEvent(9 * FRAMES, function(inst) SetLightValueAndOverride(inst, .97, .05) end),
                TimeEvent(10 * FRAMES, function(inst) SetLightValueAndOverride(inst, .96, 0) end),
                TimeEvent(11 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.01, .35) end),
                TimeEvent(12 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1, .3) end),
                TimeEvent(13 * FRAMES, function(inst) SetLightValueAndOverride(inst, .95, .05) end),
                TimeEvent(14 * FRAMES, function(inst) SetLightValueAndOverride(inst, .94, 0) end),
                TimeEvent(15 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1, .3) end),
                TimeEvent(16 * FRAMES, function(inst) SetLightValueAndOverride(inst, .99, .25) end),
                TimeEvent(17 * FRAMES, function(inst) SetLightValueAndOverride(inst, .92, .05) end),
                TimeEvent(18 * FRAMES, function(inst)
                    SetLightValueAndOverride(inst, .9, 0)
                    inst.sg.statemem.target = nil
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl", nil, .4)
                end),
                TimeEvent(19 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/laser")

                    if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                        inst.sg.statemem.target_pos = inst.sg.statemem.target:GetPosition()
                    end
                    local target_pos = inst.sg.statemem.target_pos
                    SpawnLaser_Blue(inst)

                    SetLightValueAndOverride(inst, 1.08, .7)
                end),
                TimeEvent(20 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.12, 1) end),
                TimeEvent(21 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .9) end),
                TimeEvent(22 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.06, .4) end),
                TimeEvent(23 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .6) end),
                TimeEvent(24 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.06, .3) end),
                TimeEvent(25 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.05, .25) end),
                TimeEvent(26 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .5) end),
                TimeEvent(27 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.08, .45) end),
                TimeEvent(28 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.05, .2) end),
                TimeEvent(29 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .3) end),
                TimeEvent(30 * FRAMES, function(inst)
                    inst.sg.statemem.lightval = 1.1
                end),
                TimeEvent(32 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr", nil, .5)
                    inst.sg.statemem.lightval = 1.035
                end),
                TimeEvent(41 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step",
                        nil, .7) end),
                TimeEvent(43 * FRAMES, function(inst)
                    ShakeAllCameras(CAMERASHAKE.VERTICAL, .3, .02, .7, inst, SHAKE_DIST)
                end),
                TimeEvent(47 * FRAMES, function(inst)
                    inst.sg.statemem.lightval = nil
                    SetLightValueAndOverride(inst, .9, 0)
                end),
                TimeEvent(48 * FRAMES, function(inst)
                    inst.sg:RemoveStateTag("busy")
                    SetLightValue(inst, 1)
                end),
            },

            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg.statemem.keepfacing = true
                    inst.sg:GoToState("idle")
                end),
            },

            onexit = function(inst)
                SetLightValueAndOverride(inst, 1, 0)
                SetLightColour(inst, 1)
                if not inst.sg.statemem.keepfacing then
                    DisableEightFaced(inst)
                end
            end,
        },

        State {
            name = "spinbeam_pre",
            tags = { "busy", "nosleep" },

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("ring_pre")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/charge")
                inst.components.timer:StopTimer("laserbeam_cd")
                inst.components.timer:StartTimer("laserbeam_cd", TUNING.DEERCLOPS_ATTACK_PERIOD * (math.random(3) - .5))
            end,

            timeline =
            {
                TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack", nil) end),
                TimeEvent(4 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step",
                        nil, .7) end),
                TimeEvent(6 * FRAMES, function(inst)
                    ShakeAllCameras(CAMERASHAKE.VERTICAL, .2, .02, .5, inst, SHAKE_DIST)
                    SetLightValue(inst, .97)
                end),
                TimeEvent(7 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1, .2) end),
                TimeEvent(8 * FRAMES, function(inst) SetLightValueAndOverride(inst, .99, .15) end),
                TimeEvent(9 * FRAMES, function(inst) SetLightValueAndOverride(inst, .97, .05) end),
                TimeEvent(10 * FRAMES, function(inst) SetLightValueAndOverride(inst, .96, 0) end),
                TimeEvent(11 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.01, .35) end),
                TimeEvent(12 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1, .3) end),
                TimeEvent(13 * FRAMES, function(inst) SetLightValueAndOverride(inst, .95, .05) end),
                TimeEvent(14 * FRAMES, function(inst) SetLightValueAndOverride(inst, .94, 0) end),
                TimeEvent(15 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1, .3) end),
                TimeEvent(16 * FRAMES, function(inst) SetLightValueAndOverride(inst, .99, .25) end),
                TimeEvent(17 * FRAMES, function(inst) SetLightValueAndOverride(inst, .92, .05) end),
                TimeEvent(18 * FRAMES, function(inst)
                    SetLightValueAndOverride(inst, .9, 0)
                    inst.sg.statemem.target = nil
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl", nil, .4)
                end),
            },
            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg:GoToState("spinbeam")
                end),
            },
        },
        State {
            name = "spinbeam",
            tags = { "busy", "attack", "nosleep" },

            onenter = function(inst, target)
                EnableEightFaced(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("ring_loop", true)
                if target ~= nil and target:IsValid() then
                    if inst.components.combat:TargetIs(target) then
                        inst.components.combat:StartAttack()
                    end
                    inst.sg.statemem.target = target
                end
                inst.oldtime = inst.components.combat.laststartattacktime
            end,

            onupdate = function(inst)
                inst.components.combat.laststartattacktime = inst.components.combat.laststartattacktime + 0.1
            end,

            timeline =
            {
                TimeEvent(0 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/laser")

                    if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                        inst.sg.statemem.target_pos = inst.sg.statemem.target:GetPosition()
                    end
                    local target_pos = inst.sg.statemem.target_pos
                    SpawnSweep(inst, target_pos, 1)
                    SpawnSweep(inst, target_pos, 4)
                    SpawnSweep(inst, target_pos, 7)
                    SpawnSweep(inst, target_pos, 10)
                    --SpawnLaser_Blue(inst)

                    --SpawnLaser_Blue(inst)
                    SetLightValueAndOverride(inst, 1.08, .7)
                end),
                TimeEvent(20 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.12, 1) end),
                TimeEvent(21 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .9) end),
                TimeEvent(22 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.06, .4) end),
                TimeEvent(23 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .6) end),
                TimeEvent(24 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.06, .3) end),
                TimeEvent(25 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.05, .25) end),
                TimeEvent(26 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .5) end),
                TimeEvent(27 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.08, .45) end),
                TimeEvent(28 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.05, .2) end),
                TimeEvent(29 * FRAMES, function(inst) SetLightValueAndOverride(inst, 1.1, .3) end),
                TimeEvent(30 * FRAMES, function(inst)
                    inst.sg.statemem.lightval = 1.1
                end),
                TimeEvent(32 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr", nil, .5)
                    inst.sg.statemem.lightval = 1.035
                    SetLightColour(inst, .9)
                end),
                TimeEvent(33 * FRAMES, function(inst) SetLightColour(inst, .8) end),
                TimeEvent(41 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step",
                        nil, .7) end),
                TimeEvent(43 * FRAMES, function(inst)
                    ShakeAllCameras(CAMERASHAKE.VERTICAL, .3, .02, .7, inst, SHAKE_DIST)
                end),
                TimeEvent(47 * FRAMES, function(inst)
                    inst.sg.statemem.lightval = nil
                    SetLightValueAndOverride(inst, .9, 0)
                    SetLightColour(inst, .9)
                end),
                TimeEvent(48 * FRAMES, function(inst)
                    inst.sg:RemoveStateTag("busy")
                    SetLightValue(inst, 1)
                    SetLightColour(inst, 1)
                end),
                TimeEvent(75 * FRAMES, function(inst)
                    inst.sg:GoToState("taunt")
                end),
            },

            --[[events =
        {
            EventHandler("animover", function(inst)
                inst.sg.statemem.keepfacing = true
                inst.sg:GoToState("idle")
            end),
        },]]

            onexit = function(inst)
                inst.components.combat.laststartattacktime = 3
                SetLightValueAndOverride(inst, 1, 0)
                SetLightColour(inst, 1)
                inst.components.timer:StartTimer("spinattack", 10 + math.random(1, 5))
                if inst.components.combat.target ~= nil then
                    inst:ForceFacePoint(inst.components.combat.target.Transform:GetWorldPosition())
                end
                if not inst.sg.statemem.keepfacing then
                    DisableEightFaced(inst)
                end
            end,
        },
        State {
            name = "aurafreeze_pre",
            tags = { "busy", "nosleep", "noshove" },

            onenter = function(inst)
                --inst.components.sleeper:SetResistance(400)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("fortresscast_pre")
                SpawnBlocks(inst, inst:GetPosition(), 19)
                FreezeEverything(inst)
            end,



            timeline =
            {
                TimeEvent(5 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr")
                end),
                TimeEvent(16 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl")
                end),
            },

            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg:GoToState("aurafreeze")
                end),
            },


        },
        State {
            name = "aurafreeze_pst",
            tags = { "busy", "nosleep", "noshove" },

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("fortresscast_pst")
                inst.components.timer:StartTimer("auratime", 24 + math.random(1, 11))
            end,



            timeline =
            {
                TimeEvent(5 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr")
                end),
                TimeEvent(16 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl")
                end),
            },

            events =
            {
                EventHandler("animover", function(inst) --inst.components.sleeper:SetResistance(4)
                    inst.sg:GoToState("idle")
                end),
            },


        },
        State {
            name = "aurafreeze",
            tags = { "busy", "aurafreeze", "nosleep", "noshove"},

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PushAnimation("fortresscast_loop")
            end,



            timeline =
            {

                --[[TimeEvent(16 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl")
            end),]]
            },

            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("aurafreeze") end),
            },


        },
        State {
            name = "aurafreeze_hit",
            tags = { "busy", },

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PushAnimation("fortresscast_hit")
            end,



            timeline =
            {

                --[[TimeEvent(16 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl")
            end),]]
            },

            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("aurafreeze") end),
            },


        },
        State {
            name = "taunt",
            tags = { "busy" },

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("taunt")

                if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.GOHOME then
                    inst:PerformBufferedAction()
                end
            end,

            onupdate = function(inst)
                if inst.sg.statemem.lightval ~= nil then
                    inst.sg.statemem.lightval = inst.sg.statemem.lightval * .99
                    SetLightValue(inst, inst.sg.statemem.lightval)
                end
            end,

            timeline =
            {
                TimeEvent(2 * FRAMES, function(inst) SetLightColour(inst, .9) end),
                TimeEvent(3 * FRAMES, function(inst) SetLightColour(inst, .87) end),
                TimeEvent(4 * FRAMES, function(inst) SetLightColour(inst, .845) end),
                TimeEvent(5 * FRAMES, function(inst)
                    SetLightColour(inst, .825)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_grrr")
                end),
                TimeEvent(6 * FRAMES, function(inst) SetLightColour(inst, .81) end),
                TimeEvent(7 * FRAMES, function(inst) SetLightColour(inst, .8) end),
                TimeEvent(13 * FRAMES, function(inst)
                    inst.sg.statemem.lightval = 1
                end),
                TimeEvent(16 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl")
                end),
                TimeEvent(24 * FRAMES, function(inst)
                    inst.sg.statemem.lightval = nil
                end),
                TimeEvent(41 * FRAMES, function(inst)
                    SetLightValue(inst, .98)
                    SetLightColour(inst, .95)
                end),
                TimeEvent(42 * FRAMES, function(inst)
                    SetLightValue(inst, 1)
                    SetLightColour(inst, 1)
                end),
            },

            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
            },

            onexit = function(inst)
                SetLightValue(inst, 1)
                SetLightColour(inst, 1)
            end,
        },
        State {
            name = "uppercut",
            tags = { "attack", "busy", "heavyhit" },

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("uppercut")
                inst.components.combat:StartAttack()
                inst.components.timer:StopTimer("uppercuttime")
                inst.components.timer:StartTimer("uppercuttime", TUNING.DEERCLOPS_ATTACK_PERIOD * (math.random(1, 3)))
                inst.components.combat:SetDefaultDamage(1.5 * TUNING.DEERCLOPS_DAMAGE)
            end,

            onexit = function(inst)
                inst.components.combat:SetDefaultDamage(TUNING.DEERCLOPS_DAMAGE)
            end,

            timeline =
            {
                TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
                --TimeEvent(29 * FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
                TimeEvent(35 * FRAMES, function(inst)
                    if inst.components.combat.target ~= nil then
                        local target = inst.components.combat.target
                        inst:ForceFacePoint(target.Transform:GetWorldPosition())

                        local x, y, z = inst.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x, 0, z, 8, AREAATTACK_MUST_TAGS, AREA_EXCLUDE_TAGS)

                        if #ents > 0 then
                            for i, ent in ipairs(ents) do
                                if ent ~= inst then
                                    if inst.components.combat:CanTarget(ent) then
                                        local x1, y1, z1 = target.Transform:GetWorldPosition()
                                        local angle = inst:GetAngleToPoint(x1, y1, z1)
                                        local diff = math.abs(inst.Transform:GetRotation() - angle)

                                        if diff > 180 then
                                            diff = 360 - diff
                                        end

                                        if diff <= 45 then
                                            inst.components.combat:DoAttack(ent)
                                        end
                                    end
                                end
                            end
                        end
                    end

                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")


                    if inst.bufferedaction ~= nil and inst.bufferedaction.action == ACTIONS.HAMMER then
                        local target = inst.bufferedaction.target
                        inst:ClearBufferedAction()
                        if target ~= nil and
                            target:IsValid() and
                            target.components.workable ~= nil and
                            target.components.workable:CanBeWorked() and
                            target.components.workable:GetWorkAction() == ACTIONS.HAMMER then
                            target.components.workable:Destroy(inst)
                        end
                    end
                    ShakeAllCameras(CAMERASHAKE.FULL, .5, .025, 1.25, inst, SHAKE_DIST)
                end),
                TimeEvent(36 * FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
            },

            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
            },

        },
        State {
            name = "uppercutcombo",
            tags = { "attack", "busy", "heavyhit", "noice" },

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("uppercutcombo")
                inst.components.combat:StartAttack()
                inst.components.timer:StopTimer("uppercuttime")
                inst.components.timer:StartTimer("uppercuttime", TUNING.DEERCLOPS_ATTACK_PERIOD * (math.random(2, 5)))
                inst.components.combat:SetDefaultDamage(1.5 * TUNING.DEERCLOPS_DAMAGE)

                if inst.components.combat.target ~= nil then
                    local target = inst.components.combat.target
                    inst:ForceFacePoint(target.Transform:GetWorldPosition())
                end
            end,

            onexit = function(inst)
                inst.components.combat:SetDefaultDamage(TUNING.DEERCLOPS_DAMAGE)
            end,

            timeline =
            {
                TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
                --TimeEvent(29 * FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
                TimeEvent(35 * FRAMES, function(inst)
                    if inst.components.combat.target ~= nil then
                        local target = inst.components.combat.target
                        inst:ForceFacePoint(target.Transform:GetWorldPosition())

                        local x, y, z = inst.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x, 0, z, 8, AREAATTACK_MUST_TAGS, AREA_EXCLUDE_TAGS)

                        if #ents > 0 then
                            for i, ent in ipairs(ents) do
                                if ent ~= inst then
                                    if inst.components.combat:CanTarget(ent) then
                                        local x1, y1, z1 = target.Transform:GetWorldPosition()
                                        local angle = inst:GetAngleToPoint(x1, y1, z1)
                                        local diff = math.abs(inst.Transform:GetRotation() - angle)

                                        if diff > 180 then
                                            diff = 360 - diff
                                        end

                                        if diff <= 45 then
                                            inst.components.combat:DoAttack(ent)
                                        end
                                    end
                                end
                            end
                        end
                    end


                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")

                    if inst.bufferedaction ~= nil and inst.bufferedaction.action == ACTIONS.HAMMER then
                        local target = inst.bufferedaction.target
                        inst:ClearBufferedAction()
                        if target ~= nil and
                            target:IsValid() and
                            target.components.workable ~= nil and
                            target.components.workable:CanBeWorked() and
                            target.components.workable:GetWorkAction() == ACTIONS.HAMMER then
                            target.components.workable:Destroy(inst)
                        end
                    end
                    ShakeAllCameras(CAMERASHAKE.FULL, .5, .025, 1.25, inst, SHAKE_DIST)
                end),
                TimeEvent(36 * FRAMES, function(inst)
                    inst.sg:RemoveStateTag("heavyhit")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack")
                end),
                TimeEvent(60 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
                    if inst.components.combat.target ~= nil then
                        local target = inst.components.combat.target
                        inst:ForceFacePoint(target.Transform:GetWorldPosition())
                    end

                    inst.components.locomotor.walkspeed = 20
                    inst.components.locomotor:WalkForward()
                end),

                TimeEvent(70 * FRAMES, function(inst)
                    inst.components.combat:DoAreaAttack(inst, 6, nil, nil, nil,
                        { "INLIMBO", "notarget", "invisible", "noattack", "flight", "playerghost", "shadow",
                            "shadowchesspiece", "shadowcreature" })

                    inst.Physics:Stop()
                end),

            },

            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg:GoToState("idle")
                    inst.components.locomotor.walkspeed = 3
                end),
            },
        },
        State {
            name = "aurattack",
            tags = { "attack", "busy", },

            onenter = function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("atk")
                inst.components.combat:StartAttack()
            end,


            timeline =
            {
                TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
                TimeEvent(29 * FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
                TimeEvent(35 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
                    if inst.attacktime == nil then
                        inst.attacktime = 0
                    end
                    inst.attacktime = inst.attacktime + 1 + math.random(0, 1)
                    if inst.attacktime > 4 or (inst.components.health ~= nil and inst.components.health:GetPercent() < 0.33 and inst.attacktime > 2) then
                        SpawnAttackAuras(inst)
                        inst.attacktime = 0
                    end
                    inst.components.combat:DoAttack(inst.sg.statemem.target)
                    if inst.bufferedaction ~= nil and inst.bufferedaction.action == ACTIONS.HAMMER then
                        local target = inst.bufferedaction.target
                        inst:ClearBufferedAction()
                        if target ~= nil and
                            target:IsValid() and
                            target.components.workable ~= nil and
                            target.components.workable:CanBeWorked() and
                            target.components.workable:GetWorkAction() == ACTIONS.HAMMER then
                            target.components.workable:Destroy(inst)
                        end
                    end
                    ShakeAllCameras(CAMERASHAKE.FULL, .5, .025, 1.25, inst, SHAKE_DIST)
                end),
                TimeEvent(36 * FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
            },

            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
            },

        },
    }

    for k, v in pairs(events) do
        assert(v:is_a(EventHandler), "Non-event added in mod events table!")
        inst.events[v.name] = v
    end

    for k, v in pairs(states) do
        assert(v:is_a(State), "Non-state added in mod state table!")
        inst.states[v.name] = v
    end



    CommonStates.AddCombatStates(states,
        {
            hittimeline =
            {
                TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/hurt") end),
            },
            attacktimeline =
            {
                TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/attack") end),
                TimeEvent(29 * FRAMES, function(inst) SpawnIceFx(inst, inst.components.combat.target) end),
                TimeEvent(35 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
                    print("thiscoderan")
                    print(inst.upgrade)
                    if inst.upgrade == "ice_mutation" then
                        print("triedtoattack")
                        SpawnAttackAuras(inst)
                    end
                    inst.components.combat:DoAttack(inst.sg.statemem.target)
                    if inst.bufferedaction ~= nil and inst.bufferedaction.action == ACTIONS.HAMMER then
                        local target = inst.bufferedaction.target
                        inst:ClearBufferedAction()
                        if target ~= nil and
                            target:IsValid() and
                            target.components.workable ~= nil and
                            target.components.workable:CanBeWorked() and
                            target.components.workable:GetWorkAction() == ACTIONS.HAMMER then
                            target.components.workable:Destroy(inst)
                        end
                    end
                    ShakeAllCameras(CAMERASHAKE.FULL, .5, .025, 1.25, inst, SHAKE_DIST)
                end),
                TimeEvent(36 * FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
            },
            deathtimeline =
            {
                TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/death") end),
                TimeEvent(3 * FRAMES, function(inst) SetLightValue(inst, 1.01) end),
                TimeEvent(4 * FRAMES, function(inst) SetLightValue(inst, 1.025) end),
                TimeEvent(5 * FRAMES, function(inst) SetLightValue(inst, 1.045) end),
                TimeEvent(6 * FRAMES, function(inst) SetLightValue(inst, 1.07) end),
                TimeEvent(32 * FRAMES, function(inst)
                    if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
                        local player --[[, rangesq]] = inst:GetNearestPlayer()
                        LaunchAt(SpawnPrefab("winter_ornament_light1"), inst, player, 1, 6, .5)
                        inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
                    end
                end),
                TimeEvent(33 * FRAMES, function(inst)
                    SetLightValue(inst, 1.05)
                    SetLightColour(inst, .95)
                end),
                TimeEvent(34 * FRAMES, function(inst)
                    SetLightValue(inst, 1.01)
                    SetLightColour(inst, .85)
                end),
                TimeEvent(35 * FRAMES, function(inst)
                    SetLightValue(inst, 1)
                    SetLightColour(inst, .75)
                end),
                TimeEvent(36 * FRAMES, function(inst)
                    SetLightColour(inst, .7)
                end),
                TimeEvent(48 * FRAMES, function(inst)
                    if inst.Light ~= nil then
                        local k = 1
                        local task
                        task = inst:DoPeriodicTask(0, function(inst)
                            k = k - .025
                            if k > 0 then
                                SetLightValue(inst, k)
                            else
                                inst.Light:Enable(false)
                                task:Cancel()
                            end
                        end)
                    end
                end),
                TimeEvent(50 * FRAMES, function(inst)
                    if TheWorld.state.snowlevel > 0.02 then
                        inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_snow")
                    else
                        inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/bodyfall_dirt")
                    end
                    ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, 2, inst, SHAKE_DIST)
                end),
            },
        })

    CommonStates.AddSleepStates(states,
        {
            starttimeline =
            {
                TimeEvent(1 * FRAMES, function(inst) SetLightValue(inst, .995) end),
                TimeEvent(2 * FRAMES, function(inst) SetLightValue(inst, .99) end),
                TimeEvent(3 * FRAMES, function(inst) SetLightValue(inst, .98) end),
                TimeEvent(4 * FRAMES, function(inst) SetLightValue(inst, .97) end),
                TimeEvent(5 * FRAMES, function(inst) SetLightValue(inst, .96) end),
                TimeEvent(6 * FRAMES, function(inst) SetLightValue(inst, .95) end),
                TimeEvent(7 * FRAMES, function(inst) SetLightValue(inst, .945) end),
                TimeEvent(38 * FRAMES, function(inst) SetLightColour(inst, .95) end),
                TimeEvent(39 * FRAMES, function(inst) SetLightColour(inst, .9) end),
                TimeEvent(40 * FRAMES, function(inst) SetLightColour(inst, .8) end),
                TimeEvent(41 * FRAMES, function(inst) SetLightColour(inst, .75) end),
            },
            sleeptimeline =
            {
                --TimeEvent(46*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
            },
            waketimeline =
            {
                TimeEvent(2 * FRAMES, function(inst) SetLightColour(inst, .9) end),
                TimeEvent(3 * FRAMES, function(inst) SetLightColour(inst, 1) end),
                TimeEvent(36 * FRAMES, function(inst) SetLightValue(inst, .99) end),
                TimeEvent(37 * FRAMES, function(inst) SetLightValue(inst, 1) end),
            },
        },
        {
            onsleep = function(inst)
                SetLightValue(inst, 1)
                SetLightColour(inst, 1)
            end,
            onwake = function(inst)
                SetLightValue(inst, .945)
                SetLightColour(inst, .75)
            end,
        })
end)

env.AddStategraphState("deerclops",
    State {
        name = "fall",
        tags = { "busy" },
        onenter = function(inst, data)
            inst.Physics:SetDamping(0)
            inst.Physics:SetMotorVel(0, -20 + math.random() * 10, 0)
            inst.AnimState:PlayAnimation("falling_loop", true)
        end,

        onupdate = function(inst)
            local pt = Point(inst.Transform:GetWorldPosition())
            if pt.y < 2 then
                inst.Physics:SetMotorVel(0, 0, 0)
                --inst.components.groundpounder.groundpoundfx = "deerclops_ground_fx"
                --inst.components.groundpounder:GroundPound()
                --inst.components.groundpounder.groundpoundfx = nil

                --local sinkhole = SpawnPrefab("bearger_sinkhole")
                --sinkhole.Transform:SetPosition(pt.x, 0, pt.z)
                --sinkhole.components.timer:StartTimer("nextrepair", 30 + (math.random() * 20))

                pt.y = 0

                inst.Physics:Stop()
                inst.Physics:SetDamping(5)
                inst.Physics:Teleport(pt.x, pt.y, pt.z)
                inst.DynamicShadow:Enable(true)

                inst.sg:GoToState("groundpound")
            end
        end,

    }
)
env.AddStategraphState("deerclops",
    State {
        name = "groundpound",
        tags = { "busy" },
        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("fallattack", true)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    }
)

local env = env
GLOBAL.setfenv(1, GLOBAL)

local function DoScreech(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, 1, .015, .3, inst, 30)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/taunt")
end

local function DoScreechAlert(inst)
    inst.components.epicscare:Scare(5)
    inst.components.commander:AlertAllSoldiers()
end

local function FaceTarget(inst)
    local target = inst.components.combat.target
    if inst.sg.mem.focustargets ~= nil then
        local mindistsq = math.huge
        for i = #inst.sg.mem.focustargets, 1, -1 do
            local v = inst.sg.mem.focustargets[i]
            if v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and
                not v:HasTag("playerghost") then
                local distsq = inst:GetDistanceSqToInst(v)
                if distsq < mindistsq then
                    mindistsq = distsq
                    target = v
                end
            else
                table.remove(inst.sg.mem.focustargets, i)
                if #inst.sg.mem.focustargets <= 0 then
                    inst.sg.mem.focustargets = nil
                    break
                end
            end
        end
    end
    if target ~= nil and target:IsValid() then
        inst:ForceFacePoint(target.Transform:GetWorldPosition())
    end
end

local function SetSpinSpeed(inst, speed, changeDir)
    if inst.beeHolder then
        for i, beeHolder in ipairs(inst.beeHolder) do
            beeHolder.components.linearcircler.setspeed = speed
        end
    end
end

local function StartFlapping(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")
end

local function RestoreFlapping(inst)
    if not inst.SoundEmitter:PlayingSound("flying") then
        StartFlapping(inst)
    end
end

local function StopFlapping(inst)
    inst.SoundEmitter:KillSound("flying")
end

local function SpinWall(inst, speed)
    if inst.defensebees then
        for i, bee in ipairs(inst.defensebees) do
            if bee.components.health and not bee.components.health:IsDead() and bee.components.linearcircler then
                bee.components.linearcircler.setspeed = speed
            end
        end
    end
end

local function Honey(inst, angle, count, variation, slowness)
    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
        local fx = SpawnPrefab((inst.prefab == "cherry_beequeen" or inst.prefab == "cherry_honey_trail") and
            "cherry_honey_trail" or "honey_trail")
        if inst.prefab == "cherry_beequeen" or inst.prefab == "cherry_honey_trail" then
            fx.slowness = inst.flowerbuffs ~= nil and fx.slowness + inst.flowerbuffs.honeyslowness or slowness
        end

        if not variation then
            variation = 0
        end

        fx.Transform:SetPosition(x + 2 * math.cos(angle) + variation * math.cos(angle + 3.14 / 2), 0,
            z + 2 * math.sin(angle) + variation * math.sin(angle + 3.14 / 2))
        fx:SetVariation(math.random(1, 7), GetRandomMinMax(1, 1.3), 4)
        fx.count = count - 1
        fx.angle = angle

        if count > 0 then
            fx:DoTaskInTime(0.2, function(fx)
                Honey(fx, fx.angle, fx.count, nil, fx.slowness)
            end)
        end
    else
        SpawnPrefab("ocean_splash_ripple" .. tostring(math.random(2))).Transform:SetPosition(x, 0, z)
    end
end

local function SpillHoney(inst)
    local angle = -inst.Transform:GetRotation() * DEGREES
    Honey(inst, angle, 10, -2)
    Honey(inst, angle, 10, 2)
    Honey(inst, angle, 10, 0)
end

env.AddStategraphPostInit("SGbeequeen",
    function(inst) --For some reason it's called "SGbeequeen" instead of just... beequeen, funky
        local _OldOnExit
        if inst.states["spawnguards"].onexit then
            _OldOnExit = inst.states["spawnguards"].onexit
        end

        table.insert(inst.states["spawnguards"].tags, "ability") -- This is added such that the stomphandler can recognize the spawnguards move as an ability

        inst.states["spawnguards"].onexit = function(inst)
            inst.abilitybusy = nil
            inst.PstSummonHandler(inst)
            if _OldOnExit then
                _OldOnExit(inst)
            end
        end

        --[[local _OldOnAtkEnter --Deprecated bq combo attack code.
	if inst.states["attack"].onenter then
		_OldOnAtkEnter = inst.states["attack"].onenter
	end

	inst.states["attack"].onenter = function(inst)
		if not inst.comboing and not (inst.components.commander:GetAllSoldiers() and #inst.components.commander:GetAllSoldiers() > 0) then
			--TheNet:Announce("doing this")
			inst.sg:GoToState("combo_prep")
		else
			TheNet:Announce("doing that")
			if _OldOnAtkEnter then
				_OldOnAtkEnter(inst)
			end
		end
	end]]
        local _OldOnHit
        if inst.states["hit"].onexit then
            _OldOnHit = inst.states["hit"].onexit
        end
        inst.states["hit"].onexit = function(inst)
            if _OldOnHit then
                _OldOnHit(inst)
            end
            if not inst.abilitybusy then
                inst.ActivateHitAbility(inst)
            end
        end


        local events =
        {
        }

        local states = {
            State {
                name = "stomp",
                tags = { "busy", "nosleep", "nofreeze", "ability" },

                onenter = function(inst)
                    --inst.brain:Stop()
                    --StopFlapping(inst)
                    inst.Transform:SetNoFaced()
                    inst.components.locomotor:StopMoving()
                    inst.components.health:SetInvincible(true)
                    inst.AnimState:PlayAnimation("stomp_pre")
                    inst.AnimState:PushAnimation("stomp", false)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/enter")
                    inst.sg.mem.wantstoscreech = true
                end,

                timeline =
                {
                    CommonHandlers.OnNoSleepTimeEvent(38 * FRAMES, function(inst)
                        local function isvalid(ent)
                            local tags = { "INLIMBO", "epic", "notarget", "invisible", "noattack", "flight",
                                "playerghost", "shadow", "shadowchesspiece", "shadowcreature", "bee", "beehive" }
                            for i, v in ipairs(tags) do
                                if ent:HasTag(v) then
                                    return false
                                end
                            end
                            return true
                        end

                        local x, y, z = inst.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x, y, z, 6, "_combat")
                        for i, ent in ipairs(ents) do
                            if (isvalid(ent)) and ent.components.health and not ent.components.health:IsDead() and
                                ent.components.combat then --Support for the other sort of bees
                                ent.components.combat:GetAttacked(inst, 200)
                            end
                        end
                        inst.components.groundpounder:GroundPound()
                    end),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("screech"),
                },

                onexit = function(inst)
                    --RestoreFlapping(inst)
                    inst.Transform:SetSixFaced()
                    inst.components.health:SetInvincible(false)
                end,
            },
            State {
                name = "lob",
                tags = { "busy", "nosleep", "nofreeze", "ability" },

                onenter = function(inst)
                    --inst.brain:Stop()
                    --StopFlapping(inst)
                    if inst.components.combat and inst.components.combat.target then
                        inst:ForceFacePoint(inst.components.combat.target:GetPosition())
                    end
                    inst.components.locomotor:StopMoving()
                    inst.components.health:SetInvincible(true)
                    inst.AnimState:PlayAnimation("atk")
                end,

                timeline =
                {
                    CommonHandlers.OnNoSleepTimeEvent(10 * FRAMES, SpillHoney),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("screech"),
                },

                onexit = function(inst)
                    --RestoreFlapping(inst)
                    inst.Transform:SetSixFaced()
                    inst.components.health:SetInvincible(false)
                end,
            },
            State {
                name = "stomp_combo",
                tags = { "busy", "nosleep", "nofreeze", "ability" },

                onenter = function(inst)
                    --inst.brain:Stop()
                    --StopFlapping(inst)
                    inst.Transform:SetNoFaced()
                    inst.components.locomotor:StopMoving()
                    inst.components.health:SetInvincible(true)
                    inst.AnimState:PushAnimation("stomp", false)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/enter")
                    if not inst.tiredcount then
                        inst.tiredcount = 12
                    end
                end,

                timeline =
                {
                    CommonHandlers.OnNoSleepTimeEvent(38 * FRAMES, function(inst)
                        local function isvalid(ent)
                            local tags = { "INLIMBO", "epic", "notarget", "invisible", "noattack", "flight",
                                "playerghost", "shadow", "shadowchesspiece", "shadowcreature", "bee", "beehive" }
                            for i, v in ipairs(tags) do
                                if ent:HasTag(v) then
                                    return false
                                end
                            end
                            return true
                        end

                        local x, y, z = inst.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x, y, z, 6, "_combat")
                        for i, ent in ipairs(ents) do
                            if (isvalid(ent)) and ent.components.health and not ent.components.health:IsDead() and
                                ent.components.combat then --Support for the other sort of bees
                                ent.components.combat:GetAttacked(inst, 200)
                            end
                        end
                        inst.components.groundpounder:GroundPound()
                    end),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("tired_loop"),
                },

                onexit = function(inst)
                    --RestoreFlapping(inst)
                    inst.Transform:SetSixFaced()
                    inst.components.health:SetInvincible(false)
                end,
            },

            State {
                name = "command_mortar",
                tags = { "busy", "nosleep", "nofreeze", "ability" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("command2")
                end,

                timeline =
                {
                    TimeEvent(8 * FRAMES, DoScreech),
                    TimeEvent(9 * FRAMES, DoScreechAlert),
                    TimeEvent(11 * FRAMES, function(inst)
                        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
                    end),
                    TimeEvent(18 * FRAMES, function(inst)
                        inst.sg.mem.wantstofocustarget = nil

                        local soldiers = inst.components.commander:GetAllSoldiers()
                        if #soldiers > 0 and inst.components.combat and inst.components.combat.target then
                            for i, soldier in ipairs(soldiers) do
                                soldier:MortarAttack(soldier)
                            end
                        end
                        if inst.seekerbees then
                            for i, seeker in ipairs(inst.seekerbees) do
                                if not seeker.sg:HasStateTag("mortar") then
                                    local x, y, z = seeker.Transform:GetWorldPosition()
                                    seeker:RemoveComponent("linearcircler")
                                    if x ~= nil and y ~= nil and z ~= nil then
                                        seeker.Transform:SetPosition(x, y, z)
                                    end
                                    seeker:MortarAttack(seeker)
                                end
                            end
                        end
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(25 * FRAMES, function(inst)
                        inst.sg:AddStateTag("caninterrupt")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                    end),
                },

                onexit = function(inst)
                    inst.components.sanityaura.aura = 0
                end,

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("idle"),
                },

            },
            State {
                name = "defensive_spin",
                tags = { "busy", "ability" },

                onenter = function(inst)
                    inst.defensivespincount = math.random(3, 5)
                    inst.AnimState:PlayAnimation("command1")
                    inst.AnimState:PushAnimation("command3", false)
                    FaceTarget(inst)
                    inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
                    inst.components.locomotor:StopMoving()
                end,

                timeline =
                {
                    TimeEvent(8 * FRAMES, DoScreech),
                    TimeEvent(9 * FRAMES, DoScreechAlert),
                    TimeEvent(11 * FRAMES, function(inst)
                        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
                    end),
                },

                onexit = function(inst)
                    SpinWall(inst, 0.1)
                    inst:DoTaskInTime(math.random(2, 3), function(inst) SpinWall(inst, 0) end)
                    inst.components.sanityaura.aura = 0
                end,

                events =
                {
                    EventHandler("animqueueover", function(inst)
                        inst.sg:GoToState("idle")
                    end),
                },
            },

            State {
                name = "tired", --Bee Queen is Tired after rapidly commanding the army
                tags = { "busy", "ability", "tired" },

                onenter = function(inst)
                    inst.components.timer:PauseTimer("spawnguards_cd")
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("tired_pre")
                    inst.AnimState:PushAnimation("tired_loop", true)
                    if not inst.tiredcount then
                        inst.tiredcount = 12
                    end
                    inst.tiredtask = inst:DoPeriodicTask(1, function(inst) inst.tiredcount = inst.tiredcount - 1 end)
                end,

                timeline =
                {
                    TimeEvent(9 * FRAMES, StopFlapping),
                },

                onupdate = function(inst)
                    if inst.tiredcount < 0 then
                        if inst.components.health and not inst.components.health:IsDead() then
                            inst.sg:GoToState("tired_pst")
                        else
                            inst.sg:GoToState("death")
                        end
                    end
                end,

                onexit = function(inst)
                    inst.tiredtask:Cancel()
                    inst.tiredtask = nil
                    inst.tiredcount = nil
                    inst.components.timer:ResumeTimer("spawnguards_cd")
                    inst:RemoveTag("doingability")
                end,
            },
            State {
                name = "tired_pst", --Bee Queen is Tired after rapidly commanding the army
                tags = { "busy", "ability" },

                onenter = function(inst)
                    inst.AnimState:PlayAnimation("tired_pst")
                end,

                events =
                {
                    EventHandler("animover", function(inst)
                        StartFlapping(inst)
                        if inst.components.health and not inst.components.health:IsDead() then
                            inst.sg:GoToState("idle")
                        else
                            inst.sg:GoToState("death")
                        end
                    end),
                },

            },
            State {
                name = "spawnguards_wall",
                tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("spawn")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
                end,

                timeline =
                {
                    TimeEvent(16 * FRAMES, function(inst)
                        if inst.components.health:GetPercent() > 0.5 then
                            inst.SpawnDefensiveBees(inst)
                        else
                            inst.SpawnDefensiveBeesII(inst)
                        end
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                        inst.sg:RemoveStateTag("busy")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                    end),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("idle"),
                },
            },
            State {
                name = "spawnguards_wall_shooter",
                tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("spawn")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
                end,

                timeline =
                {
                    TimeEvent(16 * FRAMES, function(inst)
                        inst.defensivecircle = true
                        inst.SpawnShooterBeesCircle(inst)
                        if inst.bonuswall then
                            inst.bonuswall = nil
                            inst.SpawnDefensiveBeesII(inst)
                        end
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                        inst.sg:RemoveStateTag("busy")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                    end),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("idle"),
                },
            },
            State {
                name = "spawnguards_shooter_circle",
                tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("spawn")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
                end,

                timeline =
                {
                    TimeEvent(16 * FRAMES, function(inst)
                        local priotarget = inst.shoottargets[1]
                        table.remove(inst.shoottargets, 1)
                        inst.SpawnShooterBeesCircle(inst, priotarget)
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                        inst.sg:RemoveStateTag("busy")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                    end),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("idle"),
                },
                onexit = function(inst) --Unfinished business, need to shoot more ppl.
                    if inst.shoottargets and inst.shoottargets[1] then
                        inst:DoTaskInTime(1, function(inst)
                            if inst.components.health and not inst.components.health:IsDead() then
                                inst.sg:GoToState("spawnguards_shooter_circle")
                            end
                        end)
                    else
                        inst.tiredcount = 15
                        inst:DoTaskInTime(0, function(inst)
                            if inst.components.health and not inst.components.health:IsDead() then
                                inst.sg:GoToState("tired")
                            else
                                inst.sg:GoToState("death")
                            end
                        end)
                    end
                end,
            },
            State {
                name = "spawnguards_shooter_line",
                tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    --inst.components.timer:PauseTimer("spawnguards_cd")
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("spawn")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
                end,

                timeline =
                {
                    TimeEvent(16 * FRAMES, function(inst)
                        inst.SpawnShooterBeesLine(inst, 5, inst.ffdir)
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                        inst.sg:RemoveStateTag("busy")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                    end),
                },
                onexit = function(inst)
                    --inst.components.timer:ResumeTimer("spawnguards_cd")
                end,
                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("idle"),
                },
            },
            State {
                name = "spawn_support",
                tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("spawn")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
                end,

                timeline =
                {
                    TimeEvent(16 * FRAMES, function(inst)
                        inst.SpawnSupport(inst)
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                        inst.sg:RemoveStateTag("busy")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                    end),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("idle"),
                },
            },
            State {
                name = "spawnguards_seeker",
                tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("spawn")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
                end,

                timeline =
                {
                    TimeEvent(16 * FRAMES, function(inst)
                        inst.SpawnSeekerBees(inst)
                        if inst.bonuswall then
                            inst.bonuswall = nil
                            inst.SpawnDefensiveBeesII(inst)
                        end
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                        inst.sg:RemoveStateTag("busy")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                        inst:DoTaskInTime(0, function(inst)
                            if inst.components.health and not inst.components.health:IsDead() then
                                inst.sg:GoToState("command_mortar")
                            end
                        end)
                    end),
                },

                events =
                {
                    --CommonHandlers.OnNoSleepAnimOver("command_mortar"), --for some reason this isn't working, taunting happens instead, so dotaskintime(0 is just going to have to be how we do it in these heavy edit postinit casess
                },
            },
            State {
                name = "spawnguards_seeker_quick",
                tags = { "spawnguards", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("spawn")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/spawn")
                    inst.seekercount = inst.seekercount - 1
                end,

                timeline =
                {
                    TimeEvent(16 * FRAMES, function(inst)
                        inst.SpawnSeekerBees(inst)
                    end),
                    CommonHandlers.OnNoSleepTimeEvent(32 * FRAMES, function(inst)
                        inst.sg:RemoveStateTag("busy")
                        inst.sg:RemoveStateTag("nosleep")
                        inst.sg:RemoveStateTag("nofreeze")
                    end),
                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("idle"),
                },
                onexit = function(inst)
                    local target
                    if inst.seeker_hitlist and #inst.seeker_hitlist > 1 then
                        local possibletarget = inst.seeker_hitlist[inst.seekercount + 1]
                        if possibletarget and possibletarget.components.health and
                            not possibletarget.components.health:IsDead() and not possibletarget:HasTag("playerghost") then
                            target = possibletarget
                        else
                            local choice = math.random(1, #inst.seeker_hitlist)
                            possibletarget = inst.seeker_hitlist[choice]
                            if possibletarget and possibletarget.components.health and
                                not possibletarget.components.health:IsDead() and
                                not possibletarget:HasTag("playerghost") then
                                target = possibletarget
                            else
                                target = inst.components.combat.target
                            end
                        end
                    else
                        target = inst.components.combat.target
                    end

                    if target then
                        if inst.seekerbees then
                            for i, seeker in ipairs(inst.seekerbees) do
                                if not seeker.sg:HasStateTag("mortar") then
                                    local x, y, z = seeker.Transform:GetWorldPosition()
                                    seeker:RemoveComponent("linearcircler")
                                    if x ~= nil and y ~= nil and z ~= nil then
                                        seeker.Transform:SetPosition(x, y, z)
                                    end
                                    seeker:MortarAttack(seeker, target, 0.5)
                                end
                            end
                        end
                    end
                    inst:DoTaskInTime(0, function(inst)
                        if inst.seekercount > 0 then
                            inst:DoTaskInTime(0.1, function(inst)
                                if inst.components.health and not inst.components.health:IsDead() then
                                    inst.sg:GoToState("spawnguards_seeker_quick")
                                end
                            end) -- Lil bit of a gap
                        else
                            inst:RemoveTag("doingability")
                            inst.components.timer:ResumeTimer("spawnguards_cd")
                            local x, y, z = inst.Transform:GetWorldPosition()
                            local players = TheSim:FindEntities(x, y, z, 30, { "player" }, { "playerghost" }) --more bees for more players
                            inst.seekercount = math.random(4, 5) + 2 * #players
                            inst.tiredcount = 12
                            if inst.components.health and not inst.components.health:IsDead() then
                                inst.sg:GoToState("tired")
                            else
                                inst.sg:GoToState("death")
                            end
                        end
                    end)
                end,
            },
            State {
                name = "combo_prep",
                tags = { "ability", "busy", "nosleep", "nofreeze" },

                onenter = function(inst)
                    FaceTarget(inst)
                    inst.components.locomotor:StopMoving()
                    inst.AnimState:PlayAnimation("combotaunt")
                    inst.comboing = true
                    inst.combocount = 3
                end,

                timeline =
                {

                },

                events =
                {
                    CommonHandlers.OnNoSleepAnimOver("attack"),
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
    end)

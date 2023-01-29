require("stategraphs/commonstates")

--just joinking these...

local function TrySplashFX(inst, size)
    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsOceanAtPoint(x, 0, z) then
        SpawnPrefab("ocean_splash_" .. (size or "med") .. tostring(math.random(2))).Transform:SetPosition(x, 0, z)
        return true
    end
end

local function NotBlocked(pt)
    return not TheWorld.Map:IsGroundTargetBlocked(pt)
end

local function IsNearTarget(inst, target, range)
	return inst:IsNear(target, range + target:GetPhysicsRadius(0))
end

local function IsLeaderNear(inst, leader, target, range)
    --leader is in range of us or our target
    return inst:IsNear(leader, range) or (target ~= nil and IsNearTarget(leader, target, range))
end

local function CheckLeaderShadowLevel(inst, target)
    local level = 0
    local leader = inst.components.follower:GetLeader()
    if leader ~= nil and
        leader.components.inventory ~= nil and
        IsLeaderNear(inst, leader, target, TUNING.SHADOWWAXWELL_PROTECTOR_SHADOW_LEADER_RADIUS)
    then
        for k, v in pairs(EQUIPSLOTS) do
            local equip = leader.components.inventory:GetEquippedItem(v)
            if equip ~= nil and equip.components.shadowlevel ~= nil then
                level = level + equip.components.shadowlevel:GetCurrentLevel()
            end
        end
    end

    --Scale damage
    inst.components.combat:SetDefaultDamage(TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE +
        level * TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE_BONUS_PER_LEVEL)
end

local actionhandlers =
{
    ActionHandler(ACTIONS.CHOP,
        function(inst)
            if not inst.sg:HasStateTag("prechop") then
                if inst.sg:HasStateTag("chopping") then
                    return "chop"
                else
                    return "chop_start"
                end
            end
        end),
    ActionHandler(ACTIONS.MINE,
        function(inst)
            if not inst.sg:HasStateTag("premine") then
                if inst.sg:HasStateTag("mining") then
                    return "mine"
                else
                    return "mine_start"
                end
            end
        end),
}

local events =
{
    CommonHandlers.OnLocomote(true, false),
    --CommonHandlers.OnAttacked(),
    EventHandler("attacked", function(inst, data)
        if not (inst.components.health:IsDead() or inst.components.health:IsInvincible()) then
            inst.sg:GoToState("disappear", data ~= nil and data.attacker or nil)
        end
    end),
    CommonHandlers.OnDeath(),
    ---CommonHandlers.OnAttack(),
    EventHandler("doattack", function(inst, data)
        if inst.components.health ~= nil and not inst.components.health:IsDead() then
            if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if math.random() > 0.5 then
                    inst.sg:GoToState("lunge_pre", data ~= nil and data.target or nil)
                else
                    inst.sg:GoToState("attack", data ~= nil and data.target or nil)
                end
            end

        end
    end),
    EventHandler("dance", function(inst)
        if not inst.sg:HasStateTag("busy") and (inst._brain_dancedata ~= nil or not inst.sg:HasStateTag("dancing")) then
            inst.sg:GoToState("dance")
        end
    end),
}

local states =
{
    State {
        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
    },

    State {
        name = "run_start",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")
            inst.sg.mem.foosteps = 0
        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },

    },

    State {
        name = "run",
        tags = { "moving", "running", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_loop")

        end,

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },
    },

    State {

        name = "run_stop",
        tags = { "canrotate", "idle" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("run_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

    },

    State {
        name = "attack",
        tags = { "attack", "abouttoattack", "busy" },

        onenter = function(inst, target)
            inst.equipfn(inst, inst.items["SWORD"])
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")

            inst.components.combat:StartAttack()
            if target == nil then
                target = inst.components.combat.target
            end
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                local target = inst.sg.statemem.target
                CheckLeaderShadowLevel(inst, target ~= nil and target:IsValid() and target or nil)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
            TimeEvent(12 * FRAMES, function(inst) -- Keep FRAMES time synced up with ShouldKiteProtector.
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(13 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
    },

    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst:DoTaskInTime(1, function()
                    SpawnPrefab("statue_transition").Transform:SetPosition(inst:GetPosition():Get())
                    SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
                    inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_despawn")
                    inst:Remove()
                end)
            end),
        },
    },

    State {
        name = "hit",
        tags = { "busy" },

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },
    },

    State {
        name = "stunned",
        tags = { "busy", "canrotate" },

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_sanity_pre")
            inst.AnimState:PushAnimation("idle_sanity_loop", true)
            inst.sg:SetTimeout(5)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

    State { name = "chop_start",
        tags = { "prechop", "chopping", "working" },
        onenter = function(inst)
            inst.equipfn(inst, inst.items["AXE"])
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("chop_pre")

        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("chop") end),
        },
    },

    State {
        name = "chop",
        tags = { "prechop", "chopping", "working" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("chop_loop")
        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("prechop")
            end),

            TimeEvent(16 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("chopping")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State {
        name = "mine_start",
        tags = { "premine", "working" },
        onenter = function(inst)
            inst.equipfn(inst, inst.items["PICK"])
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pickaxe_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("mine") end),
        },
    },

    State {
        name = "mine",
        tags = { "premine", "mining", "working" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("pickaxe_loop")
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("premine")
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_pick_rock")
            end),

            -- TimeEvent(14*FRAMES, function(inst)
            --     if  inst.sg.statemem.action and
            --         inst.sg.statemem.action.target and
            --         inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action) and
            --         inst.sg.statemem.action.target.components.workable then
            --             inst:ClearBufferedAction()
            --             inst:PushBufferedAction(inst.sg.statemem.action)
            --     end
            -- end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.AnimState:PlayAnimation("pickaxe_pst")
                inst.sg:GoToState("idle", true)
            end),
        },
    },

    State {
        name = "dance",
        tags = { "idle", "dancing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
            if inst.AnimState:IsCurrentAnimation("run_pst") then
                inst.AnimState:PushAnimation("emoteXL_pre_dance0")
            else
                inst.AnimState:PlayAnimation("emoteXL_pre_dance0")
            end
            inst.AnimState:PushAnimation("emoteXL_loop_dance0", true)
        end,
    },

    State {
        name = "jumpout",
        tags = { "busy", "canrotate", "jumping" },

        onenter = function(inst)
            inst.x = math.random(-4, 4)
            inst.z = math.random(-4, 4)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("jumpout")
            inst.Physics:SetMotorVel(inst.x, 0, inst.z)
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(inst.x * 0.75, 0, inst.z * 0.75)
            end),
            TimeEvent(15 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(inst.x * 0.5, 0, inst.z * 0.5)
            end),
            TimeEvent(17 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(inst.x * 0.25, 0, inst.z * 0.25)
            end),
            TimeEvent(18 * FRAMES, function(inst)
                inst.Physics:Stop()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
    State {
        name = "lunge_pre",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst:StopBrain()
            inst.components.locomotor:Stop()
            inst.AnimState:SetBankAndPlayAnimation("lavaarena_shadow_lunge", "lunge_pre")

            inst.components.combat:StartAttack()
            if target == nil then
                target = inst.components.combat.target
            end
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst.sg.statemem.targetpos = target:GetPosition()
                inst:ForceFacePoint(inst.sg.statemem.targetpos:Get())
            end
        end,

        onupdate = function(inst)
            if inst.sg.statemem.target ~= nil then
                if inst.sg.statemem.target:IsValid() then
                    inst.sg.statemem.targetpos = inst.sg.statemem.target:GetPosition()
                else
                    inst.sg.statemem.target = nil
                end
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg.statemem.lunge = true
                    inst.sg:GoToState("lunge_loop",
                        { target = inst.sg.statemem.target, targetpos = inst.sg.statemem.targetpos })
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.lunge then
                inst.components.combat:CancelAttack()
                inst:RestartBrain()
                inst.AnimState:SetBank("wilson")
            end
        end,
    },

    State {
        name = "lunge_loop",
        tags = { "attack", "busy", "noattack", "temp_invincible" },

        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("lunge_loop") --NOTE: this anim NOT a loop yo
            inst.Physics:ClearCollidesWith(COLLISION.GIANTS)
            ToggleOffCharacterCollisions(inst)
            TrySplashFX(inst)

            if inst.components.timer ~= nil then
                inst.components.timer:StopTimer("shadowstrike_cd")
                inst.components.timer:StartTimer("shadowstrike_cd", TUNING.SHADOWWAXWELL_SHADOWSTRIKE_COOLDOWN)
            end

            inst:PushEvent("forcelosecombattarget")

            if data ~= nil then
                if data.target ~= nil and data.target:IsValid() then
                    inst.sg.statemem.target = data.target
                    inst:ForceFacePoint(data.target.Transform:GetWorldPosition())
                elseif data.targetpos ~= nil then
                    inst:ForceFacePoint(data.targetpos)
                end
            end
            inst.Physics:SetMotorVelOverride(35, 0, 0)

            inst.sg:SetTimeout(8 * FRAMES)
        end,

        onupdate = function(inst)
            if inst.sg.statemem.attackdone then
                return
            end
            local target = inst.sg.statemem.target
            if target == nil or not target:IsValid() then
                if inst.sg.statemem.animdone then
                    inst.sg.statemem.lunge = true
                    inst.sg:GoToState("lunge_pst")
                    return
                end
                inst.sg.statemem.target = nil
            elseif inst:IsNear(target, 1) then
                local fx = SpawnPrefab(math.random() < .5 and "shadowstrike_slash_fx" or "shadowstrike_slash2_fx")
                local x, y, z = target.Transform:GetWorldPosition()
                fx.Transform:SetPosition(x, y + 1.5, z)
                fx.Transform:SetRotation(inst.Transform:GetRotation())

                inst.components.combat.externaldamagemultipliers:SetModifier(inst,
                    TUNING.SHADOWWAXWELL_SHADOWSTRIKE_DAMAGE_MULT, "shadowstrike")
                inst.components.combat:DoAttack(target)
                if inst.sg.statemem.animdone then
                    inst.sg.statemem.lunge = true
                    inst.sg:GoToState("lunge_pst", target)
                    return
                end
                inst.sg.statemem.attackdone = true
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg.statemem.attackdone or inst.sg.statemem.target == nil then
                        inst.sg.statemem.lunge = true
                        inst.sg:GoToState("lunge_pst", inst.sg.statemem.target)
                        return
                    end
                    inst.sg.statemem.animdone = true
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg.statemem.lunge = true
            inst.sg:GoToState("lunge_pst")
        end,

        onexit = function(inst)
            inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "shadowstrike")
            inst.components.combat:SetRange(2)
            if not inst.sg.statemem.lunge then
                inst:RestartBrain()
                inst.AnimState:SetBank("wilson")
                inst.Physics:CollidesWith(COLLISION.GIANTS)
                ToggleOnCharacterCollisions(inst)
            end
        end,
    },

    State {
        name = "disappear",
        tags = { "busy", "noattack", "temp_invincible" },

        onenter = function(inst, attacker)
            inst.components.locomotor:Stop()
            ToggleOffCharacterCollisions(inst)
            inst.AnimState:PlayAnimation("disappear")
            if attacker ~= nil and attacker:IsValid() then
                inst.sg.statemem.attackerpos = attacker:GetPosition()
            end
            TrySplashFX(inst, "small")
            inst:PushEvent("forcelosecombattarget")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local theta =
                    inst.sg.statemem.attackerpos ~= nil and
                        inst:GetAngleToPoint(inst.sg.statemem.attackerpos) or
                        inst.Transform:GetRotation()

                    theta = (theta + 165 + math.random() * 30) * DEGREES

                    local pos = inst:GetPosition()
                    pos.y = 0

                    local offs =
                    FindWalkableOffset(pos, theta, 4 + math.random(), 8, false, true, NotBlocked, true, true) or
                        FindWalkableOffset(pos, theta, 2 + math.random(), 6, false, true, NotBlocked, true, true)

                    if offs ~= nil then
                        pos.x = pos.x + offs.x
                        pos.z = pos.z + offs.z
                    end
                    inst.Physics:Teleport(pos:Get())
                    if inst.sg.statemem.attackerpos ~= nil then
                        inst:ForceFacePoint(inst.sg.statemem.attackerpos)
                    end

                    inst.sg.statemem.appearing = true
                    inst.sg:GoToState("appear")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.appearing then
                ToggleOnCharacterCollisions(inst)
            end
        end,
    },

    State {
        name = "appear",
        tags = { "busy", "noattack", "temp_invincible" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            ToggleOffCharacterCollisions(inst)
            inst.AnimState:PlayAnimation("appear")
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                TrySplashFX(inst, "small")
            end),
            TimeEvent(11 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("temp_invincible")
                ToggleOnCharacterCollisions(inst)
            end),
            TimeEvent(13 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = ToggleOnCharacterCollisions,
    },

    State {
        name = "lunge_pst",
        tags = { "busy", "noattack", "temp_invincible" },

        onenter = function(inst, target)
            inst.AnimState:PlayAnimation("lunge_pst")
            inst.Physics:SetMotorVelOverride(12, 0, 0)
            inst.sg.statemem.target = target
        end,

        onupdate = function(inst)
            inst.Physics:SetMotorVelOverride(inst.Physics:GetMotorVel() * .8, 0, 0)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local target = inst.sg.statemem.target
                    local pos = inst:GetPosition()
                    pos.y = 0
                    local moved = false
                    if target ~= nil then
                        if target:IsValid() then
                            local targetpos = target:GetPosition()
                            local dx, dz = targetpos.x - pos.x, targetpos.z - pos.z
                            local radius = math.sqrt(dx * dx + dz * dz)
                            local theta = math.atan2(dz, -dx)
                            local offs = FindWalkableOffset(targetpos, theta, radius + 3 + math.random(), 8, false, true
                                , NotBlocked, true, true)
                            if offs ~= nil then
                                pos.x = targetpos.x + offs.x
                                pos.z = targetpos.z + offs.z
                                inst.Physics:Teleport(pos:Get())
                                moved = true
                            end
                        else
                            target = nil
                        end
                    end
                    if not moved and not TheWorld.Map:IsPassableAtPoint(pos.x, 0, pos.z, true) then
                        pos = FindNearbyLand(pos, 1) or FindNearbyLand(pos, 2)
                        if pos ~= nil then
                            inst.Physics:Teleport(pos.x, 0, pos.z)
                        end
                    end

                    if target ~= nil then
                        inst:ForceFacePoint(target.Transform:GetWorldPosition())
                    end

                    inst.sg.statemem.appearing = true
                    inst.sg:GoToState("appear")
                end
            end),
        },

        onexit = function(inst)
            inst:RestartBrain()
            inst.AnimState:SetBank("wilson")
            inst.Physics:CollidesWith(COLLISION.GIANTS)
            if not inst.sg.statemem.appearing then
                ToggleOnCharacterCollisions(inst)
            end
        end,
    }
}

return StateGraph("shadowmaxwell", states, events, "idle", actionhandlers)

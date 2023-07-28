local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddStategraphPostInit("shadow_bishop", function(inst) --First time properly working with stategraphs so, uh, sorry if it's bad :]]]]]]
    local SWARM_PERIOD = .5
    local SWARM_START_DELAY = .25

    local AREAATTACK_EXCLUDETAGS = { "INLIMBO", "notarget", "invisible", "noattack", "flight", "playerghost", "shadow", "shadowchesspiece", "shadowcreature" }

    local function DoSwarmAttack(inst)
        inst.components.combat:DoAreaAttack(inst, inst.components.combat.hitrange, nil, nil, nil, AREAATTACK_EXCLUDETAGS)
    end

    local function DoSwarmFX(inst)
        local fx = SpawnPrefab("shadow_bishop_fx")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx.Transform:SetScale(inst.Transform:GetScale())
        fx.AnimState:SetMultColour(inst.AnimState:GetMultColour())
    end


    local states = {

        State {
            name = "attack",
            tags = { "attack", "busy" },

            onenter = function(inst, target)
                if target ~= nil and target:IsValid() then
                    inst.sg.statemem.target = target
                    inst.sg.statemem.targetpos = target:GetPosition()
                end
                inst.Physics:Stop()
                inst.components.combat:StartAttack()
                inst.AnimState:PlayAnimation("atk_side_pre")
            end,

            onupdate = function(inst)
                if inst.sg.statemem.target ~= nil then
                    if inst.sg.statemem.target:IsValid() then
                        inst.sg.statemem.targetpos = inst:GetPosition()
                    else
                        inst.sg.statemem.target = nil
                    end
                end
            end,

            timeline =
            {
                TimeEvent(8 * FRAMES, function(inst)
                    inst.sg:AddStateTag("noattack")
                    inst.components.health:SetInvincible(true)
                    DoSwarmFX(inst)
                    inst.SoundEmitter:PlaySound(inst.sounds.attack, "attack")
                end),
            },

            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg.mem.charge_count = inst.level + 2 --counts how many charges we should do! Should this be randomised a little?
                    if inst.AnimState:AnimDone() then
                        inst.sg.statemem.attack = true
                        inst.sg:GoToState("attack_loop", inst.sg.statemem.target)
                    end
                end),
            },

            onexit = function(inst)
                if not inst.sg.statemem.attack then
                    inst.components.health:SetInvincible(false)
                    inst.SoundEmitter:KillSound("attack")
                end
            end,
        },

        State {
            name = "attack_loop",
            tags = { "attack", "busy", "noattack" },

            onenter = function(inst, target)
                inst.components.health:SetInvincible(true)
                inst.sg.statemem.target = target
                inst.Physics:Stop()

                local targetpos = inst.sg.statemem.target:GetPosition()
                local pos = inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() and inst.sg.statemem.target:GetPosition() or inst:GetPosition()
                local bestoffset = nil
                local minplayerdistsq = math.huge
                local dist_off = { 0.8, 1.2, 1.35 } -- scaling with the actual scale of bishop is too high

                local angles = { 1, 60, 120, 180, 240, 300, 360 }
                local random_choose = math.floor(math.random(1, 7))
                local choose_angle = angles[random_choose]
                if inst._angle ~= nil and math.abs(choose_angle - inst._angle) <= 60 then
                    if random_choose + 4 <= 7 then
                        random_choose = random_choose + 4
                    elseif random_choose - 4 > 0 then
                        random_choose = random_choose - 4
                    end
                    inst._angle = angles[random_choose]
                else
                    inst._angle = choose_angle
                end

                for i = 1, 4 do
                    local offset = FindWalkableOffset(pos, inst._angle, 12 * dist_off[inst.level], 4, false, true)
                    if offset ~= nil then
                        local player, distsq = FindClosestPlayerInRange(pos.x + offset.x, 0, pos.z + offset.z, 6, true)
                        if player == nil then
                            bestoffset = offset
                            break
                        elseif distsq < minplayerdistsq then
                            bestoffset = offset
                            minplayerdistsq = distsq
                            inst.sg.statemem.target, target = player
                        end
                    end
                end
                if bestoffset ~= nil then
                    inst.Physics:Teleport(pos.x + bestoffset.x, 0, pos.z + bestoffset.z)
                end


                if target ~= nil and target:IsValid() and target.components.health and not target.components.health:IsDead() then
                    --local scale = inst.Transform:GetScale()
                    --if inst.level == 3 then scale = 1.7 end -- size scaling too big
                    local scale = { 16, 14, 13 } --even if 2nd level lower than a 1st one it's still faster due to scale
                    inst.sg.statemem.speed = scale[inst.level]
                    if inst:IsNear(target, .5) then
                        inst.Physics:Stop()
                    elseif inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
                        inst.sg.statemem.charge_delay = true
                        inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                        inst:DoTaskInTime(0.5, function(inst)
                            inst.sg.statemem.charge_delay = nil
                            if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
                                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                            end
                        end) --added delay for reacting
                    end
                end

                inst.AnimState:PlayAnimation("atk_side_loop_pre")

                inst.sg.statemem.task = inst:DoPeriodicTask(0.15, DoSwarmAttack, TUNING.SHADOW_BISHOP.ATTACK_START_TICK)
                inst.sg.statemem.fxtask = inst:DoPeriodicTask(0.25, DoSwarmFX, .5) --moves a lot faster so should probably check for targets nearby faster too (and fx is pretty with this amount)

                inst.sg:SetTimeout(50 * FRAMES)                                    --seems a bit long for earlier levels, should this dynamically scale too?
            end,

            onupdate = function(inst)
                if inst.sg.statemem.target ~= nil then
                    if not inst.sg.statemem.target:IsValid() or inst.sg.statemem.target.components.health == nil or inst.sg.statemem.target.components.health:IsDead() then
                        inst.sg.statemem.target = nil
                    elseif inst.sg.statemem.target:IsValid() and inst:IsNear(inst.sg.statemem.target, .5) then
                        inst.Physics:Stop()
                    elseif not inst.sg.statemem.charge_delay and inst.sg.statemem.speed and inst.sg.statemem.target:IsValid() then
                        --inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition()) -- this line makes it move constantly towards player instead of in the straight line
                        inst.Physics:SetMotorVel(inst.sg.statemem.speed, 0, 0)
                    end
                end
            end,

            events =
            {
                EventHandler("animover", function(inst)
                    if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("atk_side_loop_pre") then
                        --V2C: 1) we don't push this anim coz it might make the pre anim loop on clients
                        --     2) we loop this anim and use timeout so that it looks smoother on clients --omg V2C hi I'm a big fan!!!
                        inst.AnimState:PlayAnimation("atk_side_loop", true)
                    end
                end),
            },

            ontimeout = function(inst)
                inst.sg.statemem.attack = true
                inst.sg:GoToState("attack_loop_pst", inst.sg.statemem.target)
            end,

            onexit = function(inst)
                inst.sg.statemem.task:Cancel()
                inst.sg.statemem.fxtask:Cancel()
                if not inst.sg.statemem.attack then
                    inst.components.health:SetInvincible(false)
                    inst.SoundEmitter:KillSound("attack")
                end
            end,
        },

        State {
            name = "attack_loop_pst",
            tags = { "attack", "busy", "noattack" },

            onenter = function(inst, target)
                inst.sg.statemem.target = target
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("atk_side_loop_pst")
            end,

            events =
            {
                EventHandler("animover", function(inst)
                    if inst.AnimState:AnimDone() then
                        local pos = inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() and inst.sg.statemem.target:GetPosition() or inst:GetPosition()
                        local bestoffset = nil
                        local minplayerdistsq = math.huge
                        for i = 1, 4 do
                            local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 8 + math.random() * 2, 4, false, true)
                            if offset ~= nil then
                                local player, distsq = FindClosestPlayerInRange(pos.x + offset.x, 0, pos.z + offset.z, 6, true)
                                if player == nil then
                                    bestoffset = offset
                                    break
                                elseif distsq < minplayerdistsq then
                                    bestoffset = offset
                                    minplayerdistsq = distsq
                                end
                            end
                        end
                        if bestoffset ~= nil then
                            inst.Physics:Teleport(pos.x + bestoffset.x, 0, pos.z + bestoffset.z)
                        end
                        inst.sg.statemem.attack = true

                        inst.sg.mem.charge_count = (inst.sg.mem.charge_count == nil and 0) or inst.sg.mem.charge_count - 1

                        if inst.sg.mem.charge_count ~= nil and inst.sg.mem.charge_count > 0 and inst.sg.statemem.target ~= nil then --CHECK IF TARGET IS EVEN THERE BEFORE CHARGING AGAIN LIKE A DUMBASS
                            inst.sg:GoToState("attack_loop", inst.sg.statemem.target)
                        else
                            inst.sg:GoToState("attack_pst")
                        end
                    end
                end),
            },

            onexit = function(inst)
                if not inst.sg.statemem.attack then
                    inst.components.health:SetInvincible(false)
                end
                inst.SoundEmitter:KillSound("attack")
            end,
        }

    }

    for k, v in pairs(states) do
        assert(v:is_a(State), "Non-state added in mod state table!")
        inst.states[v.name] = v
    end
end)

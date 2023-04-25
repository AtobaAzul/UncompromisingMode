local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("wilson", function(inst)
    local function ClearStatusAilments(inst)
        if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
            inst.components.freezable:Unfreeze()
        end
        if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
            inst.components.pinnable:Unstick()
        end
    end

    local function teleport_end(inst)
        inst.sg.statemem.teleport_task = nil
        inst.sg:GoToState(inst:HasTag("playerghost") and "appear" or "wakeup")
        if inst.components.health ~= nil then
            inst.components.health:SetInvincible(false)
        end
    end

    local function getrandomposition(caster, teleportee, target_in_ocean)
        if target_in_ocean then
            local pt = TheWorld.Map:FindRandomPointInOcean(20)
            if pt ~= nil then
                return pt
            end
            local from_pt = teleportee:GetPosition()
            local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16)
                or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16)
                or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16)
                or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
            if offset ~= nil then
                return from_pt + offset
            end
            return teleportee:GetPosition()
        else
            local centers = {}
            for i, node in ipairs(TheWorld.topology.nodes) do
                if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
                    table.insert(centers, { x = node.x, z = node.y })
                end
            end
            if #centers > 0 then
                local pos = centers[math.random(#centers)]
                return Point(pos.x, 0, pos.z)
            else
                return caster:GetPosition()
            end
        end
    end

    local function ForceStopHeavyLifting(inst)
        if inst.components.inventory:IsHeavyLifting() then
            inst.components.inventory:DropItem(
                inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
                true,
                true
            )
        end
    end

    local function DoHurtSound(inst)
        if inst.hurtsoundoverride ~= nil then
            inst.SoundEmitter:PlaySound(inst.hurtsoundoverride, nil, inst.hurtsoundvolume)
        elseif not inst:HasTag("mime") then
            inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/") ..
                (inst.soundsname or inst.prefab) .. "/hurt", nil, inst.hurtsoundvolume)
        end
    end

    local function StopTalkSound(inst, instant)
        if not instant and inst.endtalksound ~= nil and inst.SoundEmitter:PlayingSound("talk") then
            inst.SoundEmitter:PlaySound(inst.endtalksound)
        end
        inst.SoundEmitter:KillSound("talk")
    end

    local function DoTalkSound(inst)
        if inst.talksoundoverride ~= nil then
            inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
            return true
        elseif not inst:HasTag("mime") then
            inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/") ..
                (inst.soundsname or inst.prefab) .. "/talk_LP", "talk")
            return true
        end
    end

    local function DoMockAttack(inst)
        local target = inst.components.combat ~= nil and inst.components.combat.target
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local dist = target ~= nil and
            distsq(target:GetPosition(), inst:GetPosition()) <= inst.components.combat:CalcAttackRangeSq(target) or false

        if equip ~= nil and dist then
            local damage = equip.components.weapon ~= nil and equip.components.weapon:GetDamage(inst, target)
            local damagemult = inst.components.combat.damagemultiplier ~= nil and inst.components.combat
                .damagemultiplier
                or 1
            local damagemultex = inst.components.combat.externaldamagemultipliers ~= nil and
                inst.components.combat.externaldamagemultipliers:Get() or 1

            local damagecalc = ((damage / 2) * damagemult) * damagemultex

            if target ~= nil and inst.sg:HasStateTag("attack") then
                local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

                if equip ~= nil then
                    if equip.prefab == "pocketwatch_weapon" and equip.components.fueled ~= nil and
                        not equip.components.fueled:IsEmpty() then
                        equip.components.fueled:DoDelta(TUNING.TINY_FUEL)
                    end

                    equip.components.weapon:OnAttack_NoDurabilityLoss(inst, target)
                end

                if target.components.combat ~= nil then
                    target.components.combat:GetAttacked(inst, damagecalc, equip)
                end
            end
        end
    end


    local SLEEPREPEL_MUST_TAGS = { "_combat" }
    local SLEEPREPEL_CANT_TAGS = { "player", "companion", "shadow", "playerghost", "INLIMBO", "wixieshoved", "invisible",
        "hiding", "NOTARGET", "flight", "toadstool" }

    local function Check_Bowling(inst)
        if inst ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()

            local ents = TheSim:FindEntities(x, y, z, 3.5, SLEEPREPEL_MUST_TAGS, SLEEPREPEL_CANT_TAGS)

            for i, v in ipairs(ents) do
                v:AddTag("wixieshoved")
                SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(v.Transform:GetWorldPosition())

                if v.components.combat ~= nil then
                    v.components.combat:GetAttacked(inst, 0)
                end

                if v.components.locomotor ~= nil and not v:HasTag("stageusher") then
                    for i = 1, 50 do
                        v:DoTaskInTime((i - 1) / 50, function(v)
                            if v ~= nil and inst ~= nil then
                                local x, y, z = inst.Transform:GetWorldPosition()
                                local tx, ty, tz = v.Transform:GetWorldPosition()

                                local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
                                local velx = math.cos(rad)  --* 4.5
                                local velz = -math.sin(rad) --* 4.5

                                local giantreduction = v:HasTag("epic") and 1.5 or v:HasTag("smallcreature") and 0.8 or 1
                                local cursemultiplier = v:HasDebuff("wixiecurse_debuff") and 1.75 or 1.25
                                local shovevalue = inst:HasTag("troublemaker") and 3 or 2

                                local dx, dy, dz =
                                    tx + (((shovevalue / (i + 3)) * velx) / giantreduction) * cursemultiplier, ty,
                                    tz + (((shovevalue / (i + 3)) * velz) / giantreduction) * cursemultiplier
                                local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
                                local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
                                local ocean_collision = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
                                local on_water = nil

                                if TUNING.DSTU.ISLAND_ADVENTURES then
                                    on_water = IsOnWater(dx, dy, dz)
                                end

                                if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then
                                    if v ~= nil and dx ~= nil and (ground or boat or ocean_collision and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
                                        if not v:HasTag("aquatic") and not on_water or v:HasTag("aquatic") and on_water then
                                            --[[if ocean_collision and v.components.amphibiouscreature and not v.components.amphibiouscreature.in_water then
												v.components.amphibiouscreature:OnEnterOcean()
											end]]
                                            v.Transform:SetPosition(dx, dy, dz)
                                        end
                                    end
                                end

                                if i >= 50 then
                                    v:RemoveTag("wixieshoved")
                                end
                            end
                        end)
                    end
                end
            end
        end
    end

    local events =
    {
        EventHandler("sneeze", function(inst, data)
            if not inst.components.health:IsDead() and not inst.components.health.invincible then
                --[[ if inst.sg:HasStateTag("busy") and inst.sg.currentstate.name ~= "emote" then
                inst.wantstosneeze = true
            else]]
                inst.wantstosneeze = true
                inst.sg:GoToState("sneeze")
                -- end
            end
        end),

        EventHandler("dreadeye_spooked", function(inst)
            if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead() or inst.components.rider:IsRiding()) then
                inst.sg:GoToState("dreadeye_spooked")
            end
        end)
    }

    local _OldSpellCast = inst.actionhandlers[ACTIONS.CASTSPELL].deststate
    inst.actionhandlers[ACTIONS.CASTSPELL].deststate =
        function(inst, action, ...)
            if action.invobject ~= nil then
                if action.invobject:HasTag("lighter") then
                    return "castspelllighter"
                elseif action.invobject:HasTag("charles_t_horse") then
                    if action.invobject.components.fueled:GetPercent() >= 0.2 then
                        if inst.components.rider and inst.components.rider:IsRiding() then
                            inst.components.rider:Dismount()
                        else
                            return "charles_charge"
                        end
                    else
                        return
                    end
                elseif action.invobject:HasTag("beargerclaw") then
                    if inst.components.rider and inst.components.rider:IsRiding() then
                        inst.components.rider:Dismount()
                    else
                        return "bearclaw_dig_start"
                    end
                elseif action.invobject:HasTag("beegun") then
                    return "collectthebees"
                end
            end
            return _OldSpellCast(inst, action, ...)
        end

    local _OldPlay = inst.actionhandlers[ACTIONS.PLAY].deststate
    inst.actionhandlers[ACTIONS.PLAY].deststate =
        function(inst, action, ...)
            if action.invobject ~= nil then
                if action.invobject:HasTag("pied_piper_flute") then
                    return "play_pied_piper_flute"
                end
            end
            return _OldPlay(inst, action, ...)
        end

    local _OldChannel = inst.actionhandlers[ACTIONS.STARTCHANNELING].deststate
    inst.actionhandlers[ACTIONS.STARTCHANNELING].deststate =
        function(inst, action, ...)
            if action.target and action.target.components.channelable and
                action.target.components.channelable.use_channel_longaction_noloop then
                return "dostandingaction"
            else
                return _OldChannel(inst, action, ...)
            end
        end

    local _OldAttackState = inst.actionhandlers[ACTIONS.ATTACK].deststate
    inst.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action, ...)
        local weapon = inst.components.combat and inst.components.combat:GetWeapon()
        if weapon and weapon:HasTag("beegun") then
            if inst.sg.laststate.name == "beegun" or inst.sg.laststate.name == "beegun_short" then
                return "beegun_short"
            else
                return "beegun"
            end
        else
            return _OldAttackState(inst, action, ...)
        end
    end

    local _OldCast_Net = inst.actionhandlers[ACTIONS.CAST_NET].deststate
    inst.actionhandlers[ACTIONS.CAST_NET].deststate =
        function(inst, action, ...)
            if inst ~= nil then
                return "cast_net_fixed"
            else
                return _OldCast_Net(inst, action, ...)
            end
        end

    local _OldDeathEvent = inst.events["death"].fn
    inst.events["death"].fn = function(inst, data)
        if data ~= nil and data.cause == "shadowvortex" and not inst:HasTag("wereplayer") then
            inst.components.rider:ActualDismount()
            inst.sg:GoToState("blackpuddle_death")
        elseif data ~= nil and data.cause == "mindweaver" and not inst:HasTag("wereplayer") then
            inst.components.rider:ActualDismount()
            inst.sg:GoToState("rne_player_grabbed")
        else
            _OldDeathEvent(inst, data)
        end
    end

    local actionhandlers =
    {
        --[[ActionHandler(ACTIONS.CASTSPELL,
        function(inst, action)
            return action.invobject ~= nil"
                and action.invobject:HasTag("lighter") and "castspelllighter"
				or _OldSpellCast
        end),]]
        ActionHandler(ACTIONS.CASTLIGHTER,
            function(inst, action)
                return action.invobject ~= nil
                    and action.invobject:HasTag("lighter") and "castspelllighter"
            end),
        ActionHandler(ACTIONS.WINGSUIT,
            function(inst, action)
                return action.invobject ~= nil
                    and action.invobject:HasTag("wingsuit") and "castspell"
            end),
        ActionHandler(ACTIONS.CREATE_BURROW,
            function(inst, action)
                return "dolongaction"
            end),
        ActionHandler(ACTIONS.CHARGE_POWERCELL,
            function(inst, action)
                return action.invobject ~= nil and action.invobject:HasTag("powercell") and "doshortaction"
            end),
        ActionHandler(ACTIONS.SET_CUSTOM_NAME, "doshortaction"),
    }

    local _OldIdleState = inst.states["idle"].onenter
    inst.states["idle"].onenter = function(inst, pushanim)
        if inst.wantstosneeze then
            inst.sg:GoToState("sneeze")
        else
            _OldIdleState(inst, pushanim)
        end
    end

    local _OldEatState = inst.states["eat"].onenter
    inst.states["eat"].onenter = function(inst, foodinfo)
        if inst.wantstosneeze then
            inst.sg:GoToState("sneeze")
        else
            _OldEatState(inst, foodinfo)
        end
    end


    local states = {

        State {
            name = "castspelllighter",
            tags = { "doing", "busy", "canrotate" },

            onenter = function(inst)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(false)
                end
                inst.AnimState:PlayAnimation("staff_pre")
                inst.AnimState:PushAnimation("staff", false)
                inst.components.locomotor:Stop()

                --Spawn an effect on the player's location
                local staff = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                local colour = staff ~= nil and staff.fxcolour or { 1, 1, 1 }
                --[[
            inst.sg.statemem.stafffx = SpawnPrefab(inst.components.rider:IsRiding() and "staffcastfx_mount" or "frog")
            inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
            inst.sg.statemem.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.sg.statemem.stafffx:SetUp(colour)
			]]
                inst.sg.statemem.stafflight = SpawnPrefab("staff_castinglight")
                inst.sg.statemem.stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.sg.statemem.stafflight:SetUp(colour, 1.9, .33)

                if staff ~= nil and staff.components.aoetargeting ~= nil and
                    staff.components.aoetargeting.targetprefab ~= nil then
                    local buffaction = inst:GetBufferedAction()
                    if buffaction ~= nil and buffaction.pos ~= nil then
                        inst.sg.statemem.targetfx = SpawnPrefab(staff.components.aoetargeting.targetprefab)
                        if inst.sg.statemem.targetfx ~= nil then
                            inst.sg.statemem.targetfx.Transform:SetPosition(buffaction:GetActionPoint():Get())
                            inst.sg.statemem.targetfx:ListenForEvent("onremove", OnRemoveCleanupTargetFX, inst)
                        end
                    end
                end

                inst.sg.statemem.castsound = staff ~= nil and staff.castsound or "dontstarve/wilson/use_gemstaff"
            end,

            timeline =
            {
                TimeEvent(13 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound(inst.sg.statemem.castsound)
                end),
                TimeEvent(53 * FRAMES, function(inst)
                    if inst.sg.statemem.targetfx ~= nil then
                        if inst.sg.statemem.targetfx:IsValid() then
                            OnRemoveCleanupTargetFX(inst)
                        end
                        inst.sg.statemem.targetfx = nil
                    end
                    inst.sg.statemem.stafffx = nil    --Can't be cancelled anymore
                    inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
                    --V2C: NOTE! if we're teleporting ourself, we may be forced to exit state here!
                    inst:PerformBufferedAction()
                end),
            },

            events =
            {
                EventHandler("animqueueover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end),
            },

            onexit = function(inst)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
                    inst.sg.statemem.stafffx:Remove()
                end
                if inst.sg.statemem.stafflight ~= nil and inst.sg.statemem.stafflight:IsValid() then
                    inst.sg.statemem.stafflight:Remove()
                end
                if inst.sg.statemem.targetfx ~= nil and inst.sg.statemem.targetfx:IsValid() then
                    OnRemoveCleanupTargetFX(inst)
                end
            end,
        },

        State {
            name = "bearclaw_dig_start",
            tags = { "predig", "working" },

            onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("shovel_pre")
            end,

            events =
            {
                EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
                EventHandler("animover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("bearclaw_dig")
                    end
                end),
            },
        },

        State {
            name = "bearclaw_dig",
            tags = { "busy", "attack" },

            onenter = function(inst)
                inst.AnimState:PlayAnimation("shovel_loop")
            end,

            timeline =
            {
                TimeEvent(15 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
                    inst:PerformBufferedAction()
                end),
            },

            events =
            {
                EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
                EventHandler("animover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.AnimState:PlayAnimation("shovel_pst")
                        inst.sg:GoToState("idle", true)
                    end
                end),
            },
        },


        State {
            name = "curse_controlled",
            tags = { "busy", "pausepredict", "nomorph", "nodangle" },

            onenter = function(inst)
                if not inst.AnimState:IsCurrentAnimation("mindcontrol_loop") then
                    inst.AnimState:PlayAnimation("mindcontrol_loop", true)
                end
                inst.sg:SetTimeout(2)
            end,

            events =
            {
                EventHandler("mindcontrolled", function(inst)
                    inst.sg.statemem.mindcontrolled = true
                    inst.sg:GoToState("mindcontrolled_loop")
                end),
            },

            ontimeout = function(inst)
                inst.sg:GoToState("mindcontrolled_pst")
            end,

            onexit = function(inst)
                if not inst.sg.statemem.mindcontrolled then
                    if inst.components.playercontroller ~= nil then
                        inst.components.playercontroller:Enable(true)
                    end
                    inst.components.inventory:Show()
                end
            end,
        },

        State {
            name = "sneeze",
            tags = { "busy", "sneeze", "pausepredict" },

            onenter = function(inst)
                local usehit = inst.components.rider:IsRiding() or inst:HasTag("wereplayer")
                local stun_frames = usehit and 6 or 9
                inst.wantstosneeze = false
                inst:ClearBufferedAction()
                inst.components.locomotor:Stop()
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit", nil, .02)


                if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
                    inst.AnimState:PlayAnimation("sneeze")
                end

                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:RemotePausePrediction(stun_frames <= 7 and stun_frames or nil)
                end


                if inst.prefab ~= "wes" then
                    inst.SoundEmitter:PlaySound("UCSounds/Sneeze/sneeze")
                    local sound_name = inst.soundsname or inst.prefab
                    local path = inst.talker_path_override or "dontstarve/characters/"
                    --local equippedHat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                    --if equippedHat and equippedHat:HasTag("muffler") then
                    --inst.SoundEmitter:PlaySound(path..sound_name.."/gasmask_hurt")
                    --else
                    local sound_event = path .. sound_name .. "/hurt"
                    inst.SoundEmitter:PlaySound(inst.hurtsoundoverride or sound_event)
                    --end

                    inst.components.talker:Say(GetString(inst.prefab, "ANNOUNCE_SNEEZE"))
                end
            end,

            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
            },

            timeline =
            {
                TimeEvent(10 * FRAMES, function(inst)
                    if inst.components.hayfever then
                        inst.components.hayfever:DoSneezeEffects()
                    end
                    inst.sg:RemoveStateTag("busy")
                end),
            },

        },

        State {
            name = "play_pied_piper_flute",
            tags = { "doing", "playing" },

            onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("action_uniqueitem_pre")
                inst.AnimState:PushAnimation("whistle", false)
                inst.AnimState:OverrideSymbol("hound_whistle01", "pied_piper_flute", "hound_whistle01")
                --inst.AnimState:Hide("ARM_carry")
                inst.AnimState:Show("ARM_normal")
                inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and
                    inst.bufferedaction.invobject or nil)
            end,

            timeline =
            {
                TimeEvent(20 * FRAMES, function(inst)
                    if inst:PerformBufferedAction() then
                        inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
                    else
                        inst.AnimState:SetTime(34 * FRAMES)
                    end
                end),
            },

            events =
            {
                EventHandler("animqueueover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end),
            },

            onexit = function(inst)
                if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                    inst.AnimState:Show("ARM_carry")
                    inst.AnimState:Hide("ARM_normal")
                end
            end,
        },

        State {
            name = "force_klaus_attack",
            tags = { "busy", "attack", "notalking", "abouttoattack", "autopredict" },

            onenter = function(inst)
                if inst.components.combat:InCooldown() then
                    inst.sg:RemoveStateTag("abouttoattack")
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle", true)
                    return
                end
                local buffaction = inst:GetBufferedAction()
                local target = buffaction ~= nil and buffaction.target or nil
                local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                inst.components.combat:SetTarget(target)
                inst.components.combat:StartAttack()
                inst.components.locomotor:Stop()
                local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
                if inst.components.rider:IsRiding() then
                    if equip ~= nil and (equip.components.projectile ~= nil or equip:HasTag("rangedweapon")) then
                        inst.AnimState:PlayAnimation("player_atk_pre")
                        inst.AnimState:PushAnimation("player_atk", false)

                        if (equip.projectiledelay or 0) > 0 then
                            --V2C: Projectiles don't show in the initial delayed frames so that
                            --     when they do appear, they're already in front of the player.
                            --     Start the attack early to keep animation in sync.
                            inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
                            if inst.sg.statemem.projectiledelay > FRAMES then
                                inst.sg.statemem.projectilesound =
                                    (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
                                    (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
                                    "dontstarve/wilson/attack_weapon"
                            elseif inst.sg.statemem.projectiledelay <= 0 then
                                inst.sg.statemem.projectiledelay = nil
                            end
                        end
                        if inst.sg.statemem.projectilesound == nil then
                            inst.SoundEmitter:PlaySound(
                                (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
                                (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
                                "dontstarve/wilson/attack_weapon",
                                nil, nil, true
                            )
                        end
                        cooldown = math.max(cooldown, 13 * FRAMES)
                    else
                        inst.AnimState:PlayAnimation("atk_pre")
                        inst.AnimState:PushAnimation("atk", false)
                        DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                        cooldown = math.max(cooldown, 16 * FRAMES)
                    end
                elseif equip ~= nil and equip:HasTag("toolpunch") then
                    -- **** ANIMATION WARNING ****
                    -- **** ANIMATION WARNING ****
                    -- **** ANIMATION WARNING ****

                    --  THIS ANIMATION LAYERS THE LANTERN GLOW UNDER THE ARM IN THE UP POSITION SO CANNOT BE USED IN STANDARD LANTERN GLOW ANIMATIONS.

                    inst.AnimState:PlayAnimation("toolpunch")
                    inst.sg.statemem.istoolpunch = true
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, inst.sg.statemem.attackvol, true)
                    cooldown = math.max(cooldown, 13 * FRAMES)
                elseif equip ~= nil and equip:HasTag("whip") then
                    inst.AnimState:PlayAnimation("whip_pre")
                    inst.AnimState:PushAnimation("whip", false)
                    inst.sg.statemem.iswhip = true
                    inst.SoundEmitter:PlaySound("dontstarve/common/whip_pre", nil, nil, true)
                    cooldown = math.max(cooldown, 17 * FRAMES)
                elseif equip ~= nil and equip:HasTag("pocketwatch") then
                    inst.AnimState:PlayAnimation(inst.sg.statemem.chained and "pocketwatch_atk_pre_2" or
                        "pocketwatch_atk_pre")
                    inst.AnimState:PushAnimation("pocketwatch_atk", false)
                    inst.sg.statemem.ispocketwatch = true
                    cooldown = math.max(cooldown, 15 * FRAMES)
                    if equip:HasTag("shadow_item") then
                        inst.SoundEmitter:PlaySound("wanda2/characters/wanda/watch/weapon/pre_shadow", nil, nil, true)
                        inst.AnimState:Show("pocketwatch_weapon_fx")
                        inst.sg.statemem.ispocketwatch_fueled = true
                    else
                        inst.SoundEmitter:PlaySound("wanda2/characters/wanda/watch/weapon/pre", nil, nil, true)
                        inst.AnimState:Hide("pocketwatch_weapon_fx")
                    end
                elseif equip ~= nil and equip:HasTag("book") then
                    inst.AnimState:PlayAnimation("attack_book")
                    inst.sg.statemem.isbook = true
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
                    cooldown = math.max(cooldown, 19 * FRAMES)
                elseif equip ~= nil and equip:HasTag("chop_attack") and inst:HasTag("woodcutter") then
                    inst.AnimState:PlayAnimation(inst.AnimState:IsCurrentAnimation("woodie_chop_loop") and
                        inst.AnimState:GetCurrentAnimationTime() < 7.1 * FRAMES and "woodie_chop_atk_pre" or
                        "woodie_chop_pre")
                    inst.AnimState:PushAnimation("woodie_chop_loop", false)
                    inst.sg.statemem.ischop = true
                    cooldown = math.max(cooldown, 11 * FRAMES)
                elseif equip ~= nil and equip.components.weapon ~= nil and not equip:HasTag("punch") then
                    inst.AnimState:PlayAnimation("atk_pre")
                    inst.AnimState:PushAnimation("atk", false)
                    if (equip.projectiledelay or 0) > 0 then
                        --V2C: Projectiles don't show in the initial delayed frames so that
                        --     when they do appear, they're already in front of the player.
                        --     Start the attack early to keep animation in sync.
                        inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
                        if inst.sg.statemem.projectiledelay > FRAMES then
                            inst.sg.statemem.projectilesound =
                                (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
                                (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
                                "dontstarve/wilson/attack_weapon"
                        elseif inst.sg.statemem.projectiledelay <= 0 then
                            inst.sg.statemem.projectiledelay = nil
                        end
                    end
                    if inst.sg.statemem.projectilesound == nil then
                        inst.SoundEmitter:PlaySound(
                            (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
                            (equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
                            (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
                            "dontstarve/wilson/attack_weapon",
                            nil, nil, true
                        )
                    end
                    cooldown = math.max(cooldown, 13 * FRAMES)
                elseif equip ~= nil and (equip:HasTag("light") or equip:HasTag("nopunch")) then
                    inst.AnimState:PlayAnimation("atk_pre")
                    inst.AnimState:PushAnimation("atk", false)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
                    cooldown = math.max(cooldown, 13 * FRAMES)
                elseif inst:HasTag("beaver") then
                    inst.sg.statemem.isbeaver = true
                    inst.AnimState:PlayAnimation("atk_pre")
                    inst.AnimState:PushAnimation("atk", false)
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
                    cooldown = math.max(cooldown, 13 * FRAMES)
                elseif inst:HasTag("weremoose") then
                    inst.sg.statemem.ismoose = true
                    inst.AnimState:PlayAnimation(
                        (
                        (inst.AnimState:IsCurrentAnimation("punch_a") or inst.AnimState:IsCurrentAnimation("punch_c"))
                        and "punch_b") or
                        (inst.AnimState:IsCurrentAnimation("punch_b") and "punch_c") or
                        "punch_a"
                    )
                    cooldown = math.max(cooldown, 15 * FRAMES)
                else
                    inst.AnimState:PlayAnimation("punch")
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
                    cooldown = math.max(cooldown, 24 * FRAMES)
                end

                inst.sg:SetTimeout(cooldown)

                if target ~= nil then
                    inst.components.combat:BattleCry()
                    if target:IsValid() then
                        inst:FacePoint(target:GetPosition())
                        inst.sg.statemem.attacktarget = target
                    end
                end
            end,

            onupdate = function(inst, dt)
                if (inst.sg.statemem.projectiledelay or 0) > 0 then
                    inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
                    if inst.sg.statemem.projectiledelay <= FRAMES then
                        if inst.sg.statemem.projectilesound ~= nil then
                            inst.SoundEmitter:PlaySound(inst.sg.statemem.projectilesound, nil, nil, true)
                            inst.sg.statemem.projectilesound = nil
                        end
                        if inst.sg.statemem.projectiledelay <= 0 then
                            DoMockAttack(inst)
                            inst:ClearBufferedAction()
                            inst.sg:RemoveStateTag("abouttoattack")
                        end
                    end
                end
            end,

            timeline =
            {
                TimeEvent(5 * FRAMES, function(inst)
                    if inst.sg.statemem.ismoose then
                        inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/moose/punch", nil, nil, true)
                    end
                end),
                TimeEvent(6 * FRAMES, function(inst)
                    if inst.sg.statemem.isbeaver then
                        DoMockAttack(inst)
                        inst:ClearBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                    elseif inst.sg.statemem.ischop then
                        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
                    end
                end),
                TimeEvent(7 * FRAMES, function(inst)
                    if inst.sg.statemem.ismoose then
                        DoMockAttack(inst)
                        inst:ClearBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                    end
                end),
                TimeEvent(8 * FRAMES, function(inst)
                    if not (inst.sg.statemem.isbeaver or
                        inst.sg.statemem.ismoose or
                        inst.sg.statemem.iswhip or
                        inst.sg.statemem.ispocketwatch or
                        inst.sg.statemem.isbook) and
                        inst.sg.statemem.projectiledelay == nil then
                        DoMockAttack(inst)
                        inst:ClearBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                        inst.sg:RemoveStateTag("busy")
                    end
                end),
                TimeEvent(10 * FRAMES, function(inst)
                    if inst.sg.statemem.iswhip or inst.sg.statemem.isbook or inst.sg.statemem.ispocketwatch then
                        DoMockAttack(inst)
                        inst:ClearBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                        inst.sg:RemoveStateTag("busy")
                    end
                end),
            },

            ontimeout = function(inst)
                inst.sg:RemoveStateTag("attack")
                inst.sg:RemoveStateTag("busy")
                inst.sg:AddStateTag("idle")
            end,

            events =
            {
                EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
                EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
                EventHandler("animqueueover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end),
            },

            onexit = function(inst)
                inst.components.combat:SetTarget(nil)
                if inst.sg:HasStateTag("abouttoattack") then
                    inst.components.combat:CancelAttack()
                end
            end,
        },


        State {
            name = "blackpuddle_death",
            tags = { "busy", --[["dead",]] "pausepredict", "nomorph", "blackpuddle_death" },

            onenter = function(inst)
                --assert(inst.deathcause ~= nil, "Entered death state without cause.")

                ClearStatusAilments(inst)
                ForceStopHeavyLifting(inst)

                inst.components.locomotor:Stop()
                inst.components.locomotor:Clear()
                inst:ClearBufferedAction()

                inst.AnimState:Hide("swap_arm_carry")
                inst.AnimState:PlayAnimation("boat_death")

                --local death_fx = SpawnPrefab("rne_grabbyshadows")
                --death_fx.Transform:SetPosition(inst:GetPosition():Get())

                if inst.components.rider:IsRiding() then
                    inst.sg:AddStateTag("dismounting")
                end

                inst.SoundEmitter:PlaySound("dontstarve/characters/" .. (inst.soundsname or inst.prefab) .. "/sinking")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/characters/" ..
                    (inst.soundsname or inst.prefab) .. "/sinking")
                if TUNING.DSTU.COMPROMISING_SHADOWVORTEX and inst.components.health ~= nil then
                    inst.components.health:SetInvincible(true)
                end
                inst.components.burnable:Extinguish()
                inst.sg:ClearBufferedEvents()
            end,

            events =
            {
                EventHandler("animover", function(inst)
                    if inst.AnimState:AnimDone() then
                        if not TUNING.DSTU.COMPROMISING_SHADOWVORTEX then
                            inst.components.inventory:DropEverything(true)
                            inst:PushEvent(inst.ghostenabled and "makeplayerghost" or "playerdied", { skeleton = nil }) -- if we are not on valid ground then don't drop a skeleton
                        else
                            local locpos = getrandomposition(inst, inst, false)
                            if inst.Physics ~= nil then
                                inst.Physics:Teleport(locpos.x, 0, locpos.z)
                            else
                                inst.Transform:SetPosition(locpos.x, 0, locpos.z)
                            end

                            if inst:HasTag("player") then
                                inst:SnapCamera()
                                inst:ScreenFade(true, 1)
                            end
                            inst.sg.statemem.teleport_task = inst:DoTaskInTime(1, teleport_end)
                        end
                    end
                end),
            },

            onexit = function(inst)
                inst.DynamicShadow:Enable(true)
            end,

            timeline =
            {
                TimeEvent(50 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boat_sinking_shadow")
                end),
                TimeEvent(70 * FRAMES, function(inst)
                    inst.DynamicShadow:Enable(false)
                end),
            },
        },


        State {
            name = "rne_player_grabbed",
            tags = { "busy", "dead", "pausepredict", "nomorph" },

            onenter = function(inst)
                assert(inst.deathcause ~= nil, "Entered death state without cause.")

                ClearStatusAilments(inst)
                ForceStopHeavyLifting(inst)

                inst.components.locomotor:Stop()
                inst.components.locomotor:Clear()
                inst:ClearBufferedAction()

                inst.AnimState:Hide("swap_arm_carry")
                inst.AnimState:PlayAnimation("grabbedbytheghoulie")

                if inst.components.rider:IsRiding() then
                    inst.sg:AddStateTag("dismounting")
                end

                if inst.deathsoundoverride ~= nil then
                    inst.SoundEmitter:PlaySound(inst.deathsoundoverride)
                elseif not inst:HasTag("mime") then
                    inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/") ..
                        (inst.soundsname or inst.prefab) .. "/death_voice")
                end

                inst.components.burnable:Extinguish()
                inst.sg:ClearBufferedEvents()
            end,

            events =
            {
                EventHandler("animover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.components.inventory:DropEverything(true)
                        inst:PushEvent(inst.ghostenabled and "makeplayerghost" or "playerdied", { skeleton = nil }) -- if we are not on valid ground then don't drop a skeleton
                    end
                end),
            },

            onexit = function(inst)
                inst.DynamicShadow:Enable(true)
            end,

            timeline =
            {
                TimeEvent(547 * FRAMES, function(inst)
                    inst.DynamicShadow:Enable(false)
                end),
            },
        },

        State {
            name = "grabby_teleport",
            tags = { "busy", "pausepredict", "nomorph", "nodangle", "gotgrabbed" },

            onenter = function(inst, cb)
                inst.sg.statemem.cb = cb

                --This state is only valid as a substate of openwardrobe
                inst.AnimState:OverrideSymbol("shadow_hands", "shadow_skinchangefx", "shadow_hands")
                inst.AnimState:OverrideSymbol("shadow_ball", "shadow_skinchangefx", "shadow_ball")
                inst.AnimState:OverrideSymbol("splode", "shadow_skinchangefx", "splode")

                --inst.AnimState:PlayAnimation("gift_pst", false)
                inst.AnimState:PlayAnimation("skin_change", false)

                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:RemotePausePrediction()
                end
            end,

            timeline =
            {
                -- gift_pst plays first and it is 20 frames long
                TimeEvent(0, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/skin_change")
                end),
                TimeEvent(41 * FRAMES, function(inst)
                    if inst.components.inventory ~= nil then
                        local hand = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        if hand ~= nil then
                            inst.components.inventory:DropItem(hand)
                        end

                        local body = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
                        if body ~= nil and body._light ~= nil then
                            inst.components.inventory:DropItem(body)
                        end

                        local hat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                        if hat ~= nil and (hat:HasTag("nightvision") or hat._light) then
                            inst.components.inventory:DropItem(hat)
                        end

                        if inst.components.sanity ~= nil then
                            inst.components.sanity:DoDelta(-15)
                        end
                    end
                end),
                -- frame 42 of skin_change is where the character is completely hidden
                TimeEvent(42 * FRAMES, function(inst)
                    if inst.sg.statemem.cb ~= nil then
                        inst.sg.statemem.cb()
                        inst.sg.statemem.cb = nil
                    end
                end),
            },

            events =
            {
                EventHandler("animqueueover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end),
            },

            onexit = function(inst)
                if inst.sg.statemem.cb ~= nil then
                    -- in case of interruption
                    inst.sg.statemem.cb()
                    inst.sg.statemem.cb = nil
                end
                inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
                --Cleanup from openwardobe state
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:EnableMapControls(true)
                    inst.components.playercontroller:Enable(true)
                end
                inst.components.inventory:Show()
                inst:ShowActions(true)
            end,
        },

        State {
            name = "hit_weaver",
            tags = { "busy", "pausepredict" },

            onenter = function(inst, attacker)
                ForceStopHeavyLifting(inst)
                inst.components.locomotor:Stop()
                inst:ClearBufferedAction()

                if attacker ~= nil then
                    inst:ForceFacePoint(attacker.Transform:GetWorldPosition())
                end

                inst.AnimState:PlayAnimation("lighthit_back")

                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                DoHurtSound(inst)

                --V2C: some of the woodie's were-transforms have shorter hit anims
                local stun_frames = math.min(math.floor(inst.AnimState:GetCurrentAnimationLength() / FRAMES + .5),
                    attacker and 10 or 6)
                if inst.components.playercontroller ~= nil then
                    --Specify min frames of pause since "busy" tag may be
                    --removed too fast for our network update interval.
                    inst.components.playercontroller:RemotePausePrediction(stun_frames <= 7 and stun_frames or nil)
                end
                inst.sg:SetTimeout(stun_frames * FRAMES)
            end,

            ontimeout = function(inst)
                inst.sg:GoToState("idle", true)
            end,

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
            name = "opossum_death",
            tags = { "hiding", "notalking", "nomorph", "busy", "nopredict", "nodangle" },

            onenter = function(inst)
                inst.components.locomotor:Stop()

                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                inst.AnimState:PlayAnimation("death2_idle")

                --inst.SoundEmitter:PlaySound("dontstarve/wilson/death")
                --inst.AnimState:PlayAnimation("death")
            end,

            timeline =
            {
                TimeEvent(24 * FRAMES, function(inst)
                    inst.sg:RemoveStateTag("busy")
                    inst.sg:RemoveStateTag("nopredict")
                    inst.sg:AddStateTag("idle")
                end),
            },

            events =
            {
                EventHandler("ontalk", function(inst)
                    if inst.sg.statemem.talktask ~= nil then
                        inst.sg.statemem.talktask:Cancel()
                        inst.sg.statemem.talktask = nil
                        StopTalkSound(inst, true)
                    end
                    if DoTalkSound(inst) then
                        inst.sg.statemem.talktask =
                            inst:DoTaskInTime(1.5 + math.random() * .5,
                                function()
                                    inst.sg.statemem.talktask = nil
                                    StopTalkSound(inst)
                                end)
                    end
                end),
                EventHandler("donetalking", function(inst)
                    if inst.sg.statemem.talktalk ~= nil then
                        inst.sg.statemem.talktask:Cancel()
                        inst.sg.statemem.talktask = nil
                        StopTalkSound(inst)
                    end
                end),
                EventHandler("unequip", function(inst, data)
                    -- We need to handle this during the initial "busy" frames
                    if not inst.sg:HasStateTag("idle") then
                        inst.sg:GoToState("idle")
                    end
                end),
            },

            onexit = function(inst)
                if inst.sg.statemem.talktask ~= nil then
                    inst.sg.statemem.talktask:Cancel()
                    inst.sg.statemem.talktask = nil
                    StopTalkSound(inst)
                end
            end,
        },

        State {
            name = "cast_net_fixed",
            tags = { "doing", "busy" },

            onenter = function(inst, silent)
                inst.components.locomotor:Stop()
                --inst.AnimState:PlayAnimation("cast_pre")
                --inst.AnimState:PushAnimation("cast_loop", true)
                inst.AnimState:PlayAnimation("fishing_ocean_pre")
                inst.AnimState:PushAnimation("fishing_ocean_cast", false)
                inst.AnimState:PushAnimation("fishing_ocean_cast_loop", true)
                --inst.sg.statemem.action = inst.bufferedaction
                --inst.sg.statemem.silent = silent
                --inst.sg:SetTimeout(10 * FRAMES)
            end,

            timeline =
            {
                TimeEvent(6 * FRAMES, function(inst)
                    inst.AnimState:ClearOverrideSymbol("swap_object")

                    inst:PerformBufferedAction()
                end),
            },

            events =
            {
                EventHandler("begin_retrieving", function(inst)
                    inst.sg:GoToState("cast_net_retrieving_fixed")
                end),
            },

            --[[
        ontimeout = function(inst)
            --pickup_pst should still be playing
            inst.sg:GoToState("idle", true)
        end,
        ]] --

            --[[
        onexit = function(inst)
            if inst.bufferedaction == inst.sg.statemem.action and
            (inst.components.playercontroller == nil or inst.components.playercontroller.lastheldaction ~= inst.bufferedaction) then
                inst:ClearBufferedAction()
            end
        end,
        ]] --
        },

        State {
            name = "cast_net_retrieving_fixed",
            tags = { "doing", "busy" },

            onenter = function(inst, silent)
                --inst.AnimState:PlayAnimation("cast_pst")
                --inst.AnimState:PushAnimation("return_pre")
                --inst.AnimState:PushAnimation("return_loop", true)
                inst.AnimState:PlayAnimation("fishing_ocean_catch")
                inst.AnimState:PushAnimation("fishing_ocean_pst")
            end,

            events =
            {
                EventHandler("begin_final_pickup", function(inst)
                    inst.sg:GoToState("cast_net_release_fixed")
                end),
            },
        },

        State {
            name = "cast_net_release_fixed",
            tags = { "doing", "busy" },

            onenter = function(inst, silent)
                --inst.AnimState:PlayAnimation("release_loop", false)

                inst.AnimState:OverrideSymbol("swap_object", "swap_boat_net", "swap_boat_net")
                inst.AnimState:PlayAnimation("pickup")
            end,

            events =
            {
                EventHandler("animqueueover", function(inst)
                    inst.sg:GoToState("cast_net_release_pst_fixed")
                end),
            }
        },

        State {
            name = "cast_net_release_pst_fixed",
            tags = { "doing" },

            onenter = function(inst, silent)
                inst.sg:RemoveStateTag("busy")
                --inst.AnimState:PlayAnimation("release_pst", false)
                inst.AnimState:PlayAnimation("pickup_pst", false)
            end,

            events =
            {
                EventHandler("animqueueover", function(inst)
                    inst.sg:GoToState("idle")
                end),
            }
        },


        State {
            name = "beegun",
            tags = { "attack", "notalking", "abouttoattack" },

            onenter = function(inst)
                inst.sg.statemem.target = inst.components.combat.target
                inst.components.combat:StartAttack()
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("speargun")

                inst.sg.statemem.abouttoattack = true

                if inst.components.combat.target then
                    if inst.components.combat.target and inst.components.combat.target:IsValid() then
                        inst:FacePoint(Point(inst.components.combat.target.Transform:GetWorldPosition()))
                    end
                end
            end,

            timeline =
            {

                TimeEvent(12 * FRAMES, function(inst)
                    local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                    if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
                        local buffaction = inst:GetBufferedAction()
                        local target = buffaction ~= nil and buffaction.target or nil
                        if target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target) then
                            inst.sg.statemem.abouttoattack = false
                            inst:PerformBufferedAction()
                        else
                            inst:ClearBufferedAction()
                            inst.sg:GoToState("idle")
                        end
                    else
                        inst:ClearBufferedAction()
                    end
                    -- inst.components.combat:DoAttack(inst.sg.statemem.target)
                    --inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_speargun")
                end),
                TimeEvent(20 * FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
            },

            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg:GoToState("idle")
                end),
            },
        },

        State {
            name = "beegun_short",
            tags = { "attack", "notalking", "abouttoattack" },

            onenter = function(inst)
                inst.sg.statemem.target = inst.components.combat.target
                inst.components.combat:StartAttack()
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("speargun")
                inst.AnimState:SetTime(5 * FRAMES)

                inst.sg.statemem.abouttoattack = true

                if inst.components.combat.target then
                    if inst.components.combat.target and inst.components.combat.target:IsValid() then
                        inst:FacePoint(Point(inst.components.combat.target.Transform:GetWorldPosition()))
                    end
                end
            end,

            timeline =
            {

                TimeEvent(6 * FRAMES, function(inst)
                    local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                    if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
                        local buffaction = inst:GetBufferedAction()
                        local target = buffaction ~= nil and buffaction.target or nil
                        if target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target) then
                            inst.sg.statemem.abouttoattack = false
                            inst:PerformBufferedAction()
                        else
                            inst:ClearBufferedAction()
                            inst.sg:GoToState("idle")
                        end
                    else
                        inst:ClearBufferedAction()
                    end
                    -- inst.components.combat:DoAttack(inst.sg.statemem.target)
                    --inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_speargun")
                end),
                TimeEvent(20 * FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
            },

            events =
            {
                EventHandler("animover", function(inst)
                    inst.sg:GoToState("idle")
                end),
            },
        },

        State {
            name = "collectthebees",
            tags = { "doing", "busy", "canrotate" },

            onenter = function(inst)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(false)
                end
                inst.AnimState:PlayAnimation("staff_pre")
                inst.AnimState:PushAnimation("staff", false)

                --inst.AnimState:PushAnimation("staff", false)
                inst.components.locomotor:Stop()

                --Spawn an effect on the player's location
                local staff = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                local colour = staff ~= nil and staff.fxcolour or { 1, 1, 1 }

                inst.sg.statemem.stafffx = SpawnPrefab("bee_poof_big")
                inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
                inst.sg.statemem.stafffx.entity:AddFollower()
                inst.sg.statemem.stafffx.Follower:FollowSymbol(inst.GUID, "swap_object", 30, 0, 0.1)
            end,

            timeline =
            {
                TimeEvent(13 * FRAMES, function(inst)
                    inst.sg.statemem.stafffx = nil --Can't be cancelled anymore
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/taunt")
                    inst:PerformBufferedAction()
                end),
            },

            events =
            {
                EventHandler("animqueueover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end),
            },

            onexit = function(inst)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
                    inst.sg.statemem.stafffx:Remove()
                end
            end,
        },

        State {
            name = "dreadeye_spooked",
            tags = { "busy", "pausepredict" },

            onenter = function(inst)
                ForceStopHeavyLifting(inst)
                inst.components.locomotor:Stop()
                inst:ClearBufferedAction()

                inst.AnimState:PlayAnimation("spooked")

                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:RemotePausePrediction()
                end
            end,

            timeline =
            {
                TimeEvent(20 * FRAMES, function(inst)
                    if inst.components.talker ~= nil then
                        inst.components.talker:Say(GetString(inst, "ANNOUNCE_DREADEYE_SPOOKED"))
                    end
                end),
                TimeEvent(49 * FRAMES, function(inst)
                    inst.sg:GoToState("idle", true)
                end),
            },

            events =
            {
                EventHandler("ontalk", function(inst)
                    if inst.sg.statemem.talktask ~= nil then
                        inst.sg.statemem.talktask:Cancel()
                        inst.sg.statemem.talktask = nil
                        StopTalkSound(inst, true)
                    end
                    if DoTalkSound(inst) then
                        inst.sg.statemem.talktask =
                            inst:DoTaskInTime(1.5 + math.random() * .5,
                                function()
                                    inst.sg.statemem.talktask = nil
                                    StopTalkSound(inst)
                                end)
                    end
                end),
                EventHandler("donetalking", function(inst)
                    if inst.sg.statemem.talktalk ~= nil then
                        inst.sg.statemem.talktask:Cancel()
                        inst.sg.statemem.talktask = nil
                        StopTalkSound(inst)
                    end
                end),
                EventHandler("animover", function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end),
            },

            onexit = function(inst)
                if inst.sg.statemem.talktask ~= nil then
                    inst.sg.statemem.talktask:Cancel()
                    inst.sg.statemem.talktask = nil
                    StopTalkSound(inst)
                end
            end,
        },

        State {
            name = "charles_charge",
            tags = { "canrotate", "busy" },

            onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.components.locomotor:EnableGroundSpeedMultiplier(false)

                local buffaction = inst:GetBufferedAction()
                if buffaction ~= nil and buffaction.pos ~= nil then
                    inst:ForceFacePoint(buffaction:GetActionPoint():Get())
                elseif buffaction ~= nil and buffaction.target ~= nil then
                    inst:ForceFacePoint(buffaction.target:GetPosition())
                end

                inst:PerformBufferedAction()
                --inst.AnimState:PlayAnimation("spearjab_pre")
                --inst.AnimState:PushAnimation("spearjab", false)

                inst.AnimState:PlayAnimation("spearjab")

                local fxcircle = SpawnPrefab("dreadeye_sanityburstring")
                fxcircle:AddTag("ignore_transparency")
                fxcircle.Transform:SetScale(1.3, 1.3, 1.3)
                fxcircle.entity:SetParent(inst.entity)
            end,

            timeline =
            {
                TimeEvent(0 * FRAMES, function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/attack")

                    inst.Physics:SetMotorVelOverride(20, 0, 0)

                    Check_Bowling(inst)
                end),

                TimeEvent(5 * FRAMES, function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.Physics:SetMotorVelOverride(15, 0, 0)
                    Check_Bowling(inst)
                end),

                TimeEvent(10 * FRAMES, function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.Physics:SetMotorVelOverride(10, 0, 0)
                    Check_Bowling(inst)
                end),

                TimeEvent(15 * FRAMES, function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.Physics:SetMotorVelOverride(5, 0, 0)
                    Check_Bowling(inst)
                end),

                TimeEvent(18 * FRAMES, function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:EnableGroundSpeedMultiplier(true)

                    inst.sg:RemoveStateTag("busy")
                end),
            },

            events =
            {
                EventHandler("animqueueover", function(inst)
                    inst.sg:GoToState("idle")
                end),
            },

            onexit = function(inst)
                inst.components.locomotor:EnableGroundSpeedMultiplier(true)
                inst.Physics:ClearMotorVelOverride()
            end,
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

    for k, v in pairs(actionhandlers) do
        assert(v:is_a(ActionHandler), "Non-action added in mod state table!")
        inst.actionhandlers[v.action] = v
    end
end)

local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("wilson_client", function(inst)

    local TIMEOUT = 2

    local function ClearStatusAilments(inst)
        if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
            inst.components.freezable:Unfreeze()
        end
        if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
            inst.components.pinnable:Unstick()
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
        end)
    }

    local _OldSpellCast = inst.actionhandlers[ACTIONS.CASTSPELL].deststate
    inst.actionhandlers[ACTIONS.CASTSPELL].deststate =
    function(inst, action, ...)
        if action.invobject ~= nil then
            if action.invobject:HasTag("lighter") then
                return "castspelllighter"
            elseif action.invobject:HasTag("beargerclaw") then
                if inst.components.rider and inst.components.rider:IsRiding() then
                    inst.components.rider:Dismount()
                else
                    return "bearclaw_dig_start"
                end
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

    --[[
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
]]
    local actionhandlers =
    {
        --[[ActionHandler(ACTIONS.CASTSPELL,
        function(inst, action)
            return action.invobject ~= nil
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
                return action.invobject ~= nil
                and action.invobject:HasTag("powercell") and "doshortaction"
            end),
            ActionHandler(ACTIONS.NAME_FOCUS, "doshortaction"),
    }

    --[[
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
	]]

    local states = {

        State {
            name = "castspelllighter",
            tags = { "doing", "busy", "canrotate" },

            onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("staff_pre")
                inst.AnimState:PushAnimation("staff_lag", false)

                inst:PerformPreviewBufferedAction()
                inst.sg:SetTimeout(TIMEOUT)
            end,

            onupdate = function(inst)
                if inst:HasTag("doing") then
                    if inst.entity:FlattenMovementPrediction() then
                        inst.sg:GoToState("idle", "noanim")
                    end
                elseif inst.bufferedaction == nil then
                    inst.sg:GoToState("idle")
                end
            end,

            ontimeout = function(inst)
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
            end,
        },

        State {
            name = "bearclaw_dig_start",
            tags = { "busy", "attack" },

            onenter = function(inst)
                inst.AnimState:PlayAnimation("shovel_pre")
                inst.AnimState:PushAnimation("shovel_loop", false)

                inst:PerformPreviewBufferedAction()
                inst.sg:SetTimeout(TIMEOUT)
            end,

            ontimeout = function(inst)
                inst.AnimState:PlayAnimation("shovel_pst")
                inst.sg:GoToState("idle", true)
            end,
        },

        State {
            name = "curse_controlled",
            tags = { "busy", "sneeze", "pausepredict" },

            onenter = function(inst)
                inst.entity:SetIsPredictingMovement(false)
                inst.entity:FlattenMovementPrediction()

                if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
                    inst.AnimState:PlayAnimation("sneeze")
                end

                inst.sg:SetTimeout(TIMEOUT)
            end,

            onupdate = function(inst)
                if inst:HasTag("busy") and
                    inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("mindcontrolled_pst")
                end
            end,

            ontimeout = function(inst)
                inst.sg:GoToState("mindcontrolled_pst")
            end,

            onexit = function(inst)
                inst.entity:SetIsPredictingMovement(true)
            end,
        },

        State {
            name = "sneeze",
            tags = { "busy", "sneeze" },

            onenter = function(inst)
                inst.entity:SetIsPredictingMovement(false)
                inst.entity:FlattenMovementPrediction()

                if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
                    inst.AnimState:PlayAnimation("sneeze")
                end

                inst.sg:SetTimeout(2)
            end,

            onupdate = function(inst)
                if inst:HasTag("busy") and
                    inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            end,

            ontimeout = function(inst)
                inst.sg:GoToState("idle", "noanim")
            end,

            onexit = function(inst)
                inst.entity:SetIsPredictingMovement(true)
            end,
        },

        State {
            name = "play_pied_piper_flute",
            tags = { "doing", "playing" },

            onenter = function(inst)
                inst.components.locomotor:Stop()
                inst.AnimState:PlayAnimation("action_uniqueitem_pre")
                inst.AnimState:PushAnimation("whistle", false)
                inst.AnimState:OverrideSymbol("hound_whistle01", "pied_piper_flute", "hound_whistle01")
                inst.AnimState:Show("ARM_normal")

                inst:PerformPreviewBufferedAction()
                inst.sg:SetTimeout(TIMEOUT)
            end,

            onupdate = function(inst)
                if inst:HasTag("doing") then
                    if inst.entity:FlattenMovementPrediction() then
                        inst.sg:GoToState("idle", "noanim")
                    end
                elseif inst.bufferedaction == nil then
                    inst.sg:GoToState("idle")
                end
            end,

            ontimeout = function(inst)
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
            end,
        },

        State {
            name = "force_klaus_attack",
            tags = { "busy", "attack", "notalking", "abouttoattack", "autopredict" },

            onenter = function(inst)
                --[[if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end]]
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
                            inst:PerformBufferedAction()
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
                        inst:PerformBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                    elseif inst.sg.statemem.ischop then
                        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
                    end
                end),
                TimeEvent(7 * FRAMES, function(inst)
                    if inst.sg.statemem.ismoose then
                        inst:PerformBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                    end
                end),
                TimeEvent(8 * FRAMES, function(inst)
                    if not (inst.sg.statemem.isbeaver or
                        inst.sg.statemem.ismoose or
                        inst.sg.statemem.iswhip or
                        inst.sg.statemem.isbook) and
                        inst.sg.statemem.projectiledelay == nil then
                        inst:PerformBufferedAction()
                        inst.sg:RemoveStateTag("abouttoattack")
                        inst.sg:RemoveStateTag("busy")
                    end
                end),
                TimeEvent(10 * FRAMES, function(inst)
                    if inst.sg.statemem.iswhip or inst.sg.statemem.isbook then
                        inst:PerformBufferedAction()
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
            tags = { "busy", "dead", "pausepredict", "nomorph" },

            onenter = function(inst)
                assert(inst.deathcause ~= nil, "Entered death state without cause.")

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
                        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        if item ~= nil then
                            inst.components.inventory:DropItem(item)
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

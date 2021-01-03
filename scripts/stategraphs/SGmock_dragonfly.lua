require("stategraphs/commonstates")

TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME = 240
TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED = 40
TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED = 20

local function onattackedfn(inst, data)
    if inst.components.health and not inst.components.health:IsDead()
    and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
        if inst.components.combat and data and data.attacker then inst.components.combat:SuggestTarget(data.target) end
        inst.sg:GoToState("hit")
    end
end

--local SHAKE_DIST = 40
local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .8, inst, 40)
end

local actionhandlers = 
{
    --ActionHandler(ACTIONS.GOHOME, "taunt"),     
    ActionHandler(ACTIONS.LAVASPIT, "spit"),
    ActionHandler(ACTIONS.PICKUP, "eat"),
}

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnDeath(),
    EventHandler("attacked", onattackedfn),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle", true)
        end,
    },

    State{
        name = "eat",
        tags = {"idle", "busy", "eat"},
        
        onenter = function(inst)
            if inst.ashes then 
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("eat")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/suckup")
                inst.last_spit_time = GetTime() -- treat this as a spit so he doesn't go directly to a spit
                if inst.ashes then 
                    inst.num_ashes_eaten = inst.num_ashes_eaten + (inst.ashes.components.stackable and inst.ashes.components.stackable:StackSize() or 1)
                    inst.ashes:VacuumUp()
                end
            else
                inst.sg:GoToState("idle")
            end
        end,

        onexit = function(inst)
            inst:ClearBufferedAction()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/chew") end),
            TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/chew") end),
            TimeEvent(31*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/chew") end),
            TimeEvent(34*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
        },
    },

    State{
        name = "spit",
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.target ~= nil and ((inst.target ~= inst and not inst.target:HasTag("fire")) or inst.target == inst) and not (inst.recently_frozen or inst.flame_on) then
                inst.Transform:SetTwoFaced()
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end
                inst.AnimState:PlayAnimation("vomit")
                inst.vomitfx = SpawnPrefab("vomitfire_fx")
                inst.vomitfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.vomitfx.Transform:SetRotation(inst.Transform:GetRotation())
				inst:DoTaskInTime(2.2, function(inst)
				inst.spittle = SpawnPrefab("lavaspit")
                inst.spittle.Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.spittle.Transform:SetRotation(inst.Transform:GetRotation())
				end)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/vomitrumble", "vomitrumble")
            else
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
            end
        end,

        onexit = function(inst)
            if inst.last_target and inst.last_target ~= inst then
                inst.num_targets_vomited = inst.last_target.components.stackable and inst.num_targets_vomited + inst.last_target.components.stackable:StackSize() or inst.num_targets_vomited + 1
                inst.last_target_spit_time = GetTime()
            end
            inst.Transform:SetSixFaced()
            if inst.vomitfx then 
                inst.vomitfx:Remove() 
            end
            inst.vomitfx = nil
            inst.SoundEmitter:KillSound("vomitrumble")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.sg:GoToState("idle") 
            end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(55*FRAMES, function(inst) 
                inst.SoundEmitter:KillSound("vomitrumble")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/vomit")
            end),
            TimeEvent(59*FRAMES, function(inst) 
                inst:PerformBufferedAction()
                inst.last_target = inst.target
                inst.target = nil
                inst.spit_interval = math.random(20,30)
                inst.last_spit_time = GetTime()
            end),
        },
    },
    
	State{
        name = "taunt_pre",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt_pre")
            inst.last_target_spit_time = nil -- Aggro, no longer care about spit timing
            inst.last_spit_time = nil -- Aggro, no longer care about spit timing
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(6*FRAMES, function(inst)
                if inst.components.health:GetPercent() <= 0.5 then
					inst.AnimState:SetBuild("dragonfly_fire_build")
					inst.SoundEmitter:KillSound("fireflying")
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/firedup", "fireflying")
					---inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
					inst.Light:Enable(true)
					inst.components.propagator:StartSpreading()
				end
                inst.fire_build = true
            end),
        },
    },

    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            local tauntfx = SpawnPrefab("tauntfire_fx")
            tauntfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            tauntfx.Transform:SetRotation(inst.Transform:GetRotation())
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt_post") end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
            TimeEvent(9*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
            TimeEvent(20*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
        },
    },

    State{
        name = "taunt_post",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("taunt_pst")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
        },
    },

    State{
        name = "flameoff",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("flame_off")
            inst.last_target_spit_time = GetTime() -- Fake this as a target spit to make him not re-aggro immediately
            inst.last_spit_time = GetTime() -- Fake this as a target spit to make him not re-aggro immediately
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(5*FRAMES, function(inst)
                local firefx = SpawnPrefab("firesplash_fx")
                firefx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.flame_on = false
                inst.Light:Enable(false)
                --inst.AnimState:ClearBloomEffectHandle()
                inst.components.propagator:StopSpreading()
                inst.AnimState:SetBuild("dragonfly_build")
                inst.fire_build = false
            end),
        },
    },

    State{
        name = "hit",
        tags = {"hit", "busy"},
        
        onenter = function(inst, cb)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) 
                if inst.flame_on and not inst.fire_build and inst.components.health:GetPercent() > 0.5 then
                    inst.sg:GoToState("idle")
                else
					if inst.components.health:GetPercent() <= 0.5 then
						inst.sg:GoToState("taunt_pre")
					else
						inst.sg:GoToState("idle")
					end
                end
            end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "busy", "canrotate"},
        
        onenter = function(inst)
            if not (inst.flame_on or not inst.fire_build) and inst.components.health:GetPercent() <= 0.5 then
                inst.flame_on = true
                inst.sg:GoToState("taunt_pre")
            else
				if inst.components.health:GetPercent() > 0.5 then
					inst.components.locomotor:StopMoving()
				end
				
                inst.components.combat:StartAttack()
                inst.AnimState:PlayAnimation("atk")
                local attackfx = SpawnPrefab("attackfire_fx")
                attackfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                attackfx.Transform:SetRotation(inst.Transform:GetRotation())
                --inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/swipe")
            end
        end,

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/swipe") end),
            TimeEvent(15*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/punchimpact")
                inst.components.combat:DoAttack()
                if inst.components.combat.target and inst.components.combat.target.components.health then
                    inst.components.combat.target.components.health:DoFireDamage(5)
                end
            end),
        },
        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "death",  
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.Light:Enable(false)
            --inst.AnimState:ClearBloomEffectHandle()
            inst.components.propagator:StopSpreading()
            -- inst.AnimState:SetBuild("dragonfly_build")
            inst.AnimState:PlayAnimation("death")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/death")
            inst.Physics:ClearCollisionMask()
        end,

        timeline=
        {
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(26*FRAMES, function(inst) 
                inst.SoundEmitter:KillSound("flying") 
                inst.SoundEmitter:KillSound("fireflying")
            end),
            TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land") end),
            TimeEvent(29*FRAMES, function(inst)
                ShakeIfClose(inst)
                inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
            end),
        },

    },

    State{
            name = "walk_start",
            tags = {"moving", "canrotate"},

            onenter = function(inst)
                if inst.fire_build then
                    inst.AnimState:PlayAnimation("walk_angry_pre")
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry")
                else
                    inst.AnimState:PlayAnimation("walk_pre")
                end
                inst.components.locomotor:WalkForward()
            end,

            events =
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
            },

            timeline=
            {
                TimeEvent(1*FRAMES, function(inst) if not inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end),
                TimeEvent(2*FRAMES, function(inst) if inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end)
            },
        },
        
    State{
            
            name = "walk",
            tags = {"moving", "canrotate"},
            
            onenter = function(inst) 
                inst.components.locomotor:WalkForward()
                if inst.fire_build then
                    inst.AnimState:PlayAnimation("walk_angry")
                    if math.random() < .5 then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry") end
                else
                    inst.AnimState:PlayAnimation("walk")
                end
            end,
            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
            },
        },        
    
    State{
            
            name = "walk_stop",
            tags = {"canrotate"},
            
            onenter = function(inst) 
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end

                local should_softstop = false
                if should_softstop then
                    if inst.fire_build then
                        inst.AnimState:PushAnimation("walk_angry_pst", false)
                    else
                        inst.AnimState:PushAnimation("walk_pst", false)
                    end
                else
                    if inst.fire_build then
                        inst.AnimState:PlayAnimation("walk_angry_pst")
                    else
                        inst.AnimState:PlayAnimation("walk_pst")
                    end
                end
            end,

            events=
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end ),        
            },

            timeline=
            {
                TimeEvent(1*FRAMES, function(inst) if not inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end),
                TimeEvent(2*FRAMES, function(inst) if inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end)
            },
        },

        State{
            name = "sleep",
            tags = {"busy", "sleeping"},
            
            onenter = function(inst) 
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end
                inst.last_target_spit_time = nil -- Unset spit timers so he doesn't aggro while sleeping
                inst.last_spit_time = nil -- Unset spit timers so he doesn't aggro while sleeping
                inst.AnimState:PlayAnimation("land")
                inst.AnimState:PushAnimation("land_idle", false)
                inst.AnimState:PushAnimation("takeoff", false)
                inst.AnimState:PushAnimation("sleep_pre", false)
            end,

            events=
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("sleeping") end ),        
                EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
            },

            timeline=
            {
                TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:KillSound("flying") end),
                TimeEvent(16*FRAMES, function(inst) 
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") 
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land")
                    if inst.fire_build then
                        inst.SoundEmitter:KillSound("fireflying")
                        local firefx = SpawnPrefab("firesplash_fx")
                        firefx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                        inst.flame_on = false
                        inst.Light:Enable(false)
                        --inst.AnimState:ClearBloomEffectHandle()
                        inst.components.propagator:StopSpreading()
                        inst.AnimState:SetBuild("dragonfly_build")
                        inst.fire_build = false
                    end
                end),
                TimeEvent(74*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
                TimeEvent(78*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying") end),
                TimeEvent(91*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
                TimeEvent(111*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/sleep_pre") end),
                TimeEvent(202*FRAMES, function(inst) 
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") 
                    inst.SoundEmitter:KillSound("flying")
                end),
                TimeEvent(203*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land") end),
            },
        },
        
        State{
            name = "sleeping",
            tags = {"busy", "sleeping"},
            
            onenter = function(inst) 
                inst.AnimState:PlayAnimation("sleep_loop")
                inst.playsleepsound = not inst.playsleepsound
                if inst.playsleepsound then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/sleep", "sleep")
                end
            end,

            onexit = function(inst)
            end,

            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end ),        
                EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
            },
        },        
    
        State{
            name = "wake",
            tags = {"busy", "waking"},
            
            onenter = function(inst) 
                inst.SoundEmitter:KillSound("sleep")
                inst.components.locomotor:StopMoving()
                inst.AnimState:PlayAnimation("sleep_pst")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/wake")
                inst.last_spit_time = GetTime() -- Fake this as a spit to make him not re-aggro immediately
                inst.last_target_spit_time = GetTime() -- Fake this as a target spit to make him not re-aggro immediately
                if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
                    inst.components.sleeper:WakeUp()
                end
            end,

            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
            },

            timeline=
            {
                TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
                TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying") end),
            },
        },      
}

--CommonStates.AddFrozenStates(states)

CommonStates.AddFrozenStates(states,
    function(inst) --onoverridesymbols
        inst.SoundEmitter:KillSound("flying")
        if inst.enraged then
            inst:TransformNormal()
            inst.SoundEmitter:KillSound("fireflying")
        end
    end,
    function(inst) --onclearsymbols
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying")
    end
)

return StateGraph("mock_dragonfly", states, events, "idle", actionhandlers)


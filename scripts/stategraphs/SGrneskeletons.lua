require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "eat"),
    ActionHandler(ACTIONS.INVESTIGATE, "investigate"),
}

local events=
{
    EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("no_stun") and not inst.sg:HasStateTag("attack") then 
            inst.sg:GoToState("hit")  -- can't attack during hit reaction
        end 
    end),
    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade")  and data and data.target  then 
        inst.sg:GoToState("attack", data.target) 
        end 
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    
    
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade")  then
            
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("premoving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),    
}

local states=
{
    
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
			inst.Physics:Stop()
			RemovePhysicsColliders(inst) 
            inst.AnimState:PlayAnimation("death_fallapart")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
        end,
		timeline=
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
        },
    },    
    State{
        name = "grounded",
        tags = {"busy","no_stun"},
        
        onenter = function(inst)
			inst.Physics:Stop()
			RemovePhysicsColliders(inst) 
            inst.AnimState:PlayAnimation("jump")
        end,
		timeline=
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
        },
        events=
        {
            EventHandler("animover", function(inst) 
		local x, y, z = inst.Transform:GetWorldPosition()
		local despawnfx = SpawnPrefab("maxwell_smoke")
		despawnfx.Transform:SetPosition(x, y, z)
		inst:Remove()
		end),
       },
},
    State{
        name = "enter",
        tags = {"busy"},
        
        onenter = function(inst)
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
            inst.AnimState:PlayAnimation("jump")
        end,
		timeline=
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(18*FRAMES, function(inst) inst.sg:GoToState("idle") end),
        },
},
    State{
        name = "dance",
        tags = {"idle", "busy", "dancing"},
        onenter = function(inst)

            inst.AnimState:PlayAnimation("emoteXL_pre_dance0")
            inst.AnimState:PushAnimation("emoteXL_loop_dance0", true)
			inst.components.locomotor:Stop()

        end,
		--EventHandler("animover", function(inst) inst.sg:GoToState("dance") end),
    },
    State{
        name = "premoving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
        end,
        
        timeline=
        {
            TimeEvent(3*FRAMES, PlayFootstep),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
    },
    
    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PushAnimation("walk_loop")
        end,
        
        timeline=
        {
            TimeEvent(4*FRAMES, PlayFootstep),
            TimeEvent(8*FRAMES, PlayFootstep),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
        
    },    
    
    
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        ontimeout = function(inst)
			inst.sg:GoToState("taunt")
        end,
        
        onenter = function(inst)
            inst.Physics:Stop()
            local animname = "idle"
            if math.random() < .3 then
				inst.sg:SetTimeout(math.random()*2 + 2)
			end

			inst.AnimState:PlayAnimation("idle", true)

        end,
    },



    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
    
    State{
        name = "investigate",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("idle")
            end),
        },
    },    
    
    State{
        name = "attack",
        tags = {"attack", "busy", "no_stun"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk",false)
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("moving") end),
        },
    },


    State{
        name = "leap_attack",
        tags = {"attack", "canrotate", "busy", "jumping"},

		
		onenter = function(inst)
		inst.components.combat:SetRange(2*TUNING.SPIDER_WARRIOR_ATTACK_RANGE, 2*TUNING.SPIDER_WARRIOR_HIT_RANGE)
            inst.sg:SetTimeout(21*FRAMES)                  
            --if inst.components.combat.target and inst.components.combat.target:IsValid() then
                inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
            --end   
            inst.components.locomotor:Stop()           
            inst.AnimState:PlayAnimation("atk")
            --inst.Physics:SetMotorVelOverride(20,0,0)
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        end,
		
		ontimeout = function(inst)
            inst.sg:GoToState("taunt")
			inst.components.combat:SetRange(3, 3)
        end,


        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,
		
		timeline =
        {
            TimeEvent(8	*FRAMES, function(inst) inst.Physics:SetMotorVelOverride(20,0,0) end),
            TimeEvent(19*FRAMES, function(inst) inst.components.combat:SetRange(4, 4)
			inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            TimeEvent(20*FRAMES,
                function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:Stop()
                end),
        },

        events=
        {
            --EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State{
        name = "hit",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
		if inst:HasTag("dancing") then
		inst:RemoveTag("dancing")
		end
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },    
    
    State{
        name = "hit_stunlock",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) 
            inst.sg:GoToState("idle") 
            end ),
        },
    },  
}

CommonStates.AddFrozenStates(states)

return StateGraph("rneskeleton", states, events, "idle", actionhandlers)


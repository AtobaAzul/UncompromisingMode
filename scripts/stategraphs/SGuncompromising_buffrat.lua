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
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("attack") then 
            inst.sg:GoToState("hit")  -- can't attack during hit reaction
        end 
    end),
    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and data and data.target  then
		inst.punchcount = 0
			if inst.mode == "offense" then
				inst.sg:GoToState("attack1", data.target) 
			else
				inst.sg:GoToState("attack_def", data.target)
			end 
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
            inst.AnimState:PlayAnimation("death")
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
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
			
			end),
        },
    },
    State{
        name = "premoving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
			if inst.mode == "offense" then
				inst.components.locomotor:WalkForward()
				inst.AnimState:PlayAnimation("walk_pre")
			else
				inst.AnimState:PlayAnimation("run_pre")
				inst.components.locomotor:RunForward()
			end
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
			if inst.mode == "offense" then
				inst.components.locomotor:WalkForward()
				inst.AnimState:PlayAnimation("walk_loop")
			else
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("run_loop")
			end
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
        
        --[[ontimeout = function(inst)
			inst.sg:GoToState("taunt")
        end,
        ]]
        onenter = function(inst)
            inst.Physics:Stop()
            if math.random() < .3 then
				inst.sg:SetTimeout(math.random()*2 + 2)
			end

			if inst.mode == "offense" then
				inst.AnimState:PlayAnimation("idle_loop")
			else
				inst.AnimState:PlayAnimation("block_loop")
			end
		end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
 
    },



    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
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
			if inst.mode == "offense" then
				inst.AnimState:PlayAnimation("idle_loop")
			else
				inst.AnimState:PlayAnimation("block_loop")
			end
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
        name = "attack_def",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("block_counter")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
				inst.sg:GoToState("idle")
			end),
        },
    },
	
    State{
        name = "attack1",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack1")
            inst.sg.statemem.target = target
			inst.punchcount = inst.punchcount + 1
        end,
        
        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
			if not inst.components.health:IsDead() and inst.components.health:GetPercent() < 0.5 and inst.components.combat.target ~= nil and inst.components.combat:CanHitTarget(inst.components.combat.target) then
				inst.sg:GoToState("attack2")
			else
				if inst:GetDistanceSqToInst(inst.components.combat.target) > 5 and inst:GetDistanceSqToInst(inst.components.combat.target) < 40 and inst.components.health:GetPercent() < 0.5 and math.random() < 1 then
					inst.sg:GoToState("leap_attack")
				else
					inst.sg:GoToState("attack1pst")
				end
			end
			end),
        },
    },

    State{
        name = "attack2",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack2")
            inst.sg.statemem.target = target
			inst.punchcount = inst.punchcount + 1
        end,
        
        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
			if not inst.components.health:IsDead() and inst.components.health:GetPercent() < 0.5 and inst.components.combat.target ~= nil and inst.components.combat:CanHitTarget(inst.components.combat.target) then
				if inst.punchcount < math.random(3,5) then
					inst.sg:GoToState("attack1")
				else
					inst.sg:GoToState("attack3")
				end
			else
				inst.sg:GoToState("attack2pst")
			end
			end),
        },
    },
	
    State{
        name = "attack3",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack3")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target)
					if inst.components.combat.target ~= nil and inst.components.combat:CanHitTarget(inst.components.combat.target) then--distsq(target:GetPosition(), inst:GetPosition()) <= 10 then
					--Don't knockback if you wear marble
						local target = inst.components.combat.target
						if target ~= nil and target.components.inventory ~= nil and not target:HasTag("fat_gang") and not target:HasTag("foodknockbackimmune") and not (target.components.rider ~= nil and target.components.rider:IsRiding()) and 
						--Don't knockback if you wear marble
							(target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
								target:PushEvent("knockback", {knocker = inst, radius = 150, strengthmult = 1})
						end
					end
					end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
				inst.sg:GoToState("idle")
			
			end),
        },
    },
	
    State{
        name = "attack1pst",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack1_pst")
            inst.sg.statemem.target = target
        end,
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
				inst.sg:GoToState("idle")
			
			end),
        },
    },
	
    State{
        name = "attack2pst",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("attack2_pst")
            inst.sg.statemem.target = target
        end,
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
				inst.sg:GoToState("idle")
			
			end),
        },
    },
    State{
        name = "defence_pre",
        tags = {"busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("block_pre")
        end,
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
				inst.components.health:SetAbsorptionAmount(0.8)
				inst.sg:GoToState("idle")
			end),
        },
    },
	
    State{
        name = "offense_pre",
        tags = {"busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("block_pst")
        end,
        
        events=
        {
            EventHandler("animqueueover", function(inst)
				inst.components.health:SetAbsorptionAmount(0)
				inst.sg:GoToState("taunt2")
			end),
        },
    },
    State{
        name = "taunt2",
        tags = {"busy","attack"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt2")
        end,
        

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst) 
				inst.components.combat:DoAreaAttack(inst, 3, nil, nil, nil, {"ratraid"})
            end),
            TimeEvent(9*FRAMES, function(inst) 
                inst.components.combat:DoAreaAttack(inst, 3, nil, nil, nil, {"ratraid"})
            end),
            TimeEvent(12*FRAMES, function(inst) 
                inst.components.combat:DoAreaAttack(inst, 3, nil, nil, nil, {"ratraid"})
            end),
            TimeEvent(20*FRAMES, function(inst) 
                inst.components.combat:DoAreaAttack(inst, 3, nil, nil, nil, {"ratraid"})
            end),
        },
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name = "hit",
        tags = {"busy"},
		
        onenter = function(inst)
			if inst.mode == "offense" then
				inst.AnimState:PlayAnimation("hit")
			elseif math.random() > 0 and inst.components.health ~= nil and inst.components.health:GetPercent() < 0.5 then
					inst.sg:GoToState("leap_attack")
				else
					inst.AnimState:PlayAnimation("block_hit")
			end
            inst.Physics:Stop()

        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

    State{
        name = "leap_attack",
        tags = {"attack", "canrotate", "busy", "jumping"},

		
		onenter = function(inst)                  
            --if inst.components.combat.target and inst.components.combat.target:IsValid() then
                inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
            --end   
            inst.components.locomotor:Stop()           
            
			if inst.mode == "offense" then
				inst.AnimState:PlayAnimation("bellyflop_pre")
			else
				inst.AnimState:PlayAnimation("bellyflop_block_pre")
			end		
			
			inst.AnimState:PushAnimation("bellyflop",false)
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        end,
		
        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,
		
		timeline =
        {
            TimeEvent(5	*FRAMES, function(inst) inst.Physics:SetMotorVelOverride(20,0,0) end),
            TimeEvent(19*FRAMES, function(inst) inst.components.combat:DoAreaAttack(inst, 3, nil, nil, nil, {"ratraid"}) end),
            TimeEvent(20*FRAMES,
                function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:Stop()
                end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },	
}

CommonStates.AddFrozenStates(states)

return StateGraph("SGuncompromising_buffrat", states, events, "idle", actionhandlers)


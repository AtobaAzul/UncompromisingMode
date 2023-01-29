require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "burrow"),
    ActionHandler(ACTIONS.PICKUP, "action"),
    ActionHandler(ACTIONS.PICK, "action"),
    ActionHandler(ACTIONS.HARVEST, "action"),
    ActionHandler(ACTIONS.EAT, "eat"),    
    --ActionHandler(ACTIONS.BUILDHOME, "buildhome"),
}

local events =
{

    EventHandler("entershield", function(inst, data)
        inst.sg:GoToState("burrow_sheild")
    end),  
    EventHandler("exitshield", function(inst, data)
        inst.sg:GoToState("emerge")
    end),        
    EventHandler("fly_in", function(inst, data)
        inst.sg:GoToState("enter_loop")
    end),
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            if not inst.sg:HasStateTag("attack") and not inst.sg:HasStateTag("shielding") then -- don't interrupt attack
                inst.sg:GoToState("hit") -- can still attack
            end
        end
    end),
    EventHandler("doattack", function(inst, data) 
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState(
                data.target:IsValid()
                and not inst:IsNear(data.target, 1.5)
                and "leap_attack" --Do leap attack
                or "attack",
                data.target
            )
        end
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnFreeze(),

    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                inst.sg:GoToState(wants_to_move and "premoving" or "idle")
            end
        end
    end),

    EventHandler("trapped", function(inst)
        if not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("trapped")
        end
    end),
}

local states =
{
    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("UCSounds/aphid/death")
            inst.AnimState:PlayAnimation("death")
            inst.AnimState:PushAnimation("dead")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
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
            inst.components.locomotor:WalkForward()
            inst.AnimState:PushAnimation("walk_loop")
        end,

        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/step") end),         
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/step") end),
            TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/step") end),
         },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
    },

    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        --ontimeout = function(inst)
        --    inst.sg:GoToState("taunt")
        --end,
 
        timeline=
        {
           
            --TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
         },

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
        --    if math.random() < .3 then
        --        inst.sg:SetTimeout(math.random()*2 + 2)
        --    end

            if start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation("idle")
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if math.random() < 0.01 then
                    inst.sg:GoToState("taunt")
                else  
                    inst.sg:GoToState("idle")
                end
            end),
        },        
    },


    State{
        name = "burrow_sheild",
        tags = {"busy","shielding"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("burrow")
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst) 
                inst.DynamicShadow:Enable(false) 
                inst.sg:AddStateTag("invisible")
                if inst.components.burnable:IsBurning() then
                    inst.components.burnable:Extinguish()
                end
            end),
        },
    },
    
    State{
        name = "burrow",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("burrow")
        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("UCSounds/aphid/dig", "move")
				inst.SoundEmitter:PlaySound("UCSounds/aphid/burrow")
            end),

            TimeEvent(9 * FRAMES, function(inst) 
                inst.DynamicShadow:Enable(false) 
                inst.sg:AddStateTag("invisible")
			end),
        },

        events =
        {
            EventHandler("animover", function(inst)
				inst:PerformBufferedAction()
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("move")        
        end,        
    },
	
    State{
        name = "emerge",
        tags = {"busy", "invisible"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("UCSounds/aphid/dig", "move")
            inst.SoundEmitter:PlaySound("UCSounds/aphid/burrow")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("unburrow")
            inst.AnimState:SetDeltaTimeMultiplier(GetRandomWithVariance(.9, .2))

			if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
			    inst:ForceFacePoint(inst.components.combat.target:GetPosition())
			end
        end,

		onexit = function(inst)
            inst.SoundEmitter:KillSound("move")
			inst.AnimState:SetDeltaTimeMultiplier(1)
			inst.DynamicShadow:Enable(true)
		end,

		timeline=
        {
            TimeEvent(0, function(inst) 
				if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
					inst:ForceFacePoint(inst.components.combat.target:GetPosition())
				end
			end),
            TimeEvent(32 * FRAMES, function(inst) inst.DynamicShadow:Enable(true) end),
        },

        events =
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

			if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
			    inst:ForceFacePoint(inst.components.combat.target:GetPosition())
			end

        end,

         timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),         
            
         },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    

    State{
        name = "enter_loop",
        tags = {"flight", "busy"},
        onenter = function(inst)
            inst.Physics:Stop()

            inst.AnimState:PlayAnimation("fly", true)

            inst.DynamicShadow:Enable(false)
            inst.components.health:SetInvincible(true)
            local x,y,z = inst.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x,15,z)
        end,

        onexit = function(inst)
			if not inst.sg.statemem.onground then
				local pt = Point(inst.Transform:GetWorldPosition())
				pt.y = 0
				inst.Physics:Stop()
				inst.Physics:Teleport(pt.x,pt.y,pt.z)
				inst.DynamicShadow:Enable(true)
				inst.components.health:SetInvincible(false)
			end
        end,

        onupdate= function(inst)
            inst.Physics:SetMotorVel(0,-10+math.random()*2,0)
            local pt = Point(inst.Transform:GetWorldPosition())

            if pt.y <= .1 or inst:IsAsleep() then
                pt.y = 0
                inst.Physics:Stop()
                inst.Physics:Teleport(pt.x,pt.y,pt.z)
                inst.DynamicShadow:Enable(true)
                inst.components.health:SetInvincible(false)
				inst.sg.statemem.onground = true
                inst.sg:GoToState("enter_pst")
            end
        end,

        timeline = {
        },

    },

    State{
        name = "enter_pst",
        tags = {"busy"},
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("land")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "action",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)

                if inst:PerformBufferedAction() then
                    inst.sg:GoToState("eat_loop")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	
    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)

                if inst:PerformBufferedAction() then
                    inst.sg:GoToState("eat_loop")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },  
    
    State{
        name = "eat_loop",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_loop", true)
            inst.sg:SetTimeout(1+math.random()*1)
        end,
        
        ontimeout = function(inst)
            inst.sg:GoToState("idle", "eat_pst")
        end,       
    },  


    State{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack")
            inst.sg.statemem.target = target
        end,

        timeline=
        {
            TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),

        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "leap_attack",
        tags = {"attack", "canrotate", "busy", "jumping"},

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("leap_attack")
            inst.sg.statemem.target = target

			if target ~= nil and target:IsValid() then
				inst:ForceFacePoint(target:GetPosition())
			end
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("buzz")
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,

        timeline =
        {
            TimeEvent(7*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("UCSounds/aphid/fly", "buzz")
            end),
            TimeEvent(17*FRAMES, function(inst) 
                inst.SoundEmitter:KillSound("buzz")
                inst.SoundEmitter:PlaySound("UCSounds/aphid/idle")
            end),

            TimeEvent(11*FRAMES, function(inst) 
				inst.Physics:SetMotorVelOverride(20,0,0)
			end),
            TimeEvent(18*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target)
			end),
            TimeEvent(19*FRAMES, function(inst) 
				inst.Physics:ClearMotorVelOverride()
	            inst.Physics:Stop()
			end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
			inst.SoundEmitter:PlaySound("UCSounds/aphid/walk")
            --inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/weevole/hit")
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },


    State{
        name = "flyintree",
        tags = {"busy", "jumping"},

        onenter = function(inst)
		inst.Physics:ClearMotorVelOverride()
		inst.AnimState:PlayAnimation("takeoff")
		inst.Physics:Stop()
        end,
        onupdate= function(inst)
            inst.Physics:SetMotorVel(0,10+math.random()*2,0)
        end,
        timeline =
        {
            TimeEvent(50*FRAMES, function(inst) inst:Remove() end),
		},
        events=
        {
            EventHandler("animover", function(inst) 		
			inst.AnimState:PushAnimation("fly")
			end)

        },
    },
}

CommonStates.AddFrozenStates(states)

return StateGraph("aphid", states, events, "emerge", actionhandlers)

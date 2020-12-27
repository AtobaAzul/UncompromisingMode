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
        if not inst.components.health:IsDead() and data and data.target  then 
        inst.sg:GoToState("attack", data.target) 
        end 
    end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnLocomote(false, true),   
}

local states=
{
    
    
    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
			inst.Physics:Stop()
			RemovePhysicsColliders(inst) 
            --inst.AnimState:PlayAnimation("death")
			local x, y, z = inst.Transform:GetWorldPosition()
		local fx = SpawnPrefab("statue_transition_2")
		if fx ~= nil then
			fx.Transform:SetPosition(x, y, z)
			fx.Transform:SetScale(1.2,1.2,1.2)
		end
		fx = SpawnPrefab("statue_transition")
		if fx ~= nil then
			fx.Transform:SetPosition(x, y, z)
			fx.Transform:SetScale(1.2,1.2,1.2)
		end
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
			inst:Remove()
        end,
		timeline=
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
			TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
        },

    },    
    
--[[
    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
			inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("shamble")
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.locomotor:RunForward() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },
        
    },]] 
    
    
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        ontimeout = function(inst)
			inst.sg:GoToState("taunt")
        end,
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            local animname = "idle"
            if math.random() < .3 then
				inst.sg:SetTimeout(math.random()*2 + 2)
			end

            if start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end

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
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/attack_VO") end),
            TimeEvent(13*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
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
CommonStates.AddWalkStates(states,
{
    starttimeline = 
    {
	    TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
    },
	walktimeline = {
		    TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
            TimeEvent(15*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/bounce")
                inst.components.locomotor:WalkForward()
            end ),
            --[[TimeEvent(25*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/land")
                inst.Physics:Stop()
            end ),]]
	},
}, nil,true)
CommonStates.AddFrozenStates(states)

return StateGraph("bight", states, events, "idle", actionhandlers)


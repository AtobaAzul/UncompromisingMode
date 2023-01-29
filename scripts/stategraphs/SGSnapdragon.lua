require("stategraphs/commonstates")

local actionhandlers = 
{
    --ActionHandler(ACTIONS.PICKUP, "doshortaction"),
    ActionHandler(ACTIONS.EAT, "eat"),
    --ActionHandler(ACTIONS.CHOP, "chop"),
    --ActionHandler(ACTIONS.PICKUP, "pickup"),
}


local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),

    EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() then inst.sg:GoToState("attack", data.target) end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("attacked", function(inst) if inst.components.health:GetPercent() > 0 and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),    
	EventHandler("onwakeup", function(inst) inst.SoundEmitter:PlaySound(inst.sounds.angry) end),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, pushanim)
            inst.components.locomotor:StopMoving()
            if inst.hairGrowthPending then
                inst.sg:GoToState("hair_growth")
            else
                inst.AnimState:PlayAnimation("idle", true)
                
                inst.sg:SetTimeout(2 + 2*math.random())
            end
        end,
        
        ontimeout=function(inst)
			if math.random() < .5 then
                inst.sg:GoToState("taunt")
			else
				inst.sg:GoToState("idle")
			end
        end,
    },

	State{
        name = "hit",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.angry)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
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
	
	State{
        name = "taunt",
        tags = {},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("taunt")
            
        end,
		
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.yell) end),
        },
		
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "create",
        tags = {},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep_pst")
			inst.SoundEmitter:PlaySound(inst.sounds.grunt)
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)    
			inst.sg.statemem.target = target
            inst.SoundEmitter:PlaySound(inst.sounds.angry)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_pre")
			inst.AnimState:PushAnimation("atk")
            --inst.AnimState:PushAnimation("atk", false)
			inst.AnimState:PushAnimation("atk_pst", false)
        end,
        
        
        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst, forced)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat")
            inst.sg.statemem.forced = forced
            inst.SoundEmitter:PlaySound("dontstarve/beefalo/eat_treat")
        end,

        timeline=
        {
            TimeEvent(18*FRAMES, function(inst) inst:PerformBufferedAction() end)
        },
		
        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState(inst:PerformBufferedAction() and "eat_loop" or "idle")
            end),
        },
    },
	
	State{
        name = "eat_loop",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_loop")
            inst.sg:SetTimeout(1+math.random()*1)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,       

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },      
    },  

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
			inst.SoundEmitter:PlaySound(inst.sounds.yell)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
}

CommonStates.AddWalkStates(
    states,
    {
        walktimeline = 
        { 
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk, nil, 0.1) end),
            TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk, nil, 0.1) end),
        }
    })
    
CommonStates.AddRunStates(
    states,
    {
        runtimeline = 
        { 
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk, nil, 0.1) end),
            TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.walk, nil, 0.1) end),
        }
    })

CommonStates.AddFrozenStates(states)

CommonStates.AddSleepStates(states,
{
    sleeptimeline = 
    {
        TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.grunt) end)
    },
})
    
return StateGraph("snapdragon", states, events, "idle", actionhandlers)


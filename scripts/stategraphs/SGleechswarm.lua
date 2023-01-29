require("stategraphs/commonstates")

local WALK_SPEED = 5

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "land"), 
	ActionHandler(ACTIONS.INFEST, "infest"),
}

local events=
{

    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then
			local is_moving = inst.sg:HasStateTag("moving")
			local wants_to_move = inst.components.locomotor:WantsToMoveForward()
			if is_moving ~= wants_to_move then
				if wants_to_move then
					inst.sg.statemem.wantstomove = true
				else
					inst.sg:GoToState("idle")
				end
			end
        end
    end),

    EventHandler("doattack", function(inst, data) inst.sg:GoToState("attack", data.target)  end),
    EventHandler("blocked", function(inst) inst.sg:GoToState("hit") end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	--EventHandler("unlcok
    CommonHandlers.OnFreeze(),
   -- CommonHandlers.OnLocomote(true,true),
}

local states=
{

    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            if inst.components.locomotor:WantsToRun() then
                inst.sg:GoToState("running",true)                
            else
			    inst.components.locomotor:WalkForward()
                inst.AnimState:PlayAnimation("idle_loop")
            end  
        end,
        


        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end),
        },        
    },

    State{
        name = "running",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst, pre)
            if not inst.components.locomotor:WantsToRun() then
                inst.sg:GoToState("moving")
            else
                inst.components.locomotor:RunForward()   
                if pre then
                    inst.AnimState:PlayAnimation("run_pre")
                    inst.AnimState:PushAnimation("run_loop")
                else
                    inst.AnimState:PlayAnimation("run_loop")
                end          
            end
        end,
        
        events =
        {
            EventHandler("animqueueover", function(inst) 
				if inst.host ~= nil then
					inst.sg:GoToState("idle")
				else
					inst.sg:GoToState("running") 
				end
			end),
        },        
    },
    
    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
			if not inst:HasTag("fx") then
				inst.SoundEmitter:PlaySound("UCSounds/pollenmite/die")        
			end

            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
			
			if inst.components.lootdropper ~= nil then
				inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
			end
        end,
    },    

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop",true)
            --inst.SoundEmitter:PlaySound("UCSounds/pollenmite/loop","move", 0.5)
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                if inst.sg.statemem.wantstomove and inst.host == nil then
					inst.sg:GoToState("moving")
				else
					inst.sg:GoToState("idle")
				end
            end),
        },
    },   

    State{
        name = "spawn",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("spawn")            
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("UCSounds/pollenmite/hit")            
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },    
    
    State{
        name = "takeoff",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("sleep_pst")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
        
    },


    State{
        name = "attack",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()

            inst.AnimState:PlayAnimation("attack_pre")
            inst.AnimState:PushAnimation("attack_pst",false)
           
            
        end,
        


        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) 
                inst.components.combat:DoAttack(inst.sg.statemem.target)               
            end ),

            TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/pollenmite/hit") end),                   
            
        },
 
        events=
        {
            EventHandler("animqueueover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },


    --State{
    --    name = "land_pre",
    --    tags = {"busy", "landing"},
    --    
    --    onenter = function(inst)
    --       inst.Physics:Stop()
    --        inst.AnimState:PlayAnimation("sleep_pre")

    --    end,
        
    --    events=
    --    {
    --        EventHandler("animqueueover", function(inst)
    --            inst.sg:GoToState("land")
    --        end),
    --    },
    --},    

    State{
        name = "land",
        tags = {"busy", "landing"},
        
        onenter = function(inst)
            inst:PerformBufferedAction()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("sleep_loop",true)
        end,
        
        events=
        {
            EventHandler("takeoff", function(inst)
                inst.sg:GoToState("takeoff")
            end),
        },
    },  
	
	State{
        name = "infest",
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.chasingtargettask then
                inst.chasingtargettask:Cancel()
                inst.chasingtargettask = nil
            end
            --inst.Physics:Stop()
            --inst.AnimState:PlayAnimation("attack_pst", false)
            --inst.AnimState:PushAnimation("attack_pst",false)
            inst:PerformBufferedAction()
        end,
        
        timeline=
        {
            --TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/pollenmite/hit") end),
        },
 
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

}
CommonStates.AddFrozenStates(states)
    
return StateGraph("leechswarm", states, events, "spawn", actionhandlers)


require("stategraphs/commonstates")
--[[
local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "eat"),
    ActionHandler(ACTIONS.INVESTIGATE, "investigate"),
}]]

local events=
{
	--[[EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("no_stun") and not inst.sg:HasStateTag("attack") then 
            inst.sg:GoToState("hit")  -- can't attack during hit reaction
        end 
    end),]]
    EventHandler("grab", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("evade")  and data and data.target  then 
        inst.sg:GoToState("grab", data.target) 
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
        tags = { "busy" },

        onenter = function(inst)
            PlayExtendedSound(inst, "death")
            inst.AnimState:PlayAnimation("dead")
            
            RemovePhysicsColliders(inst)
            inst:AddTag("NOCLICK")
            inst.persists = false
        end,

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end
    }, 

    State{
        name = "appear",
        tags = {"idle", "canrotate"},
		
        onenter = function(inst)
            
			inst.AnimState:PushAnimation("appear")
            inst.sg:SetTimeout(5)
        end,
		
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle_above") end),
        },
    },

    State{
        name = "idle_above",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, start_anim)
            
			inst.AnimState:PushAnimation("idle_above", true)
            inst.sg:SetTimeout(5)
        end,
        
        ontimeout = function(inst)
			inst.sg:GoToState("grab")
        end,
    },

    State{
        name = "grab",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, start_anim)
            
			inst.AnimState:PushAnimation("grab")
        end,
		
		events =
        {
            EventHandler("animover", function(inst) 
				inst:LaunchProjectile()
				inst.sg:GoToState("idle_grab") 
			end),
        },
    },

    State{
        name = "idle_grab",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, start_anim)
			inst.AnimState:PushAnimation("idle_grab", true)
            inst.sg:SetTimeout(5)
        end,
		
        ontimeout = function(inst)
            inst.sg:GoToState("retreat")
        end,
    },

    State{
        name = "idle_miss",
        tags = {"idle", "canrotate"},
        
        onenter = function(inst, start_anim)
            
			inst.AnimState:PushAnimation("idle_miss", true)
        end,
    },

    State{
        name = "retreat",
        tags = {"busy"},
        
        onenter = function(inst)
            
            inst.AnimState:PlayAnimation("retreat")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst:Remove() end),
        },
    },    
    
}

CommonStates.AddFrozenStates(states)

return StateGraph("mindweaver", states, events, "appear")--, actionhandlers)


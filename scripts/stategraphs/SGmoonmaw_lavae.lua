require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "eat"),
}

local events=
{
    EventHandler("attacked", function(inst) 
        if not inst.components.health:IsDead() then
			if inst.sg:HasStateTag("grounded") then
				inst.AnimState:PlayAnimation("stab_hit")
				inst.AnimState:PushAnimation("stab_loop")
			elseif not inst.sg:HasStateTag("no_stun") then
				inst.sg:GoToState("hit")  -- can't attack during hit reaction
			end
        end 
    end),
    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead()  then 
        inst.sg:GoToState("attack", data.target) 
        end 
    end),
    EventHandler("death", function(inst) 
		if inst.sg:HasStateTag("grounded") and not inst.sg:HasStateTag("dead") then
			inst.sg:GoToState("deathground") 
		else
			inst.sg:GoToState("death") 
		end
	end),
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
        tags = {"busy","dead"},
        
        onenter = function(inst)
			inst.Physics:Stop()
			RemovePhysicsColliders(inst) 
            inst.AnimState:PlayAnimation("drop")
			inst.AnimState:PushAnimation("deathground",false)
		end,
		
		timeline=
        {
			TimeEvent(11*FRAMES, function(inst) 
				inst.components.combat:DoAreaAttack(inst, 2, nil, nil,nil, { "moonglasscreature" })
				local fx = SpawnPrefab("moonstorm_glass_ground_fx")
				local x,y,z = inst.Transform:GetWorldPosition()
				fx.Transform:SetPosition(x,y,z)
				inst.Physics:Stop()
			end),
            TimeEvent(10*FRAMES, function(inst) 
				SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
			end),
            TimeEvent(30*FRAMES, function(inst) 
				SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
			end),
            TimeEvent(50*FRAMES, function(inst) 
				SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
			end),
        },
    },    
    State{
        name = "deathground",
        tags = {"busy","dead"},
        
        onenter = function(inst)
			inst.Physics:Stop()
			RemovePhysicsColliders(inst) 
            inst.AnimState:PlayAnimation("deathground",false)
		end,
		
		timeline=
        {
            TimeEvent(10*FRAMES, function(inst) 
				SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
			end),
            TimeEvent(30*FRAMES, function(inst) 
				SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
			end),
            TimeEvent(50*FRAMES, function(inst) 
				SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
			end),
        },
    },       
    State{
        name = "premoving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("hover")
        end,
        
        
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
			inst.AnimState:PushAnimation("hover")
        end,
        
        timeline=
        {
            --TimeEvent(4*FRAMES, PlayFootstep),
            --TimeEvent(8*FRAMES, PlayFootstep),
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
			inst.sg:GoToState("idle")
        end,
        
        onenter = function(inst, start_anim)
            inst.Physics:Stop()
			inst.sg:SetTimeout(math.random()*2 + 2)
            inst.AnimState:PushAnimation("hover", true)

        end,
    }, 
    
    State{
        name = "investigate",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hover")
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
        tags = {"busy", "no_stun"},
        
        onenter = function(inst, target)
            --inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("stab_pre")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/lavae/attack")
			end),
            TimeEvent(9*FRAMES, function(inst) 
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
			end),
            TimeEvent(11*FRAMES, function(inst)
			if inst.components.health ~= nil and not inst.components.health:IsDead() then
				inst.components.combat:DoAreaAttack(inst, 2, nil, nil,nil, { "moonglasscreature" })
				local fx = SpawnPrefab("moonstorm_glass_ground_fx")
				local x,y,z = inst.Transform:GetWorldPosition()
				fx.Transform:SetPosition(x,y,z)
			end
				inst.Physics:Stop()
			end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("stuck") end),
        },
    },

    State{
        name = "stuck",
        tags = {"busy", "grounded"},

        ontimeout = function(inst)
			inst.sg:GoToState("atk_pst")
        end,     
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("stab_loop")
			inst.sg:SetTimeout(5)
        end,
        

    },
	
    State{
        name = "atk_pst",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("stab_pst")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
				SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine", nil, 0.5) 
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },    
}

CommonStates.AddFrozenStates(states)

return StateGraph("moonmaw_lavae", states, events, "idle", actionhandlers)


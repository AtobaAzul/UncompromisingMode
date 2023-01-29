require("stategraphs/commonstates")

local actionhandlers = 
{
}


local events=
{
    --CommonHandlers.OnLocomote(true,true),
    --CommonHandlers.OnSleep(),
    --CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttacked(),
    --CommonHandlers.OnDeath(), 
	EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and data and data.target and not inst.sg:HasStateTag("attack") then 
        inst.sg:GoToState("attack", data.target) 
        end 
    end),
    EventHandler("locomote", function(inst)  
		local is_moving = inst.sg:HasStateTag("moving")
		local wants_to_move = inst.components.locomotor:WantsToMoveForward()
		if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
			if wants_to_move then
				inst.sg:GoToState("moving")
			else
				inst.sg:GoToState("idle")
			end
		end
    end), 
}

local states=
{
--Add special states here
    State{
        name = "moving",
        tags = {"moving", "canrotate"},
        
        onenter = function(inst)
			inst.Transform:SetFourFaced()
			inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("move")
        end,
        
        timeline=
        {
		TimeEvent(3*FRAMES, PlayFootstep),
		TimeEvent(6*FRAMES, PlayFootstep),
        },
        
        events=
        {
            EventHandler("animover", function(inst)
			inst.sg:GoToState("moving") end),
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
            TimeEvent(3*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end), 
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
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
            local animname = "idle"
            if math.random() < .3 then
				inst.sg:SetTimeout(math.random()*2 + 2)
			end
			inst.AnimState:PlayAnimation("idle", true)
        end,
        --[[timeline = 
        {
        },]]
    },

}

--[[CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
})]]

--[[CommonStates.AddSleepStates(states,
{
	sleeptimeline = 
	{
		--TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(sleepsound) end ),
	},
})]]

--[[CommonStates.AddCombatStates(states,
{
    hittimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.hit) end),
    },
    deathtimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.death) end),
    },
})]]

--CommonStates.AddIdle(states)
--CommonStates.AddFrozenStates(states)

    
return StateGraph("SGumbral_hound", states, events, "idle", actionhandlers)
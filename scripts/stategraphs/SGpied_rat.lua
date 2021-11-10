require("stategraphs/commonstates")

local actionhandlers = 
{
}


local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(), 
}

local states=
{
--Add special states here
}

CommonStates.AddWalkStates(states,
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
})


CommonStates.AddCombatStates(states,
{
    hittimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.hit) end),
    },
    deathtimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.death) end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddFrozenStates(states)

    
return StateGraph("pied_rat", states, events, "idle", actionhandlers)
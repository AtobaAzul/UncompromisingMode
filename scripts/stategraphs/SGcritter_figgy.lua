require("stategraphs/commonstates")
require("stategraphs/SGcritter_common")

local actionhandlers =
{
}

local events =
{
	SGCritterEvents.OnEat(),
    SGCritterEvents.OnAvoidCombat(),
	SGCritterEvents.OnTraitChanged(),

    CommonHandlers.OnSleepEx(),
    CommonHandlers.OnWakeEx(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnHop(),
	CommonHandlers.OnSink(),
}

local states =
{
}

local emotes =
{
	{ anim="emote_stretch",
      timeline=
 		{
			TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),
		},
	},
	{ anim="emote_lick",
      timeline=
 		{
			TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			TimeEvent(36*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			TimeEvent(58*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
		},
	},
}

SGCritterStates.AddIdle(states, #emotes)
SGCritterStates.AddRandomEmotes(states, emotes)
SGCritterStates.AddEmote(states, "cute",
		{
			TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),
			TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),
		})
SGCritterStates.AddPetEmote(states,
        {
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),
        })
SGCritterStates.AddCombatEmote(states,
		{
			loop =
			{
				TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),
			},
		})
SGCritterStates.AddPlayWithOtherCritter(states, events,
	{
		active =
		{
			TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			TimeEvent(36*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			TimeEvent(48*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			TimeEvent(60*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
		},
	})
SGCritterStates.AddEat(states,
        {
            TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),
        })
SGCritterStates.AddHungry(states,
        {
            TimeEvent(23*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/death") end),
            TimeEvent(43*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/death") end),
        })
SGCritterStates.AddNuzzle(states, actionhandlers,
        {
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/death") end),
        })

SGCritterStates.AddWalkStates(states, nil, true)
CommonStates.AddSleepExStates(states,
		{
			starttimeline =
			{
				TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/taunt") end),
			},
			sleeptimeline =
			{
				TimeEvent(31*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/aphid/idle") end),
			},
		})

CommonStates.AddHopStates(states, true)
CommonStates.AddSinkAndWashAsoreStates(states)

return StateGraph("SGcritter_figgy", states, events, "idle", actionhandlers)

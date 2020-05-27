local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddStategraphActionHandler("frog", ActionHandler(ACTIONS.EAT, "eat"))

env.AddStategraphPostInit("frog", function(inst)

local states = {

	State{
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, forced)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pre")
            inst.sg.statemem.forced = forced
        end,

        timeline =
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/attack_voice") end),

        },

        events =
        {
			EventHandler("animover", function(inst)
				inst.sg:GoToState((inst:PerformBufferedAction() or inst.sg.statemem.forced) and "eat_loop" or "idle")
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
            inst.sg:GoToState("eat_pst", "idle")
        end,       
    },
	
	State{
        name = "eat_pst",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_pst")
        end,

        timeline =
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/frog/grunt") end),

        },

        events =
        {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
    }
}

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)

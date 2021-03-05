local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddStategraphActionHandler("moose", ActionHandler(ACTIONS.EAT, "eat"))

env.AddStategraphPostInit("moose", function(inst)

local states = {

	State{
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, forced)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt_pre")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/attack")
            inst.sg.statemem.forced = forced
        end,

        events =
        {
			EventHandler("animover", function(inst)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/moose/swhoosh")
				inst.sg:GoToState("eat_pst")
            end),
		},
    },
	
	State{
        name = "eat_pst",
        tags = { "busy" },

        onenter = function(inst)
			inst:PerformBufferedAction()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt_pst")
        end,

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

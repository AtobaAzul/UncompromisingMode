local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("perd", function(inst)

local events =
{
	EventHandler("attacked", function(inst) 
		if not inst.components.health:IsDead() and not 
		inst.sg:HasStateTag("transform") and not 
		inst.sg:HasStateTag("attack") and not
		inst.sg:HasStateTag("busy") then
			if inst.attacked then
				inst.sg:GoToState("hitshort")
			else
				inst.sg:GoToState("hit")
			end
		end 
	end),
}

local states = {

    State{
        name = "hitshort",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/perd/hurt")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
			local timeouttime = inst.AnimState:GetCurrentAnimationLength() / 1.2
			inst.sg:SetTimeout(timeouttime)
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
    }
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)
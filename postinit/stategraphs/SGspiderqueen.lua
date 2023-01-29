local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("spiderqueen", function(inst)

local events =
{
	EventHandler("doattack", function(inst) 
		if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			if inst.prefab ~= "spiderking" then --CTC compat
				if not inst.components.timer:TimerExists("SpitCooldown") then
					inst.components.timer:StartTimer("SpitCooldown", 10)
				end
			end	
			--if inst.spitweb then
				--inst.sg:GoToState("give_off_cob_web")
			--else
				inst.sg:GoToState("attack")
			--end
		end
	end),
    
}

local states = {
	State{
		name = "give_off_cob_web",
        tags = { "attack", "busy"},

        onenter = function(inst, cb)
			inst.components.timer:StopTimer("SpitCooldown")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/scream")
			inst.spitweb = false
        end,

		timeline=
        {
            TimeEvent(12*FRAMES, function(inst)
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
			
				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())
				end
				
				inst.LaunchWeb(inst, inst.components.combat.target)
			end),
        },

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
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
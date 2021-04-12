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
			inst.sg:GoToState("hit") 
		end 
	end),
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

end)
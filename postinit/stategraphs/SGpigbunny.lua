local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("pig", function(inst)

local events =
{	
    EventHandler("doattack", function(inst, data) 
        if data.target:HasTag("pig") and not data.target:HasTag("werepig") then
            inst.sg:GoToState("refuse", data.target)
            inst.components.combat:SetTarget(nil)
		else
            inst.sg:GoToState("attack", data.target)
        end
    end),
    
}
--[[
local states = {

    
}]]

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

end)

env.AddStategraphPostInit("bunnyman", function(inst)

local events =
{	
    EventHandler("doattack", function(inst, data) 
        if data.target:HasTag("manrabbit") then
            inst.sg:GoToState("refuse", data.target)
            inst.components.combat:SetTarget(nil)
		else
            inst.sg:GoToState("attack", data.target)
        end
    end),
    
}
--[[
local states = {

    
}]]

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

end)
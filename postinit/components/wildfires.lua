local env = env
GLOBAL.setfenv(1, GLOBAL)
local UpvalueHacker = require("tools/upvaluehacker")


--thanks korean!
env.AddComponentPostInit("wildfires", function(self)
    local _ShouldActivateWildfires
    local _CheckValidWildfireStarter
    local _ms_startwildfireforplayerfn
    local inst = self.inst
    -- simplify the for loop by adding [inst] to the end
    for k, func in pairs(inst.event_listening["ms_lightwildfireforplayer"][inst]) do
        -- check that the upvalue we want to grab is the correct one (i.e the function ShouldActivateWildfires)
        if UpvalueHacker.GetUpvalue(func, "ShouldActivateWildfires") then
            _ms_startwildfireforplayerfn = func
            _ShouldActivateWildfires = UpvalueHacker.GetUpvalue(func, "ShouldActivateWildfires")
            _CheckValidWildfireStarter = UpvalueHacker.GetUpvalue(func, "LightFireForPlayer", "CheckValidWildfireStarter")
            -- we can break out of the loop now since we found the upvalue we wanted
            break
        end
    end
    local ShouldActivateWildfires = function()
        return _ShouldActivateWildfires() and TheWorld:HasTag("heatwavestart")
    end

    local CheckValidWildfireStarter = function(obj)
        return _CheckValidWildfireStarter(obj) and obj:HasTag("plant")
    end

    UpvalueHacker.SetUpvalue(_ms_startwildfireforplayerfn, ShouldActivateWildfires, "ShouldActivateWildfires")
    UpvalueHacker.SetUpvalue(_ms_startwildfireforplayerfn, CheckValidWildfireStarter, "LightFireForPlayer",
        "CheckValidWildfireStarter")
end)

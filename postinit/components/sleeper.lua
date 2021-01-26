local Sleeper = GLOBAL.require("components/sleeper")
AddComponentPostInit("sleeper", function(self)
    local _GoToSleep = Sleeper.GoToSleep
    self.GoToSleep = function(self, sleeptime)
        if self.inst.sg ~=nil and self.inst.sg:HasStateTag("nosleep") then
            return
        else
            _GoToSleep(self, sleeptime)
        end
    end
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("sewing", function(self)
    local _DoSewing = self.DoSewing

    function self:DoSewing(target, doer)
        local ret = _DoSewing(self, target, doer)

        if ret then
            if doer:HasTag("expert_repairer") then
                target.components.fueled:DoDelta(self.repair_value)
            end
        end

        return ret
    end
end)

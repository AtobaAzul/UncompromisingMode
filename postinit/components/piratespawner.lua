local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("piratespawner", function(self)
    local _OnUpdate = self.OnUpdate

    function self:OnUpdate(dt)
        if not TheWorld.crabking_active then
            return _OnUpdate(self, dt)
        end
    end
end)
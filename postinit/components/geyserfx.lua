local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("geyserfx", function(self)
    local _OnUpdate = self.OnUpdate

    function self:OnUpdate(dt)
        if (self.state == 3 or self.state == 1) and TheWorld.state.issummer then
            if math.random() > 0.9 then
                local smog = SpawnPrefab("smog")
                local x, y, z = self.inst.Transform:GetWorldPosition()
                smog.Transform:SetPosition(x + math.random(-40, 40) / 10, math.random(0, 4), z + math.random(-40, 40) / 10)
            end
        end

        _OnUpdate(self, dt)
    end
end)

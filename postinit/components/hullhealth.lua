local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("hullhealth", function(self)
    local _GetDamageMult = self.GetDamageMult

    function self:GetDamageMult(cat, ...)
        local ret = _GetDamageMult(self, ...)

        if self.inst.components.boatphysics ~= nil then
            for k, v in pairs(self.inst.components.boatphysics.magnets) do
                print("magnet found! reducing damage.")
                ret = ret * 0.25
                break
            end
        end

        return ret
    end

    local _OnCollide = self.OnCollide

    function self:OnCollide(data, ...)
        if data.other ~= nil and (data.other:HasTag("boat") or data.other.components.boatphysics ~= nil) and not TheNet:GetPVPEnabled() then
            return
        end
        return _OnCollide(self, data)
    end
end)

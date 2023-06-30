local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fixing A Vanilla Bug-----------------------------------------

env.AddComponentPostInit("planarentity", function(self, inst)
    local _OnResistNonPlanarAttack = self.OnResistNonPlanarAttack

    function self:OnResistNonPlanarAttack(attacker)
		if attacker ~= nil and attacker:IsValid() then
			return _OnResistNonPlanarAttack(self, attacker)
		else
			return _OnResistNonPlanarAttack(self, nil)
		end
    end
end)
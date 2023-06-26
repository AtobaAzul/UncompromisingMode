local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddClassPostConstruct("components/inventoryitem_replica", function(self, inst)
    local _SetPickupPos = self.SetPickupPos

    function self:SetPickupPos(pos)
        if self.classified ~= nil then
            _SetPickupPos(self, pos) --fuckin' hell Klei, please add more checks.
        end
    end
end)

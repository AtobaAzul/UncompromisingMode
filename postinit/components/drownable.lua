local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("drownable", function(self)

    local _OnFallInOcean = self.OnFallInOcean

    function self:OnFallInOcean(shore_x, shore_y, shore_z)
        local inv = self.inst.components.inventory
        if inv ~= nil and inv:GetEquippedItem(EQUIPSLOTS.BODY).prefab == "armormarble" then
            self.inst:DoTaskInTime(0.5, function(inst)
                inst.AnimState:SetMultColour(1, 1, 1, 0)
                inst.components.health:Kill()
                inst:ListenForEvent("animover", function(inst)
                    inst.AnimState:SetMultColour(1, 1, 1, 1)
                end)
            end)
    
            local active_item = inv:GetActiveItem()
            if active_item ~= nil and not active_item:HasTag("irreplaceable") and
                not active_item.components.inventoryitem.keepondrown then
                Launch(inv:DropActiveItem(), self.inst, 3)
            end
            Launch(inv:DropEverything(true), self.inst, 3)

        else
            return _OnFallInOcean(self, shore_x, shore_y, shore_z)
        end
    end
end)

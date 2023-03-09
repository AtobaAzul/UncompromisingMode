local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("repairable", function(self)
    local _Repair = self.Repair

    function self:Repair(doer, repair_item)
        if doer:HasTag("expert_repairer") then
            repair_item.components.repairer.healthrepairvalue = repair_item.components.repairer.healthrepairvalue * 2
            repair_item.components.repairer.healthrepairpercent = repair_item.components.repairer.healthrepairpercent * 2
            repair_item.components.repairer.perishrepairpercent = repair_item.components.repairer.perishrepairpercent * 2
            repair_item.components.repairer.workrepairvalue = repair_item.components.repairer.workrepairvalue * 2
            repair_item.components.repairer.finiteusesrepairvalue = repair_item.components.repairer.finiteusesrepairvalue * 2
        end

        return _Repair(self, doer, repair_item)
    end

end)

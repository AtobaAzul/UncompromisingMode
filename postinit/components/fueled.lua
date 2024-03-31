local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("fueled", function(self)
    local _CanAcceptFuelItem = self.CanAcceptFuelItem


    local sludge_valid_fuels = {
        FUELTYPE.BURNABLE,
        FUELTYPE.CAVE,
        FUELTYPE.CHEMICAL
    }
    function self:CanAcceptFuelItem(item)
        if self.accepting and item then
            local fuel = item.components.fuel or item.components.fueler
            return ((table.contains(sludge_valid_fuels, self.fueltype) or
                        table.contains(sludge_valid_fuels, self.secondaryfueltype)) and
                    fuel.fueltype == FUELTYPE.SLUDGE) or
                _CanAcceptFuelItem(self, item)
        end
        return _CanAcceptFuelItem(self, item)
    end

    local _TakeFuelItem = self.TakeFuelItem
    function self:TakeFuelItem(item, doer)
        if item ~= nil and item:HasTag("sludge_oil") and item.components.finiteuses ~= nil and self:CanAcceptFuelItem(item) then
            local fuel_obj = item or doer

            local masterymult = doer ~= nil and doer.components.fuelmaster ~= nil and
                doer.components.fuelmaster:GetBonusMult(fuel_obj, self.inst) or 1

            local fuel = fuel_obj.components.fuel or fuel_obj.components.fueler

            local fuelvalue = fuel.fuelvalue * self.bonusmult * masterymult

            self:DoDelta(fuelvalue, doer)

            fuel:Taken(self.inst)

            item.components.finiteuses:Use()

            if self.ontakefuelfn ~= nil then
                self.ontakefuelfn(self.inst, fuelvalue)
            end
            self.inst:PushEvent("takefuel", { fuelvalue = fuelvalue })

            return true
        end

        if self.inst:HasTag("overchargeable") then
            local _currentfuel = self.currentfuel
            local ret = _TakeFuelItem(self, item, doer)

            local fuel_obj = item or doer
            local fuel = fuel_obj.components.fuel or fuel_obj.components.fueler
            local wetmult = fuel_obj:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
            local masterymult = doer ~= nil and doer.components.fuelmaster ~= nil and
                doer.components.fuelmaster:GetBonusMult(fuel_obj, self.inst) or 1
            local fuelvalue = fuel.fuelvalue * self.bonusmult * wetmult * masterymult

            if _currentfuel < self.maxfuel and self.currentfuel > self.maxfuel and doer ~= nil and not doer:HasTag("handyperson") then
                self:SetPercent(1)
            end

            if self.currentfuel > self.maxfuel and doer ~= nil and not doer:HasTag("handyperson") then
                self:DoDelta(-fuelvalue, doer)
            end

            return ret
        end

        return _TakeFuelItem(self, item, doer)
    end

    local _DoDelta = self.DoDelta

    function self:DoDelta(amount, doer)
        if self.inst:HasTag("overchargeable") then
            local oldsection = self:GetCurrentSection()

            self.currentfuel = math.max(0, math.min(self.maxfuel * 2, self.currentfuel + amount))

            local newsection = self:GetCurrentSection()

            if oldsection ~= newsection then
                if self.sectionfn then
                    self.sectionfn(newsection, oldsection, self.inst, doer)
                end

                self.inst:PushEvent("onfueldsectionchanged",
                    { newsection = newsection, oldsection = oldsection, doer = doer })
                if self.currentfuel <= 0 and self.depleted then
                    self.depleted(self.inst)
                end
            end

            self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })

            if self.currentfuel > self.maxfuel then
                self.inst:PushEvent("overcharged", true)
            else
                self.inst:PushEvent("overcharged", false)
            end
        else
            _DoDelta(self, amount, doer)
        end
    end

    local _GetPercent = self.GetPercent

    function self:GetPercent()
        if self.inst:HasTag("overchargeable") then
            return self.maxfuel > 0 and math.max(0, math.min(2, self.currentfuel / self.maxfuel)) or 0
        else
            return _GetPercent(self)
        end
    end
end)

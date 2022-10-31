local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("fueled", function(self)
	local _TakeFuelItem = self.TakeFuelItem

	function self:TakeFuelItem(item, doer)
		if self:CanAcceptFuelItem(item) and item.components ~= nil and item.components.finiteuses ~= nil and item:HasTag("sludge_oil") then
			local wetmult = item:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
			local masterymult = doer ~= nil and doer.components.fuelmaster ~= nil and doer.components.fuelmaster:GetBonusMult(item, self.inst) or 1
			self:DoDelta(item.components.fuel.fuelvalue * self.bonusmult * wetmult * masterymult, doer)

			local fuelvalue = 0
			if item.components.fuel ~= nil then
				fuelvalue = item.components.fuel.fuelvalue
				item.components.fuel:Taken(self.inst)
			end
			item.components.finiteuses:Use()

			if self.ontakefuelfn ~= nil then
				self.ontakefuelfn(self.inst)
			end
			self.inst:PushEvent("takefuel", { fuelvalue = fuelvalue })

			return true
		else
			return _TakeFuelItem(self, item, doer)
		end
	end
end)
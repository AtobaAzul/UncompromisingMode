local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("fueled", function(self)
	local _TakeFuelItem = self.TakeFuelItem

	function self:TakeFuelItem(item, doer)
		if item:HasTag("sludge_oil") and item.components.finiteuses ~= nil and self:CanAcceptFuelItem(item) then
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
		else
			return _TakeFuelItem(self, item, doer)
		end
	end
end)

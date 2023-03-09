local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("dryer", function(self)
	
	local function StopWatchingRain(self)
		if self.watchingrain then
			self.watchingrain = nil
			self:StopWatchingWorldState("israining", OnIsRaining)
		end
	end

	local _OldHarvest = self.Harvest
	
	function self:Harvest(harvester)
		if harvester ~= nil and harvester.components.container ~= nil then
	
			local loot = SpawnPrefab(self.product)
			if loot ~= nil then
				if loot.components.perishable ~= nil then
					loot.components.perishable:SetPercent(self:GetTimeToSpoil() / TUNING.PERISH_PRESERVED)
					loot.components.perishable:StartPerishing()
				end
				if loot.components.inventoryitem ~= nil and not self.protectedfromrain then
					loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
				end
				harvester.components.container:GiveItem(loot, nil, self.inst:GetPosition())
			end

			self.ingredient = nil
			self.buildfile = nil
			self.dried_buildfile = nil
			self.product = nil
			self.foodtype = nil
			self.remainingtime = nil
			self.tasktotime = nil
			if self.task ~= nil then
				self.task:Cancel()
				self.task = nil
			end
			StopWatchingRain(self)

			if self.onharvest ~= nil then
				self.onharvest(self.inst)
			end
			return true
		else
			return _OldHarvest(self, harvester)
		end
	end
end)
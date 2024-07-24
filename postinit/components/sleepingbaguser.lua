--change moved to init/init_tuning.lua
--GLOBAL.TUNING.SLEEP_TICK_PERIOD = GLOBAL.TUNING.SLEEP_TICK_PERIOD / 2

local SleepingBagUser = GLOBAL.require("components/sleepingbaguser")
AddComponentPostInit("sleepingbaguser", function(SleepingBagUser)
	if TUNING.DSTU.GOTOBED ~= false then
		local _DoSleep = SleepingBagUser.DoSleep
		local _DoWakeUp = SleepingBagUser.DoWakeUp

		SleepingBagUser.DoSleep = function(self, bed)
			_DoSleep(self, bed)
			if TUNING.DSTU.GOTOBED == "default" then
				self.healthtask = self.inst:DoPeriodicTask(self.bed.components.sleepingbag.tick_period, function()
					local health_tick = self.bed.components.sleepingbag.health_tick * self.health_bonus_mult
					if self.inst.components.health ~= nil and not self.inst:HasTag("TiddleVirus") and
						(self.inst.components.health:GetPenaltyPercent() < 0.25) then
						--The max health repair is equal to half the health tick value of the bed/tent
						--e.g. tents restore 2 health per tick so they will restore 1% max health per tick --KoreanWaffles
						self.inst.components.health:DeltaPenalty(-health_tick / 200)
					end
				end)
			else
				self.healthtask = self.inst:DoPeriodicTask(self.bed.components.sleepingbag.tick_period, function()
					local health_tick = self.bed.components.sleepingbag.health_tick * self.health_bonus_mult
					if self.inst.components.health ~= nil and not self.inst:HasTag("TiddleVirus") then
						self.inst.components.health:DeltaPenalty(-health_tick / 200)
					end
				end)
			end
			if TUNING.DSTU.WXLESS and self.inst:HasTag("upgrademoduleowner") then
				local recharge_rate = 6
				self._wxsleepchargetask = self.inst:DoPeriodicTask(recharge_rate, function()
					self.inst.components.upgrademoduleowner:AddCharge(1)
				end)
			end
		end

		SleepingBagUser.DoWakeUp = function(self, nostatechange)
			if self.healthtask ~= nil then
				self.healthtask:Cancel()
				self.healthtask = nil
			end
			if self._wxsleepchargetask ~= nil then
				self._wxsleepchargetask:Cancel()
				self._wxsleepchargetask = nil
			end
			_DoWakeUp(self, nostatechange)
		end
	end
end)

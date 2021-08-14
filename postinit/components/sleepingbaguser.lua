--change moved to init/init_tuning.lua
--GLOBAL.TUNING.SLEEP_TICK_PERIOD = GLOBAL.TUNING.SLEEP_TICK_PERIOD / 2

local SleepingBagUser = GLOBAL.require("components/sleepingbaguser")
AddComponentPostInit("sleepingbaguser", function(SleepingBagUser)
	if TUNING.DSTU.GOTOBED then
		local _DoSleep = SleepingBagUser.DoSleep
		local _DoWakeUp = SleepingBagUser.DoWakeUp
			
		SleepingBagUser.DoSleep = function(self, bed)
			_DoSleep(self, bed)
			self.healthtask = self.inst:DoPeriodicTask(self.bed.components.sleepingbag.tick_period, function() 
				local health_tick = self.bed.components.sleepingbag.health_tick * self.health_bonus_mult
				if self.inst.components.health ~= nil and not self.inst:HasTag("TiddleVirus") then
					--The max health repair is equal to half the health tick value of the bed/tent
					--e.g. tents restore 2 health per tick so they will restore 1% max health per tick --KoreanWaffles
					self.inst.components.health:DeltaPenalty(-health_tick / 200)
				end
			end)
		end
		
		SleepingBagUser.DoWakeUp = function(self, nostatechange)
			if self.healthtask ~= nil then
				self.healthtask:Cancel()
				self.healthtask = nil
			end
			_DoWakeUp(self, nostatechange)
		end
	end
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)

--local UpvalueHacker = require("tools/upvaluehacker")


env.AddComponentPostInit("singinginspiration", function(self)
    if not TheWorld.ismastersim then return end

	self.buffertimemultipliers = SourceModifierList(self.inst) 

	self.drainratemultipliers = SourceModifierList(self.inst) 

	function self:OnUpdate(dt)
		local current_time = GetTime()
	
		if self.last_attack_time ~= nil and (current_time - self.last_attack_time >= ( TUNING.INSPIRATION_DRAIN_BUFFER_TIME * self.buffertimemultipliers:Get()) ) then
			self.is_draining = true
			self:DoDelta(TUNING.INSPIRATION_DRAIN_RATE * dt * self.drainratemultipliers:Get())
		else
			self.is_draining = false
		end
	end

	
end)

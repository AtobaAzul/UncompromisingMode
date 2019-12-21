local Hayfever = Class(function(self, inst)
    self.inst = inst

	self._sneezetime = net_byte(inst.GUID, "hayfever._sneezetime", "sneezetimedirty")
	
	if not TheWorld.ismastersim then
		self.inst:ListenForEvent("sneezetimedirty", function()
			self.inst:PushEvent("updatepollen", {sneezetime = self._sneezetime:value()})
		end)
	end
end)

function Hayfever:SetNextSneezeTime(newsneezetime)
	self._sneezetime:set(newsneezetime)
end

return Hayfever
local env = env
GLOBAL.setfenv(1, GLOBAL)

-----------------------------------------------------------------

env.AddGlobalClassPostConstruct("bufferedaction", "BufferedAction", function(self)
	if self.GetDynamicActionPoint ~= nil then
		local _OldGetDynamicActionPoint = self.GetDynamicActionPoint

		self.GetDynamicActionPoint = function(self, ...)

			if self.doer ~= nil and self.doer:HasTag("troublemaker") and self.invobject ~= nil and (self.invobject:HasTag("slingshot") or self.invobject:HasTag("wixiegun")) then
				local wixieposition = TheInput:GetWorldPosition()
				if wixieposition ~= nil then
					SendModRPCToServer(GetModRPC("WixieTheDelinquent", "GetTheInput"), wixieposition.x, wixieposition.y, wixieposition.z)
				end
			end

			return _OldGetDynamicActionPoint(self)
		end
	else
		local _OldGetActionPoint = self.GetActionPoint

		self.GetActionPoint = function(self, ...)

			if self.doer ~= nil and self.doer:HasTag("troublemaker") and self.invobject ~= nil and (self.invobject:HasTag("slingshot") or self.invobject:HasTag("wixiegun")) then
				local wixieposition = TheInput:GetWorldPosition()
				if wixieposition ~= nil then
					SendModRPCToServer(GetModRPC("WixieTheDelinquent", "GetTheInput"), wixieposition.x, wixieposition.y, wixieposition.z)
				end
			end

			return _OldGetActionPoint(self)
		end
	end
end)
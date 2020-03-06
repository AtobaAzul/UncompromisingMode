local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("groundpounder", function(self)
	self.sinkhole = false
	local _OldDestroyPoints = self.DestroyPoints
	
	function self:DestroyPoints(points, breakobjects, dodamage, pushplatforms)
		local map = TheWorld.Map

		for k, v in pairs(points) do
			if map:IsPassableAtPoint(v:Get()) then
				if self.sinkhole and IsNumberEven(k) and #TheSim:FindEntities(v.x, 0, v.z, 5, { "antlion_sinkhole_blocker" }) == 0 then
					local sinkhole = SpawnPrefab("bearger_sinkhole")
					sinkhole.Transform:SetPosition(v.x, 0, v.z)
					sinkhole:PushEvent("startcollapse")
				end
			end
		end
		
		return _OldDestroyPoints(self, points, breakobjects, dodamage, pushplatforms)
	end
end)
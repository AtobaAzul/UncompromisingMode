local function oncurrent(self, current)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.currentclaustrophobia:set(current)
    end
end

local Claustrophobia = Class(function(self, inst)
    self.inst = inst
    self.max = 1
    self.current = 0 

	self.inst:StartUpdatingComponent(self)
end,
nil,
{
    current = oncurrent,
})

function Claustrophobia:GetClaustrophobia()
    return self.current
end

function Claustrophobia:OnUpdate(dt)
		local x, y, z = self.inst.Transform:GetWorldPosition()
		
		local ents = TheSim:FindEntities(x, y, z, 5, { "_health", "_combat" }, { "INLIMBO", "player", "playerghost"} )
		
		if ents ~= nil and #ents >= self.max then
			for i, v in ipairs(ents) do
				if self.current < self.max then
					if v:HasTag("smallcreature") then
						self.current = self.current + 0.001
					elseif v:HasTag("epic") then
						self.current = self.current + 0.003
					else
						self.current = self.current + 0.002
					end
					
					if self.current > self.max then
						self.current = self.max
					end
				end
			end
		else
			self.current = self.current - 0.002
			if self.current < 0 then
				self.current = 0
			end
		end
		self.inst:PushEvent("claustrophobiadelta", {claustrophobia = self.claustrophobia})
		self.inst:PushEvent("mightinessdelta", { oldpercent = old / self.max, newpercent = self.current / self.max, delta = self.current-old })
end

return Claustrophobia

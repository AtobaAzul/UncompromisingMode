local Widget = require "widgets/widget"
local WobyHungerBadge = require "widgets/WobyHungerBadge"


local WobyHungerDisplay = Class(Widget, function(self, owner)
    Widget._ctor(self, "WobyHungerDisplay")
    self.owner = owner
	
    self.bg = self:AddChild(WobyHungerBadge(nil))
	self.bg:SetScale(0.72)
	
    self:Show()
end)

function WobyHungerDisplay:UpdateHunger(hunger)
	local percentage = hunger / 110
	
    self.bg:SetPercent(percentage)
end

return WobyHungerDisplay
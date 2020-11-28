local env = env
GLOBAL.setfenv(1, GLOBAL)
local UIAnim = require "widgets/uianim"
-----------------------------------------------------------------
env.AddClassPostConstruct("widgets/itemtile", function(self, invitem)
	local _OldUpdateToolTip = self.UpdateTooltip
	
	self.acid = self:AddChild(UIAnim())
    self.acid:GetAnimState():SetBank("acid_meter")
    self.acid:GetAnimState():SetBuild("acid_meter")
    self.acid:GetAnimState():PlayAnimation("idle")
    self.acid:Hide()
    self.acid:SetClickable(false)

	function self:UpdateTooltip()
		if self:GetDescriptionString() ~= nil then
			local str = self:GetDescriptionString()
			local mushroomcheck = TheSim:FindFirstEntityWithTag("acidrain_mushroom")
			self:SetTooltip(str)
			if self.item:GetIsWet() and mushroomcheck ~= nil then
				self:SetTooltipColour(unpack(TUNING.DSTU.ACID_TEXT_COLOUR))
			else
				return _OldUpdateToolTip(self)
			end
		else
			return _OldUpdateToolTip(self)
		end
	end
end)
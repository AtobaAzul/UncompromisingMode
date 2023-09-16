local env = env
GLOBAL.setfenv(1, GLOBAL)
local UIAnim = require "widgets/uianim"
-----------------------------------------------------------------
local Text = require "widgets/text"
require("constants")

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

	local _SetPercent = self.SetPercent

	function self:SetPercent(percent)
		_SetPercent(self, percent)

		if percent > 1 and self.item ~= nil and self.item:HasTag("overchargeable") then
			local r, g, b, a = self.percent:GetColour()[1], self.percent:GetColour()[2], self.percent:GetColour()[3], self.percent:GetColour()[4]
			self.percent:SetColour({(255/255)*Lerp(0.25, 1, percent),(240/255)*Lerp(0.25, 1, percent),0,a})
		end
	end
end)

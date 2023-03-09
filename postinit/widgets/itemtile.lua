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
		if not self.item:HasTag("hide_percentage") and percent > 1 and self.item:HasTag("overchargeable") then
			if not self.percent then
				self.percent = self:AddChild(Text(NUMBERFONT, 42))
				if JapaneseOnPS4() then
					self.percent:SetHorizontalSqueeze(0.7)
				end
				self.percent:SetPosition(5, -32 + 15, 0)
			end
			local val_to_show = percent * 100

			if val_to_show > 0 and val_to_show < 1 then
				val_to_show = 1
			end

			self.percent:SetString(string.format("%2.0f%%", val_to_show))
			self.percent:SetColour({ 0.5, Lerp(0.5,1, percent-1), 0.5, 1 })
		else
			_SetPercent(self, percent)
		end
	end
end)
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
			local mushroomcheck = nil--TheSim:FindFirstEntityWithTag("acidrain_mushroom")
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

local ItemTile = require('widgets/itemtile')
local _SetPercent = ItemTile.SetPercent

function ItemTile:SetPercent(percent, ...)
	_SetPercent(self, percent, ...)

	if percent ~= nil and self.percent ~= nil and self.inst:HasTag("overchargeable") then
		if percent > 1 then
			self.percent:SetColour({ 1, 1, 0, 1 })
		elseif percent > 0.99 and percent < 1 then --exactly at 1 just to reset it but not to break the coloured percent mod
			self.percent:SetColour({ 1, 1, 1, 1 })
		end
	end
end

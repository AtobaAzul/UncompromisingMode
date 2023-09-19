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

	self.inst:ListenForEvent("overcharged", function(inst, toggle)
		self:SetPercent(inst.components.fueled:GetPercent())
	end)

	local _SetPercent = self.SetPercent

	function self:SetPercent(percent, doyellow)
		_SetPercent(self, percent)
		if percent ~= nil and percent > 1 then
			self.item.yellowtask = self.item:DoPeriodicTask(FRAMES * 2, function()
				if self.percent ~= nil then
					self.percent:SetColour({ 1, 1, 0, 1 })
				end
			end)
		else
			if self.item.yellowtask ~= nil then --this fucker won't due and I give up. 
				self.item.yellowtask:Cancel()
				self.item.yellowtask = nil
			end
			self.item:DoTaskInTime(FRAMES, function()
				if self.percent ~= nil then
					self.percent:SetColour({ 1, 1, 1, 1 })
				end
			end)
		end
	end
end)

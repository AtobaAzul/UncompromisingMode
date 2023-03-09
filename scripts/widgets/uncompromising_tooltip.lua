local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local easing = require "easing"
local Text = require "widgets/text"

local Uncompromising_Tooltip = Class(Widget, function(self, owner)
		self.owner = owner
		Widget._ctor(self, "Uncompromising Tooltip")

		self.icon1 = self:AddChild(Image("images/UM_TT.xml", "UM_TT.tex"))

		self.icon1:SetPosition(300, 300, 0)
		self.icon1:SetScaleMode(0.01)
		self.icon1:SetScale(.9, .9, .9)

		self.icon2 = self:AddChild(Image("images/PP_TT.xml", "PP_TT.tex"))

		self.icon2:SetPosition(300, 300, 0)
		self.icon2:SetScaleMode(0.01)
		self.icon2:SetScale(.9, .9, .9)

		self.icon3 = self:AddChild(Image("images/engineering_tip.xml", "engineering_tip.tex"))

		self.icon3:SetPosition(300, 300, 0)
		self.icon3:SetScaleMode(0.01)
		self.icon3:SetScale(.9, .9, .9)

		self:Hide()
		self:RefreshTooltips()
		self.item_tip = nil
		self.skins_spinner = nil
	end)

function Uncompromising_Tooltip:ShowTip()
	self:RefreshTooltips()
	self:Show()
end

function Uncompromising_Tooltip:HideTip()
	self:RefreshTooltips()
	self:Hide()
end

function Uncompromising_Tooltip:RefreshTooltips()
	if self.skins_spinner ~= nil then
		self.icon1:SetPosition(300, 300, 0)
		self.icon2:SetPosition(300, 300, 0)
	else
		self.icon1:SetPosition(300, 245, 0)
		self.icon2:SetPosition(300, 245, 0)
	end

	local um_tip = self.item_tip ~= nil and STRINGS.UNCOMP_TOOLTIP[string.upper(self.item_tip)] ~= nil and
		STRINGS.UNCOMP_TOOLTIP[string.upper(self.item_tip)] .. "\n" or ""

	local walter_tip = self.item_tip ~= nil and ThePlayer:HasTag("pinetreepioneer") and STRINGS.PINETREE_TOOLTIP[string.upper(self.item_tip)] ~= nil and
		STRINGS.PINETREE_TOOLTIP[string.upper(self.item_tip)] .. "\n" or ""

	local winona_tip = self.item_tip ~= nil and ThePlayer:HasTag("handyperson") and STRINGS.ENGINEERING_TOOLTIP[string.upper(self.item_tip)] ~= nil and
		STRINGS.ENGINEERING_TOOLTIP[string.upper(self.item_tip)] .. "\n" or ""

	local tooltip = um_tip .. walter_tip .. winona_tip

	if self.item_tip ~= nil and winona_tip ~= "" and ThePlayer:HasTag("handyperson") then
		self.icon3:SetTooltip(tooltip)

		self.icon3:Show()

		self.icon2:Hide()
		self.icon1:Hide()
	elseif self.item_tip ~= nil and walter_tip ~= "" and ThePlayer:HasTag("pinetreepioneer") then
		self.icon2:SetTooltip(tooltip)

		self.icon2:Show()

		self.icon1:Hide()
		self.icon3:Hide()
	elseif self.item_tip ~= nil and um_tip ~= "" then
		self.icon1:SetTooltip(tooltip)
		self.icon1:Show()

		self.icon2:Hide()
		self.icon3:Hide()
	else
		self.icon1:Hide()
		self.icon2:Hide()
		self.icon3:Hide()
	end
end

return Uncompromising_Tooltip

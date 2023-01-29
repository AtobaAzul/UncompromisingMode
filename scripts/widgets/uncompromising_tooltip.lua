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
		

	if self.item_tip ~= nil and STRINGS.PINETREE_TOOLTIP[string.upper(self.item_tip)] ~= nil and ThePlayer:HasTag("pinetreepioneer") then
		self.icon2:SetTooltip(STRINGS.PINETREE_TOOLTIP[string.upper(self.item_tip)])
		self.icon2:Show()
		
		self.icon1:Hide()
	elseif self.item_tip ~= nil and STRINGS.UNCOMP_TOOLTIP[string.upper(self.item_tip)] ~= nil then
		self.icon1:SetTooltip(STRINGS.UNCOMP_TOOLTIP[string.upper(self.item_tip)])
		self.icon1:Show()
		
		self.icon2:Hide()
	else
		self.icon1:Hide()
		self.icon2:Hide()
	end
end

return Uncompromising_Tooltip
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
    --self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/UM_TT.xml", "UM_TT.tex"))
   -- self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    --self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    --self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    --self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    --self.bg2:SetHAlign(ANCHOR_MIDDLE)
	--SetHAlign
	
	--self.bg2:SetPosition(0, 0, 0)
	self.bg2:SetPosition(300, 300, 0)
    self.bg2:SetScaleMode(0.01)
	self.bg2:SetScale(.9, .9, .9)
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
		print("skin_spinner")
		self.bg2:SetPosition(300, 300, 0)
	else
		print("no skin_spinner")
		self.bg2:SetPosition(300, 245, 0)
	end
		

    local controller_id = TheInput:GetControllerID()
	if self.item_tip ~= nil and STRINGS.UNCOMP_TOOLTIP[string.upper(self.item_tip)] ~= nil then
		self.bg2:SetTooltip(STRINGS.UNCOMP_TOOLTIP[string.upper(self.item_tip)])
	else
		self.bg2:SetTooltip("???")
	end
end

return Uncompromising_Tooltip
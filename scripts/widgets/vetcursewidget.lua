local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local easing = require "easing"

local Vetcursewidget = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "Vetcursewidget")
    --self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/vetskull.xml", "vetskull.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
	self.bg2:SetPosition(880, -380, 0)
    self.bg2:SetScaleMode(0.01)
	self.bg2:SetScale(.33, .33, .33)
	self:StartUpdating()
    self:Show()
	self:RefreshTooltips()
end)

function Vetcursewidget:RefreshTooltips()
    local controller_id = TheInput:GetControllerID()
	
	if self.owner:HasTag("clockmaker") then
		self.bg2:SetTooltip("Veteran's Curse:\n - Age faster when damaged.\n - Hunger drains faster.\n - Sanity from foods is applied over time.\n - Gain the ability to wield cursed items, dropped by cerain bosses.")
	else
		self.bg2:SetTooltip("Veteran's Curse:\n - Receive more damage when attacked.\n - Hunger drains faster.\n - Health and Sanity from foods is applied over time.\n - Gain the ability to wield cursed items, dropped by cerain bosses.")
	end
end


function Vetcursewidget:OnUpdate(dt)
if self.owner:HasTag("vetcurse") then
self:Show()
else
self:Hide()
end
end

return Vetcursewidget
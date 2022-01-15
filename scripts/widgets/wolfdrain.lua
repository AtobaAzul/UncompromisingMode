local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local easing = require "easing"

local Wolfdrain = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "Wolfdrain")
    --self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/vetskull.xml", "vetskull.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
	self.bg2:SetPosition(800, 300, 0)
    self.bg2:SetScaleMode(0.01)
	self.bg2:SetScale(.25, .25, .25)
	self:StartUpdating()
    self:Show()
	self:RefreshTooltips()
end)

function Wolfdrain:RefreshTooltips()
	if self.owner.hungerpercent ~= nil then
		self.bg2:SetTooltip(self.owner.hungerpercent.."x")
	end
end


function Wolfdrain:OnUpdate(dt)
	if self.owner:HasTag("strongman") then
		if self.owner.hungerpercent ~= nil then
			self.bg2:SetTooltip(self.owner.hungerpercent.."x")
		end
		self:Show()
	else
		self:Hide()
	end
end

return Wolfdrain
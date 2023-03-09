local Widget = require "widgets/widget"
local Image = require "widgets/image"
local easing = require "easing"

local ClaustrophobiaOver =  Class(Widget, function(self, owner)
	self.owner = owner
	Widget._ctor(self, "ClaustrophobiaOver")
	self:SetClickable(false)
	
    self.bg2 = self:AddChild(Image("images/claustrophobia.xml", "claustrophobia.tex"))       
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.bg2:SetTint(1,1,1, 0)

    self:Hide()
	self:StartUpdating()
	self.claustrophobia = 0
	
end)

function ClaustrophobiaOver:UpdateState(claustrophobia)
    self.claustrophobia = claustrophobia
end

function ClaustrophobiaOver:OnUpdate(dt)
	if TheNet:IsServerPaused() then return end

	if not self.owner:HasTag("troublemaker") then
		self:Hide()
		self:StopUpdating()
		TheFocalPoint.SoundEmitter:KillSound("claustrophobicdrone")
	else
		self:Show()
		if self.owner.claustrophobia then
			local claustrophobia = self.owner.claustrophobia
			self.bg2:SetTint(1,1,1, claustrophobia)
			
			if claustrophobia >= 0.15 then
				TheFocalPoint.SoundEmitter:PlaySound("wixie/characters/wixie/claustrophobia", "claustrophobicdrone")
			else
				TheFocalPoint.SoundEmitter:KillSound("claustrophobicdrone")
			end
			TheFocalPoint.SoundEmitter:SetVolume("claustrophobicdrone", claustrophobia)
			--TheFocalPoint.SoundEmitter:SetParameter("claustrophobicdrone", "intensity", claustrophobia)
		end
	end
end

return ClaustrophobiaOver
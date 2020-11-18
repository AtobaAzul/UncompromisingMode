local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local easing = require "easing"

local FogOver = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "FogOver")
    self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/hoodedcanopyoverlay.xml", "hoodedcanopyoverlay.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FILLSCREEN)

    self.alpha = 0
    self.alphagoal = 0
    self.transitiontime = 2.0
    self.time = self.transitiontime
	self:StartUpdating()
    self:Hide()
	--self:Show()
	--self.bg2:SetTint(1, 1, 1, 0.6)
end)

function FogOver:UpdateAlpha(dt)
    if self.alphagoal ~= self.alpha then
        if self.time > 0 then
            self.time = math.max(0, self.time - dt)
            if self.alphagoal < self.alpha then
                self.alpha = Remap(self.time, self.transitiontime, 0, 1, 0)
            else
                self.alpha = Remap(self.time, self.transitiontime, 0, 0, 1)
            end
        end
    end
end

function FogOver:OnUpdate(dt)
	self.bg2:SetTint(0, 0, 0, self.alpha)
	if self.alpha == 0 then
	self:Hide()
	end
	if self.owner.components.areaaware:CurrentlyInTag("hoodedcanopy") and not TheWorld.state.isnight then
		--TheFocalPoint.SoundEmitter:KillSound("danger")
		--TheFocalPoint.SoundEmitter:KillSound("busy")
		--TheFocalPoint.SoundEmitter:PlaySound("UCSounds/music/creepyforest", "creepyforest")
		self:Show()
        self.time = self.transitiontime
		if TheWorld.state.isdusk then
		self.alphagoal = 0.4
		else
        self.alphagoal = 0.8
		end
	else
		--TheFocalPoint.SoundEmitter:KillSound("creepyforest")
        self.time = self.transitiontime
        self.alphagoal = 0
	end

	if self.alphagoal > self.alpha then
	self.alpha = self.alpha + 0.005
	end
	if self.alphagoal < self.alpha then
	self.alpha = self.alpha - 0.005
	end
end

return FogOver
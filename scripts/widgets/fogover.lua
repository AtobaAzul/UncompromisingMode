local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local easing = require "easing"

local FogOver = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "FogOver")
    self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/fx5.xml", "fog_over.tex"))
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
	
	self.inst:WatchWorldState("isday", function() 
		TheFocalPoint.SoundEmitter:KillSound("fogfear")
	end, TheWorld)
	self.inst:WatchWorldState("iscaveday", function() 
		TheFocalPoint.SoundEmitter:KillSound("fogfear")
	end, TheWorld)
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

function FogOver:StrangerMusic(d)
end

function FogOver:OnUpdate(dt)
	self.bg2:SetTint(1, 1, 1, self.alpha)
	if self.alpha == 0 then
		self:Hide()
		--TheFocalPoint.SoundEmitter:KillSound("fogfear")
	end
	if self.owner:HasTag("infog") then
	self:Show()
        self.time = self.transitiontime
        self.alphagoal = 0.6
		
		TheFocalPoint.SoundEmitter:PlaySound("UMMusic/music/night_terrors", "fogfear")
		--TheFocalPoint.SoundEmitter:PlaySound("UCSounds/screecher/feer", "fogfear")
	else
        self.time = self.transitiontime
        self.alphagoal = 0
	end

	if self.alphagoal > self.alpha then
	self.alpha = self.alpha + 0.005
	end
	if self.alphagoal < self.alpha then
	self.alpha = self.alpha - 0.005
	end
	
	local x, y, z = self.owner.Transform:GetWorldPosition()
	
	if #TheSim:FindEntities(x, y, z, 15, { "tiddlestranger" }) > 0 then
		TheFocalPoint.SoundEmitter:PlaySound("UMMusic/music/tiddlestranger", "tiddlestranger")
	else
		TheFocalPoint.SoundEmitter:KillSound("tiddlestranger")	
	end

end

return FogOver
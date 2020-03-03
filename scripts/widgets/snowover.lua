local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"

local BGCOLOR = { 0/255, 132/255, 0/255, 255/255 }

local SnowOver =  Class(Widget, function(self, owner, storm_overlays)
    self.owner = owner
    Widget._ctor(self, "SnowOver")

    self:SetClickable(false)
	
	self.minscale = .9 --min scale supported by art size
    self.maxscale = 1.20625
--[[
    self.storm_overlays = storm_overlays
    self.storm_root = storm_overlays:GetParent()
--]]
    self.bg = self:AddChild(Widget("blind_root"))
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.bg = self.bg:AddChild(UIAnim())
    self.bg:GetAnimState():SetBank("sand_over")
    self.bg:GetAnimState():SetBuild("snow_over")
    self.bg:GetAnimState():PlayAnimation("blind_loop", true)
	--self.bg:SetTint(1,1,1,.8)
	
	self.bg2 = self:AddChild(Widget("dust_root"))
	self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
	self.bg2 = self.bg2:AddChild(UIAnim())
    self.bg2:GetAnimState():SetBank("sand_over")
    self.bg2:GetAnimState():SetBuild("snow_over")
    self.bg2:GetAnimState():PlayAnimation("dust_loop", true)
	--self.bg2:SetTint(1,1,1,.8)
	
	
    self:Hide()
	self:OnUpdate(0)
	self:StartUpdating()
	

if owner ~= nil then
    self.owner:ListenForEvent("snowon", function(owner) return self:SnowOn() end, owner)
    self.owner:ListenForEvent("snowoff", function(owner) return self:SnowOn() end, owner)
	--self.owner:ListenForEvent("checksnowvision", function(owner) return self:VisionCheck() end, owner)
	--self.owner:DoTaskInTime(0.1, function() return self:SnowOn() end)
	--self.owner:DoTaskInTime(0.1, function() return self:VisionCheck() end)
	self.inst:ListenForEvent("weathertick", function(owner) return self:SnowOn() end, owner)
	
	self.inst:ListenForEvent("seasontick", function(owner) return self:ToggleUpdating() end, owner)
	--self.owner:ListenForEvent("weathertick", function(owner) return self:SnowOn() end, owner)
	--self:ListenForEvent("weathertick", function(owner) return self:SnowOn() end, owner)
	
	
	--self:SnowOn()
end
print("SNOW OVER CREATE")
end)

--[[
function SnowOver:VisionCheck()
	if self.owner.components.playervision ~= nil then
		if self.bg.shown and
			self.owner.components.playervision:HasGoggleVision() then
			self.bg:GetAnimState():SetMultColour(1, 1, 1, 0)
		elseif self.changed ~= nil then
			self.bg:GetAnimState():SetMultColour(1, 1, 1, self.changed)
		end
	end
end
--]]
function SnowOver:OnUpdate(dt)
local x, y, z = ThePlayer.Transform:GetWorldPosition()
local ents = TheSim:FindEntities(x, y, z, 4, {"wall"})
local suppressorNearby1 = 0.2 * #ents
local ents2 = TheSim:FindEntities(x, y, z, 6, {"fire"})
local suppressorNearby2 = 0.5 * #ents2
local ents3 = TheSim:FindEntities(x, y, z, 5.5, {"shelter"})
local suppressorNearby3 = 0.1 * #ents3

local equationdingus = suppressorNearby1 + suppressorNearby2 + suppressorNearby3

if TheWorld.state.issnowing then
	if self.alphaquation == nil then
	self.alphaquation = 0
	elseif self.alphaquation <= equationdingus then
	self.alphaquation = self.alphaquation + 0.01
	elseif self.alphaquation >= equationdingus then
	self.alphaquation = self.alphaquation - 0.01
	end
else
	if self.alphaquation == nil then
	self.alphaquation = 0
	elseif self.alphaquation > 0 then
	self.alphaquation = self.alphaquation - 0.001
	end
end

if TheWorld.state.issnowing and TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
		if self.changed == nil then
			self.changed = 0.01
		elseif self.changed <= 0.9 then
			self.changed = self.changed + 0.001 
			--print("plus 0.1")
			self.bg2:GetAnimState():SetMultColour(1, 1, 1, self.changed)
		
			if self.owner.components.playervision ~= nil and self.owner.components.playervision:HasGoggleVision() then
				
				self.bg:GetAnimState():SetMultColour(1, 1, 1, 0)
			else
				self.bg:GetAnimState():SetMultColour(1, 1, 1, self.changed)
			end
			
				TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/together/sandstorm", "snowstorm")
				TheFocalPoint.SoundEmitter:SetParameter("snowstorm", "intensity", self.changed)
				
		end
		self:Show()
	else
	
		if self.changed == nil then
			self.changed = 0
		elseif self.changed >= 0 then
			self.changed = self.changed - 0.001
			--print("plus 0.1")
			self.bg2:GetAnimState():SetMultColour(1, 1, 1, self.changed)
			if self.owner.components.playervision ~= nil and self.owner.components.playervision:HasGoggleVision() then
				self.bg:GetAnimState():SetMultColour(1, 1, 1, 0)
			else
				self.bg:GetAnimState():SetMultColour(1, 1, 1, self.changed)
			end
			
				TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/together/sandstorm", "snowstorm")
				TheFocalPoint.SoundEmitter:SetParameter("snowstorm", "intensity", self.changed)
			
			--self.blindto < 1 and 0 or .5)
        
			self:Show()
		elseif self.changed <= 0 then
			self:Hide() 
			TheFocalPoint.SoundEmitter:KillSound("snowstorm")
		end
	end
	
	
	
	if self.owner.components.playervision ~= nil then
		if self.bg.shown and
			self.owner.components.playervision:HasGoggleVision() then
			if self.changed > 0.4 then
				self.bg:GetAnimState():SetMultColour(1, 1, 1, 0.4 - self.alphaquation)
			else
				self.bg:GetAnimState():SetMultColour(1, 1, 1, self.changed - self.alphaquation)
			end
		elseif self.changed ~= nil then
			self.bg:GetAnimState():SetMultColour(1, 1, 1, self.changed - self.alphaquation)
			
		end
	end
end

function SnowOver:SnowOn()
if TheWorld.state.iswinter and TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
	self:StartUpdating()
	else
	self:Hide() 
	TheFocalPoint.SoundEmitter:KillSound("snowstorm")
	self:StopUpdating()
end
end

function SnowOver:ToggleUpdating()
	if TheWorld.state.iswinter and TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
	self:StartUpdating()
	else
	self:Hide() 
	TheFocalPoint.SoundEmitter:KillSound("snowstorm")
	self:StopUpdating()
end
end

return SnowOver
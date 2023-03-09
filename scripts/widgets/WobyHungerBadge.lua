local Badge = require "widgets/badge"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"

local WobyHungerBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, nil, nil, { 140 / 255, 90 / 255, 190 / 255, 1 }, "status_hunger", nil, nil, true)
	self.owner = owner
	self.icon = self.underNumber:AddChild(Image())
	self.icon:SetScale(.44)
	
	self.circleframe:GetAnimState():SetMultColour(.55, .25, .65, 1)
	
    self.wobycircle = self:AddChild(UIAnim())
    self.wobycircle:GetAnimState():SetBank("status_woby_meter")
    self.wobycircle:GetAnimState():SetBuild("status_meter_woby_small")
    self.wobycircle:GetAnimState():PlayAnimation("frame")
	
    --self.circleframe:GetAnimState():SetBank("status_woby_meter")
	--self.circleframe:GetAnimState():SetBuild("status_meter_woby_small")
	
	self.percent = .36
	
	self:SetPercent(0)
end)

function WobyHungerBadge:SetPercent(val)
    val = val or self.percent

	self.anim:GetAnimState():SetPercent("anim", 1 - val)
	self.circleframe:GetAnimState():SetPercent("frame", 1 - val)
	self.wobycircle:GetAnimState():SetPercent("frame", val)
	
	local hungerstringvalue = (val * 110) + 0.001
	local hungerstring = math.ceil(hungerstringvalue)
	
	if hungerstringvalue >= 110 then
		hungerstring = 110
	elseif hungerstringvalue <= 0.001 then
		hungerstring = 0
	end
	
    self.num:SetString(tostring(hungerstring))
    
    self.percent = val
end

return WobyHungerBadge

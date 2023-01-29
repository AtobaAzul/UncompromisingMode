local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"

local ampbadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "health", owner)
    self.anim:GetAnimState():SetBuild("ampbadge")
    self.owner = owner

    self.num.max = 100
    self.num.current = 100
    self.percent = 1

    owner:ListenForEvent("counter_maxdirty",function(owner,data)

        self.num.max = owner.counter_max:value()
        self.percent = self.num.current / self.num.max
    end)     

    owner:ListenForEvent("counter_currentdirty",function(owner,data)

        self.num.current = owner.counter_current:value()
        self.percent = self.num.current / self.num.max 
    end)  

    self:StartUpdating()
end)

function ampbadge:OnGainFocus()
    Badge._base:OnGainFocus(self)
    if self.combinedmod then
        self.maxnum:Show()
    else
        self.num:Show()
    end
end
    
function ampbadge:OnLoseFocus()
    Badge._base:OnLoseFocus(self)
    if self.combinedmod then
        self.maxnum:Hide()
        self.num:Show()
    else
        self.num:Hide()
    end
end

function ampbadge:OnUpdate(dt)
    self.num:SetString(tostring(math.floor(self.num.current)))
    self.anim:GetAnimState():SetPercent("anim", 1 - self.percent) 
end

return ampbadge
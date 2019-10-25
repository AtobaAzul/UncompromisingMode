local env = env
GLOBAL.setfenv(1, GLOBAL)
local UIAnim = require "widgets/uianim"
-----------------------------------------------------------------
env.AddClassPostConstruct("widgets/itemtile", function(self, invitem)
	local _OldUpdateToolTip = self.UpdateTooltip
	local _OldRefresh = self.Refresh
	
	self.acid = self:AddChild(UIAnim())
    self.acid:GetAnimState():SetBank("acid_meter")
    self.acid:GetAnimState():SetBuild("acid_meter")
    self.acid:GetAnimState():PlayAnimation("idle")
    self.acid:Hide()
    self.acid:SetClickable(false)
	
	self.inst:ListenForEvent("wetnesschange",
        function(invitem, wet)
            if not self.isactivetile then
				if wet and c_countprefabs("mushroomsprout_overworld") > 0 then
					self.acid:Show()
				else
					self.acid:Hide()
				end
            end
        end, invitem)

	function self:UpdateTooltip()
		local str = self:GetDescriptionString()
		self:SetTooltip(str)
		if self.item:GetIsWet() and c_countprefabs("mushroomsprout_overworld") > 0 then
			self:SetTooltipColour(unpack(TUNING.DSTU.ACID_TEXT_COLOUR))
		else
			return _OldUpdateToolTip(self)
		end
	end
	
	function self:Refresh()
		_OldRefresh(self)
		
		if not self.isactivetile then
			if self.item:GetIsWet() and c_countprefabs("mushroomsprout_overworld") > 0 then
				self.acid:Show()
				self.wetness:Hide()
			else
				self.acid:Hide()
				self.wetness:Show()
			end
		end
	end
end)
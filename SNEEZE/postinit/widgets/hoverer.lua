local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddClassPostConstruct("widgets/hoverer", function(self)
	local _OldOnUpdate = self.OnUpdate
	
	function self:OnUpdate()
		_OldOnUpdate(self)
		local str = nil

		if not self.isFE then
			str = self.owner.HUD.controls:GetTooltip() or self.owner.components.playercontroller:GetHoverTextOverride()
		else
			str = self.owner:GetTooltip()
		end
		
		local lmb = nil
		if str == nil and not self.isFE and self.owner:IsActionsVisible() then
			lmb = self.owner.components.playercontroller:GetLeftMouseAction()
		end
		if lmb ~= nil and lmb.target ~= nil and not lmb.target:HasTag("player") and lmb.target:GetIsWet() and c_countprefabs("mushroomsprout_overworld") > 0 then
            self.text:SetColour(unpack(TUNING.DSTU.ACID_TEXT_COLOUR))
        end
	end
end)
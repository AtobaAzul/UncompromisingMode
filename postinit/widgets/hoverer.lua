local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function IsActionsVisible(inst)
    --V2C: This flag is a hack for hiding actions during sleep states
    --     since controls and HUD are technically not "disabled" then
    return inst.player_classified ~= nil and inst.player_classified.isactionsvisible:value()
end

env.AddClassPostConstruct("widgets/hoverer", function(self)
	local _OldOnUpdate = self.OnUpdate
	
	function self:OnUpdate()
		_OldOnUpdate(self)
		local str = nil
		
		local mushroomcheck = TheSim:FindFirstEntityWithTag("acidrain_mushroom")
		
		if not self.isFE then
			str = self.owner.hud and self.owner.HUD.controls:GetTooltip() or self.owner.components and self.owner.components.playercontroller:GetHoverTextOverride()
		else
			str = self.owner:GetTooltip()
		end
	
		local lmb = nil
	
		if str == nil and not self.isFE and self.owner and self.owner.components then
				lmb = self.owner.components.playercontroller:GetLeftMouseAction()
		end
		if lmb ~= nil and lmb.target ~= nil and not lmb.target:HasTag("player") and lmb.target:GetIsWet() and mushroomcheck ~= nil then
            self.text:SetColour(unpack(TUNING.DSTU.ACID_TEXT_COLOUR))
        end
	end
end)
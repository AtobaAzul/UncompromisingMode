local env = env
GLOBAL.setfenv(1, GLOBAL)
local UIAnim = require "widgets/uianim"
local UncompTooltip = require "widgets/uncompromising_tooltip"
-----------------------------------------------------------------
env.AddClassPostConstruct("widgets/craftslot", function(self)
	local _OldShowRecipe = self.ShowRecipe
	local _OldHideRecipe = self.HideRecipe

	function self:ShowRecipe(...)
		self.uncomptip = self:AddChild(UncompTooltip())
		
		if self.uncomptip ~= nil and self.recipe ~= nil and self.recipe.name and STRINGS.UNCOMP_TOOLTIP[string.upper(self.recipe.name)] ~= nil then
			self.uncomptip.item_tip = self.recipe.name
			self.uncomptip:ShowTip()
		end
		
		_OldShowRecipe(self, ...)
	end

	function self:HideRecipe(...)
		if self.uncomptip ~= nil then
			self.uncomptip.item_tip = nil
			self.uncomptip:HideTip()
		end
		
		_OldHideRecipe(self, ...)
	end
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)
local UIAnim = require "widgets/uianim"
local UncompTooltip = require "widgets/uncompromising_tooltip"
-----------------------------------------------------------------
env.AddClassPostConstruct("widgets/craftslot", function(self)
	local _OldShowRecipe = self.ShowRecipe
	local _OldOnControl = self.OnControl
	local _OldHideRecipe = self.HideRecipe

	function self:ShowRecipe(...)
		if self.uncomptip ~= nil then
			self.uncomptip.item_tip = nil
			self.uncomptip.skins_spinner = nil
			self.uncomptip:HideTip()
		end

		self.uncomptip = self:AddChild(UncompTooltip())
		
		if self.uncomptip ~= nil and self.recipe ~= nil and self.recipepopup ~= nil and self.recipe.name and STRINGS.UNCOMP_TOOLTIP[string.upper(self.recipe.name)] ~= nil then
			self.uncomptip.item_tip = self.recipe.name
			self.uncomptip.skins_spinner = self.recipepopup.skins_spinner or nil
			self.uncomptip:ShowTip()
		end
		
		_OldShowRecipe(self, ...)
	end
	
	function self:OnControl(...)
		if self.uncomptip ~= nil then
			self.uncomptip.item_tip = nil
			self.uncomptip.skins_spinner = nil
			self.uncomptip:HideTip()
		end
	
		self.uncomptip = self:AddChild(UncompTooltip())
		
		if self.uncomptip ~= nil and self.recipe ~= nil and self.recipepopup ~= nil and self.recipe.name and STRINGS.UNCOMP_TOOLTIP[string.upper(self.recipe.name)] ~= nil then
			self.uncomptip.item_tip = self.recipe.name
			self.uncomptip.skins_spinner = self.recipepopup.skins_spinner or nil
			self.uncomptip:ShowTip()
		end
		
		_OldOnControl(self, ...)
	end
	
	function self:HideRecipe(...)
		if self.uncomptip ~= nil then
			self.uncomptip.item_tip = nil
			self.uncomptip.skins_spinner = nil
			self.uncomptip:HideTip()
		end
		
		_OldHideRecipe(self, ...)
	end
end)
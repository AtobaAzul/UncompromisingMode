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

		if self.uncomptip ~= nil and self.recipe ~= nil and self.recipepopup ~= nil and self.recipe.name and (STRINGS.UNCOMP_TOOLTIP[string.upper(self.recipe.name)] ~= nil or STRINGS.ENGINEERING_TOOLTIP[string.upper(self.recipe.name)] ~= nil or STRINGS.PINETREE_TOOLTIP[string.upper(self.recipe.name)] ~= nil) then
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

		if self.uncomptip ~= nil and self.recipe ~= nil and self.recipepopup ~= nil and self.recipe.name and (STRINGS.UNCOMP_TOOLTIP[string.upper(self.recipe.name)] ~= nil or STRINGS.ENGINEERING_TOOLTIP[string.upper(self.recipe.name)] ~= nil or STRINGS.PINETREE_TOOLTIP[string.upper(self.recipe.name)] ~= nil) then
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

env.AddClassPostConstruct("widgets/redux/craftingmenu_hud", function(self)
	local _OldOnUpdate = self.OnUpdate

	function self:OnUpdate(...)
		if self.craftingmenu ~= nil and self.uncomptip == nil then
			self.uncomptip = self.craftingmenu:AddChild(UncompTooltip())
			self.uncomptip:SetPosition( -105, -210)
			self.uncomptip:SetScale(0.35)
		end

		if self.craftingmenu ~= nil and
			self.craftingmenu.crafting_hud ~= nil and
			self.craftingmenu.crafting_hud:IsCraftingOpen() and
			self.uncomptip ~= nil and
			self.craftingmenu.details_root ~= nil and
			self.craftingmenu.details_root.data and
			self.craftingmenu.details_root.data.recipe ~= nil and
			self.craftingmenu.details_root.data.recipe.name and
			(STRINGS.UNCOMP_TOOLTIP[string.upper(self.craftingmenu.details_root.data.recipe.name)] ~= nil or
			STRINGS.PINETREE_TOOLTIP[string.upper(self.craftingmenu.details_root.data.recipe.name)] ~= nil or STRINGS.ENGINEERING_TOOLTIP[string.upper(self.craftingmenu.details_root.data.recipe.name)] ~= nil) then
			self.uncomptip.item_tip = self.craftingmenu.details_root.data.recipe.name
			self.uncomptip.skins_spinner = self.craftingmenu.details_root.skins_spinner or nil
			self.uncomptip:ShowTip()
		elseif self.uncomptip ~= nil then
			self.uncomptip.item_tip = nil
			self.uncomptip.skins_spinner = nil
			self.uncomptip:HideTip()
		end

		_OldOnUpdate(self, ...)
	end
end)

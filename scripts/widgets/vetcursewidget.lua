local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local easing = require "easing"

local Vetcursewidget = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "Vetcursewidget")
    --self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/vetskull.xml", "vetskull.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetPosition(880, -380, 0)
    self.bg2:SetScaleMode(0.01)
    self.bg2:SetScale(.33, .33, .33)
    self:StartUpdating()
    self:Show()
    self:RefreshTooltips()
end)

local skulls =
{
	{
		name = "walter_vetcurse",
		text = "\n - I'm bleeding! Does anyone know first aid?!",
	},
	{
		name = "wortox_vetcurse",
		text = "\n - Souls of the fallen are back for revenge!",
	},
	{
		name = "shambler_target",
		text = "\n - You are being hunted.",
	},
	{
		name = "willow_vetcurse",
		text = "\n - 'Creates fires when stressed'.",
	},
	{
		name = "warly_vetcurse",
		text = "\n - Don't be a glutton!",
	},
	{
		name = "winky_vetcurse",
		text = "\n - Littering can be hazardous to your health.",
	},
	{
		name = "winky_vetcurse",
		text = "\n - Littering can be hazardous to your health.",
	},
	{
		name = "wickerbottom_vetcurse",
		text = "\n - Catch some zeds, or end up dead!",
	},
	{
		name = "wixie_vetcurse",
		text = "\n - Krampus may take notice of haenous deeds...",
	},
	{
		name = "woodie_vetcurse",
		text = "\n - The birds! The birds I tell you!",
	},
}

function Vetcursewidget:RefreshTooltips()
    local controller_id = TheInput:GetControllerID()
	
	local vet_text = ""

    if self.owner:HasTag("clockmaker") then
        vet_text = "Veteran's Curse:\n - Age faster when damaged.\n - Hunger drains faster.\n - Sanity from foods is applied *slowly* over time.\n - Gain the ability to wield cursed items, dropped by certain bosses."
    else
        vet_text = "Veteran's Curse:\n - Receive more damage when attacked.\n - Hunger drains faster.\n - Health and Sanity from foods is applied *slowly* over time.\n - Gain the ability to wield cursed items, dropped by certain bosses."
    end
	
	for i, v in pairs(skulls) do
		if self.owner:HasTag(v.name) then
			vet_text = vet_text .. v.text
		end
	end
	
	self.bg2:SetTooltip(vet_text)
end

function Vetcursewidget:OnUpdate(dt)
    if self.owner:HasTag("vetcurse") then
		self:RefreshTooltips()
        self:Show()
    else
        self:Hide()
    end
end

return Vetcursewidget

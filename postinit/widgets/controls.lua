local require = GLOBAL.require

AddClassPostConstruct( "widgets/controls", function(self, inst)
	local ownr = self.owner
	if ownr == nil then return end
	local PollenOver = require "widgets/pollenover"
	self.pollenover = self:AddChild( PollenOver(ownr) )
	self.pollenover:MoveToBack()
	self.inst:ListenForEvent("updatepollen", function(inst, data) return self.pollenover:UpdateState(data.sneezetime) end, self.owner)
	self.owner:ListenForEvent("seasontick", function() return self:SeasonHide() end, self.owner)

	local FogOver = require "widgets/fogover"
	self.fogover = self:AddChild( FogOver(ownr) )
	self.fogover:MoveToBack()

	local Vetcursewidget = require "widgets/vetcursewidget"
	self.vetcursewidget = self:AddChild( Vetcursewidget(ownr) )
	self.vetcursewidget:MoveToBack()

	local californiakingoverlay = require "widgets/californiakingoverlay"
	self.californiakingoverlay = self:AddChild( californiakingoverlay(ownr) )
	self.californiakingoverlay:MoveToBack() 

	local uncompromising_tooltip = require "widgets/uncompromising_tooltip"
	self.uncompromising_tooltip = self:AddChild( uncompromising_tooltip(ownr) )
	self.uncompromising_tooltip:MoveToBack()
end)
--[[
AddClassPostConstruct("screens/playerhud",function(inst)
	local SnowOver = require("widgets/snowover")
	local fn =inst.CreateOverlays
	function inst:CreateOverlays(owner)
		fn(self, owner)
		self.snowover = self.overlayroot:AddChild(SnowOver(owner))
	end
	
end)

local function OnSpy(inst)
        inst._parent.HUD.snowover:SnowOn()
		inst._parent:PushEvent("snowon")
		
end

local function OffSpy(inst)
	if inst._parent ~= nil then
		ThePlayer.HUD.snowover:Show()
        inst._parent.HUD.snowover:SnowOn()
    end
end

AddPrefabPostInit("player_classified", function(inst)
	
	inst.snowoveron = GLOBAL.net_bool(inst.GUID, "snow.snowover", "snowdirty")
	inst:ListenForEvent("snowdirty", OnSpy)
end)--]]
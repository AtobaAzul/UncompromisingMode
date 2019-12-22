local require = GLOBAL.require

AddClassPostConstruct( "widgets/controls", function(self)
	local ownr = self.owner
	if ownr == nil then return end
	local PollenOver = require "widgets/pollenover"
	self.pollenover = self:AddChild( PollenOver(ownr) )
	self.pollenover:MoveToBack()
	self.inst:ListenForEvent("updatepollen", function(inst, data) return self.pollenover:UpdateState(data.sneezetime) end, self.owner)
end)
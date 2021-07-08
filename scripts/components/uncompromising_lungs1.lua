
local Uncompromising_Lungs = Class(function(self, inst)
self.inst = inst
self.interval = 0
print("initializedlungs")
end)

function Uncompromising_Lungs:HasFilter(self)
	local inst = self.inst
	if inst:HasTag("hasplaguemask") or inst:HasTag("has_gasmask") then
		return true
	end
end

function Uncompromising_Lungs:IsInGassyRatty(self)
	local inst = self.inst
	print("I did this check")
	if inst.components.areaaware ~= nil and inst.components.areaaware:HasAreaTag("rattygas") then
	print("itpassed")
		return true
	end
end

function Uncompromising_Lungs:PlagueGasDamage(self)
	local inst = self.inst
	if inst.components.health ~= nil then
		inst.components.health:DoDelta(-10)
		inst.components.health:DeltaPenalty(0.05)
	end
	if inst.components.sanity ~= nil then
		inst.components.health:DoDelta(-10)
	end
end

function Uncompromising_Lungs:Breathe(self)
	print("Breathe")
	if not self:HasFilter(self) and self:IsInGassyRatty(self) then
		print("we're here now")
		self:PlagueGasDamage(self)
	end
end

function Uncompromising_Lungs:OnUpdate(inst)
	self.interval = self.interval + 1
	if self.interval > 10 then
		self.interval = 0
		self:Breathe(self)
	end
end

Uncompromising_Lungs.LongUpdate = Uncompromising_Lungs.OnUpdate

return Uncompromising_Lungs

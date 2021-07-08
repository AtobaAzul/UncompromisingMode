
return Class(function(self, inst)
self.inst = inst

local function HasFilter(inst)
	if inst:HasTag("hasplaguemask") or inst:HasTag("has_gasmask") then
		return true
	end
end

local function IsInGassyRatty(inst)
	if inst.components.areaaware ~= nil and inst.components.areaaware:CurrentlyInTag("rattygas") then
		return true
	end
end

local function PlagueGasDamage(inst)
	if inst.components.health ~= nil then
		inst.components.health:DoDelta(-10)
		inst.components.health:DeltaPenalty(0.05)
	end
	if inst.components.sanity ~= nil then
		inst.components.sanity:DoDelta(-10)
	end
end

local function Breathe(inst)
	if not HasFilter(inst) and IsInGassyRatty(inst) then
		PlagueGasDamage(inst)
	end
end

inst:DoPeriodicTask(1,Breathe)
end)
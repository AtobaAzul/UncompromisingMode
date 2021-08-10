
return Class(function(self, inst)
self.inst = inst

local function HasFilter(inst)
	if inst:HasTag("hasplaguemask") or inst:HasTag("has_gasmask") then
		return true
	end
end

local function CleanAir(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local cleanair =  TheSim:FindEntities(x, y, z, 5, nil, nil, { "cleanair" })

	if cleanair ~= nil and cleanair > 0 then
		return false
	else
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
	if not HasFilter(inst) and IsInGassyRatty(inst) and CleanAir(inst) then
		PlagueGasDamage(inst)
	end
end

inst:DoPeriodicTask(1,Breathe)
end)
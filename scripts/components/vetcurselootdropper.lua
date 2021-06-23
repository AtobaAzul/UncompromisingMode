local function OnDeath(inst, data)
    --if inst.components.vetcurselootdropper.vetrate > 0.15 then
		if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot(inst.components.vetcurselootdropper.loot,1)
		end
    --end
end

local function OnAttacked(inst, data)
if data ~= nil and data.attacker ~= nil and data.damage ~= nil then
if data.attacker:HasTag("vetcurse") then
	if inst.components.health ~= nil then
	inst.components.vetcurselootdropper.vetrate = (data.damage/inst.components.health.maxhealth) + inst.components.vetcurselootdropper.vetrate
	end
end
end
end

local VetcurseLootdropper = Class(function(self, inst)
    self.inst = inst

    self.vetrate = 0
	self.loot = "hound"

    self.inst:ListenForEvent("death", OnDeath)
    self.inst:ListenForEvent("attacked", OnAttacked)
end)

function VetcurseLootdropper:OnSave(data)
if self.vetrate ~= nil and self.loot ~= nil then
return {loot = self.loot,vetrate = self.vetrate,}
end
end

function VetcurseLootdropper:OnLoad(data)
if data ~= nil then
if data.vetrate ~= nil then
self.vetrate = data.vetrate
end
if data.loot ~= nil then
self.loot = data.loot
end
end
end

return VetcurseLootdropper

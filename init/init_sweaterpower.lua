local _G = GLOBAL
local require = _G.require
local TUNING = _G.TUNING
local Vector3 = _G.Vector3
local ACTIONS = _G.ACTIONS
local RECIPETABS = _G.RECIPETABS
local STRINGS = _G.STRINGS
local TECH = _G.TECH
local GROUND = _G.GROUND
local SpawnPrefab = _G.SpawnPrefab
local getlocal = _G.debug.getlocal
local getupvalue = _G.debug.getupvalue
local EQUIPSLOTS = _G.EQUIPSLOTS

local WOOL = 
{
	["steelwool"] =
    {
		power = 30*TUNING.MED_FUEL,
    },
}

for k, v in pairs(WOOL) do
	AddPrefabPostInit(k, function(inst)
		if inst.components.fuel == nil then
			inst:AddComponent("fuel")
		end
		
		if inst.components.fuel ~= nil then
			inst.components.fuel.fuelvalue = v.power
			inst.components.fuel.fueltype = GLOBAL.FUELTYPE.SWEATERPOWER
		end
	end)
end
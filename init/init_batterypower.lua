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

local BATTERY = 
{
	["potato"] =
    {
		power = TUNING.MED_FUEL / 2,-- 6%
    },
	["transistor"] =
    {
		power = TUNING.MED_FUEL,-- 12%
    },
	["feather_canary"] =
    {
		power = TUNING.MED_FUEL,--12%
    },
	["trinket_6"] =
    {
		power = TUNING.MED_LARGE_FUEL,--24%
    },
	["lightninggoathorn"] =
    {
		power = TUNING.LARGE_FUEL,--50%
    },
	["goatmilk"] =
    {
		power = TUNING.LARGE_FUEL,--50%
    },
	["zaspberry"] =
    {
		power = TUNING.LARGE_FUEL * 2,--100%
    },
}

for k, v in pairs(BATTERY) do
	AddPrefabPostInit(k, function(inst)
		if inst.components.fuel == nil then
			inst:AddComponent("fuel")
		end
		
		if inst.components.fuel ~= nil then
			inst.components.fuel.fuelvalue = v.power
			inst.components.fuel.fueltype = GLOBAL.FUELTYPE.BATTERYPOWER
		end
	end)
end

local SALT = 
{
	["saltrock"] =
    {
		power = TUNING.MED_FUEL * 2,
    },
}

for k, v in pairs(SALT) do
	AddPrefabPostInit(k, function(inst)
		if inst.components.fuel == nil then
			inst:AddComponent("fuel")
		end
		
		if inst.components.fuel ~= nil then
			inst.components.fuel.fuelvalue = v.power
			inst.components.fuel.fueltype = GLOBAL.FUELTYPE.SALT
		end
	end)
end
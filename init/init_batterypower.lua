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
		power = TUNING.MED_FUEL * 2,
    },
	["transistor"] =
    {
		power = TUNING.MED_LARGE_FUEL * 2,
    },
	["feather_canary"] =
    {
		power = TUNING.MED_LARGE_FUEL * 3,
    },
	["lightninggoathorn"] =
    {
		power = TUNING.LARGE_FUEL * 3,
    },
	["goatmilk"] =
    {
		power = TUNING.LARGE_FUEL * 3,
    },
	["trinket_6"] =
    {
		power = TUNING.LARGE_FUEL * 3,
    },
	["zaspberry"] =
    {
		power = TUNING.LARGE_FUEL * 5,
    },
	--No klaus, since he does double attacks and has deer 
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
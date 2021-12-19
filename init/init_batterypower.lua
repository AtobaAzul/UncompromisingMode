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
		power = TUNING.MED_FUEL / 4,-- 6% 10~ sec NightLight 6.6~ sec Zapper
    },
	["transistor"] =
    {
		power = TUNING.MED_FUEL / 2,-- 12.5% 21~ sec NightLight 14~ sec Zapper
    },
	["feather_canary"] =
    {
		power = TUNING.MED_FUEL / 2,--12.5% 21~ sec NightLight 10~ sec Zapper
    },
	["trinket_6"] =
    {
		power = TUNING.MED_LARGE_FUEL / 2,--25% 43~ sec NightLight 28~ sec Zapper
    },
	["lightninggoathorn"] =
    {
		power = TUNING.LARGE_FUEL / 2,--50% 90~ sec NightLight 60~ sec Zapper
    },
	["goatmilk"] =
    {
		power = TUNING.LARGE_FUEL / 2,--50% 90~ sec NightLight 60~ sec Zapper
    },
	["zaspberry"] =
    {
		power = TUNING.LARGE_FUEL * 2,--100% 180~ sec NightLight 120~ sec Zapper
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
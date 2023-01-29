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
		power = TUNING.MED_FUEL / 3,
	},
	["feather_canary"] =
	{
		power = TUNING.MED_FUEL / 1.5,
	},
	["transistor"] =
	{
		power = TUNING.MED_FUEL,
	},
	["trinket_6"] =
	{
		power = TUNING.MED_FUEL,
	},
	["lightninggoathorn"] =
	{
		power = TUNING.LARGE_FUEL,
	},
	["goatmilk"] =
	{
		power = TUNING.LARGE_FUEL,
	},
	["zaspberry"] =
	{
		power = TUNING.LARGE_FUEL,
	},
}

if GLOBAL.TUNING.DSTU.ELECTRICALMISHAP == 2 then
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

--I'm blaming Zark for this not uploading properly ::::::ASDFAFSDFASDAZCQWECQWEFCCQWEFQWFCQ --Scrimbles

---------	                           -----------

-----------------------------------------
------
----------------------------------------
---------------



-------------------------------------------------------------------------------------------

local EYE =
{
	["milkywhites"] =
	{
		power = TUNING.MED_FUEL * 13,
	},
}

for k, v in pairs(EYE) do
	AddPrefabPostInit(k, function(inst)
		if inst.components.fuel == nil then
			inst:AddComponent("fuel")
		end

		if inst.components.fuel ~= nil then
			inst.components.fuel.fuelvalue = v.power
			inst.components.fuel.fueltype = GLOBAL.FUELTYPE.EYE
		end
	end)
end

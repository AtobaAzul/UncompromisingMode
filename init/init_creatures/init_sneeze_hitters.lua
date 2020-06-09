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

local HITTERS = 
{
	["mosquito"] =
    {
		power = -10,
    },
	["bee"] =
    {
		power = -10,
	},
	["killerbee"] =
    {
		power = -10,
	},
	["beeguard"] =
    {
		power = -10,
    },
	["beequeen"] =
    {
		power = -10,
	},
	["scorpion"] =
    {
		power = -10,
	},
	--No klaus, since he does double attacks and has deer 
}

for k, v in pairs(HITTERS) do
	AddPrefabPostInit(k, function(inst)
		local function OnHitOther(inst, other)
			if other ~= nil and other.components.hayfever and other.components.hayfever.enabled and other.components.hayfever:CanSneeze() then
			--Don't knockback ifws you wear marble
				other.components.hayfever:DoDelta(v.power)
			end
		end
	
		if inst.components.combat ~= nil then
			inst.components.combat.onhitotherfn = OnHitOther
		end
	end)
end
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
		power = -12,
    },
	["bee"] =
    {
		power = -12,
	},
	["killerbee"] =
    {
		power = -20,
	},
	["beeguard"] =
    {
		power = -12,
    },
	["beequeen"] =
    {
		power = -20,
	},
	["scorpion"] =
    {
		power = -12,
	},
	--No klaus, since he does double attacks and has deer 
}

AddPrefabPostInit("beehat", function(inst)
	inst:AddTag("beehat")
end)

for k, v in pairs(HITTERS) do
	AddPrefabPostInit(k, function(inst)
		local function OnHitOther(inst, other)
			if other ~= nil and other.components.hayfever and other.components.hayfever.enabled and other.components.hayfever:CanSneeze() and
			(other.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) == nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("beehat")) then
			--print(other.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD))
			--Don't knockback ifws you wear marble
				other.components.hayfever:DoDelta(v.power)
			end
		end
	
		if inst.components.combat ~= nil then
			inst.components.combat.onhitotherfn = OnHitOther
		end
	end)
end
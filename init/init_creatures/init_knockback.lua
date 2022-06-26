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

-----------------------------------------------------------------
-- Knockback mechanic for most bosses
-----------------------------------------------------------------
--TODO: Add antlion upward attack to deerclops shards
--TODO: Add AoE to most mobs that require it

local GIANTS = 
{
	--[[["bearger"] =
    {
        radius = 125,
		power = 1,
    },]]
	--[[["dragonfly"] =
    {
        radius = 75,
		power = 1.25,
    },]]
	--[[["mock_dragonfly"] =
    {
        radius = 75,
		power = 1.25,
    },]]
	--[[["leif"] =
    {
        radius = 75,
		power = 1,
    },
	["leif_sparse"] =
    {
        radius = 75,
		power = 1,
    },]]
	--[[["minotaur"] =
    {
        radius = 200,
		power = 1.5,
    },]]
	--[[["rook"] =
    {
        radius = 150,
		power = 1,
    },
	["krampus"] =
    {
        radius = 150,
		power = 1.5,
    },]]
	--[[["moose"] =
    {
        radius = 200,
		power = 1,
	},]]
	["mothergoose"] =
    {
        radius = 200,
		power = 1,
	},
	--No klaus, since he does double attacks and has deer 
}

for k, v in pairs(GIANTS) do
	AddPrefabPostInit(k, function(inst)
		local function OnHitOther(inst, other)
			if other:HasTag("creatureknockbackable") then
			other:PushEvent("knockback", {knocker = inst, radius = v.radius, strengthmult = v.power})
			else
			if other ~= nil and other.components.inventory ~= nil and not other:HasTag("fat_gang") and not other:HasTag("foodknockbackimmune") and not (other.components.rider ~= nil and other.components.rider:IsRiding()) and 
			--Don't knockback if you wear marble
			(other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
				other:PushEvent("knockback", {knocker = inst, radius = v.radius, strengthmult = v.power})
			end
			end
		end
	
		if inst.components.combat ~= nil then
			inst.components.combat.onhitotherfn = OnHitOther
		end
	end)
end

if GetModConfigData("harder_beequeen") then
AddPrefabPostInit("beequeen", function(inst)
    if inst.components.combat ~= nil then
		local function isnotbee(ent)
			if ent ~= nil and not ent:HasTag("bee") and not ent:HasTag("hive") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnotbee) -- you can edit these values to your liking -Axe
	end   
end)	
end
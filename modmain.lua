--[[
	Quick ref for global variables
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
]]
local require = GLOBAL.require
local ACTIONS = GLOBAL.ACTIONS


local BLOWNOSE = GLOBAL.Action({ priority=1})
BLOWNOSE.str = "Blow Nose"
BLOWNOSE.id = "BLOWNOSE"

BLOWNOSE.fn = function(act)
    if act.invobject ~= nil and act.doer ~= nil then
        return act.invobject.components.blow_nose:Play(act.doer)
    end
end

AddAction(BLOWNOSE)




AddComponentAction("INVENTORY", "blow_nose", function(inst, doer, actions)
    --if right then
        if doer ~= nil then
            table.insert(actions, GLOBAL.ACTIONS.BLOWNOSE)
        end
    --end
end)




PrefabFiles = require("uncompromising_prefabs")

--Start the game mode
modimport("init/init_gamemodes/init_uncompromising_mode")

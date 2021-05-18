----------------------------------------------------------------------------------------------------------
-- Remove thermal stone sewing
-- Relevant: heatrock.lua
----------------------------------------------------------------------------------------------------------
--[[
local function DoSewing(self, target, doer)
    if self ~= nil and self.inst ~= nil then
        local _OldDoSewing = self.DoSewing
        
        self.DoSewing = function(self, target, doer)
            if target ~= nil and not target:HasTag("heatrock") then --<< Check for thermal
                _OldDoSewing(self, target, doer)
            end
        end
    end
end
AddComponentPostInit("sewing", DoSewing)
--TODO thermal stone stacking
--]]
-------------Torches only smolder objects now---------------
local _OldLightAction = GLOBAL.ACTIONS.LIGHT.fn

GLOBAL.ACTIONS.LIGHT.fn = function(act)
    if act.invobject ~= nil and act.invobject.components.lighter ~= nil then
		if GLOBAL.TheWorld.state.season == "winter" and not act.doer:HasTag("pyromaniac") then
			if act.invobject.components.fueled then
				act.invobject.components.fueled:DoDelta(-5, act.doer) --Hornet: Made it take fuel away because.... The snow and cold takes some of the fire? probably will change
			end
			act.target.components.burnable:StartWildfire()
			return true
		else
			return _OldLightAction(act)
		end
	end
end

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    
    inst:AddComponent("cavedeerclopsspawner")
    inst:AddComponent("randomnighteventscaves")
	
	local newwormspawn =
{
    base_prefab = "worm",
    winter_prefab = "shockworm",
    summer_prefab = "viperworm",

    attack_levels =
    {
        intro   = { warnduration = function() return 120 end, numspawns = function() return 1 end },
        light   = { warnduration = function() return 60 end, numspawns = function() return 1 + math.random(0,1) end },
        med     = { warnduration = function() return 45 end, numspawns = function() return 1 + math.random(0,1) end },
        heavy   = { warnduration = function() return 30 end, numspawns = function() return 2 + math.random(0,1) end },
        crazy   = { warnduration = function() return 30 end, numspawns = function() return 3 + math.random(0,2) end },
    },

    attack_delays =
    {
        rare        = function() return TUNING.TOTAL_DAY_TIME * 10, math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
        occasional  = function() return TUNING.TOTAL_DAY_TIME * 8, math.random() * TUNING.TOTAL_DAY_TIME * 7 end,
        frequent    = function() return TUNING.TOTAL_DAY_TIME * 6, math.random() * TUNING.TOTAL_DAY_TIME * 5 end,
    },

    warning_speech = "ANNOUNCE_WORMS",

    --Key = time, Value = sound prefab
    warning_sound_thresholds =
    {
        { time = 30, sound = "LVL4_WORM" },
        { time = 60, sound = "LVL3_WORM" },
        { time = 90, sound = "LVL2_WORM" },
        { time = 500, sound = "LVL1_WORM" },
    },
}
inst.components.hounded:SetSpawnData(newwormspawn)
end)

local function OnSeasonTick(inst)
	if TheWorld.state.isspring then
		if not TheWorld.components.mock_dragonflyspawner then
			inst:AddComponent("mock_dragonflyspawner")
		end
	end
end

local function OnLoad(inst, data)
	if inst.components.deerclopsspawner ~= nil then
		TheWorld.components.deerclopsspawner:OverrideAttacksPerSeason("DEERCLOPS", 0)
		inst:RemoveComponent("deerclopsspawner")
	end
	
	if inst.components.forestresourcespawner ~= nil then
		inst:RemoveComponent("forestresourcespawner")
	end
	
	if inst.components.regrowthmanager ~= nil then
		inst:RemoveComponent("regrowthmanager")
	end
	
	if inst.components.desolationspawner ~= nil then
		inst:RemoveComponent("desolationspawner")
	end
end

local function OnSave()
	--Now, if you're seeing this, you might be asking yourself, "Why is the default deerclops spawner
	--being overwriten to 0? Cant you just outright disable the whole thing? Why don't you just edit
	--the original component?" The answer, is that modding is fickle, and for some reason I cannot
	--figure out, having the default spawner enabled completely glitches up the mock dragonfly and
	--mother goose spawners, funny thing is, this uncomp deerclops spawner is a nearly IDENTICAL version,
	--yet it doesnt have any effect, despite (ill say it again), being an IDENTICAL component.
	--Removing the component from the world doesnt do anything, the only easy method is to keep on
	--overriding the attacks per season to 0 on the classic version
	if TheWorld.components.deerclopsspawner ~= nil then
		TheWorld.components.deerclopsspawner:OverrideAttacksPerSeason("DEERCLOPS", 0)
		inst:RemoveComponent("deerclopsspawner")
	end
	--/////////--
end

env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	inst:AddComponent("toadrain")
	--inst:AddComponent("hayfever_tracker")
	inst:AddComponent("firefallwarning")
	
	inst:RemoveComponent("deerclopsspawner")

	
	
	
	inst:AddComponent("uncompromising_deerclopsspawner")
	inst:AddComponent("pollenmitedenspawner")
	--inst:ListenForEvent("seasontick", OnSeasonTick)
	inst:AddComponent("snowstorminitiator")
	inst:AddComponent("scorpionspawner")
	inst:AddComponent("randomnightevents")
	
	
	inst.OnSave = OnSave
	
	inst.OnLoad = OnLoad
end)

if GetModConfigData("mother_goose") == true then
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	inst:AddComponent("gmoosespawner")
end)
end

if GetModConfigData("wiltfly") == true then
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	inst:AddComponent("mock_dragonflyspawner")
end)
end

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst.OnLoad = OnLoad
end)
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
if TUNING.DSTU.WINTER_BURNING then
	GLOBAL.ACTIONS.LIGHT.fn = function(act)
		if act.invobject ~= nil and act.invobject.components.lighter ~= nil then
			if GLOBAL.TheWorld.state.season == "winter" and not act.doer:HasTag("pyromaniac") and act.target.components.burnable
				and not GLOBAL:TestForIA() then
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
end

local env = env
GLOBAL.setfenv(1, GLOBAL)

local function GenerateBiomes()
	if TheWorld.state.isspring then
		TheWorld.components.um_areahandler:FullGenerate()
	end
end

local function GenerateInactiveBiomes()
	if TheWorld.components.um_areahandler ~= nil then
		TheWorld.components.um_areahandler:GenerateInactiveBiomes()
	end
end

-----------------------------------------------------------------
env.AddPrefabPostInit("cave", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if TUNING.DSTU.CAVECLOPS then
		inst:AddComponent("cavedeerclopsspawner")
	end
	inst:AddComponent("randomnighteventscaves")
	inst:AddComponent("ratacombs_junk_manager")

	inst:AddComponent("um_stormspawner")
	
	if TUNING.DSTU.PYRENETTLES then
		inst:AddComponent("um_pyre_nettles_summer_spawner")
	end

	inst:DoTaskInTime(0, function(inst)
		if TestForIA() then
			inst:RemoveComponent("cavedeerclopsspawner")
			inst:RemoveComponent("randomnighteventscaves")
			inst:RemoveComponent("ratacombs_junk_manager")
		end
	end)
end)

env.AddPrefabPostInit("forest", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst:AddComponent("uncompromising_deerclopsspawner")

	--inst:AddComponent("toadrain")
	--inst:AddComponent("hayfever_tracker")
	inst:AddComponent("firefallwarning")
	inst:AddComponent("pollenmitedenspawner")
	inst:AddComponent("randomnightevents")
	inst:AddComponent("um_areahandler")
	--inst:AddComponent("horriblenightmanager")
	--inst:AddComponent("um_oceantilelogger")
	--inst:AddComponent("um_ocupusappearinator")
	inst:AddComponent("um_pestilencecontroller")
	if TUNING.DSTU.SPAWNMOTHERGOOSE then
		inst:AddComponent("gmoosespawner")
	end

	if TUNING.DSTU.SPAWNWILTINGFLY then
		inst:AddComponent("mock_dragonflyspawner")
	end

	--halted biome spawning until UTW.
	--inst:WatchWorldState("isspring", GenerateBiomes)
	--inst:WatchWorldState("issummer", GenerateInactiveBiomes)

	--inst:DoTaskInTime(TUNING.TOTAL_DAY_TIME/2, GenerateInactiveBiomes)

	if TUNING.DSTU.SNOWSTORMS then
		--inst:AddComponent("snowstorminitiator")
		inst:AddComponent("um_snow_stormspawner")
	end

	if TUNING.DSTU.HEATWAVES then
		inst:AddComponent("um_heatwaves")
	end

	if TUNING.DSTU.STORMS then
		inst:AddComponent("um_stormspawner")
	end

	inst:DoTaskInTime(0, function(inst)--doesn't work for some components, but works for others.
		print("HERE TestForIA:", TestForIA())
		if TestForIA() then --remove components if the world is IA island/volcano, instead of checking for the mod or delaying adding components.
			inst:RemoveComponent("uncompromising_deerclopsspawner")
			inst:RemoveComponent("toadrain")
			--inst:RemoveComponent("hayfever_tracker")
			inst:RemoveComponent("firefallwarning")
			inst:RemoveComponent("pollenmitedenspawner")
			inst:RemoveComponent("randomnightevents")
			inst:RemoveComponent("um_areahandler")
			inst:RemoveComponent("gmoosespawner")
			inst:RemoveComponent("mock_dragonflyspawner")
			inst:RemoveComponent("um_snow_stormspawner")
			--inst:RemoveComponent("um_stormspawner")
			--inst:AddComponent("um_pestilencecontroller")
		end
	end)
end)

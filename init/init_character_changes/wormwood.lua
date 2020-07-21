local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function DefaultIgniteFn(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:StartWildfire()
    end
	MakeSmallPropagator(inst)
end

local WATCH_WORLD_PLANTS_DIST_SQ = 20 * 20
local SANITY_DRAIN_TIME = 5

local function DoKillPlantPenalty(inst, penalty, overtime)
    if overtime then
        table.insert(inst.plantpenalties, { amt = -penalty / SANITY_DRAIN_TIME, t = SANITY_DRAIN_TIME })
    else
        while #inst.plantbonuses > 0 do
            table.remove(inst.plantbonuses)
        end
        inst.components.sanity:DoDelta(-penalty)
        inst.components.talker:Say(GetString(inst, "ANNOUNCE_KILLEDPLANT"))
    end
end

local function WatchWorldPlants2(inst)
    if inst._onplantkilled2 == nil then
        inst._onplantkilled2 = function(src, data)
            if data == nil then
                --shouldn't happen
            elseif data.doer == inst then
                DoKillPlantPenalty(inst, data.workaction ~= nil and data.workaction == ACTIONS.DIG and TUNING.SANITY_TINY or 0)
            end
        end
        inst:ListenForEvent("plantkilled", inst._onplantkilled2, TheWorld)
    end
end

local function StopWatchingWorldPlants2(inst)
    if inst._onplantkilled2 ~= nil then
        inst:RemoveEventCallback("plantkilled", inst._onplantkilled2, TheWorld)
        inst._onplantkilled2 = nil
    end
end

local function OnRespawnedFromGhost2(inst)
    WatchWorldPlants2(inst)
	inst:DoTaskInTime(5, function(inst) MakeSmallPropagator(inst) end)
end

local function OnBecameGhost2(inst)
    StopWatchingWorldPlants2(inst)
end

local function OnBurnt(inst)
	--Overriding the OnBurnt function to prevent propegator from sometimes removing, hopefully.
	inst:DoTaskInTime(5, function(inst) MakeSmallPropagator(inst) end)
end

env.AddPrefabPostInit("wormwood", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.burnable ~= nil then
		MakeSmallPropagator(inst)
		inst.components.burnable:SetOnBurntFn(OnBurnt)
	end
	
    WatchWorldPlants2(inst)
    inst:ListenForEvent("ms_becameghost", OnBecameGhost2)
    inst:ListenForEvent("ms_respawnedfromghost", OnRespawnedFromGhost2)
	
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function SnowedIn(inst, season)
	if season == "winter" then
		inst:AddTag("snowedin")
		inst:RemoveTag("migrator")
	else
		inst:RemoveTag("snowedin")
		inst:AddTag("migrator")
	end 
end

local function GetStatus(inst)
    return (inst:HasTag("snowedin") and "SNOWED")
		or (inst.components.worldmigrator:IsActive() and "OPEN")
        or (inst.components.worldmigrator:IsFull() and "FULL")
        or nil
end

env.AddPrefabPostInit("cave_entrance_open", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if inst.components.childspawner ~= nil then
		inst.components.childspawner:SetSpawnPeriod(.1/TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
		inst.components.childspawner:SetMaxChildren(6*TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
	end
	--[[inst:WatchWorldState("season", SnowedIn)
	SnowedIn(inst, TheWorld.state.season)
	
	inst.components.inspectable.getstatus = GetStatus]]
end)
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

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function OnIsDay(inst, isday)
    if isday then
        inst.components.childspawner:StartRegen()
        inst.components.childspawner:StopSpawning()
        ReturnChildren(inst)
    else
        inst.components.childspawner:StartRegen()
        inst.components.childspawner:StartSpawning()
    end
end

local function onnear(inst, target)
    --hive pop open? Maybe rustle to indicate danger?
    --more and more come out the closer you get to the nest?
    if inst.components.childspawner ~= nil and not TheWorld.state.isday then
        inst.components.childspawner:ReleaseAllChildren(target, "bat")
		--inst.components.childspawner:ReleaseAllChildren(target, "vampirebat")
    end
end

local function OnSleep(inst)
	if inst.spawnupdatetask ~= nil then
		inst.spawnupdatetask:Cancel()
		inst.spawnupdatetask = nil
	end
	
    inst.components.childspawner:SetSpawnPeriod(TUNING.CAVE_ENTRANCE_BATS_SPAWN_PERIOD)
end

local function OnWake(inst)
	if inst.spawnupdatetask ~= nil then
		inst.spawnupdatetask:Cancel()
		inst.spawnupdatetask = nil
	end

    inst.spawnupdatetask = inst:DoTaskInTime(5, function(inst) inst.components.childspawner:SetSpawnPeriod(TUNING.DSTU.CAVE_ENTRANCE_BATS_SPAWN_PERIOD_UM) end)
end

env.AddPrefabPostInit("cave_entrance_open", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if inst.components.childspawner ~= nil then
	
		if TUNING.DSTU.BATSPOOKING == true then
			inst.components.childspawner:SetRegenPeriod(60/TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
			--inst.components.childspawner:SetSpawnPeriod(TUNING.DSTU.CAVE_ENTRANCE_BATS_SPAWN_PERIOD_UM)
			
			inst:ListenForEvent("entitysleep", OnSleep)
			inst:ListenForEvent("entitywake", OnWake)
		end
		--inst.components.childspawner:SetMaxChildren(6*TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
		if TUNING.DSTU.ADULTBATILISKS == true then
			inst.components.childspawner.rarechild = "vampirebat"
		end
		
		--[[inst:AddComponent("playerprox")
		inst.components.playerprox:SetDist(11, 14) --set specific values
		inst.components.playerprox:SetOnPlayerNear(onnear)
		inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)]]
	end
	
	
    OnIsDay(inst, TheWorld.state.isday)
    inst:WatchWorldState("isday", OnIsDay)
	--[[inst:WatchWorldState("season", SnowedIn)
	SnowedIn(inst, TheWorld.state.season)
	
	inst.components.inspectable.getstatus = GetStatus]]
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function ShouldKeepTarget()
    return false -- chester can't attack, and won't sleep if he has a target
end

local brain = require("brains/smallwobybrain")

env.AddPrefabPostInit("wobysmall", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:SetBrain(brain)
	
	--inst:AddTag("character")

    if inst.components.eater ~= nil then
        inst.components.eater.strongstomach = true
    end
	
    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)

	
end)

env.AddPrefabPostInit("wobybig", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	--inst:AddTag("character")

    if inst.components.eater ~= nil then
        inst.components.eater.strongstomach = true
    end
	
    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH * 2)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)

	
end)

local function SpawnWoby(inst)
	print(inst.respawntime)
    local player_check_distance = 40
    local attempts = 0
    
    local max_attempts = 30
    local x, y, z = inst.Transform:GetWorldPosition()

    local woby = SpawnPrefab(TUNING.WALTER_STARTING_WOBY)
	inst.woby = woby
	woby:LinkToPlayer(inst)
    inst:ListenForEvent("onremove", inst._woby_onremove, woby)

    while true do
        local offset = FindWalkableOffset(inst:GetPosition(), math.random() * PI, player_check_distance + 1, 10)

        if offset then
            local spawn_x = x + offset.x
            local spawn_z = z + offset.z
            
            if attempts >= max_attempts then
                woby.Transform:SetPosition(spawn_x, y, spawn_z)
                break
            elseif not IsAnyPlayerInRange(spawn_x, 0, spawn_z, player_check_distance) then
                woby.Transform:SetPosition(spawn_x, y, spawn_z)
                break
            else
                attempts = attempts + 1
            end
        elseif attempts >= max_attempts then
            woby.Transform:SetPosition(x, y, z)
            break
        else
            attempts = attempts + 1    
        end
    end
	
	inst.respawntime = nil

    return woby
end

local function OnWobyRemoved(inst, time)
	inst.woby = nil
	time = time or 0
	inst._replacewobytask = inst:DoTaskInTime(time, function(i) i._replacewobytask = nil if i.woby == nil then SpawnWoby(i) end end)
    inst.respawntime = time
end

local function OnSave(inst, data)
	data.woby = inst.woby ~= nil and inst.woby:GetSaveRecord() or nil
	
	if inst.respawntime ~= nil then
        local time = GetTime()
        if inst.respawntime > time then
            data.respawntimeremaining = inst.respawntime - time
        end
    end
end

local function OnPreLoad(inst, data)
	if data.respawntimeremaining ~= nil then
        inst.respawntime = data.respawntimeremaining
		inst._woby_spawntask = inst:DoTaskInTime(inst.respawntime, function(i) i._woby_spawntask = nil SpawnWoby(i) end)
    else
		inst._woby_spawntask = inst:DoTaskInTime(0, function(i) i._woby_spawntask = nil SpawnWoby(i) end)
    end
end

local function OnLoad(inst, data)
	if data.respawntimeremaining == nil and data ~= nil and data.woby ~= nil then
		inst._woby_spawntask:Cancel()
		inst._woby_spawntask = nil

		local woby = SpawnSaveRecord(data.woby)
		inst.woby = woby
		if woby ~= nil then
			if inst.migrationpets ~= nil then
				table.insert(inst.migrationpets, woby)
			end
			woby:LinkToPlayer(inst)

	        woby.AnimState:SetMultColour(0,0,0,1)
            woby.components.colourtweener:StartTween({1,1,1,1}, 19*FRAMES)
			local fx = SpawnPrefab(woby.spawnfx)
			fx.entity:SetParent(woby.entity)

			inst:ListenForEvent("onremove", inst._woby_onremove, woby)
		end
	end
end

local function OnPreLoad(inst, data)
	if data.respawntimeremaining ~= nil then
		inst._woby_spawntask:Cancel()
		inst._woby_spawntask = nil
        inst.respawntime = data.respawntimeremaining + GetTime()
		inst._woby_spawntask = inst:DoTaskInTime(inst.respawntime, function(i) i._woby_spawntask = nil SpawnWoby(i) end)
    end
end

local function printout(inst)
	print(inst.respawntime)
	inst:DoTaskInTime(5, printout)
end

env.AddPrefabPostInit("walter", function(inst)
	if not TheWorld.ismastersim then
		return
	end


	inst.OnSave = OnSave
	inst.OnPreLoad = OnPreLoad
	inst.OnLoad = OnLoad
	
	inst._woby_onremove = function(woby) OnWobyRemoved(inst, 480) end
	
	--print(inst.respawntime)
	--local spawntime = inst.respawntime
	--inst:DoTaskInTime(0, printout)
	--if inst.respawntime ~= nil then
	--end
end)
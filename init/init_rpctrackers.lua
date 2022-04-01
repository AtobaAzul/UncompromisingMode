local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function DeerclopsDeathRPC(inst)
	if inst.deerdeathtask == nil or inst.deerdeathtask then
		print("FOREST DEATH")
		inst.deerdeathtask = false
			inst:DoTaskInTime(5, function(inst)
				inst.deerdeathtask = true
			end)
		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsDeath"), nil)
	end
end

local function DeerclopsRemovedRPC(inst)
	if inst.deerremovedtask == nil or inst.deerremovedtask then
		print("FOREST REMOVED")
		inst.deerremovedtask = false
			inst:DoTaskInTime(5, function(inst)
				inst.deerremovedtask = true
			end)
		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsRemoved"), nil)
	end
end

local function DeerclopsStoredRPC(inst)
	if inst.deerstoredtask == nil or inst.deerstoredtask then
		print("FOREST STORED")
		inst.deerstoredtask = false
			inst:DoTaskInTime(5, function(inst)
				inst.deerstoredtask = true
			end)
		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsStored"), nil)
	end
end
	
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	
	inst:AddComponent("skullchestinventory")
	inst:AddComponent("winkyburrowinventory")
	inst:ListenForEvent("hasslerremoved", DeerclopsRemovedRPC, TheWorld)
	inst:ListenForEvent("hasslerkilled", DeerclopsDeathRPC, TheWorld)
	inst:ListenForEvent("storehassler", DeerclopsStoredRPC, TheWorld)
end)

local function DeerclopsDeathRPC_caves(inst)
	if inst.deerdeathtask == nil or inst.deerdeathtask then
		print("CAVE DEATH")
		inst.deerdeathtask = false
			inst:DoTaskInTime(5, function(inst)
				inst.deerdeathtask = true
			end)
		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsDeath_caves"), nil)
	end
end

local function DeerclopsRemovedRPC_caves(inst)
	if inst.deerremovedtask == nil or inst.deerremovedtask then
		print("CAVE REMOVED")
		inst.deerremovedtask = false
			inst:DoTaskInTime(5, function(inst)
				inst.deerremovedtask = true
			end)
		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsRemoved_caves"), nil)
	end
end

local function DeerclopsStoredRPC_caves(inst)
	if inst.deerstoredtask == nil or inst.deerstoredtask then
		print("CAVE STORED")
		inst.deerstoredtask = false
			inst:DoTaskInTime(5, function(inst)
				inst.deerstoredtask = true
			end)
		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsStored_caves"), nil)
	end
end

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	inst:AddComponent("skullchestinventory")
	inst:AddComponent("winkyburrowinventory")
	inst:ListenForEvent("hasslerremoved", DeerclopsRemovedRPC_caves, TheWorld)
	inst:ListenForEvent("hasslerkilled", DeerclopsDeathRPC_caves, TheWorld)
	inst:ListenForEvent("storehassler", DeerclopsStoredRPC_caves, TheWorld)
end)
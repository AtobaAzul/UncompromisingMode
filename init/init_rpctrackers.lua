local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function DeerclopsDeathRPC()
	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsDeath"), nil)
end

local function DeerclopsRemovedRPC()
	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsRemoved"), nil)
end

local function DeerclopsStoredRPC()
	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "DeerclopsStored"), nil)
end
	

env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst:ListenForEvent("hasslerremoved", DeerclopsRemovedRPC, TheWorld)
	inst:ListenForEvent("hasslerkilled", DeerclopsDeathRPC, TheWorld)
	inst:ListenForEvent("storehassler", DeerclopsStoredRPC, TheWorld)
end)

env.AddPrefabPostInit("caves", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst:ListenForEvent("hasslerremoved", DeerclopsRemovedRPC, TheWorld)
	inst:ListenForEvent("hasslerkilled", DeerclopsDeathRPC, TheWorld)
	inst:ListenForEvent("storehassler", DeerclopsStoredRPC, TheWorld)
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)

local function RandomThreatSpring(inst)
if math.random() > 0 then  --This'll ensure that only hayfevers occur in any updates until monsoons are finished, to test monsoons, simply change to math.random() > 2
--TheWorld:AddTag("hayfever")
--TheWorld.net:AddTag("hayfever")
else
TheWorld:AddTag("monsoons")
TheWorld.net:AddTag("monsoons")
end
end
local function UndoRandomThreatSpring(inst)
if	TheWorld:HasTag("hayfever") then
TheWorld:RemoveTag("hayfever")
TheWorld.net:RemoveTag("hayfever")
end
if	TheWorld:HasTag("monsoons") then
TheWorld:RemoveTag("monsoons")
TheWorld.net:RemoveTag("monsoons")
end
end
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst:AddComponent("hayfever_tracker")
	inst:AddComponent("monsoons")
	inst:WatchWorldState("isspring", RandomThreatSpring)
	inst:WatchWorldState("issummer", UndoRandomThreatSpring)
end)

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst:AddComponent("hayfever_tracker")
	
end)

env.AddPlayerPostInit(function(inst)
if inst:HasTag("scp049") then
inst:AddTag("hasplaguemask")
inst:AddTag("has_gasmask")
end
end)
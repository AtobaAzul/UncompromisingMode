local function OverCrowded(x,z)
	if #TheSim:FindEntities(x,0,z,4,{"ratjunk"}) < 4 and #TheSim:FindEntities(x,0,z,6,{"ratjunk"}) < 6 then
		return false --Not OverCrowded, continue spawning
	else
		return true  --OverCrowded, try again
	end
end

local function GetSpawnPoint(inst)
	local x,y,z
	local satisfied = false
	local attempt = 0
	while satisfied == false do
		attempt = attempt + 1 --Attempts will prevent crashes due to not finding a location, no more stack overflows
		x,y,z = inst.Transform:GetWorldPosition()
		x = x + math.random(-10,10)
		z = z + math.random(-10,10)
		if (TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) and OverCrowded(x,z) == false) or attempt > 10 then
			satisfied = true
		end
	end
	return x,y,z
end

local function TryRatInfest(junk)
	local x,y,z = junk.Transform:GetWorldPosition()
	local infestedjunk1 = TheSim:FindEntities(x,y,z,10,{"ratinfested"})
	local infestedjunk2 = TheSim:FindEntities(x,y,z,20,{"ratinfested"})
	if #infestedjunk2 < 6 then
		junk.inhabited = true
		junk.BecomeSpawner(junk)
	end
	if #infestedjunk1 < 3 then
		junk.inhabited = true
		junk.BecomeSpawner(junk)
	end
end

local function SpawnMoreJunk(inst)
	for i = 1,math.random(3,5) do
		local junk = SpawnPrefab("ratacombs_junkpile")
		junk.Transform:SetPosition(GetSpawnPoint(inst))
		TryRatInfest(junk)
	end
	
	inst:Remove() --Final version will not remove itself.... because it should respawn junk for the player.
end

local function OnSave(inst,data)
data.initialized = inst.initialized
end

local function OnLoad(inst,data)
	if data ~= nil and data.initialized ~= nil then
		inst.initialized = true
	end
end

local function Initialize(inst)
	if TheWorld.components.ratacombs_junk_manager ~= nil then
		if TheWorld.components.ratacombs_junk_manager.spawnerlist ~= nil then
			table.insert(TheWorld.components.ratacombs_junk_manager.spawnerlist,inst)
		else
			TheWorld.components.ratacombs_junk_manager.spawnerlist = {}
			table.insert(TheWorld.components.ratacombs_junk_manager.spawnerlist,inst)
		end
	end
end

local function spawnerfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SpawnMoreJunk = SpawnMoreJunk -- Save this function for use in world component later.
	
	inst:DoTaskInTime(0,Initialize)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	return inst
end

local function triggerfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	if not TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(1,function(inst)
		if TheWorld.components.ratacombs_junk_manager ~= nil then
			TheWorld.components.ratacombs_junk_manager:MakeSpawnersSpawn()
		end
		inst:Remove()
	end)
	return inst
end

return Prefab("ratacombs_junkpile_spawner", spawnerfn),
Prefab("ratacombs_junkpile_trigger", triggerfn)
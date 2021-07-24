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
		x = x + math.random(-20,20)
		z = z + math.random(-20,20)
		if (TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) and OverCrowded(x,z) == false) or attempt > 10 then
			satisfied = true
		end
	end
	return x,y,z
end

local function SpawnMoreJunk(inst)
	for i = 1,math.random(3,5) do
		SpawnPrefab("ratacombs_junkpile").Transform:SetPosition(GetSpawnPoint(inst))
	end
	
	inst:Remove() --Final version will not remove itself.... because it should respawn junk for the player.
end

local function spawnerfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SpawnMoreJunk = SpawnMoreJunk -- Save this function for use in world component later.
	
	inst:DoTaskInTime(0,SpawnMoreJunk)
	
	return inst
end

return Prefab("ratacombs_junkpile_spawner", spawnerfn)
local env = env
GLOBAL.setfenv(1, GLOBAL)

local function SpawnSpawner(inst)
local pt = inst:GetPosition()
pt.x = pt.x + math.random(-10,10)
pt.z = pt.z + math.random(-10,10)
print("didthat2")
if TheWorld.Map:IsAboveGroundAtPoint(pt.x, 0, pt.z) then
local spawner = SpawnPrefab("ancient_trepidation_anchor")
spawner.Transform:SetPosition(pt.x,0,pt.z)
else
inst:DoTaskInTime(0.1, SpawnSpawner(inst))
end
end

local function CheckForSpawners(inst)
local pt = inst:GetPosition()
local spawners = TheSim:FindEntities(pt.x,pt.y,pt.z,50,{"trepidationspawner"})
print(spawners)
print(#spawners)
if #spawners == 0 then
print("didthat")
SpawnSpawner(inst)
end
end

env.AddPrefabPostInit("ruins_statue_head", function(inst)
	if not TheWorld.ismastersim then
		return
	end
inst:DoTaskInTime(math.random(0.1,0.4),CheckForSpawners)
end)

env.AddPrefabPostInit("ruins_statue_head_nogem", function(inst)
	if not TheWorld.ismastersim then
		return
	end
inst:DoTaskInTime(math.random(0.1,0.4),CheckForSpawners)
end)

env.AddPrefabPostInit("ruins_statue_mage", function(inst)
	if not TheWorld.ismastersim then
		return
	end
inst:DoTaskInTime(math.random(0.1,0.4),CheckForSpawners)
end)

env.AddPrefabPostInit("ruins_statue_mage_nogem", function(inst)
	if not TheWorld.ismastersim then
		return
	end
inst:DoTaskInTime(math.random(0.1,0.4),CheckForSpawners)
end)
local assets =
{
	Asset("MINIMAP_IMAGE", "whitespider_den"),
}

local prefabs =
{
    "spider_dropper",
}

local function OnKilled(inst)
    inst.components.timer:StartTimer("regen_widow", TUNING.DRAGONFLY_RESPAWN_TIME)
end

local function GenerateNewWidow(inst)
    inst.components.childspawner:AddChildrenInside(1)
    --inst.components.childspawner:StartSpawning()
end

local function ontimerdone(inst, data)
    if data.name == "regen_widow" then
        GenerateNewWidow(inst)
    end
end

local function SpawnInvestigators(inst, data)
	local test = nil
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, { "epic" }, {"hoodedwidow"})
	if #ents >= 1 then
	test = true
	else
	test = false
	end
    if inst.components.childspawner ~= nil and not test == true then
            local spider = inst.components.childspawner:SpawnChild(data.target, nil, 3)
            if spider ~= nil then
			local x,y,z = inst.Transform:GetWorldPosition()
			spider.Physics:Teleport(x, 15, z)
            spider.sg:GoToState("fall")
			spider:AddTag("justcame")
			spider:DoTaskInTime(1,function(spider) inst:RemoveTag("justcame") end)
            end
    end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddGroundCreepEntity()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	inst.MiniMapEntity:SetIcon("hoodedwidow_map.tex")
    inst.GroundCreepEntity:SetRadius(10)
    inst:AddTag("spiderden")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("creepactivate", SpawnInvestigators)

   -- inst:AddComponent("health")
    --inst.components.health.nofadeout = true
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "hoodedwidow"
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(TUNING.DRAGONFLY_SPAWN_TIME, 0)
    inst.components.childspawner.onchildkilledfn = OnKilled
    --inst.components.childspawner:StartSpawning()
    inst.components.childspawner:StopRegen()

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)
    return inst
end

return Prefab("widowweb", fn, assets, prefabs)

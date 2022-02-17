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

local function SpawnInvestigators(inst, target)
	local test = nil
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, { "epic" }, {"hoodedwidow"})
	if #ents >= 1 then
	test = true
	else
	test = false
	end
    if inst.components.childspawner ~= nil and not test == true and target ~= nil then
        local spider = inst.components.childspawner:SpawnChild(target, nil, 3)
        if spider ~= nil then
			local x,y,z = inst.Transform:GetWorldPosition()
            spider.sg:GoToState("fall")
			spider:DoTaskInTime(0.5,function(spider) spider.components.combat:SuggestTarget(target) end)
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
    inst.entity:SetPristine()
	inst.entity:AddGroundCreepEntity()
		
    if not TheWorld.ismastersim then
        return inst
    end

    inst.SpawnInvestigators = SpawnInvestigators
	inst:AddTag("widowweb")
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "hoodedwidow"
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(TUNING.DRAGONFLY_SPAWN_TIME, 0)
    inst.components.childspawner.onchildkilledfn = OnKilled
    inst.components.childspawner:StopRegen()
	inst.GroundCreepEntity:SetRadius(8)
    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)
    return inst
end

return Prefab("widowweb", fn, assets, prefabs)

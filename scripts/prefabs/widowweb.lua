local assets =
{
	Asset("MINIMAP_IMAGE", "whitespider_den"),
}

local prefabs =
{
    "spider_dropper",
}


local function SpawnInvestigators(inst, data)
    if inst.components.childspawner ~= nil then
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

    inst.GroundCreepEntity:SetRadius(10)
    inst:AddTag("spiderden")
    inst.MiniMapEntity:SetIcon("whitespider_den.png")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("creepactivate", SpawnInvestigators)

   -- inst:AddComponent("health")
    --inst.components.health.nofadeout = true
	inst:AddTag("widowweb")
    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(100)
    inst.components.childspawner:SetSpawnPeriod(100)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()
    inst.components.childspawner.childname = "hoodedwidow"
    return inst
end

return Prefab("widowweb", fn, assets, prefabs)

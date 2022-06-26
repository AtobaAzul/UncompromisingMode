local assets =
{
	Asset("MINIMAP_IMAGE", "whitespider_den"),
}

local prefabs =
{
    "spider_dropper",
}

local function TrySpawnCocoon(x, z)
    local xi = x + math.random(-12, 12)
    local zi = z + math.random(-12, 12)
    if #TheSim:FindEntities(xi, 0, zi, 1.5, {"webbedcreature"}) == 0 and
       #TheSim:FindEntities(xi, 0, zi, 3, {"webbedcreature"}) < 2 and
       #TheSim:FindEntities(xi, 0, zi, 5, {"webbedcreature"}) < 6 then
        local cocoon = SpawnPrefab("webbedcreature")
        cocoon.Transform:SetPosition(xi, 0, zi)
    else
        TrySpawnCocoon(x, z)
    end
end

local function SpawnCocoon(inst)
    local cap = math.random(8, 10)
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, cap do
        TrySpawnCocoon(x, z)
    end
end

local function RerollCocoons(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local existing_cocoons = TheSim:FindEntities(x,y,z, 30, {"webbedcreature"})
    local widowweb = TheSim:FindFirstEntityWithTag("widowweb")
    print("widowweb:",widowweb)
    if widowweb ~= nil--[[Just to prevent a crash if it was deleted.]] and widowweb.components.childspawner:IsFull() then
        for k, v in ipairs(existing_cocoons) do
            v:Remove()
        end
        print("spawning new cocoons!")
        SpawnCocoon(inst)
    else
        print("widowweb was nil or not full!")
    end
end

local function OnKilled(inst)
    inst.components.timer:StartTimer("regen_widow", TUNING.DRAGONFLY_RESPAWN_TIME)
    if inst._cdtask ~= nil then
        inst._cdtask:Cancel()
    end
    inst._rerolltask = nil
end

local function GenerateNewWidow(inst)
    inst.components.childspawner:AddChildrenInside(1)
    --inst.components.childspawner:StartSpawning()
    if inst._rerolltask == nil then
        inst._rerolltask = inst:DoPeriodicTask(2--[[TUNING.TOTAL_DAY_TIME*5]], RerollCocoons, 0, inst)
    end
end

local function ontimerdone(inst, data)
    if data.name == "regen_widow" then
        GenerateNewWidow(inst)
    end
end

local function SpawnInvestigators(inst, target)
	local test = nil
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, { "epic" }, {"hoodedwidow","leif"})
	if #ents >= 1 then
	test = true
	else
	test = false
	end
    if inst.components.childspawner ~= nil and not test and target ~= nil then
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

    if inst._rerolltask == nil then
        inst._rerolltask = inst:DoPeriodicTask(TUNING.TOTAL_DAY_TIME*5, RerollCocoons, 0, inst)
    end

    return inst
end

return Prefab("widowweb", fn, assets, prefabs)
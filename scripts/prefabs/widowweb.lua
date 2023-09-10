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
	
    if widowweb ~= nil--[[Just to prevent a crash if it was deleted.]] and widowweb.components.childspawner:IsFull() then
        for k, v in ipairs(existing_cocoons) do
            v:Remove()
        end
		
        SpawnCocoon(inst)
    end
end

local function OnKilled(inst)
    inst.components.timer:StartTimer("regen_widow", TUNING.DRAGONFLY_RESPAWN_TIME)
    if inst.components.timer:TimerExists("reroll_cocoons") then
        inst.components.timer:StopTimer("reroll_cocoons")
    end
end

local function GenerateNewWidow(inst)
    inst.components.childspawner:AddChildrenInside(1)
    --inst.components.childspawner:StartSpawning()
    if not inst.components.timer:TimerExists("reroll_cocoons") then
        inst.components.timer:StartTimer("reroll_cocoons", TUNING.TOTAL_DAY_TIME*5)
    end
end

local function ontimerdone(inst, data)
    if data.name == "regen_widow" then
        GenerateNewWidow(inst)
    end
    if data.name == "reroll_cocoons" then
        RerollCocoons(inst)
        if not inst.components.timer:TimerExists("reroll_cocoons") then
            inst.components.timer:StartTimer("reroll_cocoons", TUNING.TOTAL_DAY_TIME*5)
        end
    end
end

local function SpawnInvestigators(inst, target)
	local x, y, z = inst.Transform:GetWorldPosition()
    if inst.components.childspawner and target then
        local spider = inst.components.childspawner:SpawnChild()
        if spider then
			local x,y,z = inst.Transform:GetWorldPosition()
            spider.sg:GoToState("fall")
			spider.suggesttarget = target
			spider:DoTaskInTime(0.5,function(spider) spider.components.combat:SuggestTarget(spider.suggesttarget) end)
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

    if not inst.components.timer:TimerExists("reroll_cocoons") then
        inst.components.timer:StartTimer("reroll_cocoons", TUNING.TOTAL_DAY_TIME*5)
    end


    return inst
end

return Prefab("widowweb", fn, assets, prefabs)
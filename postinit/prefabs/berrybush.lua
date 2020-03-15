local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function SpawnDiseasePuff(inst)
    SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_common(inst, worker, numberries)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()
        local diseased = inst.components.diseaseable ~= nil and inst.components.diseaseable:IsDiseased()

        if diseased then
            SpawnDiseasePuff(inst)
        elseif inst.components.diseaseable ~= nil and inst.components.diseaseable:IsBecomingDiseased() then
            SpawnDiseasePuff(inst)
            if worker ~= nil then
                worker:PushEvent("digdiseasing")
            end
        end

        if withered or inst.components.pickable:IsBarren() then
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then
                local pt = inst:GetPosition()
                pt.y = pt.y + (inst.components.pickable.dropheight or 0)
                for i = 1, numberries do
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, pt)
                end
            end
            if diseased then
                inst.components.lootdropper:SpawnLootPrefab("twigs")
                inst.components.lootdropper:SpawnLootPrefab("twigs")
            elseif math.random() <= 0.1 then
                inst.components.lootdropper:SpawnLootPrefab("bushcrab")
			else
                inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
            end
        end
    end
    inst:Remove()
end

local function dig_up_normal(inst, worker)
    dig_up_common(inst, worker, 1)
end

env.AddPrefabPostInit("berrybush", function(inst)

	if not TheWorld.ismastersim then
		return
	end

	if inst.components.workable ~= nil then
        inst.components.workable:SetOnFinishCallback(dig_up_normal)
    end

end)

local function OnWinter(inst)
    if TheWorld.state.iswinter then
		inst.components.childspawner:StopSpawning()
    else
		inst.components.childspawner:StartSpawning()
    end
end

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function OnIsDay(inst, isday)
    if isday ~= inst.dayspawn then
        inst.components.childspawner:StopSpawning()
        ReturnChildren(inst)
    elseif not TheWorld.state.iswinter then
        inst.components.childspawner:StartSpawning()
    end
end

local function OnInit(inst)
    inst.task = nil
    inst:WatchWorldState("isday", OnIsDay)
    inst:WatchWorldState("seasontick", OnWinter)
    OnIsDay(inst, TheWorld.state.isday)
    OnWinter(inst)
end

env.AddPrefabPostInit("berrybush_juicy", function(inst)

	if not TheWorld.ismastersim then
		return
	end

	inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "mosquito"
    inst.components.childspawner:SetRegenPeriod(TUNING.POND_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.POND_SPAWN_TIME)
    inst.components.childspawner:SetMaxChildren(math.random(0,1))
    inst.components.childspawner:StartRegen()
    inst.dayspawn = false
	
    inst.task = inst:DoTaskInTime(0, OnInit)

end)
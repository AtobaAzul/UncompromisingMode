SetSharedLootTable('trapdoor',
                   {{'rocks', 1.00}, {'rocks', 1.00}, {'rocks', 1.00}})

local function onnear(inst, target)
    if inst.components.childspawner ~= nil then
        if not TheWorld.state.iswinter then
            if target:HasTag("spiderwhisperer") or
                target:HasTag("spiderdisguise") then
                inst.components.childspawner:ReleaseAllChildren(nil,
                                                                "spider_trapdoor")
            else
                inst.components.childspawner:ReleaseAllChildren(target,
                                                                "spider_trapdoor")
            end
        end
    end
end

local function OnHaunt(inst)
    if inst.components.childspawner == nil or
        not inst.components.childspawner:CanSpawn() or math.random() >
        TUNING.HAUNT_CHANCE_HALF then return false end

    local target = FindEntity(inst, 25, function(guy)
        if inst.components.combat ~= nil then
            return inst.components.combat:CanTarget(guy)
        end
    end, {"_combat"}, -- See entityreplica.lua (re: "_combat" tag)
    {"insect", "playerghost", "INLIMBO"}, {"character", "animal", "monster"})

    if target ~= nil then
        -- onhitbyplayer(inst, target)
        return true
    end
    return false
end

local function OpenMound(inst)
    inst.AnimState:PlayAnimation("idle_flipped")
    inst.AnimState:PushAnimation("flip_close")
    inst.AnimState:PushAnimation("idle")
end

local function CloseMound(inst)
    inst.AnimState:PlayAnimation("idle_flipped")
    inst.AnimState:PushAnimation("flip_close")
    inst.AnimState:PushAnimation("idle")
end

local function amempty(inst)
    return inst.components.childspawner ~= nil and
               inst.components.childspawner.maxchildren == 0 and
               not inst:HasTag("obvious")
end

local function OldFindNewHole(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local range = 30
    local ents = TheSim:FindEntities(x, y, z, range, nil, {"trapdoor"})
    if #ents > 0 then
        for i, v in ipairs(ents) do
            local randomtest = math.random()
            if randomtest >= 0.5 then
                if v.components.childspawner ~= nil and
                    v.components.childspawner.regening == false then
                    inst.components.childspawner:StopRegen()
                    inst.components.childspawner:SetMaxChildren(0)
                    v.components.childspawner:StartRegen()
                    v.components.childspawner:SetMaxChildren(1)
                    return
                end
            end
        end
    end
end

local function unempty(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:SetMaxChildren(1)
    end
end

local function FindNewHole(inst)
    local target = FindEntity(inst, 3 * TUNING.LEIF_MAXSPAWNDIST, amempty,
                              {"trapdoor"})
    if target ~= nil then
        if inst.components.childspawner ~= nil then
            target:DoTaskInTime(480 + math.random() * 3, unempty) -- <-- This is where the regen time is actually located, since it swaps nests
            inst.components.childspawner:StopRegen()
            inst.components.childspawner:SetMaxChildren(0)
            inst:AddTag("obvious")
            inst:DoTaskInTime(90000, inst:RemoveTag("obvious"))
        end
    end
end

local function workcallback(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        local grass = FindEntity(inst, 0.5, nil, "trapdoorgrass")
        if grass ~= nil and grass.components.workable ~= nil then
            grass.components.workable:WorkedBy(worker)
        end
        inst:Remove()
    end
end

local function Init(inst)
    if TUNING.DSTU.TRAPDOORSPIDERS == false then inst:Remove() end

    local x, y, z = inst.Transform:GetWorldPosition()

    if #TheSim:FindEntities(x, 0, z, 1, {"trapdoorgrass"}) > 0 then
        inst:AddTag("event_trigger") -- for retrofitting
    end
end

local function SummonChildren(inst)
    if inst.components.childspawner ~= nil then

        inst.components.childspawner:ReleaseAllChildren(nil, "spider_trapdoor")

        inst:AddTag("trapdooreviction")

        if inst.vacancytask ~= nil then
            inst.vacancytask:Cancel()
            inst.vacancytask = nil
        end

        inst.vacancytask = inst:DoTaskInTime(8, function(inst)
            inst:RemoveTag("trapdooreviction")
        end)
    end
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("trapdoor")
    inst.AnimState:SetBuild("trapdoor")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("trapdoor")
    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    -------------------------
    -------------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childspawner = "spider_trapdoor"
    inst.components.childspawner:SetMaxChildren(0)
    inst.components.childspawner:SetEmergencyRadius(
        TUNING.WASPHIVE_EMERGENCY_RADIUS / 2)
    inst.components.childspawner:SetSpawnedFn(OpenMound)
    inst.components.childspawner:SetGoHomeFn(CloseMound)
    inst.components.childspawner:SetRegenPeriod(20, 2)
    inst.components.childspawner:SetOnChildKilledFn(FindNewHole)
    local startrandomtest = math.random()
    inst.components.childspawner:StopRegen()
    if startrandomtest >= 0.75 then
        inst.components.childspawner:SetMaxChildren(1)
        inst.components.childspawner:StartRegen()
    end
    -------------------------
    -------------------------
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 8) -- set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(
        inst.components.playerprox.AliveModes.AliveOnly)
    -------------------------
    MakeSnowCovered(inst)
    -------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_MEDIUM)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    if inst.components.trapdoor == nil then inst:AddComponent("lootdropper") end

    inst.components.lootdropper:SetChanceLootTable('trapdoor')

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)

    inst.components.workable:SetOnWorkCallback(workcallback)

    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.SummonChildren = SummonChildren

    inst:DoTaskInTime(0, Init)
    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("flipping_rock")
    inst.AnimState:SetBuild("rock_flipping_moss")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("hive")
    inst:AddTag("WORM_DANGER")
    inst:AddTag("trapdoor")
    -- inst:AddTag("CLASSIFIED")
    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end
    -- inst.entity:SetTint(1,1,1,1)
    -------------------------
    -- inst:AddComponent("health")
    -- inst.components.health:SetMaxHealth(250) --increase health?
    -------------------------
    if TUNING.DSTU.TRAPDOORSPIDERS then
        inst:AddComponent("childspawner")
        -- Set spawner to wasp. Change tuning values to wasp values.
        inst.components.childspawner.childspawner = "spider_trapdoor"
        inst.components.childspawner:SetMaxChildren(0)
        inst.components.childspawner:SetEmergencyRadius(
            TUNING.WASPHIVE_EMERGENCY_RADIUS / 2)
        inst.components.childspawner:SetSpawnedFn(OpenMound)
        inst.components.childspawner:SetGoHomeFn(CloseMound)
        inst.components.childspawner:SetRegenPeriod(20, 2)
        inst.components.childspawner:SetOnChildKilledFn(FindNewHole)
        local startrandomtest = math.random()
        inst.components.childspawner:StopRegen()
        if startrandomtest >= 0.75 then
            inst.components.childspawner:SetMaxChildren(1)
            inst.components.childspawner:StartRegen()
        end

        -------------------------
        -------------------------
        inst:AddComponent("playerprox")
        inst.components.playerprox:SetDist(6, 8) -- set specific values
        inst.components.playerprox:SetOnPlayerNear(onnear)
        inst.components.playerprox:SetPlayerAliveMode(
            inst.components.playerprox.AliveModes.AliveOnly)
    end
    -------------------------
    -- inst:AddComponent("combat")
    -- wasp hive should trigger on proximity, release wasps.
    -- inst.components.combat:SetOnHit(onhitbyplayer)
    -- inst:ListenForEvent("death", OnKilled)
    -------------------------

    MakeSnowCovered(inst)
    -------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_MEDIUM)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    if inst.components.trapdoor == nil then inst:AddComponent("lootdropper") end

    inst.components.lootdropper:SetChanceLootTable('trapdoor')

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)

    inst.components.workable:SetOnWorkCallback(workcallback)
    --[[if not inst:HasTag("finishedgrass") then
		inst:DoTaskInTime(0, function(inst)
		-- Spawn Trapdoor Grass
		local x, y, z = inst.Transform:GetWorldPosition()
		local grasschance = math.random()
			if grasschance > 0.25 then
			local grassycover = SpawnPrefab("trapdoorgrass")
			grassycover.Transform:SetPosition(x, y, z)
			--inst:AddChild(grassycover)
			end
			inst:AddTag("finishedgrass")
		end)
	end]]
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst.SummonChildren = SummonChildren
    -- inst.AnimState:SetSortOrder(1)

    MakeMediumPropagator(inst)
    inst:DoTaskInTime(0, Init)

    return inst
end

return Prefab("trapdoor", fn1), Prefab("hoodedtrapdoor", fn2)

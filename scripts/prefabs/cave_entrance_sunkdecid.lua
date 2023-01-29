local function close(inst)
    inst.AnimState:PlayAnimation("no_access", true)
end

local function open(inst)
    inst.AnimState:PlayAnimation("open", true)
end

local function full(inst)
    inst.AnimState:PlayAnimation("over_capacity", true)
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
    if isday then
        inst.components.childspawner:StartRegen()
        inst.components.childspawner:StopSpawning()
        ReturnChildren(inst)
    else
        inst.components.childspawner:StopRegen()
        inst.components.childspawner:StartSpawning()
    end
end

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        local pt = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
        inst.components.lootdropper:DropLoot(pt)
        ProfileStatsSet("cave_entrance_opened", true)
        if worker ~= nil then
	        AwardPlayerAchievement("cave_entrance_opened", worker)
	    end
        local openinst = SpawnPrefab("cave_entrance_open_sunkdecid")
        openinst.Transform:SetPosition(pt:Get())
        openinst.components.worldmigrator.id = inst.components.worldmigrator.id
        openinst.components.worldmigrator.linkedWorld = inst.components.worldmigrator.linkedWorld
        openinst.components.worldmigrator.receivedPortal = inst.components.worldmigrator.receivedPortal
        inst:Remove()
    else
        inst.AnimState:PlayAnimation(
            (workleft < TUNING.ROCKS_MINE / 3 and "low") or
            (workleft < TUNING.ROCKS_MINE * 2 / 3 and "med") or
            "idle_closed"
        )
    end
end

local function GetStatus(inst)
    return (inst.components.worldmigrator:IsActive() and "OPEN")
        or (inst.components.worldmigrator:IsFull() and "FULL")
        or nil
end

local function canspawn(inst)
    return inst.components.worldmigrator:IsActive() or inst.components.worldmigrator:IsFull()
end

local function activatebyother(inst)
    OnWork(inst, nil, 0)
end

local function fn(bank, build, anim, minimap, isbackground)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon(minimap)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)
    if isbackground then
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
    end

    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0,0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("worldmigrator")

    return inst
end

local function closed_fn()
    local inst = fn("cave_entrance", "cave_entrance", "idle_closed", "cave_closed.png", false)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)

    inst.components.worldmigrator:SetEnabled(false)
	inst.components.worldmigrator:SetID(777)
    inst:ListenForEvent("migration_activate_other", activatebyother)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rocks", "rocks", "flint", "flint", "flint" })

    return inst
end

local function open_fn()
    local inst = fn("cave_entrance", "cave_entrance", "no_access", "cave_open.png", true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(60)
    inst.components.childspawner:SetSpawnPeriod(.1)
    inst.components.childspawner:SetMaxChildren(6)
    inst.components.childspawner.canspawnfn = canspawn
    inst.components.childspawner.childname = "bat"

    inst.components.inspectable.getstatus = GetStatus

    inst:ListenForEvent("migration_available", open)
    inst:ListenForEvent("migration_unavailable", close)
    inst:ListenForEvent("migration_full", full)
    --inst:ListenForEvent("migration_activate", activate)

    --Cave entrance is an overworld entity, so it
    --should be aware of phase and not cavephase.
    --Actually, it could make sense either way...
    --Alternative: -add "cavedweller" tag
    --             -watch iscaveday world state
    OnIsDay(inst, TheWorld.state.isday)
    inst:WatchWorldState("isday", OnIsDay)

    return inst
end

return Prefab("cave_entrance_sunkdecid", closed_fn),
    Prefab("cave_entrance_open_sunkdecid", open_fn)

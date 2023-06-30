local terraformer_assets =
{
    Asset("ANIM", "anim/groundcrystal_growth.zip"),
}

local terraformer_prefabs =
{
    "um_waterfall_terraformer_visual",
}

--------------------------------------------------------------------------------
local TERRAFORM_INDEX_TEMPLATE = "%d %d"

local function _TerraformTile(inst, tx, ty)
    local index = string.format(TERRAFORM_INDEX_TEMPLATE, tx, ty)
    inst._terraform_tasks[index] = nil

    local _map = TheWorld.Map
    local current_tile = _map:GetTile(tx, ty)
    if TileGroupManager:IsLandTile(current_tile) and current_tile ~= WORLD_TILES.UM_FLOODWATER then
        local _undertile_cmp = TheWorld.components.undertile
        local current_undertile = _undertile_cmp:GetTileUnderneath(tx, ty)

        _map:SetTile(tx, ty, WORLD_TILES.UM_FLOODWATER)

        -- farming_manager.lua will clear this if we do it before the SetTile call.
        if _undertile_cmp then
            -- If the undertile component already has an entry at this location,
            -- we'll just keep that instead of over-writing with the current one.
            -- This plays a bit better with farm plots.
            _undertile_cmp:SetTileUnderneath(tx, ty, current_undertile or current_tile)
        end
    end
end

local function _RevertTile(inst, tx, ty)
    local index = string.format(TERRAFORM_INDEX_TEMPLATE, tx, ty)
    inst._terraform_tasks[index] = nil

    -- First, reset the tile.
    local _map = TheWorld.Map
    local _undertile_cmp = TheWorld.components.undertile
    local old_tile = WORLD_TILES.DIRT
    if _undertile_cmp then
        old_tile = _undertile_cmp:GetTileUnderneath(tx, ty) or old_tile
        _undertile_cmp:ClearTileUnderneath(tx, ty)
    end
    _map:SetTile(tx, ty, old_tile)
	
    local tcx, tcy, tcz = _map:GetTileCenterPoint(tx, ty)

    local explosion_cover = SpawnPrefab("ocean_splash_med1")
    explosion_cover.Transform:SetPosition(tcx, tcy, tcz)
end

local function terraformer_addtask(inst, tx, ty, time, facing, is_revert)
    local index = string.format(TERRAFORM_INDEX_TEMPLATE, tx, ty)

    local current_task_data = inst._terraform_tasks[index]
    if current_task_data then
        if current_task_data.task then
            current_task_data.task:Cancel()
        end
    end

    local _map = TheWorld.Map
    local tile = _map:GetTile(tx, ty)
    local tile_is_rift = (tile == WORLD_TILES.UM_FLOODWATER)
    if (is_revert and tile_is_rift)
            or (not is_revert and TileGroupManager:IsLandTile(tile) and not tile_is_rift) then

        local _TaskFunction = (is_revert and _RevertTile) or _TerraformTile
        inst._terraform_tasks[index] = {
            tx = tx, ty = ty,
            is_revert = is_revert,
            endtime = GetTime() + time,
            facing = facing,
            task = inst:DoTaskInTime(time, _TaskFunction, tx, ty),
        }
    end
end

local function terraformer_remainingtasktimefortile(inst, tx, ty)
    local tile_data = inst._terraform_tasks[string.format(TERRAFORM_INDEX_TEMPLATE, tx, ty)]
    return (tile_data and (tile_data.endtime - GetTime())) or 0
end

------------------------------------------------------------------
local function terraformer_forcefinishterraform(inst)
    for index, task_data in pairs(inst._terraform_tasks) do
        if task_data.task then
            task_data.task:Cancel()
            task_data.task = nil
        end
        ((task_data.is_revert and _RevertTile) or _TerraformTile)(inst, task_data.tx, task_data.ty)
    end
end

------------------------------------------------------------------
local function on_terraformer_save(inst, data)
    for task_index, task_data in pairs(inst._terraform_tasks) do
        data.terraform_tasks = data.terraform_tasks or {}
        table.insert(data.terraform_tasks, {
            tx = task_data.tx,
            ty = task_data.ty,
            facing = task_data.facing,
            is_revert = task_data.is_revert,
            time = task_data.endtime - GetTime()
        })
    end
end

local function on_terraformer_load(inst, data)
    if data then
        if data.terraform_tasks then
            for _, task_data in ipairs(data.terraform_tasks) do
                terraformer_addtask(inst,
                    task_data.tx,
                    task_data.ty,
                    task_data.time,
                    task_data.facing,
                    task_data.is_revert
                )
            end
        end
    end
end

local function on_terraformer_longupdate(inst, delta_time)
    if inst._terraform_tasks then
        for task_index, task_data in pairs(inst._terraform_tasks) do
            local time_remaining = GetTaskRemaining(task_data.task)
            task_data.task:Cancel()
            task_data.task = inst:DoTaskInTime(
                math.max(FRAMES, time_remaining - delta_time),
                (task_data.is_revert and _RevertTile) or _TerraformTile,
                task_data.tx, task_data.ty
            )
        end
    end
end

------------------------------------------------------------------
local function terraformerfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("birdblocker")
    inst:AddTag("FX")
    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("NOBLOCK")
    inst:AddTag("scarytoprey")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst._terraform_tasks = {}

    --
    inst.AddTerraformTask = terraformer_addtask
    inst.TaskTimeForTile = terraformer_remainingtasktimefortile

    --
    inst:ListenForEvent("forcefinishterraforming", terraformer_forcefinishterraform)

    --
    inst.OnSave = on_terraformer_save
    inst.OnLoad = on_terraformer_load
    inst.OnLongUpdate = on_terraformer_longupdate

    return inst
end

return Prefab("um_waterfall_terraformer", terraformerfn, terraformer_assets, terraformer_prefabs)
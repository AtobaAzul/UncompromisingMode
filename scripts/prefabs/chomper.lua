require "prefabutil" -- for the MakePlacer function

local assets =
{
    Asset("ANIM", "anim/star_trap.zip"),
    Asset("MINIMAP_IMAGE", "star_trap"),
}

local prefabs =
{
}

local function on_anim_over(inst)
    if inst.components.mine.issprung then
        return
    end
    --inst.AnimState:PushAnimation("idle_2")
    inst.AnimState:PushAnimation("open_loop", true)
end

-- Copied from mine.lua to emulate its mine test.
local mine_test_fn = function(target, inst)
    return not (target.components.health ~= nil and target.components.health:IsDead())
            and (target.components.combat ~= nil and target.components.combat:CanBeAttacked(inst))
end
local mine_test_tags = { "monster", "character", "animal" }
local mine_must_tags = { "_combat" }
local mine_no_tags = { "notraptrigger", "flying", "ghost", "playerghost" }

local function do_snap(inst)
    -- We're going off whether we hit somebody or not, so play the trap sound.
    inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/trap")

    -- Do an AOE attack, based on how the combat component does it.
    local x, y, z = inst.Transform:GetWorldPosition()
    local target_ents = TheSim:FindEntities(x, y, z, TUNING.STARFISH_TRAP_RADIUS, mine_must_tags, mine_no_tags, mine_test_tags)
    for i, target in ipairs(target_ents) do
        if target ~= inst and target.entity:IsVisible() and mine_test_fn(target, inst) then
            target.components.combat:GetAttacked(inst, TUNING.STARFISH_TRAP_DAMAGE)
        end
    end

    if inst._snap_task ~= nil then
        inst._snap_task:Cancel()
        inst._snap_task = nil
    end
end

local function reset(inst)
    inst.components.mine:Reset()
end

local function start_reset_task(inst)
    if inst._reset_task ~= nil then
        inst._reset_task:Cancel()
    end
    local reset_task_randomized_time = GetRandomWithVariance(TUNING.STARFISH_TRAP_NOTDAY_RESET.BASE, TUNING.STARFISH_TRAP_NOTDAY_RESET.VARIANCE)
    inst._reset_task = inst:DoTaskInTime(reset_task_randomized_time, reset)
    inst._reset_task_end_time = GetTime() + reset_task_randomized_time
end

local function on_explode(inst, target)
    inst.AnimState:PlayAnimation("open_pst")
    inst.AnimState:PushAnimation("idle_loop", true)

    inst:RemoveEventCallback("animover", on_anim_over)

    if target ~= nil and inst._snap_task == nil then
        local frames_until_anim_snap = 8
        inst._snap_task = inst:DoTaskInTime(frames_until_anim_snap * FRAMES, do_snap)
    end

    start_reset_task(inst)
end

local function on_reset(inst)
    inst:ListenForEvent("animover", on_anim_over)

    if inst.AnimState:IsCurrentAnimation("idle_loop") then
        inst.AnimState:PlayAnimation("open_pre")
        --- scott this one is playing as expected
        inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("open_loop", true)
    end
end

local function on_sprung(inst)
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:RemoveEventCallback("animover", on_anim_over)

    start_reset_task(inst)
end

local function on_deactivate(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SpawnLootPrefab("dug_trap_starfish")
    end

    inst:Remove()
end

local function get_status(inst)
    return (inst.components.mine.issprung and "CLOSED") or nil
end


local function calculate_mine_test_time()
    return TUNING.STARFISH_TRAP_TIMING.BASE + (math.random() * TUNING.STARFISH_TRAP_TIMING.VARIANCE)
end

local function on_save(inst, data)
    -- If we have an unfinished reset task and its projected end time is past our save time,
    -- save out that end time so we can restart from where we saved on load.
    if inst._reset_task ~= nil then
        local remaining_task_time = inst._reset_task_end_time - GetTime()
        if remaining_task_time >= 0 then
            data.reset_task_time_remaining = remaining_task_time
        end
    end
end

local function on_load(inst, data)
    if data ~= nil and data.reset_task_time_remaining ~= nil then
        -- If we saved out a reset time, we should cancel the task the mine component's load started
        -- and start a new one with the remaining time.
        if inst._reset_task ~= nil then
            inst._reset_task:Cancel()
        end

        inst._reset_task = inst:DoTaskInTime(data.reset_task_time_remaining, reset)
        inst._reset_task_end_time = GetTime() + data.reset_task_time_remaining
    end
end

local function trap_starfish()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("star_trap.png")

    inst.AnimState:SetBank("chomper")
    inst.AnimState:SetBuild("chomper")
    inst.AnimState:PlayAnimation("open_loop", true)

    inst:AddTag("trap")
    inst:AddTag("trapdamage")
    inst:AddTag("birdblocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = get_status

    inst:AddComponent("hauntable")
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY

    inst:AddComponent("mine")
    inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS)
    inst.components.mine:SetAlignment(nil) -- starfish trigger on EVERYTHING on the ground, players and non-players alike.
    inst.components.mine:SetOnExplodeFn(on_explode)
    inst.components.mine:SetOnResetFn(on_reset)
    inst.components.mine:SetOnSprungFn(on_sprung)
    inst.components.mine:SetOnDeactivateFn(on_deactivate)
    inst.components.mine:SetTestTimeFn(calculate_mine_test_time)
    inst.components.mine:SetReusable(false)
    reset(inst)

    -- Stop the starfish from idling in unison.
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    -- Start the task for the characterizing additional idles.
    inst:ListenForEvent("animover", on_anim_over)

    inst.OnSave = on_save
    inst.OnLoad = on_load

    return inst
end

return Prefab("chomper", trap_starfish, assets, prefabs)

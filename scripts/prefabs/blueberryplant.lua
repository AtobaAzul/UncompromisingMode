require "prefabutil" -- for the MakePlacer function


local function on_anim_over(inst)
    if inst.components.mine.issprung then
        return
    end

	if inst.froze == true then
	if inst.Harvestable == true then
	inst.AnimState:PushAnimation("idle_frozen", true)
	else
	inst.AnimState:PushAnimation("trap_idle", true)
	end
	else
    local random_value = math.random()
    if random_value < 0.4 then
        inst.AnimState:PushAnimation("idle_2")
        -- inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)


    elseif random_value < 0.8 then
        inst.AnimState:PushAnimation("idle_3")
        -- inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)
    end
	end

	
end

-- Copied from mine.lua to emulate its mine test.
local mine_test_fn = function(target, inst)
    return not (target.components.health ~= nil and target.components.health:IsDead())
            and (target.components.combat ~= nil and target.components.combat:CanBeAttacked(inst))
end
local mine_test_tags = { "monster", "character", "animal" }
local mine_must_tags = { "_combat" }
local mine_no_tags = { "notraptrigger", "flying", "ghost", "playerghost", "snapdragon" }

local function do_snap(inst)
    -- We're going off whether we hit somebody or not, so play the trap sound.
	if inst.Harvestable == true then
    inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/trap")

    -- Do an AOE attack, based on how the combat component does it.
    local x, y, z = inst.Transform:GetWorldPosition()
    local target_ents = TheSim:FindEntities(x, y, z, 1.1*TUNING.STARFISH_TRAP_RADIUS, mine_must_tags, mine_no_tags, mine_test_tags)
    for i, target in ipairs(target_ents) do
        if target ~= inst and target.entity:IsVisible() and mine_test_fn(target, inst) then
            target.components.combat:GetAttacked(inst, TUNING.STARFISH_TRAP_DAMAGE)
        end
    end
	local otherbombs = TheSim:FindEntities(x, y, z, 3*TUNING.STARFISH_TRAP_RADIUS, {"blueberrybomb"}, mine_no_tags)
    for i, target in ipairs(otherbombs) do
        if target ~= inst and target.components.mine and not target.components.mine.issprung and not target.froze == true then
		target.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*12)
        end
    end
	inst.Harvestable = false
	end
    if inst._snap_task ~= nil then
        inst._snap_task:Cancel()
        inst._snap_task = nil
    end
end

local function Regrow(inst)
inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*1.1)
    inst.components.mine:Reset()
	inst.Harvestable = true
end
local function CheckTimeRegrow(inst)
if TheWorld.state.iswinter then
inst.pendingregrow = true
else
Regrow(inst)
end
end
local function start_reset_task(inst)
	inst.components.timer:StartTimer("regrow", 3840)
end

local function on_explode(inst, target)
    inst.AnimState:PlayAnimation("trap")
    inst.AnimState:PushAnimation("trap_idle", true)
	inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*1.1) --Gotta Reset
    inst:RemoveEventCallback("animover", on_anim_over)

    if target ~= nil and inst._snap_task == nil then
        local frames_until_anim_snap = 40
        inst._snap_task = inst:DoTaskInTime(frames_until_anim_snap * FRAMES, do_snap)
    end

    start_reset_task(inst)
end

local function on_reset(inst)
    inst:ListenForEvent("animover", on_anim_over)

    --if inst.AnimState:IsCurrentAnimation("trap_idle") then
        inst.AnimState:PlayAnimation("reset")
        --- scott this one is playing as expected
        inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
        inst.AnimState:PushAnimation("idle", true)
    --end
end

local function on_sprung(inst)
    inst.AnimState:PlayAnimation("trap_idle", true)
	inst.AnimState:PushAnimation("trap_idle", true)
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:RemoveEventCallback("animover", on_anim_over)

    start_reset_task(inst)
end

local function on_deactivate(inst)
    if inst.components.lootdropper ~= nil then
		if inst.Harvestable == true then

		inst.components.lootdropper:SpawnLootPrefab("giant_blueberry")
		end	

    end

    if inst.Harvestable == false then
	inst:Remove()
	else
	inst.components.workable:SetWorkLeft(1)
	inst.Harvestable = false
	end
end

local function get_status(inst)
    return (inst.components.mine.issprung and "REGROWING") or (inst.froze == true and "FROZE") or "READY"
end

local function on_blueberry_dug_up(inst, digger)
	if digger:HasTag("player") then
	inst.AnimState:PlayAnimation("dig")
	inst.AnimState:PushAnimation("trap_idle")

    on_deactivate(inst)
	else
	inst.components.workable:SetWorkLeft(1)
	end
end

local function calculate_mine_test_time()
    return TUNING.STARFISH_TRAP_TIMING.BASE + (math.random() * TUNING.STARFISH_TRAP_TIMING.VARIANCE) --This will be the "regrow" period of the blueberry, will extend it to be much longer.
end

local function on_save(inst, data)
    if inst._reset_task ~= nil then
        local remaining_task_time = inst._reset_task_end_time - GetTime()
        if remaining_task_time >= 0 then
            data.reset_task_time_remaining = remaining_task_time
        end
    end
	data.froze = inst.froze
	data.Harvestable = inst.Harvestable
	data.pendingregrow = inst.pendingregrow
end

local function on_blueberry_mine(inst)
inst.components.lootdropper:SpawnLootPrefab("ice")
local x,y,z = inst.Transform:GetWorldPosition()
local players = TheSim:FindEntities(x,y,z,1.5,{"player"},{"ghost"})
for i, v in ipairs(players) do
if v.components.moisture ~= nil then
v.components.moisture:DoDelta(5)
end
end

inst.Harvestable = false
inst.components.workable:SetWorkAction(ACTIONS.DIG)
inst.components.workable:SetWorkLeft(1)
inst.components.workable:SetOnFinishCallback(on_blueberry_dug_up)
start_reset_task(inst)
inst.AnimState:PlayAnimation("mine")
end

local function MakeWinter(inst)
inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*0)
if inst.Harvestable == true then
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(on_blueberry_mine)
    inst.components.workable:SetWorkable(true)
else
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(on_blueberry_dug_up)
    inst.components.workable:SetWorkable(true)
end
end

local function MakeNotWinter(inst)
inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*1.1)
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(on_blueberry_dug_up)
    inst.components.workable:SetWorkable(true)
end

local function on_load(inst, data)
    if data ~= nil and data.reset_task_time_remaining ~= nil then
        if inst._reset_task ~= nil then
            inst._reset_task:Cancel()
        end
	inst.Harvestable = data.Harvestable
        inst._reset_task = inst:DoTaskInTime(data.reset_task_time_remaining, reset)
        inst._reset_task_end_time = GetTime() + data.reset_task_time_remaining
	inst.pendingregrow = data.pendingregrow
    end
	if TheWorld.state.iswinter then
	inst.froze = true
	MakeWinter(inst)
	else
	inst.froze = false
	MakeNotWinter(inst)
	end
end

local function Melt(inst)
MakeNotWinter(inst)
inst.AnimState:PlayAnimation("melt")
inst.froze = false
end
local function OnSpring(inst)
if inst.pendingregrow == true or (inst.Harvestable == false and not inst.components.timer:TimerExists("regrow"))then
Regrow(inst)
inst.froze = false
end
if inst.Harvestable == true and inst.froze == true then
inst:DoTaskInTime(3+math.random(0,15), Melt)
end
end

local function Freeze(inst)
if TheWorld.state.iswinter then
MakeWinter(inst)
if inst.Harvestable == true then
inst.AnimState:PlayAnimation("freeze")
inst.froze = true
end
else
inst.froze = false
end
end

local function OnWinter(inst)
if inst.froze ~= true then
inst:DoTaskInTime(3+math.random(0,15), Freeze)
end
end
local function blueberryplant()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("blueberryplant_map.tex")

    inst.AnimState:SetBank("blueberryplant")
    inst.AnimState:SetBuild("blueberryplant")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("trap")
	inst:AddTag("blueberrybomb")
    inst:AddTag("trapdamage")
    inst:AddTag("birdblocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "BLUEBERRYPLANT"
    inst.components.inspectable.getstatus = get_status

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(on_blueberry_dug_up)
    inst.components.workable:SetWorkable(true)

    inst:AddComponent("hauntable")
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY

    inst:AddComponent("mine")
    inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*1.1)
    inst.components.mine:SetAlignment(nil) -- blueberries trigger on EVERYTHING on the ground, players and non-players alike.
    inst.components.mine:SetOnExplodeFn(on_explode)
    inst.components.mine:SetOnResetFn(on_reset)
    inst.components.mine:SetOnSprungFn(on_sprung)
    inst.components.mine:SetOnDeactivateFn(on_deactivate)
    inst.components.mine:SetTestTimeFn(calculate_mine_test_time)
    inst.components.mine:SetReusable(false)
    Regrow(inst)
    -- Stop the blueberries from idling in unison.
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", CheckTimeRegrow)
    -- Start the task for the characterizing additional idles.
    inst:ListenForEvent("animover", on_anim_over)
	inst.Harvestable = true
    inst.OnSave = on_save
    inst.OnLoad = on_load
	inst.pendingregrow = false
	inst:WatchWorldState("isspring", OnSpring)
	inst:WatchWorldState("isautumn", OnSpring) --Include other seasons incase someone is weird and disables spring for reasons unknown?
	inst:WatchWorldState("issummer", OnSpring)
	inst:WatchWorldState("iswinter", OnWinter)
    return inst
end

local function on_deploy(inst, position, deployer)
    local new_trap_starfish = SpawnPrefab("blueberryplant")
    if new_trap_starfish ~= nil then
        -- Dropped and deployed starfish traps shouldn't spawn in a reset state (or they'll bite the deployer).
        new_trap_starfish.AnimState:PlayAnimation("trap_idle")
        new_trap_starfish.components.mine:Spring()

        new_trap_starfish.Transform:SetPosition(position:Get())
        new_trap_starfish.SoundEmitter:PlaySound("dontstarve/common/plant")

        inst:Remove()
    end
end

local function blueberryflower()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueberryplant")
    inst.AnimState:SetBuild("blueberryplant")
    inst.AnimState:PlayAnimation("inactive", true)

    MakeInventoryFloatable(inst, "med")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- Stop the starfish from idling in unison.
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "blueberryflower"

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:InheritMoisture(100, true)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = on_deploy

    return inst
end

return Prefab("blueberryplant", blueberryplant),
Prefab("blueberryflower", blueberryflower),
MakePlacer("blueberryflower_placer", "star_trap", "star_trap", "trap_idle")

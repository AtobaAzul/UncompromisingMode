require "prefabutil" -- for the MakePlacer function

local assets = {
	Asset("ANIM", "anim/um_goo_blue.zip"),
}

local function FxAppear(inst)
	SpawnPrefab("blueberryexplosion").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("blueberrypuddle").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local mine_test_tags = { "monster", "character", "animal" }
local mine_must_tags = { "_combat" }
local mine_no_tags = { "notraptrigger", "flying", "ghost", "playerghost", "snapdragon" }

local function on_deactivate(inst)
    if inst.components.lootdropper ~= nil then
        if inst.Harvestable == "full" then
            if math.random() > 0.1 then
                inst.components.lootdropper:SpawnLootPrefab("giant_blueberry")
				local x, y, z = inst.Transform:GetWorldPosition()
				local otherbombs = TheSim:FindEntities(x, y, z, 1.1*TUNING.STARFISH_TRAP_RADIUS, {"blueberrybomb"}, mine_no_tags)
					for i, target in ipairs(otherbombs) do
                if target ~= inst and target.components.mine and not target.components.mine.issprung and not target.froze then
                    target.components.mine:Explode(target)
                end
            end				
            else
                local berryman = SpawnPrefab("fruitbat")
                berryman.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end    
    end
    if inst.Harvestable == "regrow" then
        inst:Remove()
    else
        inst.components.workable:SetWorkLeft(1)
        inst.Harvestable = "regrow"
    end
end

local function on_blueberry_dug_up(inst, digger)
	if digger:HasTag("player") then
		if inst.Harvestable == "full" then
			if not inst.components.mine.issprung then
				inst.components.mine:Explode()
			end
			
			on_deactivate(inst)
			inst.AnimState:PlayAnimation("dig")
			inst.AnimState:PushAnimation("spawn")
			inst.AnimState:PushAnimation("trap_idle")
			inst.components.workable:SetWorkable(false)
			inst:DoTaskInTime(5, function(inst)
				inst.components.workable:SetWorkable(true)
			end)
		else
			inst:Remove()
		end
	else
		inst.components.workable:SetWorkLeft(1)
	end
end

local function MakeNotWinter(inst)
	inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*1.1)
	inst:RemoveComponent("workable")
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(on_blueberry_dug_up)
    inst.components.workable:SetWorkable(true)
end

local function Melt(inst)
	MakeNotWinter(inst)
	inst.AnimState:PlayAnimation("melt")
	inst.AnimState:PushAnimation("idle"..math.random(1,4))
end

local function on_anim_over(inst)
    if inst.components.mine.issprung then
        return
    end
	if inst.froze then
		if inst.Harvestable == "full" and TheWorld.state.iswinter then
			inst.AnimState:PushAnimation("idle_frozen", true)
			elseif not TheWorld.state.iswinter  then
			inst.froze = false
			Melt(inst)
		else
			inst.AnimState:PushAnimation("trap_idle", true)
		end
	elseif not TheWorld.state.iswinter then
		inst.AnimState:PushAnimation("idle"..math.random(1,4))
	end
end

-- Copied from mine.lua to emulate its mine test.
local mine_test_fn = function(target, inst)
    return not (target.components.health ~= nil and target.components.health:IsDead())
            and (target.components.combat ~= nil and target.components.combat:CanBeAttacked(inst))
end

local function do_snap(inst)
	if inst.Harvestable == "full" then
		inst.AnimState:PushAnimation("spawn")
		inst.AnimState:PushAnimation("trap_idle", true)
		inst.SoundEmitter:PlaySound("wintersfeast2019/creatures/gingerbread_vargr/splat")
		inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/trap")

		FxAppear(inst)
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
			if target ~= inst and target.components.mine and not target.components.mine.issprung and not target.froze then
                    target.components.mine:Explode(target)
			end
		end
		inst.Harvestable = "regrow"
	end
    if inst._snap_task ~= nil then
        inst._snap_task:Cancel()
        inst._snap_task = nil
    end
end

local function Regrow(inst)
	inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*1.1)
    inst.components.mine:Reset()
	inst.Harvestable = "full"
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
    inst.AnimState:PlayAnimation("reset")
    inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/idle")
    inst.AnimState:PushAnimation("idle"..math.random(1,4), true)
end

local function on_sprung(inst)
    inst.AnimState:PlayAnimation("trap_idle", true)
	inst.AnimState:PushAnimation("trap_idle", true)
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    inst:RemoveEventCallback("animover", on_anim_over)
    start_reset_task(inst)
end

local function get_status(inst)
    return (inst.components.mine.issprung and "REGROWING") or (inst.froze and "FROZE") or "READY"
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
	inst.Harvestable = "regrow"
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(on_blueberry_dug_up)
	start_reset_task(inst)
	FxAppear(inst)
	inst.AnimState:PlayAnimation("mine")
	inst.AnimState:PushAnimation("spawn")
	inst.AnimState:PushAnimation("trap_idle")
end

local function MakeWinter(inst)
	inst.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS*0)
	if inst.Harvestable == "full" then
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

local function on_load(inst, data)
    if data then
		if data.Harvestable then
			inst.Harvestable = data.Harvestable
		end
		if data.reset_task_time_remaining then
			if inst._reset_task then
				inst._reset_task:Cancel()
			end
			inst._reset_task = inst:DoTaskInTime(data.reset_task_time_remaining, reset)
			inst._reset_task_end_time = GetTime() + data.reset_task_time_remaining
		end
		if data.pendingregrow then
			inst.pendingregrow = data.pendingregrow
		end
    end
	if TheWorld.state.iswinter then
		inst.froze = true
		MakeWinter(inst)
	else
		inst.froze = false
		MakeNotWinter(inst)
	end
end



local function OnSpring(inst)
	if inst.pendingregrow or (inst.Harvestable == "regrow" and not inst.components.timer:TimerExists("regrow"))then
		Regrow(inst)
	end
	if inst.Harvestable == "full" and inst.froze then
		inst:RemoveEventCallback("animover",on_anim_over)
		inst:DoTaskInTime(3+math.random(0,15), function(inst) 
			Melt(inst)
			inst:ListenForEvent("animover", on_anim_over)
		end)
	end
	inst.froze = false
end

local function Freeze(inst)
	if TheWorld.state.iswinter then
		MakeWinter(inst)
		if inst.Harvestable == "full" then
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
    inst.AnimState:PlayAnimation("idle"..math.random(1,4), true)

    inst:AddTag("trap")
	inst:AddTag("blueberrybomb")
    inst:AddTag("trapdamage")
    inst:AddTag("birdblocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:DoTaskInTime(math.random() * (10 * math.random()), function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		
		local pitchers = TheSim:FindEntities(x, y, z, 50, { "pitcherplant" })
		
		if pitchers == nil or #pitchers < 1 then
			SpawnPrefab("pitcherplant").Transform:SetPosition(x, y, z)
		end
	end)

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
    inst.components.mine:SetAlignment("plantkin") -- blueberries trigger on EVERYTHING on the ground, players and non-players alike.
    inst.components.mine:SetOnExplodeFn(on_explode)
    inst.components.mine:SetOnResetFn(on_reset)
    inst.components.mine:SetOnSprungFn(on_sprung)
    inst.components.mine:SetOnDeactivateFn(on_deactivate)
    inst.components.mine:SetTestTimeFn(calculate_mine_test_time)
    inst.components.mine:SetReusable(false)
    Regrow(inst)
    -- Stop the blueberries from idling in unison.
    inst.AnimState:SetTime(math.random(0.1,0.3) * inst.AnimState:GetCurrentAnimationLength())
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", CheckTimeRegrow)
    -- Start the task for the characterizing additional idles.
    inst:ListenForEvent("animover", on_anim_over)
	
	inst:DoTaskInTime(0,function(inst) if not inst.Harvestable then inst.Harvestable = "full" end end)
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

local function blueberryexplosion()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("treegrowthsolution")
    inst.AnimState:SetBuild("um_goo_blue")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.Transform:SetScale(1.5,1.5,1.5)
	inst.AnimState:PlayAnimation("use", false)
	inst:ListenForEvent("animover",function(inst) inst:Remove() end)
	inst.persists = false

    return inst
end

local function blueberrypuddle()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("treegrowthsolution")
    inst.AnimState:SetBuild("um_goo_blue")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.Transform:SetScale(1.5,1.5,1.5)
    inst.AnimState:PlayAnimation("pre_idle", false)
	inst.AnimState:PushAnimation("idle", false)
	inst:ListenForEvent("animqueueover",function(inst) inst:Remove() end)
	inst.persists = false

    return inst
end

return Prefab("blueberryplant", blueberryplant,assets),
Prefab("blueberryflower", blueberryflower),
MakePlacer("blueberryflower_placer", "star_trap", "star_trap", "trap_idle"),
Prefab("blueberryexplosion",blueberryexplosion),
Prefab("blueberrypuddle",blueberrypuddle)

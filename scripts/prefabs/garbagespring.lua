

local function choose_anim_by_level(remaining, low, med, full)
    return (remaining < (TUNING.HOTSPRING_WORK / 3) and low) or (remaining < (TUNING.HOTSPRING_WORK * 2 / 3) and med) or full
end

local function push_special_idle(inst)
    if inst._glassed then
        -- We need to push a size-relevant sparkle, and then also the size-relevant idle.
		inst._glass_sparkle_tick = (inst._glass_sparkle_tick or 0) - 1

		if inst._glass_sparkle_tick < 0 then
			local work_remaining = (inst.components.workable ~= nil and inst.components.workable.workleft) or TUNING.HOTSPRING_WORK
			local sparkle_anim = choose_anim_by_level(work_remaining, "glass_low_sparkle1", "glass_med_sparkle"..math.random(2), "glass_full_sparkle"..math.random(3))
			inst.AnimState:PushAnimation(sparkle_anim, false)

			local idle_anim = choose_anim_by_level(work_remaining, "glass_low", "glass_med", "glass_full")
			inst.AnimState:PushAnimation(idle_anim)

			inst._glass_sparkle_tick = math.random(1, 3)
		end
    else
        local steam_anim_index = math.random(5)
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("slow_steam_fx"..steam_anim_index).Transform:SetPosition(x, y, z)
    end
end

--------------------------------------------------------------------------

--------------------------------------------------------------------------

local function OnSave(inst, data)
end

local function OnLoad(inst, data)
    if data ~= nil then
    end
end

--------------------------------------------------------------------------
local function GetFish(inst)
    return "ratacombs_junkpouch"
end

local function hotspring()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeSmallObstaclePhysics(inst, 1)

    inst.AnimState:SetBuild("crater_pool")
    inst.AnimState:SetBank("crater_pool")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetLayer(LAYER_BACKGROUND) -- TODO: these should be enabled but then the player will stand on top of the glass, so the glass needs to be seperated out in order for this to work.
    inst.AnimState:SetSortOrder(2)

    inst.MiniMapEntity:SetIcon("hotspring.png")

    -- From watersource component
    inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("watersource")

    inst:AddComponent("fishable")
    inst.components.fishable.maxfish = TUNING.OASISLAKE_MAX_FISH
    inst.components.fishable:SetRespawnTime(TUNING.OASISLAKE_FISH_RESPAWN_TIME)
    inst.components.fishable:SetGetFishFn(GetFish)
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	
    return inst
end

return Prefab("garbagespring", hotspring)

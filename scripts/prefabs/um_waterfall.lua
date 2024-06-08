local assets =
{
    Asset("ANIM", "anim/moonglass_bigwaterfall_steam.zip"),
    Asset("ANIM", "anim/moonglasspool_tile.zip"),
    Asset("MINIMAP_IMAGE", "um_waterfall_pool"),
}

local prefabs =
{
    "um_waterfall",
    "grottopool_sfx",
}

local STAGEUP_TIME = 3

local TILE_WIDTH_BY_STAGE = {0, 3, 6}
local TERRAFORM_DELAY = 3

--------------------------------------------------------------------------------
local function make_terraformer_proxy(inst, ix, iy, iz)
    local terraformer = SpawnPrefab("um_waterfall_terraformer")
    terraformer.Transform:SetPosition(ix, iy, iz)
    inst:ListenForEvent("onremove", function(_)
        inst._terraformer = nil
    end, terraformer)

    return terraformer
end

local function do_portal_tiles(inst, portal_position, stage)
    local ix, iy, iz
    if portal_position then
        ix, iy, iz = portal_position.x, portal_position.y, portal_position.z
    else
        ix, iy, iz = inst.Transform:GetWorldPosition()
    end

    local _map = TheWorld.Map
    local _undertile_cmp = TheWorld.components.undertile
    local portal_tile_x, portal_tile_y = _map:GetTileCoordsAtPoint(ix, iy, iz)

    stage = stage or inst._stage

    inst._terraformer = inst._terraformer or make_terraformer_proxy(inst, ix, iy, iz)

    -- If we're at stage 1, we need to handle offset 0,0 (the loop condition excludes it below)
    if stage == 1 then
        inst._terraformer:AddTerraformTask(portal_tile_x, portal_tile_y, 0)
    end

    local current_count = TILE_WIDTH_BY_STAGE[stage]
    local previous_count = (TILE_WIDTH_BY_STAGE[stage - 1] or 0) + 1

    for index = previous_count, current_count do
        local horizontal_offset, vertical_offset = index, 0
        local vertical_mod = 1
        local base_time_delay = (index - previous_count)
        while horizontal_offset > -index do
            -- We do the tile replacement symmetrically, so we can just flip our offsets
            -- while iterating to hit both sides of the portal together.
            inst._terraformer:AddTerraformTask(
                portal_tile_x + horizontal_offset,
                portal_tile_y + vertical_offset,
                (base_time_delay + 0.3 + 0.3*math.random()) * TERRAFORM_DELAY,
                {horizontal_offset, vertical_offset}
            )
            inst._terraformer:AddTerraformTask(
                portal_tile_x - horizontal_offset,
                portal_tile_y - vertical_offset,
                (base_time_delay + 0.3 + 0.3*math.random()) * TERRAFORM_DELAY,
                {-horizontal_offset, -vertical_offset}
            )

            -- The vertical offset needs to reverse when it reaches max distance,
            -- but the horizontal offset can just keep trucking until it reaches
            -- the maximum negative distance.
            horizontal_offset = horizontal_offset - 1
            vertical_offset = vertical_offset + vertical_mod
            if vertical_offset == index then
                vertical_mod = -1
            end
        end
    end
end

--------------------------------------------------------------------------------

local function do_stage_up(inst)
    if inst._stage < TUNING.RIFT_LUNAR1_MAXSTAGE then
        local next_stage = inst._stage + 1
        inst._stage = next_stage
		
		inst.components.um_ripplespawner:SetRange(inst._stage * 8)

        if next_stage < TUNING.RIFT_LUNAR1_MAXSTAGE then
            if not inst.components.timer:TimerExists("trynextstage") then
                inst.components.timer:StartTimer("trynextstage", STAGEUP_TIME)
            end
        else
            inst.components.timer:StopTimer("trynextstage")
        end

        local portal_position = inst:GetPosition()
        do_portal_tiles(inst, portal_position, next_stage)
    end
end

local function try_stage_up(inst, force_finish_terraforming)
    if inst._stage < TUNING.RIFT_LUNAR1_MAXSTAGE then

        inst.components.timer:StopTimer("do_stageup")
        inst.components.timer:StartTimer("do_stageup", STAGEUP_TIME)

        if force_finish_terraforming then
            inst.components.timer:StopTimer("do_forcefinishterraforming")
            inst.components.timer:StartTimer("do_forcefinishterraforming", STAGEUP_TIME + FRAMES)
        end
    end
end

--------------------------------------------------------------------------------
local function on_timer_done(inst, data)
    -- If we're in the process of phasing out, don't fire any timers.
    if inst._finished then
        return
    end

    if data.name == "disappear" then
		inst.AnimState:PlayAnimation("waterfall_end")
		inst:DoTaskInTime(.7, inst.Remove) --Why? Because spriter insists that the waterfall should go back UP after going down, for no reason. this is what spriter does to a mf
		inst:ListenForEvent("animover", inst.Remove)
		inst.persists = false
    elseif data.name == "initialize" then
        local portal_position = inst:GetPosition()
        do_portal_tiles(inst, portal_position, inst._stage)
    elseif data.name == "trynextstage" then
        inst:TryStageUp()
    elseif data.name == "do_stageup" then
        do_stage_up(inst)
    elseif data.name == "do_forcefinishterraforming" then
        inst:ForceFinishTerraforming(inst)
    end
end

--------------------------------------------------------------------------------
local function on_portal_removed(inst)
    local _map = TheWorld.Map
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    local portal_tile_x, portal_tile_y = _map:GetTileCoordsAtPoint(ix, iy, iz)

    local _undertile_cmp = TheWorld.components.undertile
	
	inst.SoundEmitter:KillSound("um_waterfall_loop")

    inst._terraformer = inst._terraformer or make_terraformer_proxy(inst, ix, iy, iz)
    inst._terraformer:AddTerraformTask(portal_tile_x, portal_tile_y, 0, {0, 0}, true)

    local current_portal_radius = TILE_WIDTH_BY_STAGE[inst._stage]
    for index = 1, current_portal_radius do
        local horizontal_offset, vertical_offset = index, 0
        local vertical_mod = 1
        local base_time_delay = (current_portal_radius - index - 1)

        while horizontal_offset > -index do
            inst._terraformer:AddTerraformTask(
                portal_tile_x + horizontal_offset,
                portal_tile_y + vertical_offset,
                (base_time_delay + 0.5*math.random()) * 2.0,
                {horizontal_offset, vertical_offset},
                true
            )
            inst._terraformer:AddTerraformTask(
                portal_tile_x - horizontal_offset,
                portal_tile_y - vertical_offset,
                (base_time_delay + 0.5*math.random()) * 2.0,
                {horizontal_offset, vertical_offset},
                true
            )

            horizontal_offset = horizontal_offset - 1
            vertical_offset = vertical_offset + vertical_mod
            if vertical_offset == index then
                vertical_mod = -1
            end
        end
    end
end

local function on_rift_finished(inst)
    inst:ListenForEvent("animover", inst.Remove)

    inst._finished = true
end

--------------------------------------------------------------------------------
local GRAZER_MUST_TAGS = {"lunar_aligned", "NOCLICK"} -- Hiding/pre-spawn grazers have NOCLICK
local function portal_forcefinishterraforming(inst)
    if inst._terraformer then
        inst._terraformer:PushEvent("forcefinishterraforming")
    end
end

--------------------------------------------------------------------------------
local function on_portal_save(inst, data)
    data.stage = inst._stage

    -- We can't just flag with persists = false, because we need to fire the onremove listener to clean up the area.
    data.finished = inst._finished

    local entity_guids

    if inst._terraformer then
        entity_guids = entity_guids or {}
        data.terraformer_guid = inst._terraformer.GUID
        table.insert(entity_guids, data.terraformer_guid)
    end

    return entity_guids
end

local function on_portal_load(inst, data)
    if data then
        inst._stage = data.stage or inst._stage
		
		inst.components.um_ripplespawner:SetRange(inst._stage * 8)
		
        if inst._stage >= TUNING.RIFT_LUNAR1_MAXSTAGE then
            inst.components.timer:StopTimer("trynextstage")            
        end

        if data.finished then
            on_rift_finished(inst)
        end
    end
end

local function on_portal_load_postpass(inst, newents, data)
    if data then

        local terraformerGUID = data.terraformer_guid
        if terraformerGUID then
            local terraformer_entdata = newents[terraformerGUID]
            if terraformer_entdata then
                inst._terraformer = terraformer_entdata.entity
            end
        end
    end

    -- If we're loading anything, stop our timer
    inst.components.timer:StopTimer("initialize")
end

local function makebigmist(proxy)
    if not proxy then
        return nil
    end

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --[[Non-networked entity]]

    local parent = proxy.entity:GetParent()
    if parent ~= nil then
        inst.entity:SetParent(parent.entity)
    end

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBuild("moonglass_bigwaterfall_steam")
    inst.AnimState:SetBank("moonglass_bigwaterfall_steam")
    inst.AnimState:PlayAnimation("steam_big", true)
    inst.AnimState:SetLightOverride(0.5)

    proxy:ListenForEvent("onremove", function() inst:Remove() end)

    return inst
end

local function IsNearFloodTile(map, x, y, z)
	local is_valid_tile = true
			
	local offs =
	{
		{-2,-2}, {-1,-2}, {0,-2}, {1,-2}, {2,-2},
		{-2,-1}, 						  {2,-1},
		{-2, 0}, 						  {2, 0},
		{-2, 1}, 						  {2, 1},
		{-2, 2}, {-1, 2}, {0, 2}, {1, 2}, {2, 2},
		{-2,-2}, {-2,-3}, {0,-3}, {2,-3}, {3,-3},
		{-3,-2}, 						  {3,-2},
		{-3, 0}, 						  {3, 0},
		{-3, 1}, 						  {3, 2},
		{-3, 3}, {-2, 3}, {0, 3}, {2, 3}, {3, 3}
	}
	for i = 1, #offs, 1 do
		local curoff = offs[i]
		local offx, offz = curoff[1], curoff[2]

		local current_tile = map:GetTileAtPoint(x + offx, y, z + offz)
		if not current_tile == WORLD_TILES.UM_FLOODWATER or 
			current_tile == nil or not
			map:IsPassableAtPoint(x + offx, y, z + offz) then
			is_valid_tile = false
		end
	end
	
	return is_valid_tile
end

local function OnEntitySleep(inst)
	if inst.persists and TheWorld.state.isspring then
		inst.SoundEmitter:KillSound("um_waterfall_loop")
		
		if inst.raindroptask ~= nil then
			inst.raindroptask:Cancel()
			inst.raindroptask = nil
		end
	else
		inst:Remove()
	end
end

local function OnEntityWake(inst)
	if inst.persists and TheWorld.state.isspring then
		if not inst.SoundEmitter:PlayingSound("um_waterfall_loop") then
			inst.SoundEmitter:PlaySound("UCSounds/um_waterfall/um_waterfall", "um_waterfall_loop")
		end
		
		if inst.raindroptask == nil then
			inst.raindroptask = inst:DoPeriodicTask(.25, function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				
				local x1 = x + math.random(-25, 25)
				local z1 = z + math.random(-25, 25)
				
				local _map = TheWorld.Map
				local current_tile = _map:GetTileAtPoint(x1, y, z1)
				if current_tile == WORLD_TILES.UM_FLOODWATER then
					if IsNearFloodTile(_map, x1, 0, z1) then
						local shimmer = SpawnPrefab("um_waterfall_wave")
						shimmer.Transform:SetPosition(x1, 0, z1)
						shimmer.Transform:SetScale(0.9, 0.9, 0.9)
					end
				end
			end)
		end
	else
		inst:Remove()
	end
end

local function Init(inst)
	inst.SoundEmitter:PlaySound("UCSounds/um_waterfall/um_waterfall", "um_waterfall_loop")
	
	inst.raindroptask = inst:DoPeriodicTask(.25, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
			
		local x1 = x + math.random(-25, 25)
		local z1 = z + math.random(-25, 25)
			
		local _map = TheWorld.Map
		local current_tile = _map:GetTileAtPoint(x1, y, z1)
		if current_tile == WORLD_TILES.UM_FLOODWATER then
			if IsNearFloodTile(_map, x1, 0, z1) then
				local shimmer = SpawnPrefab("um_waterfall_wave")
				shimmer.Transform:SetPosition(x1, 0, z1)
				shimmer.Transform:SetScale(0.9, 0.9, 0.9)
			end
		end
	end)
	
	if not inst.components.timer:TimerExists("disappear") then
		inst.components.timer:StartTimer("disappear", (TheWorld.state.springlength / 4) * 480)
	end
end

local function WatchSeason(inst, season)
	if season ~= SEASONS.SPRING then
		if not inst.components.timer:TimerExists("disappear") then
			inst.components.timer:StartTimer("disappear", math.random(2,400))
		end
	end
end

local COLOUR_R, COLOUR_G, COLOUR_B = 227/255, 227/255, 227/255
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, makebigmist)
    end

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBuild("um_waterfall")
    inst.AnimState:SetBank("um_waterfall")
    inst.AnimState:PlayAnimation("waterfall_loop", true)
	
    inst.MiniMapEntity:SetIcon("um_waterfall_pool.png")

    inst.Light:SetColour(COLOUR_R, COLOUR_G, COLOUR_B)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetFalloff(0.6)
    inst.Light:SetRadius(0.9)

    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    -- From watersource component
    inst:AddTag("watersource")
    inst:AddTag("cavedweller")
    inst:AddTag("um_waterfall")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("watersource")
	--inst.components.watersource.onusefn = function(inst) inst:Remove() end
	
	inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)

    ----------------------------------------------------------
    inst._stage = 1
	
    inst:AddComponent("um_ripplespawner")
	inst.components.um_ripplespawner:SetRange(inst._stage * 8)

	inst:DoTaskInTime(0, Init)

    ----------------------------------------------------------
    inst.TryStageUp = try_stage_up
    inst.ForceFinishTerraforming = portal_forcefinishterraforming

    ----------------------------------------------------------
    local timer_cmp = inst:AddComponent("timer")
    timer_cmp:StartTimer("initialize", 0)
    timer_cmp:StartTimer("trynextstage", STAGEUP_TIME)
	
    WatchSeason(inst, TheWorld.state.season)
    inst:WatchWorldState("season", WatchSeason)
    ----------------------------------------------------------
    inst:ListenForEvent("timerdone", on_timer_done)
    inst:ListenForEvent("onremove", on_portal_removed)
    inst:ListenForEvent("finish_rift", on_rift_finished)

    ----------------------------------------------------------
    inst.OnSave = on_portal_save
    inst.OnLoad = on_portal_load
    inst.OnLoadPostPass = on_portal_load_postpass
	
    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
end

local function SpawnerInit(inst)
	if TheWorld.state.isspring then
		inst.SoundEmitter:PlaySound("UCSounds/um_waterfall/um_waterfall", "um_waterfall_loop")
		inst.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "miniearthquake")
		inst.SoundEmitter:SetParameter("miniearthquake", "intensity", 1)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local x1, y1, z1 = TheWorld.Map:GetTileCenterPoint(x, y, z)
		
		if x1 ~= nil then
			inst.Transform:SetPosition(x1, y1, z1)
			inst.AnimState:PlayAnimation("waterfall_start")

			inst:ListenForEvent("animover", function()
				SpawnPrefab("um_waterfall").Transform:SetPosition(x1, y1, z1)
				inst.persists = false
				inst:DoTaskInTime(0, inst.Remove)
			end)
		else
			inst.Transform:SetPosition(x, y, z)
			inst.AnimState:PlayAnimation("waterfall_start")

			inst:ListenForEvent("animover", function()
				SpawnPrefab("um_waterfall").Transform:SetPosition(x, y, z)
				inst.persists = false
				inst:DoTaskInTime(0, inst.Remove)
			end)
		end
	else
		inst:Remove()
	end
end

local function spawnfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBuild("um_waterfall")
    inst.AnimState:SetBank("um_waterfall")

    inst.Light:SetColour(COLOUR_R, COLOUR_G, COLOUR_B)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetFalloff(0.6)
    inst.Light:SetRadius(0.9)
	
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("um_waterfall")

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:DoTaskInTime(0, SpawnerInit)

    return inst
end

local function wavefn()
    local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	--inst.AnimState:SetLayer(LAYER_GROUND)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	
    inst.AnimState:SetBuild( "wave_shimmer" )
    inst.AnimState:SetBank( "shimmer" )
    inst.AnimState:PlayAnimation( "idle", false )

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:ListenForEvent("animover", inst.Remove)
	inst.Transform:SetRotation(math.random(360))

	inst.OnEntitySleep = inst.Remove
	
	inst.persists = false

    return inst
end

return Prefab("um_waterfall", fn, assets, prefabs),
		Prefab("um_waterfall_spawner", spawnfn, assets, prefabs),
		Prefab("um_waterfall_wave", wavefn, assets, prefabs)
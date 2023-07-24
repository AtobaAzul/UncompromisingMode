-- This file is, uh, very normal.
-- I used it for a few experiments.
-- I hope there's some useful stuff!
-- Mara :D

local prefabs = {
	"firenettles",
	"um_smolder_spore",
	"umdebuff_pyre_toxin",
	"character_fire"
}

local plant_maxhealth = 300
local spore_cooldown_max = 60

--local onsurface = false
--local oncave = false
--local function WorldCheck(inst)
--	if TheWorld:HasTag("forest") then
--		onsurface = true
--	end
--	if TheWorld:HasTag("cave") then
--		oncave = true
--	end
--end

-- These tiles are where Smolder Spores can survive, when it isn't Summer.
-- ALL NON-MAGMA MAGMA CAVES TURFS SHOULD GO HERE.
local HOME_TILES =
{
	[WORLD_TILES.OCEAN_WATERLOG] = true, -- PLACEHOLDER
}

if WORLD_TILES.MAGMA_ASH ~= nil then
	HOME_TILES[WORLD_TILES.MAGMA_ASH] = true --IA compat teehee
	HOME_TILES[WORLD_TILES.MAGMA_ROCK] = true
	HOLE_TILES[WORLD_TILES.MAGMAFIELD] = true
end


SetSharedLootTable('um_pyre_nettles_1',
	{
		{ 'firenettles', 1.0 }
	})
SetSharedLootTable('um_pyre_nettles_2',
	{
		{ 'firenettles', 0.75 }
	})
SetSharedLootTable('um_pyre_nettles_3',
	{
		{ 'firenettles', 0.75 },
		{ 'firenettles', 0.25 }
	})
SetSharedLootTable('um_pyre_nettles_4',
	{
		{ 'firenettles', 1.0 },
		{ 'firenettles', 1.0 },
		{ 'firenettles', 0.75 },
		{ 'firenettles', 0.25 }
	})
SetSharedLootTable('um_pyre_nettles_5',
	{
		{ 'firenettles', 1.0 },
		{ 'firenettles', 1.0 },
		{ 'firenettles', 0.75 },
		{ 'firenettles', 0.5 },
		{ 'firenettles', 0.25 }
	})


local function pyrenettle_bumped(inst)
	local bumpradius = 1
	if inst.stage > 3 then
		bumpradius = inst.stage * 0.75
	end

	local nextvictim = FindClosestEntity(inst, bumpradius, true, nil,
		{ "PyreToxinImmune", "plantkin", "flying", "FX", "INLIMBO", "invisible", "notarget", "noattack", "playerghost", "smog", "wall" }
	)

	if nextvictim ~= nil
		and nextvictim.components.locomotor ~= nil
		--	and not inst:GetIsWet() -- Disabled because it would completely remove the threat in summer.
		and math.random() > 0.5 -- Chance to bump the plant.
	then
		--print ("At the time of pyrenettle_bumped PlayAnimation, inst.stage == " .. inst.stage )
		inst.AnimState:PlayAnimation("pn" .. inst.stage .. "_bump", false)
		inst.AnimState:PushAnimation("pn" .. inst.stage .. "_idle", true)

		-- If we're at a later stage, try to drop some spores.
		local spore_cooldown_running = inst.components.timer:GetTimeLeft("SporeCooldownTimer")
		if spore_cooldown_running == nil and inst.stage > 3 then
			if math.random() < 0.5 then
				SpawnPrefab("um_smolder_spore").Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
			if inst.stage > 4 and math.random() < 0.5 then
				SpawnPrefab("um_smolder_spore").Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
			inst.components.timer:StartTimer("SporeCooldownTimer", spore_cooldown_max)
		end

		-- Apply debuff if it's a valid target.
		if nextvictim.components.health ~= nil and not nextvictim.components.health:IsDead()
			and math.random() > 0.25
		then
			local DebuffDuration = 6
			if inst.stage > 3 then
				DebuffDuration = 10
			end
			nextvictim:AddDebuff("umdebuff_pyre_toxin", "umdebuff_pyre_toxin", DebuffDuration)

			inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit", "um_pyre_nettles_bumpedsound")
			inst.SoundEmitter:SetVolume("um_pyre_nettles_bumpedsound", 0.5)
		end
	end
end


-- Timer reset for small nettle growth.
local function SmallPyreNettleGrowthTimerReset(inst)
	local time_remaining = inst.components.timer:GetTimeLeft("SmallPyreNettleGrowthTimer")
	local timer_duration = (math.random((TUNING.TOTAL_DAY_TIME * 0.125)) + (TUNING.TOTAL_DAY_TIME * 0.125))

	if inst.stage < 3 then
		if time_remaining ~= nil then
			inst.components.timer:SetTimeLeft("SmallPyreNettleGrowthTimer", timer_duration)
		else
			inst.components.timer:StartTimer("SmallPyreNettleGrowthTimer", timer_duration)
		end
	end
end

-- Timer reset for natural spore spawning.
-- Also does the actual spore spawn.
local function NaturalSporeSpawnTimerReset(inst)
	local time_remaining = inst.components.timer:GetTimeLeft("NaturalSporeSpawnTimer")
	local timer_duration = (math.random(1, 30) + 60)

	local spore_cooldown_running = inst.components.timer:GetTimeLeft("SporeCooldownTimer")
	if spore_cooldown_running == nil and inst.stage == 5 and math.random() > 0.5 then
		inst.AnimState:PlayAnimation("pn5_coof", false)
		inst.AnimState:PushAnimation("pn5_idle", true)
		SpawnPrefab("um_smolder_spore").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.components.timer:StartTimer("SporeCooldownTimer", spore_cooldown_max)

		if time_remaining ~= nil then
			inst.components.timer:SetTimeLeft("NaturalSporeSpawnTimer", timer_duration)
		else
			inst.components.timer:StartTimer("NaturalSporeSpawnTimer", timer_duration)
		end
	end
end


-- This sets up the plant's stage-unique traits.
local function SetStage(inst)
	-- Remove and then add a tag to identify current stage, for spawning checks.
	for i = 1, 5 do
		inst:RemoveTag("PyreNettle" .. i)
	end
	inst:AddTag("PyreNettle" .. inst.stage)

	-- Anim selector.
	inst.AnimState:PushAnimation("pn" .. inst.stage .. "_idle", true)


	if not TheWorld.ismastersim then
		return
	end

	-- Loot selector.
	inst.components.lootdropper:SetChanceLootTable("um_pyre_nettles_" .. inst.stage)

	if inst.stage == 1 then
		inst.components.pickable.remove_when_picked = true
	else
		inst.components.pickable.remove_when_picked = false
	end

	-- Flammability stage properties.
	if inst.stage > 3 then
		inst.components.burnable:SetFXLevel(3)
	else
		inst.components.burnable:SetFXLevel(2)
	end

	SmallPyreNettleGrowthTimerReset(inst)
	NaturalSporeSpawnTimerReset(inst)

	-- Burn the playerbase! And other stuff.
	if inst.bump_task ~= nil then
		inst.bump_task:Cancel()
	end
	inst.bump_task = inst:DoPeriodicTask((FRAMES * 10), pyrenettle_bumped, 1)

	-- When everything else is done, set the prefab's destruction methods.
	if inst.stage > 3 then
		inst:RemoveTag("notarget")
		inst.components.pickable.canbepicked = false
	else
		inst:AddTag("notarget")
		inst.components.pickable.canbepicked = true
	end
end


local function OnGrow(inst)
	local targetstage = 1
	if inst.stage ~= nil then
		targetstage = (inst.stage + 1)
	end

	-- In case we've reached an invalid stage, crash/error prevention.
	if targetstage > 5 then
		targetstage = 6 -- This exists just for stage 5 plants to drop spores when burnt.
	elseif targetstage < 1 then
		print("um_pyre_nettles.lua is trying to grow to an invalid stage! Target stage: " .. targetstage)
		targetstage = 1
	end

	local growsuccess = false
	local x, y, z = inst.Transform:GetWorldPosition()
	local tile_at_position = TheWorld.Map:GetTileAtPoint(x, y, z)
	local findnettles = TheSim:FindEntities(x, y, z, 50, { "PyreNettle" .. targetstage })

	local nearextremeheat = false
	if (FindClosestEntity(inst, 15, true, { "lava" })) ~= nil -- Lava tag is on Dfly lava pond. Also add it to any lava deco in the Lava Caves.
	--or -- CHECK FOR LAVA TURF IN A RADIUS SIMILAR TO 50 ENTITY UNITS
	then
		nearextremeheat = true
	end

	if inst.components.pickable ~= nil then
		inst.components.pickable.canbepicked = false
	end

	-- This block is set up this way so it'll be easily changable for balance/biome aesthetics. Don't condense it.
	-- This decides if the plant will actually grow a stage.
	if #findnettles == (nil or 0) then
		growsuccess = true
	elseif targetstage == 2 and #findnettles < 16 then
		growsuccess = true
	elseif targetstage == 3 and #findnettles < 8 then
		growsuccess = true
	elseif targetstage == 4 and #findnettles < 4 then
		growsuccess = true
	elseif targetstage == 5 and #findnettles < 2 then
		growsuccess = true
	elseif targetstage == 6 then
		growsuccess = true
	end

	-- Outside Magma Caves, Pyre Nettles can't grow past stage 2.
	if growsuccess == true
		and not HOME_TILES[tile_at_position]
		and not TheWorld:HasTag("heatwavestart")                      -- Unless a heatwave is happening.
		and nearextremeheat == false                                  -- Or we're near lava	.
		and (targetstage > 2 or (targetstage == 2 and math.random() > 0.5)) --They also have a chance to stop growth at stage 1.
	then
		growsuccess = false
	end

	if growsuccess == false and inst ~= nil then
		SetStage(inst) -- Even if the stage didn't change, we still need to reset traits like pickability.
	end

	if growsuccess == true and inst ~= nil and inst.AnimState ~= nil then
		local spore_cooldown_running = inst.components.timer:GetTimeLeft("SporeCooldownTimer")
		if spore_cooldown_running == nil and targetstage == 6 then
			inst.AnimState:PlayAnimation("pn5_coof", false)
			inst.AnimState:PushAnimation("pn5_idle", true)
			SpawnPrefab("um_smolder_spore").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.components.timer:StartTimer("SporeCooldownTimer", spore_cooldown_max)
		elseif targetstage < 6 then
			inst.AnimState:PlayAnimation("pn" .. inst.stage .. "_grow", false)
			inst.stage = targetstage
			inst:ListenForEvent("animover", SetStage)
		end
	end
end

local function OnShrink(inst)
	local targetstage = (inst.stage - 1)

	if inst.components.pickable ~= nil then
		inst.components.pickable.canbepicked = false
	end

	inst.AnimState:PlayAnimation("pn" .. inst.stage .. "_shrink", false)

	inst.stage = targetstage

	inst:ListenForEvent("animover", function()
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile_at_position = TheWorld.Map:GetTileAtPoint(x, y, z)

		if inst.stage == 0 then
			inst:Remove()
		elseif TheWorld.state.season ~= "summer" and not HOME_TILES[tile_at_position] then
			inst:DoTaskInTime(((30 * 3 * math.random()) + 30), OnShrink)
		end

		SetStage(inst)
	end)
end

local function OnPicked(inst)
	OnShrink(inst)
end

local function OnAttacked(inst, data)
	if inst.components.health:GetPercent() > 0.01 then
		if (math.random() * inst.stage) > 3 and not (data.attacker ~= nil and data.attacker:HasTag("HASHEATER")) then
			SpawnPrefab("um_smolder_spore").Transform:SetPosition(inst.Transform:GetWorldPosition())

			if data.weapon ~= nil and data.weapon.prefab == "voidcloth_scythe" then
				inst.components.health:DoDelta(-TUNING.VOIDCLOTH_SCYTHE_DAMAGE * 2)
			end
		end
		inst.AnimState:PlayAnimation("pn" .. inst.stage .. "_hit", false)
		inst.AnimState:PushAnimation("pn" .. inst.stage .. "_idle", true)
		inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit", "um_pyre_nettles_attackedsound")
		inst.SoundEmitter:SetVolume("um_pyre_nettles_attackedsound", 0.5)
	else
		inst.components.lootdropper:DropLoot(inst:GetPosition())

		inst.components.health:SetCurrentHealth(plant_maxhealth)

		OnShrink(inst)
	end
end

-- Make the plant destroyable instantly with explosives, dropping the current stage's loot and all below it.
local function OnExplosion(inst)
	for i = 1, inst.stage do
		inst.components.lootdropper:SetChanceLootTable("um_pyre_nettles_" .. i)
		inst.components.lootdropper:DropLoot(inst:GetPosition())
	end

	if inst.stage == (4 or 5) then
		for i = 1, math.random(2, 5) do
			SpawnPrefab("um_smolder_spore").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	end

	inst:DoTaskInTime(0, function()
		inst:Remove()
	end)
end

local function OnHaunt(inst)
	if inst.stage < 4 and math.random() > 0.5 then
		OnShrink(inst)
		return true
	else
		return false
	end
end

local function OnTimerDone(inst, data)
	print("timerdone", data.name)
	if data.name == "SmallPyreNettleGrowthTimer" then
		OnGrow(inst)
	elseif data.name == "NaturalSporeSpawnTimer" then
		NaturalSporeSpawnTimerReset(inst)
	end
end


local function SpringCleaning(inst)
	inst:DoTaskInTime(10, function()
		local x, y, z = inst.Transform:GetWorldPosition()
		local tile_at_position = TheWorld.Map:GetTileAtPoint(x, y, z)

		if TheWorld.state.season ~= "summer" and not HOME_TILES[tile_at_position] then
			inst:DoTaskInTime(((60 * 10 * math.random()) + (60 * 4)), OnShrink)
		end
	end)
end

local function OnHeatwaveStart(inst)
	if inst.HeatwaveGrowthTask == nil then
		inst.HeatwaveGrowthTask = inst:DoPeriodicTask((60 * math.random()) + 30, OnGrow, 2)
	end
end

local function OnHeatwaveEnd(inst)
	if inst.HeatwaveGrowthTask ~= nil then
		inst.HeatwaveGrowthTask:Cancel()
		inst.HeatwaveGrowthTask = nil
	end
end


local function OnSave(inst, data)
	data.stage = inst.stage
end

local function OnLoad(inst, data)
	if data ~= nil then
		inst.stage = data.stage
	end

	inst:DoTaskInTime(0, SetStage)
end


local function StageSpawner(name, SpawnAtStage)
	local SpawnAtStage = SpawnAtStage

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()

		inst.prefab = "um_pyre_nettles" -- In case we're a spawned-in stage-specifying prefab.

		--	MakeObstaclePhysics(inst, 0.1)

		local minimap = inst.entity:AddMiniMapEntity()
		inst.MiniMapEntity:SetIcon("um_pyre_nettles_map.tex")
		inst.MiniMapEntity:SetPriority(-1)

		-- Stage setting
		if inst.stage == nil then
			inst.stage = SpawnAtStage
		end
		local growanimstage = (inst.stage - 1)

		inst.AnimState:SetBank("um_pyre_nettles")
		inst.AnimState:SetBuild("um_pyre_nettles")
		local multsize = 0.75 + (math.random() * 0.2)
		if math.random() < 0.5 then
			inst.AnimState:SetScale(-multsize, multsize, multsize)
		else
			inst.AnimState:SetScale(multsize, multsize, multsize)
		end
		inst.AnimState:PlayAnimation("pn" .. growanimstage .. "_grow", false)
		local multcolor = 0.85 + (math.random() * 0.15)
		inst.AnimState:SetMultColour(multcolor, multcolor, multcolor, 1)

		-- UM tags
		inst:AddTag("PyreNettle")
		inst:AddTag("PyreToxinImmune")
		inst:AddTag("SmolderSporeAvoid")
		inst:AddTag("snowpileblocker") -- SNOOOOOWWWW BLOCKERRRRRR
		-- Vanilla tags
		inst:AddTag("plant")
		inst:AddTag("scarytoprey")
		inst:AddTag("thorny")

		inst:SetDeployExtraSpacing(1)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		--inst:DoPeriodicTask(1 --[[(30 * math.random()) + 30]], OnGrow, 2)

		inst:DoTaskInTime(0, function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			if #TheSim:FindEntities(x, y, z, 1, { "PyreNettle" }) > 1 then
				inst:Remove()
			end
		end)

		inst:AddComponent("inspectable")

		inst:AddComponent("lootdropper")
		inst:AddComponent("pickable")
		inst.components.pickable:SetUp(nil)
		inst.components.pickable.use_lootdropper_for_product = true
		inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
		inst.components.pickable.onpickedfn = OnPicked

		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(plant_maxhealth)
		inst.components.health:SetMinHealth(1) -- We don't want it to die a 'normal' death.
		inst.components.health.fire_damage_scale = 0 -- Take no damage from fire.

		inst:AddComponent("combat")

		inst:ListenForEvent("attacked", OnAttacked)
		inst:ListenForEvent("explosion", OnExplosion)

		inst:AddComponent("hauntable")
		inst.components.hauntable:SetOnHauntFn(OnHaunt)

		inst:AddComponent("burnable")
		inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 0))
		inst.components.burnable:SetBurnTime(6)
		inst.components.burnable:SetOnBurntFn(OnGrow) -- Try to grow the plant whenever the fire finishes burning.
		MakeSmallPropagator(inst)

		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", OnTimerDone)


		-- Heatwave listeners.
		inst:DoPeriodicTask(5, function(inst)
			if TheWorld:HasTag("heatwavestart") then
				OnHeatwaveStart(inst)
			else
				OnHeatwaveEnd(inst)
			end
		end)
		--inst:ListenForEvent("heatwavestart", OnHeatwaveStart, TheWorld)
		--inst:ListenForEvent("heatwaveend", OnHeatwaveEnd, TheWorld)


		SpringCleaning(inst)
		inst:WatchWorldState("stopsummer", SpringCleaning)

		--	inst:DoTaskInTime(0, WorldCheck)
		inst:DoTaskInTime(0, SetStage)

		inst.OnSave = OnSave
		inst.OnLoad = OnLoad

		return inst
	end

	return Prefab(name, fn, nil, prefabs)
end


local pyre_nettle_prefabs = {}
for i = 1, 5 do
	table.insert(pyre_nettle_prefabs, StageSpawner("um_pyre_nettles_stage_" .. i, i))
end
table.insert(pyre_nettle_prefabs, StageSpawner("um_pyre_nettles", 1))

return unpack(pyre_nettle_prefabs)

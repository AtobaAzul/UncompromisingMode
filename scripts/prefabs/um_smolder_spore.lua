local prefabs = {
	"um_pyre_nettles",
	"houndfire",
	"smog"
}


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
	--	[WORLD_TILES.MAGMA_ASH] = true,
	--	[WORLD_TILES.MAGMA_ROCK] = true,
	--	[WORLD_TILES.MAGMAFIELD] = true,
}


-- Use lootdropper to drop hound fires in a natural-looking way.
SetSharedLootTable('um_smolder_spore',
	{
		{ 'houndfire', 1.0 },
		{ 'houndfire', 1.0 },
		{ 'houndfire', 0.5 },
		{ 'houndfire', 0.25 },
		{ 'smog',      1.0 }
	})


-- This prefab just isn't complicated enough to need seperate files for movement. One block of code suffices.
local function SimpleWander(inst)
	if not inst:HasTag("BUSYSMOLDERSPORE") then
		if math.random() > 0.5 then
			inst.components.locomotor:RunInDirection(math.random(1, 359))
			inst.components.locomotor:RunForward()
			inst:DoTaskInTime(math.random(4, 7), function()
				inst.components.locomotor:Stop()
			end)
		end
	end
end


local function PlantSelf(inst)
	local blockers = FindClosestEntity(inst, 1, true, { "blocker" },
		{ "invisible", "notarget", "noattack", "playerghost" })
	local nettlescrowding = FindClosestEntity(inst, 2, true, { "PyreNettle" })
	local x, y, z = inst.Transform:GetWorldPosition()
	local findnettles = TheSim:FindEntities(x, y, z, 50, { "PyreNettle" })

	if not inst:HasTag("BUSYSMOLDERSPORE")
		and blockers == nil
		and nettlescrowding == nil
		and #findnettles < 16 
		and TheWorld.Map:IsPassableAtPoint(x, y, z) 
		and TheWorld.Map:CanPlantAtPoint(x, y, z)
	then
		inst:AddTag("BUSYSMOLDERSPORE")

		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("divebomb", false)
		inst:ListenForEvent("animover", function()
			inst:Hide()
			SpawnPrefab("um_pyre_nettles").Transform:SetPosition(x, y, z)
			inst:DoTaskInTime(0, function()
				inst:Remove()
			end)
		end)
	end

	-- If the planting failed, wait a bit and try again.
	inst:DoTaskInTime(10, PlantSelf)
end


-- Spread some fire around!
local function FireSpread(inst)
	-- We make the spore uninterractable past this point, because it should be visually destroying itself by the time we get here.
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")
	inst:AddTag("noattack")
	inst.Light:Enable(false)

	-- Explody noises.
	inst.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/firehound_explo")

	-- Instantly ignites anything flammable within a radius.
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 2, nil,
		{ "FX", "NOCLICK", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
	if #ents > 0 then
		for i, v in pairs(ents) do
			if v.components.burnable ~= nil then
				v.components.burnable:Ignite()
			end
		end
	end

	-- Slight AoE damage. Mainly to set off other nearby Smolder Spores.
	inst.components.combat:DoAreaAttack(inst, 3, nil, nil, "fire",
		{ "SmolderSporeAvoid", "BUSYSMOLDERSPORE", "INLIMBO", "invisible", "noattack" })

	inst.components.lootdropper:DropLoot(inst:GetPosition())
end


-- Suddenly pop!
local function PopSpore(inst)
	if not inst:HasTag("BUSYSMOLDERSPORE") then
		inst:AddTag("BUSYSMOLDERSPORE")

		if inst.components.locomotor ~= nil then
			inst.components.locomotor:Stop()
		end

		inst:Show()
		inst.AnimState:PlayAnimation("explode", false)
		FireSpread(inst)

		inst:ListenForEvent("animover", function()
			inst:Hide()
		end)

		inst:DoTaskInTime(2, function()
			inst:Remove()
		end)
	end
end

-- Divebomb the ground and explode!
local function Divebomb(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local refusetargets = TheSim:FindEntities(x, y, z, 2, "_health", nil, { "SmolderSporeAvoid", "plantkin" })

	if not inst:HasTag("BUSYSMOLDERSPORE") and #refusetargets < 1 then
		inst:AddTag("BUSYSMOLDERSPORE")

		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("divebomb", false)
		inst:ListenForEvent("animover", function()
			SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())

			FireSpread(inst)
			inst:Hide()
			inst:DoTaskInTime(1, function()
				inst:Remove()
			end)
		end)
	end
end

-- Check if we're in range of a suitable target.
local function TargetCheck(inst)
	local nextvictim = FindClosestEntity(inst, 1, true, nil,
		{ "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })

	if not inst:HasTag("BUSYSMOLDERSPORE")
		and nextvictim ~= nil
		and nextvictim.components.burnable ~= nil
		and not nextvictim:HasTag("plantkin")
		and not (nextvictim.components.health ~= nil and nextvictim.components.health:IsDead())
		and not (nextvictim:HasTag("SmolderSporeAvoid") and math.random() > 0.01) -- This keeps them from constantly seeking pyre nettles.
		and (nextvictim:HasTag("player") or math.random() > 0.5)            -- For anything but a player, chance to not activate.
	then
		Divebomb(inst)
	end
end

-- Check if we're allowed to be where we are.
local function TurfCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local tile_at_position = TheWorld.Map:GetTileAtPoint(x, y, z)

	if not HOME_TILES[tile_at_position] then
		Divebomb(inst)
	end
end

-- What happens when caught via bug net.
local function OnWorked(inst, worker)
	if worker.components.inventory ~= nil then
		worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
		worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
	end
end


-- Wormwood planting a spore.
local function OnDeploy(inst, pt)
	local plant = SpawnPrefab("um_pyre_nettles")
	plant.Transform:SetPosition(pt.x, 0, pt.z)
	plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
	inst:Remove()
end


local function OnPerish(inst)
	if inst.components.inventoryitem:IsHeld() then
		local holder = inst.components.inventoryitem:GetGrandOwner()

		if holder ~= nil and holder.components.talker ~= nil and holder.components.health ~= nil and not holder.components.health:IsDead() then
			holder.components.talker:Say(GetString(holder, "ANNOUNCE_SMOLDER_SPORE_INVENTORY_POP"))
		end

		SpawnPrefab("um_smolder_spore_pop").Transform:SetPosition(holder.Transform:GetWorldPosition())
		inst:Remove()
	else
		PopSpore(inst)
	end
end


local function OnEaten(inst, eater)
	if eater.components.sanity ~= nil then
		if eater:HasTag("plantkin") then -- The spores are alive. L for canibaLism.
			eater.components.sanity:DoDelta(-10)
		elseif eater:HasTag("pyromaniac") or eater.prefab == "wanda" then
			eater.components.sanity:DoDelta(10)
		end
	end

	if eater.components.talker ~= nil and eater.components.health ~= nil and not eater.components.health:IsDead() then
		eater.components.talker:Say(GetString(eater, "ANNOUNCE_SMOLDER_SPORE_EATEN"))
	end

	SpawnPrefab("um_smolder_spore_pop").Transform:SetPosition(eater.Transform:GetWorldPosition())
end


local function TaskStartup(inst)
	if inst.SimpleWanderTask == nil then
		inst.SimpleWanderTask = inst:DoPeriodicTask(9, SimpleWander, 2)
	end
	if inst.TargetCheckTask == nil then
		inst.TargetCheckTask = inst:DoPeriodicTask((FRAMES * 3), TargetCheck, 5)
	end
	if inst.PlantSelfTask == nil then
		inst.PlantSelfTask = inst:DoTaskInTime((math.random(1, 60) * math.random(1, 5)) + 30, PlantSelf)
	end
	if TheWorld.state.season ~= "summer" and inst.TurfCheckTask == nil then
		inst:DoPeriodicTask(10, TurfCheck, 10)
	end
end

local function TaskCancel(inst)
	if inst.SimpleWanderTask ~= nil then
		inst.SimpleWanderTask:Cancel()
		inst.SimpleWanderTask = nil
	end
	if inst.TargetCheckTask ~= nil then
		inst.TargetCheckTask:Cancel()
		inst.TargetCheckTask = nil
	end
	if inst.PlantSelfTask ~= nil then
		inst.PlantSelfTask:Cancel()
		inst.PlantSelfTask = nil
	end
	if inst.TurfCheckTask ~= nil then
		inst.TurfCheckTask:Cancel()
		inst.TurfCheckTask = nil
	end
end


local function OnDropped(inst)
	inst.Light:Enable(true)
	inst.persists = false

	if inst:GetIsWet() then
		PlantSelf(inst)
	end

	if inst.components.stackable ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		while inst.components.stackable:StackSize() > 1 do
			local item = inst.components.stackable:Get()
			if item ~= nil then
				if item.components.inventoryitem ~= nil then
					item.components.inventoryitem:OnDropped()
				end
				item.Physics:Teleport(x + math.random(-4, 4), y, z + math.random(-4, 4))
			end
		end
	end


	TaskStartup(inst)
end



local function OnPickup(inst)
	inst.Light:Enable(false)
	inst.persists = true

	TaskCancel(inst)

	-- Make it take longer to perish if Wormwood is holding it.
	if inst.components.inventoryitem:IsHeld() then
		local holder = inst.components.inventoryitem:GetGrandOwner()

		if holder ~= nil and holder:HasTag("plantkin") then
			inst.components.perishable:SetLocalMultiplier(TUNING.SEG_TIME * 3 / TUNING.PERISH_SLOW) -- From mushtree_spores.lua.
		end
	end
end


local function OnSeasonChange(inst)
	if TheWorld.state.season == "summer" then
		if inst.TurfCheckTask ~= nil then
			inst.TurfCheckTask:Cancel()
			inst.TurfCheckTask = nil
		end
	elseif inst.TurfCheckTask == nil then
		inst:DoPeriodicTask(10, TurfCheck, 10)
	end
end


local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	MakeCharacterPhysics(inst, 1, 0.5)
	RemovePhysicsColliders(inst)

	inst.AnimState:SetBank("um_smolder_spore")
	inst.AnimState:SetBuild("um_smolder_spore")
	inst.Transform:SetScale(1.25, 1.25, 1.25)
	inst.AnimState:PlayAnimation("spawn", false)
	inst.AnimState:PushAnimation("idle", true)

	inst:AddTag("PyreToxinImmune")
	inst:AddTag("soulless") -- Prefab shouldn't die via health loss, but...just in case.
    inst:AddTag("noember")
	inst:AddTag("scarytoprey")
	inst:AddTag("thorny")
	--	inst:AddTag("flying") -- Makes them ignore platform borders entirely. Flying over the void isn't ideal...

	inst:AddTag("show_spoilage")

	-- Sporepack tag
	inst:AddTag("spore_special")
	-- Slingshot tags
	inst:AddTag("slingshotammo")
	inst:AddTag("reloaditem_ammo")

	inst.Light:Enable(true)
	inst.Light:SetRadius(0.5)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetColour(235 / 255, 121 / 255, 12 / 255)


	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 1
	inst.components.locomotor.runspeed = 1
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor.pathcaps = { ignorecreep = true }

	inst:AddComponent("inspectable")

	inst:AddComponent("stackable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("um_smolder_spore")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(5)    -- To make it poppable via ranged attacks or earthquake drops.
	inst.components.health:SetMinHealth(1)    -- We don't want it to die a 'normal' death.
	inst.components.health.fire_damage_scale = 0 -- Take no damage from fire.
	inst.components.health.canmurder = false
	inst:ListenForEvent("attacked", PopSpore)
	inst:ListenForEvent("explosion", PopSpore)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(3)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(Divebomb)

	inst:AddComponent("moisture")
	inst.components.moisture.maxmoisture = 2
	inst:ListenForEvent("moisturedelta", function()
		if inst:GetIsWet() then
			PlantSelf(inst)
		end
	end)

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.TOTAL_DAY_TIME)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(OnPerish)


	-- Catchable via bugnet.
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.NET)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnWorked)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/um_smolder_spore.xml"
	inst.components.inventoryitem.canbepickedup = false
	inst:ListenForEvent("ondropped", OnDropped)
	inst:ListenForEvent("onputininventory", OnPickup)

	inst:AddComponent("reloaditem") -- Makes it acceptable Slingshot ammo.

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	-- Let Wormwood plant it.
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM) -- use inst._custom_candeploy_fn
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable.restrictedtag = "plantkin"

	-- Eating explosives goes about as well as you'd think.
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -10
	inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(OnEaten)


	--	inst:DoTaskInTime(0, WorldCheck) -- Only check for world tags after server startup is complete.

	TaskStartup(inst)

	OnSeasonChange(inst)
	inst:WatchWorldState("season", OnSeasonChange)


	inst.persists = false

	return inst
end

local function pop_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	inst:SetPrefabNameOverride("um_smolder_spore")

	inst.AnimState:SetBank("um_smolder_spore")
	inst.AnimState:SetBuild("um_smolder_spore")
	inst.Transform:SetScale(1.25, 1.25, 1.25)

	inst:AddTag("PyreToxinImmune")
	inst:AddTag("flying")
	inst:AddTag("thorny")

	inst.Light:Enable(true)
	inst.Light:SetRadius(0.5)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetColour(235 / 255, 121 / 255, 12 / 255)

	inst:Hide()

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("um_smolder_spore")

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(3)


	inst:DoTaskInTime(0, PopSpore)


	inst.persists = false

	return inst
end



-------------------------------
--- SLINGSHOT FUNCTIONALITY ---
-------------------------------
local AURA_EXCLUDE_TAGS = { "noclaustrophobia", "playerghost", "abigail", "companion", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible" }

if not TheNet:GetPVPEnabled() then
	table.insert(AURA_EXCLUDE_TAGS, "player")
end


-- temp aggro system for the slingshots
local function no_aggro(attacker, target)
	local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4 and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function DealDamage(inst, attacker, target, salty)
	inst.finaldamage = (inst.damage * (1 + (inst.powerlevel / 2))) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1)

	if salty ~= nil and salty and target.components.health ~= nil then
		inst.finaldamage = inst.finaldamage / target.components.health:GetPercent()
		if target:HasTag("snowish") then
			inst.finaldamage = inst.finaldamage * 2
		end
	end

	if no_aggro(attacker, target) then
		target.components.combat:SetShouldAvoidAggro(attacker)
	end

	if target:HasTag("shadowcreature") or target.sg == nil or target.wixieammo_hitstuncd == nil and not (target.sg:HasStateTag("busy") or target.sg:HasStateTag("caninterrupt")) or target.sg:HasStateTag("frozen") then
		target.wixieammo_hitstuncd = target:DoTaskInTime(8, function()
			if target.wixieammo_hitstuncd ~= nil then
				target.wixieammo_hitstuncd:Cancel()
			end
			target.wixieammo_hitstuncd = nil
		end)

		target.components.combat:GetAttacked(inst, inst.finaldamage, inst, "fire")
	else
		target.components.combat:GetAttacked(inst, 0, inst, "fire")

		target.components.health:DoDelta(-inst.finaldamage, false, inst, false, inst, false)
	end

	if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
		target.components.sleeper:WakeUp()
	end

	if target.components.combat ~= nil then
		target.components.combat:SetTarget(attacker)
		target.components.combat.temp_disable_aggro = false
		target.components.combat:RemoveShouldAvoidAggro(attacker)
	end

	if attacker.components.combat ~= nil then
		attacker.components.combat:SetTarget(target)
	end
end


local function SS_OnHit(inst, attacker, target)
	inst:Hide()

	SpawnPrefab("um_smolder_spore_pop").Transform:SetPosition(inst.Transform:GetWorldPosition()) -- Big badda boom.

	-- Damage anything within a radius.	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 3, nil, { "SmolderSporeAvoid", "BUSYSMOLDERSPORE", "INLIMBO", "invisible", "noattack" })
	if #ents > 0 then
		for i, v in pairs(ents) do
			local target = v

			if target ~= nil and target:IsValid() and target.components.combat ~= nil then
				DealDamage(inst, attacker, target)
			end
		end
	end

	inst:Remove()
end

local function SS_CollisionCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local attacker = inst.components.projectile.owner or nil

	for i, v in ipairs(TheSim:FindEntities(x, y, z, 3, { "_combat" }, AURA_EXCLUDE_TAGS)) do
		if v:GetPhysicsRadius(0) > 1.5 and v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
				if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
					SS_OnHit(inst, attacker, v)
					inst:Remove()
					return
				end
			end
		end
	end

	for i, v in ipairs(TheSim:FindEntities(x, y, z, 2, { "_combat" }, AURA_EXCLUDE_TAGS)) do
		if v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
				if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
					SS_OnHit(inst, attacker, v)
					inst:Remove()
					return
				end
			end
		end
	end
end


local function projectile_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	inst:SetPrefabNameOverride("um_smolder_spore")

	MakeProjectilePhysics(inst)

	inst.AnimState:SetBank("um_smolder_spore")
	inst.AnimState:SetBuild("um_smolder_spore")
	inst.Transform:SetScale(0.9, 0.9, 0.9)
	inst.AnimState:PlayAnimation("idle", true)

	--projectile (from projectile component) added to pristine state for optimization
	inst:AddTag("projectile")
	inst:AddTag("scarytoprey")
	inst:AddTag("flying")

	inst.Light:Enable(true)
	inst.Light:SetRadius(0.4)
	inst.Light:SetFalloff(0.4)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetColour(235 / 255, 121 / 255, 12 / 255)


	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	if inst.powerlevel == nil then
		inst.powerlevel = 1
	end

	inst:AddComponent("locomotor")

	inst:AddComponent("weapon")
	inst:AddComponent("projectile")

	inst:AddComponent("projectile")
	inst.components.projectile.hascustomattack = true
	inst.components.projectile:SetSpeed(25)
	inst.components.projectile:SetHoming(false)
	inst.components.projectile:SetHitDist(1.5)
	inst.components.projectile:SetOnPreHitFn(nil)
	inst.components.projectile:SetOnHitFn(SS_OnHit)
	inst.components.projectile:SetOnMissFn(SS_OnHit)
	inst.components.projectile.range = 30
	inst.components.projectile:SetLaunchOffset(Vector3(1, 0.5, 0))


	inst.damage = 75

	inst:DoPeriodicTask(FRAMES, SS_CollisionCheck)
	inst:DoTaskInTime(2 - (inst.powerlevel * inst.powerlevel), inst.Remove)


	inst.persists = false

	return inst
end


return Prefab("um_smolder_spore", fn, nil, prefabs),
	MakePlacer("um_smolder_spore_placer", "um_pyre_nettles", "um_pyre_nettles", "pn1_idle"),
	Prefab("um_smolder_spore_pop", pop_fn, nil, prefabs),
	Prefab("um_smolder_spore_proj_secondary", projectile_fn) -- Wixie slingshot projectile





-- https://cdn.discordapp.com/attachments/497450801191583787/1115361079950839829/Live_Wilson_Reaction.png

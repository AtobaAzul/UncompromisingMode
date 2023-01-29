require "stategraphs/SGancient_trepidation"

local brain = require "brains/trepidationbrain"

SetSharedLootTable('ancient_trepidation',
	{
		{ 'nightmarefuel', 1.00 },
	})

local function Remember(inst, target, insert) --Remember those vvho are menaces
	if insert then
		local notintable = true
		for i, v in ipairs(inst.menaces) do
			if v == target then
				notintable = nil
			end
		end
		if notintable then
			inst:AddTag("hostile")--I'M GONNA *KILL* SOMEBODY
			table.insert(inst.menaces, target)
		end
	else
		for i, v in ipairs(inst.menaces) do
			if v == target then
				inst:AddTag("hostile")
				return true
			end
		end
	end
	inst:RemoveTag("hostile")
end

local SHARE_TARGET_DIST = 30

local function NormalRetarget(inst)
	local targetDist = 40
	local x, y, z = inst.Transform:GetWorldPosition()
	local potentialtargets = TheSim:FindEntities(x, y, z, targetDist, { "character" }, { "playerghost" })
	local foundtarget = nil
	for i, target in ipairs(potentialtargets) do
		if inst.components.combat:CanTarget(target) and target.components.sanity and
			(target.components.sanity:GetPercent() < 0.5 or Remember(inst, target)) then
			Remember(inst, target, true) --This guy vvas insane near me, remember vvho they are.
			foundtarget = true
			return target
		end
	end
	if not foundtarget then
		for i, target in ipairs(potentialtargets) do
			if inst.components.combat:CanTarget(target) and target.components.sanity then
				return target
			end
		end
	end
end

local function keeptargetfn(inst, target)
	if target.components.health and not target.components.health:IsDead() and target.components.sanity then
		if target.components.sanity:GetPercent() < 0.5 or Remember(inst, target) then
			return target
		else
			local targetDist = 40
			local x, y, z = inst.Transform:GetWorldPosition()
			local potentialtargets = TheSim:FindEntities(x, y, z, targetDist, { "character" }, { "playerghost" })
			local foundtarget = nil
			for i, v in ipairs(potentialtargets) do
				if inst.components.combat:CanTarget(v) and v.components.sanity and
					(v.components.sanity:GetPercent() < 0.5 or Remember(inst, v)) then
					Remember(inst, v, true) --This guy is insane and my current target is not, I'm svvapping to them
					inst.components.combat:SetTarget(v)
					foundtarget = true
				end
			end
			if not foundtarget then
				return target
			end
		end
	end
end

local function OnAttacked(inst, data)
	if data.attacker and data.attacker:HasTag("player") then
		Remember(inst, data.attacker, true) --This guy vvas insane enough to hit me, I'm gonna clobber 'em the next time I see them.
		inst.components.combat:SetTarget(data.attacker)
	end
end

local sounds =
{
	attack = "dontstarve/sanity/creature2/attack",
	attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
	death = "dontstarve/sanity/creature2/die",
	idle = "dontstarve/sanity/creature2/idle",
	taunt = "dontstarve/sanity/creature2/taunt",
	appear = "dontstarve/sanity/creature2/appear",
	disappear = "dontstarve/sanity/creature2/dissappear",
}

local function ResetAbilityCooldown(inst, ability)
	local id = ability .. "_cd"
	local remaining = TUNING["STALKER_" .. string.upper(id)] -
		(inst.components.timer:GetTimeElapsed(id) or TUNING.STALKER_ABILITY_RETRY_CD)
	inst.components.timer:StopTimer(id)
	if remaining > 0 then
		inst.components.timer:StartTimer(id, remaining)
	end
end

local CHANNELER_SPAWN_PERIOD = 0.5
local function DoSpawnChanneler(inst, radius)
	local CHANNELER_SPAWN_RADIUS = 8.7
	if radius then
		CHANNELER_SPAWN_RADIUS = radius
	end
	if inst.components.health:IsDead() then
		inst.channelertask = nil
		inst.channelerparams = nil
		return
	end

	local x = inst.channelerparams.x + CHANNELER_SPAWN_RADIUS * math.cos(inst.channelerparams.angle)
	local z = inst.channelerparams.z + CHANNELER_SPAWN_RADIUS * math.sin(inst.channelerparams.angle)
	if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) and #TheSim:FindEntities(x, 0, z, 1, { "treparm" }) == 0 then
		local channeler = SpawnPrefab("ancient_trepidation_arm")
		channeler.Transform:SetPosition(x, 0, z)
		inst.channelerparams.count = inst.channelerparams.count - 1
		--channeler:ForceFacePoint(Vector3(inst.channelerparams.x, 0, inst.channelerparams.z))
		inst.components.commander:AddSoldier(channeler)
	else
		CHANNELER_SPAWN_RADIUS = CHANNELER_SPAWN_RADIUS / 2
	end

	if inst.channelerparams.count > 0 then
		inst.channelerparams.angle = inst.channelerparams.angle + inst.channelerparams.delta
		if inst:HasTag("spawning") then
			inst.channelertask = inst:DoTaskInTime(CHANNELER_SPAWN_PERIOD, DoSpawnChanneler)
		end
	else
		inst.channelertask = nil
		inst.channelerparams = nil
	end
end

local function SpawnChannelers(inst)
	ResetAbilityCooldown(inst, "channelers")

	local count = 4
	if count <= 0 or inst.channelertask ~= nil then
		return
	end

	local x, y, z = (inst.components.entitytracker:GetEntity("stargate") or inst).Transform:GetWorldPosition()
	inst.channelerparams =
	{
		x = x,
		z = z,
		angle = math.random() * 2 * PI,
		delta = -2 * PI / count,
		count = count,
	}
	DoSpawnChanneler(inst)
end

local function DespawnChannelers(inst)
	if inst.channelertask then
		inst.channelertask:Cancel()
		inst.channelertask = nil
		inst.channelerparams = nil
	end
	for i, v in ipairs(inst.components.commander:GetAllSoldiers()) do
		if not v.components.health:IsDead() then
			v.components.health:Kill()
		end
	end
end

local function nodmgshielded(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	return inst.hasshield and amount <= 0 and not ignore_absorb or afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function OnSoldiersChanged(inst)
	if inst.hasshield ~= (inst.components.commander:GetNumSoldiers() > 0) then
		inst.hasshield = not inst.hasshield
		if not inst.hasshield then
			inst.components.timer:StopTimer("channelers_cd")
			inst.sg:GoToState("summon_channelers_pst")
			inst.components.timer:StartTimer("channelers_cd", TUNING.STALKER_CHANNELERS_CD)
		end
	end
end

local function StartAbility(inst, ability)
	inst.components.timer:StartTimer(ability .. "_cd", TUNING.STALKER_ABILITY_RETRY_CD)
end

local function CheckIfBozoLeft(inst)
	if not
		FindEntity(inst, 20, function(guy) if inst.components.combat:CanTarget(guy) then return guy:HasTag("character") end end) then
		inst.sg:GoToState("spawn")
		local x, y, z = inst.Transform:GetWorldPosition()
		local Despawn = SpawnPrefab("shadow_despawn")
		inst:DespawnChannelers()
		if inst.components.health ~= nil then
			inst.components.health:SetCurrentHealth(3000)
		end
		Despawn.Transform:SetPosition(x, 0, z)
		local bozo = FindEntity(inst, 40,
			function(guy)
				if inst.components.combat:CanTarget(guy) then
					return guy:HasTag("character")
				end
			end)
		if bozo then
			inst.components.combat:SuggestTarget(bozo)
			local x, y, z = bozo.Transform:GetWorldPosition()
			inst.Transform:SetPosition(x, 0, z)
		end
	end
end

local function OnSave(inst, data)
end

local function OnLoad(inst, data)

end

local function CheckWhereTheHeckIAm(inst)
	if not inst.components.areaaware:CurrentlyInTag("Nightmare") and inst.components.homeseeker then
		if inst.components.combat.target then
			inst.components.combat.target = nil
		end
		inst.Physics:Stop()
		inst.sg:GoToState("anger")
		inst:DoTaskInTime(0.6, function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			local Despawn = SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
			local x, y, z = inst.components.homeseeker.home.Transform:GetWorldPosition()
			inst.Transform:SetPosition(x, y, z)
			if inst.components.combat.target then
				inst.components.combat.target = nil
			end
		end)
	end
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	inst.entity:AddNetwork()
	inst.entity:AddLightWatcher()

	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(2, 2, 2)
	MakeCharacterPhysics(inst, 10, 1.5)
	RemovePhysicsColliders(inst)

	inst.AnimState:UsePointFiltering(true)
	inst.entity:SetPristine()

	inst.menaces = {} --putting this here so clients can access it!

	if not TheWorld.ismastersim then
		return inst
	end

	inst.AnimState:SetBank("ancient_trepidation")
	inst.AnimState:SetBuild("ancient_trepidation")
	inst.AnimState:PlayAnimation("give_life", true)

	inst.AnimState:SetMultColour(0, 0, 0, 0.8)
	-- locomotor must be constructed before the stategraph!
	inst:AddComponent("locomotor")
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.walkspeed = 3.5
	inst.components.locomotor.runspeed = 3.5


	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('ancient_trepidation')


	inst:AddTag("notraptrigger")
	inst:AddTag("shadowchesspiece")
	inst:AddTag("trepidation")
	inst:AddTag("fossil")
	------------------
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(3000)
	inst.components.health.redirect = nodmgshielded
	inst.hasshield = false
	------------------

	inst:AddComponent("shadowsubmissive")
	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat:SetDefaultDamage(75)
	inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRetargetFunction(1, NormalRetarget)
	inst.components.combat:SetHurtSound("dontstarve/sanity/creature" .. math.random(1, 2) .. "/attack_grunt")
	inst.components.combat:SetRange(3, 3)
	------------------
	inst:AddComponent("areaaware")
	------------------
	inst.sounds = sounds
	inst:AddComponent("knownlocations")
	------------------
	inst:AddComponent("commander")
	inst:AddComponent("timer")
	inst:AddComponent("entitytracker")
	inst:AddComponent("epicscare")
	inst.components.epicscare:SetRange(TUNING.STALKER_EPICSCARE_RANGE)
	------------------

	inst.SpawnChannelers = SpawnChannelers
	inst.DespawnChannelers = DespawnChannelers
	inst.StartAbility = StartAbility
	inst.CheckIfBozoLeft = CheckIfBozoLeft
	------------------
	inst:ListenForEvent("soldierschanged", OnSoldiersChanged)
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL

	inst.components.timer:StartTimer("channelers_cd", TUNING.STALKER_FIRST_CHANNELERS_CD)
	inst:SetStateGraph("SGancient_trepidation")
	inst:SetBrain(brain)
	inst:ListenForEvent("attacked", OnAttacked)
	inst.sg:GoToState("spawn")
	inst.hasshield = false

	inst.onsave = OnSave
	inst.onload = OnLoad
	inst:DoPeriodicTask(10, CheckWhereTheHeckIAm)

	inst.Remember = Remember

	inst:DoTaskInTime(0, function(inst)
		if TUNING.DSTU.TREPIDATIONS == false then
			inst:Remove()
		end
	end)
	return inst
end

return Prefab("ancient_trepidation", fn)

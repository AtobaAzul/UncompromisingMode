local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--Treeguard now has AOE - Axe
env.AddPrefabPostInit("leif", function(inst)
	if inst.components.combat ~= nil then
		local function isnottree(ent)
			if ent ~= nil and not ent:HasTag("leif") and not ent:HasTag("stumpling") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end

		inst.components.combat:SetAreaDamage(3, TUNING.DEERCLOPS_AOE_SCALE, isnottree) -- you can edit these values to your liking -Axe
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetLoot({ "livinglog", "livinglog", "livinglog", "livinglog", "livinglog", "livinglog",
			"plantmeat" })
	end

end)
--Treeguard now has single target root attack -Axe
env.AddPrefabPostInit("leif", function(inst)

	env.AddComponentPostInit("wisecracker", function(self, inst)
		self.inst = inst

		inst:ListenForEvent("rooting", function(inst, data)
			inst.components.talker:Say(GetString(inst, "ANNOUNCE_ROOTING"))
		end)
	end)

	local prefabs = {
		"rootspike",
	}

	local SNARE_OVERLAP_MIN = 1
	local SNARE_OVERLAP_MAX = 3
	local SNARE_TAGS = { "_combat", "locomotor" }
	local SNARE_NO_TAGS = { "flying", "ghost", "playerghost", "tallbird", "fossil", "shadow", "shadowminion", "INLIMBO",
		"epic", "smallcreature" }
	local SNARE_MAX_TARGETS = 20

	inst:AddComponent("timer")

	local function NoSnareOverlap(x, z, r)
		return #TheSim:FindEntities(x, 0, z, r or SNARE_OVERLAP_MIN, { "rootspike", "groundspike" }) <= 0
	end

	local function FindSnareTargets(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local targets = {}
		local priorityindex = 1
		local priorityindex2 = 1
		local ents = TheSim:FindEntities(x, y, z, TUNING.STALKER_SNARE_RANGE, SNARE_TAGS, SNARE_NO_TAGS)
		for i, v in ipairs(ents) do
			if not (v.components.health ~= nil and v.components.health:IsDead()) then
				if v:HasTag("player") then
				elseif v.components.combat:TargetIs(inst) then
					table.insert(targets, priorityindex2, v)
					priorityindex2 = priorityindex2 + 1
				else
					table.insert(targets, v)
				end
				if #targets >= SNARE_MAX_TARGETS then
					return targets
				end
			end
		end
		return #targets > 0 and targets or nil
	end

	local function SpawnSnare(inst, target)
		-- find target position
		local x, y, z = target.Transform:GetWorldPosition()
		local islarge = target:HasTag("largecreature")
		local r = target:GetPhysicsRadius(0) + (islarge and 1.5 or .5)
		local num = islarge and 12 or 6


		local vars = { 1, 2, 3, 4, 5, 6, 7 }
		local used = {}
		local queued = {}
		local count = 0
		local dtheta = PI * 2 / num
		local thetaoffset = math.random() * PI * 2
		local delaytoggle = 0
		local map = TheWorld.Map


		if x ~= nil and z ~= nil then
			for theta = math.random() * dtheta, PI * 2, dtheta do
				local x1 = x + r * math.cos(theta)
				local z1 = z + r * math.sin(theta)
				local boat = map:GetPlatformAtPoint(x, z)
				if boat then
					if boat.components.health ~= nil and not boat.components.health:IsDead() then
						boat.components.health:DoDelta(-25)
						boat:PushEvent("spawnnewboatleak",
							{ pt = target:GetPosition(), leak_size = "med_leak", playsoundfx = true, cause = "leif" })
						break
					end
				elseif map:IsPassableAtPoint(x1, 0, z1) and not map:IsPointNearHole(Vector3(x1, 0, z1)) then
					local spike = SpawnPrefab("rootspike")
					spike.Transform:SetPosition(x1, 0, z1)

					local delay = delaytoggle == 0 and 0 or .2 + delaytoggle * math.random() * .2
					delaytoggle = delaytoggle == 1 and -1 or 1

					local duration = GetRandomWithVariance(TUNING.STALKER_SNARE_TIME, TUNING.STALKER_SNARE_TIME_VARIANCE)

					local variation = table.remove(vars, math.random(#vars))
					table.insert(used, variation)
					if #used > 3 then
						table.insert(queued, table.remove(used, 1))
					end
					if #vars <= 0 then
						local swap = vars
						vars = queued
						queued = swap
					end

					spike:RestartSpike(delay, duration, variation)
					count = count + 1
				end
			end
		end
		if count <= 0 then
			return false
		elseif target:IsValid() then
			if target.components.talker then
				target:PushEvent("rooting", { attacker = inst })
			end
		end
		return true
	end

	local function find_leif_spawn_target(item)
		return not item.noleif
			and item.components.growable ~= nil
			and item.components.growable.stage <= 3
	end

	local function spawn_stumpling(target)
		if target:HasTag("deciduous") then
			local stumpling = SpawnPrefab("birchling")

			if target.chopper ~= nil then
				stumpling.components.combat:SuggestTarget(target.chopper)
			end

			local x, y, z = target.Transform:GetWorldPosition()
			target:Remove()
			local effect = SpawnPrefab("round_puff_fx_hi")
			effect.Transform:SetPosition(x, y, z)
			stumpling.Transform:SetPosition(x, y, z)
			stumpling.sg:GoToState("hit")
		else
			local stumpling = SpawnPrefab("stumpling")

			if target.chopper ~= nil then
				stumpling.components.combat:SuggestTarget(target.chopper)
			end

			local x, y, z = target.Transform:GetWorldPosition()
			target:Remove()
			local effect = SpawnPrefab("round_puff_fx_hi")
			effect.Transform:SetPosition(x, y, z)
			stumpling.Transform:SetPosition(x, y, z)
			stumpling.sg:GoToState("hit")
		end
	end

	local function SummonStumplings(target)
		for k = 1, 3 do
			local stump = FindEntity(target, TUNING.LEIF_MAXSPAWNDIST, find_leif_spawn_target, { "stump" --[[,"evergreen"]] },
				{ "leif", "burnt" --[[,"deciduoustree"]] })
			if stump ~= nil then
				stump.noleif = true
				if inst.components.combat.target ~= nil then
					stump.chopper = inst.components.combat.target
				end
				stump:DoTaskInTime(0, spawn_stumpling)
			end
		end
	end

	inst.SummonStumplings = SummonStumplings
	inst.FindSnareTargets = FindSnareTargets
	inst.SpawnSnare = SpawnSnare

	local function UnHide(inst, data)
		if data.statename ~= "sleeping" then
			--print("flimbus")
			inst.sg:RemoveStateTag("hiding")
			inst:RemoveEventCallback("newstate", UnHide)
		end
	end

	local function BossCheck(inst, data)
		if not inst.components.health:IsDead() and data.attacker ~= nil and data.attacker:HasTag("epic") then
			inst:PushEvent("bosshide")

			if inst.components.combat.target ~= nil and not inst.components.combat.target:HasTag("player") then
				inst.components.combat:DropTarget()
			end

			if data.attacker.components.combat:HasTarget() and not data.attacker.components.combat:TargetIs(inst) then
				--print("flimbo")
				data.attacker.components.combat:DropTarget()
			end
		end
	end

	inst:ListenForEvent("attacked", BossCheck)

	local function OnHitOther(inst, other)
		if other:HasTag("creatureknockbackable") then
			other:PushEvent("knockback", { knocker = inst, radius = 75, strengthmult = 1 })
		else
			if other ~= nil and other.components.inventory ~= nil and not other:HasTag("fat_gang") and
				not other:HasTag("foodknockbackimmune") and not (other.components.rider ~= nil and other.components.rider:IsRiding()
				) and
				--Don't knockback if you wear marble
				(
				other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil or
					not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and
					not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
				other:PushEvent("knockback", { knocker = inst, radius = 75, strengthmult = 1 })
			end
		end
	end

	if inst.components.combat ~= nil then
		inst.components.combat.onhitotherfn = OnHitOther
	end

end)

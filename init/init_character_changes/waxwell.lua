local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
if not TUNING.DSTU.UPDATE_CHECK then
	local function DoEffects(pet)
		local x, y, z = pet.Transform:GetWorldPosition()

		SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)

		if pet.components.follower.leader ~= nil then
			local x1, y1, z1 = pet.components.follower.leader.Transform:GetWorldPosition()
			SpawnPrefab("statue_transition").Transform:SetPosition(x1, y1, z1)
		end
	end

	--[[local function doeffects(inst, pos)
    SpawnPrefab("statue_transition").Transform:SetPosition(pos:Get())
    SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
end]]


	local function CalculateMaxHealthLoss(inst, data)
		if inst.components.health ~= nil and not inst.components.health:IsDead() then
			local healthloss = ((data.damageresolved ~= nil and data.damageresolved or data.damage) * 0.2) / 75
			inst.components.health:DeltaPenalty(healthloss)
		end
	end

	local function KillPet(pet)
		pet.components.health:Kill()
	end

	local function OnSpawnPet(inst, pet)
		if pet:HasTag("classicshadow") then
			--Delayed in case we need to relocate for migration spawning
			pet:DoTaskInTime(0, DoEffects)

			if not (inst.components.health:IsDead() or inst:HasTag("playerghost")) then
				inst.components.sanity:AddSanityPenalty(pet, TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_PENALTY)
				inst:ListenForEvent("onremove", inst._onpetlost, pet)
			elseif pet._killtask == nil then
				pet._killtask = pet:DoTaskInTime(math.random(), KillPet)
			end
		else
			return inst.OldSpawnPet(inst, pet)
		end
	end

	env.AddPrefabPostInit("waxwell", function(inst)
		if not TheWorld.ismastersim then
			return
		end

		inst:AddTag("codexumbrareader")

		if inst.components.petleash ~= nil then
			inst.OldSpawnPet = inst.components.petleash.onspawnfn
			inst.components.petleash:SetOnSpawnFn(OnSpawnPet)
		end

		if TUNING.DSTU.MAX_HEALTH_WELL then
			inst:ListenForEvent("attacked", CalculateMaxHealthLoss)
		end
	end)

	local function canread(inst, reader)
		return (inst.components.sanity:GetMaxWithPenalty() >= TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST) and
			(inst.components.health.currenthealth > TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
	end

	local function onread(inst, reader)

		if not reader:HasTag("codexumbrareader") then
			return false
		end

		--Check sanity
		if not canread(reader) then
			if reader.components.talker then
				if reader.components.sanity:GetMaxWithPenalty() < TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST then
					reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOSANITY"))
				elseif reader.components.health.currenthealth <= TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST then
					reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOHEALTH"))
				end
				return true
			end
		end

		--Check reagent
		if not reader.components.inventory:Has("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST) then
			if reader.components.talker then
				reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOFUEL"))
				return true
			end
		end


		local readx, ready, readz = reader.Transform:GetWorldPosition()
		local shadowmax = reader.components.petleash:SpawnPetAt(readx, ready, readz, "old_shadowwaxwell")

		if shadowmax ~= nil then
			reader.components.inventory:ConsumeByName("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST)
			shadowmax:DoTaskInTime(0, function(shadowmax) shadowmax.sg:GoToState("jumpout") end)
			reader.components.health:DoDelta(-TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
			reader.components.sanity:RecalculatePenalty()
			inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		end

		return true
	end

	env.AddPrefabPostInit("waxwelljournal", function(inst)

		if not TheWorld.ismastersim then
			return
		end

		if inst.components.prototyper ~= nil then
			--inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.PRESTIHATITATOR
		end

		inst:AddComponent("book")
		inst.components.book.onread = onread
	end)
else
	STRINGS.SPELLS.SHADOW_MIMIC = "Shadow Mimic"--TODO:MOVE THIS TO init/init_strings!!
	local ICON_SCALE = .6
	local ICON_RADIUS = 50
	local SPELLBOOK_RADIUS = 100
	local SPELLBOOK_FOCUS_RADIUS = SPELLBOOK_RADIUS + 2
	local NUM_MINIONS_PER_SPAWN = 1
	
	
	local function _CheckMaxSanity(sanity, minionprefab)
		return sanity ~= nil and
			sanity:GetPenaltyPercent() +
			(TUNING.SHADOWWAXWELL_SANITY_PENALTY[string.upper(minionprefab)] or 0) * NUM_MINIONS_PER_SPAWN <=
			TUNING.MAXIMUM_SANITY_PENALTY
	end
	
	local function CheckMaxSanity(doer, minionprefab)
		return _CheckMaxSanity(doer.components.sanity, minionprefab)
	end
	
	--I don't know why Klei does this, but i'm not gonna ask.
	
	local function SpellCost(pct)
		return pct * TUNING.LARGE_FUEL * -4
	end
	
	local function ShadowMimicSpellFn(inst, doer)
		if inst.components.fueled:IsEmpty() then
			return false, "NO_FUEL"
		elseif doer.components.health.currenthealth <= TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST then
			doer.components.talker:Say(GetString(doer.prefab, "ANNOUNCE_NOHEALTH"))
		elseif ThePlayer and ThePlayer.waxwellshadow ~= nil then
			return false, "MAX_MIMICS"
		else
			local x, y, z = doer.Transform:GetWorldPosition()
			local shadowmax = doer.components.petleash:SpawnPetAt(x, y, z, "old_shadowwaxwell")
	
			if shadowmax ~= nil then
				inst.components.fueled:DoDelta(SpellCost(TUNING.WAXWELLJOURNAL_SPELL_COST.SHADOW_TOPHAT * 2), doer)
				shadowmax:DoTaskInTime(0, function(shadowmax) shadowmax.sg:GoToState("jumpout") end)
				doer.components.health:DoDelta(-TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
				doer.components.sanity:RecalculatePenalty()
				doer.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
			end
		end
	end
	
	local SHADOW_MIMIC_SPELL =
	{
		label = STRINGS.SPELLS.SHADOW_MIMIC,
		onselect = function(inst)
			inst.components.spellbook:SetSpellName(STRINGS.SPELLS.SHADOW_MIMIC)
			if TheWorld.ismastersim then
				inst.components.aoespell:SetSpellFn(nil)
				inst.components.spellbook:SetSpellFn(ShadowMimicSpellFn)
			end
		end,
		execute = function(inst)
			local inventory = ThePlayer.replica.inventory
			if inventory ~= nil then
				inventory:CastSpellBookFromInv(inst)
			end
			print("here?")
		end,
		atlas = "images/the_men.xml", --didn't rename because I thought it was funny.
		normal = "the_men.tex",
		widget_scale = ICON_SCALE,
		hit_radius = ICON_RADIUS,
	}
	
	env.AddPrefabPostInit("waxwelljournal", function(inst)
		if not TheWorld.ismastersim then
			return
		end
	
		if inst.components.spellbook ~= nil then
			if not table.contains(inst.components.spellbook.items, SHADOW_MIMIC_SPELL) then
				table.insert(inst.components.spellbook.items, SHADOW_MIMIC_SPELL)
			end
		end
	end)	
end

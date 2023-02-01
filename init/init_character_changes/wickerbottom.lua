-- Wicker Books
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
AllRecipes = GLOBAL.AllRecipes
STRINGS = GLOBAL.STRINGS
TECH = GLOBAL.TECH
CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

if TUNING.DSTU.WICKERNERF_TENTACLES then
	local function newtentacles(inst, reader)
		if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
			local pt = reader:GetPosition()
			local numtentacles = 3

			reader:StartThread(function()
				for k = 1, numtentacles do
					local theta = math.random() * 2 * PI
					local radius = math.random(3, 8)

					local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
						local pos = pt + offset
						--NOTE: The first search includes invisible entities
						return #TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
							and TheWorld.Map:IsPassableAtPoint(pos:Get())
							and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
					end)

					if result_offset ~= nil then
						local x, z = pt.x + result_offset.x, pt.z + result_offset.z
						local tentacle = SpawnPrefab("wicker_tentacle")
						tentacle.Transform:SetPosition(x, 0, z)
						tentacle.sg:GoToState("attack_pre")

						--need a better effect
						SpawnPrefab("shadow_puff").Transform:SetPosition(x, 0, z)
						ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, reader, 40)
					end

					Sleep(.33)
				end
			end)
			return true
		else
			return false
		end
	end

	env.AddPrefabPostInit("book_tentacles", function(inst)
		if not TheWorld.ismastersim then
			return
		end

		if inst.components.book ~= nil then
			inst.components.book.onread = newtentacles
		end
	end)
end

if TUNING.DSTU.WICKERNERF_MOONBOOK then
	--just a little convinience thing for me
	env.AddPrefabPostInit("werebeast", function(self)
		if self.inst ~= nil then
			self.inst:AddTag("werebeast")
		end
	end)

	local WEREMODE_NAMES =
	{
		"beaver",
		"moose",
		"goose",
	}	

	local WEREMODES = { NONE = 0 }
	for i, v in ipairs(WEREMODE_NAMES) do
		WEREMODES[string.upper(v)] = i
	end

	local function IsWereMode(mode)
		return WEREMODE_NAMES[mode] ~= nil
	end

	local function OnGooseRunningOver(inst, CalculateWerenessDrainRate)
		if inst._gooserunninglevel > 1 then
			inst._gooserunninglevel = inst._gooserunninglevel - 1
			inst._gooserunning = inst:DoTaskInTime(TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseRunningOver,
				CalculateWerenessDrainRate)
		else
			inst._gooserunning = nil
			inst._gooserunninglevel = nil
		end
		inst.components.wereness:SetDrainRate(CalculateWerenessDrainRate(inst, WEREMODES.GOOSE, TheWorld.state.isfullmoon))
	end

	local function CalculateWerenessDrainRate(inst, mode, isfullmoon)
		local t = isfullmoon and TUNING.WERE_FULLMOON_DRAIN_TIME_MULTIPLIER or 1
		if mode == WEREMODES.BEAVER then
			t = t * TUNING.BEAVER_DRAIN_TIME
			if inst._beaverworkinglevel ~= nil then
				t = t *
					(
					inst._beaverworkinglevel > 1 and TUNING.BEAVER_WORKING_DRAIN_TIME_MULTIPLIER2 or
						TUNING.BEAVER_WORKING_DRAIN_TIME_MULTIPLIER1)
			end
		elseif mode == WEREMODES.MOOSE then
			t = t * TUNING.WEREMOOSE_DRAIN_TIME
			if inst._moosefightinglevel ~= nil then
				t = t *
					(
					inst._moosefightinglevel > 1 and TUNING.WEREMOOSE_FIGHTING_DRAIN_TIME_MULTIPLIER2 or
						TUNING.WEREMOOSE_FIGHTING_DRAIN_TIME_MULTIPLIER1)
			end
		else --if mode == WEREMODES.GOOSE then
			t = t * TUNING.WEREGOOSE_DRAIN_TIME
			if inst.sg:HasStateTag("moving") then
				if inst._gooserunning ~= nil then
					inst._gooserunning:Cancel()
				end
				inst._gooserunning = inst:DoTaskInTime(TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseRunningOver,
					CalculateWerenessDrainRate)
				inst._gooserunninglevel = 2
			end
			if inst._gooserunninglevel ~= nil then
				t = t *
					(
					inst._gooserunninglevel > 1 and TUNING.WEREGOOSE_RUN_DRAIN_TIME_MULTIPLIER2 or
						TUNING.WEREGOOSE_RUN_DRAIN_TIME_MULTIPLIER1)
			end
		end
		return -100 / t
	end

	local function OnRead_moon(inst, reader)
		local x, y, z = reader.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 16, nil, { "player", "playerghost", "INLIMBO", "dead" },
			{ "halloweenmoonmutable", "werebeast" })
		local woodies = TheSim:FindEntities(x, y, z, 16, { "wereness" }, { "playerghost", "INLIMBO", "dead" })
		local found = false

		for k, v in ipairs(ents) do
			x, y, z = v.Transform:GetWorldPosition()

			if v.components.halloweenmoonmutable ~= nil then
				v.components.halloweenmoonmutable:Mutate()
				local fx = SpawnPrefab("halloween_moonpuff")
				fx.Transform:SetPosition(x, y, z)
			end --should this be an elseif?

			if v.components.werebeast ~= nil then
				v.components.werebeast:SetWere(1)
				local fx = SpawnPrefab("halloween_moonpuff")
				fx.Transform:SetPosition(x, y, z)
			end

			found = true
		end

		for k, v in ipairs(woodies) do
			x, y, z = v.Transform:GetWorldPosition()

			if not v.fullmoontriggered then
				v.fullmoontriggered = true
				local pct = v.components.wereness:GetPercent()
				if pct > 0 then
					v.components.wereness:SetPercent(1)
					local fx = SpawnPrefab("halloween_moonpuff")
					fx.Transform:SetPosition(x, y, z)
				else
					v.components.wereeater:ForceTransformToWere()
					v.components.wereness:SetPercent(1, true)
					local fx = SpawnPrefab("halloween_moonpuff")
					fx.Transform:SetPosition(x, y, z)
				end
				found = true
			end
		end

		if found then
			return true
		end
	end

	local function OnPerUse_moon(inst, reader)
		--if reader.peruse_moon then
		--    reader.peruse_moon(reader)
		--end
		--reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_MOON"))
		return true
	end

	env.AddPrefabPostInit("book_moon", function(inst)
		if not TheWorld.ismastersim then
			return
		end

		if inst.components.book ~= nil then
			inst.components.book:SetOnRead(OnRead_moon)
			inst.components.book:SetOnPeruse(OnPerUse_moon)
		end
	end)
end
local function OnRead_bees(inst, reader)
	local x, y, z = reader.Transform:GetWorldPosition()
	local beeboxes = TheSim:FindEntities(x, y, z, 16, { "beebox" }, { "burnt", "INLIMBO" })
	local found = false

	for k, v in ipairs(beeboxes) do
		if k > 10 then
			break
		end

		local x, y, z = v.Transform:GetWorldPosition()
		for i = 0, v.components.harvestable.maxproduce - v.components.harvestable.produce do
			v.components.harvestable:Grow()
			local fx = SpawnPrefab("fx_book_bees")
			fx.Transform:SetPosition(x, y, z)
			found = true
		end
	end

	if found then
		return true
	end
end

if TUNING.DSTU.WICKERNERF_BEEBOOK then
	env.AddPrefabPostInit("book_bees", function(inst)
		if not TheWorld.ismastersim then
			return
		end

		if inst.components.book ~= nil then
			inst.components.book:SetOnRead(OnRead_bees)
		end
	end)
end

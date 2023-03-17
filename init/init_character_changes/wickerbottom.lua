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
	env.AddComponentPostInit("werebeast", function(self)
		if self.inst ~= nil then
			self.inst:AddTag("werebeast")
		end
	end)

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

			if v.components.werebeast ~= nil and not v.components.werebeast:IsInWereState() then
				v.components.werebeast:SetWere(1)
				local fx = SpawnPrefab("halloween_moonpuff")
				fx.Transform:SetPosition(x, y, z)
			end

			found = true
		end

		for k, v in ipairs(woodies) do
			x, y, z = v.Transform:GetWorldPosition()

			local pct = v.components.wereness:GetPercent()
			if pct > 0 then
				v.components.wereness:SetPercent(1)
				local fx = SpawnPrefab("halloween_moonpuff")
				fx.Transform:SetPosition(x, y, z)
			else
				v.components.wereness:SetPercent(1, true)
				v.components.wereeater:ForceTransformToWere()
				local fx = SpawnPrefab("halloween_moonpuff")
				fx.Transform:SetPosition(x, y, z)
			end
			found = true
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

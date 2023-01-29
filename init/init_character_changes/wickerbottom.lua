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

if TUNING.DSTU.WICKERNERF_HORTICULTURE then
	Recipe("book_horticulture", {Ingredient("papyrus", 2), Ingredient("plantmeat", 1), Ingredient("poop", 5)}, CUSTOM_RECIPETABS.BOOKS, TECH.SCIENCE_ONE, nil, nil, nil, nil, "bookbuilder")
end
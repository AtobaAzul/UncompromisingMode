-- Wicker Books

TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
AllRecipes = GLOBAL.AllRecipes
STRINGS = GLOBAL.STRINGS
TECH = GLOBAL.TECH
CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

-----------------------------------------------------------------
-- Leafy meat and bucket cost for applied horticulture
-----------------------------------------------------------------
if GetModConfigData("harder_recipes") then
	-- Also use fertilizer instead of poop
	Recipe("book_gardening", {Ingredient("papyrus", 2), Ingredient("plantmeat", 1), Ingredient("fertilizer", 1)}, CUSTOM_RECIPETABS.BOOKS, TECH.SCIENCE_ONE, nil, nil, nil, nil, "bookbuilder")
else
	-- Use poop as normal
	Recipe("book_gardening", {Ingredient("papyrus", 2), Ingredient("plantmeat", 1), Ingredient("poop", 1)}, CUSTOM_RECIPETABS.BOOKS, TECH.SCIENCE_ONE, nil, nil, nil, nil, "bookbuilder")
end

-----------------------------------------------------------------
-- Nerf on tentacles to spawn 50% a small tentacle
-----------------------------------------------------------------
AddPrefabPostInit("tentacle", function(inst)
	local function retargetfn(inst)
		return GLOBAL.FindEntity(
			inst,
			GLOBAL.TUNING.TENTACLE_ATTACK_DIST,
			function(guy) 
				return guy.prefab ~= inst.prefab
					and guy.entity:IsVisible()
					and guy.prefab ~= "tentacle__pillar_arm"
					and not guy.components.health:IsDead()
					and (guy.components.combat.target == inst or
						guy:HasTag("character") or
						guy:HasTag("monster") or
						guy:HasTag("animal"))
			end,
			{ "_combat", "_health" },
			{ "prey" })
	end
	
	if inst ~= nil and inst.components.combat ~= nil then 
		inst.components.combat:SetRetargetFunction(GLOBAL.GetRandomWithVariance(2, 0.5), retargetfn)
	end
end)

AddPrefabPostInit("tentacle_pillar_arm", function(inst)
	local function retargetfn(inst)
		return GLOBAL.FindEntity(inst,
				GLOBAL.TUNING.TENTACLE_PILLAR_ARM_ATTACK_DIST,
				function(guy)
					return guy.prefab ~= "tentacle"
						and not guy.components.health:IsDead()
				end,
				{ "_combat", "_health" },
				{ "tentacle_pillar_arm", "tentacle_pillar", "prey", "INLIMBO" },
				{ "character", "monster", "animal" }
			)
	end
	
	if inst ~= nil and inst.components.combat ~= nil then 
		inst.components.combat:SetRetargetFunction(GLOBAL.GetRandomWithVariance(1, .5), retargetfn)
	end
end)

AddPrefabPostInit("book_tentacles", function(inst)
	local function TentacleSpawn(inst, reader)
		local pt = reader:GetPosition()
		local numtentacles = 3

		if inst ~= nil and inst.components.sanity ~= nil then 
			reader.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
		end

		reader:StartThread(function()
			for k = 1, numtentacles do
				local theta = math.random() * 2 * GLOBAL.PI
				local radius = math.random(3, 8)

				local result_offset = GLOBAL.FindValidPositionByFan(theta, radius, 12, function(offset)
				local pos = pt + offset
                return #GLOBAL.TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
					and GLOBAL.TheWorld.Map:IsPassableAtPoint(pos:Get())
					and GLOBAL.TheWorld.Map:IsDeployPointClear(pos, nil, 1)
				end)

				if result_offset ~= nil then
					local x, z = pt.x + result_offset.x, pt.z + result_offset.z
					local tentacle = math.random(100) <= 50 and GLOBAL.SpawnPrefab("tentacle") or GLOBAL.SpawnPrefab("tentacle_pillar_arm")
					tentacle.Transform:SetPosition(x, 0, z)
					
					if not tentacle:HasTag("tentacle_pillar_arm") then
						tentacle.sg:GoToState("attack_pre")
					else
						tentacle.sg:GoToState("emerge")
					end
					
                    GLOBAL.SpawnPrefab("splash_ocean").Transform:SetPosition(x, 0, z)
                    GLOBAL.ShakeAllCameras(GLOBAL.CAMERASHAKE.FULL, .2, .02, .25, reader, 40)
				end
				GLOBAL.Sleep(.33)
			end
        end)
        return true
    end

	if inst ~= nil and inst.components.book ~= nil then 
		inst.components.book.onread = TentacleSpawn
	end
end)
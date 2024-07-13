local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--[[Documentation: Atobá Azul

Makes mushtrees drop spores if they're not blooming. 
Checks season instead of actually blooming because thats easier.
Keeps old copy of loot for mod compat, does not use SetLoot because that clears chanceloot, randomloot and numrandomloot. For some reason.
Uses lootsetupfn to dynamically give it loot based on the season, instead of changing it onseasontick.
]]

if TUNING.DSTU.MUSHROOM_CHANGES then
	local tree_data =
	{
		small =
		{ --Green
			season = SEASONS.SPRING,
			spore = "spore_small",
			loot = { "log" },
		},
		medium =
		{ --Red
			season = SEASONS.SUMMER,
			spore = "spore_medium",
			loot = { "log" },
		},
		tall =
		{ --Blue
			season = SEASONS.WINTER,
			spore = "spore_tall",
			loot = { "log", "log", },
		},
	}

	for tree, data in pairs(tree_data) do
		env.AddPrefabPostInit("mushtree_" .. tree, function(inst)
			if not TheWorld.ismastersim then
				return
			end

			local old_loot = deepcopy(inst.components.lootdropper.loot)

			inst.components.lootdropper.lootsetupfn = function(lootdropper)
				if data.season ~= TheWorld.state.season then
					lootdropper.loot = { data.spore, unpack(data.loot), }
				else
					lootdropper.loot = old_loot
				end
			end
		end)
	end
end
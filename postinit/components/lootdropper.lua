local env = env
--local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("lootdropper", function(self)
	local _DropLoot = self.DropLoot
	local _GenerateLoot = self.GenerateLoot

	--[[if TUNING.DSTU.WARLY_BUTCHER then
		function self:GenerateLoot()
			if self.inst:HasTag("butchermark") then
				local loots = {}
				local previous_prefab = nil

				if self.lootsetupfn then
					self.lootsetupfn(self)
				end

				local function butcherloot(prefab)
					if self.inst:HasTag("butchermark") --and not
						--(self.inst:HasTag("epic") or
							--self.inst:HasTag("veggie") or
							--self.inst:HasTag("structure") or
							--self.inst:HasTag("wall") or
							--self.inst:HasTag("balloon") or
							--self.inst:HasTag("soulless") or
							--self.inst:HasTag("chess") or
							--self.inst:HasTag("shadow") or
							--self.inst:HasTag("shadowcreature") or
							--self.inst:HasTag("shadowminion") or
							--self.inst:HasTag("shadowchesspiece") or
							--self.inst:HasTag("groundspike") or
							--self.inst:HasTag("smashable"))
						--and math.random() <= .25 
						and (previous_prefab == nil or previous_prefab ~= prefab) then
						table.insert(loots, prefab)
					end
					previous_prefab = prefab
				end

				if self.numrandomloot and math.random() <= (self.chancerandomloot or 1) then
					for k = 1, self.numrandomloot do
						local loot = self:PickRandomLoot()
						if loot then
							table.insert(loots, loot)
							butcherloot(loot)
						end
					end
				end

				if self.chanceloot then
					for k, v in pairs(self.chanceloot) do
						if v.chance >= 1.0 then
							table.insert(loots, v.prefab)
							butcherloot(v.prefab)
						elseif math.random() < v.chance then
							table.insert(loots, v.prefab)
							butcherloot(v.prefab)
							self.droppingchanceloot = true
						end
					end
				end

				if self.chanceloottable then
					local loot_table = LootTables[self.chanceloottable]
					if loot_table then
						for i, entry in ipairs(loot_table) do
							local prefab = entry[1]
							local chance = entry[2]
							if chance >= 1.0 then
								table.insert(loots, prefab)
								butcherloot(prefab)
							elseif math.random() <= chance then
								table.insert(loots, prefab)
								butcherloot(prefab)
								self.droppingchanceloot = true
							end
						end
					end
				end

				if not self.droppingchanceloot and self.ifnotchanceloot then
					self.inst:PushEvent("ifnotchanceloot")
					for k, v in pairs(self.ifnotchanceloot) do
						table.insert(loots, v.prefab)
						butcherloot(v.prefab)
					end
				end

				if self.loot then
					for k, v in ipairs(self.loot) do
						table.insert(loots, v)
						butcherloot(v)
					end
				end

				local recipe = AllRecipes[self.inst.prefab]
				if recipe then
					local recipeloot = self:GetRecipeLoot(recipe)
					for k, v in ipairs(recipeloot) do
						table.insert(loots, v)
					end
				end

				if self.inst:HasTag("burnt") and math.random() < .4 then
					table.insert(loots, "charcoal") -- Add charcoal to loot for burnt structures
				end

				return loots
			else
				return _GenerateLoot(self)
			end
		end
	end]]

	if TUNING.DSTU.FIRELOOT ~= nil and TUNING.DSTU.FIRELOOT > 1 then
		function self:DropLoot(pt, ...)
			local prefabs = self:GenerateLoot(self)
			local isstructure = self.inst:HasTag("structure")

			if self.inst.components.burnable ~= nil and
				self.inst.components.burnable:IsBurning() and
				(not isstructure and not self.inst:HasTag("tree"))
				and not self.inst:HasTag("hive")
				and not self.inst:HasTag("prey") then
				if self.inst:HasTag("burnt")
					or (self.inst.components.burnable ~= nil and
						self.inst.components.burnable:IsBurning() and
						(self.inst.components.fueled == nil or self.inst.components.burnable.ignorefuel)) then
					for k, v in pairs(prefabs) do
						if TUNING.BURNED_LOOT_OVERRIDES[v] ~= nil then
							prefabs[k] = TUNING.BURNED_LOOT_OVERRIDES[v]
						elseif PrefabExists(v .. "_cooked") then
							prefabs[k] = v .. "_cooked"
						elseif PrefabExists("cooked" .. v) then
							prefabs[k] = "cooked" .. v
						else
							self:SpawnLootPrefab("ash", pt)
						end
					end
				end
				for k, v in pairs(prefabs) do
					self:SpawnLootPrefab(v, pt)
					self:SpawnLootPrefab("fireloot", pt)
				end

				if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
					local prefabname = string.upper(self.inst.prefab)
					local num_decor_loot = self.GetWintersFeastOrnaments ~= nil and
						self.GetWintersFeastOrnaments(self.inst) or TUNING.WINTERS_FEAST_TREE_DECOR_LOOT[prefabname] or
						nil
					if num_decor_loot ~= nil then
						for i = 1, num_decor_loot.basic do
							self:SpawnLootPrefab(GetRandomBasicWinterOrnament(), pt)
						end
						if num_decor_loot.special ~= nil then
							self:SpawnLootPrefab(num_decor_loot.special, pt)
						end
					elseif not TUNING.WINTERS_FEAST_LOOT_EXCLUSION[prefabname] and (self.inst:HasTag("monster") or self.inst:HasTag("animal")) then
						local loot = math.random()
						if loot < 0.005 then
							self:SpawnLootPrefab(GetRandomBasicWinterOrnament(), pt)
						elseif loot < 0.20 then
							self:SpawnLootPrefab("winter_food" .. math.random(NUM_WINTERFOOD), pt)
						end
					end
				end

				TheWorld:PushEvent("entity_droploot", { inst = self.inst })
			else
				return _DropLoot(self, pt, ...)
			end
		end
	end
end)

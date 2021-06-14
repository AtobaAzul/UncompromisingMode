local env = env
--local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("lootdropper", function(self)

	local _OldDropLoot = self.DropLoot
	local _GenerateLoot = self.GenerateLoot
	
	function self:DropLoot(pt)
	
				--local prefabs = _GenerateLoot(self)
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
						elseif PrefabExists(v.."_cooked") then
							prefabs[k] = v.."_cooked"
						elseif PrefabExists("cooked"..v) then
							prefabs[k] = "cooked"..v
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
					local num_decor_loot = self.GetWintersFeastOrnaments ~= nil and self.GetWintersFeastOrnaments(self.inst) or TUNING.WINTERS_FEAST_TREE_DECOR_LOOT[prefabname] or nil
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
							self:SpawnLootPrefab("winter_food"..math.random(NUM_WINTERFOOD), pt)
						end
					end
				end

				TheWorld:PushEvent("entity_droploot", { inst = self.inst }) 
		else
			return _OldDropLoot(self, pt)
		end
	end
end)
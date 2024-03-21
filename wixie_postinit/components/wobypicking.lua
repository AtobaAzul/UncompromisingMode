local env = env
GLOBAL.setfenv(1, GLOBAL)

-- THESE CHANGES AND POSTINITS ALLOW WOBY TO TRANSFER ITEMS TO HER "CONTAINER" SINCE INVENTORY IS NOT HANDLED
-- IF I >ADD< THE INVENTORY COMPONENT IT CAUSES PROBLEMS, IF YOU EAT SOMETHING IN HER CONTAINER FOR EXAMPLE
-- IT WILL CRASH THE GAME. SO I HAD TO REROUTE THE PICKABLE COMPONENT AND
-- THE PICKUP ACTION TO INCLUDE CONTAINER TARGETS

-- Later I duped the container components GiveItem function because I needed to push a custom event in case
-- the item fails to get added to wobys inventory

env.AddComponentPostInit("container", function(self)
	function self:GiveWobyItem(item, slot, src_pos, drop_on_fail)
		if item == nil then
			return false
		elseif item.components.inventoryitem ~= nil and self:CanTakeItemInSlot(item, slot) then
			if slot == nil then
				slot = self:GetSpecificSlotForItem(item)
			end

			--try to burn off stacks if we're just dumping it in there
			if item.components.stackable ~= nil and self.acceptsstacks then
				--Added this for when we want to dump a stack back into a
				--specific spot (e.g. moving half a stack failed, so we
				--need to dump the leftovers back into the original stack)
				if slot ~= nil and slot <= self.numslots then
					local other_item = self.slots[slot]
					if other_item ~= nil and other_item.prefab == item.prefab and other_item.skinname == item.skinname and not other_item.components.stackable:IsFull() then
						if self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner ~= nil then
							self.inst.components.inventoryitem.owner:PushEvent("gotnewitem", { item = item, slot = slot })
						end

						item = other_item.components.stackable:Put(item, src_pos)
						if item == nil then
							return true
						end

						slot = self:GetSpecificSlotForItem(item)
					end
				end

				if slot == nil then
					for k = 1, self.numslots do
						local other_item = self.slots[k]
						if other_item and other_item.prefab == item.prefab and other_item.skinname == item.skinname and not other_item.components.stackable:IsFull() then
							if self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner ~= nil then
								self.inst.components.inventoryitem.owner:PushEvent("gotnewitem", { item = item, slot = k })
							end

							item = other_item.components.stackable:Put(item, src_pos)
							if item == nil then
								return true
							end
						end
					end
				end
			end

			local in_slot = nil
			if slot ~= nil and slot <= self.numslots and not self.slots[slot] then
				in_slot = slot
			elseif not self.usespecificslotsforitems and self.numslots > 0 then
				for i = 1, self.numslots do
					if not self.slots[i] then
						in_slot = i
						break
					end
				end
			end

			if in_slot then
				--weird case where we are trying to force a stack into a non-stacking container. this should probably have been handled earlier, but this is a failsafe
				if not self.acceptsstacks and item.components.stackable and item.components.stackable:StackSize() > 1 then
					item = item.components.stackable:Get()
					self.slots[in_slot] = item
					item.components.inventoryitem:OnPutInInventory(self.inst)
					self.inst:PushEvent("itemget", { slot = in_slot, item = item, src_pos = src_pos, })
					return false
				end

				self.slots[in_slot] = item
				item.components.inventoryitem:OnPutInInventory(self.inst)
				self.inst:PushEvent("itemget", { slot = in_slot, item = item, src_pos = src_pos })

				if not self.ignoresound and self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner ~= nil then
					self.inst.components.inventoryitem.owner:PushEvent("gotnewitem", { item = item, slot = in_slot })
				end

				return true
			end
		end

		--default to true if nil
		if drop_on_fail ~= false then
			--@V2C NOTE: not supported when using container_proxy
			item.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			if item.components.inventoryitem ~= nil then
				item.components.inventoryitem:OnDropped(true)
			end
			
			self.inst:PushEvent("woby_dropped_item", { dropped_item = item })
		end
		return false
	end
end)

env.AddComponentPostInit("pickable", function(self)
	local _OldPick = self.Pick
	
	local function OnRegen(inst)
		inst.components.pickable:Regen()
	end

	function self:Pick(picker)
		if picker ~= nil and picker.components.container ~= nil and picker:HasTag("customwobytag") then
			if self.canbepicked and self.caninteractwith then
			
				local loot = nil
				if picker ~= nil and picker.components.container ~= nil and (self.product ~= nil or self.use_lootdropper_for_product ~= nil) then
					if self.droppicked and self.inst.components.lootdropper ~= nil then
						local pt = self.inst:GetPosition()
						pt.y = pt.y + (self.dropheight or 0)
						if self.use_lootdropper_for_product then
							self.inst.components.lootdropper:DropLoot(pt)
						else
							local num = self.numtoharvest or 1
							for i = 1, num do
								self.inst.components.lootdropper:SpawnLootPrefab(self.product, pt)
							end
						end
					else
						if self.use_lootdropper_for_product then
							loot = {}
							for _, prefab in ipairs(self.inst.components.lootdropper:GenerateLoot()) do
								table.insert(loot, self.inst.components.lootdropper:SpawnLootPrefab(prefab))
							end
							if not IsTableEmpty(loot) then
								picker:PushEvent("picksomething", { object = self.inst, loot = loot })
							end
							for i, item in ipairs(loot) do
								if item.components.inventoryitem ~= nil then
									picker.components.container:GiveWobyItem(item, nil, self.inst:GetPosition())
								end
							end
						else
							loot = SpawnPrefab(self.product)
							if loot ~= nil then
								if loot.components.inventoryitem ~= nil then
									loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
								end
								if self.numtoharvest > 1 and loot.components.stackable ~= nil then
									loot.components.stackable:SetStackSize(self.numtoharvest)
								end
								picker:PushEvent("picksomething", { object = self.inst, loot = loot })
								picker.components.container:GiveWobyItem(loot, nil, self.inst:GetPosition())
							end
						end
					end
				end

				if self.onpickedfn ~= nil then
					self.onpickedfn(self.inst, picker, loot)
				end

				self.canbepicked = false

				if self.baseregentime ~= nil and not (self.paused or self:IsBarren() or self.inst:HasTag("withered")) then
					if TheWorld.state.isspring then
						self.regentime = self.baseregentime * TUNING.SPRING_GROWTH_MODIFIER
					end

					if not self.useexternaltimer then
						if self.task ~= nil then
							self.task:Cancel()
						end
						self.task = self.inst:DoTaskInTime(self.regentime, OnRegen)
						self.targettime = GetTime() + self.regentime
					else
						self.stopregentimer(self.inst)
						self.startregentimer(self.inst, self.regentime)
					end
				end

				self.inst:PushEvent("picked", { picker = picker, loot = loot, plant = self.inst })

				if self.remove_when_picked then
					self.inst:Remove()
				end
				
				--return _OldPick(self, picker)
			end
		else
			return _OldPick(self, picker)
		end
	end
end)

local _PickupFn = ACTIONS.PICKUP.fn

ACTIONS.PICKUP.fn = function(act)
    if act.doer.components.container ~= nil and
        act.target ~= nil and
        act.target.components.inventoryitem ~= nil and
        (act.target.components.inventoryitem.canbepickedup or
        (act.target.components.inventoryitem.canbepickedupalive and not act.doer:HasTag("player"))) and
        not (act.target:IsInLimbo() or
            (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning()) or
            (act.target.components.projectile ~= nil and act.target.components.projectile:IsThrown())) then
			
		if act.doer.components.itemtyperestrictions ~= nil and not act.doer.components.itemtyperestrictions:IsAllowed(act.target) then
            return false, "restriction"
        elseif act.target.components.container ~= nil and act.target.components.container:IsOpenedByOthers(act.doer) then
            return false, "INUSE"
        elseif (act.target.components.yotc_racecompetitor ~= nil and act.target.components.entitytracker ~= nil) then
            local trainer = act.target.components.entitytracker:GetEntity("yotc_trainer")
            if trainer ~= nil and trainer ~= act.doer then
                return false, "NOTMINE_YOTC"
            end
		elseif act.doer.components.inventory ~= nil and act.doer.components.inventory.noheavylifting and act.target:HasTag("heavy") then
			return false, "NO_HEAVY_LIFTING"
        end

        if (act.target:HasTag("spider") and act.doer:HasTag("spiderwhisperer")) and 
           (act.target.components.follower.leader ~= nil and act.target.components.follower.leader ~= act.doer) then
            return false, "NOTMINE_SPIDER"
        end

        act.doer.components.container:GiveWobyItem(act.target, nil, act.target:GetPosition())
        return true
	else
		return _PickupFn(act)
	end
end
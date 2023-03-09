local env = env
GLOBAL.setfenv(1, GLOBAL)

-- THESE CHANGES AND POSTINITS ALLOW WOBY TO TRANSFER ITEMS TO HER "CONTAINER" SINCE INVENTORY IS NOT HANDLED
-- IF I >ADD< THE INVENTORY COMPONENT IT CAUSES PROBLEMS, IF YOU EAT SOMETHING IN HER CONTAINER FOR EXAMPLE
-- IT WILL CRASH THE GAME. SO I HAD TO REROUTE THE PICKABLE COMPONENT AND
-- THE PICKUP ACTION TO INCLUDE CONTAINER TARGETS

env.AddComponentPostInit("pickable", function(self)
	local _OldPick = self.Pick
	
	function self:Pick(picker)
		if picker ~= nil and picker.components.container ~= nil then
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
									picker.components.container:GiveItem(item, nil, self.inst:GetPosition())
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
								picker.components.container:GiveItem(loot, nil, self.inst:GetPosition())
							end
						end
					end
				end
				
				return _OldPick(self, picker)
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

        act.doer.components.container:GiveItem(act.target, nil, act.target:GetPosition())
        return true
	else
		return _PickupFn(act)
	end
end
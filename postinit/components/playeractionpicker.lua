local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("playeractionpicker", function(self)

    local _OldGetRightClickActions = self.GetRightClickActions
	
	function self:GetRightClickActions(position, target, spellbook)
		if self.inst.replica.inventory and (self.inst.replica.inventory:EquipHasTag("um_wingsuit") or self.inst:HasTag("allow_action_on_impassable")) then
			if self.disable_right_click then
				return {}
			end

			if self.rightclickoverride ~= nil then
				local actions, usedefault = self.rightclickoverride(self.inst, target, position)
				if not usedefault or (actions ~= nil and #actions > 0) then
					return actions or {}
				end
			end

			local steering_actions = self:GetSteeringActions(self.inst, position, true)
			if steering_actions ~= nil then
				--self.disable_right_click = true
				return steering_actions
			end

			local cannon_aim_actions = self:GetCannonAimActions(self.inst, position, true)
			if cannon_aim_actions ~= nil then
				return cannon_aim_actions
			end

			local actions = nil
			local useitem = self.inst.replica.inventory:GetActiveItem()
			local equipitem = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

			if target ~= nil and self.containers[target] then
				--check if we have container widget actions
				actions = self:GetSceneActions(target, true)
			elseif useitem ~= nil then
				--if we're specifically using an item, see if we can use it on the target entity
				if useitem:IsValid() then
					if target == self.inst then
						actions = self:GetInventoryActions(useitem, true)
					elseif target ~= nil and ((not target:HasTag("walkableplatform") and not target:HasTag("ignoremouseover")) or (useitem:HasTag("repairer") and not useitem:HasTag("deployable"))) then
						actions = self:GetUseItemActions(target, useitem, true)
						if #actions == 0 and target:HasTag("walkableperipheral") then
							actions = self:GetPointActions(position, useitem, true, target)
						end
					else
						actions = self:GetPointActions(position, useitem, true, target)
					end
				end
			elseif target ~= nil and not target:HasTag("walkableplatform") then
				--if we're clicking on a scene entity, see if we can use our equipped object on it, or just use it
				if equipitem ~= nil and equipitem:IsValid() then
					actions = self:GetEquippedItemActions(target, equipitem, true)

					--strip out all other actions for weapons with right click special attacks
					if equipitem.components.aoetargeting ~= nil then
						return (#actions <= 0 or actions[1].action == ACTIONS.CASTAOE) and actions or {}
					end
				end

				if actions == nil or #actions == 0 then
					actions = self:GetSceneActions(target, true)
					if (#actions == 0 or (#actions == 1 and actions[1].action == ACTIONS.LOOKAT)) and target:HasTag("walkableperipheral") then
						if equipitem ~= nil and equipitem:IsValid() then
							local alwayspassable, allowwater--, deployradius
							local aoetargeting = equipitem.components.aoetargeting
							if aoetargeting ~= nil and aoetargeting:IsEnabled() then
								alwayspassable = aoetargeting.alwaysvalid
								allowwater = aoetargeting.allowwater
								--deployradius = aoetargeting.deployradius
							end
							alwayspassable = alwayspassable or equipitem:HasTag("allow_action_on_impassable")
							--V2C: just do passable check here, componentactions tends to redo the full check
							--if self.map:CanCastAtPoint(position, alwayspassable, allowwater, deployradius) then
							if alwayspassable or self.map:IsPassableAtPoint(position.x, 0, position.z, allowwater) then
								actions = self:GetPointActions(position, equipitem, true, target)
							end
						end
					end
				end
			else
				local item = spellbook or equipitem
				if item ~= nil and item:IsValid() then
					local alwayspassable, allowwater--, deployradius
					local aoetargeting = item.components.aoetargeting
					if aoetargeting ~= nil and aoetargeting:IsEnabled() then
						alwayspassable = item.components.aoetargeting.alwaysvalid
						allowwater = item.components.aoetargeting.allowwater
						--deployradius = item.components.aoetargeting.deployradius
					end
					alwayspassable = alwayspassable or item:HasTag("allow_action_on_impassable")
					--V2C: just do passable check here, componentactions tends to redo the full check
					--if self.map:CanCastAtPoint(position, alwayspassable, allowwater, deployradius) then
					if alwayspassable or self.map:IsPassableAtPoint(position.x, 0, position.z, allowwater) then
						actions = self:GetPointActions(position, item, true, target)
					end
				end
			end

			local rider = self.inst.replica.rider
	
			if (actions == nil or #actions <= 0) and (target == nil or target:HasTag("walkableplatform") or target:HasTag("walkableperipheral")) and 
			useitem == nil and not TheWorld.Map:IsGroundTargetBlocked(position) and 
			(rider == nil or not rider:IsRiding()) then
				
				actions = self:GetPointSpecialActions(position, useitem, true)
			end

			return actions or {}
		else
			return _OldGetRightClickActions(self, position, target, spellbook)
		end
	end
end)

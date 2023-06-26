local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function KrampusStealing(self)
	local SEE_DIST = 30
	local TOOCLOSE = 6

    self.greed = 4

	local function CanSteal(item)
		return item.components.inventoryitem ~= nil
			and item.components.inventoryitem.canbepickedup
			and item:IsOnValidGround()      -- NOTE: If Krampus learns to hop on boats or travel over water, this should change to include water.
			and not item:IsNearPlayer(TOOCLOSE)
			and not self.inst:IsNearPlayer(TOOCLOSE)
	end

	local STEAL_MUST_TAGS = { "_inventoryitem" }
	local STEAL_CANT_TAGS = { "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container" }

	local function ItemsToSteal(inst)
		if not inst.components.inventory:IsFull() then
			local target = FindEntity(inst, SEE_DIST,
				CanSteal,
				STEAL_MUST_TAGS, --see entityreplica.lua
				STEAL_CANT_TAGS)
			return target ~= nil
		end
		
		return false
	end

	local function StealAction(inst)
		if not inst.components.inventory:IsFull() then
			local target_priority = FindEntity(inst, SEE_DIST,
				CanSteal,
				{ "_inventoryitem", "_equippable" },
				STEAL_CANT_TAGS)
				
			local target = FindEntity(inst, SEE_DIST,
				CanSteal,
				STEAL_MUST_TAGS, --see entityreplica.lua
				STEAL_CANT_TAGS)

			return target_priority ~= nil
				and BufferedAction(inst, target_priority, ACTIONS.PICKUP) or
				target ~= nil
				and BufferedAction(inst, target, ACTIONS.PICKUP)
				or nil
		end
	end

	local leave_2 = IfNode( function() return self.inst.components.inventory:NumItems() >= self.greed and not self.inst.sg:HasStateTag("busy") end, "ForceLeave",
            ActionNode(function() self.inst.sg:GoToState("exit") return SUCCESS end, "leave" ))

    local steal_2 = WhileNode(function() return self.inst.components.combat.target ~= nil and self.inst.components.inventory:NumItems() < self.greed and ItemsToSteal(self.inst) end, "StealNotFight",
						PriorityNode({
							MinPeriod(self.inst, 5, true,
									DoAction(self.inst, function() return StealAction(self.inst) end, "steal", true )
								)
						}, 2)
					)
	
	--if TUNING.DSTU.NAUGHT_KRAMPII then
        table.insert(self.bt.root.children, 2, leave_2)
        table.insert(self.bt.root.children, 3, steal_2)
    --end
	
end

env.AddBrainPostInit("krampusbrain", KrampusStealing)
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
if TUNING.DSTU.MUSHROOM_CHANGES then

	local UpvalueHacker = require("tools/upvaluehacker")
	
	env.AddPrefabPostInit("mushroom_farm", function(inst)
		if not TheNet:GetIsServer() then
			return
		end

		local _AcceptTest = inst.components.trader.abletoaccepttest
		local _OnAcceptItem = inst.components.trader.onaccept
		local max_harvests = TUNING.MUSHROOMFARM_MAX_HARVESTS -- 4

		-- 8 compost nutrients = 1 refuel
		inst.refuel_items = {
			["compost"] = 2,			
			["glommerfuel"] = 2,
			["compostwrap"] = max_harvests,
			["treegrowthsolution"] = max_harvests,
			["livinglog"] = max_harvests,
		}

		-- Allows Mushroom Planters to accept more types of fuel, and
		-- can be refueled when not at 0 uses (but not at max uses)
		local function AcceptTest(inst, item, giver)
			if inst.remainingharvests < max_harvests and inst.refuel_items[item.prefab] then
				return true
			end
			return _AcceptTest(inst, item, giver)
		end

		local FULLY_REPAIRED_WORKLEFT = UpvalueHacker.GetUpvalue(Prefabs.mushroom_farm.fn, "FULLY_REPAIRED_WORKLEFT")
		local updatelevel = UpvalueHacker.GetUpvalue(Prefabs.mushroom_farm.fn, "updatelevel")
		-- Adds harvest value based on inst.refuel_items
		local function OnAcceptItem(inst, giver, item)
			if inst.refuel_items[item.prefab] then
				inst.remainingharvests = math.min(inst.remainingharvests + inst.refuel_items[item.prefab], max_harvests)
				inst.components.workable:SetWorkLeft(FULLY_REPAIRED_WORKLEFT)
				updatelevel(inst)
			else
				return _OnAcceptItem(inst, giver, item)
			end
		end

		inst.components.trader:SetAbleToAcceptTest(AcceptTest)
		inst.components.trader.onaccept = OnAcceptItem
	end)
end
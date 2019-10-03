-- Counter based-check for warly's hunger memory (so that last X recipes will be remembered, regardless of time)
-- Relevant: warly.lua, eater.lua, foodmemory.lua
--[[    From warly.lua:
        inst:AddComponent("foodmemory")
        inst.components.foodmemory:SetDuration(TUNING.WARLY_SAME_OLD_COOLDOWN)
        inst.components.foodmemory:SetMultipliers(TUNING.WARLY_SAME_OLD_MULTIPLIERS)
]]--

AddComponentPostInit("foodmemory", function(self)
   --
end)
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddBrainPostInit("pigbrain", function(inst)
	local FINDFOOD_CANT_TAGS = { "outofreach", "insect" }
end)
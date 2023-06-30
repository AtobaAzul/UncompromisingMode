local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local panzies = {
	"spiderbrain",
	"pigbrain",
	"rabbitbrain",
	"frogbrain",




}

local RUN_AWAY_PARAMS =
{
    tags = { "_combat", "_health","reallyfrickinscary"},
    notags = { "EPIC" },
}
local function Attacking(inst)
	return inst.sg:HasStateTag("attack")
end

local function Taunting(inst)
	return inst.sg:HasStateTag("taunting")
end

local function BecomeTerrified(self)
	require "behaviours/runaway"
    local runaway = WhileNode(function() return not Attacking(self.inst) and not Taunting(self.inst) end, "AmIBusyAttacking", RunAway(self.inst, RUN_AWAY_PARAMS, 8, 12))
    table.insert(self.bt.root.children, 1, runaway)
end

for i,v in ipairs(panzies) do
	env.AddBrainPostInit(v, BecomeTerrified)
end
GLOBAL.setfenv(1, GLOBAL)
--------------------------------------------------------------
local UpvalueHacker = require("tools/upvaluehacker")
local ShadowWaxwellBrain = require("brains/shadowwaxwellbrain")

local DIG_TAGS = {"snowpile_basic", "snowpile"}
local TOWORK_CANT_TAGS = {"sludgestack"}

local _DIG_TAGS = UpvalueHacker.GetUpvalue(ShadowWaxwellBrain.OnStart, "DIG_TAGS")

for i,TAG in pairs(DIG_TAGS) do
    table.insert(_DIG_TAGS, TAG)
end

local _TOWORK_CANT_TAGS = UpvalueHacker.GetUpvalue(ShadowWaxwellBrain.OnStart, "FindEntityToWorkAction", "TOWORK_CANT_TAGS")

for i,TAG in pairs(TOWORK_CANT_TAGS) do
    table.insert(_TOWORK_CANT_TAGS, TAG)
end
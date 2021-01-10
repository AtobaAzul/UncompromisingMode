local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("walrus_camp", function (inst)
local _OnIsWinter = UpvalueHacker.GetUpvalue(Prefabs.walrus_camp.fn, "OnIsWinter")
    if not TheWorld.ismastersim then
		return
	end
	
	local _onsave = inst.OnSave
	local _onload = inst.OnLoad
	
local function OnIsWinter(inst)
if inst.chosen ~= nil and inst.chosen == true then
_OnIsWinter(inst)
else
inst.chosen = false
end
end
UpvalueHacker.SetUpvalue(Prefabs.walrus_camp.fn, OnIsWinter,"OnIsWinter")

local _onsleep = inst.OnEntitySleep

local function OnEntitySleep(inst)
if inst.chosen ~= nil and inst.chosen == true then
_onsleep(inst)
end
end
inst.OnEntitySleep = OnEntitySleep
local function onsave(inst,data)
if inst.chosen ~= nil then
data.chosen = inst.chosen
end
_onsave(inst,data)
end
local function onsave(inst,data)
if data.chosen ~= nil then
inst.chosen = data.chosen
end
_onsave(inst,data)
end
end)

local require = GLOBAL.require


local SignGenerator = GLOBAL.require "signgenerator"
local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
local writeables = GLOBAL.require("writeables")

local kinds = UpvalueHacker.GetUpvalue(writeables.makescreen, "kinds")

if kinds == nil then
    return
end

local function itemtestfn(container, item, slot)
    return item.prefab == "log" or item.prefab == "boards"
end

local containers = GLOBAL.require("containers")

containers.params.dl_recorder = GLOBAL.deepcopy(containers.params.shadowchester)
containers.params.dl_recorder.itemtestfn = itemtestfn

kinds["dl_recorder"] = {
    prompt = GLOBAL.STRINGS.SIGNS.MENU.PROMPT,
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = GLOBAL.Vector3(6, -70, 0),

    cancelbtn = { text = GLOBAL.STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = GLOBAL.CONTROL_CANCEL },
    middlebtn = {
        text = GLOBAL.STRINGS.SIGNS.MENU.RANDOM,
        cb = function(inst, doer, widget)
            widget:OverrideText(SignGenerator(inst, doer))
        end,
        control = GLOBAL.CONTROL_MENU_MISC_2
    },
    acceptbtn = { text = GLOBAL.STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = GLOBAL.CONTROL_ACCEPT },

    --defaulttext = SignGenerator,
}

kinds["dl_spawner"] = kinds["dl_recorder"]

require "map/terrain"

local _SetTile = GLOBAL.Map.SetTile
function GLOBAL.Map:SetTile(x, y, tile, data, ...)
    local original_tile = GLOBAL.TheWorld.Map:GetTile(x, y)
    if data ~= nil and type(data) == "table" and data.reversible then
        table.insert(GLOBAL.TheWorld.components.dynamic_layouts.layouts[data.group].tiles, { x = x, y = y, original_tile = original_tile })
    end

    _SetTile(self, x, y, tile, data, ...)
end

AddPrefabPostInit("world", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    inst:AddComponent("dynamic_layouts")
end)

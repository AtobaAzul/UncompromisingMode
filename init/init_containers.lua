local Vector3 = GLOBAL.Vector3
local require = GLOBAL.require
local ACTIONS = GLOBAL.ACTIONS
local Inv = require "widgets/inventorybar"
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local SpawnPrefab = GLOBAL.SpawnPrefab

local containers = require("containers")
--[[
AddComponentPostInit("container", function(self)
	function self:RemoveSingleItemBySlot(slot)
		if slot and self.slots[slot] then
			local item = self.slots[slot]
			return self:RemoveItem(item)
		end
	end
end)
]]
function CheckMush(container, item, slot)
    return item:HasTag("mushroom_fuel")
end

function CheckWardrobeItem(container, item, slot)
    return item:HasTag("_equippable") or item:HasTag("reloaditem_ammo") or item:HasTag("tool") or item:HasTag("weapon")
        or (item.prefab == "razor" or item.prefab == "beef_bell") or item:HasTag("heatrock") or
        (item:HasTag("pocketwatch") or item.prefab == "pocketwatch_dismantler") or
        item.prefab == "sewing_tape" or item.prefab == "sewing_kit" or item:HasTag("fan") or
        string.match(item.prefab, "wx78module_") ~= nil or item:HasTag("mine") or item:HasTag("trap")
end

function CheckToolboxItem(container, item, slot)
    return item:HasTag("toolbox_item") or item:HasTag("gem") or item:HasTag("tool") or item.prefab == "nitre" or item.prefab == "sewing_tape"
end

function CheckEquipItem(container, item, slot)
    return item:HasTag("_equippable")
end

function CheckBee(container, item, slot)
    return item:HasTag("bee")
end

function CheckGem(container, item, slot)
    return not item:HasTag("irreplaceable") and item:HasTag("gem")
end

function CheckFish(container, item, slot)
    return item:HasTag("smalloceancreature")
end

function CheckDart(container, item, slot)
    return item:HasTag("um_dart")
end

function CheckFeather(container, item, slot)
    return item:HasTag("wingsuit_feather")
end

function CheckNOTHING(container, item, slot)
    return false
end

local modparams = {}

modparams.air_conditioner =
{
    widget =
    {
        slotpos =
        {
            Vector3(-37.5, 32 + 4, 0),
            Vector3(37.5, 32 + 4, 0),
            Vector3(-37.5, -(32 + 4), 0),
            Vector3(37.5, -(32 + 4), 0),
        },
        slotbg =
        {
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
        },
        animbank = "ui_chest_2x2",
        animbuild = "ui_chest_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
    },
    itemtestfn = CheckMush,
    acceptsstacks = false,
    type = "cooker",
}

modparams.itemscrapper =
{
    widget =
    {
        slotpos =
        {
            Vector3(-37.5, 32 + 4, 0),
            Vector3(37.5, 32 + 4, 0),
            Vector3(-37.5, -(32 + 4), 0),
            Vector3(37.5, -(32 + 4), 0),
        },
        slotbg =
        {
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
            { image = "mushroom_slot.tex", atlas = "images/mushroom_slot.xml" },
        },
        animbank = "ui_chest_2x2",
        animbuild = "ui_chest_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
    },
    itemtestfn = CheckEquipItem,
    acceptsstacks = false,
    type = "cooker",
}

modparams.puffvest =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_lamp_1x4",
        animbuild = "ui_lamp_1x4",
        pos = Vector3(-70, -70, 0),
    },
    issidewidget = true,
    type = "pack",
}
modparams.reflvest =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_lamp_1x4",
        animbuild = "ui_lamp_1x4",
        pos = Vector3(-70, -70, 0),
    },
    issidewidget = true,
    type = "pack",
}

modparams.puffvest_big =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_icepack_2x3",
        animbuild = "ui_icepack_2x3",
        pos = Vector3(-5, -70, 0),
    },
    issidewidget = true,
    type = "pack",
}

for y = 0, 2 do
    table.insert(modparams.puffvest_big.widget.slotpos, Vector3(-162, -75 * y + 75, 0))
    table.insert(modparams.puffvest_big.widget.slotpos, Vector3(-162 + 75, -75 * y + 75, 0))
end

modparams.crabclaw =
{
    widget =
    {
        slotpos =
        {
            --Vector3(0,   32 + 4,  0),
        },
        --[[slotbg =
        {
            { image = "slingshot_ammo_slot.tex" },
        },]]
        slotbg =
        {
            { image = "gem_slot.tex", atlas = "images/gem_slot.xml" },
            { image = "gem_slot.tex", atlas = "images/gem_slot.xml" },
            { image = "gem_slot.tex", atlas = "images/gem_slot.xml" },
            { image = "gem_slot.tex", atlas = "images/gem_slot.xml" },
        },
        animbank = "ui_lamp_1x4",
        animbuild = "ui_lamp_1x4",
        pos = Vector3(0, 125, 0),
    },
    itemtestfn = CheckGem,
    acceptsstacks = false,
    type = "hand_inv",
}

modparams.um_blowgun =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 32 + 4, 0),
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 15, 0),
    },
    itemtestfn = CheckDart,
    acceptsstacks = true,
    type = "hand_inv",
}

modparams.um_beegun =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 32 + 4, 0),
        },
        slotbg =
        {
            { image = "bee_slot.tex", atlas = "images/bee_slot.xml" },
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 15, 0),
    },
    itemtestfn = CheckBee,
    usespecificslotsforitems = true,
    acceptsstacks = true,
    type = "hand_inv",
}

modparams.frigginbirdpail =
{
    widget =
    {
        slotpos =
        {
            --Vector3(0,   32 + 4,  0),
        },
        slotbg =
        {
            { image = "fish_slot.tex", atlas = "images/fish_slot.xml" },
            { image = "fish_slot.tex", atlas = "images/fish_slot.xml" },
            { image = "fish_slot.tex", atlas = "images/fish_slot.xml" },
            { image = "fish_slot.tex", atlas = "images/fish_slot.xml" },
        },
        animbank = "ui_lamp_1x4",
        animbuild = "ui_lamp_1x4",
        pos = Vector3(0, 125, 0),
    },
    itemtestfn = CheckFish,
    --acceptsstacks = true,
    type = "hand_inv",
}

modparams.wingsuit =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 32 + 4, 0),
        },
        slotbg =
        {
            { image = "feather_slot.tex", atlas = "images/feather_slot.xml" },
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(53, 15, 0),
    },
    itemtestfn = CheckFeather,
    usespecificslotsforitems = true,
    type = "hand_inv",
}

modparams.corvushat =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 32 + 4, 0),
        },
        slotbg =
        {
            { image = "feather_slot.tex", atlas = "images/feather_slot.xml" },
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(106, 15, 0),
    },
    acceptsstacks = false,
    itemtestfn = CheckFeather,
    usespecificslotsforitems = true,
    type = "hand_inv",
}

modparams.winkyburrow_child =
{
    widget =
    {
        slotpos = {},
        slotbg = {},
    },
    itemtestfn = CheckNOTHING,
    type = "special for shared inventory",
}

modparams.skullchest_child =
{
    widget =
    {
        slotpos = {},
        slotbg = {},
    },
    itemtestfn = CheckNOTHING,
    type = "special for shared inventory",
}

for y = 0, 3 do
    table.insert(modparams.puffvest.widget.slotpos, Vector3(-1, -75 * y + 110, 0))
end
for y = 0, 3 do
    table.insert(modparams.reflvest.widget.slotpos, Vector3(-1, -75 * y + 110, 0))
end
for y = 0, 3 do
    table.insert(modparams.crabclaw.widget.slotpos, Vector3(-1, -75 * y + 110, 0))
end
for y = 0, 3 do
    table.insert(modparams.frigginbirdpail.widget.slotpos, Vector3(-1, -75 * y + 110, 0))
end

local function NoIreplaceables(container, item, slot)
    return not item:HasTag("irreplaceable")
end

modparams.skullchest = GLOBAL.deepcopy(containers.params.shadowchester)
modparams.skullchest.itemtestfn = NoIreplaceables
modparams.uncompromising_winkyburrow_master = GLOBAL.deepcopy(containers.params.shadowchester)
modparams.uncompromising_winkyburrow_master.itemtestfn = NoIreplaceables
modparams.um_devcapture = GLOBAL.deepcopy(containers.params.shadowchester)
modparams.um_devcapture.itemtestfn = NoIreplaceables
modparams.um_sacred_chest = GLOBAL.deepcopy(containers.params.sacred_chest)
modparams.um_sacred_chest.itemtestfn = NoIreplaceables

modparams.sludge_sack = containers.params.piggyback

local old_wsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data, ...)
    local t = modparams[ prefab or container.inst.prefab --[[ or inst.widgetsetup]] ]
    if t ~= nil then
        --if modparams[prefab or container.inst.prefab] and not data then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        --data = modparams[prefab or container.inst.prefab]
        --return old_wsetup(container, prefab, data, ...)
    else
        return old_wsetup(container, prefab, data, ...)
        --containers_widgetsetup_base(container, prefab, data, ...)
    end
end

if containers.MAXITEMSLOTS == nil or containers.MAXITEMSLOTS < 25 then
    containers.MAXITEMSLOTS = 25
end

if GetModConfigData("scaledchestbuff") then
    containers.params.dragonflychest =
    {
        widget =
        {
            slotpos = {},
            animbank = nil,
            animbuild = nil,
            bgatlas = "images/dragonflycontainerborder.xml",
            bgimage = "dragonflycontainerborder.tex",
            bgimagetint = { r = .82, g = .77, b = .7, a = 1 },
            pos = Vector3(0, 220, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }

    for y = 2.5, -1.5, -1 do
        for x = 0, 4 do
            table.insert(containers.params.dragonflychest.widget.slotpos, Vector3(80 * x - 80 * 2, 80 * y - 80 * 2 + 120
            , 0))
        end
    end
end

if GetModConfigData("nofishyincrockpot") then
    local _itemtestfn = containers.params.cookpot.itemtestfn
    containers.params.cookpot.itemtestfn = function(container, item, slot)
        return _itemtestfn(container, item, slot) and item ~= nil and not item:HasTag("oceanfish")
    end
end

containers.params.wardrobe =
{
    widget =
    {
        slotpos = {},
        animbank = nil,
        animbuild = nil,
        bgatlas = "images/dragonflycontainerborder.xml",
        bgimage = "dragonflycontainerborder.tex",
        bgimagetint = { r = .82, g = .77, b = .7, a = 1 },
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
        slotbg =
        {
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
            { image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
            { image = "wardrobe_tool_slot.tex",  atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_hat_slot.tex",   atlas = "images/wardrobe_hat_slot.xml" },
        },
    },
    type = "chest",
    itemtestfn = CheckWardrobeItem,
    right = true,
}

for y = 2.5, -1.5, -1 do
    for x = 0, 4 do
        table.insert(containers.params.wardrobe.widget.slotpos, Vector3(80 * x - 80 * 2, 80 * y - 80 * 2 + 120, 0))
    end
end

containers.params.winona_toolbox =
{
    widget =
    {
        slotpos = {},
        slotbg =
        {
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
            { image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
        },
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
    itemtestfn = GetModConfigData("winona_portables_") and CheckToolboxItem or CheckWardrobeItem,
}

containers.params.winona_toolbox.widget.slotpos = containers.params.shadowchester.widget.slotpos

modparams.sunkenchest_royal_random = containers.params.shadowchester
modparams.sunkenchest_royal_red = containers.params.shadowchester
modparams.sunkenchest_royal_blue = containers.params.shadowchester
modparams.sunkenchest_royal_purple = containers.params.shadowchester
modparams.sunkenchest_royal_green = containers.params.shadowchester
modparams.sunkenchest_royal_orange = containers.params.shadowchester
modparams.sunkenchest_royal_yellow = containers.params.shadowchester
modparams.sunkenchest_royal_rainbow = containers.params.shadowchester

for k, v in pairs(modparams) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local function addItemSlotNetvarsInContainer(inst)
    if (#inst._itemspool < containers.MAXITEMSLOTS) then
        for i = #inst._itemspool + 1, containers.MAXITEMSLOTS do
            table.insert(inst._itemspool,
                net_entity(inst.GUID, "container._items[" .. tostring(i) .. "]", "items[" .. tostring(i) .. "]dirty"))
        end
    end
end

AddPrefabPostInit("container_classified", addItemSlotNetvarsInContainer)

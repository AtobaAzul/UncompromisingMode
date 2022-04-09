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
function CheckItem(container, item, slot)
    return item:HasTag("mushroom_fuel")
end

function CheckEquipItem(container, item, slot)
    return item:HasTag("_equippable")
end

function CheckHandItem(container, item, slot)
    if item and item.components.equippable ~= nil then
        return item.components.equippable.equipslot == EQUIPSLOTS.HANDS
    end
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
	itemtestfn = CheckItem,
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
            Vector3(0,   32 + 4,  0),
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 15, 0),
    },
	itemtestfn = CheckDart,
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
            Vector3(0,   32 + 4,  0),
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
            Vector3(0,   32 + 4,  0),
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

for k, v in pairs(modparams) do
	containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

modparams.skullchest = containers.params.shadowchester
modparams.winkyburrow = containers.params.shadowchester

local old_wsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data, ...)
    local t = modparams[prefab or container.inst.prefab--[[ or inst.widgetsetup]]]
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
local function addItemSlotNetvarsInContainer(inst)
     if(#inst._itemspool < containers.MAXITEMSLOTS) then
        for i = #inst._itemspool+1, containers.MAXITEMSLOTS do
            table.insert(inst._itemspool, net_entity(inst.GUID, "container._items["..tostring(i).."]", "items["..tostring(i).."]dirty"))
        end
     end
  end
AddPrefabPostInit("container_classified", addItemSlotNetvarsInContainer)

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
		bgimagetint = {r=.82,g=.77,b=.7,a=1},
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2.5, -1.5, -1 do
	for x = 0, 4 do
		table.insert(containers.params.dragonflychest.widget.slotpos, Vector3(80*x-80*2, 80*y-80*2+120,0))
  	end
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
		bgimagetint = {r=.82,g=.77,b=.7,a=1},
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
        slotbg =
        {
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },	
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },
			{ image = "wardrobe_chest_slot.tex", atlas = "images/wardrobe_chest_slot.xml" },
			{ image = "wardrobe_tool_slot.tex", atlas = "images/wardrobe_tool_slot.xml" },
			{ image = "wardrobe_hat_slot.tex", atlas = "images/wardrobe_hat_slot.xml" },			
        },		
    },
    type = "chest",
	itemtestfn = CheckEquipItem,
	right = true,
}

for y = 2.5, -1.5, -1 do
	for x = 0, 4 do
		table.insert(containers.params.wardrobe.widget.slotpos, Vector3(80*x-80*2, 80*y-80*2+120,0))
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
        },
        animbank = "ui_tacklecontainer_3x2",
        animbuild = "ui_tacklecontainer_3x2",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
    itemtestfn = CheckHandItem,
}

for y = 1, 0, -1 do
    for x = 0, 2 do
        table.insert(containers.params.winona_toolbox.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 120, 0))
    end
end
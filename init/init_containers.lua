local Vector3 = GLOBAL.Vector3
local require = GLOBAL.require
local ACTIONS = GLOBAL.ACTIONS
local Inv = require "widgets/inventorybar"
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local modparams = {}
local SpawnPrefab = GLOBAL.SpawnPrefab

AddComponentPostInit("container", function(self)
	function self:RemoveSingleItemBySlot(slot)
		if slot and self.slots[slot] then
			local item = self.slots[slot]
			return self:RemoveItem(item)
		end
	end
end)

function CheckItem(container, item, slot)
    return item:HasTag("mushroom_fuel")
end

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
        animbank = "ui_chest_2x2",
        animbuild = "ui_chest_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
    },
	itemtestfn = CheckItem,
    acceptsstacks = false,
    type = "cooker",
}

local containers = require("containers")

for k, v in pairs(modparams) do
	containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local old_wsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
	if modparams[prefab or container.inst.prefab] and not data then
		data = modparams[prefab or container.inst.prefab]
	end
	old_wsetup(container, prefab, data)
end
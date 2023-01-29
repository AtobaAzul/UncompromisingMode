local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function CanSteal(item)
    return item.components.inventoryitem ~= nil
        and item.components.inventoryitem.canbepickedup
        and item:IsOnValidGround()      
end

local PLAY_TAGS = {"cattoy", "cattoyairborne", "catfood"}
local STEAL_MUST_TAGS = { "_inventoryitem", }
local STEAL_CANT_TAGS = { "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach", "_container","FX", "NOCLICK", "DECOR","INLIMBO", "stump", "burnt", "notarget" }

local function PlayAction_Inventory(inst)
    if inst.sg:HasStateTag("busy") then return end
    local target = nil
    local target = FindEntity(inst, TUNING.CATCOON_TARGET_DIST,
        CanSteal,
        STEAL_MUST_TAGS, --see entityreplica.lua
        STEAL_CANT_TAGS,
		PLAY_TAGS)
    return target ~= nil
        and BufferedAction(inst, target, ACTIONS.PICKUP)
    or nil
end

env.AddBrainPostInit("catcoonbrain", function(self)
    table.insert(self.bt.root.children, 7, DoAction(self.inst, PlayAction_Inventory, "steal", true))
end)